
_test3:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }
    i=PAIN;
    while(i--){}
}

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
    int pid;
    int i;
    for (i=0;i<CHILDS;i++){
   7:	31 c0                	xor    %eax,%eax
int main(){
   9:	ff 71 fc             	pushl  -0x4(%ecx)
   c:	55                   	push   %ebp
   d:	89 e5                	mov    %esp,%ebp
   f:	53                   	push   %ebx
  10:	8d 58 01             	lea    0x1(%eax),%ebx
  13:	51                   	push   %ecx
        if(i<(CHILDS/3)){
  14:	83 f8 09             	cmp    $0x9,%eax
  17:	76 33                	jbe    4c <main+0x4c>
  19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            pid=forkt(i+1);
        }else if(i>=(CHILDS/3) &&  i<(2*(CHILDS/3))    ){
  20:	83 e8 0a             	sub    $0xa,%eax
  23:	83 f8 09             	cmp    $0x9,%eax
  26:	76 69                	jbe    91 <main+0x91>
            pid=forkt(4*(i+1));
        }else{
            pid=forkt(64*(i+1));
  28:	89 d8                	mov    %ebx,%eax
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	c1 e0 06             	shl    $0x6,%eax
  30:	50                   	push   %eax
  31:	e8 7b 03 00 00       	call   3b1 <forkt>
        }
        
        
        if(pid == 0){
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	74 1f                	je     5c <main+0x5c>
    for (i=0;i<CHILDS;i++){
  3d:	83 fb 1e             	cmp    $0x1e,%ebx
  40:	74 41                	je     83 <main+0x83>
  42:	89 d8                	mov    %ebx,%eax
        if(i<(CHILDS/3)){
  44:	8d 58 01             	lea    0x1(%eax),%ebx
  47:	83 f8 09             	cmp    $0x9,%eax
  4a:	77 d4                	ja     20 <main+0x20>
            pid=forkt(i+1);
  4c:	83 ec 0c             	sub    $0xc,%esp
  4f:	53                   	push   %ebx
  50:	e8 5c 03 00 00       	call   3b1 <forkt>
  55:	83 c4 10             	add    $0x10,%esp
        if(pid == 0){
  58:	85 c0                	test   %eax,%eax
  5a:	75 e6                	jne    42 <main+0x42>
           yieldc();
  5c:	e8 58 03 00 00       	call   3b9 <yieldc>
            nopainnogain();
            exit();
  61:	e8 ab 02 00 00       	call   311 <exit>
  66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    //while (wait() != -1);
    while(1){
        pid=wait();
        if(pid<0)break;
        printf(STDOUT,"Child %d finished\n",pid );
  70:	83 ec 04             	sub    $0x4,%esp
  73:	50                   	push   %eax
  74:	68 f8 07 00 00       	push   $0x7f8
  79:	6a 01                	push   $0x1
  7b:	e8 10 04 00 00       	call   490 <printf>
        pid=wait();
  80:	83 c4 10             	add    $0x10,%esp
  83:	e8 91 02 00 00       	call   319 <wait>
        if(pid<0)break;
  88:	85 c0                	test   %eax,%eax
  8a:	79 e4                	jns    70 <main+0x70>
        
    }
    
    
    exit();
  8c:	e8 80 02 00 00       	call   311 <exit>
            pid=forkt(4*(i+1));
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  9b:	50                   	push   %eax
  9c:	e8 10 03 00 00       	call   3b1 <forkt>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	eb b2                	jmp    58 <main+0x58>
  a6:	66 90                	xchg   %ax,%ax
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <nopainnogain>:
}
  b0:	c3                   	ret    
  b1:	66 90                	xchg   %ax,%ax
  b3:	66 90                	xchg   %ax,%ax
  b5:	66 90                	xchg   %ax,%ax
  b7:	66 90                	xchg   %ax,%ax
  b9:	66 90                	xchg   %ax,%ax
  bb:	66 90                	xchg   %ax,%ax
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c1:	31 d2                	xor    %edx,%edx
{
  c3:	89 e5                	mov    %esp,%ebp
  c5:	53                   	push   %ebx
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  d7:	83 c2 01             	add    $0x1,%edx
  da:	84 c9                	test   %cl,%cl
  dc:	75 f2                	jne    d0 <strcpy+0x10>
    ;
  return os;
}
  de:	5b                   	pop    %ebx
  df:	5d                   	pop    %ebp
  e0:	c3                   	ret    
  e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ef:	90                   	nop

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
  fb:	0f b6 13             	movzbl (%ebx),%edx
  fe:	0f b6 0e             	movzbl (%esi),%ecx
 101:	84 d2                	test   %dl,%dl
 103:	74 1e                	je     123 <strcmp+0x33>
 105:	b8 01 00 00 00       	mov    $0x1,%eax
 10a:	38 ca                	cmp    %cl,%dl
 10c:	74 09                	je     117 <strcmp+0x27>
 10e:	eb 20                	jmp    130 <strcmp+0x40>
 110:	83 c0 01             	add    $0x1,%eax
 113:	38 ca                	cmp    %cl,%dl
 115:	75 19                	jne    130 <strcmp+0x40>
 117:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 11b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 11f:	84 d2                	test   %dl,%dl
 121:	75 ed                	jne    110 <strcmp+0x20>
 123:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 125:	5b                   	pop    %ebx
 126:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 127:	29 c8                	sub    %ecx,%eax
}
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop
 130:	0f b6 c2             	movzbl %dl,%eax
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 135:	29 c8                	sub    %ecx,%eax
}
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 39 00             	cmpb   $0x0,(%ecx)
 149:	74 15                	je     160 <strlen+0x20>
 14b:	31 d2                	xor    %edx,%edx
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c2 01             	add    $0x1,%edx
 153:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 157:	89 d0                	mov    %edx,%eax
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    
 15d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 160:	31 c0                	xor    %eax,%eax
}
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    
 164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	89 d0                	mov    %edx,%eax
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18e:	66 90                	xchg   %ax,%ax

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 19a:	0f b6 18             	movzbl (%eax),%ebx
 19d:	84 db                	test   %bl,%bl
 19f:	74 1d                	je     1be <strchr+0x2e>
 1a1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 1a3:	38 d3                	cmp    %dl,%bl
 1a5:	75 0d                	jne    1b4 <strchr+0x24>
 1a7:	eb 17                	jmp    1c0 <strchr+0x30>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b0:	38 ca                	cmp    %cl,%dl
 1b2:	74 0c                	je     1c0 <strchr+0x30>
  for(; *s; s++)
 1b4:	83 c0 01             	add    $0x1,%eax
 1b7:	0f b6 10             	movzbl (%eax),%edx
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strchr+0x20>
      return (char*)s;
  return 0;
 1be:	31 c0                	xor    %eax,%eax
}
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	31 f6                	xor    %esi,%esi
{
 1d7:	53                   	push   %ebx
 1d8:	89 f3                	mov    %esi,%ebx
 1da:	83 ec 1c             	sub    $0x1c,%esp
 1dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1e0:	eb 2f                	jmp    211 <gets+0x41>
 1e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1ee:	6a 01                	push   $0x1
 1f0:	50                   	push   %eax
 1f1:	6a 00                	push   $0x0
 1f3:	e8 31 01 00 00       	call   329 <read>
    if(cc < 1)
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	85 c0                	test   %eax,%eax
 1fd:	7e 1c                	jle    21b <gets+0x4b>
      break;
    buf[i++] = c;
 1ff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 203:	83 c7 01             	add    $0x1,%edi
 206:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 209:	3c 0a                	cmp    $0xa,%al
 20b:	74 23                	je     230 <gets+0x60>
 20d:	3c 0d                	cmp    $0xd,%al
 20f:	74 1f                	je     230 <gets+0x60>
  for(i=0; i+1 < max; ){
 211:	83 c3 01             	add    $0x1,%ebx
 214:	89 fe                	mov    %edi,%esi
 216:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 219:	7c cd                	jl     1e8 <gets+0x18>
 21b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 220:	c6 03 00             	movb   $0x0,(%ebx)
}
 223:	8d 65 f4             	lea    -0xc(%ebp),%esp
 226:	5b                   	pop    %ebx
 227:	5e                   	pop    %esi
 228:	5f                   	pop    %edi
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret    
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop
 230:	8b 75 08             	mov    0x8(%ebp),%esi
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	01 de                	add    %ebx,%esi
 238:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 23a:	c6 03 00             	movb   $0x0,(%ebx)
}
 23d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 240:	5b                   	pop    %ebx
 241:	5e                   	pop    %esi
 242:	5f                   	pop    %edi
 243:	5d                   	pop    %ebp
 244:	c3                   	ret    
 245:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <stat>:

int
stat(const char *n, struct stat *st)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 255:	83 ec 08             	sub    $0x8,%esp
 258:	6a 00                	push   $0x0
 25a:	ff 75 08             	pushl  0x8(%ebp)
 25d:	e8 ef 00 00 00       	call   351 <open>
  if(fd < 0)
 262:	83 c4 10             	add    $0x10,%esp
 265:	85 c0                	test   %eax,%eax
 267:	78 27                	js     290 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 269:	83 ec 08             	sub    $0x8,%esp
 26c:	ff 75 0c             	pushl  0xc(%ebp)
 26f:	89 c3                	mov    %eax,%ebx
 271:	50                   	push   %eax
 272:	e8 f2 00 00 00       	call   369 <fstat>
  close(fd);
 277:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 27a:	89 c6                	mov    %eax,%esi
  close(fd);
 27c:	e8 b8 00 00 00       	call   339 <close>
  return r;
 281:	83 c4 10             	add    $0x10,%esp
}
 284:	8d 65 f8             	lea    -0x8(%ebp),%esp
 287:	89 f0                	mov    %esi,%eax
 289:	5b                   	pop    %ebx
 28a:	5e                   	pop    %esi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 290:	be ff ff ff ff       	mov    $0xffffffff,%esi
 295:	eb ed                	jmp    284 <stat+0x34>
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax

