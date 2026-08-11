/*
 * Example: why PT_SIGEXC must not be set before an exception port exists
 *
 * exec() under PT_TRACE_ME raises SIGTRAP to stop the tracee at its entry
 * point - the initial stop every debugger waits for. PT_SIGEXC asks the kernel
 * to deliver this process's BSD signals as Mach exceptions instead. Set
 * PT_SIGEXC before anyone has called task_set_exception_ports and that SIGTRAP
 * becomes an exception with nowhere to go, and the kernel kills the child.
 *
 * The fix is a handshake: the child does PT_TRACE_ME and then blocks. The
 * parent takes the task port, registers an exception port, and only then
 * releases the child, which sets PT_SIGEXC and execs.
 *
 * Run it both ways to see the difference:
 *
 *   ./exception_handshake racy      /bin/echo hi   -> child killed by SIGTRAP
 *   ./exception_handshake handshake /bin/echo hi   -> exception delivered to us
 *
 * Two further points this demonstrates:
 *   - exception ports registered on the pre-exec task ARE inherited across the
 *     exec, which is what makes the handshake work at all;
 *   - the task port itself is NOT - the target has different entitlements, so
 *     exec invalidates it and task_for_pid has to be called again.
 *
 * PT_SIGEXC cannot be applied by the tracer after the fact: macOS rejects
 * ptrace(PT_SIGEXC, child_pid, ...) with EINVAL, it is only valid on self.
 *
 * Build, from this repo:
 *   dune build @build-c
 * or from a workspace that vendors mach (where @build-c is not reachable):
 *   dune build lib/mach/examples/exception_handshake
 *
 * Run (requires debugger entitlements and developer mode). Note codesign has
 * to write to the binary, so copy it out of the read-only build tree first:
 *   sudo DevToolsSecurity -enable
 *   cp _build/default/lib/mach/examples/exception_handshake /tmp/exh
 *   codesign -s - -f --entitlements debugger-entitlements.plist /tmp/exh
 *   /tmp/exh racy      ./some_target
 *   /tmp/exh handshake ./some_target
 *
 * The target must itself be codesigned with get-task-allow.
 */

#include <errno.h>
#include <mach/mach.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef PT_SIGEXC
#define PT_SIGEXC 12
#endif

/* Exception types a debugger claims. Note masks are (1 << exception_type) and
 * types start at 1, so bit 0 is never valid - a mask containing it makes
 * task_set_exception_ports fail with KERN_INVALID_ARGUMENT. */
static const exception_mask_t debugger_mask =
    EXC_MASK_BAD_ACCESS | EXC_MASK_BAD_INSTRUCTION | EXC_MASK_ARITHMETIC |
    EXC_MASK_EMULATION | EXC_MASK_SOFTWARE | EXC_MASK_BREAKPOINT;

static void describe_child(pid_t pid, int status) {
    if (WIFSTOPPED(status))
        printf("  child: stopped by signal %d\n", WSTOPSIG(status));
    else if (WIFSIGNALED(status))
        printf("  child: KILLED by signal %d\n", WTERMSIG(status));
    else if (WIFEXITED(status))
        printf("  child: exited %d\n", WEXITSTATUS(status));
    else
        printf("  child: status 0x%x\n", status);
    (void)pid;
}

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "usage: %s racy|handshake <program> [args...]\n",
                argv[0]);
        return 2;
    }
    int handshake = (strcmp(argv[1], "handshake") == 0);
    char **target = &argv[2];

    int go[2];
    if (pipe(go) != 0) { perror("pipe"); return 1; }

    pid_t pid = fork();
    if (pid == 0) {
        close(go[1]);
        if (ptrace(PT_TRACE_ME, 0, 0, 0) < 0) {
            fprintf(stderr, "PT_TRACE_ME: %s\n", strerror(errno));
            _exit(1);
        }
        if (handshake) {
            /* Wait until the parent has an exception port installed. */
            char b;
            (void)read(go[0], &b, 1);
        }
        close(go[0]);
        if (ptrace(PT_SIGEXC, 0, 0, 0) < 0) {
            fprintf(stderr, "PT_SIGEXC: %s\n", strerror(errno));
            _exit(1);
        }
        execv(target[0], target);
        fprintf(stderr, "execv(%s): %s\n", target[0], strerror(errno));
        _exit(1);
    }
    close(go[0]);

    printf("mode: %s\n", handshake ? "handshake" : "racy");

    mach_port_t exc_port = MACH_PORT_NULL;
    if (handshake) {
        mach_port_t task;
        kern_return_t kr = task_for_pid(mach_task_self(), pid, &task);
        printf("  task_for_pid (pre-exec): %s\n",
               kr == KERN_SUCCESS ? "ok" : mach_error_string(kr));
        if (kr != KERN_SUCCESS) goto reap;

        kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE,
                                &exc_port);
        if (kr == KERN_SUCCESS)
            kr = mach_port_insert_right(mach_task_self(), exc_port, exc_port,
                                        MACH_MSG_TYPE_MAKE_SEND);
        if (kr != KERN_SUCCESS) {
            printf("  exception port: %s\n", mach_error_string(kr));
            goto reap;
        }

        kr = task_set_exception_ports(task, debugger_mask, exc_port,
                                      EXCEPTION_DEFAULT | MACH_EXCEPTION_CODES,
                                      THREAD_STATE_NONE);
        printf("  set_exception_ports: %s\n",
               kr == KERN_SUCCESS ? "ok" : mach_error_string(kr));
        if (kr != KERN_SUCCESS) goto reap;

        /* Release the child: it may now set PT_SIGEXC and exec. */
        (void)write(go[1], "g", 1);
    }
    close(go[1]);

    if (handshake) {
        union { mach_msg_header_t hdr; char buf[1024]; } msg;
        memset(&msg, 0, sizeof msg);
        kern_return_t kr =
            mach_msg(&msg.hdr, MACH_RCV_MSG | MACH_RCV_TIMEOUT, 0, sizeof msg,
                     exc_port, 3000, MACH_PORT_NULL);
        printf("  exec trap arrived as a Mach exception: %s\n",
               kr == KERN_SUCCESS ? "YES"
               : kr == MACH_RCV_TIMED_OUT ? "no (timed out)"
                                          : mach_error_string(kr));

        /* The pre-exec task port is stale now; a fresh one still works. */
        mach_port_t task2;
        kr = task_for_pid(mach_task_self(), pid, &task2);
        printf("  task_for_pid (post-exec): %s\n",
               kr == KERN_SUCCESS ? "ok" : mach_error_string(kr));
        printf("  child alive: %s\n", kill(pid, 0) == 0 ? "yes" : "no");
    } else {
        int status = 0;
        waitpid(pid, &status, WUNTRACED);
        describe_child(pid, status);
    }

reap:
    kill(pid, SIGKILL);
    (void)waitpid(pid, NULL, 0);
    return 0;
}
