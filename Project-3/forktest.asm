
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
   6:	e8 35 00 00 00       	call   40 <forktest>
  exit();
   b:	e8 71 03 00 00       	call   381 <exit>

00000010 <printf>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	83 ec 10             	sub    $0x10,%esp
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  1a:	53                   	push   %ebx
  1b:	e8 90 01 00 00       	call   1b0 <strlen>
  20:	83 c4 0c             	add    $0xc,%esp
  23:	50                   	push   %eax
  24:	53                   	push   %ebx
  25:	ff 75 08             	pushl  0x8(%ebp)
  28:	e8 74 03 00 00       	call   3a1 <write>
}
  2d:	83 c4 10             	add    $0x10,%esp
  30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  33:	c9                   	leave  
  34:	c3                   	ret    
  35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000040 <forktest>:
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
  for(n=0; n<N; n++){
  45:	31 db                	xor    %ebx,%ebx
  47:	eb 14                	jmp    5d <forktest+0x1d>
  49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
  50:	74 6a                	je     bc <forktest+0x7c>
  52:	89 f3                	mov    %esi,%ebx
  for(n=0; n<N; n++){
  54:	83 fe 3e             	cmp    $0x3e,%esi
  57:	0f 84 a8 00 00 00    	je     105 <forktest+0xc5>
    pid = forkt(4*(n+1));
  5d:	8d 73 01             	lea    0x1(%ebx),%esi
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  6a:	50                   	push   %eax
  6b:	e8 b1 03 00 00       	call   421 <forkt>
    if(pid < 0)
  70:	83 c4 10             	add    $0x10,%esp
  73:	85 c0                	test   %eax,%eax
  75:	79 d9                	jns    50 <forktest+0x10>
  for(; n > 0; n--){
  77:	85 db                	test   %ebx,%ebx
  79:	74 13                	je     8e <forktest+0x4e>
  7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  7f:	90                   	nop
    if(wait() < 0){
  80:	e8 04 03 00 00       	call   389 <wait>
  85:	85 c0                	test   %eax,%eax
  87:	78 38                	js     c1 <forktest+0x81>
  for(; n > 0; n--){
  89:	83 eb 01             	sub    $0x1,%ebx
  8c:	75 f2                	jne    80 <forktest+0x40>
  if(wait() != -1){
  8e:	e8 f6 02 00 00       	call   389 <wait>
  93:	83 f8 ff             	cmp    $0xffffffff,%eax
  96:	75 4b                	jne    e3 <forktest+0xa3>
  write(fd, s, strlen(s));
  98:	83 ec 0c             	sub    $0xc,%esp
  9b:	68 63 04 00 00       	push   $0x463
  a0:	e8 0b 01 00 00       	call   1b0 <strlen>
  a5:	83 c4 0c             	add    $0xc,%esp
  a8:	50                   	push   %eax
  a9:	68 63 04 00 00       	push   $0x463
  ae:	6a 01                	push   $0x1
  b0:	e8 ec 02 00 00       	call   3a1 <write>
}
  b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  b8:	5b                   	pop    %ebx
  b9:	5e                   	pop    %esi
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    
      exit();
  bc:	e8 c0 02 00 00       	call   381 <exit>
  write(fd, s, strlen(s));
  c1:	83 ec 0c             	sub    $0xc,%esp
  c4:	68 3c 04 00 00       	push   $0x43c
  c9:	e8 e2 00 00 00       	call   1b0 <strlen>
  ce:	83 c4 0c             	add    $0xc,%esp
  d1:	50                   	push   %eax
  d2:	68 3c 04 00 00       	push   $0x43c
  d7:	6a 01                	push   $0x1
  d9:	e8 c3 02 00 00       	call   3a1 <write>
      exit();
  de:	e8 9e 02 00 00       	call   381 <exit>
  write(fd, s, strlen(s));
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	68 50 04 00 00       	push   $0x450
  eb:	e8 c0 00 00 00       	call   1b0 <strlen>
  f0:	83 c4 0c             	add    $0xc,%esp
  f3:	50                   	push   %eax
  f4:	68 50 04 00 00       	push   $0x450
  f9:	6a 01                	push   $0x1
  fb:	e8 a1 02 00 00       	call   3a1 <write>
    exit();
 100:	e8 7c 02 00 00       	call   381 <exit>
  write(fd, s, strlen(s));
 105:	83 ec 0c             	sub    $0xc,%esp
 108:	68 74 04 00 00       	push   $0x474
 10d:	e8 9e 00 00 00       	call   1b0 <strlen>
 112:	83 c4 0c             	add    $0xc,%esp
 115:	50                   	push   %eax
 116:	68 74 04 00 00       	push   $0x474
 11b:	6a 01                	push   $0x1
 11d:	e8 7f 02 00 00       	call   3a1 <write>
    exit();
 122:	e8 5a 02 00 00       	call   381 <exit>
 127:	66 90                	xchg   %ax,%ax
 129:	66 90                	xchg   %ax,%ax
 12b:	66 90                	xchg   %ax,%ax
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 130:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 131:	31 d2                	xor    %edx,%edx
{
 133:	89 e5                	mov    %esp,%ebp
 135:	53                   	push   %ebx
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 140:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 144:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 147:	83 c2 01             	add    $0x1,%edx
 14a:	84 c9                	test   %cl,%cl
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	5b                   	pop    %ebx
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    
 151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15f:	90                   	nop

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	56                   	push   %esi
 164:	53                   	push   %ebx
 165:	8b 5d 08             	mov    0x8(%ebp),%ebx
 168:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 16b:	0f b6 13             	movzbl (%ebx),%edx
 16e:	0f b6 0e             	movzbl (%esi),%ecx
 171:	84 d2                	test   %dl,%dl
 173:	74 1e                	je     193 <strcmp+0x33>
 175:	b8 01 00 00 00       	mov    $0x1,%eax
 17a:	38 ca                	cmp    %cl,%dl
 17c:	74 09                	je     187 <strcmp+0x27>
 17e:	eb 20                	jmp    1a0 <strcmp+0x40>
 180:	83 c0 01             	add    $0x1,%eax
 183:	38 ca                	cmp    %cl,%dl
 185:	75 19                	jne    1a0 <strcmp+0x40>
 187:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 18b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 18f:	84 d2                	test   %dl,%dl
 191:	75 ed                	jne    180 <strcmp+0x20>
 193:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 195:	5b                   	pop    %ebx
 196:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 197:	29 c8                	sub    %ecx,%eax
}
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
 19b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 19f:	90                   	nop
 1a0:	0f b6 c2             	movzbl %dl,%eax
 1a3:	5b                   	pop    %ebx
 1a4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 1a5:	29 c8                	sub    %ecx,%eax
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1b6:	80 39 00             	cmpb   $0x0,(%ecx)
 1b9:	74 15                	je     1d0 <strlen+0x20>
 1bb:	31 d2                	xor    %edx,%edx
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
 1c0:	83 c2 01             	add    $0x1,%edx
 1c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1c7:	89 d0                	mov    %edx,%eax
 1c9:	75 f5                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1d0:	31 c0                	xor    %eax,%eax
}
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1df:	90                   	nop

000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	89 d7                	mov    %edx,%edi
 1ef:	fc                   	cld    
 1f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f2:	89 d0                	mov    %edx,%eax
 1f4:	5f                   	pop    %edi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 20a:	0f b6 18             	movzbl (%eax),%ebx
 20d:	84 db                	test   %bl,%bl
 20f:	74 1d                	je     22e <strchr+0x2e>
 211:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 213:	38 d3                	cmp    %dl,%bl
 215:	75 0d                	jne    224 <strchr+0x24>
 217:	eb 17                	jmp    230 <strchr+0x30>
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 220:	38 ca                	cmp    %cl,%dl
 222:	74 0c                	je     230 <strchr+0x30>
  for(; *s; s++)
 224:	83 c0 01             	add    $0x1,%eax
 227:	0f b6 10             	movzbl (%eax),%edx
 22a:	84 d2                	test   %dl,%dl
 22c:	75 f2                	jne    220 <strchr+0x20>
      return (char*)s;
  return 0;
 22e:	31 c0                	xor    %eax,%eax
}
 230:	5b                   	pop    %ebx
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    
 233:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 245:	31 f6                	xor    %esi,%esi
{
 247:	53                   	push   %ebx
 248:	89 f3                	mov    %esi,%ebx
 24a:	83 ec 1c             	sub    $0x1c,%esp
 24d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 250:	eb 2f                	jmp    281 <gets+0x41>
 252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 258:	83 ec 04             	sub    $0x4,%esp
 25b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 25e:	6a 01                	push   $0x1
 260:	50                   	push   %eax
 261:	6a 00                	push   $0x0
 263:	e8 31 01 00 00       	call   399 <read>
    if(cc < 1)
 268:	83 c4 10             	add    $0x10,%esp
 26b:	85 c0                	test   %eax,%eax
 26d:	7e 1c                	jle    28b <gets+0x4b>
      break;
    buf[i++] = c;
 26f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 273:	83 c7 01             	add    $0x1,%edi
 276:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 23                	je     2a0 <gets+0x60>
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 1f                	je     2a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 281:	83 c3 01             	add    $0x1,%ebx
 284:	89 fe                	mov    %edi,%esi
 286:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 289:	7c cd                	jl     258 <gets+0x18>
 28b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 290:	c6 03 00             	movb   $0x0,(%ebx)
}
 293:	8d 65 f4             	lea    -0xc(%ebp),%esp
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop
 2a0:	8b 75 08             	mov    0x8(%ebp),%esi
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	01 de                	add    %ebx,%esi
 2a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 2ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    
 2b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c5:	83 ec 08             	sub    $0x8,%esp
 2c8:	6a 00                	push   $0x0
 2ca:	ff 75 08             	pushl  0x8(%ebp)
 2cd:	e8 ef 00 00 00       	call   3c1 <open>
  if(fd < 0)
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	78 27                	js     300 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	ff 75 0c             	pushl  0xc(%ebp)
 2df:	89 c3                	mov    %eax,%ebx
 2e1:	50                   	push   %eax
 2e2:	e8 f2 00 00 00       	call   3d9 <fstat>
  close(fd);
 2e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ea:	89 c6                	mov    %eax,%esi
  close(fd);
 2ec:	e8 b8 00 00 00       	call   3a9 <close>
  return r;
 2f1:	83 c4 10             	add    $0x10,%esp
}
 2f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2f7:	89 f0                	mov    %esi,%eax
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 300:	be ff ff ff ff       	mov    $0xffffffff,%esi
 305:	eb ed                	jmp    2f4 <stat+0x34>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 11             	movsbl (%ecx),%edx
 31a:	8d 42 d0             	lea    -0x30(%edx),%eax
 31d:	3c 09                	cmp    $0x9,%al
  n = 0;
 31f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 324:	77 1f                	ja     345 <atoi+0x35>
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 330:	83 c1 01             	add    $0x1,%ecx
 333:	8d 04 80             	lea    (%eax,%eax,4),%eax
 336:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 33a:	0f be 11             	movsbl (%ecx),%edx
 33d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	5b                   	pop    %ebx
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    
 348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34f:	90                   	nop

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 55 10             	mov    0x10(%ebp),%edx
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	56                   	push   %esi
 35b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	85 d2                	test   %edx,%edx
 360:	7e 13                	jle    375 <memmove+0x25>
 362:	01 c2                	add    %eax,%edx
  dst = vdst;
 364:	89 c7                	mov    %eax,%edi
 366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 371:	39 fa                	cmp    %edi,%edx
 373:	75 fb                	jne    370 <memmove+0x20>
  return vdst;
}
 375:	5e                   	pop    %esi
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 379:	b8 01 00 00 00       	mov    $0x1,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <exit>:
SYSCALL(exit)
 381:	b8 02 00 00 00       	mov    $0x2,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <wait>:
SYSCALL(wait)
 389:	b8 03 00 00 00       	mov    $0x3,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <pipe>:
SYSCALL(pipe)
 391:	b8 04 00 00 00       	mov    $0x4,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <read>:
SYSCALL(read)
 399:	b8 05 00 00 00       	mov    $0x5,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <write>:
SYSCALL(write)
 3a1:	b8 10 00 00 00       	mov    $0x10,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <close>:
SYSCALL(close)
 3a9:	b8 15 00 00 00       	mov    $0x15,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <kill>:
SYSCALL(kill)
 3b1:	b8 06 00 00 00       	mov    $0x6,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <exec>:
SYSCALL(exec)
 3b9:	b8 07 00 00 00       	mov    $0x7,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <open>:
SYSCALL(open)
 3c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <mknod>:
SYSCALL(mknod)
 3c9:	b8 11 00 00 00       	mov    $0x11,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <unlink>:
SYSCALL(unlink)
 3d1:	b8 12 00 00 00       	mov    $0x12,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <fstat>:
SYSCALL(fstat)
 3d9:	b8 08 00 00 00       	mov    $0x8,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <link>:
SYSCALL(link)
 3e1:	b8 13 00 00 00       	mov    $0x13,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <mkdir>:
SYSCALL(mkdir)
 3e9:	b8 14 00 00 00       	mov    $0x14,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <chdir>:
SYSCALL(chdir)
 3f1:	b8 09 00 00 00       	mov    $0x9,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <dup>:
SYSCALL(dup)
 3f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <getpid>:
SYSCALL(getpid)
 401:	b8 0b 00 00 00       	mov    $0xb,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <sbrk>:
SYSCALL(sbrk)
 409:	b8 0c 00 00 00       	mov    $0xc,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <sleep>:
SYSCALL(sleep)
 411:	b8 0d 00 00 00       	mov    $0xd,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <uptime>:
SYSCALL(uptime)
 419:	b8 0e 00 00 00       	mov    $0xe,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <forkt>:
SYSCALL(forkt)
 421:	b8 16 00 00 00       	mov    $0x16,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <yieldc>:
SYSCALL(yieldc)
 429:	b8 17 00 00 00       	mov    $0x17,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <getcycles1>:
SYSCALL(getcycles1)
 431:	b8 18 00 00 00       	mov    $0x18,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    
