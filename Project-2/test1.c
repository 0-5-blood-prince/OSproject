#include "types.h"
#include "stat.h"
#include "user.h"
int print_l(int fd)
{

    char buffer[512];
    int read_size;
    
    int i;
    while( (read_size = read(fd,buffer,sizeof(buffer))) >0 )
    {
        for(i=0;i<=read_size;i++)
        {
            if(buffer[i]!='\n')
            {
             if(buffer[i]!= 0)
                printf(1,"from file %d %c\n",fd,buffer[i]);
            }
            else if(buffer[i]=='\n')
            {
               // printf(1,"\n");
                sleep(10);
                yieldc();
            }
        }
        
    }
    return 0;
}

int distribute_work(int fd)
{
    int pid=fork();
    if(pid==0)
    {
        // printf(1,"%d",i);
        print_l(fd);
        exit();
    }
    else
        return pid;
}
int main()
{
    int n_files=3;
    int files[3];
    files[0]=open("t1",0);
    files[1]=open("t2",0);
    files[2]=open("t3",0);
    
    
    int i;
    for(i=0;i<n_files;i++)
        distribute_work(files[i]);
       
    sleep(4);
    for(i=0;i<n_files;i++)
        wait();   
    
    close(files[0]);
    close(files[1]);
    close(files[2]);

    exit();
}