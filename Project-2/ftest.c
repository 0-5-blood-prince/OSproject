// #define NSEGS     6
#include "types.h"
// #include "defs.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "stat.h"
#include "user.h"

const int N_PROC=10;
int ticks_stat[10];
//int procticks[40];

typedef void (*function_type)(void);

void yield_inf()
{
    for(;;)
        yieldc();
}
// void run_inf()
// {
//     for(;;)
//         _asm_("");
// }

int test(function_type fn)
{
    int pid=fork();
    if(pid==0)
    {
        yieldc();
        (*fn)();
        exit();
    }
    else
        return pid;
}



void master_test(int n_proc)
{
    int child_pids[n_proc];
    int ticks_prev[n_proc];
    int ticks_curr[n_proc];

    int i;
    for(i=0;i<n_proc;i++)
        // child_pids[i]=test( calculate_tickets(i) ,run_inf);
        child_pids[i]=test(yield_inf);

    sleep(50);
    for(i=0;i<n_proc;i++)
        ticks_prev[i]=getcycles1(child_pids[i]);
    sleep(100);

    for(i=0;i<n_proc;i++)
        ticks_curr[i]=getcycles1(child_pids[i]);
    for(i=0;i<n_proc;i++)
        kill(child_pids[i]);
    for(i=0;i<n_proc;i++)
        wait();    
    sleep(100);
    for(i=0;i<n_proc;i++)
    {
        printf(1,"%d,%d\n",i,ticks_curr[i]-ticks_prev[i]);
        ticks_stat[i]+=ticks_curr[i]-ticks_prev[i];

    }    
    return;
}

int main()
{
    int i;
    for(i=0;i<N_PROC;i++)
        ticks_stat[i]=0;
    
    // printf(1,"%d\n",i+1);
    master_test(N_PROC);

    printf(1,"\n");
    printf(1,"id,ticks\n");
    for(i=0;i<N_PROC;i++)
        printf(1,"%d,%d\n",i,ticks_stat[i]);
        
    printf(1,"Test Complete\n");
    exit();
}