/*
 * register_access.c - Demonstrates register read/write on macOS
 *
 * This example shows how to read and write CPU registers using
 * thread_get_state() and thread_set_state(). These operations are
 * per-thread on macOS, unlike Linux's process-level ptrace operations.
 *
 * Linux equivalent:
 *   - PTRACE_GETREGS / PTRACE_GETREGSET - read registers
 *   - PTRACE_SETREGS / PTRACE_SETREGSET - write registers
 *
 * macOS:
 *   - thread_get_state() - read thread's register state
 *   - thread_set_state() - write thread's register state
 *   - Uses architecture-specific "flavors" (x86_THREAD_STATE64, ARM_THREAD_STATE64)
 *
 * Build:
 *   make register_access
 *
 * Run (requires debugger entitlements):
 *   codesign -s - --entitlements debugger.entitlements --force register_access
 *   ./register_access <pid>
 */

#include <mach/mach.h>
#include <stdio.h>
#include <stdlib.h>

#if defined(__x86_64__)
void print_x86_64_registers(x86_thread_state64_t *state) {
    printf("  General Purpose Registers:\n");
    printf("    rax: 0x%016llx    rbx: 0x%016llx\n",
           state->__rax, state->__rbx);
    printf("    rcx: 0x%016llx    rdx: 0x%016llx\n",
           state->__rcx, state->__rdx);
    printf("    rsi: 0x%016llx    rdi: 0x%016llx\n",
           state->__rsi, state->__rdi);
    printf("    rbp: 0x%016llx    rsp: 0x%016llx\n",
           state->__rbp, state->__rsp);
    printf("    r8:  0x%016llx    r9:  0x%016llx\n",
           state->__r8, state->__r9);
    printf("    r10: 0x%016llx    r11: 0x%016llx\n",
           state->__r10, state->__r11);
    printf("    r12: 0x%016llx    r13: 0x%016llx\n",
           state->__r12, state->__r13);
    printf("    r14: 0x%016llx    r15: 0x%016llx\n",
           state->__r14, state->__r15);
    printf("\n  Control Registers:\n");
    printf("    rip: 0x%016llx (instruction pointer)\n", state->__rip);
    printf("    rflags: 0x%016llx\n", state->__rflags);
    printf("    cs:  0x%016llx    fs:  0x%016llx    gs:  0x%016llx\n",
           state->__cs, state->__fs, state->__gs);
}
#endif

#if defined(__arm64__) || defined(__aarch64__)
void print_arm64_registers(arm_thread_state64_t *state) {
    printf("  General Purpose Registers:\n");
    for (int i = 0; i < 29; i += 2) {
        printf("    x%-2d: 0x%016llx    x%-2d: 0x%016llx\n",
               i, state->__x[i], i+1, state->__x[i+1]);
    }
    printf("    fp:  0x%016llx (x29, frame pointer)\n", state->__fp);
    printf("    lr:  0x%016llx (x30, link register)\n", state->__lr);
    printf("    sp:  0x%016llx (stack pointer)\n", state->__sp);
    printf("    pc:  0x%016llx (program counter)\n", state->__pc);
    printf("    cpsr: 0x%08x (processor state)\n", state->__cpsr);
}
#endif

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <pid>\n", argv[0]);
        fprintf(stderr, "\nThis program reads and displays CPU registers "
                        "from all threads\n");
        fprintf(stderr, "in the target process.\n");
        return 1;
    }

    pid_t target_pid = atoi(argv[1]);
    printf("Target PID: %d\n", target_pid);

    /* Step 1: Get task port */
    printf("\n[1] Getting task port...\n");
    mach_port_t task;
    kern_return_t kr = task_for_pid(mach_task_self(), target_pid, &task);

    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error: task_for_pid() failed\n");
        return 1;
    }
    printf("    ✓ Got task port: 0x%x\n", task);

    /* Step 2: Suspend task */
    printf("\n[2] Suspending task...\n");
    kr = task_suspend(task);
    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error: task_suspend() failed\n");
        mach_port_deallocate(mach_task_self(), task);
        return 1;
    }
    printf("    ✓ Task suspended\n");

    /* Step 3: Get thread list */
    printf("\n[3] Getting thread list...\n");
    thread_act_array_t thread_list;
    mach_msg_type_number_t thread_count;

    kr = task_threads(task, &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error: task_threads() failed\n");
        task_resume(task);
        mach_port_deallocate(mach_task_self(), task);
        return 1;
    }

    printf("    ✓ Found %d thread(s)\n", thread_count);

    /*
     * Step 4: Read registers from each thread
     *
     * Key difference from Linux:
     *   - macOS operates on individual threads (thread ports)
     *   - Linux ptrace is process-level (but can target specific threads)
     *
     * The "flavor" parameter specifies which register set you want:
     *   - x86_THREAD_STATE64 (4) for x86_64
     *   - ARM_THREAD_STATE64 (6) for ARM64
     */
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        printf("\n[4.%d] Reading registers for thread %d (port 0x%x)...\n",
               i, i, thread_list[i]);

