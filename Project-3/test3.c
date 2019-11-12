#include "types.h"      //maybe needed to use some types of variables
#include "user.h"       //functios like printf and syscalls

//#include "defs.h"
#define STDOUT 1        //following the standard nomenclature for xv6 output
#define CHILDS 30
#define PAIN 99999999

void nopainnogain(){
    int i=PAIN;
    while(i--)
    {
        // printf(STDOUT,"%d\n",PAIN);
    }
    i=PAIN;
    while(i--){}
}

int main(){
    int pid;
    int i;
    for (i=0;i<CHILDS;i++){
        if(i<(CHILDS/3)){
            pid=forkt(i+1);
        }else if(i>=(CHILDS/3) &&  i<(2*(CHILDS/3))    ){
            pid=forkt(4*(i+1));
        }else{
            pid=forkt(64*(i+1));
        }
        
        
        if(pid == 0){
           yieldc();
            nopainnogain();
            exit();
        }
        
    }
    //while (wait() != -1);
    while(1){
        pid=wait();
        if(pid<0)break;
        printf(STDOUT,"Child %d finished\n",pid );
        
    }
    
    
    exit();
}