000002a0 <atoi>:

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a7:	0f be 11             	movsbl (%ecx),%edx
 2aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ad:	3c 09                	cmp    $0x9,%al
  n = 0;
 2af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2b4:	77 1f                	ja     2d5 <atoi+0x35>
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 2c0:	83 c1 01             	add    $0x1,%ecx
 2c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2ca:	0f be 11             	movsbl (%ecx),%edx
 2cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2d0:	80 fb 09             	cmp    $0x9,%bl
 2d3:	76 eb                	jbe    2c0 <atoi+0x20>
  return n;
}
 2d5:	5b                   	pop    %ebx
 2d6:	5d                   	pop    %ebp
 2d7:	c3                   	ret    
 2d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop

000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	8b 55 10             	mov    0x10(%ebp),%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	56                   	push   %esi
 2eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ee:	85 d2                	test   %edx,%edx
 2f0:	7e 13                	jle    305 <memmove+0x25>
 2f2:	01 c2                	add    %eax,%edx
  dst = vdst;
 2f4:	89 c7                	mov    %eax,%edi
 2f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 300:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 301:	39 fa                	cmp    %edi,%edx
 303:	75 fb                	jne    300 <memmove+0x20>
  return vdst;
}
 305:	5e                   	pop    %esi
 306:	5f                   	pop    %edi
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    

