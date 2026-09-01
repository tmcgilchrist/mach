/*
 * simple_attach.c - Demonstrates basic process attachment on macOS
 *
 * This example shows the two-step process required to attach to a running
 * process on macOS, contrasting with Linux's single PTRACE_ATTACH call.
 *
 * Steps:
 *   1. task_for_pid() - Get a Mach task port for the target process
 *   2. task_suspend() - Suspend all threads in the task
 *
 * Build:
 *   make simple_attach
 *
 * Run (requires debugger entitlements):
 *   codesign -s - --entitlements debugger.entitlements --force simple_attach
 *   ./simple_attach <pid>
 *
 * Or run as root:
 *   sudo ./simple_attach <pid>
 */

#include <mach/mach.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <libproc.h>

void print_kern_error(const char *msg, kern_return_t kr) {
    fprintf(stderr, "Error: %s: ", msg);
    switch (kr) {
        case KERN_SUCCESS:
            fprintf(stderr, "KERN_SUCCESS\n");
            break;
        case KERN_FAILURE:
            fprintf(stderr, "KERN_FAILURE (likely permission denied)\n");
            break;
        case KERN_INVALID_ARGUMENT:
            fprintf(stderr, "KERN_INVALID_ARGUMENT\n");
            break;
        default:
            fprintf(stderr, "kern_return_t = %d\n", kr);
            break;
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <pid>\n", argv[0]);
        fprintf(stderr, "\nThis program demonstrates attaching to a process "
                        "on macOS.\n");
        fprintf(stderr, "Requires debugger entitlements or root privileges.\n");
        return 1;
    }

    pid_t target_pid = atoi(argv[1]);
    if (target_pid <= 0) {
        fprintf(stderr, "Error: Invalid PID\n");
        return 1;
    }

    /* Get process name for display */
    char path[PROC_PIDPATHINFO_MAXSIZE];
    if (proc_pidpath(target_pid, path, sizeof(path)) > 0) {
        printf("Target process: %s (PID %d)\n", path, target_pid);
    } else {
        printf("Target PID: %d\n", target_pid);
    }

    /*
     * Step 1: Get task port
     *
     * On Linux, you would use: ptrace(PTRACE_ATTACH, pid, 0, 0);
     *
     * On macOS, task_for_pid() returns a Mach port (a capability) that
     * represents the target process (called a "task" in Mach terminology).
     */
    printf("\n[1] Calling task_for_pid()...\n");
    mach_port_t task;
    kern_return_t kr = task_for_pid(mach_task_self(), target_pid, &task);

    if (kr != KERN_SUCCESS) {
        print_kern_error("task_for_pid() failed", kr);
        fprintf(stderr, "\nCommon causes:\n");
        fprintf(stderr, "  - Not running as root\n");
        fprintf(stderr, "  - Missing debugger entitlements\n");
        fprintf(stderr, "  - Target process is restricted (SIP protected)\n");
        fprintf(stderr, "\nTo fix:\n");
        fprintf(stderr, "  1. Run as root: sudo %s %d\n", argv[0], target_pid);
        fprintf(stderr, "  2. Or add entitlements:\n");
        fprintf(stderr, "     codesign -s - --entitlements "
                        "debugger.entitlements --force %s\n", argv[0]);
        return 1;
    }

    printf("    ✓ Got task port: 0x%x\n", task);

    /*
     * Step 2: Suspend the task
     *
     * Unlike Linux's PTRACE_ATTACH which stops the process automatically,
     * task_for_pid() does NOT suspend the target. You must explicitly
     * call task_suspend().
     *
     * task_suspend() suspends ALL threads in the task. The suspend count
     * is reference counted - you need one task_resume() for each
     * task_suspend().
     */
    printf("\n[2] Calling task_suspend()...\n");
    kr = task_suspend(task);

    if (kr != KERN_SUCCESS) {
        print_kern_error("task_suspend() failed", kr);
        mach_port_deallocate(mach_task_self(), task);
        return 1;
    }

    printf("    ✓ Task suspended\n");

    /* Verify the suspend count */
    struct task_basic_info info;
    mach_msg_type_number_t count = TASK_BASIC_INFO_COUNT;
    kr = task_info(task, TASK_BASIC_INFO, (task_info_t)&info, &count);

    if (kr == KERN_SUCCESS) {
        printf("    Task suspend count: %d\n", info.suspend_count);
    }

    /* Get thread list to show what we can do now */
    thread_act_array_t thread_list;
    mach_msg_type_number_t thread_count;
    kr = task_threads(task, &thread_list, &thread_count);

    if (kr == KERN_SUCCESS) {
        printf("    Target has %d thread(s)\n", thread_count);

        /* Clean up thread ports */
        for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
            mach_port_deallocate(mach_task_self(), thread_list[i]);
        }
        vm_deallocate(mach_task_self(), (vm_address_t)thread_list,
                      thread_count * sizeof(thread_act_t));
    }

    /*
     * At this point, the target process is stopped and we have control.
     * You could now:
     *   - Read/write memory with mach_vm_read/mach_vm_write
     *   - Read/write registers with thread_get_state/thread_set_state
     *   - Set breakpoints
     *   - Set exception ports
     */

    printf("\n✓ Successfully attached to process!\n");
    printf("\nPress Enter to detach and resume the process...");
    getchar();

    /*
     * Step 3: Resume the task
     *
     * On Linux: ptrace(PTRACE_DETACH, pid, 0, 0);
     *
     * On macOS: task_resume() decrements the suspend count. Because we
     * called task_suspend() once, we call task_resume() once to resume.
     */
    printf("\n[3] Calling task_resume()...\n");
    kr = task_resume(task);

    if (kr != KERN_SUCCESS) {
        print_kern_error("task_resume() failed", kr);
    } else {
        printf("    ✓ Task resumed\n");
    }

    /* Clean up the task port */
    mach_port_deallocate(mach_task_self(), task);

    printf("\n✓ Detached from process\n");
    return 0;
}
