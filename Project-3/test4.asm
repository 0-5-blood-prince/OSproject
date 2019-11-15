
_test4:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }    
    return;
}

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
    int repeat=10;
    int i;
    for(i=0;i<N_PROC;i++)
   7:	31 c0                	xor    %eax,%eax
{
   9:	ff 71 fc             	pushl  -0x4(%ecx)
   c:	55                   	push   %ebp
   d:	89 e5                	mov    %esp,%ebp
   f:	56                   	push   %esi
  10:	53                   	push   %ebx
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
  15:	8d 76 00             	lea    0x0(%esi),%esi
        ticks_stat[i]=0;
  18:	c7 04 85 c0 0d 00 00 	movl   $0x0,0xdc0(,%eax,4)
  1f:	00 00 00 00 
    for(i=0;i<N_PROC;i++)
  23:	83 c0 01             	add    $0x1,%eax
  26:	83 f8 0a             	cmp    $0xa,%eax
  29:	75 ed                	jne    18 <main+0x18>
    
    for(i=0;i<repeat;i++)
  2b:	31 db                	xor    %ebx,%ebx
  2d:	8d 76 00             	lea    0x0(%esi),%esi
    {
        printf(1,"%d\n",i+1);
  30:	83 ec 04             	sub    $0x4,%esp
  33:	83 c3 01             	add    $0x1,%ebx
  36:	53                   	push   %ebx
  37:	68 18 0a 00 00       	push   $0xa18
  3c:	6a 01                	push   $0x1
  3e:	e8 4d 06 00 00       	call   690 <printf>
        master_test(N_PROC);
  43:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  4a:	e8 01 01 00 00       	call   150 <master_test>
    for(i=0;i<repeat;i++)
  4f:	83 c4 10             	add    $0x10,%esp
  52:	83 fb 0a             	cmp    $0xa,%ebx
  55:	75 d9                	jne    30 <main+0x30>
    }

    for(i=0;i<N_PROC;i++)
  57:	31 c9                	xor    %ecx,%ecx
        ticks_stat[i]/=repeat;
  59:	bb 67 66 66 66       	mov    $0x66666667,%ebx
  5e:	66 90                	xchg   %ax,%ax
  60:	8b 34 8d c0 0d 00 00 	mov    0xdc0(,%ecx,4),%esi
  67:	89 f0                	mov    %esi,%eax
  69:	c1 fe 1f             	sar    $0x1f,%esi
  6c:	f7 eb                	imul   %ebx
  6e:	c1 fa 02             	sar    $0x2,%edx
  71:	29 f2                	sub    %esi,%edx
  73:	89 14 8d c0 0d 00 00 	mov    %edx,0xdc0(,%ecx,4)
    for(i=0;i<N_PROC;i++)
  7a:	83 c1 01             	add    $0x1,%ecx
  7d:	83 f9 0a             	cmp    $0xa,%ecx
  80:	75 de                	jne    60 <main+0x60>

    printf(1,"\n");
  82:	83 ec 08             	sub    $0x8,%esp
  85:	68 1a 0a 00 00       	push   $0xa1a
  8a:	6a 01                	push   $0x1
  8c:	e8 ff 05 00 00       	call   690 <printf>
    printf(1,"id,ticket_assigned,ticks\n");
  91:	58                   	pop    %eax
  92:	5a                   	pop    %edx
  93:	68 f8 09 00 00       	push   $0x9f8
  98:	6a 01                	push   $0x1
  9a:	e8 f1 05 00 00       	call   690 <printf>
  9f:	83 c4 10             	add    $0x10,%esp
    for(i=0;i<N_PROC;i++)
  a2:	31 c0                	xor    %eax,%eax
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    i=i+1;
  a8:	8d 58 01             	lea    0x1(%eax),%ebx
        printf(1,"%d,%d,%d\n",i,calculate_tickets(i),ticks_stat[i]);
  ab:	83 ec 0c             	sub    $0xc,%esp
  ae:	ff 34 85 c0 0d 00 00 	pushl  0xdc0(,%eax,4)
     return (i*i);
  b5:	89 da                	mov    %ebx,%edx
  b7:	0f af d3             	imul   %ebx,%edx
        printf(1,"%d,%d,%d\n",i,calculate_tickets(i),ticks_stat[i]);
  ba:	52                   	push   %edx
  bb:	50                   	push   %eax
  bc:	68 12 0a 00 00       	push   $0xa12
  c1:	6a 01                	push   $0x1
  c3:	e8 c8 05 00 00       	call   690 <printf>
  c8:	89 d8                	mov    %ebx,%eax
    for(i=0;i<N_PROC;i++)
  ca:	83 c4 20             	add    $0x20,%esp
  cd:	83 fb 0a             	cmp    $0xa,%ebx
  d0:	75 d6                	jne    a8 <main+0xa8>
        
    printf(1,"Test Complete\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 1c 0a 00 00       	push   $0xa1c
  da:	6a 01                	push   $0x1
  dc:	e8 af 05 00 00       	call   690 <printf>
    exit();
  e1:	e8 2b 04 00 00       	call   511 <exit>
  e6:	66 90                	xchg   %ax,%ax
  e8:	66 90                	xchg   %ax,%ax
  ea:	66 90                	xchg   %ax,%ax
  ec:	66 90                	xchg   %ax,%ax
  ee:	66 90                	xchg   %ax,%ax

000000f0 <yield_inf>:
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	83 ec 08             	sub    $0x8,%esp
  f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fd:	8d 76 00             	lea    0x0(%esi),%esi
        yieldc();
 100:	e8 b4 04 00 00       	call   5b9 <yieldc>
 105:	eb f9                	jmp    100 <yield_inf+0x10>
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax

00000110 <test>:
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 14             	sub    $0x14,%esp
    int pid=forkt(n_tickets);
 116:	ff 75 08             	pushl  0x8(%ebp)
 119:	e8 93 04 00 00       	call   5b1 <forkt>
    if(pid==0)
 11e:	83 c4 10             	add    $0x10,%esp
 121:	85 c0                	test   %eax,%eax
 123:	74 02                	je     127 <test+0x17>
}
 125:	c9                   	leave  
 126:	c3                   	ret    
        yieldc();
 127:	e8 8d 04 00 00       	call   5b9 <yieldc>
        (*fn)();
 12c:	ff 55 0c             	call   *0xc(%ebp)
        exit();
 12f:	e8 dd 03 00 00       	call   511 <exit>
 134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop

00000140 <calculate_tickets>:
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
    i=i+1;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	5d                   	pop    %ebp
    i=i+1;
 147:	83 c0 01             	add    $0x1,%eax
     return (i*i);
 14a:	0f af c0             	imul   %eax,%eax
}
 14d:	c3                   	ret    
 14e:	66 90                	xchg   %ax,%ax

