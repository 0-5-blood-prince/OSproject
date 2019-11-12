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

int test(int n_tickets,function_type fn)
{
    int pid=forkt(n_tickets);
    if(pid==0)
    {
        yieldc();
        (*fn)();
        exit();
    }
    else
        return pid;
}

int calculate_tickets(int i)
{
    i=i+1;
    //return(5); // fair
    // return (i);
     return (i*i);
    // return (i*i*i);
}

void master_test(int n_proc)
{
    int child_pids[n_proc];
    int ticks_prev[n_proc];
    int ticks_curr[n_proc];

    int i;
    for(i=0;i<n_proc;i++)
        // child_pids[i]=test( calculate_tickets(i) ,run_inf);
        child_pids[i]=test( calculate_tickets(i) ,yield_inf);

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
    for(i=0;i<n_proc;i++)
    {
        printf(1,"%d,%d,%d\n",i,calculate_tickets(i),ticks_curr[i]-ticks_prev[i]);
        ticks_stat[i]+=ticks_curr[i]-ticks_prev[i];

    }    
    return;
}

int main()
{
    int repeat=1;
    int i;
    for(i=0;i<N_PROC;i++)
        ticks_stat[i]=0;
    
    for(i=0;i<repeat;i++)
    {
        printf(1,"%d\n",i+1);
        master_test(N_PROC);
    }

    for(i=0;i<N_PROC;i++)
        ticks_stat[i]/=repeat;

    printf(1,"\n");
    printf(1,"id,ticket_assigned,ticks\n");
    for(i=0;i<N_PROC;i++)
        printf(1,"%d,%d,%d\n",i,calculate_tickets(i),ticks_stat[i]);
        
    printf(1,"Test Complete\n");
    exit();
}