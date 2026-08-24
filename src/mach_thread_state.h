#ifndef MACH_THREAD_STATE_H
#define MACH_THREAD_STATE_H

#include <stddef.h>
#include <stdint.h>

/*
 * x86_64 thread state, declared so that it is visible on every host.
 *
 * <mach/i386/_structs.h> and <mach/i386/thread_status.h> are both guarded by
 * `#if defined(__i386__) || defined(__x86_64__)`, so an arm64 build cannot see
 * x86_thread_state64_t at all. The layout is fixed by the x86_64 Mach ABI and
 * the kernel fills it the same way whoever asks, so a debugger built for
 * either architecture can read an x86_64 target's registers.
 *
 * The static assertions below run wherever the system header *is* available -
 * i.e. on the x86_64 CI job - and fail the build if this ever drifts from it.
 */

struct mach_x86_thread_state64 {
	uint64_t	__rax;
	uint64_t	__rbx;
	uint64_t	__rcx;
	uint64_t	__rdx;
	uint64_t	__rdi;
	uint64_t	__rsi;
	uint64_t	__rbp;
	uint64_t	__rsp;
	uint64_t	__r8;
	uint64_t	__r9;
	uint64_t	__r10;
	uint64_t	__r11;
	uint64_t	__r12;
	uint64_t	__r13;
	uint64_t	__r14;
	uint64_t	__r15;
	uint64_t	__rip;
	uint64_t	__rflags;
	uint64_t	__cs;
	uint64_t	__fs;
	uint64_t	__gs;
};

/* x86_THREAD_STATE64 and x86_THREAD_STATE64_COUNT from
 * <mach/i386/thread_status.h>, likewise unavailable on arm64. */
#define MACH_X86_THREAD_STATE64 4
#define MACH_X86_THREAD_STATE64_COUNT \
	((unsigned int)(sizeof(struct mach_x86_thread_state64) / sizeof(int)))

#if defined(__i386__) || defined(__x86_64__)
#include <mach/i386/thread_status.h>

#define MACH_X86_SAME_OFFSET(f)                                               \
	_Static_assert(offsetof(struct mach_x86_thread_state64, f) ==         \
	                   offsetof(x86_thread_state64_t, f),                 \
	    "mach_x86_thread_state64." #f " disagrees with the system header")

_Static_assert(sizeof(struct mach_x86_thread_state64) ==
                   sizeof(x86_thread_state64_t),
    "mach_x86_thread_state64 disagrees with the system header");

MACH_X86_SAME_OFFSET(__rax);
MACH_X86_SAME_OFFSET(__rbx);
MACH_X86_SAME_OFFSET(__rcx);
MACH_X86_SAME_OFFSET(__rdx);
MACH_X86_SAME_OFFSET(__rdi);
MACH_X86_SAME_OFFSET(__rsi);
MACH_X86_SAME_OFFSET(__rbp);
MACH_X86_SAME_OFFSET(__rsp);
MACH_X86_SAME_OFFSET(__r8);
MACH_X86_SAME_OFFSET(__r9);
MACH_X86_SAME_OFFSET(__r10);
MACH_X86_SAME_OFFSET(__r11);
MACH_X86_SAME_OFFSET(__r12);
MACH_X86_SAME_OFFSET(__r13);
MACH_X86_SAME_OFFSET(__r14);
MACH_X86_SAME_OFFSET(__r15);
MACH_X86_SAME_OFFSET(__rip);
MACH_X86_SAME_OFFSET(__rflags);
MACH_X86_SAME_OFFSET(__cs);
MACH_X86_SAME_OFFSET(__fs);
MACH_X86_SAME_OFFSET(__gs);

_Static_assert(MACH_X86_THREAD_STATE64 == x86_THREAD_STATE64,
    "x86_THREAD_STATE64 flavor disagrees with the system header");
_Static_assert(MACH_X86_THREAD_STATE64_COUNT == x86_THREAD_STATE64_COUNT,
    "x86_THREAD_STATE64_COUNT disagrees with the system header");

#endif /* defined(__i386__) || defined(__x86_64__) */


/*
 * arm64 thread state, declared for the same reason: <mach/arm/_structs.h> is
 * guarded by `#if defined(__arm__) || defined(__arm64__)`, so an x86_64 build
 * cannot see arm_thread_state64_t.
 */

struct mach_arm_thread_state64 {
	uint64_t	__x[29];
	uint64_t	__fp;
	uint64_t	__lr;
	uint64_t	__sp;
	uint64_t	__pc;
	uint32_t	__cpsr;
	uint32_t	__pad;
};

#define MACH_ARM_THREAD_STATE64 6
#define MACH_ARM_THREAD_STATE64_COUNT \
	((unsigned int)(sizeof(struct mach_arm_thread_state64) / sizeof(int)))

#if defined(__arm__) || defined(__arm64__)
#include <mach/arm/thread_status.h>

#define MACH_ARM_SAME_OFFSET(f)                                               \
	_Static_assert(offsetof(struct mach_arm_thread_state64, f) ==         \
	                   offsetof(arm_thread_state64_t, f),                 \
	    "mach_arm_thread_state64." #f " disagrees with the system header")

_Static_assert(sizeof(struct mach_arm_thread_state64) ==
                   sizeof(arm_thread_state64_t),
    "mach_arm_thread_state64 disagrees with the system header");

MACH_ARM_SAME_OFFSET(__x);
MACH_ARM_SAME_OFFSET(__fp);
MACH_ARM_SAME_OFFSET(__lr);
MACH_ARM_SAME_OFFSET(__sp);
MACH_ARM_SAME_OFFSET(__pc);
MACH_ARM_SAME_OFFSET(__cpsr);
MACH_ARM_SAME_OFFSET(__pad);

_Static_assert(MACH_ARM_THREAD_STATE64 == ARM_THREAD_STATE64,
    "ARM_THREAD_STATE64 flavor disagrees with the system header");
_Static_assert(MACH_ARM_THREAD_STATE64_COUNT == ARM_THREAD_STATE64_COUNT,
    "ARM_THREAD_STATE64_COUNT disagrees with the system header");

#endif /* defined(__arm__) || defined(__arm64__) */

#endif /* MACH_THREAD_STATE_H */
