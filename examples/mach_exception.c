/*
 * Example: Mach Exception Handling with task_set_exception_ports
 *
 * This demonstrates how to:
 * - Create a Mach exception port
 * - Set up exception handling for a child process using task_set_exception_ports
 * - Use PT_TRACE_ME and PT_SIGEXC for debugging
 * - Interact with a child process via Mach task ports
 *
 * This mirrors what LLDB does in debugserver.
 *
 * Build:
 *   dune build @build-c
 *
 * Run (requires debugger entitlements):
 *   codesign -s - -f --entitlements debugserver-macos-entitlements.plist \
 *     _build/default/lib/mach/examples/mach_exception
 *   _build/default/lib/mach/examples/mach_exception
 */

#include <mach/mach.h>
#include <mach/mach_vm.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ptrace.h>

#define CHECK_KERN(kr, msg) \
    if (kr != KERN_SUCCESS) { \
        mach_error(msg, kr); \
        exit(1); \
    }

int main(int argc, char **argv) {
    kern_return_t kr;
    mach_port_t task_self = mach_task_self();
    mach_port_t exception_port;

    printf("Step 1: Allocate exception port with MACH_PORT_RIGHT_RECEIVE...\n");
    kr = mach_port_allocate(task_self, MACH_PORT_RIGHT_RECEIVE, &exception_port);
    CHECK_KERN(kr, "mach_port_allocate");
    printf("  ✓ Allocated exception port: 0x%x\n", exception_port);

    printf("\nStep 2: Insert send right with MACH_MSG_TYPE_MAKE_SEND...\n");
    kr = mach_port_insert_right(task_self, exception_port, exception_port,
                                 MACH_MSG_TYPE_MAKE_SEND);
    CHECK_KERN(kr, "mach_port_insert_right");
    printf("  ✓ Inserted send right\n");

    /* Now fork and create a child process to debug */
    printf("\nStep 3: Fork child process...\n");
    pid_t child_pid = fork();

    if (child_pid == 0) {
        /* Child process */
        printf("  [Child] Calling PT_TRACE_ME...\n");
        if (ptrace(PT_TRACE_ME, 0, 0, 0) < 0) {
            perror("PT_TRACE_ME");
            exit(1);
        }

        printf("  [Child] Calling PT_SIGEXC...\n");
        if (ptrace(PT_SIGEXC, 0, 0, 0) < 0) {
            perror("PT_SIGEXC");
            exit(1);
        }

        printf("  [Child] Waiting to be debugged...\n");
        pause(); /* Wait for signal from parent */
        exit(0);
    }

    /* Parent process */
    printf("  ✓ Forked child with PID: %d\n", child_pid);

    /* Small delay to let child exec */
    usleep(100000);

    printf("\nStep 4: Get task port for child PID %d...\n", child_pid);
    mach_port_t child_task;
    kr = task_for_pid(task_self, child_pid, &child_task);
    CHECK_KERN(kr, "task_for_pid");
    printf("  ✓ Got child task port: 0x%x\n", child_task);

    printf("\nStep 5: Set exception ports on child task...\n");
    exception_mask_t mask = EXC_MASK_ALL;
    exception_behavior_t behavior = EXCEPTION_DEFAULT | MACH_EXCEPTION_CODES;
    thread_state_flavor_t flavor = THREAD_STATE_NONE;

    printf("  Parameters:\n");
    printf("    mask: 0x%x (EXC_MASK_ALL)\n", mask);
    printf("    port: 0x%x\n", exception_port);
    printf("    behavior: 0x%x (EXCEPTION_DEFAULT | MACH_EXCEPTION_CODES)\n", behavior);
    printf("    flavor: 0x%x (THREAD_STATE_NONE)\n", flavor);

    kr = task_set_exception_ports(child_task, mask, exception_port,
                                   behavior, flavor);
    CHECK_KERN(kr, "task_set_exception_ports");
    printf("  ✓ Successfully set exception ports!\n");

    /* Clean up */
    printf("\nStep 6: Cleanup...\n");
    kill(child_pid, SIGKILL);
    wait(NULL);
    mach_port_deallocate(task_self, exception_port);

    printf("\n✓ All steps completed successfully!\n");
    printf("\nThis demonstrates that exception handling setup works correctly.\n");
    printf("The key is to call task_set_exception_ports AFTER:\n");
    printf("  1. Creating the exception port\n");
    printf("  2. Inserting the send right\n");
    printf("  3. Getting the child task port\n");
    printf("  4. Waiting for the child to be ready (after exec)\n");

    return 0;
}