#if defined(__x86_64__)
        x86_thread_state64_t state;
        mach_msg_type_number_t state_count = x86_THREAD_STATE64_COUNT;

        /*
         * thread_get_state() parameters:
         *   - thread: The thread port (not task port!)
         *   - flavor: x86_THREAD_STATE64 (4) for 64-bit x86
         *   - state: Pointer to state structure to fill
         *   - state_count: Size of structure (input/output parameter)
         */
        kr = thread_get_state(thread_list[i], x86_THREAD_STATE64,
                              (thread_state_t)&state, &state_count);

        if (kr != KERN_SUCCESS) {
            fprintf(stderr, "  Error: thread_get_state() failed for thread %d\n", i);
            continue;
        }

        printf("  ✓ Read %d values from register state\n", state_count);
        print_x86_64_registers(&state);

        /* Demonstrate writing registers (modifying RAX as an example) */
        printf("\n  Modifying RAX register...\n");
        uint64_t old_rax = state.__rax;
        state.__rax = 0xDEADBEEFCAFEBABE;

        /*
         * thread_set_state() parameters:
         *   - thread: The thread port
         *   - flavor: x86_THREAD_STATE64
         *   - state: Pointer to state structure to write
         *   - state_count: Size of structure
         *
         * Must write the ENTIRE state structure, not individual registers.
         */
        kr = thread_set_state(thread_list[i], x86_THREAD_STATE64,
                              (thread_state_t)&state, state_count);

        if (kr != KERN_SUCCESS) {
            fprintf(stderr, "  Error: thread_set_state() failed\n");
        } else {
            printf("  ✓ Modified RAX: 0x%016llx -> 0x%016llx\n",
                   old_rax, state.__rax);

            /* Read back to verify */
            mach_msg_type_number_t verify_count = x86_THREAD_STATE64_COUNT;
            x86_thread_state64_t verify_state;
            kr = thread_get_state(thread_list[i], x86_THREAD_STATE64,
                                  (thread_state_t)&verify_state, &verify_count);

            if (kr == KERN_SUCCESS) {
                printf("  ✓ Verified RAX = 0x%016llx\n", verify_state.__rax);
            }

            /* Restore original value */
            state.__rax = old_rax;
            thread_set_state(thread_list[i], x86_THREAD_STATE64,
                           (thread_state_t)&state, state_count);
            printf("  ✓ Restored RAX to original value\n");
        }

#elif defined(__arm64__) || defined(__aarch64__)
        arm_thread_state64_t state;
        mach_msg_type_number_t state_count = ARM_THREAD_STATE64_COUNT;

        kr = thread_get_state(thread_list[i], ARM_THREAD_STATE64,
                              (thread_state_t)&state, &state_count);

        if (kr != KERN_SUCCESS) {
            fprintf(stderr, "  Error: thread_get_state() failed for thread %d\n", i);
            continue;
        }

        printf("  ✓ Read %d values from register state\n", state_count);
        print_arm64_registers(&state);

        /* Demonstrate writing registers (modifying X0 as an example) */
        printf("\n  Modifying X0 register...\n");
        uint64_t old_x0 = state.__x[0];
        state.__x[0] = 0xDEADBEEFCAFEBABE;

        kr = thread_set_state(thread_list[i], ARM_THREAD_STATE64,
                              (thread_state_t)&state, state_count);

        if (kr != KERN_SUCCESS) {
            fprintf(stderr, "  Error: thread_set_state() failed\n");
        } else {
            printf("  ✓ Modified X0: 0x%016llx -> 0x%016llx\n",
                   old_x0, state.__x[0]);

            /* Read back to verify */
            mach_msg_type_number_t verify_count = ARM_THREAD_STATE64_COUNT;
            arm_thread_state64_t verify_state;
            kr = thread_get_state(thread_list[i], ARM_THREAD_STATE64,
                                  (thread_state_t)&verify_state, &verify_count);

            if (kr == KERN_SUCCESS) {
                printf("  ✓ Verified X0 = 0x%016llx\n", verify_state.__x[0]);
            }

            /* Restore original value */
            state.__x[0] = old_x0;
            thread_set_state(thread_list[i], ARM_THREAD_STATE64,
                           (thread_state_t)&state, state_count);
            printf("  ✓ Restored X0 to original value\n");
        }
#else
        printf("  Architecture not supported for register display\n");
#endif
    }

    /* Cleanup */
    printf("\n[Cleanup]\n");
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        mach_port_deallocate(mach_task_self(), thread_list[i]);
    }
    vm_deallocate(mach_task_self(), (vm_address_t)thread_list,
                  thread_count * sizeof(thread_act_t));

    task_resume(task);
    mach_port_deallocate(mach_task_self(), task);

    printf("  ✓ Cleaned up and resumed task\n");

    printf("\n✓ Done!\n");
    printf("\nKey takeaways:\n");
    printf("  - macOS register operations are per-THREAD, not per-process\n");
    printf("  - Must use architecture-specific flavors (x86_THREAD_STATE64, etc)\n");
    printf("  - thread_set_state() writes the ENTIRE state structure atomically\n");
    printf("  - Linux uses PTRACE_GETREGS/SETREGS which are process-level\n");

    return 0;
}
