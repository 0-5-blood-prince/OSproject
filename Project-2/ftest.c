#include "types.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "stat.h"
#include "user.h"
#define Test_time 500
const int N_PROC=40;
int ticks[40];
int test()
{
    int pid=fork();
    if(pid==0)
    {
        for(;;){
             yieldc();  
 //this loop keeps the childs in Runnable state 
 //in the test time given below Test_time 
         }
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
        child_pids[i]=test();

    sleep(50);
    for(i=0;i<n_proc;i++)
        ticks_prev[i]=getcycles1(child_pids[i]);

    sleep(Test_time);
    
    for(i=0;i<n_proc;i++)
        ticks_curr[i]=getcycles1(child_pids[i]);

    for(i=0;i<n_proc;i++)
        kill(child_pids[i]);

    for(i=0;i<n_proc;i++)
        wait();    

    for(i=0;i<n_proc;i++)
    {
        ticks[i]+=ticks_curr[i]-ticks_prev[i];
    }    
    return;
}

int main()
{
    int i;
    int repeat=10;
    for(i=0;i<N_PROC;i++)
        ticks[i]=0;
    for(i=0;i<repeat;i++)
    {
        printf(1,"%d\n",i+1);
        master_test(N_PROC);
    }
    for(i=0;i<N_PROC;i++)
        ticks[i]/=repeat;

    for(i=0;i<N_PROC;i++)
        printf(1,"Child  %d   spent  %d  ticks on cpu\n",i,ticks[i]);
        
    printf(1,"Test Complete\n");
    exit();
}