00000150 <master_test>:
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
 156:	83 ec 1c             	sub    $0x1c,%esp
    int child_pids[n_proc];
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	8d 04 85 0f 00 00 00 	lea    0xf(,%eax,4),%eax
 163:	c1 e8 04             	shr    $0x4,%eax
 166:	c1 e0 04             	shl    $0x4,%eax
 169:	29 c4                	sub    %eax,%esp
 16b:	89 e6                	mov    %esp,%esi
    int ticks_prev[n_proc];
 16d:	29 c4                	sub    %eax,%esp
 16f:	89 65 e4             	mov    %esp,-0x1c(%ebp)
    int ticks_curr[n_proc];
 172:	29 c4                	sub    %eax,%esp
    for(i=0;i<n_proc;i++)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
    int ticks_curr[n_proc];
 177:	89 65 e0             	mov    %esp,-0x20(%ebp)
    for(i=0;i<n_proc;i++)
 17a:	85 c0                	test   %eax,%eax
 17c:	0f 8e 0e 01 00 00    	jle    290 <master_test+0x140>
 182:	31 db                	xor    %ebx,%ebx
 184:	eb 0c                	jmp    192 <master_test+0x42>
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	89 fb                	mov    %edi,%ebx
    i=i+1;
 192:	8d 7b 01             	lea    0x1(%ebx),%edi
    int pid=forkt(n_tickets);
 195:	83 ec 0c             	sub    $0xc,%esp
     return (i*i);
 198:	89 f8                	mov    %edi,%eax
 19a:	0f af c7             	imul   %edi,%eax
    int pid=forkt(n_tickets);
 19d:	50                   	push   %eax
 19e:	e8 0e 04 00 00       	call   5b1 <forkt>
    if(pid==0)
 1a3:	83 c4 10             	add    $0x10,%esp
 1a6:	85 c0                	test   %eax,%eax
 1a8:	0f 84 d0 00 00 00    	je     27e <master_test+0x12e>
        child_pids[i]=test( calculate_tickets(i) ,yield_inf);
 1ae:	89 44 be fc          	mov    %eax,-0x4(%esi,%edi,4)
    for(i=0;i<n_proc;i++)
 1b2:	39 7d 08             	cmp    %edi,0x8(%ebp)
 1b5:	75 d9                	jne    190 <master_test+0x40>
    sleep(50);
 1b7:	83 ec 0c             	sub    $0xc,%esp
 1ba:	6a 32                	push   $0x32
 1bc:	e8 e0 03 00 00       	call   5a1 <sleep>
    for(i=0;i<n_proc;i++)
 1c1:	31 d2                	xor    %edx,%edx
    sleep(50);
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	89 d7                	mov    %edx,%edi
 1c8:	eb 08                	jmp    1d2 <master_test+0x82>
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1d0:	89 c7                	mov    %eax,%edi
        ticks_prev[i]=getcycles1(child_pids[i]);
 1d2:	83 ec 0c             	sub    $0xc,%esp
 1d5:	ff 34 be             	pushl  (%esi,%edi,4)
 1d8:	e8 e4 03 00 00       	call   5c1 <getcycles1>
 1dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    for(i=0;i<n_proc;i++)
 1e0:	83 c4 10             	add    $0x10,%esp
        ticks_prev[i]=getcycles1(child_pids[i]);
 1e3:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
    for(i=0;i<n_proc;i++)
 1e6:	8d 47 01             	lea    0x1(%edi),%eax
 1e9:	39 df                	cmp    %ebx,%edi
 1eb:	75 e3                	jne    1d0 <master_test+0x80>
    sleep(100);
 1ed:	83 ec 0c             	sub    $0xc,%esp
 1f0:	6a 64                	push   $0x64
 1f2:	e8 aa 03 00 00       	call   5a1 <sleep>
    for(i=0;i<n_proc;i++)
 1f7:	31 d2                	xor    %edx,%edx
    sleep(100);
 1f9:	83 c4 10             	add    $0x10,%esp
 1fc:	89 d7                	mov    %edx,%edi
 1fe:	eb 02                	jmp    202 <master_test+0xb2>
 200:	89 c7                	mov    %eax,%edi
        ticks_curr[i]=getcycles1(child_pids[i]);
 202:	83 ec 0c             	sub    $0xc,%esp
 205:	ff 34 be             	pushl  (%esi,%edi,4)
 208:	e8 b4 03 00 00       	call   5c1 <getcycles1>
 20d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    for(i=0;i<n_proc;i++)
 210:	83 c4 10             	add    $0x10,%esp
        ticks_curr[i]=getcycles1(child_pids[i]);
 213:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
    for(i=0;i<n_proc;i++)
 216:	8d 47 01             	lea    0x1(%edi),%eax
 219:	39 df                	cmp    %ebx,%edi
 21b:	75 e3                	jne    200 <master_test+0xb0>
    for(i=0;i<n_proc;i++)
 21d:	31 d2                	xor    %edx,%edx
 21f:	89 d7                	mov    %edx,%edi
 221:	eb 07                	jmp    22a <master_test+0xda>
 223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 227:	90                   	nop
 228:	89 c7                	mov    %eax,%edi
        kill(child_pids[i]);
 22a:	83 ec 0c             	sub    $0xc,%esp
 22d:	ff 34 be             	pushl  (%esi,%edi,4)
 230:	e8 0c 03 00 00       	call   541 <kill>
    for(i=0;i<n_proc;i++)
 235:	8d 47 01             	lea    0x1(%edi),%eax
 238:	83 c4 10             	add    $0x10,%esp
 23b:	39 df                	cmp    %ebx,%edi
 23d:	75 e9                	jne    228 <master_test+0xd8>
    for(i=0;i<n_proc;i++)
 23f:	31 f6                	xor    %esi,%esi
 241:	eb 07                	jmp    24a <master_test+0xfa>
 243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 247:	90                   	nop
 248:	89 c6                	mov    %eax,%esi
        wait();    
 24a:	e8 ca 02 00 00       	call   519 <wait>
    for(i=0;i<n_proc;i++)
 24f:	8d 46 01             	lea    0x1(%esi),%eax
 252:	39 de                	cmp    %ebx,%esi
 254:	75 f2                	jne    248 <master_test+0xf8>
    for(i=0;i<n_proc;i++)
 256:	31 c0                	xor    %eax,%eax
 258:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 25b:	8b 75 e0             	mov    -0x20(%ebp),%esi
 25e:	eb 02                	jmp    262 <master_test+0x112>
 260:	89 d0                	mov    %edx,%eax
        ticks_stat[i]+=ticks_curr[i]-ticks_prev[i];
 262:	8b 14 86             	mov    (%esi,%eax,4),%edx
 265:	2b 14 81             	sub    (%ecx,%eax,4),%edx
 268:	01 14 85 c0 0d 00 00 	add    %edx,0xdc0(,%eax,4)
    for(i=0;i<n_proc;i++)
 26f:	8d 50 01             	lea    0x1(%eax),%edx
 272:	39 d8                	cmp    %ebx,%eax
 274:	75 ea                	jne    260 <master_test+0x110>
}
 276:	8d 65 f4             	lea    -0xc(%ebp),%esp
 279:	5b                   	pop    %ebx
 27a:	5e                   	pop    %esi
 27b:	5f                   	pop    %edi
 27c:	5d                   	pop    %ebp
 27d:	c3                   	ret    
        yieldc();
 27e:	e8 36 03 00 00       	call   5b9 <yieldc>
 283:	e8 31 03 00 00       	call   5b9 <yieldc>
        yieldc();
 288:	eb f4                	jmp    27e <master_test+0x12e>
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(50);
 290:	83 ec 0c             	sub    $0xc,%esp
 293:	6a 32                	push   $0x32
 295:	e8 07 03 00 00       	call   5a1 <sleep>
    sleep(100);
 29a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 2a1:	e8 fb 02 00 00       	call   5a1 <sleep>
 2a6:	83 c4 10             	add    $0x10,%esp
}
 2a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ac:	5b                   	pop    %ebx
 2ad:	5e                   	pop    %esi
 2ae:	5f                   	pop    %edi
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    
 2b1:	66 90                	xchg   %ax,%ax
 2b3:	66 90                	xchg   %ax,%ax
 2b5:	66 90                	xchg   %ax,%ax
 2b7:	66 90                	xchg   %ax,%ax
 2b9:	66 90                	xchg   %ax,%ax
 2bb:	66 90                	xchg   %ax,%ax
 2bd:	66 90                	xchg   %ax,%ax
 2bf:	90                   	nop

