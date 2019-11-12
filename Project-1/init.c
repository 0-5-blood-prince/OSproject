// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = { "sh", 0 };

int
main(void)
{
  int pid, wpid;
  // printf(1,"0\n");
  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  // printf(1,"1\n");
  dup(0);  // stdout
  dup(0);  // stderr
  // printf(1,"2\n");
  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    // printf(1,"3\n");
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    } 
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    // printf(1,"4\n");
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
