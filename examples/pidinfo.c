/* Compile on macOS as:
   cc pidinfo.c -o pidinfo

   ./pidinfo <PID> will print out the process status
*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <libproc.h>

/* Status values from proc.h */
#define SIDL    1               /* Process being created by fork. */
#define SRUN    2               /* Currently runnable. */
#define SSLEEP  3               /* Sleeping on an address. */
#define SSTOP   4               /* Process debugging or suspension. */
#define SZOMB   5               /* Awaiting collection by parent. */

void print_status(struct proc_bsdshortinfo* proc) {
    char* status;
    switch (proc->pbsi_status) {
    case SIDL:
        status = "IDLE";
        break;
    case SRUN:
        status = "RUN";
        break;
    case SSLEEP:
        status = "SLEEP";
        break;
    case SSTOP:
        status = "STOP";
        break;
    case 5:
        status = "ZOMB";
        break;
    }
    printf(" status: %s\n", status);
    return;
}

int main(int argc, char *argv[])
{
    pid_t pid;
    struct proc_bsdshortinfo proc;

    if (argc == 2)
        pid = atoi(argv[1]);
    else
        pid = getpid();
    int st = proc_pidinfo(pid, PROC_PIDT_SHORTBSDINFO, 0,
                          &proc, PROC_PIDT_SHORTBSDINFO_SIZE);

    if (st != PROC_PIDT_SHORTBSDINFO_SIZE) {
        fprintf(stderr, "Cannot get process info");
        return 1;
    }
    printf(" pid: %d\n", (int)proc.pbsi_pid);
    printf("ppid: %d\n", (int)proc.pbsi_ppid);
    printf(" uid: %d\n", (int)proc.pbsi_uid);
    printf(" gid: %d\n", (int)proc.pbsi_gid);
    print_status(&proc);

    return 0;
}