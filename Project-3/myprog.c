#include "types.h"
#include "stat.h"
#include "user.h"

#define N  1000


int
main(int argc,char *argv[])
{
	// int pid1=fork();
	// int pid2=forkt(8);
	
	if(forkt(8)==0)
	{
		printf(1,"8\n");
		exit();
	}
	if(fork()==0)
	{
		printf(1,"a\n");
		exit();
	}
	wait();
	wait();
	exit();
}