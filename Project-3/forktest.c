// Test that fork fails gracefully.
// Tiny executable so that the limit can be filling the proc table.

#include "types.h"
#include "stat.h"
#include "user.h"

#define N  62

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  int n, pid;

  // printf(1, "fork test\n");

  for(n=0; n<N; n++){
    pid = forkt(4*(n+1));
    if(pid < 0)
      break;
    if(pid == 0)
    {
      int i=0;
      while(i<=10000)
      {
        i++;
      }
      exit();
    }
  }

  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
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

  printf(1, "fork test OK\n");
}

int
main(void)
{
  forktest();
  exit();
}
