#include "types.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "stat.h"
#include "user.h"

const int N_PROC=10;
int ticks_stat[10];

int test(int n_tickets)
{
    int pid=forkt(n_tickets);
    if(pid==0)
    {
        for(;;)
            yieldc();
        exit();
    }
    else
        return pid;
}

int calculate_tickets(int i)
{
    i=i+1;
    return (i); 
    //return (i*i);
    // return (i*i*i);
}

void master_test(int n_proc)
{
    int child_pids[n_proc];
    int ticks_prev[n_proc];
    int ticks_curr[n_proc];

    int i;
    for(i=0;i<n_proc;i++)
        child_pids[i]=test( calculate_tickets(i));

    sleep(50);
    for(i=0;i<n_proc;i++)
        ticks_prev[i]=getcycles1(child_pids[i]);

    sleep(500);

    for(i=0;i<n_proc;i++)
        ticks_curr[i]=getcycles1(child_pids[i]);

    for(i=0;i<n_proc;i++)
        kill(child_pids[i]);
    
    for(i=0;i<n_proc;i++)
        wait();    
    
    for(i=0;i<n_proc;i++)
    {
        printf(1,"Id %d,Tickets %d,Ticks %d\n",i,calculate_tickets(i),ticks_curr[i]-ticks_prev[i]);
        ticks_stat[i]+=ticks_curr[i]-ticks_prev[i];

    }    
    
    return;
}

int main()
{
    int repeat=10;
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
    for(i=0;i<N_PROC;i++)
        printf(1,"Id %d, Ticks %d\n",i,ticks_stat[i]);
        
    printf(1,"Test Complete\n");
    exit();
}