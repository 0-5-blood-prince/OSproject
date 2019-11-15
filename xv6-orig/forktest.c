// Test that fork fails gracefully.
// Tiny executable so that the limit can be filling the proc table.
// #include "defs.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#define N  60

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  int n, pid;

  printf(1, "fork test\n");
  int a = gettsched();
 
  for(n=0; n<N; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
    {
      int i=1;
      while(i>0){//yieldc();
        i--;}
      exit();
    }
  }
  
  if(n == N){
  int b = gettsched();
  printf(1,"sched time %d",(b-a));
    printf(1, "fork claimed to work N times!%d\n", N);
    exit();
  }

  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    printf(1, "wait got too many\n");
    exit();
  }
    int b = gettsched();
  printf(1,"sched time %d\n",b-a);
  printf(1, "fork test OK\n");
}

int
main(void)
{
  forktest();
  exit();
}
