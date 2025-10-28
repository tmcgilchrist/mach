/*
 * memory_access.c - Demonstrates memory read/write on macOS
 *
 * This example shows how macOS's mach_vm_read() and mach_vm_write() can
 * read/write arbitrary amounts of memory in a single call, contrasting with
 * Linux's ptrace() which is limited to word-at-a-time access.
 *
 * Linux equivalent:
 *   - PTRACE_PEEKDATA - reads one word (8 bytes on 64-bit)
 *   - PTRACE_POKEDATA - writes one word
 *   - Requires a loop to read/write multiple words
 *
 * macOS advantage:
 *   - mach_vm_read() - reads arbitrary amount in one call
 *   - mach_vm_write() - writes arbitrary amount in one call
 *
 * Build:
 *   make memory_access
 *
 * Run (requires debugger entitlements):
 *   codesign -s - --entitlements debugger.entitlements --force memory_access
 *   ./memory_access <pid> <address> <size>
 */

#include <mach/mach.h>
#include <mach/mach_vm.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void print_hex_dump(const uint8_t *data, size_t size, uint64_t base_addr) {
    for (size_t i = 0; i < size; i += 16) {
        printf("  0x%016llx: ", base_addr + i);

        /* Hex bytes */
        for (size_t j = 0; j < 16; j++) {
            if (i + j < size) {
                printf("%02x ", data[i + j]);
            } else {
                printf("   ");
            }
            if (j == 7) printf(" ");
        }

        printf(" |");

        /* ASCII */
        for (size_t j = 0; j < 16 && i + j < size; j++) {
            char c = data[i + j];
            printf("%c", isprint(c) ? c : '.');
        }

        printf("|\n");
    }
}

int main(int argc, char **argv) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <pid> <address> <size>\n", argv[0]);
        fprintf(stderr, "\nExample:\n");
        fprintf(stderr, "  %s 1234 0x100000000 64\n", argv[0]);
        fprintf(stderr, "\nThis will read 64 bytes from address 0x100000000 "
                        "in process 1234\n");
        return 1;
    }

    pid_t target_pid = atoi(argv[1]);
    uint64_t address = strtoull(argv[2], NULL, 0);
    size_t size = strtoull(argv[3], NULL, 0);

    if (size > 1024 * 1024) {
        fprintf(stderr, "Error: Size too large (max 1MB)\n");
        return 1;
    }

    printf("Target PID: %d\n", target_pid);
    printf("Address:    0x%llx\n", address);
    printf("Size:       %zu bytes\n", size);

    /* Step 1: Get task port */
    printf("\n[1] Getting task port...\n");
    mach_port_t task;
    kern_return_t kr = task_for_pid(mach_task_self(), target_pid, &task);

    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error: task_for_pid() failed with code %d\n", kr);
        fprintf(stderr, "Try running as root or with debugger entitlements\n");
        return 1;
    }

    printf("    ✓ Got task port: 0x%x\n", task);

    /* Step 2: Suspend the task (optional, but safer) */
    printf("\n[2] Suspending task...\n");
    kr = task_suspend(task);
    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error: task_suspend() failed\n");
        mach_port_deallocate(mach_task_self(), task);
        return 1;
    }
    printf("    ✓ Task suspended\n");

    /*
     * Step 3: Read memory with mach_vm_read()
     *
     * Linux equivalent (word-at-a-time):
     *   for (i = 0; i < size; i += 8) {
     *       data = ptrace(PTRACE_PEEKDATA, pid, address + i, 0);
     *       // Copy data into buffer...
     *   }
     *
     * macOS: Single call for arbitrary size!
     */
    printf("\n[3] Reading memory with mach_vm_read()...\n");

    vm_offset_t read_data;
    mach_msg_type_number_t read_count;

    kr = mach_vm_read(task, address, size, &read_data, &read_count);

    if (kr != KERN_SUCCESS) {
        fprintf(stderr, "Error: mach_vm_read() failed with code %d\n", kr);
        fprintf(stderr, "The address may be invalid or not mapped\n");
        task_resume(task);
        mach_port_deallocate(mach_task_self(), task);
        return 1;
    }

    printf("    ✓ Read %u bytes\n", read_count);
    printf("\nMemory contents:\n");
    print_hex_dump((uint8_t *)read_data, read_count, address);

    /*
     * Important: mach_vm_read() allocates memory in your address space
     * using vm_allocate(). You MUST call vm_deallocate() to free it,
     * or you'll leak kernel memory!
     */
    vm_deallocate(mach_task_self(), read_data, read_count);

    /*
     * Step 4: Write memory with mach_vm_write()
     *
     * For demonstration, we'll write a pattern to memory (if user wants).
     */
    printf("\nDo you want to write to this memory? (y/N): ");
    char response[10];
    if (fgets(response, sizeof(response), stdin) &&
        (response[0] == 'y' || response[0] == 'Y')) {

        printf("\n[4] Writing memory with mach_vm_write()...\n");

        /* Create a test pattern */
        uint8_t *write_data = malloc(size);
        for (size_t i = 0; i < size; i++) {
            write_data[i] = (uint8_t)(i & 0xFF);
        }

        /*
         * Linux equivalent (word-at-a-time):
         *   for (i = 0; i < size; i += 8) {
         *       long word = *(long*)(write_data + i);
         *       ptrace(PTRACE_POKEDATA, pid, address + i, word);
         *   }
         *
         * macOS: Single call!
         */
        kr = mach_vm_write(task, address, (vm_offset_t)write_data, size);

        if (kr != KERN_SUCCESS) {
            fprintf(stderr, "Error: mach_vm_write() failed with code %d\n", kr);
            fprintf(stderr, "The address may be read-only or not writable\n");
        } else {
            printf("    ✓ Wrote %zu bytes\n", size);

            /* Read back to verify */
            printf("\n[5] Reading back to verify...\n");
            kr = mach_vm_read(task, address, size, &read_data, &read_count);
            if (kr == KERN_SUCCESS) {
                printf("    ✓ Read %u bytes\n", read_count);
                printf("\nNew memory contents:\n");
                print_hex_dump((uint8_t *)read_data, read_count, address);
                vm_deallocate(mach_task_self(), read_data, read_count);
            }
        }

        free(write_data);
    }

    /* Step 5: Resume and cleanup */
    printf("\n[Cleanup] Resuming task...\n");
    task_resume(task);
    mach_port_deallocate(mach_task_self(), task);

    printf("\n✓ Done!\n");
    printf("\nKey takeaway:\n");
    printf("  - macOS can read/write arbitrary memory sizes in ONE call\n");
    printf("  - Linux ptrace requires a loop, reading/writing one word at a time\n");
    printf("  - This makes macOS Mach API much more efficient for memory access\n");
    printf("  - But remember to vm_deallocate() the buffer from mach_vm_read()!\n");

    return 0;
}