00000309 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 309:	b8 01 00 00 00       	mov    $0x1,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <exit>:
SYSCALL(exit)
 311:	b8 02 00 00 00       	mov    $0x2,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <wait>:
SYSCALL(wait)
 319:	b8 03 00 00 00       	mov    $0x3,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <pipe>:
SYSCALL(pipe)
 321:	b8 04 00 00 00       	mov    $0x4,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <read>:
SYSCALL(read)
 329:	b8 05 00 00 00       	mov    $0x5,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <write>:
SYSCALL(write)
 331:	b8 10 00 00 00       	mov    $0x10,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <close>:
SYSCALL(close)
 339:	b8 15 00 00 00       	mov    $0x15,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <kill>:
SYSCALL(kill)
 341:	b8 06 00 00 00       	mov    $0x6,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <exec>:
SYSCALL(exec)
 349:	b8 07 00 00 00       	mov    $0x7,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <open>:
SYSCALL(open)
 351:	b8 0f 00 00 00       	mov    $0xf,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <mknod>:
SYSCALL(mknod)
 359:	b8 11 00 00 00       	mov    $0x11,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <unlink>:
SYSCALL(unlink)
 361:	b8 12 00 00 00       	mov    $0x12,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <fstat>:
SYSCALL(fstat)
 369:	b8 08 00 00 00       	mov    $0x8,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <link>:
SYSCALL(link)
 371:	b8 13 00 00 00       	mov    $0x13,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <mkdir>:
SYSCALL(mkdir)
 379:	b8 14 00 00 00       	mov    $0x14,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <chdir>:
SYSCALL(chdir)
 381:	b8 09 00 00 00       	mov    $0x9,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <dup>:
SYSCALL(dup)
 389:	b8 0a 00 00 00       	mov    $0xa,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <getpid>:
SYSCALL(getpid)
 391:	b8 0b 00 00 00       	mov    $0xb,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <sbrk>:
SYSCALL(sbrk)
 399:	b8 0c 00 00 00       	mov    $0xc,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <sleep>:
SYSCALL(sleep)
 3a1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <uptime>:
SYSCALL(uptime)
 3a9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <forkt>:
SYSCALL(forkt)
 3b1:	b8 16 00 00 00       	mov    $0x16,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <yieldc>:
SYSCALL(yieldc)
 3b9:	b8 17 00 00 00       	mov    $0x17,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getcycles1>:
SYSCALL(getcycles1)
 3c1:	b8 18 00 00 00       	mov    $0x18,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    
 3c9:	66 90                	xchg   %ax,%ax
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3d6:	89 d3                	mov    %edx,%ebx
{
 3d8:	83 ec 3c             	sub    $0x3c,%esp
 3db:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 3de:	85 d2                	test   %edx,%edx
 3e0:	0f 89 92 00 00 00    	jns    478 <printint+0xa8>
 3e6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ea:	0f 84 88 00 00 00    	je     478 <printint+0xa8>
    neg = 1;
 3f0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 3f7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 3f9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 400:	8d 75 d7             	lea    -0x29(%ebp),%esi
 403:	eb 08                	jmp    40d <printint+0x3d>
 405:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 408:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 40b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 40d:	89 d8                	mov    %ebx,%eax
 40f:	31 d2                	xor    %edx,%edx
 411:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 414:	f7 f1                	div    %ecx
 416:	83 c7 01             	add    $0x1,%edi
 419:	0f b6 92 14 08 00 00 	movzbl 0x814(%edx),%edx
 420:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 423:	39 d9                	cmp    %ebx,%ecx
 425:	76 e1                	jbe    408 <printint+0x38>
  if(neg)
 427:	8b 45 c0             	mov    -0x40(%ebp),%eax
 42a:	85 c0                	test   %eax,%eax
 42c:	74 0d                	je     43b <printint+0x6b>
    buf[i++] = '-';
 42e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 433:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 438:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 43b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 43e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 441:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 445:	eb 0f                	jmp    456 <printint+0x86>
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax
 450:	0f b6 13             	movzbl (%ebx),%edx
 453:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 456:	83 ec 04             	sub    $0x4,%esp
 459:	88 55 d7             	mov    %dl,-0x29(%ebp)
 45c:	6a 01                	push   $0x1
 45e:	56                   	push   %esi
 45f:	57                   	push   %edi
 460:	e8 cc fe ff ff       	call   331 <write>

  while(--i >= 0)
 465:	83 c4 10             	add    $0x10,%esp
 468:	39 de                	cmp    %ebx,%esi
 46a:	75 e4                	jne    450 <printint+0x80>
    putc(fd, buf[i]);
}
 46c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46f:	5b                   	pop    %ebx
 470:	5e                   	pop    %esi
 471:	5f                   	pop    %edi
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 478:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 47f:	e9 75 ff ff ff       	jmp    3f9 <printint+0x29>
 484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 48f:	90                   	nop

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	8b 75 0c             	mov    0xc(%ebp),%esi
 49c:	0f b6 1e             	movzbl (%esi),%ebx
 49f:	84 db                	test   %bl,%bl
 4a1:	0f 84 b9 00 00 00    	je     560 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 4a7:	8d 45 10             	lea    0x10(%ebp),%eax
 4aa:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 4ad:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4b0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 4b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4b5:	eb 38                	jmp    4ef <printf+0x5f>
 4b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4be:	66 90                	xchg   %ax,%ax
 4c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4c3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	74 17                	je     4e4 <printf+0x54>
  write(fd, &c, 1);
 4cd:	83 ec 04             	sub    $0x4,%esp
 4d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4d3:	6a 01                	push   $0x1
 4d5:	57                   	push   %edi
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 53 fe ff ff       	call   331 <write>
 4de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4e1:	83 c4 10             	add    $0x10,%esp
 4e4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4e7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4eb:	84 db                	test   %bl,%bl
 4ed:	74 71                	je     560 <printf+0xd0>
    c = fmt[i] & 0xff;
 4ef:	0f be cb             	movsbl %bl,%ecx
 4f2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4f5:	85 d2                	test   %edx,%edx
 4f7:	74 c7                	je     4c0 <printf+0x30>
      }
    } else if(state == '%'){
 4f9:	83 fa 25             	cmp    $0x25,%edx
 4fc:	75 e6                	jne    4e4 <printf+0x54>
      if(c == 'd'){
 4fe:	83 f8 64             	cmp    $0x64,%eax
 501:	0f 84 99 00 00 00    	je     5a0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 507:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 50d:	83 f9 70             	cmp    $0x70,%ecx
 510:	74 5e                	je     570 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 512:	83 f8 73             	cmp    $0x73,%eax
 515:	0f 84 d5 00 00 00    	je     5f0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51b:	83 f8 63             	cmp    $0x63,%eax
 51e:	0f 84 8c 00 00 00    	je     5b0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 524:	83 f8 25             	cmp    $0x25,%eax
 527:	0f 84 b3 00 00 00    	je     5e0 <printf+0x150>
  write(fd, &c, 1);
 52d:	83 ec 04             	sub    $0x4,%esp
 530:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 534:	6a 01                	push   $0x1
 536:	57                   	push   %edi
 537:	ff 75 08             	pushl  0x8(%ebp)
 53a:	e8 f2 fd ff ff       	call   331 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 53f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 542:	83 c4 0c             	add    $0xc,%esp
 545:	6a 01                	push   $0x1
 547:	83 c6 01             	add    $0x1,%esi
 54a:	57                   	push   %edi
 54b:	ff 75 08             	pushl  0x8(%ebp)
 54e:	e8 de fd ff ff       	call   331 <write>
  for(i = 0; fmt[i]; i++){
 553:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 557:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 55a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 55c:	84 db                	test   %bl,%bl
 55e:	75 8f                	jne    4ef <printf+0x5f>
    }
  }
}
 560:	8d 65 f4             	lea    -0xc(%ebp),%esp
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
 568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
        printint(fd, *ap, 16, 0);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
 578:	6a 00                	push   $0x0
 57a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	8b 13                	mov    (%ebx),%edx
 582:	e8 49 fe ff ff       	call   3d0 <printint>
        ap++;
 587:	89 d8                	mov    %ebx,%eax
 589:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58c:	31 d2                	xor    %edx,%edx
        ap++;
 58e:	83 c0 04             	add    $0x4,%eax
 591:	89 45 d0             	mov    %eax,-0x30(%ebp)
 594:	e9 4b ff ff ff       	jmp    4e4 <printf+0x54>
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a8:	6a 01                	push   $0x1
 5aa:	eb ce                	jmp    57a <printf+0xea>
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 5b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5b6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5b8:	6a 01                	push   $0x1
        ap++;
 5ba:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 5bd:	57                   	push   %edi
 5be:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 5c1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5c4:	e8 68 fd ff ff       	call   331 <write>
        ap++;
 5c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cf:	31 d2                	xor    %edx,%edx
 5d1:	e9 0e ff ff ff       	jmp    4e4 <printf+0x54>
 5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 5e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5e3:	83 ec 04             	sub    $0x4,%esp
 5e6:	e9 5a ff ff ff       	jmp    545 <printf+0xb5>
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
        s = (char*)*ap;
 5f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5f3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5f5:	83 c0 04             	add    $0x4,%eax
 5f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5fb:	85 db                	test   %ebx,%ebx
 5fd:	74 17                	je     616 <printf+0x186>
        while(*s != 0){
 5ff:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 602:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 604:	84 c0                	test   %al,%al
 606:	0f 84 d8 fe ff ff    	je     4e4 <printf+0x54>
 60c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 60f:	89 de                	mov    %ebx,%esi
 611:	8b 5d 08             	mov    0x8(%ebp),%ebx
 614:	eb 1a                	jmp    630 <printf+0x1a0>
          s = "(null)";
 616:	bb 0b 08 00 00       	mov    $0x80b,%ebx
        while(*s != 0){
 61b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 61e:	b8 28 00 00 00       	mov    $0x28,%eax
 623:	89 de                	mov    %ebx,%esi
 625:	8b 5d 08             	mov    0x8(%ebp),%ebx
 628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
  write(fd, &c, 1);
 630:	83 ec 04             	sub    $0x4,%esp
          s++;
 633:	83 c6 01             	add    $0x1,%esi
 636:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 639:	6a 01                	push   $0x1
 63b:	57                   	push   %edi
 63c:	53                   	push   %ebx
 63d:	e8 ef fc ff ff       	call   331 <write>
        while(*s != 0){
 642:	0f b6 06             	movzbl (%esi),%eax
 645:	83 c4 10             	add    $0x10,%esp
 648:	84 c0                	test   %al,%al
 64a:	75 e4                	jne    630 <printf+0x1a0>
 64c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 64f:	31 d2                	xor    %edx,%edx
 651:	e9 8e fe ff ff       	jmp    4e4 <printf+0x54>
 656:	66 90                	xchg   %ax,%ax
 658:	66 90                	xchg   %ax,%ax
 65a:	66 90                	xchg   %ax,%ax
 65c:	66 90                	xchg   %ax,%ax
 65e:	66 90                	xchg   %ax,%ax

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 d4 0a 00 00       	mov    0xad4,%eax
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 66e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 670:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 673:	39 c8                	cmp    %ecx,%eax
 675:	73 19                	jae    690 <free+0x30>
 677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67e:	66 90                	xchg   %ax,%ax
 680:	39 d1                	cmp    %edx,%ecx
 682:	72 14                	jb     698 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 684:	39 d0                	cmp    %edx,%eax
 686:	73 10                	jae    698 <free+0x38>
{
 688:	89 d0                	mov    %edx,%eax
 68a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	39 c8                	cmp    %ecx,%eax
 68e:	72 f0                	jb     680 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	39 d0                	cmp    %edx,%eax
 692:	72 f4                	jb     688 <free+0x28>
 694:	39 d1                	cmp    %edx,%ecx
 696:	73 f0                	jae    688 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 73 fc             	mov    -0x4(%ebx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 fa                	cmp    %edi,%edx
 6a0:	74 1e                	je     6c0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ab:	39 f1                	cmp    %esi,%ecx
 6ad:	74 28                	je     6d7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6af:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 6b1:	5b                   	pop    %ebx
  freep = p;
 6b2:	a3 d4 0a 00 00       	mov    %eax,0xad4
}
 6b7:	5e                   	pop    %esi
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret    
 6bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6c0:	03 72 04             	add    0x4(%edx),%esi
 6c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 12                	mov    (%edx),%edx
 6ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6cd:	8b 50 04             	mov    0x4(%eax),%edx
 6d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d3:	39 f1                	cmp    %esi,%ecx
 6d5:	75 d8                	jne    6af <free+0x4f>
    p->s.size += bp->s.size;
 6d7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6da:	a3 d4 0a 00 00       	mov    %eax,0xad4
    p->s.size += bp->s.size;
 6df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6e5:	89 10                	mov    %edx,(%eax)
}
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6fc:	8b 3d d4 0a 00 00    	mov    0xad4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8d 70 07             	lea    0x7(%eax),%esi
 705:	c1 ee 03             	shr    $0x3,%esi
 708:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 70b:	85 ff                	test   %edi,%edi
 70d:	0f 84 ad 00 00 00    	je     7c0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 715:	8b 4a 04             	mov    0x4(%edx),%ecx
 718:	39 f1                	cmp    %esi,%ecx
 71a:	73 72                	jae    78e <malloc+0x9e>
 71c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 722:	bb 00 10 00 00       	mov    $0x1000,%ebx
 727:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 72a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 734:	eb 1b                	jmp    751 <malloc+0x61>
 736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 740:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 742:	8b 48 04             	mov    0x4(%eax),%ecx
 745:	39 f1                	cmp    %esi,%ecx
 747:	73 4f                	jae    798 <malloc+0xa8>
 749:	8b 3d d4 0a 00 00    	mov    0xad4,%edi
 74f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 751:	39 d7                	cmp    %edx,%edi
 753:	75 eb                	jne    740 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 755:	83 ec 0c             	sub    $0xc,%esp
 758:	ff 75 e4             	pushl  -0x1c(%ebp)
 75b:	e8 39 fc ff ff       	call   399 <sbrk>
  if(p == (char*)-1)
 760:	83 c4 10             	add    $0x10,%esp
 763:	83 f8 ff             	cmp    $0xffffffff,%eax
 766:	74 1c                	je     784 <malloc+0x94>
  hp->s.size = nu;
 768:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 76b:	83 ec 0c             	sub    $0xc,%esp
 76e:	83 c0 08             	add    $0x8,%eax
 771:	50                   	push   %eax
 772:	e8 e9 fe ff ff       	call   660 <free>
  return freep;
 777:	8b 15 d4 0a 00 00    	mov    0xad4,%edx
      if((p = morecore(nunits)) == 0)
 77d:	83 c4 10             	add    $0x10,%esp
 780:	85 d2                	test   %edx,%edx
 782:	75 bc                	jne    740 <malloc+0x50>
        return 0;
  }
}
 784:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 787:	31 c0                	xor    %eax,%eax
}
 789:	5b                   	pop    %ebx
 78a:	5e                   	pop    %esi
 78b:	5f                   	pop    %edi
 78c:	5d                   	pop    %ebp
 78d:	c3                   	ret    
    if(p->s.size >= nunits){
 78e:	89 d0                	mov    %edx,%eax
 790:	89 fa                	mov    %edi,%edx
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 798:	39 ce                	cmp    %ecx,%esi
 79a:	74 54                	je     7f0 <malloc+0x100>
        p->s.size -= nunits;
 79c:	29 f1                	sub    %esi,%ecx
 79e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7a1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7a4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7a7:	89 15 d4 0a 00 00    	mov    %edx,0xad4
}
 7ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7b0:	83 c0 08             	add    $0x8,%eax
}
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret    
 7b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7bf:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7c0:	c7 05 d4 0a 00 00 d8 	movl   $0xad8,0xad4
 7c7:	0a 00 00 
    base.s.size = 0;
 7ca:	bf d8 0a 00 00       	mov    $0xad8,%edi
    base.s.ptr = freep = prevp = &base;
 7cf:	c7 05 d8 0a 00 00 d8 	movl   $0xad8,0xad8
 7d6:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7db:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 7e2:	00 00 00 
    if(p->s.size >= nunits){
 7e5:	e9 32 ff ff ff       	jmp    71c <malloc+0x2c>
 7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7f0:	8b 08                	mov    (%eax),%ecx
 7f2:	89 0a                	mov    %ecx,(%edx)
 7f4:	eb b1                	jmp    7a7 <malloc+0xb7>