000002c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c1:	31 d2                	xor    %edx,%edx
{
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	53                   	push   %ebx
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 2d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2d7:	83 c2 01             	add    $0x1,%edx
 2da:	84 c9                	test   %cl,%cl
 2dc:	75 f2                	jne    2d0 <strcpy+0x10>
    ;
  return os;
}
 2de:	5b                   	pop    %ebx
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
 2f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 2fb:	0f b6 13             	movzbl (%ebx),%edx
 2fe:	0f b6 0e             	movzbl (%esi),%ecx
 301:	84 d2                	test   %dl,%dl
 303:	74 1e                	je     323 <strcmp+0x33>
 305:	b8 01 00 00 00       	mov    $0x1,%eax
 30a:	38 ca                	cmp    %cl,%dl
 30c:	74 09                	je     317 <strcmp+0x27>
 30e:	eb 20                	jmp    330 <strcmp+0x40>
 310:	83 c0 01             	add    $0x1,%eax
 313:	38 ca                	cmp    %cl,%dl
 315:	75 19                	jne    330 <strcmp+0x40>
 317:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 31b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 31f:	84 d2                	test   %dl,%dl
 321:	75 ed                	jne    310 <strcmp+0x20>
 323:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 325:	5b                   	pop    %ebx
 326:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 327:	29 c8                	sub    %ecx,%eax
}
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    
 32b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop
 330:	0f b6 c2             	movzbl %dl,%eax
 333:	5b                   	pop    %ebx
 334:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 335:	29 c8                	sub    %ecx,%eax
}
 337:	5d                   	pop    %ebp
 338:	c3                   	ret    
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000340 <strlen>:

uint
strlen(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 346:	80 39 00             	cmpb   $0x0,(%ecx)
 349:	74 15                	je     360 <strlen+0x20>
 34b:	31 d2                	xor    %edx,%edx
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	83 c2 01             	add    $0x1,%edx
 353:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 357:	89 d0                	mov    %edx,%eax
 359:	75 f5                	jne    350 <strlen+0x10>
    ;
  return n;
}
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 360:	31 c0                	xor    %eax,%eax
}
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
 364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 36f:	90                   	nop

00000370 <memset>:

void*
memset(void *dst, int c, uint n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 377:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	89 d7                	mov    %edx,%edi
 37f:	fc                   	cld    
 380:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 382:	89 d0                	mov    %edx,%eax
 384:	5f                   	pop    %edi
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax

00000390 <strchr>:

char*
strchr(const char *s, char c)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 39a:	0f b6 18             	movzbl (%eax),%ebx
 39d:	84 db                	test   %bl,%bl
 39f:	74 1d                	je     3be <strchr+0x2e>
 3a1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 3a3:	38 d3                	cmp    %dl,%bl
 3a5:	75 0d                	jne    3b4 <strchr+0x24>
 3a7:	eb 17                	jmp    3c0 <strchr+0x30>
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b0:	38 ca                	cmp    %cl,%dl
 3b2:	74 0c                	je     3c0 <strchr+0x30>
  for(; *s; s++)
 3b4:	83 c0 01             	add    $0x1,%eax
 3b7:	0f b6 10             	movzbl (%eax),%edx
 3ba:	84 d2                	test   %dl,%dl
 3bc:	75 f2                	jne    3b0 <strchr+0x20>
      return (char*)s;
  return 0;
 3be:	31 c0                	xor    %eax,%eax
}
 3c0:	5b                   	pop    %ebx
 3c1:	5d                   	pop    %ebp
 3c2:	c3                   	ret    
 3c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003d0 <gets>:

char*
gets(char *buf, int max)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d5:	31 f6                	xor    %esi,%esi
{
 3d7:	53                   	push   %ebx
 3d8:	89 f3                	mov    %esi,%ebx
 3da:	83 ec 1c             	sub    $0x1c,%esp
 3dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3e0:	eb 2f                	jmp    411 <gets+0x41>
 3e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3e8:	83 ec 04             	sub    $0x4,%esp
 3eb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3ee:	6a 01                	push   $0x1
 3f0:	50                   	push   %eax
 3f1:	6a 00                	push   $0x0
 3f3:	e8 31 01 00 00       	call   529 <read>
    if(cc < 1)
 3f8:	83 c4 10             	add    $0x10,%esp
 3fb:	85 c0                	test   %eax,%eax
 3fd:	7e 1c                	jle    41b <gets+0x4b>
      break;
    buf[i++] = c;
 3ff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 403:	83 c7 01             	add    $0x1,%edi
 406:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 409:	3c 0a                	cmp    $0xa,%al
 40b:	74 23                	je     430 <gets+0x60>
 40d:	3c 0d                	cmp    $0xd,%al
 40f:	74 1f                	je     430 <gets+0x60>
  for(i=0; i+1 < max; ){
 411:	83 c3 01             	add    $0x1,%ebx
 414:	89 fe                	mov    %edi,%esi
 416:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 419:	7c cd                	jl     3e8 <gets+0x18>
 41b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 420:	c6 03 00             	movb   $0x0,(%ebx)
}
 423:	8d 65 f4             	lea    -0xc(%ebp),%esp
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    
 42b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop
 430:	8b 75 08             	mov    0x8(%ebp),%esi
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	01 de                	add    %ebx,%esi
 438:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 43a:	c6 03 00             	movb   $0x0,(%ebx)
}
 43d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 440:	5b                   	pop    %ebx
 441:	5e                   	pop    %esi
 442:	5f                   	pop    %edi
 443:	5d                   	pop    %ebp
 444:	c3                   	ret    
 445:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <stat>:

int
stat(const char *n, struct stat *st)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 455:	83 ec 08             	sub    $0x8,%esp
 458:	6a 00                	push   $0x0
 45a:	ff 75 08             	pushl  0x8(%ebp)
 45d:	e8 ef 00 00 00       	call   551 <open>
  if(fd < 0)
 462:	83 c4 10             	add    $0x10,%esp
 465:	85 c0                	test   %eax,%eax
 467:	78 27                	js     490 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	ff 75 0c             	pushl  0xc(%ebp)
 46f:	89 c3                	mov    %eax,%ebx
 471:	50                   	push   %eax
 472:	e8 f2 00 00 00       	call   569 <fstat>
  close(fd);
 477:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 47a:	89 c6                	mov    %eax,%esi
  close(fd);
 47c:	e8 b8 00 00 00       	call   539 <close>
  return r;
 481:	83 c4 10             	add    $0x10,%esp
}
 484:	8d 65 f8             	lea    -0x8(%ebp),%esp
 487:	89 f0                	mov    %esi,%eax
 489:	5b                   	pop    %ebx
 48a:	5e                   	pop    %esi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 490:	be ff ff ff ff       	mov    $0xffffffff,%esi
 495:	eb ed                	jmp    484 <stat+0x34>
 497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49e:	66 90                	xchg   %ax,%ax

000004a0 <atoi>:

int
atoi(const char *s)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	53                   	push   %ebx
 4a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a7:	0f be 11             	movsbl (%ecx),%edx
 4aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 4ad:	3c 09                	cmp    $0x9,%al
  n = 0;
 4af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 4b4:	77 1f                	ja     4d5 <atoi+0x35>
 4b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 4c0:	83 c1 01             	add    $0x1,%ecx
 4c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4ca:	0f be 11             	movsbl (%ecx),%edx
 4cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4d0:	80 fb 09             	cmp    $0x9,%bl
 4d3:	76 eb                	jbe    4c0 <atoi+0x20>
  return n;
}
 4d5:	5b                   	pop    %ebx
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret    
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop

000004e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	8b 55 10             	mov    0x10(%ebp),%edx
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	56                   	push   %esi
 4eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ee:	85 d2                	test   %edx,%edx
 4f0:	7e 13                	jle    505 <memmove+0x25>
 4f2:	01 c2                	add    %eax,%edx
  dst = vdst;
 4f4:	89 c7                	mov    %eax,%edi
 4f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 500:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 501:	39 fa                	cmp    %edi,%edx
 503:	75 fb                	jne    500 <memmove+0x20>
  return vdst;
}
 505:	5e                   	pop    %esi
 506:	5f                   	pop    %edi
 507:	5d                   	pop    %ebp
 508:	c3                   	ret    

00000509 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 509:	b8 01 00 00 00       	mov    $0x1,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <exit>:
SYSCALL(exit)
 511:	b8 02 00 00 00       	mov    $0x2,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <wait>:
SYSCALL(wait)
 519:	b8 03 00 00 00       	mov    $0x3,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <pipe>:
SYSCALL(pipe)
 521:	b8 04 00 00 00       	mov    $0x4,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <read>:
SYSCALL(read)
 529:	b8 05 00 00 00       	mov    $0x5,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <write>:
SYSCALL(write)
 531:	b8 10 00 00 00       	mov    $0x10,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <close>:
SYSCALL(close)
 539:	b8 15 00 00 00       	mov    $0x15,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <kill>:
SYSCALL(kill)
 541:	b8 06 00 00 00       	mov    $0x6,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <exec>:
SYSCALL(exec)
 549:	b8 07 00 00 00       	mov    $0x7,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <open>:
SYSCALL(open)
 551:	b8 0f 00 00 00       	mov    $0xf,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <mknod>:
SYSCALL(mknod)
 559:	b8 11 00 00 00       	mov    $0x11,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <unlink>:
SYSCALL(unlink)
 561:	b8 12 00 00 00       	mov    $0x12,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <fstat>:
SYSCALL(fstat)
 569:	b8 08 00 00 00       	mov    $0x8,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <link>:
SYSCALL(link)
 571:	b8 13 00 00 00       	mov    $0x13,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <mkdir>:
SYSCALL(mkdir)
 579:	b8 14 00 00 00       	mov    $0x14,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <chdir>:
SYSCALL(chdir)
 581:	b8 09 00 00 00       	mov    $0x9,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <dup>:
SYSCALL(dup)
 589:	b8 0a 00 00 00       	mov    $0xa,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <getpid>:
SYSCALL(getpid)
 591:	b8 0b 00 00 00       	mov    $0xb,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <sbrk>:
SYSCALL(sbrk)
 599:	b8 0c 00 00 00       	mov    $0xc,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <sleep>:
SYSCALL(sleep)
 5a1:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <uptime>:
SYSCALL(uptime)
 5a9:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <forkt>:
SYSCALL(forkt)
 5b1:	b8 16 00 00 00       	mov    $0x16,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <yieldc>:
SYSCALL(yieldc)
 5b9:	b8 17 00 00 00       	mov    $0x17,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <getcycles1>:
SYSCALL(getcycles1)
 5c1:	b8 18 00 00 00       	mov    $0x18,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    
 5c9:	66 90                	xchg   %ax,%ax
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5d6:	89 d3                	mov    %edx,%ebx
{
 5d8:	83 ec 3c             	sub    $0x3c,%esp
 5db:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 5de:	85 d2                	test   %edx,%edx
 5e0:	0f 89 92 00 00 00    	jns    678 <printint+0xa8>
 5e6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ea:	0f 84 88 00 00 00    	je     678 <printint+0xa8>
    neg = 1;
 5f0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 5f7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 5f9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 600:	8d 75 d7             	lea    -0x29(%ebp),%esi
 603:	eb 08                	jmp    60d <printint+0x3d>
 605:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 608:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 60b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 60d:	89 d8                	mov    %ebx,%eax
 60f:	31 d2                	xor    %edx,%edx
 611:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 614:	f7 f1                	div    %ecx
 616:	83 c7 01             	add    $0x1,%edi
 619:	0f b6 92 38 0a 00 00 	movzbl 0xa38(%edx),%edx
 620:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 623:	39 d9                	cmp    %ebx,%ecx
 625:	76 e1                	jbe    608 <printint+0x38>
  if(neg)
 627:	8b 45 c0             	mov    -0x40(%ebp),%eax
 62a:	85 c0                	test   %eax,%eax
 62c:	74 0d                	je     63b <printint+0x6b>
    buf[i++] = '-';
 62e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 633:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 638:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 63b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 63e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 641:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 645:	eb 0f                	jmp    656 <printint+0x86>
 647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64e:	66 90                	xchg   %ax,%ax
 650:	0f b6 13             	movzbl (%ebx),%edx
 653:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 656:	83 ec 04             	sub    $0x4,%esp
 659:	88 55 d7             	mov    %dl,-0x29(%ebp)
 65c:	6a 01                	push   $0x1
 65e:	56                   	push   %esi
 65f:	57                   	push   %edi
 660:	e8 cc fe ff ff       	call   531 <write>

  while(--i >= 0)
 665:	83 c4 10             	add    $0x10,%esp
 668:	39 de                	cmp    %ebx,%esi
 66a:	75 e4                	jne    650 <printint+0x80>
    putc(fd, buf[i]);
}
 66c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 678:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 67f:	e9 75 ff ff ff       	jmp    5f9 <printint+0x29>
 684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop

00000690 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 699:	8b 75 0c             	mov    0xc(%ebp),%esi
 69c:	0f b6 1e             	movzbl (%esi),%ebx
 69f:	84 db                	test   %bl,%bl
 6a1:	0f 84 b9 00 00 00    	je     760 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 6a7:	8d 45 10             	lea    0x10(%ebp),%eax
 6aa:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6ad:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6b0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 6b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b5:	eb 38                	jmp    6ef <printf+0x5f>
 6b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6be:	66 90                	xchg   %ax,%ax
 6c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6c3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	74 17                	je     6e4 <printf+0x54>
  write(fd, &c, 1);
 6cd:	83 ec 04             	sub    $0x4,%esp
 6d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6d3:	6a 01                	push   $0x1
 6d5:	57                   	push   %edi
 6d6:	ff 75 08             	pushl  0x8(%ebp)
 6d9:	e8 53 fe ff ff       	call   531 <write>
 6de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6e1:	83 c4 10             	add    $0x10,%esp
 6e4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 6e7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6eb:	84 db                	test   %bl,%bl
 6ed:	74 71                	je     760 <printf+0xd0>
    c = fmt[i] & 0xff;
 6ef:	0f be cb             	movsbl %bl,%ecx
 6f2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6f5:	85 d2                	test   %edx,%edx
 6f7:	74 c7                	je     6c0 <printf+0x30>
      }
    } else if(state == '%'){
 6f9:	83 fa 25             	cmp    $0x25,%edx
 6fc:	75 e6                	jne    6e4 <printf+0x54>
      if(c == 'd'){
 6fe:	83 f8 64             	cmp    $0x64,%eax
 701:	0f 84 99 00 00 00    	je     7a0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 707:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 70d:	83 f9 70             	cmp    $0x70,%ecx
 710:	74 5e                	je     770 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 712:	83 f8 73             	cmp    $0x73,%eax
 715:	0f 84 d5 00 00 00    	je     7f0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71b:	83 f8 63             	cmp    $0x63,%eax
 71e:	0f 84 8c 00 00 00    	je     7b0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 724:	83 f8 25             	cmp    $0x25,%eax
 727:	0f 84 b3 00 00 00    	je     7e0 <printf+0x150>
  write(fd, &c, 1);
 72d:	83 ec 04             	sub    $0x4,%esp
 730:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 734:	6a 01                	push   $0x1
 736:	57                   	push   %edi
 737:	ff 75 08             	pushl  0x8(%ebp)
 73a:	e8 f2 fd ff ff       	call   531 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 73f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 742:	83 c4 0c             	add    $0xc,%esp
 745:	6a 01                	push   $0x1
 747:	83 c6 01             	add    $0x1,%esi
 74a:	57                   	push   %edi
 74b:	ff 75 08             	pushl  0x8(%ebp)
 74e:	e8 de fd ff ff       	call   531 <write>
  for(i = 0; fmt[i]; i++){
 753:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 757:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 75a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 75c:	84 db                	test   %bl,%bl
 75e:	75 8f                	jne    6ef <printf+0x5f>
    }
  }
}
 760:	8d 65 f4             	lea    -0xc(%ebp),%esp
 763:	5b                   	pop    %ebx
 764:	5e                   	pop    %esi
 765:	5f                   	pop    %edi
 766:	5d                   	pop    %ebp
 767:	c3                   	ret    
 768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
        printint(fd, *ap, 16, 0);
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	b9 10 00 00 00       	mov    $0x10,%ecx
 778:	6a 00                	push   $0x0
 77a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	8b 13                	mov    (%ebx),%edx
 782:	e8 49 fe ff ff       	call   5d0 <printint>
        ap++;
 787:	89 d8                	mov    %ebx,%eax
 789:	83 c4 10             	add    $0x10,%esp
      state = 0;
 78c:	31 d2                	xor    %edx,%edx
        ap++;
 78e:	83 c0 04             	add    $0x4,%eax
 791:	89 45 d0             	mov    %eax,-0x30(%ebp)
 794:	e9 4b ff ff ff       	jmp    6e4 <printf+0x54>
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7a8:	6a 01                	push   $0x1
 7aa:	eb ce                	jmp    77a <printf+0xea>
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 7b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7b6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 7b8:	6a 01                	push   $0x1
        ap++;
 7ba:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 7bd:	57                   	push   %edi
 7be:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 7c1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7c4:	e8 68 fd ff ff       	call   531 <write>
        ap++;
 7c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7cf:	31 d2                	xor    %edx,%edx
 7d1:	e9 0e ff ff ff       	jmp    6e4 <printf+0x54>
 7d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 7e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7e3:	83 ec 04             	sub    $0x4,%esp
 7e6:	e9 5a ff ff ff       	jmp    745 <printf+0xb5>
 7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
        s = (char*)*ap;
 7f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7f3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7f5:	83 c0 04             	add    $0x4,%eax
 7f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7fb:	85 db                	test   %ebx,%ebx
 7fd:	74 17                	je     816 <printf+0x186>
        while(*s != 0){
 7ff:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 802:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 804:	84 c0                	test   %al,%al
 806:	0f 84 d8 fe ff ff    	je     6e4 <printf+0x54>
 80c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 80f:	89 de                	mov    %ebx,%esi
 811:	8b 5d 08             	mov    0x8(%ebp),%ebx
 814:	eb 1a                	jmp    830 <printf+0x1a0>
          s = "(null)";
 816:	bb 30 0a 00 00       	mov    $0xa30,%ebx
        while(*s != 0){
 81b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 81e:	b8 28 00 00 00       	mov    $0x28,%eax
 823:	89 de                	mov    %ebx,%esi
 825:	8b 5d 08             	mov    0x8(%ebp),%ebx
 828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82f:	90                   	nop
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
          s++;
 833:	83 c6 01             	add    $0x1,%esi
 836:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 839:	6a 01                	push   $0x1
 83b:	57                   	push   %edi
 83c:	53                   	push   %ebx
 83d:	e8 ef fc ff ff       	call   531 <write>
        while(*s != 0){
 842:	0f b6 06             	movzbl (%esi),%eax
 845:	83 c4 10             	add    $0x10,%esp
 848:	84 c0                	test   %al,%al
 84a:	75 e4                	jne    830 <printf+0x1a0>
 84c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 84f:	31 d2                	xor    %edx,%edx
 851:	e9 8e fe ff ff       	jmp    6e4 <printf+0x54>
 856:	66 90                	xchg   %ax,%ax
 858:	66 90                	xchg   %ax,%ax
 85a:	66 90                	xchg   %ax,%ax
 85c:	66 90                	xchg   %ax,%ax
 85e:	66 90                	xchg   %ax,%ax

00000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	a1 a0 0d 00 00       	mov    0xda0,%eax
{
 866:	89 e5                	mov    %esp,%ebp
 868:	57                   	push   %edi
 869:	56                   	push   %esi
 86a:	53                   	push   %ebx
 86b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 86e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 870:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 873:	39 c8                	cmp    %ecx,%eax
 875:	73 19                	jae    890 <free+0x30>
 877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87e:	66 90                	xchg   %ax,%ax
 880:	39 d1                	cmp    %edx,%ecx
 882:	72 14                	jb     898 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	39 d0                	cmp    %edx,%eax
 886:	73 10                	jae    898 <free+0x38>
{
 888:	89 d0                	mov    %edx,%eax
 88a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88c:	39 c8                	cmp    %ecx,%eax
 88e:	72 f0                	jb     880 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	39 d0                	cmp    %edx,%eax
 892:	72 f4                	jb     888 <free+0x28>
 894:	39 d1                	cmp    %edx,%ecx
 896:	73 f0                	jae    888 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 898:	8b 73 fc             	mov    -0x4(%ebx),%esi
 89b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 89e:	39 fa                	cmp    %edi,%edx
 8a0:	74 1e                	je     8c0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8a5:	8b 50 04             	mov    0x4(%eax),%edx
 8a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8ab:	39 f1                	cmp    %esi,%ecx
 8ad:	74 28                	je     8d7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8af:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 8b1:	5b                   	pop    %ebx
  freep = p;
 8b2:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 8b7:	5e                   	pop    %esi
 8b8:	5f                   	pop    %edi
 8b9:	5d                   	pop    %ebp
 8ba:	c3                   	ret    
 8bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 8c0:	03 72 04             	add    0x4(%edx),%esi
 8c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 12                	mov    (%edx),%edx
 8ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8cd:	8b 50 04             	mov    0x4(%eax),%edx
 8d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d3:	39 f1                	cmp    %esi,%ecx
 8d5:	75 d8                	jne    8af <free+0x4f>
    p->s.size += bp->s.size;
 8d7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8da:	a3 a0 0d 00 00       	mov    %eax,0xda0
    p->s.size += bp->s.size;
 8df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8e5:	89 10                	mov    %edx,(%eax)
}
 8e7:	5b                   	pop    %ebx
 8e8:	5e                   	pop    %esi
 8e9:	5f                   	pop    %edi
 8ea:	5d                   	pop    %ebp
 8eb:	c3                   	ret    
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	57                   	push   %edi
 8f4:	56                   	push   %esi
 8f5:	53                   	push   %ebx
 8f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8fc:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	8d 70 07             	lea    0x7(%eax),%esi
 905:	c1 ee 03             	shr    $0x3,%esi
 908:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 90b:	85 ff                	test   %edi,%edi
 90d:	0f 84 ad 00 00 00    	je     9c0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 913:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 915:	8b 4a 04             	mov    0x4(%edx),%ecx
 918:	39 f1                	cmp    %esi,%ecx
 91a:	73 72                	jae    98e <malloc+0x9e>
 91c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 922:	bb 00 10 00 00       	mov    $0x1000,%ebx
 927:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 92a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 934:	eb 1b                	jmp    951 <malloc+0x61>
 936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 942:	8b 48 04             	mov    0x4(%eax),%ecx
 945:	39 f1                	cmp    %esi,%ecx
 947:	73 4f                	jae    998 <malloc+0xa8>
 949:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 94f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 951:	39 d7                	cmp    %edx,%edi
 953:	75 eb                	jne    940 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 955:	83 ec 0c             	sub    $0xc,%esp
 958:	ff 75 e4             	pushl  -0x1c(%ebp)
 95b:	e8 39 fc ff ff       	call   599 <sbrk>
  if(p == (char*)-1)
 960:	83 c4 10             	add    $0x10,%esp
 963:	83 f8 ff             	cmp    $0xffffffff,%eax
 966:	74 1c                	je     984 <malloc+0x94>
  hp->s.size = nu;
 968:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 96b:	83 ec 0c             	sub    $0xc,%esp
 96e:	83 c0 08             	add    $0x8,%eax
 971:	50                   	push   %eax
 972:	e8 e9 fe ff ff       	call   860 <free>
  return freep;
 977:	8b 15 a0 0d 00 00    	mov    0xda0,%edx
      if((p = morecore(nunits)) == 0)
 97d:	83 c4 10             	add    $0x10,%esp
 980:	85 d2                	test   %edx,%edx
 982:	75 bc                	jne    940 <malloc+0x50>
        return 0;
  }
}
 984:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 987:	31 c0                	xor    %eax,%eax
}
 989:	5b                   	pop    %ebx
 98a:	5e                   	pop    %esi
 98b:	5f                   	pop    %edi
 98c:	5d                   	pop    %ebp
 98d:	c3                   	ret    
    if(p->s.size >= nunits){
 98e:	89 d0                	mov    %edx,%eax
 990:	89 fa                	mov    %edi,%edx
 992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 998:	39 ce                	cmp    %ecx,%esi
 99a:	74 54                	je     9f0 <malloc+0x100>
        p->s.size -= nunits;
 99c:	29 f1                	sub    %esi,%ecx
 99e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9a1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9a4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 9a7:	89 15 a0 0d 00 00    	mov    %edx,0xda0
}
 9ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9b0:	83 c0 08             	add    $0x8,%eax
}
 9b3:	5b                   	pop    %ebx
 9b4:	5e                   	pop    %esi
 9b5:	5f                   	pop    %edi
 9b6:	5d                   	pop    %ebp
 9b7:	c3                   	ret    
 9b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9bf:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 9c0:	c7 05 a0 0d 00 00 a4 	movl   $0xda4,0xda0
 9c7:	0d 00 00 
    base.s.size = 0;
 9ca:	bf a4 0d 00 00       	mov    $0xda4,%edi
    base.s.ptr = freep = prevp = &base;
 9cf:	c7 05 a4 0d 00 00 a4 	movl   $0xda4,0xda4
 9d6:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 9db:	c7 05 a8 0d 00 00 00 	movl   $0x0,0xda8
 9e2:	00 00 00 
    if(p->s.size >= nunits){
 9e5:	e9 32 ff ff ff       	jmp    91c <malloc+0x2c>
 9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9f0:	8b 08                	mov    (%eax),%ecx
 9f2:	89 0a                	mov    %ecx,(%edx)
 9f4:	eb b1                	jmp    9a7 <malloc+0xb7>
