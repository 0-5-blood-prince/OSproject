
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2f 10 80       	mov    $0x80102fa0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 d5 42 00 00       	call   80104330 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 63 41 00 00       	call   80104200 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 a7 43 00 00       	call   80104490 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 e9 43 00 00       	call   80104550 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 40 00 00       	call   80104240 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 20 00 00       	call   801021f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 6f 10 80       	push   $0x80106fce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 1d 41 00 00       	call   801042e0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 20 00 00       	jmp    801021f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 6f 10 80       	push   $0x80106fdf
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 40 00 00       	call   801042e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 40 00 00       	call   801042a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010021b:	e8 70 42 00 00       	call   80104490 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 df 42 00 00       	jmp    80104550 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 6f 10 80       	push   $0x80106fe6
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 5c 15 00 00       	call   801017f0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 f0 41 00 00       	call   80104490 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002ba:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002d5:	e8 d6 3b 00 00       	call   80103eb0 <sleep>
    while(input.r == input.w){
801002da:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 00 36 00 00       	call   801038f0 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 4c 42 00 00       	call   80104550 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 03 14 00 00       	call   80101710 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 ee 41 00 00       	call   80104550 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 a5 13 00 00       	call   80101710 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 72 24 00 00       	call   80102820 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 6f 10 80       	push   $0x80106fed
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 3f 79 10 80 	movl   $0x8010793f,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 3f 00 00       	call   80104350 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 70 10 80       	push   $0x80107001
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 57 00 00       	call   80105be0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 56 00 00       	call   80105be0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 56 00 00       	call   80105be0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 56 00 00       	call   80105be0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 da 40 00 00       	call   80104640 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 40 00 00       	call   801045a0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 70 10 80       	push   $0x80107005
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 a9 11 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 3d 3e 00 00       	call   80104490 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068f:	90                   	nop
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 b3 3e 00 00       	call   80104550 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 6a 10 00 00       	call   80101710 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100727:	90                   	nop
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
    switch(c){
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 18 70 10 80       	mov    $0x80107018,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 db 3c 00 00       	call   80104490 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 23 3d 00 00       	call   80104550 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 70 10 80       	push   $0x8010701f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 18 3c 00 00       	call   80104490 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008a0:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
    switch(c){
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d c8 ff 10 80    	mov    %ecx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 40 ff 10 80    	mov    %bl,-0x7fef00c0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010095a:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100999:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 84 3b 00 00       	call   80104550 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100a07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100a0c:	e8 4f 36 00 00       	call   80104060 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 1b 37 00 00       	jmp    80104140 <procdump>
80100a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 28 70 10 80       	push   $0x80107028
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 eb 38 00 00       	call   80104330 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 8c 09 11 80 30 	movl   $0x80100630,0x8011098c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 88 09 11 80 80 	movl   $0x80100280,0x80110988
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 32 19 00 00       	call   801023a0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 5f 2e 00 00       	call   801038f0 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 f4 21 00 00       	call   80102c90 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 09 15 00 00       	call   80101fb0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 02 03 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 53 0c 00 00       	call   80101710 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 22 0f 00 00       	call   801019f0 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 c1 0e 00 00       	call   801019a0 <iunlockput>
    end_op();
80100adf:	e8 1c 22 00 00       	call   80102d00 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 27 62 00 00       	call   80106d30 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 ac 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 d8 5f 00 00       	call   80106b50 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 e2 5e 00 00       	call   80106a90 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 1a 0e 00 00       	call   801019f0 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 c0 60 00 00       	call   80106cb0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 7f 0d 00 00       	call   801019a0 <iunlockput>
  end_op();
80100c21:	e8 da 20 00 00       	call   80102d00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 19 5f 00 00       	call   80106b50 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 78 61 00 00       	call   80106dd0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 08 3b 00 00       	call   801047b0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 f5 3a 00 00       	call   801047b0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 62 00 00       	call   80106f30 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 5f 00 00       	call   80106cb0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 f8 61 00 00       	call   80106f30 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 fa 39 00 00       	call   80104770 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 5e 5b 00 00       	call   80106900 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 06 5f 00 00       	call   80106cb0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 47 1f 00 00       	call   80102d00 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 41 70 10 80       	push   $0x80107041
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 19 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 4d 70 10 80       	push   $0x8010704d
80100deb:	68 e0 ff 10 80       	push   $0x8010ffe0
80100df0:	e8 3b 35 00 00       	call   80104330 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e11:	e8 7a 36 00 00       	call   80104490 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e41:	e8 0a 37 00 00       	call   80104550 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e5a:	e8 f1 36 00 00       	call   80104550 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e7f:	e8 0c 36 00 00       	call   80104490 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e9c:	e8 af 36 00 00       	call   80104550 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 54 70 10 80       	push   $0x80107054
80100eb0:	e8 db f4 ff ff       	call   80100390 <panic>
80100eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100ed1:	e8 ba 35 00 00       	call   80104490 <acquire>
  if(f->ref < 1)
80100ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e a3 00 00 00    	jle    80100f87 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	89 43 04             	mov    %eax,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 3f 36 00 00       	call   80104550 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 2f                	je     80100f48 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 4a                	je     80100f68 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 0d 36 00 00       	jmp    80104550 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 ea 24 00 00       	call   80103440 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5c:	5b                   	pop    %ebx
80100f5d:	5e                   	pop    %esi
80100f5e:	5f                   	pop    %edi
80100f5f:	5d                   	pop    %ebp
80100f60:	c3                   	ret    
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f68:	e8 23 1d 00 00       	call   80102c90 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 c8 08 00 00       	call   80101840 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 79 1d 00 00       	jmp    80102d00 <end_op>
    panic("fileclose");
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	68 5c 70 10 80       	push   $0x8010705c
80100f8f:	e8 fc f3 ff ff       	call   80100390 <panic>
80100f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 56 07 00 00       	call   80101710 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 f9 09 00 00       	call   801019c0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 20 08 00 00       	call   801017f0 <iunlock>
    return 0;
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 f1 06 00 00       	call   80101710 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 c4 09 00 00       	call   801019f0 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 ad 07 00 00       	call   801017f0 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 8e 25 00 00       	jmp    801035f0 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 66 70 10 80       	push   $0x80107066
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bb 00 00 00    	je     8010115d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 03                	mov    (%ebx),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 73 10             	pushl  0x10(%ebx)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 17 07 00 00       	call   801017f0 <iunlock>
      end_op();
801010d9:	e8 22 1c 00 00       	call   80102d00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 f0                	cmp    %esi,%eax
801010e6:	75 60                	jne    80101148 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010e8:	01 c7                	add    %eax,%edi
    while(i < n){
801010ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 fe                	sub    %edi,%esi
      if(n1 > max)
801010f9:	81 fe 00 06 00 00    	cmp    $0x600,%esi
801010ff:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101102:	e8 89 1b 00 00       	call   80102c90 <begin_op>
      ilock(f->ip);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 73 10             	pushl  0x10(%ebx)
8010110d:	e8 fe 05 00 00       	call   80101710 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101112:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101115:	56                   	push   %esi
80101116:	ff 73 14             	pushl  0x14(%ebx)
80101119:	01 f8                	add    %edi,%eax
8010111b:	50                   	push   %eax
8010111c:	ff 73 10             	pushl  0x10(%ebx)
8010111f:	e8 cc 09 00 00       	call   80101af0 <writei>
80101124:	83 c4 20             	add    $0x20,%esp
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 9d                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 73 10             	pushl  0x10(%ebx)
80101131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101134:	e8 b7 06 00 00       	call   801017f0 <iunlock>
      end_op();
80101139:	e8 c2 1b 00 00       	call   80102d00 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 15                	jne    8010115d <filewrite+0xdd>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 6f 70 10 80       	push   $0x8010706f
80101150:	e8 3b f2 ff ff       	call   80100390 <panic>
80101155:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101158:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010115b:	74 05                	je     80101162 <filewrite+0xe2>
8010115d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	89 f8                	mov    %edi,%eax
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 62 23 00 00       	jmp    801034e0 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 75 70 10 80       	push   $0x80107075
80101186:	e8 05 f2 ff ff       	call   80100390 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	56                   	push   %esi
80101194:	53                   	push   %ebx
80101195:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101197:	c1 ea 0c             	shr    $0xc,%edx
8010119a:	03 15 f8 09 11 80    	add    0x801109f8,%edx
801011a0:	83 ec 08             	sub    $0x8,%esp
801011a3:	52                   	push   %edx
801011a4:	50                   	push   %eax
801011a5:	e8 26 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011aa:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011ac:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011af:	ba 01 00 00 00       	mov    $0x1,%edx
801011b4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011b7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011bd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011c0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011c2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011c7:	85 d1                	test   %edx,%ecx
801011c9:	74 25                	je     801011f0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011cb:	f7 d2                	not    %edx
801011cd:	89 c6                	mov    %eax,%esi
  log_write(bp);
801011cf:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801011d2:	21 ca                	and    %ecx,%edx
801011d4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801011d8:	56                   	push   %esi
801011d9:	e8 92 1c 00 00       	call   80102e70 <log_write>
  brelse(bp);
801011de:	89 34 24             	mov    %esi,(%esp)
801011e1:	e8 0a f0 ff ff       	call   801001f0 <brelse>
}
801011e6:	83 c4 10             	add    $0x10,%esp
801011e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011ec:	5b                   	pop    %ebx
801011ed:	5e                   	pop    %esi
801011ee:	5d                   	pop    %ebp
801011ef:	c3                   	ret    
    panic("freeing free block");
801011f0:	83 ec 0c             	sub    $0xc,%esp
801011f3:	68 7f 70 10 80       	push   $0x8010707f
801011f8:	e8 93 f1 ff ff       	call   80100390 <panic>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi

80101200 <balloc>:
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101209:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010120f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101212:	85 c9                	test   %ecx,%ecx
80101214:	0f 84 87 00 00 00    	je     801012a1 <balloc+0xa1>
8010121a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101221:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	89 f0                	mov    %esi,%eax
80101229:	c1 f8 0c             	sar    $0xc,%eax
8010122c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101232:	50                   	push   %eax
80101233:	ff 75 d8             	pushl  -0x28(%ebp)
80101236:	e8 95 ee ff ff       	call   801000d0 <bread>
8010123b:	83 c4 10             	add    $0x10,%esp
8010123e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101241:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101246:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101249:	31 c0                	xor    %eax,%eax
8010124b:	eb 2f                	jmp    8010127c <balloc+0x7c>
8010124d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101250:	89 c1                	mov    %eax,%ecx
80101252:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101257:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010125a:	83 e1 07             	and    $0x7,%ecx
8010125d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010125f:	89 c1                	mov    %eax,%ecx
80101261:	c1 f9 03             	sar    $0x3,%ecx
80101264:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101269:	89 fa                	mov    %edi,%edx
8010126b:	85 df                	test   %ebx,%edi
8010126d:	74 41                	je     801012b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126f:	83 c0 01             	add    $0x1,%eax
80101272:	83 c6 01             	add    $0x1,%esi
80101275:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010127a:	74 05                	je     80101281 <balloc+0x81>
8010127c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010127f:	77 cf                	ja     80101250 <balloc+0x50>
    brelse(bp);
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	ff 75 e4             	pushl  -0x1c(%ebp)
80101287:	e8 64 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010128c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101293:	83 c4 10             	add    $0x10,%esp
80101296:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101299:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010129f:	77 80                	ja     80101221 <balloc+0x21>
  panic("balloc: out of blocks");
801012a1:	83 ec 0c             	sub    $0xc,%esp
801012a4:	68 92 70 10 80       	push   $0x80107092
801012a9:	e8 e2 f0 ff ff       	call   80100390 <panic>
801012ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012b6:	09 da                	or     %ebx,%edx
801012b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012bc:	57                   	push   %edi
801012bd:	e8 ae 1b 00 00       	call   80102e70 <log_write>
        brelse(bp);
801012c2:	89 3c 24             	mov    %edi,(%esp)
801012c5:	e8 26 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012ca:	58                   	pop    %eax
801012cb:	5a                   	pop    %edx
801012cc:	56                   	push   %esi
801012cd:	ff 75 d8             	pushl  -0x28(%ebp)
801012d0:	e8 fb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012da:	8d 40 5c             	lea    0x5c(%eax),%eax
801012dd:	68 00 02 00 00       	push   $0x200
801012e2:	6a 00                	push   $0x0
801012e4:	50                   	push   %eax
801012e5:	e8 b6 32 00 00       	call   801045a0 <memset>
  log_write(bp);
801012ea:	89 1c 24             	mov    %ebx,(%esp)
801012ed:	e8 7e 1b 00 00       	call   80102e70 <log_write>
  brelse(bp);
801012f2:	89 1c 24             	mov    %ebx,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	89 f0                	mov    %esi,%eax
801012ff:	5b                   	pop    %ebx
80101300:	5e                   	pop    %esi
80101301:	5f                   	pop    %edi
80101302:	5d                   	pop    %ebp
80101303:	c3                   	ret    
80101304:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010130b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010130f:	90                   	nop

80101310 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	89 c7                	mov    %eax,%edi
80101316:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101317:	31 f6                	xor    %esi,%esi
{
80101319:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010131f:	83 ec 28             	sub    $0x28,%esp
80101322:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101325:	68 00 0a 11 80       	push   $0x80110a00
8010132a:	e8 61 31 00 00       	call   80104490 <acquire>
8010132f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101332:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101335:	eb 1b                	jmp    80101352 <iget+0x42>
80101337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 3b                	cmp    %edi,(%ebx)
80101342:	74 6c                	je     801013b0 <iget+0xa0>
80101344:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101350:	73 26                	jae    80101378 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101352:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101355:	85 c9                	test   %ecx,%ecx
80101357:	7f e7                	jg     80101340 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101359:	85 f6                	test   %esi,%esi
8010135b:	75 e7                	jne    80101344 <iget+0x34>
8010135d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101363:	85 c9                	test   %ecx,%ecx
80101365:	75 70                	jne    801013d7 <iget+0xc7>
80101367:	89 de                	mov    %ebx,%esi
80101369:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136b:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101371:	72 df                	jb     80101352 <iget+0x42>
80101373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101377:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101378:	85 f6                	test   %esi,%esi
8010137a:	74 74                	je     801013f0 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010137c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010137f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101381:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101384:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010138b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101392:	68 00 0a 11 80       	push   $0x80110a00
80101397:	e8 b4 31 00 00       	call   80104550 <release>

  return ip;
8010139c:	83 c4 10             	add    $0x10,%esp
}
8010139f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a2:	89 f0                	mov    %esi,%eax
801013a4:	5b                   	pop    %ebx
801013a5:	5e                   	pop    %esi
801013a6:	5f                   	pop    %edi
801013a7:	5d                   	pop    %ebp
801013a8:	c3                   	ret    
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013b3:	75 8f                	jne    80101344 <iget+0x34>
      release(&icache.lock);
801013b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013b8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013bb:	89 de                	mov    %ebx,%esi
      ip->ref++;
801013bd:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013c0:	68 00 0a 11 80       	push   $0x80110a00
801013c5:	e8 86 31 00 00       	call   80104550 <release>
      return ip;
801013ca:	83 c4 10             	add    $0x10,%esp
}
801013cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d0:	89 f0                	mov    %esi,%eax
801013d2:	5b                   	pop    %ebx
801013d3:	5e                   	pop    %esi
801013d4:	5f                   	pop    %edi
801013d5:	5d                   	pop    %ebp
801013d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013d7:	3d 54 26 11 80       	cmp    $0x80112654,%eax
801013dc:	73 12                	jae    801013f0 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013de:	8b 48 08             	mov    0x8(%eax),%ecx
801013e1:	89 c3                	mov    %eax,%ebx
801013e3:	85 c9                	test   %ecx,%ecx
801013e5:	0f 8f 55 ff ff ff    	jg     80101340 <iget+0x30>
801013eb:	e9 6d ff ff ff       	jmp    8010135d <iget+0x4d>
    panic("iget: no inodes");
801013f0:	83 ec 0c             	sub    $0xc,%esp
801013f3:	68 a8 70 10 80       	push   $0x801070a8
801013f8:	e8 93 ef ff ff       	call   80100390 <panic>
801013fd:	8d 76 00             	lea    0x0(%esi),%esi

80101400 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	56                   	push   %esi
80101405:	89 c6                	mov    %eax,%esi
80101407:	53                   	push   %ebx
80101408:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010140b:	83 fa 0b             	cmp    $0xb,%edx
8010140e:	0f 86 84 00 00 00    	jbe    80101498 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101414:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101417:	83 fb 7f             	cmp    $0x7f,%ebx
8010141a:	0f 87 98 00 00 00    	ja     801014b8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101420:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101426:	8b 00                	mov    (%eax),%eax
80101428:	85 d2                	test   %edx,%edx
8010142a:	74 54                	je     80101480 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010142c:	83 ec 08             	sub    $0x8,%esp
8010142f:	52                   	push   %edx
80101430:	50                   	push   %eax
80101431:	e8 9a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101436:	83 c4 10             	add    $0x10,%esp
80101439:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010143d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010143f:	8b 1a                	mov    (%edx),%ebx
80101441:	85 db                	test   %ebx,%ebx
80101443:	74 1b                	je     80101460 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	57                   	push   %edi
80101449:	e8 a2 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010144e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101454:	89 d8                	mov    %ebx,%eax
80101456:	5b                   	pop    %ebx
80101457:	5e                   	pop    %esi
80101458:	5f                   	pop    %edi
80101459:	5d                   	pop    %ebp
8010145a:	c3                   	ret    
8010145b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010145f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101460:	8b 06                	mov    (%esi),%eax
80101462:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101465:	e8 96 fd ff ff       	call   80101200 <balloc>
8010146a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010146d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101470:	89 c3                	mov    %eax,%ebx
80101472:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101474:	57                   	push   %edi
80101475:	e8 f6 19 00 00       	call   80102e70 <log_write>
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	eb c6                	jmp    80101445 <bmap+0x45>
8010147f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101480:	e8 7b fd ff ff       	call   80101200 <balloc>
80101485:	89 c2                	mov    %eax,%edx
80101487:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010148d:	8b 06                	mov    (%esi),%eax
8010148f:	eb 9b                	jmp    8010142c <bmap+0x2c>
80101491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101498:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010149b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010149e:	85 db                	test   %ebx,%ebx
801014a0:	75 af                	jne    80101451 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014a2:	8b 00                	mov    (%eax),%eax
801014a4:	e8 57 fd ff ff       	call   80101200 <balloc>
801014a9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ac:	89 c3                	mov    %eax,%ebx
}
801014ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b1:	89 d8                	mov    %ebx,%eax
801014b3:	5b                   	pop    %ebx
801014b4:	5e                   	pop    %esi
801014b5:	5f                   	pop    %edi
801014b6:	5d                   	pop    %ebp
801014b7:	c3                   	ret    
  panic("bmap: out of range");
801014b8:	83 ec 0c             	sub    $0xc,%esp
801014bb:	68 b8 70 10 80       	push   $0x801070b8
801014c0:	e8 cb ee ff ff       	call   80100390 <panic>
801014c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014d0 <readsb>:
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	56                   	push   %esi
801014d4:	53                   	push   %ebx
801014d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014d8:	83 ec 08             	sub    $0x8,%esp
801014db:	6a 01                	push   $0x1
801014dd:	ff 75 08             	pushl  0x8(%ebp)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801014e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801014e8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ed:	6a 1c                	push   $0x1c
801014ef:	50                   	push   %eax
801014f0:	56                   	push   %esi
801014f1:	e8 4a 31 00 00       	call   80104640 <memmove>
  brelse(bp);
801014f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014f9:	83 c4 10             	add    $0x10,%esp
}
801014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ff:	5b                   	pop    %ebx
80101500:	5e                   	pop    %esi
80101501:	5d                   	pop    %ebp
  brelse(bp);
80101502:	e9 e9 ec ff ff       	jmp    801001f0 <brelse>
80101507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150e:	66 90                	xchg   %ax,%ax

80101510 <iinit>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	53                   	push   %ebx
80101514:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101519:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010151c:	68 cb 70 10 80       	push   $0x801070cb
80101521:	68 00 0a 11 80       	push   $0x80110a00
80101526:	e8 05 2e 00 00       	call   80104330 <initlock>
  for(i = 0; i < NINODE; i++) {
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101530:	83 ec 08             	sub    $0x8,%esp
80101533:	68 d2 70 10 80       	push   $0x801070d2
80101538:	53                   	push   %ebx
80101539:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010153f:	e8 bc 2c 00 00       	call   80104200 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101544:	83 c4 10             	add    $0x10,%esp
80101547:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010154d:	75 e1                	jne    80101530 <iinit+0x20>
  readsb(dev, &sb);
8010154f:	83 ec 08             	sub    $0x8,%esp
80101552:	68 e0 09 11 80       	push   $0x801109e0
80101557:	ff 75 08             	pushl  0x8(%ebp)
8010155a:	e8 71 ff ff ff       	call   801014d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010155f:	ff 35 f8 09 11 80    	pushl  0x801109f8
80101565:	ff 35 f4 09 11 80    	pushl  0x801109f4
8010156b:	ff 35 f0 09 11 80    	pushl  0x801109f0
80101571:	ff 35 ec 09 11 80    	pushl  0x801109ec
80101577:	ff 35 e8 09 11 80    	pushl  0x801109e8
8010157d:	ff 35 e4 09 11 80    	pushl  0x801109e4
80101583:	ff 35 e0 09 11 80    	pushl  0x801109e0
80101589:	68 38 71 10 80       	push   $0x80107138
8010158e:	e8 1d f1 ff ff       	call   801006b0 <cprintf>
}
80101593:	83 c4 30             	add    $0x30,%esp
80101596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101599:	c9                   	leave  
8010159a:	c3                   	ret    
8010159b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010159f:	90                   	nop

801015a0 <ialloc>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
801015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015ac:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
801015b3:	8b 75 08             	mov    0x8(%ebp),%esi
801015b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	0f 86 91 00 00 00    	jbe    80101650 <ialloc+0xb0>
801015bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015c4:	eb 21                	jmp    801015e7 <ialloc+0x47>
801015c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015d6:	57                   	push   %edi
801015d7:	e8 14 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
801015e5:	73 69                	jae    80101650 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015e7:	89 d8                	mov    %ebx,%eax
801015e9:	83 ec 08             	sub    $0x8,%esp
801015ec:	c1 e8 03             	shr    $0x3,%eax
801015ef:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015f5:	50                   	push   %eax
801015f6:	56                   	push   %esi
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801015fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801015ff:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101601:	89 d8                	mov    %ebx,%eax
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010160d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101611:	75 bd                	jne    801015d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101613:	83 ec 04             	sub    $0x4,%esp
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	6a 40                	push   $0x40
8010161b:	6a 00                	push   $0x0
8010161d:	51                   	push   %ecx
8010161e:	e8 7d 2f 00 00       	call   801045a0 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 3c 24             	mov    %edi,(%esp)
80101630:	e8 3b 18 00 00       	call   80102e70 <log_write>
      brelse(bp);
80101635:	89 3c 24             	mov    %edi,(%esp)
80101638:	e8 b3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010163d:	83 c4 10             	add    $0x10,%esp
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101643:	89 da                	mov    %ebx,%edx
80101645:	89 f0                	mov    %esi,%eax
}
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5f                   	pop    %edi
8010164a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010164b:	e9 c0 fc ff ff       	jmp    80101310 <iget>
  panic("ialloc: no inodes");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 d8 70 10 80       	push   $0x801070d8
80101658:	e8 33 ed ff ff       	call   80100390 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101668:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010166e:	83 ec 08             	sub    $0x8,%esp
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010167a:	50                   	push   %eax
8010167b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010167e:	e8 4d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101683:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101687:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010168a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010168c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010168f:	83 e0 07             	and    $0x7,%eax
80101692:	c1 e0 06             	shl    $0x6,%eax
80101695:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101699:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010169c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bd:	6a 34                	push   $0x34
801016bf:	53                   	push   %ebx
801016c0:	50                   	push   %eax
801016c1:	e8 7a 2f 00 00       	call   80104640 <memmove>
  log_write(bp);
801016c6:	89 34 24             	mov    %esi,(%esp)
801016c9:	e8 a2 17 00 00       	call   80102e70 <log_write>
  brelse(bp);
801016ce:	89 75 08             	mov    %esi,0x8(%ebp)
801016d1:	83 c4 10             	add    $0x10,%esp
}
801016d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d7:	5b                   	pop    %ebx
801016d8:	5e                   	pop    %esi
801016d9:	5d                   	pop    %ebp
  brelse(bp);
801016da:	e9 11 eb ff ff       	jmp    801001f0 <brelse>
801016df:	90                   	nop

801016e0 <idup>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	83 ec 10             	sub    $0x10,%esp
801016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ea:	68 00 0a 11 80       	push   $0x80110a00
801016ef:	e8 9c 2d 00 00       	call   80104490 <acquire>
  ip->ref++;
801016f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016f8:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016ff:	e8 4c 2e 00 00       	call   80104550 <release>
}
80101704:	89 d8                	mov    %ebx,%eax
80101706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101709:	c9                   	leave  
8010170a:	c3                   	ret    
8010170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

80101710 <ilock>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101718:	85 db                	test   %ebx,%ebx
8010171a:	0f 84 b7 00 00 00    	je     801017d7 <ilock+0xc7>
80101720:	8b 53 08             	mov    0x8(%ebx),%edx
80101723:	85 d2                	test   %edx,%edx
80101725:	0f 8e ac 00 00 00    	jle    801017d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010172b:	83 ec 0c             	sub    $0xc,%esp
8010172e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101731:	50                   	push   %eax
80101732:	e8 09 2b 00 00       	call   80104240 <acquiresleep>
  if(ip->valid == 0){
80101737:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010173a:	83 c4 10             	add    $0x10,%esp
8010173d:	85 c0                	test   %eax,%eax
8010173f:	74 0f                	je     80101750 <ilock+0x40>
}
80101741:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101744:	5b                   	pop    %ebx
80101745:	5e                   	pop    %esi
80101746:	5d                   	pop    %ebp
80101747:	c3                   	ret    
80101748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101750:	8b 43 04             	mov    0x4(%ebx),%eax
80101753:	83 ec 08             	sub    $0x8,%esp
80101756:	c1 e8 03             	shr    $0x3,%eax
80101759:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010175f:	50                   	push   %eax
80101760:	ff 33                	pushl  (%ebx)
80101762:	e8 69 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 04             	mov    0x4(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101779:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010177c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010177f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101783:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101787:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010178b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010178f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101793:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101797:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010179b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010179e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a1:	6a 34                	push   $0x34
801017a3:	50                   	push   %eax
801017a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017a7:	50                   	push   %eax
801017a8:	e8 93 2e 00 00       	call   80104640 <memmove>
    brelse(bp);
801017ad:	89 34 24             	mov    %esi,(%esp)
801017b0:	e8 3b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017c4:	0f 85 77 ff ff ff    	jne    80101741 <ilock+0x31>
      panic("ilock: no type");
801017ca:	83 ec 0c             	sub    $0xc,%esp
801017cd:	68 f0 70 10 80       	push   $0x801070f0
801017d2:	e8 b9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017d7:	83 ec 0c             	sub    $0xc,%esp
801017da:	68 ea 70 10 80       	push   $0x801070ea
801017df:	e8 ac eb ff ff       	call   80100390 <panic>
801017e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <iunlock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	74 28                	je     80101824 <iunlock+0x34>
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101802:	56                   	push   %esi
80101803:	e8 d8 2a 00 00       	call   801042e0 <holdingsleep>
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 c0                	test   %eax,%eax
8010180d:	74 15                	je     80101824 <iunlock+0x34>
8010180f:	8b 43 08             	mov    0x8(%ebx),%eax
80101812:	85 c0                	test   %eax,%eax
80101814:	7e 0e                	jle    80101824 <iunlock+0x34>
  releasesleep(&ip->lock);
80101816:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101819:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010181f:	e9 7c 2a 00 00       	jmp    801042a0 <releasesleep>
    panic("iunlock");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 ff 70 10 80       	push   $0x801070ff
8010182c:	e8 5f eb ff ff       	call   80100390 <panic>
80101831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iput>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 28             	sub    $0x28,%esp
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010184c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010184f:	57                   	push   %edi
80101850:	e8 eb 29 00 00       	call   80104240 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101855:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101858:	83 c4 10             	add    $0x10,%esp
8010185b:	85 d2                	test   %edx,%edx
8010185d:	74 07                	je     80101866 <iput+0x26>
8010185f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101864:	74 32                	je     80101898 <iput+0x58>
  releasesleep(&ip->lock);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	57                   	push   %edi
8010186a:	e8 31 2a 00 00       	call   801042a0 <releasesleep>
  acquire(&icache.lock);
8010186f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101876:	e8 15 2c 00 00       	call   80104490 <acquire>
  ip->ref--;
8010187b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010187f:	83 c4 10             	add    $0x10,%esp
80101882:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5f                   	pop    %edi
8010188f:	5d                   	pop    %ebp
  release(&icache.lock);
80101890:	e9 bb 2c 00 00       	jmp    80104550 <release>
80101895:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 00 0a 11 80       	push   $0x80110a00
801018a0:	e8 eb 2b 00 00       	call   80104490 <acquire>
    int r = ip->ref;
801018a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018a8:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801018af:	e8 9c 2c 00 00       	call   80104550 <release>
    if(r == 1){
801018b4:	83 c4 10             	add    $0x10,%esp
801018b7:	83 fe 01             	cmp    $0x1,%esi
801018ba:	75 aa                	jne    80101866 <iput+0x26>
801018bc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018c8:	89 cf                	mov    %ecx,%edi
801018ca:	eb 0b                	jmp    801018d7 <iput+0x97>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018d0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018d3:	39 fe                	cmp    %edi,%esi
801018d5:	74 19                	je     801018f0 <iput+0xb0>
    if(ip->addrs[i]){
801018d7:	8b 16                	mov    (%esi),%edx
801018d9:	85 d2                	test   %edx,%edx
801018db:	74 f3                	je     801018d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018dd:	8b 03                	mov    (%ebx),%eax
801018df:	e8 ac f8 ff ff       	call   80101190 <bfree>
      ip->addrs[i] = 0;
801018e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018ea:	eb e4                	jmp    801018d0 <iput+0x90>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018f0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018f9:	85 c0                	test   %eax,%eax
801018fb:	75 33                	jne    80101930 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018fd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101900:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101907:	53                   	push   %ebx
80101908:	e8 53 fd ff ff       	call   80101660 <iupdate>
      ip->type = 0;
8010190d:	31 c0                	xor    %eax,%eax
8010190f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101913:	89 1c 24             	mov    %ebx,(%esp)
80101916:	e8 45 fd ff ff       	call   80101660 <iupdate>
      ip->valid = 0;
8010191b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101922:	83 c4 10             	add    $0x10,%esp
80101925:	e9 3c ff ff ff       	jmp    80101866 <iput+0x26>
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101930:	83 ec 08             	sub    $0x8,%esp
80101933:	50                   	push   %eax
80101934:	ff 33                	pushl  (%ebx)
80101936:	e8 95 e7 ff ff       	call   801000d0 <bread>
8010193b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010193e:	83 c4 10             	add    $0x10,%esp
80101941:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101947:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010194a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010194d:	89 cf                	mov    %ecx,%edi
8010194f:	eb 0e                	jmp    8010195f <iput+0x11f>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101958:	83 c6 04             	add    $0x4,%esi
8010195b:	39 f7                	cmp    %esi,%edi
8010195d:	74 11                	je     80101970 <iput+0x130>
      if(a[j])
8010195f:	8b 16                	mov    (%esi),%edx
80101961:	85 d2                	test   %edx,%edx
80101963:	74 f3                	je     80101958 <iput+0x118>
        bfree(ip->dev, a[j]);
80101965:	8b 03                	mov    (%ebx),%eax
80101967:	e8 24 f8 ff ff       	call   80101190 <bfree>
8010196c:	eb ea                	jmp    80101958 <iput+0x118>
8010196e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101970:	83 ec 0c             	sub    $0xc,%esp
80101973:	ff 75 e4             	pushl  -0x1c(%ebp)
80101976:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101979:	e8 72 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010197e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101984:	8b 03                	mov    (%ebx),%eax
80101986:	e8 05 f8 ff ff       	call   80101190 <bfree>
    ip->addrs[NDIRECT] = 0;
8010198b:	83 c4 10             	add    $0x10,%esp
8010198e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101995:	00 00 00 
80101998:	e9 60 ff ff ff       	jmp    801018fd <iput+0xbd>
8010199d:	8d 76 00             	lea    0x0(%esi),%esi

801019a0 <iunlockput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	53                   	push   %ebx
801019a4:	83 ec 10             	sub    $0x10,%esp
801019a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019aa:	53                   	push   %ebx
801019ab:	e8 40 fe ff ff       	call   801017f0 <iunlock>
  iput(ip);
801019b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019b3:	83 c4 10             	add    $0x10,%esp
}
801019b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019b9:	c9                   	leave  
  iput(ip);
801019ba:	e9 81 fe ff ff       	jmp    80101840 <iput>
801019bf:	90                   	nop

801019c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	8b 55 08             	mov    0x8(%ebp),%edx
801019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019c9:	8b 0a                	mov    (%edx),%ecx
801019cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801019d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019d4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019d8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019db:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019df:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019e3:	8b 52 58             	mov    0x58(%edx),%edx
801019e6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019e9:	5d                   	pop    %ebp
801019ea:	c3                   	ret    
801019eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ef:	90                   	nop

801019f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	8b 75 10             	mov    0x10(%ebp),%esi
80101a02:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a05:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a08:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a13:	0f 84 a7 00 00 00    	je     80101ac0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a1c:	8b 40 58             	mov    0x58(%eax),%eax
80101a1f:	39 c6                	cmp    %eax,%esi
80101a21:	0f 87 ba 00 00 00    	ja     80101ae1 <readi+0xf1>
80101a27:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a2a:	31 c9                	xor    %ecx,%ecx
80101a2c:	89 da                	mov    %ebx,%edx
80101a2e:	01 f2                	add    %esi,%edx
80101a30:	0f 92 c1             	setb   %cl
80101a33:	89 cf                	mov    %ecx,%edi
80101a35:	0f 82 a6 00 00 00    	jb     80101ae1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a3b:	89 c1                	mov    %eax,%ecx
80101a3d:	29 f1                	sub    %esi,%ecx
80101a3f:	39 d0                	cmp    %edx,%eax
80101a41:	0f 43 cb             	cmovae %ebx,%ecx
80101a44:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	85 c9                	test   %ecx,%ecx
80101a49:	74 67                	je     80101ab2 <readi+0xc2>
80101a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a53:	89 f2                	mov    %esi,%edx
80101a55:	c1 ea 09             	shr    $0x9,%edx
80101a58:	89 d8                	mov    %ebx,%eax
80101a5a:	e8 a1 f9 ff ff       	call   80101400 <bmap>
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	50                   	push   %eax
80101a63:	ff 33                	pushl  (%ebx)
80101a65:	e8 66 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a72:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a77:	89 f0                	mov    %esi,%eax
80101a79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a7e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a80:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a83:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a85:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a89:	39 d9                	cmp    %ebx,%ecx
80101a8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a8f:	01 df                	add    %ebx,%edi
80101a91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a93:	50                   	push   %eax
80101a94:	ff 75 e0             	pushl  -0x20(%ebp)
80101a97:	e8 a4 2b 00 00       	call   80104640 <memmove>
    brelse(bp);
80101a9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a9f:	89 14 24             	mov    %edx,(%esp)
80101aa2:	e8 49 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ab0:	77 9e                	ja     80101a50 <readi+0x60>
  }
  return n;
80101ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5f                   	pop    %edi
80101abb:	5d                   	pop    %ebp
80101abc:	c3                   	ret    
80101abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ac0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ac4:	66 83 f8 09          	cmp    $0x9,%ax
80101ac8:	77 17                	ja     80101ae1 <readi+0xf1>
80101aca:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	74 0c                	je     80101ae1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ad5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5f                   	pop    %edi
80101ade:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101adf:	ff e0                	jmp    *%eax
      return -1;
80101ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ae6:	eb cd                	jmp    80101ab5 <readi+0xc5>
80101ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 45 08             	mov    0x8(%ebp),%eax
80101afc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aff:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 b7 00 00 00    	je     80101bd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1f:	0f 82 e7 00 00 00    	jb     80101c0c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b28:	89 f8                	mov    %edi,%eax
80101b2a:	01 f0                	add    %esi,%eax
80101b2c:	0f 82 da 00 00 00    	jb     80101c0c <writei+0x11c>
80101b32:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b37:	0f 87 cf 00 00 00    	ja     80101c0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b44:	85 ff                	test   %edi,%edi
80101b46:	74 79                	je     80101bc1 <writei+0xd1>
80101b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 f8                	mov    %edi,%eax
80101b5a:	e8 a1 f8 ff ff       	call   80101400 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 37                	pushl  (%edi)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 f0                	mov    %esi,%eax
80101b79:	83 c4 0c             	add    $0xc,%esp
80101b7c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b81:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	39 d9                	cmp    %ebx,%ecx
80101b89:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b8f:	ff 75 dc             	pushl  -0x24(%ebp)
80101b92:	50                   	push   %eax
80101b93:	e8 a8 2a 00 00       	call   80104640 <memmove>
    log_write(bp);
80101b98:	89 3c 24             	mov    %edi,(%esp)
80101b9b:	e8 d0 12 00 00       	call   80102e70 <log_write>
    brelse(bp);
80101ba0:	89 3c 24             	mov    %edi,(%esp)
80101ba3:	e8 48 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ba8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bab:	83 c4 10             	add    $0x10,%esp
80101bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bb7:	77 97                	ja     80101b50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	77 37                	ja     80101bf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc7:	5b                   	pop    %ebx
80101bc8:	5e                   	pop    %esi
80101bc9:	5f                   	pop    %edi
80101bca:	5d                   	pop    %ebp
80101bcb:	c3                   	ret    
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bd4:	66 83 f8 09          	cmp    $0x9,%ax
80101bd8:	77 32                	ja     80101c0c <writei+0x11c>
80101bda:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101be1:	85 c0                	test   %eax,%eax
80101be3:	74 27                	je     80101c0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101be5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bef:	ff e0                	jmp    *%eax
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c01:	50                   	push   %eax
80101c02:	e8 59 fa ff ff       	call   80101660 <iupdate>
80101c07:	83 c4 10             	add    $0x10,%esp
80101c0a:	eb b5                	jmp    80101bc1 <writei+0xd1>
      return -1;
80101c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c11:	eb b1                	jmp    80101bc4 <writei+0xd4>
80101c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c26:	6a 0e                	push   $0xe
80101c28:	ff 75 0c             	pushl  0xc(%ebp)
80101c2b:	ff 75 08             	pushl  0x8(%ebp)
80101c2e:	e8 7d 2a 00 00       	call   801046b0 <strncmp>
}
80101c33:	c9                   	leave  
80101c34:	c3                   	ret    
80101c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c51:	0f 85 85 00 00 00    	jne    80101cdc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c57:	8b 53 58             	mov    0x58(%ebx),%edx
80101c5a:	31 ff                	xor    %edi,%edi
80101c5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c5f:	85 d2                	test   %edx,%edx
80101c61:	74 3e                	je     80101ca1 <dirlookup+0x61>
80101c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c67:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c68:	6a 10                	push   $0x10
80101c6a:	57                   	push   %edi
80101c6b:	56                   	push   %esi
80101c6c:	53                   	push   %ebx
80101c6d:	e8 7e fd ff ff       	call   801019f0 <readi>
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	83 f8 10             	cmp    $0x10,%eax
80101c78:	75 55                	jne    80101ccf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c7f:	74 18                	je     80101c99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c81:	83 ec 04             	sub    $0x4,%esp
80101c84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c87:	6a 0e                	push   $0xe
80101c89:	50                   	push   %eax
80101c8a:	ff 75 0c             	pushl  0xc(%ebp)
80101c8d:	e8 1e 2a 00 00       	call   801046b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	85 c0                	test   %eax,%eax
80101c97:	74 17                	je     80101cb0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c99:	83 c7 10             	add    $0x10,%edi
80101c9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c9f:	72 c7                	jb     80101c68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ca4:	31 c0                	xor    %eax,%eax
}
80101ca6:	5b                   	pop    %ebx
80101ca7:	5e                   	pop    %esi
80101ca8:	5f                   	pop    %edi
80101ca9:	5d                   	pop    %ebp
80101caa:	c3                   	ret    
80101cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101caf:	90                   	nop
      if(poff)
80101cb0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cb3:	85 c0                	test   %eax,%eax
80101cb5:	74 05                	je     80101cbc <dirlookup+0x7c>
        *poff = off;
80101cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cc0:	8b 03                	mov    (%ebx),%eax
80101cc2:	e8 49 f6 ff ff       	call   80101310 <iget>
}
80101cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cca:	5b                   	pop    %ebx
80101ccb:	5e                   	pop    %esi
80101ccc:	5f                   	pop    %edi
80101ccd:	5d                   	pop    %ebp
80101cce:	c3                   	ret    
      panic("dirlookup read");
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	68 19 71 10 80       	push   $0x80107119
80101cd7:	e8 b4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	68 07 71 10 80       	push   $0x80107107
80101ce4:	e8 a7 e6 ff ff       	call   80100390 <panic>
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	89 c3                	mov    %eax,%ebx
80101cf8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cfe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d04:	0f 84 86 01 00 00    	je     80101e90 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d0a:	e8 e1 1b 00 00       	call   801038f0 <myproc>
  acquire(&icache.lock);
80101d0f:	83 ec 0c             	sub    $0xc,%esp
80101d12:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d14:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d17:	68 00 0a 11 80       	push   $0x80110a00
80101d1c:	e8 6f 27 00 00       	call   80104490 <acquire>
  ip->ref++;
80101d21:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d25:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101d2c:	e8 1f 28 00 00       	call   80104550 <release>
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	eb 0d                	jmp    80101d43 <namex+0x53>
80101d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d43:	0f b6 07             	movzbl (%edi),%eax
80101d46:	3c 2f                	cmp    $0x2f,%al
80101d48:	74 f6                	je     80101d40 <namex+0x50>
  if(*path == 0)
80101d4a:	84 c0                	test   %al,%al
80101d4c:	0f 84 ee 00 00 00    	je     80101e40 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d52:	0f b6 07             	movzbl (%edi),%eax
80101d55:	84 c0                	test   %al,%al
80101d57:	0f 84 fb 00 00 00    	je     80101e58 <namex+0x168>
80101d5d:	89 fb                	mov    %edi,%ebx
80101d5f:	3c 2f                	cmp    $0x2f,%al
80101d61:	0f 84 f1 00 00 00    	je     80101e58 <namex+0x168>
80101d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6e:	66 90                	xchg   %ax,%ax
    path++;
80101d70:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d73:	0f b6 03             	movzbl (%ebx),%eax
80101d76:	3c 2f                	cmp    $0x2f,%al
80101d78:	74 04                	je     80101d7e <namex+0x8e>
80101d7a:	84 c0                	test   %al,%al
80101d7c:	75 f2                	jne    80101d70 <namex+0x80>
  len = path - s;
80101d7e:	89 d8                	mov    %ebx,%eax
80101d80:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d82:	83 f8 0d             	cmp    $0xd,%eax
80101d85:	0f 8e 85 00 00 00    	jle    80101e10 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d8b:	83 ec 04             	sub    $0x4,%esp
80101d8e:	6a 0e                	push   $0xe
80101d90:	57                   	push   %edi
    path++;
80101d91:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101d93:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d96:	e8 a5 28 00 00       	call   80104640 <memmove>
80101d9b:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101d9e:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101da1:	75 0d                	jne    80101db0 <namex+0xc0>
80101da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101da7:	90                   	nop
    path++;
80101da8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dab:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dae:	74 f8                	je     80101da8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	56                   	push   %esi
80101db4:	e8 57 f9 ff ff       	call   80101710 <ilock>
    if(ip->type != T_DIR){
80101db9:	83 c4 10             	add    $0x10,%esp
80101dbc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dc1:	0f 85 a1 00 00 00    	jne    80101e68 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dca:	85 d2                	test   %edx,%edx
80101dcc:	74 09                	je     80101dd7 <namex+0xe7>
80101dce:	80 3f 00             	cmpb   $0x0,(%edi)
80101dd1:	0f 84 d9 00 00 00    	je     80101eb0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dd7:	83 ec 04             	sub    $0x4,%esp
80101dda:	6a 00                	push   $0x0
80101ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ddf:	56                   	push   %esi
80101de0:	e8 5b fe ff ff       	call   80101c40 <dirlookup>
80101de5:	83 c4 10             	add    $0x10,%esp
80101de8:	89 c3                	mov    %eax,%ebx
80101dea:	85 c0                	test   %eax,%eax
80101dec:	74 7a                	je     80101e68 <namex+0x178>
  iunlock(ip);
80101dee:	83 ec 0c             	sub    $0xc,%esp
80101df1:	56                   	push   %esi
80101df2:	e8 f9 f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101df7:	89 34 24             	mov    %esi,(%esp)
80101dfa:	89 de                	mov    %ebx,%esi
80101dfc:	e8 3f fa ff ff       	call   80101840 <iput>
  while(*path == '/')
80101e01:	83 c4 10             	add    $0x10,%esp
80101e04:	e9 3a ff ff ff       	jmp    80101d43 <namex+0x53>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e13:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e16:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e19:	83 ec 04             	sub    $0x4,%esp
80101e1c:	50                   	push   %eax
80101e1d:	57                   	push   %edi
    name[len] = 0;
80101e1e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e20:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e23:	e8 18 28 00 00       	call   80104640 <memmove>
    name[len] = 0;
80101e28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	c6 00 00             	movb   $0x0,(%eax)
80101e31:	e9 68 ff ff ff       	jmp    80101d9e <namex+0xae>
80101e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 85 00 00 00    	jne    80101ed0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4e:	89 f0                	mov    %esi,%eax
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
80101e54:	c3                   	ret    
80101e55:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e5b:	89 fb                	mov    %edi,%ebx
80101e5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e60:	31 c0                	xor    %eax,%eax
80101e62:	eb b5                	jmp    80101e19 <namex+0x129>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	56                   	push   %esi
80101e6c:	e8 7f f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101e71:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e74:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e76:	e8 c5 f9 ff ff       	call   80101840 <iput>
      return 0;
80101e7b:	83 c4 10             	add    $0x10,%esp
}
80101e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e81:	89 f0                	mov    %esi,%eax
80101e83:	5b                   	pop    %ebx
80101e84:	5e                   	pop    %esi
80101e85:	5f                   	pop    %edi
80101e86:	5d                   	pop    %ebp
80101e87:	c3                   	ret    
80101e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e8f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101e90:	ba 01 00 00 00       	mov    $0x1,%edx
80101e95:	b8 01 00 00 00       	mov    $0x1,%eax
80101e9a:	89 df                	mov    %ebx,%edi
80101e9c:	e8 6f f4 ff ff       	call   80101310 <iget>
80101ea1:	89 c6                	mov    %eax,%esi
80101ea3:	e9 9b fe ff ff       	jmp    80101d43 <namex+0x53>
80101ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaf:	90                   	nop
      iunlock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <iunlock>
      return ip;
80101eb9:	83 c4 10             	add    $0x10,%esp
}
80101ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ebf:	89 f0                	mov    %esi,%eax
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	56                   	push   %esi
    return 0;
80101ed4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ed6:	e8 65 f9 ff ff       	call   80101840 <iput>
    return 0;
80101edb:	83 c4 10             	add    $0x10,%esp
80101ede:	e9 68 ff ff ff       	jmp    80101e4b <namex+0x15b>
80101ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ef0 <dirlink>:
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	57                   	push   %edi
80101ef4:	56                   	push   %esi
80101ef5:	53                   	push   %ebx
80101ef6:	83 ec 20             	sub    $0x20,%esp
80101ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101efc:	6a 00                	push   $0x0
80101efe:	ff 75 0c             	pushl  0xc(%ebp)
80101f01:	53                   	push   %ebx
80101f02:	e8 39 fd ff ff       	call   80101c40 <dirlookup>
80101f07:	83 c4 10             	add    $0x10,%esp
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 67                	jne    80101f75 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f14:	85 ff                	test   %edi,%edi
80101f16:	74 29                	je     80101f41 <dirlink+0x51>
80101f18:	31 ff                	xor    %edi,%edi
80101f1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f1d:	eb 09                	jmp    80101f28 <dirlink+0x38>
80101f1f:	90                   	nop
80101f20:	83 c7 10             	add    $0x10,%edi
80101f23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f26:	73 19                	jae    80101f41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f28:	6a 10                	push   $0x10
80101f2a:	57                   	push   %edi
80101f2b:	56                   	push   %esi
80101f2c:	53                   	push   %ebx
80101f2d:	e8 be fa ff ff       	call   801019f0 <readi>
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	83 f8 10             	cmp    $0x10,%eax
80101f38:	75 4e                	jne    80101f88 <dirlink+0x98>
    if(de.inum == 0)
80101f3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f3f:	75 df                	jne    80101f20 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f41:	83 ec 04             	sub    $0x4,%esp
80101f44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f47:	6a 0e                	push   $0xe
80101f49:	ff 75 0c             	pushl  0xc(%ebp)
80101f4c:	50                   	push   %eax
80101f4d:	e8 be 27 00 00       	call   80104710 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f52:	6a 10                	push   $0x10
  de.inum = inum;
80101f54:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f57:	57                   	push   %edi
80101f58:	56                   	push   %esi
80101f59:	53                   	push   %ebx
  de.inum = inum;
80101f5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f5e:	e8 8d fb ff ff       	call   80101af0 <writei>
80101f63:	83 c4 20             	add    $0x20,%esp
80101f66:	83 f8 10             	cmp    $0x10,%eax
80101f69:	75 2a                	jne    80101f95 <dirlink+0xa5>
  return 0;
80101f6b:	31 c0                	xor    %eax,%eax
}
80101f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret    
    iput(ip);
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	50                   	push   %eax
80101f79:	e8 c2 f8 ff ff       	call   80101840 <iput>
    return -1;
80101f7e:	83 c4 10             	add    $0x10,%esp
80101f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f86:	eb e5                	jmp    80101f6d <dirlink+0x7d>
      panic("dirlink read");
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	68 28 71 10 80       	push   $0x80107128
80101f90:	e8 fb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	68 26 77 10 80       	push   $0x80107726
80101f9d:	e8 ee e3 ff ff       	call   80100390 <panic>
80101fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fb0 <namei>:

struct inode*
namei(char *path)
{
80101fb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fb1:	31 d2                	xor    %edx,%edx
{
80101fb3:	89 e5                	mov    %esp,%ebp
80101fb5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fbe:	e8 2d fd ff ff       	call   80101cf0 <namex>
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    
80101fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fd0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fd1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fd6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fde:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fdf:	e9 0c fd ff ff       	jmp    80101cf0 <namex>
80101fe4:	66 90                	xchg   %ax,%ax
80101fe6:	66 90                	xchg   %ax,%ax
80101fe8:	66 90                	xchg   %ax,%ax
80101fea:	66 90                	xchg   %ax,%ax
80101fec:	66 90                	xchg   %ax,%ax
80101fee:	66 90                	xchg   %ax,%ax

80101ff0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ff9:	85 c0                	test   %eax,%eax
80101ffb:	0f 84 b4 00 00 00    	je     801020b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102001:	8b 70 08             	mov    0x8(%eax),%esi
80102004:	89 c3                	mov    %eax,%ebx
80102006:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010200c:	0f 87 96 00 00 00    	ja     801020a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102012:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201e:	66 90                	xchg   %ax,%ax
80102020:	89 ca                	mov    %ecx,%edx
80102022:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102023:	83 e0 c0             	and    $0xffffffc0,%eax
80102026:	3c 40                	cmp    $0x40,%al
80102028:	75 f6                	jne    80102020 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010202a:	31 ff                	xor    %edi,%edi
8010202c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102031:	89 f8                	mov    %edi,%eax
80102033:	ee                   	out    %al,(%dx)
80102034:	b8 01 00 00 00       	mov    $0x1,%eax
80102039:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010203e:	ee                   	out    %al,(%dx)
8010203f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102044:	89 f0                	mov    %esi,%eax
80102046:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102047:	89 f0                	mov    %esi,%eax
80102049:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010204e:	c1 f8 08             	sar    $0x8,%eax
80102051:	ee                   	out    %al,(%dx)
80102052:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102057:	89 f8                	mov    %edi,%eax
80102059:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010205a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010205e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102063:	c1 e0 04             	shl    $0x4,%eax
80102066:	83 e0 10             	and    $0x10,%eax
80102069:	83 c8 e0             	or     $0xffffffe0,%eax
8010206c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010206d:	f6 03 04             	testb  $0x4,(%ebx)
80102070:	75 16                	jne    80102088 <idestart+0x98>
80102072:	b8 20 00 00 00       	mov    $0x20,%eax
80102077:	89 ca                	mov    %ecx,%edx
80102079:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010207a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207d:	5b                   	pop    %ebx
8010207e:	5e                   	pop    %esi
8010207f:	5f                   	pop    %edi
80102080:	5d                   	pop    %ebp
80102081:	c3                   	ret    
80102082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102088:	b8 30 00 00 00       	mov    $0x30,%eax
8010208d:	89 ca                	mov    %ecx,%edx
8010208f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102090:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102095:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102098:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010209d:	fc                   	cld    
8010209e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a3:	5b                   	pop    %ebx
801020a4:	5e                   	pop    %esi
801020a5:	5f                   	pop    %edi
801020a6:	5d                   	pop    %ebp
801020a7:	c3                   	ret    
    panic("incorrect blockno");
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	68 94 71 10 80       	push   $0x80107194
801020b0:	e8 db e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	68 8b 71 10 80       	push   $0x8010718b
801020bd:	e8 ce e2 ff ff       	call   80100390 <panic>
801020c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <ideinit>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020d6:	68 a6 71 10 80       	push   $0x801071a6
801020db:	68 80 a5 10 80       	push   $0x8010a580
801020e0:	e8 4b 22 00 00       	call   80104330 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020e5:	58                   	pop    %eax
801020e6:	a1 20 2d 11 80       	mov    0x80112d20,%eax
801020eb:	5a                   	pop    %edx
801020ec:	83 e8 01             	sub    $0x1,%eax
801020ef:	50                   	push   %eax
801020f0:	6a 0e                	push   $0xe
801020f2:	e8 a9 02 00 00       	call   801023a0 <ioapicenable>
801020f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ff:	90                   	nop
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	83 e0 c0             	and    $0xffffffc0,%eax
80102104:	3c 40                	cmp    $0x40,%al
80102106:	75 f8                	jne    80102100 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102108:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010210d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102112:	ee                   	out    %al,(%dx)
80102113:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	eb 06                	jmp    80102125 <ideinit+0x55>
8010211f:	90                   	nop
  for(i=0; i<1000; i++){
80102120:	83 e9 01             	sub    $0x1,%ecx
80102123:	74 0f                	je     80102134 <ideinit+0x64>
80102125:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102126:	84 c0                	test   %al,%al
80102128:	74 f6                	je     80102120 <ideinit+0x50>
      havedisk1 = 1;
8010212a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102131:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102134:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102139:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010213e:	ee                   	out    %al,(%dx)
}
8010213f:	c9                   	leave  
80102140:	c3                   	ret    
80102141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010214f:	90                   	nop

80102150 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	57                   	push   %edi
80102154:	56                   	push   %esi
80102155:	53                   	push   %ebx
80102156:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102159:	68 80 a5 10 80       	push   $0x8010a580
8010215e:	e8 2d 23 00 00       	call   80104490 <acquire>

  if((b = idequeue) == 0){
80102163:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102169:	83 c4 10             	add    $0x10,%esp
8010216c:	85 db                	test   %ebx,%ebx
8010216e:	74 63                	je     801021d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102170:	8b 43 58             	mov    0x58(%ebx),%eax
80102173:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102178:	8b 33                	mov    (%ebx),%esi
8010217a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102180:	75 2f                	jne    801021b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102191:	89 c1                	mov    %eax,%ecx
80102193:	83 e1 c0             	and    $0xffffffc0,%ecx
80102196:	80 f9 40             	cmp    $0x40,%cl
80102199:	75 f5                	jne    80102190 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010219b:	a8 21                	test   $0x21,%al
8010219d:	75 12                	jne    801021b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010219f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ac:	fc                   	cld    
801021ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801021af:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021b7:	83 ce 02             	or     $0x2,%esi
801021ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021bc:	53                   	push   %ebx
801021bd:	e8 9e 1e 00 00       	call   80104060 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021c2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	85 c0                	test   %eax,%eax
801021cc:	74 05                	je     801021d3 <ideintr+0x83>
    idestart(idequeue);
801021ce:	e8 1d fe ff ff       	call   80101ff0 <idestart>
    release(&idelock);
801021d3:	83 ec 0c             	sub    $0xc,%esp
801021d6:	68 80 a5 10 80       	push   $0x8010a580
801021db:	e8 70 23 00 00       	call   80104550 <release>

  release(&idelock);
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret    
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	53                   	push   %ebx
801021f4:	83 ec 10             	sub    $0x10,%esp
801021f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801021fd:	50                   	push   %eax
801021fe:	e8 dd 20 00 00       	call   801042e0 <holdingsleep>
80102203:	83 c4 10             	add    $0x10,%esp
80102206:	85 c0                	test   %eax,%eax
80102208:	0f 84 d3 00 00 00    	je     801022e1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 e0 06             	and    $0x6,%eax
80102213:	83 f8 02             	cmp    $0x2,%eax
80102216:	0f 84 b8 00 00 00    	je     801022d4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010221c:	8b 53 04             	mov    0x4(%ebx),%edx
8010221f:	85 d2                	test   %edx,%edx
80102221:	74 0d                	je     80102230 <iderw+0x40>
80102223:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102228:	85 c0                	test   %eax,%eax
8010222a:	0f 84 97 00 00 00    	je     801022c7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	68 80 a5 10 80       	push   $0x8010a580
80102238:	e8 53 22 00 00       	call   80104490 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010223d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102243:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	85 d2                	test   %edx,%edx
8010224f:	75 09                	jne    8010225a <iderw+0x6a>
80102251:	eb 6d                	jmp    801022c0 <iderw+0xd0>
80102253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102257:	90                   	nop
80102258:	89 c2                	mov    %eax,%edx
8010225a:	8b 42 58             	mov    0x58(%edx),%eax
8010225d:	85 c0                	test   %eax,%eax
8010225f:	75 f7                	jne    80102258 <iderw+0x68>
80102261:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102264:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102266:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010226c:	74 42                	je     801022b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010226e:	8b 03                	mov    (%ebx),%eax
80102270:	83 e0 06             	and    $0x6,%eax
80102273:	83 f8 02             	cmp    $0x2,%eax
80102276:	74 23                	je     8010229b <iderw+0xab>
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop
    sleep(b, &idelock);
80102280:	83 ec 08             	sub    $0x8,%esp
80102283:	68 80 a5 10 80       	push   $0x8010a580
80102288:	53                   	push   %ebx
80102289:	e8 22 1c 00 00       	call   80103eb0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010228e:	8b 03                	mov    (%ebx),%eax
80102290:	83 c4 10             	add    $0x10,%esp
80102293:	83 e0 06             	and    $0x6,%eax
80102296:	83 f8 02             	cmp    $0x2,%eax
80102299:	75 e5                	jne    80102280 <iderw+0x90>
  }


  release(&idelock);
8010229b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022a5:	c9                   	leave  
  release(&idelock);
801022a6:	e9 a5 22 00 00       	jmp    80104550 <release>
801022ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop
    idestart(b);
801022b0:	89 d8                	mov    %ebx,%eax
801022b2:	e8 39 fd ff ff       	call   80101ff0 <idestart>
801022b7:	eb b5                	jmp    8010226e <iderw+0x7e>
801022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022c0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022c5:	eb 9d                	jmp    80102264 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801022c7:	83 ec 0c             	sub    $0xc,%esp
801022ca:	68 d5 71 10 80       	push   $0x801071d5
801022cf:	e8 bc e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 c0 71 10 80       	push   $0x801071c0
801022dc:	e8 af e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022e1:	83 ec 0c             	sub    $0xc,%esp
801022e4:	68 aa 71 10 80       	push   $0x801071aa
801022e9:	e8 a2 e0 ff ff       	call   80100390 <panic>
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022f1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801022f8:	00 c0 fe 
{
801022fb:	89 e5                	mov    %esp,%ebp
801022fd:	56                   	push   %esi
801022fe:	53                   	push   %ebx
  ioapic->reg = reg;
801022ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102306:	00 00 00 
  return ioapic->data;
80102309:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010230f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102312:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102318:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010231e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102325:	c1 ee 10             	shr    $0x10,%esi
80102328:	89 f0                	mov    %esi,%eax
8010232a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010232d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102330:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102333:	39 c2                	cmp    %eax,%edx
80102335:	74 16                	je     8010234d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 f4 71 10 80       	push   $0x801071f4
8010233f:	e8 6c e3 ff ff       	call   801006b0 <cprintf>
80102344:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 c6 21             	add    $0x21,%esi
{
80102350:	ba 10 00 00 00       	mov    $0x10,%edx
80102355:	b8 20 00 00 00       	mov    $0x20,%eax
8010235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102360:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102362:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102364:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010236a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010236d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102373:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102376:	8d 5a 01             	lea    0x1(%edx),%ebx
80102379:	83 c2 02             	add    $0x2,%edx
8010237c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010237e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102384:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010238b:	39 f0                	cmp    %esi,%eax
8010238d:	75 d1                	jne    80102360 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010238f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102392:	5b                   	pop    %ebx
80102393:	5e                   	pop    %esi
80102394:	5d                   	pop    %ebp
80102395:	c3                   	ret    
80102396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239d:	8d 76 00             	lea    0x0(%esi),%esi

801023a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023a0:	55                   	push   %ebp
  ioapic->reg = reg;
801023a1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801023a7:	89 e5                	mov    %esp,%ebp
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023ac:	8d 50 20             	lea    0x20(%eax),%edx
801023af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023b5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801023d1:	5d                   	pop    %ebp
801023d2:	c3                   	ret    
801023d3:	66 90                	xchg   %ax,%ax
801023d5:	66 90                	xchg   %ax,%ax
801023d7:	66 90                	xchg   %ax,%ax
801023d9:	66 90                	xchg   %ax,%ax
801023db:	66 90                	xchg   %ax,%ax
801023dd:	66 90                	xchg   %ax,%ax
801023df:	90                   	nop

801023e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 04             	sub    $0x4,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023f0:	75 76                	jne    80102468 <kfree+0x88>
801023f2:	81 fb c8 54 11 80    	cmp    $0x801154c8,%ebx
801023f8:	72 6e                	jb     80102468 <kfree+0x88>
801023fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102400:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102405:	77 61                	ja     80102468 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102407:	83 ec 04             	sub    $0x4,%esp
8010240a:	68 00 10 00 00       	push   $0x1000
8010240f:	6a 01                	push   $0x1
80102411:	53                   	push   %ebx
80102412:	e8 89 21 00 00       	call   801045a0 <memset>

  if(kmem.use_lock)
80102417:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 d2                	test   %edx,%edx
80102422:	75 1c                	jne    80102440 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102424:	a1 98 26 11 80       	mov    0x80112698,%eax
80102429:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010242b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102430:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102436:	85 c0                	test   %eax,%eax
80102438:	75 1e                	jne    80102458 <kfree+0x78>
    release(&kmem.lock);
}
8010243a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243d:	c9                   	leave  
8010243e:	c3                   	ret    
8010243f:	90                   	nop
    acquire(&kmem.lock);
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	68 60 26 11 80       	push   $0x80112660
80102448:	e8 43 20 00 00       	call   80104490 <acquire>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	eb d2                	jmp    80102424 <kfree+0x44>
80102452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102458:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010245f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102462:	c9                   	leave  
    release(&kmem.lock);
80102463:	e9 e8 20 00 00       	jmp    80104550 <release>
    panic("kfree");
80102468:	83 ec 0c             	sub    $0xc,%esp
8010246b:	68 26 72 10 80       	push   $0x80107226
80102470:	e8 1b df ff ff       	call   80100390 <panic>
80102475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102480 <freerange>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102484:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102487:	8b 75 0c             	mov    0xc(%ebp),%esi
8010248a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <freerange+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	83 ec 0c             	sub    $0xc,%esp
801024ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 23 ff ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 f3                	cmp    %esi,%ebx
801024c2:	76 e4                	jbe    801024a8 <freerange+0x28>
}
801024c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c7:	5b                   	pop    %ebx
801024c8:	5e                   	pop    %esi
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    
801024cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024cf:	90                   	nop

801024d0 <kinit1>:
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
801024d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024d8:	83 ec 08             	sub    $0x8,%esp
801024db:	68 2c 72 10 80       	push   $0x8010722c
801024e0:	68 60 26 11 80       	push   $0x80112660
801024e5:	e8 46 1e 00 00       	call   80104330 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024f0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801024f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102500:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102506:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010250c:	39 de                	cmp    %ebx,%esi
8010250e:	72 1c                	jb     8010252c <kinit1+0x5c>
    kfree(p);
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102519:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010251f:	50                   	push   %eax
80102520:	e8 bb fe ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102525:	83 c4 10             	add    $0x10,%esp
80102528:	39 de                	cmp    %ebx,%esi
8010252a:	73 e4                	jae    80102510 <kinit1+0x40>
}
8010252c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    
80102533:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102540 <kinit2>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102544:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102547:	8b 75 0c             	mov    0xc(%ebp),%esi
8010254a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <kinit2+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 63 fe ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <kinit2+0x28>
  kmem.use_lock = 1;
80102584:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010258b:	00 00 00 
}
8010258e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102591:	5b                   	pop    %ebx
80102592:	5e                   	pop    %esi
80102593:	5d                   	pop    %ebp
80102594:	c3                   	ret    
80102595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025a7:	a1 94 26 11 80       	mov    0x80112694,%eax
801025ac:	85 c0                	test   %eax,%eax
801025ae:	75 20                	jne    801025d0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025b0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801025b6:	85 db                	test   %ebx,%ebx
801025b8:	74 07                	je     801025c1 <kalloc+0x21>
    kmem.freelist = r->next;
801025ba:	8b 03                	mov    (%ebx),%eax
801025bc:	a3 98 26 11 80       	mov    %eax,0x80112698
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025c1:	89 d8                	mov    %ebx,%eax
801025c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c6:	c9                   	leave  
801025c7:	c3                   	ret    
801025c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop
    acquire(&kmem.lock);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	68 60 26 11 80       	push   $0x80112660
801025d8:	e8 b3 1e 00 00       	call   80104490 <acquire>
  r = kmem.freelist;
801025dd:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801025e3:	83 c4 10             	add    $0x10,%esp
801025e6:	a1 94 26 11 80       	mov    0x80112694,%eax
801025eb:	85 db                	test   %ebx,%ebx
801025ed:	74 08                	je     801025f7 <kalloc+0x57>
    kmem.freelist = r->next;
801025ef:	8b 13                	mov    (%ebx),%edx
801025f1:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801025f7:	85 c0                	test   %eax,%eax
801025f9:	74 c6                	je     801025c1 <kalloc+0x21>
    release(&kmem.lock);
801025fb:	83 ec 0c             	sub    $0xc,%esp
801025fe:	68 60 26 11 80       	push   $0x80112660
80102603:	e8 48 1f 00 00       	call   80104550 <release>
}
80102608:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010260a:	83 c4 10             	add    $0x10,%esp
}
8010260d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102610:	c9                   	leave  
80102611:	c3                   	ret    
80102612:	66 90                	xchg   %ax,%ax
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102620:	ba 64 00 00 00       	mov    $0x64,%edx
80102625:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102626:	a8 01                	test   $0x1,%al
80102628:	0f 84 c2 00 00 00    	je     801026f0 <kbdgetc+0xd0>
{
8010262e:	55                   	push   %ebp
8010262f:	ba 60 00 00 00       	mov    $0x60,%edx
80102634:	89 e5                	mov    %esp,%ebp
80102636:	53                   	push   %ebx
80102637:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102638:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010263b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102641:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102647:	74 57                	je     801026a0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102649:	89 d9                	mov    %ebx,%ecx
8010264b:	83 e1 40             	and    $0x40,%ecx
8010264e:	84 c0                	test   %al,%al
80102650:	78 5e                	js     801026b0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102652:	85 c9                	test   %ecx,%ecx
80102654:	74 09                	je     8010265f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102656:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102659:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010265c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010265f:	0f b6 8a 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%ecx
  shift ^= togglecode[data];
80102666:	0f b6 82 60 72 10 80 	movzbl -0x7fef8da0(%edx),%eax
  shift |= shiftcode[data];
8010266d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010266f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102671:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102673:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102679:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010267c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010267f:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
80102686:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010268a:	74 0b                	je     80102697 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010268c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010268f:	83 fa 19             	cmp    $0x19,%edx
80102692:	77 44                	ja     801026d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102694:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102697:	5b                   	pop    %ebx
80102698:	5d                   	pop    %ebp
80102699:	c3                   	ret    
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026a5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026ab:	5b                   	pop    %ebx
801026ac:	5d                   	pop    %ebp
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026b0:	83 e0 7f             	and    $0x7f,%eax
801026b3:	85 c9                	test   %ecx,%ecx
801026b5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026b8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026ba:	0f b6 8a 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%ecx
801026c1:	83 c9 40             	or     $0x40,%ecx
801026c4:	0f b6 c9             	movzbl %cl,%ecx
801026c7:	f7 d1                	not    %ecx
801026c9:	21 d9                	and    %ebx,%ecx
}
801026cb:	5b                   	pop    %ebx
801026cc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026cd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026d3:	c3                   	ret    
801026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026db:	8d 50 20             	lea    0x20(%eax),%edx
}
801026de:	5b                   	pop    %ebx
801026df:	5d                   	pop    %ebp
      c += 'a' - 'A';
801026e0:	83 f9 1a             	cmp    $0x1a,%ecx
801026e3:	0f 42 c2             	cmovb  %edx,%eax
}
801026e6:	c3                   	ret    
801026e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ee:	66 90                	xchg   %ax,%ax
    return -1;
801026f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026f5:	c3                   	ret    
801026f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fd:	8d 76 00             	lea    0x0(%esi),%esi

80102700 <kbdintr>:

void
kbdintr(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102706:	68 20 26 10 80       	push   $0x80102620
8010270b:	e8 50 e1 ff ff       	call   80100860 <consoleintr>
}
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	c9                   	leave  
80102714:	c3                   	ret    
80102715:	66 90                	xchg   %ax,%ax
80102717:	66 90                	xchg   %ax,%ax
80102719:	66 90                	xchg   %ax,%ax
8010271b:	66 90                	xchg   %ax,%ax
8010271d:	66 90                	xchg   %ax,%ax
8010271f:	90                   	nop

80102720 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102720:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102725:	85 c0                	test   %eax,%eax
80102727:	0f 84 cb 00 00 00    	je     801027f8 <lapicinit+0xd8>
  lapic[index] = value;
8010272d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102734:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102741:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102747:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010274e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102751:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102754:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010275b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010275e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102761:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102768:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010276b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102775:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102778:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010277b:	8b 50 30             	mov    0x30(%eax),%edx
8010277e:	c1 ea 10             	shr    $0x10,%edx
80102781:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102787:	75 77                	jne    80102800 <lapicinit+0xe0>
  lapic[index] = value;
80102789:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102790:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102796:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010279d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027d4:	8b 50 20             	mov    0x20(%eax),%edx
801027d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027de:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027e6:	80 e6 10             	and    $0x10,%dh
801027e9:	75 f5                	jne    801027e0 <lapicinit+0xc0>
  lapic[index] = value;
801027eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027f8:	c3                   	ret    
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102800:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102807:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280a:	8b 50 20             	mov    0x20(%eax),%edx
8010280d:	e9 77 ff ff ff       	jmp    80102789 <lapicinit+0x69>
80102812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102820 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102820:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102825:	85 c0                	test   %eax,%eax
80102827:	74 07                	je     80102830 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102829:	8b 40 20             	mov    0x20(%eax),%eax
8010282c:	c1 e8 18             	shr    $0x18,%eax
8010282f:	c3                   	ret    
    return 0;
80102830:	31 c0                	xor    %eax,%eax
}
80102832:	c3                   	ret    
80102833:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102840:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 0d                	je     80102856 <lapiceoi+0x16>
  lapic[index] = value;
80102849:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102850:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102853:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102856:	c3                   	ret    
80102857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285e:	66 90                	xchg   %ax,%ax

80102860 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102860:	c3                   	ret    
80102861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop

80102870 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102870:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102871:	b8 0f 00 00 00       	mov    $0xf,%eax
80102876:	ba 70 00 00 00       	mov    $0x70,%edx
8010287b:	89 e5                	mov    %esp,%ebp
8010287d:	53                   	push   %ebx
8010287e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102881:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102884:	ee                   	out    %al,(%dx)
80102885:	b8 0a 00 00 00       	mov    $0xa,%eax
8010288a:	ba 71 00 00 00       	mov    $0x71,%edx
8010288f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102890:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102892:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102895:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010289b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010289d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028a0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028a2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028a5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028ae:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801028b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028dc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801028f7:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801028f8:	8b 40 20             	mov    0x20(%eax),%eax
}
801028fb:	5d                   	pop    %ebp
801028fc:	c3                   	ret    
801028fd:	8d 76 00             	lea    0x0(%esi),%esi

80102900 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102900:	55                   	push   %ebp
80102901:	b8 0b 00 00 00       	mov    $0xb,%eax
80102906:	ba 70 00 00 00       	mov    $0x70,%edx
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	57                   	push   %edi
8010290e:	56                   	push   %esi
8010290f:	53                   	push   %ebx
80102910:	83 ec 4c             	sub    $0x4c,%esp
80102913:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102914:	ba 71 00 00 00       	mov    $0x71,%edx
80102919:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010291a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102922:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102925:	8d 76 00             	lea    0x0(%esi),%esi
80102928:	31 c0                	xor    %eax,%eax
8010292a:	89 da                	mov    %ebx,%edx
8010292c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102932:	89 ca                	mov    %ecx,%edx
80102934:	ec                   	in     (%dx),%al
80102935:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102938:	89 da                	mov    %ebx,%edx
8010293a:	b8 02 00 00 00       	mov    $0x2,%eax
8010293f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
80102943:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 da                	mov    %ebx,%edx
80102948:	b8 04 00 00 00       	mov    $0x4,%eax
8010294d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294e:	89 ca                	mov    %ecx,%edx
80102950:	ec                   	in     (%dx),%al
80102951:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102954:	89 da                	mov    %ebx,%edx
80102956:	b8 07 00 00 00       	mov    $0x7,%eax
8010295b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295c:	89 ca                	mov    %ecx,%edx
8010295e:	ec                   	in     (%dx),%al
8010295f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102962:	89 da                	mov    %ebx,%edx
80102964:	b8 08 00 00 00       	mov    $0x8,%eax
80102969:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296a:	89 ca                	mov    %ecx,%edx
8010296c:	ec                   	in     (%dx),%al
8010296d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010296f:	89 da                	mov    %ebx,%edx
80102971:	b8 09 00 00 00       	mov    $0x9,%eax
80102976:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102977:	89 ca                	mov    %ecx,%edx
80102979:	ec                   	in     (%dx),%al
8010297a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010297c:	89 da                	mov    %ebx,%edx
8010297e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102983:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102984:	89 ca                	mov    %ecx,%edx
80102986:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102987:	84 c0                	test   %al,%al
80102989:	78 9d                	js     80102928 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010298b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010298f:	89 fa                	mov    %edi,%edx
80102991:	0f b6 fa             	movzbl %dl,%edi
80102994:	89 f2                	mov    %esi,%edx
80102996:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102999:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010299d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a0:	89 da                	mov    %ebx,%edx
801029a2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029a5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029a8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029ac:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029af:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029b2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029b9:	31 c0                	xor    %eax,%eax
801029bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bc:	89 ca                	mov    %ecx,%edx
801029be:	ec                   	in     (%dx),%al
801029bf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029c7:	b8 02 00 00 00       	mov    $0x2,%eax
801029cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cd:	89 ca                	mov    %ecx,%edx
801029cf:	ec                   	in     (%dx),%al
801029d0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d3:	89 da                	mov    %ebx,%edx
801029d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029d8:	b8 04 00 00 00       	mov    $0x4,%eax
801029dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029de:	89 ca                	mov    %ecx,%edx
801029e0:	ec                   	in     (%dx),%al
801029e1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e4:	89 da                	mov    %ebx,%edx
801029e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029e9:	b8 07 00 00 00       	mov    $0x7,%eax
801029ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ef:	89 ca                	mov    %ecx,%edx
801029f1:	ec                   	in     (%dx),%al
801029f2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f5:	89 da                	mov    %ebx,%edx
801029f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029fa:	b8 08 00 00 00       	mov    $0x8,%eax
801029ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a00:	89 ca                	mov    %ecx,%edx
80102a02:	ec                   	in     (%dx),%al
80102a03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a06:	89 da                	mov    %ebx,%edx
80102a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a11:	89 ca                	mov    %ecx,%edx
80102a13:	ec                   	in     (%dx),%al
80102a14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a20:	6a 18                	push   $0x18
80102a22:	50                   	push   %eax
80102a23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a26:	50                   	push   %eax
80102a27:	e8 c4 1b 00 00       	call   801045f0 <memcmp>
80102a2c:	83 c4 10             	add    $0x10,%esp
80102a2f:	85 c0                	test   %eax,%eax
80102a31:	0f 85 f1 fe ff ff    	jne    80102928 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a3b:	75 78                	jne    80102ab5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a40:	89 c2                	mov    %eax,%edx
80102a42:	83 e0 0f             	and    $0xf,%eax
80102a45:	c1 ea 04             	shr    $0x4,%edx
80102a48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a54:	89 c2                	mov    %eax,%edx
80102a56:	83 e0 0f             	and    $0xf,%eax
80102a59:	c1 ea 04             	shr    $0x4,%edx
80102a5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a68:	89 c2                	mov    %eax,%edx
80102a6a:	83 e0 0f             	and    $0xf,%eax
80102a6d:	c1 ea 04             	shr    $0x4,%edx
80102a70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a7c:	89 c2                	mov    %eax,%edx
80102a7e:	83 e0 0f             	and    $0xf,%eax
80102a81:	c1 ea 04             	shr    $0x4,%edx
80102a84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a90:	89 c2                	mov    %eax,%edx
80102a92:	83 e0 0f             	and    $0xf,%eax
80102a95:	c1 ea 04             	shr    $0x4,%edx
80102a98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102aa1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102aa4:	89 c2                	mov    %eax,%edx
80102aa6:	83 e0 0f             	and    $0xf,%eax
80102aa9:	c1 ea 04             	shr    $0x4,%edx
80102aac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aaf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ab5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ab8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102abb:	89 06                	mov    %eax,(%esi)
80102abd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ac0:	89 46 04             	mov    %eax,0x4(%esi)
80102ac3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ac6:	89 46 08             	mov    %eax,0x8(%esi)
80102ac9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102acc:	89 46 0c             	mov    %eax,0xc(%esi)
80102acf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ad2:	89 46 10             	mov    %eax,0x10(%esi)
80102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ad8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102adb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ae2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ae5:	5b                   	pop    %ebx
80102ae6:	5e                   	pop    %esi
80102ae7:	5f                   	pop    %edi
80102ae8:	5d                   	pop    %ebp
80102ae9:	c3                   	ret    
80102aea:	66 90                	xchg   %ax,%ax
80102aec:	66 90                	xchg   %ax,%ax
80102aee:	66 90                	xchg   %ax,%ax

80102af0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102af0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102af6:	85 c9                	test   %ecx,%ecx
80102af8:	0f 8e 8a 00 00 00    	jle    80102b88 <install_trans+0x98>
{
80102afe:	55                   	push   %ebp
80102aff:	89 e5                	mov    %esp,%ebp
80102b01:	57                   	push   %edi
80102b02:	56                   	push   %esi
80102b03:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b04:	31 db                	xor    %ebx,%ebx
{
80102b06:	83 ec 0c             	sub    $0xc,%esp
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b10:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102b15:	83 ec 08             	sub    $0x8,%esp
80102b18:	01 d8                	add    %ebx,%eax
80102b1a:	83 c0 01             	add    $0x1,%eax
80102b1d:	50                   	push   %eax
80102b1e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102b24:	e8 a7 d5 ff ff       	call   801000d0 <bread>
80102b29:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b2b:	58                   	pop    %eax
80102b2c:	5a                   	pop    %edx
80102b2d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102b34:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b3d:	e8 8e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b45:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b47:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b4a:	68 00 02 00 00       	push   $0x200
80102b4f:	50                   	push   %eax
80102b50:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b53:	50                   	push   %eax
80102b54:	e8 e7 1a 00 00       	call   80104640 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b59:	89 34 24             	mov    %esi,(%esp)
80102b5c:	e8 4f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b61:	89 3c 24             	mov    %edi,(%esp)
80102b64:	e8 87 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b69:	89 34 24             	mov    %esi,(%esp)
80102b6c:	e8 7f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b71:	83 c4 10             	add    $0x10,%esp
80102b74:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102b7a:	7f 94                	jg     80102b10 <install_trans+0x20>
  }
}
80102b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7f:	5b                   	pop    %ebx
80102b80:	5e                   	pop    %esi
80102b81:	5f                   	pop    %edi
80102b82:	5d                   	pop    %ebp
80102b83:	c3                   	ret    
80102b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b88:	c3                   	ret    
80102b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	53                   	push   %ebx
80102b94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b97:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102b9d:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ba3:	e8 28 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ba8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102bad:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102bb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	7e 19                	jle    80102bd2 <write_head+0x42>
80102bb9:	31 d2                	xor    %edx,%edx
80102bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102bc0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102bc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102bcb:	83 c2 01             	add    $0x1,%edx
80102bce:	39 d0                	cmp    %edx,%eax
80102bd0:	75 ee                	jne    80102bc0 <write_head+0x30>
  }
  bwrite(buf);
80102bd2:	83 ec 0c             	sub    $0xc,%esp
80102bd5:	53                   	push   %ebx
80102bd6:	e8 d5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102bdb:	89 1c 24             	mov    %ebx,(%esp)
80102bde:	e8 0d d6 ff ff       	call   801001f0 <brelse>
}
80102be3:	83 c4 10             	add    $0x10,%esp
80102be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102be9:	c9                   	leave  
80102bea:	c3                   	ret    
80102beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bef:	90                   	nop

80102bf0 <initlog>:
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 2c             	sub    $0x2c,%esp
80102bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102bfa:	68 60 74 10 80       	push   $0x80107460
80102bff:	68 a0 26 11 80       	push   $0x801126a0
80102c04:	e8 27 17 00 00       	call   80104330 <initlock>
  readsb(dev, &sb);
80102c09:	58                   	pop    %eax
80102c0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c0d:	5a                   	pop    %edx
80102c0e:	50                   	push   %eax
80102c0f:	53                   	push   %ebx
80102c10:	e8 bb e8 ff ff       	call   801014d0 <readsb>
  log.start = sb.logstart;
80102c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c18:	59                   	pop    %ecx
  log.dev = dev;
80102c19:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c22:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102c27:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102c2d:	5a                   	pop    %edx
80102c2e:	50                   	push   %eax
80102c2f:	53                   	push   %ebx
80102c30:	e8 9b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c38:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c3b:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102c41:	85 c9                	test   %ecx,%ecx
80102c43:	7e 1d                	jle    80102c62 <initlog+0x72>
80102c45:	31 d2                	xor    %edx,%edx
80102c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c50:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c54:	89 1c 95 ec 26 11 80 	mov    %ebx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c5b:	83 c2 01             	add    $0x1,%edx
80102c5e:	39 d1                	cmp    %edx,%ecx
80102c60:	75 ee                	jne    80102c50 <initlog+0x60>
  brelse(buf);
80102c62:	83 ec 0c             	sub    $0xc,%esp
80102c65:	50                   	push   %eax
80102c66:	e8 85 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c6b:	e8 80 fe ff ff       	call   80102af0 <install_trans>
  log.lh.n = 0;
80102c70:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102c77:	00 00 00 
  write_head(); // clear the log
80102c7a:	e8 11 ff ff ff       	call   80102b90 <write_head>
}
80102c7f:	83 c4 10             	add    $0x10,%esp
80102c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c85:	c9                   	leave  
80102c86:	c3                   	ret    
80102c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8e:	66 90                	xchg   %ax,%ax

80102c90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c96:	68 a0 26 11 80       	push   $0x801126a0
80102c9b:	e8 f0 17 00 00       	call   80104490 <acquire>
80102ca0:	83 c4 10             	add    $0x10,%esp
80102ca3:	eb 18                	jmp    80102cbd <begin_op+0x2d>
80102ca5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ca8:	83 ec 08             	sub    $0x8,%esp
80102cab:	68 a0 26 11 80       	push   $0x801126a0
80102cb0:	68 a0 26 11 80       	push   $0x801126a0
80102cb5:	e8 f6 11 00 00       	call   80103eb0 <sleep>
80102cba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102cbd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102cc2:	85 c0                	test   %eax,%eax
80102cc4:	75 e2                	jne    80102ca8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cc6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102ccb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102cd1:	83 c0 01             	add    $0x1,%eax
80102cd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102cd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cda:	83 fa 1e             	cmp    $0x1e,%edx
80102cdd:	7f c9                	jg     80102ca8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cdf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ce2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ce7:	68 a0 26 11 80       	push   $0x801126a0
80102cec:	e8 5f 18 00 00       	call   80104550 <release>
      break;
    }
  }
}
80102cf1:	83 c4 10             	add    $0x10,%esp
80102cf4:	c9                   	leave  
80102cf5:	c3                   	ret    
80102cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cfd:	8d 76 00             	lea    0x0(%esi),%esi

80102d00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	57                   	push   %edi
80102d04:	56                   	push   %esi
80102d05:	53                   	push   %ebx
80102d06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d09:	68 a0 26 11 80       	push   $0x801126a0
80102d0e:	e8 7d 17 00 00       	call   80104490 <acquire>
  log.outstanding -= 1;
80102d13:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102d18:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102d1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d24:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102d2a:	85 f6                	test   %esi,%esi
80102d2c:	0f 85 22 01 00 00    	jne    80102e54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d32:	85 db                	test   %ebx,%ebx
80102d34:	0f 85 f6 00 00 00    	jne    80102e30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d3a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102d41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d44:	83 ec 0c             	sub    $0xc,%esp
80102d47:	68 a0 26 11 80       	push   $0x801126a0
80102d4c:	e8 ff 17 00 00       	call   80104550 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d51:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102d57:	83 c4 10             	add    $0x10,%esp
80102d5a:	85 c9                	test   %ecx,%ecx
80102d5c:	7f 42                	jg     80102da0 <end_op+0xa0>
    acquire(&log.lock);
80102d5e:	83 ec 0c             	sub    $0xc,%esp
80102d61:	68 a0 26 11 80       	push   $0x801126a0
80102d66:	e8 25 17 00 00       	call   80104490 <acquire>
    wakeup(&log);
80102d6b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102d72:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d79:	00 00 00 
    wakeup(&log);
80102d7c:	e8 df 12 00 00       	call   80104060 <wakeup>
    release(&log.lock);
80102d81:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d88:	e8 c3 17 00 00       	call   80104550 <release>
80102d8d:	83 c4 10             	add    $0x10,%esp
}
80102d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d93:	5b                   	pop    %ebx
80102d94:	5e                   	pop    %esi
80102d95:	5f                   	pop    %edi
80102d96:	5d                   	pop    %ebp
80102d97:	c3                   	ret    
80102d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102da0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102da5:	83 ec 08             	sub    $0x8,%esp
80102da8:	01 d8                	add    %ebx,%eax
80102daa:	83 c0 01             	add    $0x1,%eax
80102dad:	50                   	push   %eax
80102dae:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102db4:	e8 17 d3 ff ff       	call   801000d0 <bread>
80102db9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dbb:	58                   	pop    %eax
80102dbc:	5a                   	pop    %edx
80102dbd:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102dc4:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dcd:	e8 fe d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102dd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dd5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102dd7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dda:	68 00 02 00 00       	push   $0x200
80102ddf:	50                   	push   %eax
80102de0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102de3:	50                   	push   %eax
80102de4:	e8 57 18 00 00       	call   80104640 <memmove>
    bwrite(to);  // write the log
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 bf d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102df1:	89 3c 24             	mov    %edi,(%esp)
80102df4:	e8 f7 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102df9:	89 34 24             	mov    %esi,(%esp)
80102dfc:	e8 ef d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102e0a:	7c 94                	jl     80102da0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e0c:	e8 7f fd ff ff       	call   80102b90 <write_head>
    install_trans(); // Now install writes to home locations
80102e11:	e8 da fc ff ff       	call   80102af0 <install_trans>
    log.lh.n = 0;
80102e16:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e20:	e8 6b fd ff ff       	call   80102b90 <write_head>
80102e25:	e9 34 ff ff ff       	jmp    80102d5e <end_op+0x5e>
80102e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e30:	83 ec 0c             	sub    $0xc,%esp
80102e33:	68 a0 26 11 80       	push   $0x801126a0
80102e38:	e8 23 12 00 00       	call   80104060 <wakeup>
  release(&log.lock);
80102e3d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e44:	e8 07 17 00 00       	call   80104550 <release>
80102e49:	83 c4 10             	add    $0x10,%esp
}
80102e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e4f:	5b                   	pop    %ebx
80102e50:	5e                   	pop    %esi
80102e51:	5f                   	pop    %edi
80102e52:	5d                   	pop    %ebp
80102e53:	c3                   	ret    
    panic("log.committing");
80102e54:	83 ec 0c             	sub    $0xc,%esp
80102e57:	68 64 74 10 80       	push   $0x80107464
80102e5c:	e8 2f d5 ff ff       	call   80100390 <panic>
80102e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e77:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102e7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e80:	83 fa 1d             	cmp    $0x1d,%edx
80102e83:	0f 8f 94 00 00 00    	jg     80102f1d <log_write+0xad>
80102e89:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102e8e:	83 e8 01             	sub    $0x1,%eax
80102e91:	39 c2                	cmp    %eax,%edx
80102e93:	0f 8d 84 00 00 00    	jge    80102f1d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e99:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e9e:	85 c0                	test   %eax,%eax
80102ea0:	0f 8e 84 00 00 00    	jle    80102f2a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ea6:	83 ec 0c             	sub    $0xc,%esp
80102ea9:	68 a0 26 11 80       	push   $0x801126a0
80102eae:	e8 dd 15 00 00       	call   80104490 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102eb3:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102eb9:	83 c4 10             	add    $0x10,%esp
80102ebc:	85 d2                	test   %edx,%edx
80102ebe:	7e 51                	jle    80102f11 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ec0:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ec5:	3b 0d ec 26 11 80    	cmp    0x801126ec,%ecx
80102ecb:	75 0c                	jne    80102ed9 <log_write+0x69>
80102ecd:	eb 39                	jmp    80102f08 <log_write+0x98>
80102ecf:	90                   	nop
80102ed0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102ed7:	74 2f                	je     80102f08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ed9:	83 c0 01             	add    $0x1,%eax
80102edc:	39 c2                	cmp    %eax,%edx
80102ede:	75 f0                	jne    80102ed0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ee0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ee7:	83 c2 01             	add    $0x1,%edx
80102eea:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102ef0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102ef6:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102efd:	c9                   	leave  
  release(&log.lock);
80102efe:	e9 4d 16 00 00       	jmp    80104550 <release>
80102f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f07:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f08:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102f0f:	eb df                	jmp    80102ef0 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f11:	8b 43 08             	mov    0x8(%ebx),%eax
80102f14:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102f19:	75 d5                	jne    80102ef0 <log_write+0x80>
80102f1b:	eb ca                	jmp    80102ee7 <log_write+0x77>
    panic("too big a transaction");
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	68 73 74 10 80       	push   $0x80107473
80102f25:	e8 66 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f2a:	83 ec 0c             	sub    $0xc,%esp
80102f2d:	68 89 74 10 80       	push   $0x80107489
80102f32:	e8 59 d4 ff ff       	call   80100390 <panic>
80102f37:	66 90                	xchg   %ax,%ax
80102f39:	66 90                	xchg   %ax,%ax
80102f3b:	66 90                	xchg   %ax,%ax
80102f3d:	66 90                	xchg   %ax,%ax
80102f3f:	90                   	nop

80102f40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f47:	e8 84 09 00 00       	call   801038d0 <cpuid>
80102f4c:	89 c3                	mov    %eax,%ebx
80102f4e:	e8 7d 09 00 00       	call   801038d0 <cpuid>
80102f53:	83 ec 04             	sub    $0x4,%esp
80102f56:	53                   	push   %ebx
80102f57:	50                   	push   %eax
80102f58:	68 a4 74 10 80       	push   $0x801074a4
80102f5d:	e8 4e d7 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102f62:	e8 89 28 00 00       	call   801057f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f67:	e8 e4 08 00 00       	call   80103850 <mycpu>
80102f6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f7a:	e8 31 0c 00 00       	call   80103bb0 <scheduler>
80102f7f:	90                   	nop

80102f80 <mpenter>:
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f86:	e8 65 39 00 00       	call   801068f0 <switchkvm>
  seginit();
80102f8b:	e8 d0 38 00 00       	call   80106860 <seginit>
  lapicinit();
80102f90:	e8 8b f7 ff ff       	call   80102720 <lapicinit>
  mpmain();
80102f95:	e8 a6 ff ff ff       	call   80102f40 <mpmain>
80102f9a:	66 90                	xchg   %ax,%ax
80102f9c:	66 90                	xchg   %ax,%ax
80102f9e:	66 90                	xchg   %ax,%ax

80102fa0 <main>:
{
80102fa0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fa4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fa7:	ff 71 fc             	pushl  -0x4(%ecx)
80102faa:	55                   	push   %ebp
80102fab:	89 e5                	mov    %esp,%ebp
80102fad:	53                   	push   %ebx
80102fae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 00 40 80       	push   $0x80400000
80102fb7:	68 c8 54 11 80       	push   $0x801154c8
80102fbc:	e8 0f f5 ff ff       	call   801024d0 <kinit1>
  kvmalloc();      // kernel page table
80102fc1:	e8 ea 3d 00 00       	call   80106db0 <kvmalloc>
  mpinit();        // detect other processors
80102fc6:	e8 85 01 00 00       	call   80103150 <mpinit>
  lapicinit();     // interrupt controller
80102fcb:	e8 50 f7 ff ff       	call   80102720 <lapicinit>
  seginit();       // segment descriptors
80102fd0:	e8 8b 38 00 00       	call   80106860 <seginit>
  picinit();       // disable pic
80102fd5:	e8 46 03 00 00       	call   80103320 <picinit>
  ioapicinit();    // another interrupt controller
80102fda:	e8 11 f3 ff ff       	call   801022f0 <ioapicinit>
  consoleinit();   // console hardware
80102fdf:	e8 4c da ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80102fe4:	e8 37 2b 00 00       	call   80105b20 <uartinit>
  pinit();         // process table
80102fe9:	e8 22 08 00 00       	call   80103810 <pinit>
  tvinit();        // trap vectors
80102fee:	e8 7d 27 00 00       	call   80105770 <tvinit>
  binit();         // buffer cache
80102ff3:	e8 48 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ff8:	e8 e3 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80102ffd:	e8 ce f0 ff ff       	call   801020d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103002:	83 c4 0c             	add    $0xc,%esp
80103005:	68 8a 00 00 00       	push   $0x8a
8010300a:	68 8c a4 10 80       	push   $0x8010a48c
8010300f:	68 00 70 00 80       	push   $0x80007000
80103014:	e8 27 16 00 00       	call   80104640 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103023:	00 00 00 
80103026:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010302b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103030:	76 7e                	jbe    801030b0 <main+0x110>
80103032:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103037:	eb 20                	jmp    80103059 <main+0xb9>
80103039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103040:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103047:	00 00 00 
8010304a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103050:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103055:	39 c3                	cmp    %eax,%ebx
80103057:	73 57                	jae    801030b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103059:	e8 f2 07 00 00       	call   80103850 <mycpu>
8010305e:	39 d8                	cmp    %ebx,%eax
80103060:	74 de                	je     80103040 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103062:	e8 39 f5 ff ff       	call   801025a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103067:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010306a:	c7 05 f8 6f 00 80 80 	movl   $0x80102f80,0x80006ff8
80103071:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103074:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010307b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010307e:	05 00 10 00 00       	add    $0x1000,%eax
80103083:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103088:	0f b6 03             	movzbl (%ebx),%eax
8010308b:	68 00 70 00 00       	push   $0x7000
80103090:	50                   	push   %eax
80103091:	e8 da f7 ff ff       	call   80102870 <lapicstartap>
80103096:	83 c4 10             	add    $0x10,%esp
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030a6:	85 c0                	test   %eax,%eax
801030a8:	74 f6                	je     801030a0 <main+0x100>
801030aa:	eb 94                	jmp    80103040 <main+0xa0>
801030ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030b0:	83 ec 08             	sub    $0x8,%esp
801030b3:	68 00 00 00 8e       	push   $0x8e000000
801030b8:	68 00 00 40 80       	push   $0x80400000
801030bd:	e8 7e f4 ff ff       	call   80102540 <kinit2>
  userinit();      // first user process
801030c2:	e8 59 08 00 00       	call   80103920 <userinit>
  mpmain();        // finish this processor's setup
801030c7:	e8 74 fe ff ff       	call   80102f40 <mpmain>
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030db:	53                   	push   %ebx
  e = addr+len;
801030dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030e2:	39 de                	cmp    %ebx,%esi
801030e4:	72 10                	jb     801030f6 <mpsearch1+0x26>
801030e6:	eb 50                	jmp    80103138 <mpsearch1+0x68>
801030e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop
801030f0:	89 fe                	mov    %edi,%esi
801030f2:	39 fb                	cmp    %edi,%ebx
801030f4:	76 42                	jbe    80103138 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030f6:	83 ec 04             	sub    $0x4,%esp
801030f9:	8d 7e 10             	lea    0x10(%esi),%edi
801030fc:	6a 04                	push   $0x4
801030fe:	68 b8 74 10 80       	push   $0x801074b8
80103103:	56                   	push   %esi
80103104:	e8 e7 14 00 00       	call   801045f0 <memcmp>
80103109:	83 c4 10             	add    $0x10,%esp
8010310c:	85 c0                	test   %eax,%eax
8010310e:	75 e0                	jne    801030f0 <mpsearch1+0x20>
80103110:	89 f1                	mov    %esi,%ecx
80103112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103118:	0f b6 11             	movzbl (%ecx),%edx
8010311b:	83 c1 01             	add    $0x1,%ecx
8010311e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103120:	39 f9                	cmp    %edi,%ecx
80103122:	75 f4                	jne    80103118 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103124:	84 c0                	test   %al,%al
80103126:	75 c8                	jne    801030f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312b:	89 f0                	mov    %esi,%eax
8010312d:	5b                   	pop    %ebx
8010312e:	5e                   	pop    %esi
8010312f:	5f                   	pop    %edi
80103130:	5d                   	pop    %ebp
80103131:	c3                   	ret    
80103132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103138:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010313b:	31 f6                	xor    %esi,%esi
}
8010313d:	5b                   	pop    %ebx
8010313e:	89 f0                	mov    %esi,%eax
80103140:	5e                   	pop    %esi
80103141:	5f                   	pop    %edi
80103142:	5d                   	pop    %ebp
80103143:	c3                   	ret    
80103144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop

80103150 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	57                   	push   %edi
80103154:	56                   	push   %esi
80103155:	53                   	push   %ebx
80103156:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103159:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103160:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103167:	c1 e0 08             	shl    $0x8,%eax
8010316a:	09 d0                	or     %edx,%eax
8010316c:	c1 e0 04             	shl    $0x4,%eax
8010316f:	75 1b                	jne    8010318c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103171:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103178:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010317f:	c1 e0 08             	shl    $0x8,%eax
80103182:	09 d0                	or     %edx,%eax
80103184:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103187:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010318c:	ba 00 04 00 00       	mov    $0x400,%edx
80103191:	e8 3a ff ff ff       	call   801030d0 <mpsearch1>
80103196:	89 c7                	mov    %eax,%edi
80103198:	85 c0                	test   %eax,%eax
8010319a:	0f 84 c0 00 00 00    	je     80103260 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031a0:	8b 5f 04             	mov    0x4(%edi),%ebx
801031a3:	85 db                	test   %ebx,%ebx
801031a5:	0f 84 d5 00 00 00    	je     80103280 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801031ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031b4:	6a 04                	push   $0x4
801031b6:	68 d5 74 10 80       	push   $0x801074d5
801031bb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031bf:	e8 2c 14 00 00       	call   801045f0 <memcmp>
801031c4:	83 c4 10             	add    $0x10,%esp
801031c7:	85 c0                	test   %eax,%eax
801031c9:	0f 85 b1 00 00 00    	jne    80103280 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
801031cf:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031d6:	3c 01                	cmp    $0x1,%al
801031d8:	0f 95 c2             	setne  %dl
801031db:	3c 04                	cmp    $0x4,%al
801031dd:	0f 95 c0             	setne  %al
801031e0:	20 c2                	and    %al,%dl
801031e2:	0f 85 98 00 00 00    	jne    80103280 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
801031e8:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
801031ef:	66 85 c9             	test   %cx,%cx
801031f2:	74 21                	je     80103215 <mpinit+0xc5>
801031f4:	89 d8                	mov    %ebx,%eax
801031f6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
801031f9:	31 d2                	xor    %edx,%edx
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop
    sum += addr[i];
80103200:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103207:	83 c0 01             	add    $0x1,%eax
8010320a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010320c:	39 c6                	cmp    %eax,%esi
8010320e:	75 f0                	jne    80103200 <mpinit+0xb0>
80103210:	84 d2                	test   %dl,%dl
80103212:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103215:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103218:	85 c9                	test   %ecx,%ecx
8010321a:	74 64                	je     80103280 <mpinit+0x130>
8010321c:	84 d2                	test   %dl,%dl
8010321e:	75 60                	jne    80103280 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103220:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103226:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010322b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103232:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103238:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323d:	01 d1                	add    %edx,%ecx
8010323f:	89 ce                	mov    %ecx,%esi
80103241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103248:	39 c6                	cmp    %eax,%esi
8010324a:	76 4b                	jbe    80103297 <mpinit+0x147>
    switch(*p){
8010324c:	0f b6 10             	movzbl (%eax),%edx
8010324f:	80 fa 04             	cmp    $0x4,%dl
80103252:	0f 87 bf 00 00 00    	ja     80103317 <mpinit+0x1c7>
80103258:	ff 24 95 fc 74 10 80 	jmp    *-0x7fef8b04(,%edx,4)
8010325f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103260:	ba 00 00 01 00       	mov    $0x10000,%edx
80103265:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010326a:	e8 61 fe ff ff       	call   801030d0 <mpsearch1>
8010326f:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103271:	85 c0                	test   %eax,%eax
80103273:	0f 85 27 ff ff ff    	jne    801031a0 <mpinit+0x50>
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103280:	83 ec 0c             	sub    $0xc,%esp
80103283:	68 bd 74 10 80       	push   $0x801074bd
80103288:	e8 03 d1 ff ff       	call   80100390 <panic>
8010328d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103290:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103293:	39 c6                	cmp    %eax,%esi
80103295:	77 b5                	ja     8010324c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103297:	85 db                	test   %ebx,%ebx
80103299:	74 6f                	je     8010330a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010329b:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010329f:	74 15                	je     801032b6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a1:	b8 70 00 00 00       	mov    $0x70,%eax
801032a6:	ba 22 00 00 00       	mov    $0x22,%edx
801032ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ac:	ba 23 00 00 00       	mov    $0x23,%edx
801032b1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032b2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b5:	ee                   	out    %al,(%dx)
  }
}
801032b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032b9:	5b                   	pop    %ebx
801032ba:	5e                   	pop    %esi
801032bb:	5f                   	pop    %edi
801032bc:	5d                   	pop    %ebp
801032bd:	c3                   	ret    
801032be:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801032c0:	8b 15 20 2d 11 80    	mov    0x80112d20,%edx
801032c6:	83 fa 07             	cmp    $0x7,%edx
801032c9:	7f 1f                	jg     801032ea <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032cb:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801032d4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032d8:	88 91 a0 27 11 80    	mov    %dl,-0x7feed860(%ecx)
        ncpu++;
801032de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032e1:	83 c2 01             	add    $0x1,%edx
801032e4:	89 15 20 2d 11 80    	mov    %edx,0x80112d20
      p += sizeof(struct mpproc);
801032ea:	83 c0 14             	add    $0x14,%eax
      continue;
801032ed:	e9 56 ff ff ff       	jmp    80103248 <mpinit+0xf8>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
801032f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801032ff:	88 15 80 27 11 80    	mov    %dl,0x80112780
      continue;
80103305:	e9 3e ff ff ff       	jmp    80103248 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010330a:	83 ec 0c             	sub    $0xc,%esp
8010330d:	68 dc 74 10 80       	push   $0x801074dc
80103312:	e8 79 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
80103317:	31 db                	xor    %ebx,%ebx
80103319:	e9 31 ff ff ff       	jmp    8010324f <mpinit+0xff>
8010331e:	66 90                	xchg   %ax,%ax

80103320 <picinit>:
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103325:	ba 21 00 00 00       	mov    $0x21,%edx
8010332a:	ee                   	out    %al,(%dx)
8010332b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103330:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103331:	c3                   	ret    
80103332:	66 90                	xchg   %ax,%ax
80103334:	66 90                	xchg   %ax,%ax
80103336:	66 90                	xchg   %ax,%ax
80103338:	66 90                	xchg   %ax,%ax
8010333a:	66 90                	xchg   %ax,%ax
8010333c:	66 90                	xchg   %ax,%ax
8010333e:	66 90                	xchg   %ax,%ax

80103340 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 0c             	sub    $0xc,%esp
80103349:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010334c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010334f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103355:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010335b:	e8 a0 da ff ff       	call   80100e00 <filealloc>
80103360:	89 03                	mov    %eax,(%ebx)
80103362:	85 c0                	test   %eax,%eax
80103364:	0f 84 a8 00 00 00    	je     80103412 <pipealloc+0xd2>
8010336a:	e8 91 da ff ff       	call   80100e00 <filealloc>
8010336f:	89 06                	mov    %eax,(%esi)
80103371:	85 c0                	test   %eax,%eax
80103373:	0f 84 87 00 00 00    	je     80103400 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103379:	e8 22 f2 ff ff       	call   801025a0 <kalloc>
8010337e:	89 c7                	mov    %eax,%edi
80103380:	85 c0                	test   %eax,%eax
80103382:	0f 84 b0 00 00 00    	je     80103438 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103388:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010338f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103392:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103395:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010339c:	00 00 00 
  p->nwrite = 0;
8010339f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033a6:	00 00 00 
  p->nread = 0;
801033a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033b0:	00 00 00 
  initlock(&p->lock, "pipe");
801033b3:	68 10 75 10 80       	push   $0x80107510
801033b8:	50                   	push   %eax
801033b9:	e8 72 0f 00 00       	call   80104330 <initlock>
  (*f0)->type = FD_PIPE;
801033be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033c9:	8b 03                	mov    (%ebx),%eax
801033cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033cf:	8b 03                	mov    (%ebx),%eax
801033d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033d5:	8b 03                	mov    (%ebx),%eax
801033d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033da:	8b 06                	mov    (%esi),%eax
801033dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033e2:	8b 06                	mov    (%esi),%eax
801033e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033e8:	8b 06                	mov    (%esi),%eax
801033ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033ee:	8b 06                	mov    (%esi),%eax
801033f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033f6:	31 c0                	xor    %eax,%eax
}
801033f8:	5b                   	pop    %ebx
801033f9:	5e                   	pop    %esi
801033fa:	5f                   	pop    %edi
801033fb:	5d                   	pop    %ebp
801033fc:	c3                   	ret    
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103400:	8b 03                	mov    (%ebx),%eax
80103402:	85 c0                	test   %eax,%eax
80103404:	74 1e                	je     80103424 <pipealloc+0xe4>
    fileclose(*f0);
80103406:	83 ec 0c             	sub    $0xc,%esp
80103409:	50                   	push   %eax
8010340a:	e8 b1 da ff ff       	call   80100ec0 <fileclose>
8010340f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103412:	8b 06                	mov    (%esi),%eax
80103414:	85 c0                	test   %eax,%eax
80103416:	74 0c                	je     80103424 <pipealloc+0xe4>
    fileclose(*f1);
80103418:	83 ec 0c             	sub    $0xc,%esp
8010341b:	50                   	push   %eax
8010341c:	e8 9f da ff ff       	call   80100ec0 <fileclose>
80103421:	83 c4 10             	add    $0x10,%esp
}
80103424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103427:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010342c:	5b                   	pop    %ebx
8010342d:	5e                   	pop    %esi
8010342e:	5f                   	pop    %edi
8010342f:	5d                   	pop    %ebp
80103430:	c3                   	ret    
80103431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103438:	8b 03                	mov    (%ebx),%eax
8010343a:	85 c0                	test   %eax,%eax
8010343c:	75 c8                	jne    80103406 <pipealloc+0xc6>
8010343e:	eb d2                	jmp    80103412 <pipealloc+0xd2>

80103440 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	56                   	push   %esi
80103444:	53                   	push   %ebx
80103445:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103448:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010344b:	83 ec 0c             	sub    $0xc,%esp
8010344e:	53                   	push   %ebx
8010344f:	e8 3c 10 00 00       	call   80104490 <acquire>
  if(writable){
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	85 f6                	test   %esi,%esi
80103459:	74 65                	je     801034c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010345b:	83 ec 0c             	sub    $0xc,%esp
8010345e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103464:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010346b:	00 00 00 
    wakeup(&p->nread);
8010346e:	50                   	push   %eax
8010346f:	e8 ec 0b 00 00       	call   80104060 <wakeup>
80103474:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103477:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010347d:	85 d2                	test   %edx,%edx
8010347f:	75 0a                	jne    8010348b <pipeclose+0x4b>
80103481:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103487:	85 c0                	test   %eax,%eax
80103489:	74 15                	je     801034a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010348b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010348e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103491:	5b                   	pop    %ebx
80103492:	5e                   	pop    %esi
80103493:	5d                   	pop    %ebp
    release(&p->lock);
80103494:	e9 b7 10 00 00       	jmp    80104550 <release>
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 a7 10 00 00       	call   80104550 <release>
    kfree((char*)p);
801034a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ac:	83 c4 10             	add    $0x10,%esp
}
801034af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b2:	5b                   	pop    %ebx
801034b3:	5e                   	pop    %esi
801034b4:	5d                   	pop    %ebp
    kfree((char*)p);
801034b5:	e9 26 ef ff ff       	jmp    801023e0 <kfree>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801034c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034d0:	00 00 00 
    wakeup(&p->nwrite);
801034d3:	50                   	push   %eax
801034d4:	e8 87 0b 00 00       	call   80104060 <wakeup>
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	eb 99                	jmp    80103477 <pipeclose+0x37>
801034de:	66 90                	xchg   %ax,%ax

801034e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
801034e5:	53                   	push   %ebx
801034e6:	83 ec 28             	sub    $0x28,%esp
801034e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034ec:	53                   	push   %ebx
801034ed:	e8 9e 0f 00 00       	call   80104490 <acquire>
  for(i = 0; i < n; i++){
801034f2:	8b 45 10             	mov    0x10(%ebp),%eax
801034f5:	83 c4 10             	add    $0x10,%esp
801034f8:	85 c0                	test   %eax,%eax
801034fa:	0f 8e c8 00 00 00    	jle    801035c8 <pipewrite+0xe8>
80103500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103503:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103509:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010350f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103512:	03 4d 10             	add    0x10(%ebp),%ecx
80103515:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103518:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010351e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103524:	39 d0                	cmp    %edx,%eax
80103526:	75 71                	jne    80103599 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103528:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010352e:	85 c0                	test   %eax,%eax
80103530:	74 4e                	je     80103580 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103532:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103538:	eb 3a                	jmp    80103574 <pipewrite+0x94>
8010353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	57                   	push   %edi
80103544:	e8 17 0b 00 00       	call   80104060 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103549:	5a                   	pop    %edx
8010354a:	59                   	pop    %ecx
8010354b:	53                   	push   %ebx
8010354c:	56                   	push   %esi
8010354d:	e8 5e 09 00 00       	call   80103eb0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103552:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103558:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010355e:	83 c4 10             	add    $0x10,%esp
80103561:	05 00 02 00 00       	add    $0x200,%eax
80103566:	39 c2                	cmp    %eax,%edx
80103568:	75 36                	jne    801035a0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010356a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103570:	85 c0                	test   %eax,%eax
80103572:	74 0c                	je     80103580 <pipewrite+0xa0>
80103574:	e8 77 03 00 00       	call   801038f0 <myproc>
80103579:	8b 40 24             	mov    0x24(%eax),%eax
8010357c:	85 c0                	test   %eax,%eax
8010357e:	74 c0                	je     80103540 <pipewrite+0x60>
        release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 c7 0f 00 00       	call   80104550 <release>
        return -1;
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103594:	5b                   	pop    %ebx
80103595:	5e                   	pop    %esi
80103596:	5f                   	pop    %edi
80103597:	5d                   	pop    %ebp
80103598:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103599:	89 c2                	mov    %eax,%edx
8010359b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010359f:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035a3:	8d 42 01             	lea    0x1(%edx),%eax
801035a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035ac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035b2:	0f b6 0e             	movzbl (%esi),%ecx
801035b5:	83 c6 01             	add    $0x1,%esi
801035b8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801035bb:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035bf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035c2:	0f 85 50 ff ff ff    	jne    80103518 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035c8:	83 ec 0c             	sub    $0xc,%esp
801035cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035d1:	50                   	push   %eax
801035d2:	e8 89 0a 00 00       	call   80104060 <wakeup>
  release(&p->lock);
801035d7:	89 1c 24             	mov    %ebx,(%esp)
801035da:	e8 71 0f 00 00       	call   80104550 <release>
  return n;
801035df:	83 c4 10             	add    $0x10,%esp
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	eb aa                	jmp    80103591 <pipewrite+0xb1>
801035e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 18             	sub    $0x18,%esp
801035f9:	8b 75 08             	mov    0x8(%ebp),%esi
801035fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035ff:	56                   	push   %esi
80103600:	e8 8b 0e 00 00       	call   80104490 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010360e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103614:	75 6a                	jne    80103680 <piperead+0x90>
80103616:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010361c:	85 db                	test   %ebx,%ebx
8010361e:	0f 84 c4 00 00 00    	je     801036e8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103624:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010362a:	eb 2d                	jmp    80103659 <piperead+0x69>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103630:	83 ec 08             	sub    $0x8,%esp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	e8 76 08 00 00       	call   80103eb0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103643:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103649:	75 35                	jne    80103680 <piperead+0x90>
8010364b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103651:	85 d2                	test   %edx,%edx
80103653:	0f 84 8f 00 00 00    	je     801036e8 <piperead+0xf8>
    if(myproc()->killed){
80103659:	e8 92 02 00 00       	call   801038f0 <myproc>
8010365e:	8b 48 24             	mov    0x24(%eax),%ecx
80103661:	85 c9                	test   %ecx,%ecx
80103663:	74 cb                	je     80103630 <piperead+0x40>
      release(&p->lock);
80103665:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103668:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010366d:	56                   	push   %esi
8010366e:	e8 dd 0e 00 00       	call   80104550 <release>
      return -1;
80103673:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103679:	89 d8                	mov    %ebx,%eax
8010367b:	5b                   	pop    %ebx
8010367c:	5e                   	pop    %esi
8010367d:	5f                   	pop    %edi
8010367e:	5d                   	pop    %ebp
8010367f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103680:	8b 45 10             	mov    0x10(%ebp),%eax
80103683:	85 c0                	test   %eax,%eax
80103685:	7e 61                	jle    801036e8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103687:	31 db                	xor    %ebx,%ebx
80103689:	eb 13                	jmp    8010369e <piperead+0xae>
8010368b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
80103690:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103696:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010369c:	74 1f                	je     801036bd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010369e:	8d 41 01             	lea    0x1(%ecx),%eax
801036a1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036a7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036ad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036b2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036b5:	83 c3 01             	add    $0x1,%ebx
801036b8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036bb:	75 d3                	jne    80103690 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036bd:	83 ec 0c             	sub    $0xc,%esp
801036c0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036c6:	50                   	push   %eax
801036c7:	e8 94 09 00 00       	call   80104060 <wakeup>
  release(&p->lock);
801036cc:	89 34 24             	mov    %esi,(%esp)
801036cf:	e8 7c 0e 00 00       	call   80104550 <release>
  return i;
801036d4:	83 c4 10             	add    $0x10,%esp
}
801036d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036da:	89 d8                	mov    %ebx,%eax
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801036e8:	31 db                	xor    %ebx,%ebx
801036ea:	eb d1                	jmp    801036bd <piperead+0xcd>
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036f4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801036f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801036fc:	68 40 2d 11 80       	push   $0x80112d40
80103701:	e8 8a 0d 00 00       	call   80104490 <acquire>
80103706:	83 c4 10             	add    $0x10,%esp
80103709:	eb 10                	jmp    8010371b <allocproc+0x2b>
8010370b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103710:	83 c3 7c             	add    $0x7c,%ebx
80103713:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103719:	74 75                	je     80103790 <allocproc+0xa0>
    if(p->state == UNUSED)
8010371b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010371e:	85 c0                	test   %eax,%eax
80103720:	75 ee                	jne    80103710 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103722:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103727:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010372a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103731:	89 43 10             	mov    %eax,0x10(%ebx)
80103734:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103737:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
8010373c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103742:	e8 09 0e 00 00       	call   80104550 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103747:	e8 54 ee ff ff       	call   801025a0 <kalloc>
8010374c:	83 c4 10             	add    $0x10,%esp
8010374f:	89 43 08             	mov    %eax,0x8(%ebx)
80103752:	85 c0                	test   %eax,%eax
80103754:	74 53                	je     801037a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103756:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010375c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010375f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103764:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103767:	c7 40 14 62 57 10 80 	movl   $0x80105762,0x14(%eax)
  p->context = (struct context*)sp;
8010376e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103771:	6a 14                	push   $0x14
80103773:	6a 00                	push   $0x0
80103775:	50                   	push   %eax
80103776:	e8 25 0e 00 00       	call   801045a0 <memset>
  p->context->eip = (uint)forkret;
8010377b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010377e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103781:	c7 40 10 c0 37 10 80 	movl   $0x801037c0,0x10(%eax)
}
80103788:	89 d8                	mov    %ebx,%eax
8010378a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010378d:	c9                   	leave  
8010378e:	c3                   	ret    
8010378f:	90                   	nop
  release(&ptable.lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103793:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103795:	68 40 2d 11 80       	push   $0x80112d40
8010379a:	e8 b1 0d 00 00       	call   80104550 <release>
}
8010379f:	89 d8                	mov    %ebx,%eax
  return 0;
801037a1:	83 c4 10             	add    $0x10,%esp
}
801037a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037a7:	c9                   	leave  
801037a8:	c3                   	ret    
    p->state = UNUSED;
801037a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037b0:	31 db                	xor    %ebx,%ebx
}
801037b2:	89 d8                	mov    %ebx,%eax
801037b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037b7:	c9                   	leave  
801037b8:	c3                   	ret    
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037c6:	68 40 2d 11 80       	push   $0x80112d40
801037cb:	e8 80 0d 00 00       	call   80104550 <release>

  if (first) {
801037d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	85 c0                	test   %eax,%eax
801037da:	75 04                	jne    801037e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037dc:	c9                   	leave  
801037dd:	c3                   	ret    
801037de:	66 90                	xchg   %ax,%ax
    first = 0;
801037e0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037e7:	00 00 00 
    iinit(ROOTDEV);
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	6a 01                	push   $0x1
801037ef:	e8 1c dd ff ff       	call   80101510 <iinit>
    initlog(ROOTDEV);
801037f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037fb:	e8 f0 f3 ff ff       	call   80102bf0 <initlog>
80103800:	83 c4 10             	add    $0x10,%esp
}
80103803:	c9                   	leave  
80103804:	c3                   	ret    
80103805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103810 <pinit>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103816:	68 15 75 10 80       	push   $0x80107515
8010381b:	68 40 2d 11 80       	push   $0x80112d40
80103820:	e8 0b 0b 00 00       	call   80104330 <initlock>
}
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	c9                   	leave  
80103829:	c3                   	ret    
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103830 <gettsched>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 10             	sub    $0x10,%esp
    cprintf("%d\n",ticks);
80103836:	ff 35 c0 54 11 80    	pushl  0x801154c0
8010383c:	68 b4 74 10 80       	push   $0x801074b4
80103841:	e8 6a ce ff ff       	call   801006b0 <cprintf>
}
80103846:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
8010384b:	c9                   	leave  
8010384c:	c3                   	ret    
8010384d:	8d 76 00             	lea    0x0(%esi),%esi

80103850 <mycpu>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103855:	9c                   	pushf  
80103856:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103857:	f6 c4 02             	test   $0x2,%ah
8010385a:	75 5d                	jne    801038b9 <mycpu+0x69>
  apicid = lapicid();
8010385c:	e8 bf ef ff ff       	call   80102820 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103861:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
80103867:	85 f6                	test   %esi,%esi
80103869:	7e 41                	jle    801038ac <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
8010386b:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103872:	39 d0                	cmp    %edx,%eax
80103874:	74 2f                	je     801038a5 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103876:	31 d2                	xor    %edx,%edx
80103878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop
80103880:	83 c2 01             	add    $0x1,%edx
80103883:	39 f2                	cmp    %esi,%edx
80103885:	74 25                	je     801038ac <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103887:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010388d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103894:	39 c3                	cmp    %eax,%ebx
80103896:	75 e8                	jne    80103880 <mycpu+0x30>
80103898:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
8010389e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a1:	5b                   	pop    %ebx
801038a2:	5e                   	pop    %esi
801038a3:	5d                   	pop    %ebp
801038a4:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038a5:	b8 a0 27 11 80       	mov    $0x801127a0,%eax
      return &cpus[i];
801038aa:	eb f2                	jmp    8010389e <mycpu+0x4e>
  panic("unknown apicid\n");
801038ac:	83 ec 0c             	sub    $0xc,%esp
801038af:	68 1c 75 10 80       	push   $0x8010751c
801038b4:	e8 d7 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038b9:	83 ec 0c             	sub    $0xc,%esp
801038bc:	68 f8 75 10 80       	push   $0x801075f8
801038c1:	e8 ca ca ff ff       	call   80100390 <panic>
801038c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <cpuid>:
cpuid() {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038d6:	e8 75 ff ff ff       	call   80103850 <mycpu>
}
801038db:	c9                   	leave  
  return mycpu()-cpus;
801038dc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801038e1:	c1 f8 04             	sar    $0x4,%eax
801038e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038ea:	c3                   	ret    
801038eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop

801038f0 <myproc>:
myproc(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038f7:	e8 a4 0a 00 00       	call   801043a0 <pushcli>
  c = mycpu();
801038fc:	e8 4f ff ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103901:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103907:	e8 e4 0a 00 00       	call   801043f0 <popcli>
}
8010390c:	83 c4 04             	add    $0x4,%esp
8010390f:	89 d8                	mov    %ebx,%eax
80103911:	5b                   	pop    %ebx
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret    
80103914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010391f:	90                   	nop

80103920 <userinit>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
80103924:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103927:	e8 c4 fd ff ff       	call   801036f0 <allocproc>
8010392c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010392e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
80103933:	e8 f8 33 00 00       	call   80106d30 <setupkvm>
80103938:	89 43 04             	mov    %eax,0x4(%ebx)
8010393b:	85 c0                	test   %eax,%eax
8010393d:	0f 84 bd 00 00 00    	je     80103a00 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103943:	83 ec 04             	sub    $0x4,%esp
80103946:	68 2c 00 00 00       	push   $0x2c
8010394b:	68 60 a4 10 80       	push   $0x8010a460
80103950:	50                   	push   %eax
80103951:	e8 ba 30 00 00       	call   80106a10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103956:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103959:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010395f:	6a 4c                	push   $0x4c
80103961:	6a 00                	push   $0x0
80103963:	ff 73 18             	pushl  0x18(%ebx)
80103966:	e8 35 0c 00 00       	call   801045a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010396b:	8b 43 18             	mov    0x18(%ebx),%eax
8010396e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103973:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103976:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010397b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010397f:	8b 43 18             	mov    0x18(%ebx),%eax
80103982:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103986:	8b 43 18             	mov    0x18(%ebx),%eax
80103989:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010398d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103991:	8b 43 18             	mov    0x18(%ebx),%eax
80103994:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103998:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010399c:	8b 43 18             	mov    0x18(%ebx),%eax
8010399f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039a6:	8b 43 18             	mov    0x18(%ebx),%eax
801039a9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039b0:	8b 43 18             	mov    0x18(%ebx),%eax
801039b3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039ba:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039bd:	6a 10                	push   $0x10
801039bf:	68 45 75 10 80       	push   $0x80107545
801039c4:	50                   	push   %eax
801039c5:	e8 a6 0d 00 00       	call   80104770 <safestrcpy>
  p->cwd = namei("/");
801039ca:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801039d1:	e8 da e5 ff ff       	call   80101fb0 <namei>
801039d6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039d9:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801039e0:	e8 ab 0a 00 00       	call   80104490 <acquire>
  p->state = RUNNABLE;
801039e5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801039ec:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801039f3:	e8 58 0b 00 00       	call   80104550 <release>
}
801039f8:	83 c4 10             	add    $0x10,%esp
801039fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039fe:	c9                   	leave  
801039ff:	c3                   	ret    
    panic("userinit: out of memory?");
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	68 2c 75 10 80       	push   $0x8010752c
80103a08:	e8 83 c9 ff ff       	call   80100390 <panic>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi

80103a10 <growproc>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
80103a15:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a18:	e8 83 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a1d:	e8 2e fe ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103a22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a28:	e8 c3 09 00 00       	call   801043f0 <popcli>
  sz = curproc->sz;
80103a2d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a2f:	85 f6                	test   %esi,%esi
80103a31:	7f 1d                	jg     80103a50 <growproc+0x40>
  } else if(n < 0){
80103a33:	75 3b                	jne    80103a70 <growproc+0x60>
  switchuvm(curproc);
80103a35:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a38:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a3a:	53                   	push   %ebx
80103a3b:	e8 c0 2e 00 00       	call   80106900 <switchuvm>
  return 0;
80103a40:	83 c4 10             	add    $0x10,%esp
80103a43:	31 c0                	xor    %eax,%eax
}
80103a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a48:	5b                   	pop    %ebx
80103a49:	5e                   	pop    %esi
80103a4a:	5d                   	pop    %ebp
80103a4b:	c3                   	ret    
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a50:	83 ec 04             	sub    $0x4,%esp
80103a53:	01 c6                	add    %eax,%esi
80103a55:	56                   	push   %esi
80103a56:	50                   	push   %eax
80103a57:	ff 73 04             	pushl  0x4(%ebx)
80103a5a:	e8 f1 30 00 00       	call   80106b50 <allocuvm>
80103a5f:	83 c4 10             	add    $0x10,%esp
80103a62:	85 c0                	test   %eax,%eax
80103a64:	75 cf                	jne    80103a35 <growproc+0x25>
      return -1;
80103a66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a6b:	eb d8                	jmp    80103a45 <growproc+0x35>
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a70:	83 ec 04             	sub    $0x4,%esp
80103a73:	01 c6                	add    %eax,%esi
80103a75:	56                   	push   %esi
80103a76:	50                   	push   %eax
80103a77:	ff 73 04             	pushl  0x4(%ebx)
80103a7a:	e8 01 32 00 00       	call   80106c80 <deallocuvm>
80103a7f:	83 c4 10             	add    $0x10,%esp
80103a82:	85 c0                	test   %eax,%eax
80103a84:	75 af                	jne    80103a35 <growproc+0x25>
80103a86:	eb de                	jmp    80103a66 <growproc+0x56>
80103a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop

80103a90 <fork>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
80103a95:	53                   	push   %ebx
80103a96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a99:	e8 02 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a9e:	e8 ad fd ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103aa3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa9:	e8 42 09 00 00       	call   801043f0 <popcli>
  if((np = allocproc()) == 0){
80103aae:	e8 3d fc ff ff       	call   801036f0 <allocproc>
80103ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ab6:	85 c0                	test   %eax,%eax
80103ab8:	0f 84 b7 00 00 00    	je     80103b75 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103abe:	83 ec 08             	sub    $0x8,%esp
80103ac1:	ff 33                	pushl  (%ebx)
80103ac3:	89 c7                	mov    %eax,%edi
80103ac5:	ff 73 04             	pushl  0x4(%ebx)
80103ac8:	e8 33 33 00 00       	call   80106e00 <copyuvm>
80103acd:	83 c4 10             	add    $0x10,%esp
80103ad0:	89 47 04             	mov    %eax,0x4(%edi)
80103ad3:	85 c0                	test   %eax,%eax
80103ad5:	0f 84 a1 00 00 00    	je     80103b7c <fork+0xec>
  np->sz = curproc->sz;
80103adb:	8b 03                	mov    (%ebx),%eax
80103add:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ae0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ae2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ae5:	89 c8                	mov    %ecx,%eax
80103ae7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103aea:	b9 13 00 00 00       	mov    $0x13,%ecx
80103aef:	8b 73 18             	mov    0x18(%ebx),%esi
80103af2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103af4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103af6:	8b 40 18             	mov    0x18(%eax),%eax
80103af9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b04:	85 c0                	test   %eax,%eax
80103b06:	74 13                	je     80103b1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	50                   	push   %eax
80103b0c:	e8 5f d3 ff ff       	call   80100e70 <filedup>
80103b11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b14:	83 c4 10             	add    $0x10,%esp
80103b17:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b1b:	83 c6 01             	add    $0x1,%esi
80103b1e:	83 fe 10             	cmp    $0x10,%esi
80103b21:	75 dd                	jne    80103b00 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b23:	83 ec 0c             	sub    $0xc,%esp
80103b26:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b29:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b2c:	e8 af db ff ff       	call   801016e0 <idup>
80103b31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b37:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b3d:	6a 10                	push   $0x10
80103b3f:	53                   	push   %ebx
80103b40:	50                   	push   %eax
80103b41:	e8 2a 0c 00 00       	call   80104770 <safestrcpy>
  pid = np->pid;
80103b46:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b49:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b50:	e8 3b 09 00 00       	call   80104490 <acquire>
  np->state = RUNNABLE;
80103b55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b5c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b63:	e8 e8 09 00 00       	call   80104550 <release>
  return pid;
80103b68:	83 c4 10             	add    $0x10,%esp
}
80103b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b6e:	89 d8                	mov    %ebx,%eax
80103b70:	5b                   	pop    %ebx
80103b71:	5e                   	pop    %esi
80103b72:	5f                   	pop    %edi
80103b73:	5d                   	pop    %ebp
80103b74:	c3                   	ret    
    return -1;
80103b75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b7a:	eb ef                	jmp    80103b6b <fork+0xdb>
    kfree(np->kstack);
80103b7c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b7f:	83 ec 0c             	sub    $0xc,%esp
80103b82:	ff 73 08             	pushl  0x8(%ebx)
80103b85:	e8 56 e8 ff ff       	call   801023e0 <kfree>
    np->kstack = 0;
80103b8a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b91:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b94:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ba0:	eb c9                	jmp    80103b6b <fork+0xdb>
80103ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bb0 <scheduler>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	57                   	push   %edi
80103bb4:	56                   	push   %esi
80103bb5:	53                   	push   %ebx
80103bb6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103bb9:	e8 92 fc ff ff       	call   80103850 <mycpu>
  c->proc = 0;
80103bbe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bc5:	00 00 00 
  struct cpu *c = mycpu();
80103bc8:	89 c6                	mov    %eax,%esi
  int s = ticks;
80103bca:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80103bcf:	8d 7e 04             	lea    0x4(%esi),%edi
80103bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103bdb:	fb                   	sti    
    acquire(&ptable.lock);
80103bdc:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bdf:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103be4:	68 40 2d 11 80       	push   $0x80112d40
80103be9:	e8 a2 08 00 00       	call   80104490 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    acquire(&ptable.lock);
80103bf1:	83 c4 10             	add    $0x10,%esp
80103bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->state != RUNNABLE)
80103bf8:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103bfc:	75 46                	jne    80103c44 <scheduler+0x94>
      switchuvm(p);
80103bfe:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c01:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      time_sched+=(e-s);
80103c07:	8b 15 c0 54 11 80    	mov    0x801154c0,%edx
      switchuvm(p);
80103c0d:	53                   	push   %ebx
      time_sched+=(e-s);
80103c0e:	29 c2                	sub    %eax,%edx
80103c10:	01 15 b8 a5 10 80    	add    %edx,0x8010a5b8
      switchuvm(p);
80103c16:	e8 e5 2c 00 00       	call   80106900 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c1b:	58                   	pop    %eax
80103c1c:	5a                   	pop    %edx
80103c1d:	ff 73 1c             	pushl  0x1c(%ebx)
80103c20:	57                   	push   %edi
      p->state = RUNNING;
80103c21:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c28:	e8 9e 0b 00 00       	call   801047cb <swtch>
      switchkvm();
80103c2d:	e8 be 2c 00 00       	call   801068f0 <switchkvm>
      s=ticks;
80103c32:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80103c37:	83 c4 10             	add    $0x10,%esp
      c->proc = 0;
80103c3a:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c41:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c44:	83 c3 7c             	add    $0x7c,%ebx
80103c47:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103c4d:	75 a9                	jne    80103bf8 <scheduler+0x48>
    release(&ptable.lock);
80103c4f:	83 ec 0c             	sub    $0xc,%esp
80103c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c55:	68 40 2d 11 80       	push   $0x80112d40
80103c5a:	e8 f1 08 00 00       	call   80104550 <release>
    sti();
80103c5f:	83 c4 10             	add    $0x10,%esp
80103c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c65:	e9 6e ff ff ff       	jmp    80103bd8 <scheduler+0x28>
80103c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c70 <sched>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
  pushcli();
80103c75:	e8 26 07 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103c7a:	e8 d1 fb ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103c7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c85:	e8 66 07 00 00       	call   801043f0 <popcli>
  if(!holding(&ptable.lock))
80103c8a:	83 ec 0c             	sub    $0xc,%esp
80103c8d:	68 40 2d 11 80       	push   $0x80112d40
80103c92:	e8 b9 07 00 00       	call   80104450 <holding>
80103c97:	83 c4 10             	add    $0x10,%esp
80103c9a:	85 c0                	test   %eax,%eax
80103c9c:	74 4f                	je     80103ced <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c9e:	e8 ad fb ff ff       	call   80103850 <mycpu>
80103ca3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103caa:	75 68                	jne    80103d14 <sched+0xa4>
  if(p->state == RUNNING)
80103cac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cb0:	74 55                	je     80103d07 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cb2:	9c                   	pushf  
80103cb3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cb4:	f6 c4 02             	test   $0x2,%ah
80103cb7:	75 41                	jne    80103cfa <sched+0x8a>
  intena = mycpu()->intena;
80103cb9:	e8 92 fb ff ff       	call   80103850 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cbe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103cc1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cc7:	e8 84 fb ff ff       	call   80103850 <mycpu>
80103ccc:	83 ec 08             	sub    $0x8,%esp
80103ccf:	ff 70 04             	pushl  0x4(%eax)
80103cd2:	53                   	push   %ebx
80103cd3:	e8 f3 0a 00 00       	call   801047cb <swtch>
  mycpu()->intena = intena;
80103cd8:	e8 73 fb ff ff       	call   80103850 <mycpu>
}
80103cdd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ce0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce9:	5b                   	pop    %ebx
80103cea:	5e                   	pop    %esi
80103ceb:	5d                   	pop    %ebp
80103cec:	c3                   	ret    
    panic("sched ptable.lock");
80103ced:	83 ec 0c             	sub    $0xc,%esp
80103cf0:	68 50 75 10 80       	push   $0x80107550
80103cf5:	e8 96 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 7c 75 10 80       	push   $0x8010757c
80103d02:	e8 89 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d07:	83 ec 0c             	sub    $0xc,%esp
80103d0a:	68 6e 75 10 80       	push   $0x8010756e
80103d0f:	e8 7c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d14:	83 ec 0c             	sub    $0xc,%esp
80103d17:	68 62 75 10 80       	push   $0x80107562
80103d1c:	e8 6f c6 ff ff       	call   80100390 <panic>
80103d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop

80103d30 <exit>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	57                   	push   %edi
80103d34:	56                   	push   %esi
80103d35:	53                   	push   %ebx
80103d36:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d39:	e8 62 06 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103d3e:	e8 0d fb ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103d43:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d49:	e8 a2 06 00 00       	call   801043f0 <popcli>
  if(curproc == initproc)
80103d4e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d51:	8d 7e 68             	lea    0x68(%esi),%edi
80103d54:	39 35 bc a5 10 80    	cmp    %esi,0x8010a5bc
80103d5a:	0f 84 e7 00 00 00    	je     80103e47 <exit+0x117>
    if(curproc->ofile[fd]){
80103d60:	8b 03                	mov    (%ebx),%eax
80103d62:	85 c0                	test   %eax,%eax
80103d64:	74 12                	je     80103d78 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d66:	83 ec 0c             	sub    $0xc,%esp
80103d69:	50                   	push   %eax
80103d6a:	e8 51 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103d6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d75:	83 c4 10             	add    $0x10,%esp
80103d78:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d7b:	39 df                	cmp    %ebx,%edi
80103d7d:	75 e1                	jne    80103d60 <exit+0x30>
  begin_op();
80103d7f:	e8 0c ef ff ff       	call   80102c90 <begin_op>
  iput(curproc->cwd);
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	ff 76 68             	pushl  0x68(%esi)
80103d8a:	e8 b1 da ff ff       	call   80101840 <iput>
  end_op();
80103d8f:	e8 6c ef ff ff       	call   80102d00 <end_op>
  curproc->cwd = 0;
80103d94:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d9b:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103da2:	e8 e9 06 00 00       	call   80104490 <acquire>
  wakeup1(curproc->parent);
80103da7:	8b 56 14             	mov    0x14(%esi),%edx
80103daa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dad:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103db2:	eb 0e                	jmp    80103dc2 <exit+0x92>
80103db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db8:	83 c0 7c             	add    $0x7c,%eax
80103dbb:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103dc0:	74 1c                	je     80103dde <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103dc2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dc6:	75 f0                	jne    80103db8 <exit+0x88>
80103dc8:	3b 50 20             	cmp    0x20(%eax),%edx
80103dcb:	75 eb                	jne    80103db8 <exit+0x88>
      p->state = RUNNABLE;
80103dcd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd4:	83 c0 7c             	add    $0x7c,%eax
80103dd7:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103ddc:	75 e4                	jne    80103dc2 <exit+0x92>
      p->parent = initproc;
80103dde:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de4:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103de9:	eb 10                	jmp    80103dfb <exit+0xcb>
80103deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103def:	90                   	nop
80103df0:	83 c2 7c             	add    $0x7c,%edx
80103df3:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
80103df9:	74 33                	je     80103e2e <exit+0xfe>
    if(p->parent == curproc){
80103dfb:	39 72 14             	cmp    %esi,0x14(%edx)
80103dfe:	75 f0                	jne    80103df0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e00:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e04:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e07:	75 e7                	jne    80103df0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e09:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103e0e:	eb 0a                	jmp    80103e1a <exit+0xea>
80103e10:	83 c0 7c             	add    $0x7c,%eax
80103e13:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103e18:	74 d6                	je     80103df0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e1e:	75 f0                	jne    80103e10 <exit+0xe0>
80103e20:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e23:	75 eb                	jne    80103e10 <exit+0xe0>
      p->state = RUNNABLE;
80103e25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e2c:	eb e2                	jmp    80103e10 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e2e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e35:	e8 36 fe ff ff       	call   80103c70 <sched>
  panic("zombie exit");
80103e3a:	83 ec 0c             	sub    $0xc,%esp
80103e3d:	68 9d 75 10 80       	push   $0x8010759d
80103e42:	e8 49 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e47:	83 ec 0c             	sub    $0xc,%esp
80103e4a:	68 90 75 10 80       	push   $0x80107590
80103e4f:	e8 3c c5 ff ff       	call   80100390 <panic>
80103e54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <yield>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e67:	68 40 2d 11 80       	push   $0x80112d40
80103e6c:	e8 1f 06 00 00       	call   80104490 <acquire>
  pushcli();
80103e71:	e8 2a 05 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103e76:	e8 d5 f9 ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103e7b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e81:	e8 6a 05 00 00       	call   801043f0 <popcli>
  myproc()->state = RUNNABLE;
80103e86:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e8d:	e8 de fd ff ff       	call   80103c70 <sched>
  release(&ptable.lock);
80103e92:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e99:	e8 b2 06 00 00       	call   80104550 <release>
}
80103e9e:	83 c4 10             	add    $0x10,%esp
80103ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ea4:	c9                   	leave  
80103ea5:	c3                   	ret    
80103ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ead:	8d 76 00             	lea    0x0(%esi),%esi

80103eb0 <sleep>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 0c             	sub    $0xc,%esp
80103eb9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103ebf:	e8 dc 04 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103ec4:	e8 87 f9 ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103ec9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ecf:	e8 1c 05 00 00       	call   801043f0 <popcli>
  if(p == 0)
80103ed4:	85 db                	test   %ebx,%ebx
80103ed6:	0f 84 87 00 00 00    	je     80103f63 <sleep+0xb3>
  if(lk == 0)
80103edc:	85 f6                	test   %esi,%esi
80103ede:	74 76                	je     80103f56 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ee0:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80103ee6:	74 50                	je     80103f38 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ee8:	83 ec 0c             	sub    $0xc,%esp
80103eeb:	68 40 2d 11 80       	push   $0x80112d40
80103ef0:	e8 9b 05 00 00       	call   80104490 <acquire>
    release(lk);
80103ef5:	89 34 24             	mov    %esi,(%esp)
80103ef8:	e8 53 06 00 00       	call   80104550 <release>
  p->chan = chan;
80103efd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f00:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f07:	e8 64 fd ff ff       	call   80103c70 <sched>
  p->chan = 0;
80103f0c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f13:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103f1a:	e8 31 06 00 00       	call   80104550 <release>
    acquire(lk);
80103f1f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f22:	83 c4 10             	add    $0x10,%esp
}
80103f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f28:	5b                   	pop    %ebx
80103f29:	5e                   	pop    %esi
80103f2a:	5f                   	pop    %edi
80103f2b:	5d                   	pop    %ebp
    acquire(lk);
80103f2c:	e9 5f 05 00 00       	jmp    80104490 <acquire>
80103f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f38:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f3b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f42:	e8 29 fd ff ff       	call   80103c70 <sched>
  p->chan = 0;
80103f47:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f51:	5b                   	pop    %ebx
80103f52:	5e                   	pop    %esi
80103f53:	5f                   	pop    %edi
80103f54:	5d                   	pop    %ebp
80103f55:	c3                   	ret    
    panic("sleep without lk");
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	68 af 75 10 80       	push   $0x801075af
80103f5e:	e8 2d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f63:	83 ec 0c             	sub    $0xc,%esp
80103f66:	68 a9 75 10 80       	push   $0x801075a9
80103f6b:	e8 20 c4 ff ff       	call   80100390 <panic>

80103f70 <wait>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
  pushcli();
80103f75:	e8 26 04 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103f7a:	e8 d1 f8 ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103f7f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f85:	e8 66 04 00 00       	call   801043f0 <popcli>
  acquire(&ptable.lock);
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 40 2d 11 80       	push   $0x80112d40
80103f92:	e8 f9 04 00 00       	call   80104490 <acquire>
80103f97:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f9a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80103fa1:	eb 10                	jmp    80103fb3 <wait+0x43>
80103fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa7:	90                   	nop
80103fa8:	83 c3 7c             	add    $0x7c,%ebx
80103fab:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103fb1:	74 1b                	je     80103fce <wait+0x5e>
      if(p->parent != curproc)
80103fb3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fb6:	75 f0                	jne    80103fa8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fb8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fbc:	74 32                	je     80103ff0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fc1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc6:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103fcc:	75 e5                	jne    80103fb3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fce:	85 c0                	test   %eax,%eax
80103fd0:	74 74                	je     80104046 <wait+0xd6>
80103fd2:	8b 46 24             	mov    0x24(%esi),%eax
80103fd5:	85 c0                	test   %eax,%eax
80103fd7:	75 6d                	jne    80104046 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fd9:	83 ec 08             	sub    $0x8,%esp
80103fdc:	68 40 2d 11 80       	push   $0x80112d40
80103fe1:	56                   	push   %esi
80103fe2:	e8 c9 fe ff ff       	call   80103eb0 <sleep>
    havekids = 0;
80103fe7:	83 c4 10             	add    $0x10,%esp
80103fea:	eb ae                	jmp    80103f9a <wait+0x2a>
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103ff6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ff9:	e8 e2 e3 ff ff       	call   801023e0 <kfree>
        freevm(p->pgdir);
80103ffe:	5a                   	pop    %edx
80103fff:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104002:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104009:	e8 a2 2c 00 00       	call   80106cb0 <freevm>
        release(&ptable.lock);
8010400e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
        p->pid = 0;
80104015:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010401c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104023:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104027:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010402e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104035:	e8 16 05 00 00       	call   80104550 <release>
        return pid;
8010403a:	83 c4 10             	add    $0x10,%esp
}
8010403d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104040:	89 f0                	mov    %esi,%eax
80104042:	5b                   	pop    %ebx
80104043:	5e                   	pop    %esi
80104044:	5d                   	pop    %ebp
80104045:	c3                   	ret    
      release(&ptable.lock);
80104046:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104049:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010404e:	68 40 2d 11 80       	push   $0x80112d40
80104053:	e8 f8 04 00 00       	call   80104550 <release>
      return -1;
80104058:	83 c4 10             	add    $0x10,%esp
8010405b:	eb e0                	jmp    8010403d <wait+0xcd>
8010405d:	8d 76 00             	lea    0x0(%esi),%esi

80104060 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 10             	sub    $0x10,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010406a:	68 40 2d 11 80       	push   $0x80112d40
8010406f:	e8 1c 04 00 00       	call   80104490 <acquire>
80104074:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104077:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010407c:	eb 0c                	jmp    8010408a <wakeup+0x2a>
8010407e:	66 90                	xchg   %ax,%ax
80104080:	83 c0 7c             	add    $0x7c,%eax
80104083:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104088:	74 1c                	je     801040a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010408a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010408e:	75 f0                	jne    80104080 <wakeup+0x20>
80104090:	3b 58 20             	cmp    0x20(%eax),%ebx
80104093:	75 eb                	jne    80104080 <wakeup+0x20>
      p->state = RUNNABLE;
80104095:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010409c:	83 c0 7c             	add    $0x7c,%eax
8010409f:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801040a4:	75 e4                	jne    8010408a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801040a6:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
801040ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b0:	c9                   	leave  
  release(&ptable.lock);
801040b1:	e9 9a 04 00 00       	jmp    80104550 <release>
801040b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bd:	8d 76 00             	lea    0x0(%esi),%esi

801040c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 10             	sub    $0x10,%esp
801040c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040ca:	68 40 2d 11 80       	push   $0x80112d40
801040cf:	e8 bc 03 00 00       	call   80104490 <acquire>
801040d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040dc:	eb 0c                	jmp    801040ea <kill+0x2a>
801040de:	66 90                	xchg   %ax,%ax
801040e0:	83 c0 7c             	add    $0x7c,%eax
801040e3:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801040e8:	74 36                	je     80104120 <kill+0x60>
    if(p->pid == pid){
801040ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801040ed:	75 f1                	jne    801040e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040ef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801040f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801040fa:	75 07                	jne    80104103 <kill+0x43>
        p->state = RUNNABLE;
801040fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104103:	83 ec 0c             	sub    $0xc,%esp
80104106:	68 40 2d 11 80       	push   $0x80112d40
8010410b:	e8 40 04 00 00       	call   80104550 <release>
      return 0;
80104110:	83 c4 10             	add    $0x10,%esp
80104113:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104118:	c9                   	leave  
80104119:	c3                   	ret    
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	68 40 2d 11 80       	push   $0x80112d40
80104128:	e8 23 04 00 00       	call   80104550 <release>
  return -1;
8010412d:	83 c4 10             	add    $0x10,%esp
80104130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104138:	c9                   	leave  
80104139:	c3                   	ret    
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104140 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104148:	53                   	push   %ebx
80104149:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
8010414e:	83 ec 3c             	sub    $0x3c,%esp
80104151:	eb 24                	jmp    80104177 <procdump+0x37>
80104153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104157:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 3f 79 10 80       	push   $0x8010793f
80104160:	e8 4b c5 ff ff       	call   801006b0 <cprintf>
80104165:	83 c4 10             	add    $0x10,%esp
80104168:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010416b:	81 fb e0 4c 11 80    	cmp    $0x80114ce0,%ebx
80104171:	0f 84 81 00 00 00    	je     801041f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104177:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010417a:	85 c0                	test   %eax,%eax
8010417c:	74 ea                	je     80104168 <procdump+0x28>
      state = "???";
8010417e:	ba c0 75 10 80       	mov    $0x801075c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104183:	83 f8 05             	cmp    $0x5,%eax
80104186:	77 11                	ja     80104199 <procdump+0x59>
80104188:	8b 14 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%edx
      state = "???";
8010418f:	b8 c0 75 10 80       	mov    $0x801075c0,%eax
80104194:	85 d2                	test   %edx,%edx
80104196:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104199:	53                   	push   %ebx
8010419a:	52                   	push   %edx
8010419b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010419e:	68 c4 75 10 80       	push   $0x801075c4
801041a3:	e8 08 c5 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801041a8:	83 c4 10             	add    $0x10,%esp
801041ab:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041af:	75 a7                	jne    80104158 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041b1:	83 ec 08             	sub    $0x8,%esp
801041b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041b7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041ba:	50                   	push   %eax
801041bb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801041be:	8b 40 0c             	mov    0xc(%eax),%eax
801041c1:	83 c0 08             	add    $0x8,%eax
801041c4:	50                   	push   %eax
801041c5:	e8 86 01 00 00       	call   80104350 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801041ca:	83 c4 10             	add    $0x10,%esp
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
801041d0:	8b 17                	mov    (%edi),%edx
801041d2:	85 d2                	test   %edx,%edx
801041d4:	74 82                	je     80104158 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041d6:	83 ec 08             	sub    $0x8,%esp
801041d9:	83 c7 04             	add    $0x4,%edi
801041dc:	52                   	push   %edx
801041dd:	68 01 70 10 80       	push   $0x80107001
801041e2:	e8 c9 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801041e7:	83 c4 10             	add    $0x10,%esp
801041ea:	39 fe                	cmp    %edi,%esi
801041ec:	75 e2                	jne    801041d0 <procdump+0x90>
801041ee:	e9 65 ff ff ff       	jmp    80104158 <procdump+0x18>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
  }
}
801041f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041fb:	5b                   	pop    %ebx
801041fc:	5e                   	pop    %esi
801041fd:	5f                   	pop    %edi
801041fe:	5d                   	pop    %ebp
801041ff:	c3                   	ret    

80104200 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010420a:	68 38 76 10 80       	push   $0x80107638
8010420f:	8d 43 04             	lea    0x4(%ebx),%eax
80104212:	50                   	push   %eax
80104213:	e8 18 01 00 00       	call   80104330 <initlock>
  lk->name = name;
80104218:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010421b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104221:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104224:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010422b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010422e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104231:	c9                   	leave  
80104232:	c3                   	ret    
80104233:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104248:	8d 73 04             	lea    0x4(%ebx),%esi
8010424b:	83 ec 0c             	sub    $0xc,%esp
8010424e:	56                   	push   %esi
8010424f:	e8 3c 02 00 00       	call   80104490 <acquire>
  while (lk->locked) {
80104254:	8b 13                	mov    (%ebx),%edx
80104256:	83 c4 10             	add    $0x10,%esp
80104259:	85 d2                	test   %edx,%edx
8010425b:	74 16                	je     80104273 <acquiresleep+0x33>
8010425d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104260:	83 ec 08             	sub    $0x8,%esp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
80104265:	e8 46 fc ff ff       	call   80103eb0 <sleep>
  while (lk->locked) {
8010426a:	8b 03                	mov    (%ebx),%eax
8010426c:	83 c4 10             	add    $0x10,%esp
8010426f:	85 c0                	test   %eax,%eax
80104271:	75 ed                	jne    80104260 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104273:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104279:	e8 72 f6 ff ff       	call   801038f0 <myproc>
8010427e:	8b 40 10             	mov    0x10(%eax),%eax
80104281:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104284:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104287:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010428a:	5b                   	pop    %ebx
8010428b:	5e                   	pop    %esi
8010428c:	5d                   	pop    %ebp
  release(&lk->lk);
8010428d:	e9 be 02 00 00       	jmp    80104550 <release>
80104292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
801042a4:	53                   	push   %ebx
801042a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042a8:	8d 73 04             	lea    0x4(%ebx),%esi
801042ab:	83 ec 0c             	sub    $0xc,%esp
801042ae:	56                   	push   %esi
801042af:	e8 dc 01 00 00       	call   80104490 <acquire>
  lk->locked = 0;
801042b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801042ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042c1:	89 1c 24             	mov    %ebx,(%esp)
801042c4:	e8 97 fd ff ff       	call   80104060 <wakeup>
  release(&lk->lk);
801042c9:	89 75 08             	mov    %esi,0x8(%ebp)
801042cc:	83 c4 10             	add    $0x10,%esp
}
801042cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042d2:	5b                   	pop    %ebx
801042d3:	5e                   	pop    %esi
801042d4:	5d                   	pop    %ebp
  release(&lk->lk);
801042d5:	e9 76 02 00 00       	jmp    80104550 <release>
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	31 ff                	xor    %edi,%edi
801042e6:	56                   	push   %esi
801042e7:	53                   	push   %ebx
801042e8:	83 ec 18             	sub    $0x18,%esp
801042eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801042ee:	8d 73 04             	lea    0x4(%ebx),%esi
801042f1:	56                   	push   %esi
801042f2:	e8 99 01 00 00       	call   80104490 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801042f7:	8b 03                	mov    (%ebx),%eax
801042f9:	83 c4 10             	add    $0x10,%esp
801042fc:	85 c0                	test   %eax,%eax
801042fe:	75 18                	jne    80104318 <holdingsleep+0x38>
  release(&lk->lk);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	56                   	push   %esi
80104304:	e8 47 02 00 00       	call   80104550 <release>
  return r;
}
80104309:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010430c:	89 f8                	mov    %edi,%eax
8010430e:	5b                   	pop    %ebx
8010430f:	5e                   	pop    %esi
80104310:	5f                   	pop    %edi
80104311:	5d                   	pop    %ebp
80104312:	c3                   	ret    
80104313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104317:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104318:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010431b:	e8 d0 f5 ff ff       	call   801038f0 <myproc>
80104320:	39 58 10             	cmp    %ebx,0x10(%eax)
80104323:	0f 94 c0             	sete   %al
80104326:	0f b6 c0             	movzbl %al,%eax
80104329:	89 c7                	mov    %eax,%edi
8010432b:	eb d3                	jmp    80104300 <holdingsleep+0x20>
8010432d:	66 90                	xchg   %ax,%ax
8010432f:	90                   	nop

80104330 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104336:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104339:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010433f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104342:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104349:	5d                   	pop    %ebp
8010434a:	c3                   	ret    
8010434b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop

80104350 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104350:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104351:	31 d2                	xor    %edx,%edx
{
80104353:	89 e5                	mov    %esp,%ebp
80104355:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104356:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104359:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010435c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010435f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104360:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104366:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010436c:	77 1a                	ja     80104388 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010436e:	8b 58 04             	mov    0x4(%eax),%ebx
80104371:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104374:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104377:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104379:	83 fa 0a             	cmp    $0xa,%edx
8010437c:	75 e2                	jne    80104360 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010437e:	5b                   	pop    %ebx
8010437f:	5d                   	pop    %ebp
80104380:	c3                   	ret    
80104381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104388:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010438b:	8d 51 28             	lea    0x28(%ecx),%edx
8010438e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104396:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104399:	39 d0                	cmp    %edx,%eax
8010439b:	75 f3                	jne    80104390 <getcallerpcs+0x40>
}
8010439d:	5b                   	pop    %ebx
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
801043a7:	9c                   	pushf  
801043a8:	5b                   	pop    %ebx
  asm volatile("cli");
801043a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043aa:	e8 a1 f4 ff ff       	call   80103850 <mycpu>
801043af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043b5:	85 c0                	test   %eax,%eax
801043b7:	74 17                	je     801043d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801043b9:	e8 92 f4 ff ff       	call   80103850 <mycpu>
801043be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043c5:	83 c4 04             	add    $0x4,%esp
801043c8:	5b                   	pop    %ebx
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801043d0:	e8 7b f4 ff ff       	call   80103850 <mycpu>
801043d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801043e1:	eb d6                	jmp    801043b9 <pushcli+0x19>
801043e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <popcli>:

void
popcli(void)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043f6:	9c                   	pushf  
801043f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043f8:	f6 c4 02             	test   $0x2,%ah
801043fb:	75 35                	jne    80104432 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801043fd:	e8 4e f4 ff ff       	call   80103850 <mycpu>
80104402:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104409:	78 34                	js     8010443f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010440b:	e8 40 f4 ff ff       	call   80103850 <mycpu>
80104410:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104416:	85 d2                	test   %edx,%edx
80104418:	74 06                	je     80104420 <popcli+0x30>
    sti();
}
8010441a:	c9                   	leave  
8010441b:	c3                   	ret    
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104420:	e8 2b f4 ff ff       	call   80103850 <mycpu>
80104425:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010442b:	85 c0                	test   %eax,%eax
8010442d:	74 eb                	je     8010441a <popcli+0x2a>
  asm volatile("sti");
8010442f:	fb                   	sti    
}
80104430:	c9                   	leave  
80104431:	c3                   	ret    
    panic("popcli - interruptible");
80104432:	83 ec 0c             	sub    $0xc,%esp
80104435:	68 43 76 10 80       	push   $0x80107643
8010443a:	e8 51 bf ff ff       	call   80100390 <panic>
    panic("popcli");
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	68 5a 76 10 80       	push   $0x8010765a
80104447:	e8 44 bf ff ff       	call   80100390 <panic>
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <holding>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 75 08             	mov    0x8(%ebp),%esi
80104458:	31 db                	xor    %ebx,%ebx
  pushcli();
8010445a:	e8 41 ff ff ff       	call   801043a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010445f:	8b 06                	mov    (%esi),%eax
80104461:	85 c0                	test   %eax,%eax
80104463:	75 0b                	jne    80104470 <holding+0x20>
  popcli();
80104465:	e8 86 ff ff ff       	call   801043f0 <popcli>
}
8010446a:	89 d8                	mov    %ebx,%eax
8010446c:	5b                   	pop    %ebx
8010446d:	5e                   	pop    %esi
8010446e:	5d                   	pop    %ebp
8010446f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104470:	8b 5e 08             	mov    0x8(%esi),%ebx
80104473:	e8 d8 f3 ff ff       	call   80103850 <mycpu>
80104478:	39 c3                	cmp    %eax,%ebx
8010447a:	0f 94 c3             	sete   %bl
  popcli();
8010447d:	e8 6e ff ff ff       	call   801043f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104482:	0f b6 db             	movzbl %bl,%ebx
}
80104485:	89 d8                	mov    %ebx,%eax
80104487:	5b                   	pop    %ebx
80104488:	5e                   	pop    %esi
80104489:	5d                   	pop    %ebp
8010448a:	c3                   	ret    
8010448b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010448f:	90                   	nop

80104490 <acquire>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104495:	e8 06 ff ff ff       	call   801043a0 <pushcli>
  if(holding(lk))
8010449a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010449d:	83 ec 0c             	sub    $0xc,%esp
801044a0:	53                   	push   %ebx
801044a1:	e8 aa ff ff ff       	call   80104450 <holding>
801044a6:	83 c4 10             	add    $0x10,%esp
801044a9:	85 c0                	test   %eax,%eax
801044ab:	0f 85 83 00 00 00    	jne    80104534 <acquire+0xa4>
801044b1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801044b3:	ba 01 00 00 00       	mov    $0x1,%edx
801044b8:	eb 09                	jmp    801044c3 <acquire+0x33>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044c3:	89 d0                	mov    %edx,%eax
801044c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801044c8:	85 c0                	test   %eax,%eax
801044ca:	75 f4                	jne    801044c0 <acquire+0x30>
  __sync_synchronize();
801044cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801044d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044d4:	e8 77 f3 ff ff       	call   80103850 <mycpu>
801044d9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801044dc:	89 e8                	mov    %ebp,%eax
801044de:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044e0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801044e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801044ec:	77 22                	ja     80104510 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801044ee:	8b 50 04             	mov    0x4(%eax),%edx
801044f1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801044f5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801044f8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044fa:	83 fe 0a             	cmp    $0xa,%esi
801044fd:	75 e1                	jne    801044e0 <acquire+0x50>
}
801044ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104502:	5b                   	pop    %ebx
80104503:	5e                   	pop    %esi
80104504:	5d                   	pop    %ebp
80104505:	c3                   	ret    
80104506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
80104510:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104514:	83 c3 34             	add    $0x34,%ebx
80104517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104526:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104529:	39 d8                	cmp    %ebx,%eax
8010452b:	75 f3                	jne    80104520 <acquire+0x90>
}
8010452d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104530:	5b                   	pop    %ebx
80104531:	5e                   	pop    %esi
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
    panic("acquire");
80104534:	83 ec 0c             	sub    $0xc,%esp
80104537:	68 61 76 10 80       	push   $0x80107661
8010453c:	e8 4f be ff ff       	call   80100390 <panic>
80104541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454f:	90                   	nop

80104550 <release>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 10             	sub    $0x10,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010455a:	53                   	push   %ebx
8010455b:	e8 f0 fe ff ff       	call   80104450 <holding>
80104560:	83 c4 10             	add    $0x10,%esp
80104563:	85 c0                	test   %eax,%eax
80104565:	74 22                	je     80104589 <release+0x39>
  lk->pcs[0] = 0;
80104567:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010456e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104575:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010457a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104583:	c9                   	leave  
  popcli();
80104584:	e9 67 fe ff ff       	jmp    801043f0 <popcli>
    panic("release");
80104589:	83 ec 0c             	sub    $0xc,%esp
8010458c:	68 69 76 10 80       	push   $0x80107669
80104591:	e8 fa bd ff ff       	call   80100390 <panic>
80104596:	66 90                	xchg   %ax,%ax
80104598:	66 90                	xchg   %ax,%ax
8010459a:	66 90                	xchg   %ax,%ax
8010459c:	66 90                	xchg   %ax,%ax
8010459e:	66 90                	xchg   %ax,%ax

801045a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	8b 55 08             	mov    0x8(%ebp),%edx
801045a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801045ab:	89 d0                	mov    %edx,%eax
801045ad:	09 c8                	or     %ecx,%eax
801045af:	a8 03                	test   $0x3,%al
801045b1:	75 2d                	jne    801045e0 <memset+0x40>
    c &= 0xFF;
801045b3:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801045b7:	c1 e9 02             	shr    $0x2,%ecx
801045ba:	89 f8                	mov    %edi,%eax
801045bc:	89 fb                	mov    %edi,%ebx
801045be:	c1 e0 18             	shl    $0x18,%eax
801045c1:	c1 e3 10             	shl    $0x10,%ebx
801045c4:	09 d8                	or     %ebx,%eax
801045c6:	09 f8                	or     %edi,%eax
801045c8:	c1 e7 08             	shl    $0x8,%edi
801045cb:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801045cd:	89 d7                	mov    %edx,%edi
801045cf:	fc                   	cld    
801045d0:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801045d2:	5b                   	pop    %ebx
801045d3:	89 d0                	mov    %edx,%eax
801045d5:	5f                   	pop    %edi
801045d6:	5d                   	pop    %ebp
801045d7:	c3                   	ret    
801045d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045df:	90                   	nop
  asm volatile("cld; rep stosb" :
801045e0:	89 d7                	mov    %edx,%edi
801045e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801045e5:	fc                   	cld    
801045e6:	f3 aa                	rep stos %al,%es:(%edi)
801045e8:	5b                   	pop    %ebx
801045e9:	89 d0                	mov    %edx,%eax
801045eb:	5f                   	pop    %edi
801045ec:	5d                   	pop    %ebp
801045ed:	c3                   	ret    
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	8b 75 10             	mov    0x10(%ebp),%esi
801045f7:	8b 45 08             	mov    0x8(%ebp),%eax
801045fa:	53                   	push   %ebx
801045fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801045fe:	85 f6                	test   %esi,%esi
80104600:	74 22                	je     80104624 <memcmp+0x34>
    if(*s1 != *s2)
80104602:	0f b6 08             	movzbl (%eax),%ecx
80104605:	0f b6 1a             	movzbl (%edx),%ebx
80104608:	01 c6                	add    %eax,%esi
8010460a:	38 cb                	cmp    %cl,%bl
8010460c:	74 0c                	je     8010461a <memcmp+0x2a>
8010460e:	eb 20                	jmp    80104630 <memcmp+0x40>
80104610:	0f b6 08             	movzbl (%eax),%ecx
80104613:	0f b6 1a             	movzbl (%edx),%ebx
80104616:	38 d9                	cmp    %bl,%cl
80104618:	75 16                	jne    80104630 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
8010461a:	83 c0 01             	add    $0x1,%eax
8010461d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104620:	39 c6                	cmp    %eax,%esi
80104622:	75 ec                	jne    80104610 <memcmp+0x20>
  }

  return 0;
}
80104624:	5b                   	pop    %ebx
  return 0;
80104625:	31 c0                	xor    %eax,%eax
}
80104627:	5e                   	pop    %esi
80104628:	5d                   	pop    %ebp
80104629:	c3                   	ret    
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104630:	0f b6 c1             	movzbl %cl,%eax
80104633:	29 d8                	sub    %ebx,%eax
}
80104635:	5b                   	pop    %ebx
80104636:	5e                   	pop    %esi
80104637:	5d                   	pop    %ebp
80104638:	c3                   	ret    
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	8b 45 08             	mov    0x8(%ebp),%eax
80104647:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010464a:	56                   	push   %esi
8010464b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010464e:	39 c6                	cmp    %eax,%esi
80104650:	73 26                	jae    80104678 <memmove+0x38>
80104652:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104655:	39 f8                	cmp    %edi,%eax
80104657:	73 1f                	jae    80104678 <memmove+0x38>
80104659:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
8010465c:	85 c9                	test   %ecx,%ecx
8010465e:	74 0f                	je     8010466f <memmove+0x2f>
      *--d = *--s;
80104660:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104664:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104667:	83 ea 01             	sub    $0x1,%edx
8010466a:	83 fa ff             	cmp    $0xffffffff,%edx
8010466d:	75 f1                	jne    80104660 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010466f:	5e                   	pop    %esi
80104670:	5f                   	pop    %edi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104677:	90                   	nop
80104678:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
8010467b:	89 c7                	mov    %eax,%edi
8010467d:	85 c9                	test   %ecx,%ecx
8010467f:	74 ee                	je     8010466f <memmove+0x2f>
80104681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104688:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104689:	39 d6                	cmp    %edx,%esi
8010468b:	75 fb                	jne    80104688 <memmove+0x48>
}
8010468d:	5e                   	pop    %esi
8010468e:	5f                   	pop    %edi
8010468f:	5d                   	pop    %ebp
80104690:	c3                   	ret    
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046a0:	eb 9e                	jmp    80104640 <memmove>
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	8b 7d 10             	mov    0x10(%ebp),%edi
801046b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046ba:	56                   	push   %esi
801046bb:	8b 75 0c             	mov    0xc(%ebp),%esi
801046be:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
801046bf:	85 ff                	test   %edi,%edi
801046c1:	74 2f                	je     801046f2 <strncmp+0x42>
801046c3:	0f b6 11             	movzbl (%ecx),%edx
801046c6:	0f b6 1e             	movzbl (%esi),%ebx
801046c9:	84 d2                	test   %dl,%dl
801046cb:	74 37                	je     80104704 <strncmp+0x54>
801046cd:	38 da                	cmp    %bl,%dl
801046cf:	75 33                	jne    80104704 <strncmp+0x54>
801046d1:	01 f7                	add    %esi,%edi
801046d3:	eb 13                	jmp    801046e8 <strncmp+0x38>
801046d5:	8d 76 00             	lea    0x0(%esi),%esi
801046d8:	0f b6 11             	movzbl (%ecx),%edx
801046db:	84 d2                	test   %dl,%dl
801046dd:	74 21                	je     80104700 <strncmp+0x50>
801046df:	0f b6 18             	movzbl (%eax),%ebx
801046e2:	89 c6                	mov    %eax,%esi
801046e4:	38 da                	cmp    %bl,%dl
801046e6:	75 1c                	jne    80104704 <strncmp+0x54>
    n--, p++, q++;
801046e8:	8d 46 01             	lea    0x1(%esi),%eax
801046eb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801046ee:	39 f8                	cmp    %edi,%eax
801046f0:	75 e6                	jne    801046d8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801046f2:	5b                   	pop    %ebx
    return 0;
801046f3:	31 c0                	xor    %eax,%eax
}
801046f5:	5e                   	pop    %esi
801046f6:	5f                   	pop    %edi
801046f7:	5d                   	pop    %ebp
801046f8:	c3                   	ret    
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104700:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104704:	0f b6 c2             	movzbl %dl,%eax
80104707:	29 d8                	sub    %ebx,%eax
}
80104709:	5b                   	pop    %ebx
8010470a:	5e                   	pop    %esi
8010470b:	5f                   	pop    %edi
8010470c:	5d                   	pop    %ebp
8010470d:	c3                   	ret    
8010470e:	66 90                	xchg   %ax,%ax

80104710 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104717:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
8010471a:	56                   	push   %esi
8010471b:	53                   	push   %ebx
8010471c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
8010471f:	eb 1a                	jmp    8010473b <strncpy+0x2b>
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104728:	83 c2 01             	add    $0x1,%edx
8010472b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
8010472f:	83 c1 01             	add    $0x1,%ecx
80104732:	88 41 ff             	mov    %al,-0x1(%ecx)
80104735:	84 c0                	test   %al,%al
80104737:	74 09                	je     80104742 <strncpy+0x32>
80104739:	89 fb                	mov    %edi,%ebx
8010473b:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010473e:	85 db                	test   %ebx,%ebx
80104740:	7f e6                	jg     80104728 <strncpy+0x18>
    ;
  while(n-- > 0)
80104742:	89 ce                	mov    %ecx,%esi
80104744:	85 ff                	test   %edi,%edi
80104746:	7e 1b                	jle    80104763 <strncpy+0x53>
80104748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474f:	90                   	nop
    *s++ = 0;
80104750:	83 c6 01             	add    $0x1,%esi
80104753:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104757:	89 f2                	mov    %esi,%edx
80104759:	f7 d2                	not    %edx
8010475b:	01 ca                	add    %ecx,%edx
8010475d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
8010475f:	85 d2                	test   %edx,%edx
80104761:	7f ed                	jg     80104750 <strncpy+0x40>
  return os;
}
80104763:	5b                   	pop    %ebx
80104764:	8b 45 08             	mov    0x8(%ebp),%eax
80104767:	5e                   	pop    %esi
80104768:	5f                   	pop    %edi
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret    
8010476b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop

80104770 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104777:	8b 45 08             	mov    0x8(%ebp),%eax
8010477a:	53                   	push   %ebx
8010477b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010477e:	85 c9                	test   %ecx,%ecx
80104780:	7e 26                	jle    801047a8 <safestrcpy+0x38>
80104782:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104786:	89 c1                	mov    %eax,%ecx
80104788:	eb 17                	jmp    801047a1 <safestrcpy+0x31>
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104790:	83 c2 01             	add    $0x1,%edx
80104793:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104797:	83 c1 01             	add    $0x1,%ecx
8010479a:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010479d:	84 db                	test   %bl,%bl
8010479f:	74 04                	je     801047a5 <safestrcpy+0x35>
801047a1:	39 f2                	cmp    %esi,%edx
801047a3:	75 eb                	jne    80104790 <safestrcpy+0x20>
    ;
  *s = 0;
801047a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047a8:	5b                   	pop    %ebx
801047a9:	5e                   	pop    %esi
801047aa:	5d                   	pop    %ebp
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <strlen>:

int
strlen(const char *s)
{
801047b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047b1:	31 c0                	xor    %eax,%eax
{
801047b3:	89 e5                	mov    %esp,%ebp
801047b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801047b8:	80 3a 00             	cmpb   $0x0,(%edx)
801047bb:	74 0c                	je     801047c9 <strlen+0x19>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	83 c0 01             	add    $0x1,%eax
801047c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801047c7:	75 f7                	jne    801047c0 <strlen+0x10>
    ;
  return n;
}
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    

801047cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801047cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801047cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801047d3:	55                   	push   %ebp
  pushl %ebx
801047d4:	53                   	push   %ebx
  pushl %esi
801047d5:	56                   	push   %esi
  pushl %edi
801047d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801047d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801047d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801047db:	5f                   	pop    %edi
  popl %esi
801047dc:	5e                   	pop    %esi
  popl %ebx
801047dd:	5b                   	pop    %ebx
  popl %ebp
801047de:	5d                   	pop    %ebp
  ret
801047df:	c3                   	ret    

801047e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801047ea:	e8 01 f1 ff ff       	call   801038f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047ef:	8b 00                	mov    (%eax),%eax
801047f1:	39 d8                	cmp    %ebx,%eax
801047f3:	76 1b                	jbe    80104810 <fetchint+0x30>
801047f5:	8d 53 04             	lea    0x4(%ebx),%edx
801047f8:	39 d0                	cmp    %edx,%eax
801047fa:	72 14                	jb     80104810 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801047fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ff:	8b 13                	mov    (%ebx),%edx
80104801:	89 10                	mov    %edx,(%eax)
  return 0;
80104803:	31 c0                	xor    %eax,%eax
}
80104805:	83 c4 04             	add    $0x4,%esp
80104808:	5b                   	pop    %ebx
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop
    return -1;
80104810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104815:	eb ee                	jmp    80104805 <fetchint+0x25>
80104817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481e:	66 90                	xchg   %ax,%ax

80104820 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
80104827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010482a:	e8 c1 f0 ff ff       	call   801038f0 <myproc>

  if(addr >= curproc->sz)
8010482f:	39 18                	cmp    %ebx,(%eax)
80104831:	76 29                	jbe    8010485c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104833:	8b 55 0c             	mov    0xc(%ebp),%edx
80104836:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104838:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010483a:	39 d3                	cmp    %edx,%ebx
8010483c:	73 1e                	jae    8010485c <fetchstr+0x3c>
    if(*s == 0)
8010483e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104841:	74 35                	je     80104878 <fetchstr+0x58>
80104843:	89 d8                	mov    %ebx,%eax
80104845:	eb 0e                	jmp    80104855 <fetchstr+0x35>
80104847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484e:	66 90                	xchg   %ax,%ax
80104850:	80 38 00             	cmpb   $0x0,(%eax)
80104853:	74 1b                	je     80104870 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104855:	83 c0 01             	add    $0x1,%eax
80104858:	39 c2                	cmp    %eax,%edx
8010485a:	77 f4                	ja     80104850 <fetchstr+0x30>
    return -1;
8010485c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104861:	83 c4 04             	add    $0x4,%esp
80104864:	5b                   	pop    %ebx
80104865:	5d                   	pop    %ebp
80104866:	c3                   	ret    
80104867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486e:	66 90                	xchg   %ax,%ax
80104870:	83 c4 04             	add    $0x4,%esp
80104873:	29 d8                	sub    %ebx,%eax
80104875:	5b                   	pop    %ebx
80104876:	5d                   	pop    %ebp
80104877:	c3                   	ret    
    if(*s == 0)
80104878:	31 c0                	xor    %eax,%eax
      return s - *pp;
8010487a:	eb e5                	jmp    80104861 <fetchstr+0x41>
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104885:	e8 66 f0 ff ff       	call   801038f0 <myproc>
8010488a:	8b 55 08             	mov    0x8(%ebp),%edx
8010488d:	8b 40 18             	mov    0x18(%eax),%eax
80104890:	8b 40 44             	mov    0x44(%eax),%eax
80104893:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104896:	e8 55 f0 ff ff       	call   801038f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010489b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010489e:	8b 00                	mov    (%eax),%eax
801048a0:	39 c6                	cmp    %eax,%esi
801048a2:	73 1c                	jae    801048c0 <argint+0x40>
801048a4:	8d 53 08             	lea    0x8(%ebx),%edx
801048a7:	39 d0                	cmp    %edx,%eax
801048a9:	72 15                	jb     801048c0 <argint+0x40>
  *ip = *(int*)(addr);
801048ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ae:	8b 53 04             	mov    0x4(%ebx),%edx
801048b1:	89 10                	mov    %edx,(%eax)
  return 0;
801048b3:	31 c0                	xor    %eax,%eax
}
801048b5:	5b                   	pop    %ebx
801048b6:	5e                   	pop    %esi
801048b7:	5d                   	pop    %ebp
801048b8:	c3                   	ret    
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048c5:	eb ee                	jmp    801048b5 <argint+0x35>
801048c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	83 ec 10             	sub    $0x10,%esp
801048d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801048db:	e8 10 f0 ff ff       	call   801038f0 <myproc>
 
  if(argint(n, &i) < 0)
801048e0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801048e3:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801048e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048e8:	50                   	push   %eax
801048e9:	ff 75 08             	pushl  0x8(%ebp)
801048ec:	e8 8f ff ff ff       	call   80104880 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801048f1:	83 c4 10             	add    $0x10,%esp
801048f4:	85 c0                	test   %eax,%eax
801048f6:	78 28                	js     80104920 <argptr+0x50>
801048f8:	85 db                	test   %ebx,%ebx
801048fa:	78 24                	js     80104920 <argptr+0x50>
801048fc:	8b 16                	mov    (%esi),%edx
801048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104901:	39 c2                	cmp    %eax,%edx
80104903:	76 1b                	jbe    80104920 <argptr+0x50>
80104905:	01 c3                	add    %eax,%ebx
80104907:	39 da                	cmp    %ebx,%edx
80104909:	72 15                	jb     80104920 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010490b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010490e:	89 02                	mov    %eax,(%edx)
  return 0;
80104910:	31 c0                	xor    %eax,%eax
}
80104912:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104915:	5b                   	pop    %ebx
80104916:	5e                   	pop    %esi
80104917:	5d                   	pop    %ebp
80104918:	c3                   	ret    
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104925:	eb eb                	jmp    80104912 <argptr+0x42>
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax

80104930 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104939:	50                   	push   %eax
8010493a:	ff 75 08             	pushl  0x8(%ebp)
8010493d:	e8 3e ff ff ff       	call   80104880 <argint>
80104942:	83 c4 10             	add    $0x10,%esp
80104945:	85 c0                	test   %eax,%eax
80104947:	78 17                	js     80104960 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104949:	83 ec 08             	sub    $0x8,%esp
8010494c:	ff 75 0c             	pushl  0xc(%ebp)
8010494f:	ff 75 f4             	pushl  -0xc(%ebp)
80104952:	e8 c9 fe ff ff       	call   80104820 <fetchstr>
80104957:	83 c4 10             	add    $0x10,%esp
}
8010495a:	c9                   	leave  
8010495b:	c3                   	ret    
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104960:	c9                   	leave  
    return -1;
80104961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104966:	c3                   	ret    
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax

80104970 <syscall>:

};

void
syscall(void)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104977:	e8 74 ef ff ff       	call   801038f0 <myproc>
8010497c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010497e:	8b 40 18             	mov    0x18(%eax),%eax
80104981:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104984:	8d 50 ff             	lea    -0x1(%eax),%edx
80104987:	83 fa 16             	cmp    $0x16,%edx
8010498a:	77 1c                	ja     801049a8 <syscall+0x38>
8010498c:	8b 14 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%edx
80104993:	85 d2                	test   %edx,%edx
80104995:	74 11                	je     801049a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104997:	ff d2                	call   *%edx
80104999:	8b 53 18             	mov    0x18(%ebx),%edx
8010499c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010499f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a2:	c9                   	leave  
801049a3:	c3                   	ret    
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049a8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049a9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049ac:	50                   	push   %eax
801049ad:	ff 73 10             	pushl  0x10(%ebx)
801049b0:	68 71 76 10 80       	push   $0x80107671
801049b5:	e8 f6 bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801049ba:	8b 43 18             	mov    0x18(%ebx),%eax
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801049c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049ca:	c9                   	leave  
801049cb:	c3                   	ret    
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801049d6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801049d9:	83 ec 34             	sub    $0x34,%esp
801049dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801049df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801049e2:	53                   	push   %ebx
801049e3:	50                   	push   %eax
{
801049e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801049ea:	e8 e1 d5 ff ff       	call   80101fd0 <nameiparent>
801049ef:	83 c4 10             	add    $0x10,%esp
801049f2:	85 c0                	test   %eax,%eax
801049f4:	0f 84 46 01 00 00    	je     80104b40 <create+0x170>
    return 0;
  ilock(dp);
801049fa:	83 ec 0c             	sub    $0xc,%esp
801049fd:	89 c6                	mov    %eax,%esi
801049ff:	50                   	push   %eax
80104a00:	e8 0b cd ff ff       	call   80101710 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a05:	83 c4 0c             	add    $0xc,%esp
80104a08:	6a 00                	push   $0x0
80104a0a:	53                   	push   %ebx
80104a0b:	56                   	push   %esi
80104a0c:	e8 2f d2 ff ff       	call   80101c40 <dirlookup>
80104a11:	83 c4 10             	add    $0x10,%esp
80104a14:	89 c7                	mov    %eax,%edi
80104a16:	85 c0                	test   %eax,%eax
80104a18:	74 56                	je     80104a70 <create+0xa0>
    iunlockput(dp);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
80104a1d:	56                   	push   %esi
80104a1e:	e8 7d cf ff ff       	call   801019a0 <iunlockput>
    ilock(ip);
80104a23:	89 3c 24             	mov    %edi,(%esp)
80104a26:	e8 e5 cc ff ff       	call   80101710 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a2b:	83 c4 10             	add    $0x10,%esp
80104a2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104a33:	75 1b                	jne    80104a50 <create+0x80>
80104a35:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104a3a:	75 14                	jne    80104a50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a3f:	89 f8                	mov    %edi,%eax
80104a41:	5b                   	pop    %ebx
80104a42:	5e                   	pop    %esi
80104a43:	5f                   	pop    %edi
80104a44:	5d                   	pop    %ebp
80104a45:	c3                   	ret    
80104a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	57                   	push   %edi
    return 0;
80104a54:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a56:	e8 45 cf ff ff       	call   801019a0 <iunlockput>
    return 0;
80104a5b:	83 c4 10             	add    $0x10,%esp
}
80104a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a61:	89 f8                	mov    %edi,%eax
80104a63:	5b                   	pop    %ebx
80104a64:	5e                   	pop    %esi
80104a65:	5f                   	pop    %edi
80104a66:	5d                   	pop    %ebp
80104a67:	c3                   	ret    
80104a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104a70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104a74:	83 ec 08             	sub    $0x8,%esp
80104a77:	50                   	push   %eax
80104a78:	ff 36                	pushl  (%esi)
80104a7a:	e8 21 cb ff ff       	call   801015a0 <ialloc>
80104a7f:	83 c4 10             	add    $0x10,%esp
80104a82:	89 c7                	mov    %eax,%edi
80104a84:	85 c0                	test   %eax,%eax
80104a86:	0f 84 cd 00 00 00    	je     80104b59 <create+0x189>
  ilock(ip);
80104a8c:	83 ec 0c             	sub    $0xc,%esp
80104a8f:	50                   	push   %eax
80104a90:	e8 7b cc ff ff       	call   80101710 <ilock>
  ip->major = major;
80104a95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104a99:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104a9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104aa1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104aa5:	b8 01 00 00 00       	mov    $0x1,%eax
80104aaa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104aae:	89 3c 24             	mov    %edi,(%esp)
80104ab1:	e8 aa cb ff ff       	call   80101660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ab6:	83 c4 10             	add    $0x10,%esp
80104ab9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104abe:	74 30                	je     80104af0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ac0:	83 ec 04             	sub    $0x4,%esp
80104ac3:	ff 77 04             	pushl  0x4(%edi)
80104ac6:	53                   	push   %ebx
80104ac7:	56                   	push   %esi
80104ac8:	e8 23 d4 ff ff       	call   80101ef0 <dirlink>
80104acd:	83 c4 10             	add    $0x10,%esp
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	78 78                	js     80104b4c <create+0x17c>
  iunlockput(dp);
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	56                   	push   %esi
80104ad8:	e8 c3 ce ff ff       	call   801019a0 <iunlockput>
  return ip;
80104add:	83 c4 10             	add    $0x10,%esp
}
80104ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ae3:	89 f8                	mov    %edi,%eax
80104ae5:	5b                   	pop    %ebx
80104ae6:	5e                   	pop    %esi
80104ae7:	5f                   	pop    %edi
80104ae8:	5d                   	pop    %ebp
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104af0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104af3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104af8:	56                   	push   %esi
80104af9:	e8 62 cb ff ff       	call   80101660 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104afe:	83 c4 0c             	add    $0xc,%esp
80104b01:	ff 77 04             	pushl  0x4(%edi)
80104b04:	68 1c 77 10 80       	push   $0x8010771c
80104b09:	57                   	push   %edi
80104b0a:	e8 e1 d3 ff ff       	call   80101ef0 <dirlink>
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	85 c0                	test   %eax,%eax
80104b14:	78 18                	js     80104b2e <create+0x15e>
80104b16:	83 ec 04             	sub    $0x4,%esp
80104b19:	ff 76 04             	pushl  0x4(%esi)
80104b1c:	68 1b 77 10 80       	push   $0x8010771b
80104b21:	57                   	push   %edi
80104b22:	e8 c9 d3 ff ff       	call   80101ef0 <dirlink>
80104b27:	83 c4 10             	add    $0x10,%esp
80104b2a:	85 c0                	test   %eax,%eax
80104b2c:	79 92                	jns    80104ac0 <create+0xf0>
      panic("create dots");
80104b2e:	83 ec 0c             	sub    $0xc,%esp
80104b31:	68 0f 77 10 80       	push   $0x8010770f
80104b36:	e8 55 b8 ff ff       	call   80100390 <panic>
80104b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
}
80104b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b43:	31 ff                	xor    %edi,%edi
}
80104b45:	5b                   	pop    %ebx
80104b46:	89 f8                	mov    %edi,%eax
80104b48:	5e                   	pop    %esi
80104b49:	5f                   	pop    %edi
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
    panic("create: dirlink");
80104b4c:	83 ec 0c             	sub    $0xc,%esp
80104b4f:	68 1e 77 10 80       	push   $0x8010771e
80104b54:	e8 37 b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104b59:	83 ec 0c             	sub    $0xc,%esp
80104b5c:	68 00 77 10 80       	push   $0x80107700
80104b61:	e8 2a b8 ff ff       	call   80100390 <panic>
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi

80104b70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	89 d6                	mov    %edx,%esi
80104b76:	53                   	push   %ebx
80104b77:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104b79:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104b7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b7f:	50                   	push   %eax
80104b80:	6a 00                	push   $0x0
80104b82:	e8 f9 fc ff ff       	call   80104880 <argint>
80104b87:	83 c4 10             	add    $0x10,%esp
80104b8a:	85 c0                	test   %eax,%eax
80104b8c:	78 2a                	js     80104bb8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b92:	77 24                	ja     80104bb8 <argfd.constprop.0+0x48>
80104b94:	e8 57 ed ff ff       	call   801038f0 <myproc>
80104b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	74 14                	je     80104bb8 <argfd.constprop.0+0x48>
  if(pfd)
80104ba4:	85 db                	test   %ebx,%ebx
80104ba6:	74 02                	je     80104baa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ba8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104baa:	89 06                	mov    %eax,(%esi)
  return 0;
80104bac:	31 c0                	xor    %eax,%eax
}
80104bae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb1:	5b                   	pop    %ebx
80104bb2:	5e                   	pop    %esi
80104bb3:	5d                   	pop    %ebp
80104bb4:	c3                   	ret    
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bbd:	eb ef                	jmp    80104bae <argfd.constprop.0+0x3e>
80104bbf:	90                   	nop

80104bc0 <sys_dup>:
{
80104bc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104bc1:	31 c0                	xor    %eax,%eax
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	56                   	push   %esi
80104bc6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104bc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104bca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104bcd:	e8 9e ff ff ff       	call   80104b70 <argfd.constprop.0>
80104bd2:	85 c0                	test   %eax,%eax
80104bd4:	78 1a                	js     80104bf0 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104bd6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104bd9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104bdb:	e8 10 ed ff ff       	call   801038f0 <myproc>
    if(curproc->ofile[fd] == 0){
80104be0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104be4:	85 d2                	test   %edx,%edx
80104be6:	74 18                	je     80104c00 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104be8:	83 c3 01             	add    $0x1,%ebx
80104beb:	83 fb 10             	cmp    $0x10,%ebx
80104bee:	75 f0                	jne    80104be0 <sys_dup+0x20>
}
80104bf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104bf3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104bf8:	89 d8                	mov    %ebx,%eax
80104bfa:	5b                   	pop    %ebx
80104bfb:	5e                   	pop    %esi
80104bfc:	5d                   	pop    %ebp
80104bfd:	c3                   	ret    
80104bfe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c00:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0a:	e8 61 c2 ff ff       	call   80100e70 <filedup>
  return fd;
80104c0f:	83 c4 10             	add    $0x10,%esp
}
80104c12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c15:	89 d8                	mov    %ebx,%eax
80104c17:	5b                   	pop    %ebx
80104c18:	5e                   	pop    %esi
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c1f:	90                   	nop

80104c20 <sys_read>:
{
80104c20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c21:	31 c0                	xor    %eax,%eax
{
80104c23:	89 e5                	mov    %esp,%ebp
80104c25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c2b:	e8 40 ff ff ff       	call   80104b70 <argfd.constprop.0>
80104c30:	85 c0                	test   %eax,%eax
80104c32:	78 4c                	js     80104c80 <sys_read+0x60>
80104c34:	83 ec 08             	sub    $0x8,%esp
80104c37:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c3a:	50                   	push   %eax
80104c3b:	6a 02                	push   $0x2
80104c3d:	e8 3e fc ff ff       	call   80104880 <argint>
80104c42:	83 c4 10             	add    $0x10,%esp
80104c45:	85 c0                	test   %eax,%eax
80104c47:	78 37                	js     80104c80 <sys_read+0x60>
80104c49:	83 ec 04             	sub    $0x4,%esp
80104c4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c52:	50                   	push   %eax
80104c53:	6a 01                	push   $0x1
80104c55:	e8 76 fc ff ff       	call   801048d0 <argptr>
80104c5a:	83 c4 10             	add    $0x10,%esp
80104c5d:	85 c0                	test   %eax,%eax
80104c5f:	78 1f                	js     80104c80 <sys_read+0x60>
  return fileread(f, p, n);
80104c61:	83 ec 04             	sub    $0x4,%esp
80104c64:	ff 75 f0             	pushl  -0x10(%ebp)
80104c67:	ff 75 f4             	pushl  -0xc(%ebp)
80104c6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c6d:	e8 7e c3 ff ff       	call   80100ff0 <fileread>
80104c72:	83 c4 10             	add    $0x10,%esp
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax
80104c80:	c9                   	leave  
    return -1;
80104c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c86:	c3                   	ret    
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <sys_write>:
{
80104c90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c91:	31 c0                	xor    %eax,%eax
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c9b:	e8 d0 fe ff ff       	call   80104b70 <argfd.constprop.0>
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	78 4c                	js     80104cf0 <sys_write+0x60>
80104ca4:	83 ec 08             	sub    $0x8,%esp
80104ca7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104caa:	50                   	push   %eax
80104cab:	6a 02                	push   $0x2
80104cad:	e8 ce fb ff ff       	call   80104880 <argint>
80104cb2:	83 c4 10             	add    $0x10,%esp
80104cb5:	85 c0                	test   %eax,%eax
80104cb7:	78 37                	js     80104cf0 <sys_write+0x60>
80104cb9:	83 ec 04             	sub    $0x4,%esp
80104cbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cbf:	ff 75 f0             	pushl  -0x10(%ebp)
80104cc2:	50                   	push   %eax
80104cc3:	6a 01                	push   $0x1
80104cc5:	e8 06 fc ff ff       	call   801048d0 <argptr>
80104cca:	83 c4 10             	add    $0x10,%esp
80104ccd:	85 c0                	test   %eax,%eax
80104ccf:	78 1f                	js     80104cf0 <sys_write+0x60>
  return filewrite(f, p, n);
80104cd1:	83 ec 04             	sub    $0x4,%esp
80104cd4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cda:	ff 75 ec             	pushl  -0x14(%ebp)
80104cdd:	e8 9e c3 ff ff       	call   80101080 <filewrite>
80104ce2:	83 c4 10             	add    $0x10,%esp
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cee:	66 90                	xchg   %ax,%ax
80104cf0:	c9                   	leave  
    return -1;
80104cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf6:	c3                   	ret    
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <sys_close>:
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d06:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d09:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d0c:	e8 5f fe ff ff       	call   80104b70 <argfd.constprop.0>
80104d11:	85 c0                	test   %eax,%eax
80104d13:	78 2b                	js     80104d40 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d15:	e8 d6 eb ff ff       	call   801038f0 <myproc>
80104d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d1d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d20:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d27:	00 
  fileclose(f);
80104d28:	ff 75 f4             	pushl  -0xc(%ebp)
80104d2b:	e8 90 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104d30:	83 c4 10             	add    $0x10,%esp
80104d33:	31 c0                	xor    %eax,%eax
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
80104d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3e:	66 90                	xchg   %ax,%ax
80104d40:	c9                   	leave  
    return -1;
80104d41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d46:	c3                   	ret    
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <sys_fstat>:
{
80104d50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d51:	31 c0                	xor    %eax,%eax
{
80104d53:	89 e5                	mov    %esp,%ebp
80104d55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d58:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d5b:	e8 10 fe ff ff       	call   80104b70 <argfd.constprop.0>
80104d60:	85 c0                	test   %eax,%eax
80104d62:	78 2c                	js     80104d90 <sys_fstat+0x40>
80104d64:	83 ec 04             	sub    $0x4,%esp
80104d67:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6a:	6a 14                	push   $0x14
80104d6c:	50                   	push   %eax
80104d6d:	6a 01                	push   $0x1
80104d6f:	e8 5c fb ff ff       	call   801048d0 <argptr>
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	85 c0                	test   %eax,%eax
80104d79:	78 15                	js     80104d90 <sys_fstat+0x40>
  return filestat(f, st);
80104d7b:	83 ec 08             	sub    $0x8,%esp
80104d7e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d81:	ff 75 f0             	pushl  -0x10(%ebp)
80104d84:	e8 17 c2 ff ff       	call   80100fa0 <filestat>
80104d89:	83 c4 10             	add    $0x10,%esp
}
80104d8c:	c9                   	leave  
80104d8d:	c3                   	ret    
80104d8e:	66 90                	xchg   %ax,%ax
80104d90:	c9                   	leave  
    return -1;
80104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_link>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104da5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104da8:	53                   	push   %ebx
80104da9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dac:	50                   	push   %eax
80104dad:	6a 00                	push   $0x0
80104daf:	e8 7c fb ff ff       	call   80104930 <argstr>
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 c0                	test   %eax,%eax
80104db9:	0f 88 fb 00 00 00    	js     80104eba <sys_link+0x11a>
80104dbf:	83 ec 08             	sub    $0x8,%esp
80104dc2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104dc5:	50                   	push   %eax
80104dc6:	6a 01                	push   $0x1
80104dc8:	e8 63 fb ff ff       	call   80104930 <argstr>
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	0f 88 e2 00 00 00    	js     80104eba <sys_link+0x11a>
  begin_op();
80104dd8:	e8 b3 de ff ff       	call   80102c90 <begin_op>
  if((ip = namei(old)) == 0){
80104ddd:	83 ec 0c             	sub    $0xc,%esp
80104de0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104de3:	e8 c8 d1 ff ff       	call   80101fb0 <namei>
80104de8:	83 c4 10             	add    $0x10,%esp
80104deb:	89 c3                	mov    %eax,%ebx
80104ded:	85 c0                	test   %eax,%eax
80104def:	0f 84 e4 00 00 00    	je     80104ed9 <sys_link+0x139>
  ilock(ip);
80104df5:	83 ec 0c             	sub    $0xc,%esp
80104df8:	50                   	push   %eax
80104df9:	e8 12 c9 ff ff       	call   80101710 <ilock>
  if(ip->type == T_DIR){
80104dfe:	83 c4 10             	add    $0x10,%esp
80104e01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e06:	0f 84 b5 00 00 00    	je     80104ec1 <sys_link+0x121>
  iupdate(ip);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e0f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e14:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e17:	53                   	push   %ebx
80104e18:	e8 43 c8 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104e1d:	89 1c 24             	mov    %ebx,(%esp)
80104e20:	e8 cb c9 ff ff       	call   801017f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e25:	58                   	pop    %eax
80104e26:	5a                   	pop    %edx
80104e27:	57                   	push   %edi
80104e28:	ff 75 d0             	pushl  -0x30(%ebp)
80104e2b:	e8 a0 d1 ff ff       	call   80101fd0 <nameiparent>
80104e30:	83 c4 10             	add    $0x10,%esp
80104e33:	89 c6                	mov    %eax,%esi
80104e35:	85 c0                	test   %eax,%eax
80104e37:	74 5b                	je     80104e94 <sys_link+0xf4>
  ilock(dp);
80104e39:	83 ec 0c             	sub    $0xc,%esp
80104e3c:	50                   	push   %eax
80104e3d:	e8 ce c8 ff ff       	call   80101710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e42:	83 c4 10             	add    $0x10,%esp
80104e45:	8b 03                	mov    (%ebx),%eax
80104e47:	39 06                	cmp    %eax,(%esi)
80104e49:	75 3d                	jne    80104e88 <sys_link+0xe8>
80104e4b:	83 ec 04             	sub    $0x4,%esp
80104e4e:	ff 73 04             	pushl  0x4(%ebx)
80104e51:	57                   	push   %edi
80104e52:	56                   	push   %esi
80104e53:	e8 98 d0 ff ff       	call   80101ef0 <dirlink>
80104e58:	83 c4 10             	add    $0x10,%esp
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	78 29                	js     80104e88 <sys_link+0xe8>
  iunlockput(dp);
80104e5f:	83 ec 0c             	sub    $0xc,%esp
80104e62:	56                   	push   %esi
80104e63:	e8 38 cb ff ff       	call   801019a0 <iunlockput>
  iput(ip);
80104e68:	89 1c 24             	mov    %ebx,(%esp)
80104e6b:	e8 d0 c9 ff ff       	call   80101840 <iput>
  end_op();
80104e70:	e8 8b de ff ff       	call   80102d00 <end_op>
  return 0;
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	31 c0                	xor    %eax,%eax
}
80104e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e7d:	5b                   	pop    %ebx
80104e7e:	5e                   	pop    %esi
80104e7f:	5f                   	pop    %edi
80104e80:	5d                   	pop    %ebp
80104e81:	c3                   	ret    
80104e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104e88:	83 ec 0c             	sub    $0xc,%esp
80104e8b:	56                   	push   %esi
80104e8c:	e8 0f cb ff ff       	call   801019a0 <iunlockput>
    goto bad;
80104e91:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	53                   	push   %ebx
80104e98:	e8 73 c8 ff ff       	call   80101710 <ilock>
  ip->nlink--;
80104e9d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ea2:	89 1c 24             	mov    %ebx,(%esp)
80104ea5:	e8 b6 c7 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104eaa:	89 1c 24             	mov    %ebx,(%esp)
80104ead:	e8 ee ca ff ff       	call   801019a0 <iunlockput>
  end_op();
80104eb2:	e8 49 de ff ff       	call   80102d00 <end_op>
  return -1;
80104eb7:	83 c4 10             	add    $0x10,%esp
80104eba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebf:	eb b9                	jmp    80104e7a <sys_link+0xda>
    iunlockput(ip);
80104ec1:	83 ec 0c             	sub    $0xc,%esp
80104ec4:	53                   	push   %ebx
80104ec5:	e8 d6 ca ff ff       	call   801019a0 <iunlockput>
    end_op();
80104eca:	e8 31 de ff ff       	call   80102d00 <end_op>
    return -1;
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed7:	eb a1                	jmp    80104e7a <sys_link+0xda>
    end_op();
80104ed9:	e8 22 de ff ff       	call   80102d00 <end_op>
    return -1;
80104ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee3:	eb 95                	jmp    80104e7a <sys_link+0xda>
80104ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <sys_unlink>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	57                   	push   %edi
80104ef4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104ef5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104ef8:	53                   	push   %ebx
80104ef9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104efc:	50                   	push   %eax
80104efd:	6a 00                	push   $0x0
80104eff:	e8 2c fa ff ff       	call   80104930 <argstr>
80104f04:	83 c4 10             	add    $0x10,%esp
80104f07:	85 c0                	test   %eax,%eax
80104f09:	0f 88 91 01 00 00    	js     801050a0 <sys_unlink+0x1b0>
  begin_op();
80104f0f:	e8 7c dd ff ff       	call   80102c90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f14:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f17:	83 ec 08             	sub    $0x8,%esp
80104f1a:	53                   	push   %ebx
80104f1b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f1e:	e8 ad d0 ff ff       	call   80101fd0 <nameiparent>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	89 c6                	mov    %eax,%esi
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	0f 84 7a 01 00 00    	je     801050aa <sys_unlink+0x1ba>
  ilock(dp);
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	50                   	push   %eax
80104f34:	e8 d7 c7 ff ff       	call   80101710 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f39:	58                   	pop    %eax
80104f3a:	5a                   	pop    %edx
80104f3b:	68 1c 77 10 80       	push   $0x8010771c
80104f40:	53                   	push   %ebx
80104f41:	e8 da cc ff ff       	call   80101c20 <namecmp>
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	0f 84 0f 01 00 00    	je     80105060 <sys_unlink+0x170>
80104f51:	83 ec 08             	sub    $0x8,%esp
80104f54:	68 1b 77 10 80       	push   $0x8010771b
80104f59:	53                   	push   %ebx
80104f5a:	e8 c1 cc ff ff       	call   80101c20 <namecmp>
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	85 c0                	test   %eax,%eax
80104f64:	0f 84 f6 00 00 00    	je     80105060 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f6a:	83 ec 04             	sub    $0x4,%esp
80104f6d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f70:	50                   	push   %eax
80104f71:	53                   	push   %ebx
80104f72:	56                   	push   %esi
80104f73:	e8 c8 cc ff ff       	call   80101c40 <dirlookup>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	89 c3                	mov    %eax,%ebx
80104f7d:	85 c0                	test   %eax,%eax
80104f7f:	0f 84 db 00 00 00    	je     80105060 <sys_unlink+0x170>
  ilock(ip);
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	50                   	push   %eax
80104f89:	e8 82 c7 ff ff       	call   80101710 <ilock>
  if(ip->nlink < 1)
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f96:	0f 8e 37 01 00 00    	jle    801050d3 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fa1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104fa4:	74 6a                	je     80105010 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104fa6:	83 ec 04             	sub    $0x4,%esp
80104fa9:	6a 10                	push   $0x10
80104fab:	6a 00                	push   $0x0
80104fad:	57                   	push   %edi
80104fae:	e8 ed f5 ff ff       	call   801045a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fb3:	6a 10                	push   $0x10
80104fb5:	ff 75 c4             	pushl  -0x3c(%ebp)
80104fb8:	57                   	push   %edi
80104fb9:	56                   	push   %esi
80104fba:	e8 31 cb ff ff       	call   80101af0 <writei>
80104fbf:	83 c4 20             	add    $0x20,%esp
80104fc2:	83 f8 10             	cmp    $0x10,%eax
80104fc5:	0f 85 fb 00 00 00    	jne    801050c6 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
80104fcb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fd0:	0f 84 aa 00 00 00    	je     80105080 <sys_unlink+0x190>
  iunlockput(dp);
80104fd6:	83 ec 0c             	sub    $0xc,%esp
80104fd9:	56                   	push   %esi
80104fda:	e8 c1 c9 ff ff       	call   801019a0 <iunlockput>
  ip->nlink--;
80104fdf:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fe4:	89 1c 24             	mov    %ebx,(%esp)
80104fe7:	e8 74 c6 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104fec:	89 1c 24             	mov    %ebx,(%esp)
80104fef:	e8 ac c9 ff ff       	call   801019a0 <iunlockput>
  end_op();
80104ff4:	e8 07 dd ff ff       	call   80102d00 <end_op>
  return 0;
80104ff9:	83 c4 10             	add    $0x10,%esp
80104ffc:	31 c0                	xor    %eax,%eax
}
80104ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105001:	5b                   	pop    %ebx
80105002:	5e                   	pop    %esi
80105003:	5f                   	pop    %edi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105010:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105014:	76 90                	jbe    80104fa6 <sys_unlink+0xb6>
80105016:	ba 20 00 00 00       	mov    $0x20,%edx
8010501b:	eb 0f                	jmp    8010502c <sys_unlink+0x13c>
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
80105020:	83 c2 10             	add    $0x10,%edx
80105023:	39 53 58             	cmp    %edx,0x58(%ebx)
80105026:	0f 86 7a ff ff ff    	jbe    80104fa6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010502c:	6a 10                	push   $0x10
8010502e:	52                   	push   %edx
8010502f:	57                   	push   %edi
80105030:	53                   	push   %ebx
80105031:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105034:	e8 b7 c9 ff ff       	call   801019f0 <readi>
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010503f:	83 f8 10             	cmp    $0x10,%eax
80105042:	75 75                	jne    801050b9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105044:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105049:	74 d5                	je     80105020 <sys_unlink+0x130>
    iunlockput(ip);
8010504b:	83 ec 0c             	sub    $0xc,%esp
8010504e:	53                   	push   %ebx
8010504f:	e8 4c c9 ff ff       	call   801019a0 <iunlockput>
    goto bad;
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105060:	83 ec 0c             	sub    $0xc,%esp
80105063:	56                   	push   %esi
80105064:	e8 37 c9 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105069:	e8 92 dc ff ff       	call   80102d00 <end_op>
  return -1;
8010506e:	83 c4 10             	add    $0x10,%esp
80105071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105076:	eb 86                	jmp    80104ffe <sys_unlink+0x10e>
80105078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop
    iupdate(dp);
80105080:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105083:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105088:	56                   	push   %esi
80105089:	e8 d2 c5 ff ff       	call   80101660 <iupdate>
8010508e:	83 c4 10             	add    $0x10,%esp
80105091:	e9 40 ff ff ff       	jmp    80104fd6 <sys_unlink+0xe6>
80105096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	e9 54 ff ff ff       	jmp    80104ffe <sys_unlink+0x10e>
    end_op();
801050aa:	e8 51 dc ff ff       	call   80102d00 <end_op>
    return -1;
801050af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b4:	e9 45 ff ff ff       	jmp    80104ffe <sys_unlink+0x10e>
      panic("isdirempty: readi");
801050b9:	83 ec 0c             	sub    $0xc,%esp
801050bc:	68 40 77 10 80       	push   $0x80107740
801050c1:	e8 ca b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801050c6:	83 ec 0c             	sub    $0xc,%esp
801050c9:	68 52 77 10 80       	push   $0x80107752
801050ce:	e8 bd b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801050d3:	83 ec 0c             	sub    $0xc,%esp
801050d6:	68 2e 77 10 80       	push   $0x8010772e
801050db:	e8 b0 b2 ff ff       	call   80100390 <panic>

801050e0 <sys_open>:

int
sys_open(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801050e8:	53                   	push   %ebx
801050e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050ec:	50                   	push   %eax
801050ed:	6a 00                	push   $0x0
801050ef:	e8 3c f8 ff ff       	call   80104930 <argstr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	0f 88 8e 00 00 00    	js     8010518d <sys_open+0xad>
801050ff:	83 ec 08             	sub    $0x8,%esp
80105102:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105105:	50                   	push   %eax
80105106:	6a 01                	push   $0x1
80105108:	e8 73 f7 ff ff       	call   80104880 <argint>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	78 79                	js     8010518d <sys_open+0xad>
    return -1;

  begin_op();
80105114:	e8 77 db ff ff       	call   80102c90 <begin_op>

  if(omode & O_CREATE){
80105119:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010511d:	75 79                	jne    80105198 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010511f:	83 ec 0c             	sub    $0xc,%esp
80105122:	ff 75 e0             	pushl  -0x20(%ebp)
80105125:	e8 86 ce ff ff       	call   80101fb0 <namei>
8010512a:	83 c4 10             	add    $0x10,%esp
8010512d:	89 c6                	mov    %eax,%esi
8010512f:	85 c0                	test   %eax,%eax
80105131:	0f 84 7e 00 00 00    	je     801051b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105137:	83 ec 0c             	sub    $0xc,%esp
8010513a:	50                   	push   %eax
8010513b:	e8 d0 c5 ff ff       	call   80101710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105148:	0f 84 c2 00 00 00    	je     80105210 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010514e:	e8 ad bc ff ff       	call   80100e00 <filealloc>
80105153:	89 c7                	mov    %eax,%edi
80105155:	85 c0                	test   %eax,%eax
80105157:	74 23                	je     8010517c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105159:	e8 92 e7 ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010515e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105160:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105164:	85 d2                	test   %edx,%edx
80105166:	74 60                	je     801051c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105168:	83 c3 01             	add    $0x1,%ebx
8010516b:	83 fb 10             	cmp    $0x10,%ebx
8010516e:	75 f0                	jne    80105160 <sys_open+0x80>
    if(f)
      fileclose(f);
80105170:	83 ec 0c             	sub    $0xc,%esp
80105173:	57                   	push   %edi
80105174:	e8 47 bd ff ff       	call   80100ec0 <fileclose>
80105179:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010517c:	83 ec 0c             	sub    $0xc,%esp
8010517f:	56                   	push   %esi
80105180:	e8 1b c8 ff ff       	call   801019a0 <iunlockput>
    end_op();
80105185:	e8 76 db ff ff       	call   80102d00 <end_op>
    return -1;
8010518a:	83 c4 10             	add    $0x10,%esp
8010518d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105192:	eb 6d                	jmp    80105201 <sys_open+0x121>
80105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105198:	83 ec 0c             	sub    $0xc,%esp
8010519b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010519e:	31 c9                	xor    %ecx,%ecx
801051a0:	ba 02 00 00 00       	mov    $0x2,%edx
801051a5:	6a 00                	push   $0x0
801051a7:	e8 24 f8 ff ff       	call   801049d0 <create>
    if(ip == 0){
801051ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801051af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801051b1:	85 c0                	test   %eax,%eax
801051b3:	75 99                	jne    8010514e <sys_open+0x6e>
      end_op();
801051b5:	e8 46 db ff ff       	call   80102d00 <end_op>
      return -1;
801051ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051bf:	eb 40                	jmp    80105201 <sys_open+0x121>
801051c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801051c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801051cf:	56                   	push   %esi
801051d0:	e8 1b c6 ff ff       	call   801017f0 <iunlock>
  end_op();
801051d5:	e8 26 db ff ff       	call   80102d00 <end_op>

  f->type = FD_INODE;
801051da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801051e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801051e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801051eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801051f2:	f7 d0                	not    %eax
801051f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801051fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105204:	89 d8                	mov    %ebx,%eax
80105206:	5b                   	pop    %ebx
80105207:	5e                   	pop    %esi
80105208:	5f                   	pop    %edi
80105209:	5d                   	pop    %ebp
8010520a:	c3                   	ret    
8010520b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105210:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105213:	85 c9                	test   %ecx,%ecx
80105215:	0f 84 33 ff ff ff    	je     8010514e <sys_open+0x6e>
8010521b:	e9 5c ff ff ff       	jmp    8010517c <sys_open+0x9c>

80105220 <sys_mkdir>:

int
sys_mkdir(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105226:	e8 65 da ff ff       	call   80102c90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010522b:	83 ec 08             	sub    $0x8,%esp
8010522e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105231:	50                   	push   %eax
80105232:	6a 00                	push   $0x0
80105234:	e8 f7 f6 ff ff       	call   80104930 <argstr>
80105239:	83 c4 10             	add    $0x10,%esp
8010523c:	85 c0                	test   %eax,%eax
8010523e:	78 30                	js     80105270 <sys_mkdir+0x50>
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105246:	31 c9                	xor    %ecx,%ecx
80105248:	ba 01 00 00 00       	mov    $0x1,%edx
8010524d:	6a 00                	push   $0x0
8010524f:	e8 7c f7 ff ff       	call   801049d0 <create>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	74 15                	je     80105270 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010525b:	83 ec 0c             	sub    $0xc,%esp
8010525e:	50                   	push   %eax
8010525f:	e8 3c c7 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105264:	e8 97 da ff ff       	call   80102d00 <end_op>
  return 0;
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	31 c0                	xor    %eax,%eax
}
8010526e:	c9                   	leave  
8010526f:	c3                   	ret    
    end_op();
80105270:	e8 8b da ff ff       	call   80102d00 <end_op>
    return -1;
80105275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010527a:	c9                   	leave  
8010527b:	c3                   	ret    
8010527c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_mknod>:

int
sys_mknod(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105286:	e8 05 da ff ff       	call   80102c90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010528b:	83 ec 08             	sub    $0x8,%esp
8010528e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105291:	50                   	push   %eax
80105292:	6a 00                	push   $0x0
80105294:	e8 97 f6 ff ff       	call   80104930 <argstr>
80105299:	83 c4 10             	add    $0x10,%esp
8010529c:	85 c0                	test   %eax,%eax
8010529e:	78 60                	js     80105300 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801052a0:	83 ec 08             	sub    $0x8,%esp
801052a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a6:	50                   	push   %eax
801052a7:	6a 01                	push   $0x1
801052a9:	e8 d2 f5 ff ff       	call   80104880 <argint>
  if((argstr(0, &path)) < 0 ||
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	85 c0                	test   %eax,%eax
801052b3:	78 4b                	js     80105300 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801052b5:	83 ec 08             	sub    $0x8,%esp
801052b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052bb:	50                   	push   %eax
801052bc:	6a 02                	push   $0x2
801052be:	e8 bd f5 ff ff       	call   80104880 <argint>
     argint(1, &major) < 0 ||
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	78 36                	js     80105300 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801052ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801052ce:	83 ec 0c             	sub    $0xc,%esp
801052d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801052d5:	ba 03 00 00 00       	mov    $0x3,%edx
801052da:	50                   	push   %eax
801052db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052de:	e8 ed f6 ff ff       	call   801049d0 <create>
     argint(2, &minor) < 0 ||
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	74 16                	je     80105300 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ea:	83 ec 0c             	sub    $0xc,%esp
801052ed:	50                   	push   %eax
801052ee:	e8 ad c6 ff ff       	call   801019a0 <iunlockput>
  end_op();
801052f3:	e8 08 da ff ff       	call   80102d00 <end_op>
  return 0;
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	31 c0                	xor    %eax,%eax
}
801052fd:	c9                   	leave  
801052fe:	c3                   	ret    
801052ff:	90                   	nop
    end_op();
80105300:	e8 fb d9 ff ff       	call   80102d00 <end_op>
    return -1;
80105305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010530a:	c9                   	leave  
8010530b:	c3                   	ret    
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105310 <sys_chdir>:

int
sys_chdir(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
80105315:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105318:	e8 d3 e5 ff ff       	call   801038f0 <myproc>
8010531d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010531f:	e8 6c d9 ff ff       	call   80102c90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105324:	83 ec 08             	sub    $0x8,%esp
80105327:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010532a:	50                   	push   %eax
8010532b:	6a 00                	push   $0x0
8010532d:	e8 fe f5 ff ff       	call   80104930 <argstr>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	85 c0                	test   %eax,%eax
80105337:	78 77                	js     801053b0 <sys_chdir+0xa0>
80105339:	83 ec 0c             	sub    $0xc,%esp
8010533c:	ff 75 f4             	pushl  -0xc(%ebp)
8010533f:	e8 6c cc ff ff       	call   80101fb0 <namei>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	89 c3                	mov    %eax,%ebx
80105349:	85 c0                	test   %eax,%eax
8010534b:	74 63                	je     801053b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010534d:	83 ec 0c             	sub    $0xc,%esp
80105350:	50                   	push   %eax
80105351:	e8 ba c3 ff ff       	call   80101710 <ilock>
  if(ip->type != T_DIR){
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010535e:	75 30                	jne    80105390 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	53                   	push   %ebx
80105364:	e8 87 c4 ff ff       	call   801017f0 <iunlock>
  iput(curproc->cwd);
80105369:	58                   	pop    %eax
8010536a:	ff 76 68             	pushl  0x68(%esi)
8010536d:	e8 ce c4 ff ff       	call   80101840 <iput>
  end_op();
80105372:	e8 89 d9 ff ff       	call   80102d00 <end_op>
  curproc->cwd = ip;
80105377:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	31 c0                	xor    %eax,%eax
}
8010537f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105382:	5b                   	pop    %ebx
80105383:	5e                   	pop    %esi
80105384:	5d                   	pop    %ebp
80105385:	c3                   	ret    
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	53                   	push   %ebx
80105394:	e8 07 c6 ff ff       	call   801019a0 <iunlockput>
    end_op();
80105399:	e8 62 d9 ff ff       	call   80102d00 <end_op>
    return -1;
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a6:	eb d7                	jmp    8010537f <sys_chdir+0x6f>
801053a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
    end_op();
801053b0:	e8 4b d9 ff ff       	call   80102d00 <end_op>
    return -1;
801053b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ba:	eb c3                	jmp    8010537f <sys_chdir+0x6f>
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_exec>:

int
sys_exec(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801053cb:	53                   	push   %ebx
801053cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053d2:	50                   	push   %eax
801053d3:	6a 00                	push   $0x0
801053d5:	e8 56 f5 ff ff       	call   80104930 <argstr>
801053da:	83 c4 10             	add    $0x10,%esp
801053dd:	85 c0                	test   %eax,%eax
801053df:	0f 88 87 00 00 00    	js     8010546c <sys_exec+0xac>
801053e5:	83 ec 08             	sub    $0x8,%esp
801053e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053ee:	50                   	push   %eax
801053ef:	6a 01                	push   $0x1
801053f1:	e8 8a f4 ff ff       	call   80104880 <argint>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	78 6f                	js     8010546c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053fd:	83 ec 04             	sub    $0x4,%esp
80105400:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105406:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105408:	68 80 00 00 00       	push   $0x80
8010540d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105413:	6a 00                	push   $0x0
80105415:	50                   	push   %eax
80105416:	e8 85 f1 ff ff       	call   801045a0 <memset>
8010541b:	83 c4 10             	add    $0x10,%esp
8010541e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105420:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105426:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010542d:	83 ec 08             	sub    $0x8,%esp
80105430:	57                   	push   %edi
80105431:	01 f0                	add    %esi,%eax
80105433:	50                   	push   %eax
80105434:	e8 a7 f3 ff ff       	call   801047e0 <fetchint>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	85 c0                	test   %eax,%eax
8010543e:	78 2c                	js     8010546c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105440:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105446:	85 c0                	test   %eax,%eax
80105448:	74 36                	je     80105480 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010544a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105450:	83 ec 08             	sub    $0x8,%esp
80105453:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105456:	52                   	push   %edx
80105457:	50                   	push   %eax
80105458:	e8 c3 f3 ff ff       	call   80104820 <fetchstr>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 08                	js     8010546c <sys_exec+0xac>
  for(i=0;; i++){
80105464:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105467:	83 fb 20             	cmp    $0x20,%ebx
8010546a:	75 b4                	jne    80105420 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010546c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010546f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105474:	5b                   	pop    %ebx
80105475:	5e                   	pop    %esi
80105476:	5f                   	pop    %edi
80105477:	5d                   	pop    %ebp
80105478:	c3                   	ret    
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105480:	83 ec 08             	sub    $0x8,%esp
80105483:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105489:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105490:	00 00 00 00 
  return exec(path, argv);
80105494:	50                   	push   %eax
80105495:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010549b:	e8 e0 b5 ff ff       	call   80100a80 <exec>
801054a0:	83 c4 10             	add    $0x10,%esp
}
801054a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a6:	5b                   	pop    %ebx
801054a7:	5e                   	pop    %esi
801054a8:	5f                   	pop    %edi
801054a9:	5d                   	pop    %ebp
801054aa:	c3                   	ret    
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop

801054b0 <sys_pipe>:

int
sys_pipe(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801054b8:	53                   	push   %ebx
801054b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054bc:	6a 08                	push   $0x8
801054be:	50                   	push   %eax
801054bf:	6a 00                	push   $0x0
801054c1:	e8 0a f4 ff ff       	call   801048d0 <argptr>
801054c6:	83 c4 10             	add    $0x10,%esp
801054c9:	85 c0                	test   %eax,%eax
801054cb:	78 4a                	js     80105517 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801054cd:	83 ec 08             	sub    $0x8,%esp
801054d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054d3:	50                   	push   %eax
801054d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054d7:	50                   	push   %eax
801054d8:	e8 63 de ff ff       	call   80103340 <pipealloc>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 33                	js     80105517 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054e9:	e8 02 e4 ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801054f4:	85 f6                	test   %esi,%esi
801054f6:	74 28                	je     80105520 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	75 f0                	jne    801054f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	ff 75 e0             	pushl  -0x20(%ebp)
80105506:	e8 b5 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010550b:	58                   	pop    %eax
8010550c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010550f:	e8 ac b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551c:	eb 53                	jmp    80105571 <sys_pipe+0xc1>
8010551e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105520:	8d 73 08             	lea    0x8(%ebx),%esi
80105523:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010552a:	e8 c1 e3 ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010552f:	31 d2                	xor    %edx,%edx
80105531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105538:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010553c:	85 c9                	test   %ecx,%ecx
8010553e:	74 20                	je     80105560 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105540:	83 c2 01             	add    $0x1,%edx
80105543:	83 fa 10             	cmp    $0x10,%edx
80105546:	75 f0                	jne    80105538 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105548:	e8 a3 e3 ff ff       	call   801038f0 <myproc>
8010554d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105554:	00 
80105555:	eb a9                	jmp    80105500 <sys_pipe+0x50>
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105560:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105564:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105567:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105569:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010556c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010556f:	31 c0                	xor    %eax,%eax
}
80105571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105574:	5b                   	pop    %ebx
80105575:	5e                   	pop    %esi
80105576:	5f                   	pop    %edi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	66 90                	xchg   %ax,%ax
8010557b:	66 90                	xchg   %ax,%ax
8010557d:	66 90                	xchg   %ax,%ax
8010557f:	90                   	nop

80105580 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105580:	e9 0b e5 ff ff       	jmp    80103a90 <fork>
80105585:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_gettsched>:
}
int 
sys_gettsched(void)
{
   return gettsched();
80105590:	e9 9b e2 ff ff       	jmp    80103830 <gettsched>
80105595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_yieldc>:
}
int 
sys_yieldc(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 08             	sub    $0x8,%esp

   yield();
801055a6:	e8 b5 e8 ff ff       	call   80103e60 <yield>
   return 0;
}
801055ab:	31 c0                	xor    %eax,%eax
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    
801055af:	90                   	nop

801055b0 <sys_exit>:
int
sys_exit(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055b6:	e8 75 e7 ff ff       	call   80103d30 <exit>
  return 0;  // not reached
}
801055bb:	31 c0                	xor    %eax,%eax
801055bd:	c9                   	leave  
801055be:	c3                   	ret    
801055bf:	90                   	nop

801055c0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801055c0:	e9 ab e9 ff ff       	jmp    80103f70 <wait>
801055c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_kill>:
}

int
sys_kill(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d9:	50                   	push   %eax
801055da:	6a 00                	push   $0x0
801055dc:	e8 9f f2 ff ff       	call   80104880 <argint>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	85 c0                	test   %eax,%eax
801055e6:	78 18                	js     80105600 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055e8:	83 ec 0c             	sub    $0xc,%esp
801055eb:	ff 75 f4             	pushl  -0xc(%ebp)
801055ee:	e8 cd ea ff ff       	call   801040c0 <kill>
801055f3:	83 c4 10             	add    $0x10,%esp
}
801055f6:	c9                   	leave  
801055f7:	c3                   	ret    
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
80105600:	c9                   	leave  
    return -1;
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105606:	c3                   	ret    
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <sys_getpid>:

int
sys_getpid(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105616:	e8 d5 e2 ff ff       	call   801038f0 <myproc>
8010561b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010561e:	c9                   	leave  
8010561f:	c3                   	ret    

80105620 <sys_sbrk>:

int
sys_sbrk(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105624:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105627:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010562a:	50                   	push   %eax
8010562b:	6a 00                	push   $0x0
8010562d:	e8 4e f2 ff ff       	call   80104880 <argint>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	85 c0                	test   %eax,%eax
80105637:	78 27                	js     80105660 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105639:	e8 b2 e2 ff ff       	call   801038f0 <myproc>
  if(growproc(n) < 0)
8010563e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105641:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105643:	ff 75 f4             	pushl  -0xc(%ebp)
80105646:	e8 c5 e3 ff ff       	call   80103a10 <growproc>
8010564b:	83 c4 10             	add    $0x10,%esp
8010564e:	85 c0                	test   %eax,%eax
80105650:	78 0e                	js     80105660 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105652:	89 d8                	mov    %ebx,%eax
80105654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105657:	c9                   	leave  
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105660:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105665:	eb eb                	jmp    80105652 <sys_sbrk+0x32>
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_sleep>:

int
sys_sleep(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105674:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105677:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010567a:	50                   	push   %eax
8010567b:	6a 00                	push   $0x0
8010567d:	e8 fe f1 ff ff       	call   80104880 <argint>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	0f 88 8a 00 00 00    	js     80105717 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	68 80 4c 11 80       	push   $0x80114c80
80105695:	e8 f6 ed ff ff       	call   80104490 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010569a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010569d:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  while(ticks - ticks0 < n){
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 d2                	test   %edx,%edx
801056a8:	75 27                	jne    801056d1 <sys_sleep+0x61>
801056aa:	eb 54                	jmp    80105700 <sys_sleep+0x90>
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056b0:	83 ec 08             	sub    $0x8,%esp
801056b3:	68 80 4c 11 80       	push   $0x80114c80
801056b8:	68 c0 54 11 80       	push   $0x801154c0
801056bd:	e8 ee e7 ff ff       	call   80103eb0 <sleep>
  while(ticks - ticks0 < n){
801056c2:	a1 c0 54 11 80       	mov    0x801154c0,%eax
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	29 d8                	sub    %ebx,%eax
801056cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056cf:	73 2f                	jae    80105700 <sys_sleep+0x90>
    if(myproc()->killed){
801056d1:	e8 1a e2 ff ff       	call   801038f0 <myproc>
801056d6:	8b 40 24             	mov    0x24(%eax),%eax
801056d9:	85 c0                	test   %eax,%eax
801056db:	74 d3                	je     801056b0 <sys_sleep+0x40>
      release(&tickslock);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	68 80 4c 11 80       	push   $0x80114c80
801056e5:	e8 66 ee ff ff       	call   80104550 <release>
      return -1;
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801056f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	68 80 4c 11 80       	push   $0x80114c80
80105708:	e8 43 ee ff ff       	call   80104550 <release>
  return 0;
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	31 c0                	xor    %eax,%eax
}
80105712:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105715:	c9                   	leave  
80105716:	c3                   	ret    
    return -1;
80105717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571c:	eb f4                	jmp    80105712 <sys_sleep+0xa2>
8010571e:	66 90                	xchg   %ax,%ax

80105720 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	53                   	push   %ebx
80105724:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105727:	68 80 4c 11 80       	push   $0x80114c80
8010572c:	e8 5f ed ff ff       	call   80104490 <acquire>
  xticks = ticks;
80105731:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  release(&tickslock);
80105737:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
8010573e:	e8 0d ee ff ff       	call   80104550 <release>
  return xticks;
}
80105743:	89 d8                	mov    %ebx,%eax
80105745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105748:	c9                   	leave  
80105749:	c3                   	ret    

8010574a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010574a:	1e                   	push   %ds
  pushl %es
8010574b:	06                   	push   %es
  pushl %fs
8010574c:	0f a0                	push   %fs
  pushl %gs
8010574e:	0f a8                	push   %gs
  pushal
80105750:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105751:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105755:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105757:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105759:	54                   	push   %esp
  call trap
8010575a:	e8 c1 00 00 00       	call   80105820 <trap>
  addl $4, %esp
8010575f:	83 c4 04             	add    $0x4,%esp

80105762 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105762:	61                   	popa   
  popl %gs
80105763:	0f a9                	pop    %gs
  popl %fs
80105765:	0f a1                	pop    %fs
  popl %es
80105767:	07                   	pop    %es
  popl %ds
80105768:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105769:	83 c4 08             	add    $0x8,%esp
  iret
8010576c:	cf                   	iret   
8010576d:	66 90                	xchg   %ax,%ax
8010576f:	90                   	nop

80105770 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105770:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105771:	31 c0                	xor    %eax,%eax
{
80105773:	89 e5                	mov    %esp,%ebp
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105780:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105787:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
8010578e:	08 00 00 8e 
80105792:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105799:	80 
8010579a:	c1 ea 10             	shr    $0x10,%edx
8010579d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
801057a4:	80 
  for(i = 0; i < 256; i++)
801057a5:	83 c0 01             	add    $0x1,%eax
801057a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801057ad:	75 d1                	jne    80105780 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801057af:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057b2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801057b7:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
801057be:	00 00 ef 
  initlock(&tickslock, "time");
801057c1:	68 61 77 10 80       	push   $0x80107761
801057c6:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057cb:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
801057d1:	c1 e8 10             	shr    $0x10,%eax
801057d4:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
801057da:	e8 51 eb ff ff       	call   80104330 <initlock>
}
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	c9                   	leave  
801057e3:	c3                   	ret    
801057e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop

801057f0 <idtinit>:

void
idtinit(void)
{
801057f0:	55                   	push   %ebp
  pd[0] = size-1;
801057f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057f6:	89 e5                	mov    %esp,%ebp
801057f8:	83 ec 10             	sub    $0x10,%esp
801057fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057ff:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105804:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105808:	c1 e8 10             	shr    $0x10,%eax
8010580b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010580f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105812:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105815:	c9                   	leave  
80105816:	c3                   	ret    
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
80105825:	53                   	push   %ebx
80105826:	83 ec 1c             	sub    $0x1c,%esp
80105829:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010582c:	8b 47 30             	mov    0x30(%edi),%eax
8010582f:	83 f8 40             	cmp    $0x40,%eax
80105832:	0f 84 b8 01 00 00    	je     801059f0 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105838:	83 e8 20             	sub    $0x20,%eax
8010583b:	83 f8 1f             	cmp    $0x1f,%eax
8010583e:	77 10                	ja     80105850 <trap+0x30>
80105840:	ff 24 85 08 78 10 80 	jmp    *-0x7fef87f8(,%eax,4)
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105850:	e8 9b e0 ff ff       	call   801038f0 <myproc>
80105855:	8b 5f 38             	mov    0x38(%edi),%ebx
80105858:	85 c0                	test   %eax,%eax
8010585a:	0f 84 17 02 00 00    	je     80105a77 <trap+0x257>
80105860:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105864:	0f 84 0d 02 00 00    	je     80105a77 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010586a:	0f 20 d1             	mov    %cr2,%ecx
8010586d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105870:	e8 5b e0 ff ff       	call   801038d0 <cpuid>
80105875:	8b 77 30             	mov    0x30(%edi),%esi
80105878:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010587b:	8b 47 34             	mov    0x34(%edi),%eax
8010587e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105881:	e8 6a e0 ff ff       	call   801038f0 <myproc>
80105886:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105889:	e8 62 e0 ff ff       	call   801038f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010588e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105891:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105894:	51                   	push   %ecx
80105895:	53                   	push   %ebx
80105896:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105897:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010589a:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010589d:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058a0:	56                   	push   %esi
801058a1:	52                   	push   %edx
801058a2:	ff 70 10             	pushl  0x10(%eax)
801058a5:	68 c4 77 10 80       	push   $0x801077c4
801058aa:	e8 01 ae ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058af:	83 c4 20             	add    $0x20,%esp
801058b2:	e8 39 e0 ff ff       	call   801038f0 <myproc>
801058b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058be:	e8 2d e0 ff ff       	call   801038f0 <myproc>
801058c3:	85 c0                	test   %eax,%eax
801058c5:	74 1d                	je     801058e4 <trap+0xc4>
801058c7:	e8 24 e0 ff ff       	call   801038f0 <myproc>
801058cc:	8b 50 24             	mov    0x24(%eax),%edx
801058cf:	85 d2                	test   %edx,%edx
801058d1:	74 11                	je     801058e4 <trap+0xc4>
801058d3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058d7:	83 e0 03             	and    $0x3,%eax
801058da:	66 83 f8 03          	cmp    $0x3,%ax
801058de:	0f 84 44 01 00 00    	je     80105a28 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058e4:	e8 07 e0 ff ff       	call   801038f0 <myproc>
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 0b                	je     801058f8 <trap+0xd8>
801058ed:	e8 fe df ff ff       	call   801038f0 <myproc>
801058f2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058f6:	74 38                	je     80105930 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058f8:	e8 f3 df ff ff       	call   801038f0 <myproc>
801058fd:	85 c0                	test   %eax,%eax
801058ff:	74 1d                	je     8010591e <trap+0xfe>
80105901:	e8 ea df ff ff       	call   801038f0 <myproc>
80105906:	8b 40 24             	mov    0x24(%eax),%eax
80105909:	85 c0                	test   %eax,%eax
8010590b:	74 11                	je     8010591e <trap+0xfe>
8010590d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105911:	83 e0 03             	and    $0x3,%eax
80105914:	66 83 f8 03          	cmp    $0x3,%ax
80105918:	0f 84 fb 00 00 00    	je     80105a19 <trap+0x1f9>
    exit();
}
8010591e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105921:	5b                   	pop    %ebx
80105922:	5e                   	pop    %esi
80105923:	5f                   	pop    %edi
80105924:	5d                   	pop    %ebp
80105925:	c3                   	ret    
80105926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105930:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105934:	75 c2                	jne    801058f8 <trap+0xd8>
    yield();
80105936:	e8 25 e5 ff ff       	call   80103e60 <yield>
8010593b:	eb bb                	jmp    801058f8 <trap+0xd8>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105940:	e8 8b df ff ff       	call   801038d0 <cpuid>
80105945:	85 c0                	test   %eax,%eax
80105947:	0f 84 eb 00 00 00    	je     80105a38 <trap+0x218>
    lapiceoi();
8010594d:	e8 ee ce ff ff       	call   80102840 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105952:	e8 99 df ff ff       	call   801038f0 <myproc>
80105957:	85 c0                	test   %eax,%eax
80105959:	0f 85 68 ff ff ff    	jne    801058c7 <trap+0xa7>
8010595f:	eb 83                	jmp    801058e4 <trap+0xc4>
80105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105968:	e8 93 cd ff ff       	call   80102700 <kbdintr>
    lapiceoi();
8010596d:	e8 ce ce ff ff       	call   80102840 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105972:	e8 79 df ff ff       	call   801038f0 <myproc>
80105977:	85 c0                	test   %eax,%eax
80105979:	0f 85 48 ff ff ff    	jne    801058c7 <trap+0xa7>
8010597f:	e9 60 ff ff ff       	jmp    801058e4 <trap+0xc4>
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105988:	e8 83 02 00 00       	call   80105c10 <uartintr>
    lapiceoi();
8010598d:	e8 ae ce ff ff       	call   80102840 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105992:	e8 59 df ff ff       	call   801038f0 <myproc>
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 85 28 ff ff ff    	jne    801058c7 <trap+0xa7>
8010599f:	e9 40 ff ff ff       	jmp    801058e4 <trap+0xc4>
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059a8:	8b 77 38             	mov    0x38(%edi),%esi
801059ab:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059af:	e8 1c df ff ff       	call   801038d0 <cpuid>
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
801059b6:	50                   	push   %eax
801059b7:	68 6c 77 10 80       	push   $0x8010776c
801059bc:	e8 ef ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801059c1:	e8 7a ce ff ff       	call   80102840 <lapiceoi>
    break;
801059c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059c9:	e8 22 df ff ff       	call   801038f0 <myproc>
801059ce:	85 c0                	test   %eax,%eax
801059d0:	0f 85 f1 fe ff ff    	jne    801058c7 <trap+0xa7>
801059d6:	e9 09 ff ff ff       	jmp    801058e4 <trap+0xc4>
801059db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059df:	90                   	nop
    ideintr();
801059e0:	e8 6b c7 ff ff       	call   80102150 <ideintr>
801059e5:	e9 63 ff ff ff       	jmp    8010594d <trap+0x12d>
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801059f0:	e8 fb de ff ff       	call   801038f0 <myproc>
801059f5:	8b 58 24             	mov    0x24(%eax),%ebx
801059f8:	85 db                	test   %ebx,%ebx
801059fa:	75 74                	jne    80105a70 <trap+0x250>
    myproc()->tf = tf;
801059fc:	e8 ef de ff ff       	call   801038f0 <myproc>
80105a01:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a04:	e8 67 ef ff ff       	call   80104970 <syscall>
    if(myproc()->killed)
80105a09:	e8 e2 de ff ff       	call   801038f0 <myproc>
80105a0e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a11:	85 c9                	test   %ecx,%ecx
80105a13:	0f 84 05 ff ff ff    	je     8010591e <trap+0xfe>
}
80105a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a1c:	5b                   	pop    %ebx
80105a1d:	5e                   	pop    %esi
80105a1e:	5f                   	pop    %edi
80105a1f:	5d                   	pop    %ebp
      exit();
80105a20:	e9 0b e3 ff ff       	jmp    80103d30 <exit>
80105a25:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a28:	e8 03 e3 ff ff       	call   80103d30 <exit>
80105a2d:	e9 b2 fe ff ff       	jmp    801058e4 <trap+0xc4>
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	68 80 4c 11 80       	push   $0x80114c80
80105a40:	e8 4b ea ff ff       	call   80104490 <acquire>
      wakeup(&ticks);
80105a45:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
      ticks++;
80105a4c:	83 05 c0 54 11 80 01 	addl   $0x1,0x801154c0
      wakeup(&ticks);
80105a53:	e8 08 e6 ff ff       	call   80104060 <wakeup>
      release(&tickslock);
80105a58:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105a5f:	e8 ec ea ff ff       	call   80104550 <release>
80105a64:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a67:	e9 e1 fe ff ff       	jmp    8010594d <trap+0x12d>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105a70:	e8 bb e2 ff ff       	call   80103d30 <exit>
80105a75:	eb 85                	jmp    801059fc <trap+0x1dc>
80105a77:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a7a:	e8 51 de ff ff       	call   801038d0 <cpuid>
80105a7f:	83 ec 0c             	sub    $0xc,%esp
80105a82:	56                   	push   %esi
80105a83:	53                   	push   %ebx
80105a84:	50                   	push   %eax
80105a85:	ff 77 30             	pushl  0x30(%edi)
80105a88:	68 90 77 10 80       	push   $0x80107790
80105a8d:	e8 1e ac ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105a92:	83 c4 14             	add    $0x14,%esp
80105a95:	68 66 77 10 80       	push   $0x80107766
80105a9a:	e8 f1 a8 ff ff       	call   80100390 <panic>
80105a9f:	90                   	nop

80105aa0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105aa0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 17                	je     80105ac0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aa9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105aae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105aaf:	a8 01                	test   $0x1,%al
80105ab1:	74 0d                	je     80105ac0 <uartgetc+0x20>
80105ab3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ab8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ab9:	0f b6 c0             	movzbl %al,%eax
80105abc:	c3                   	ret    
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac5:	c3                   	ret    
80105ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105acd:	8d 76 00             	lea    0x0(%esi),%esi

80105ad0 <uartputc.part.0>:
uartputc(int c)
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	89 c7                	mov    %eax,%edi
80105ad6:	56                   	push   %esi
80105ad7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105adc:	53                   	push   %ebx
80105add:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	eb 1b                	jmp    80105b02 <uartputc.part.0+0x32>
80105ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aee:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	6a 0a                	push   $0xa
80105af5:	e8 66 cd ff ff       	call   80102860 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	83 eb 01             	sub    $0x1,%ebx
80105b00:	74 07                	je     80105b09 <uartputc.part.0+0x39>
80105b02:	89 f2                	mov    %esi,%edx
80105b04:	ec                   	in     (%dx),%al
80105b05:	a8 20                	test   $0x20,%al
80105b07:	74 e7                	je     80105af0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b0e:	89 f8                	mov    %edi,%eax
80105b10:	ee                   	out    %al,(%dx)
}
80105b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b14:	5b                   	pop    %ebx
80105b15:	5e                   	pop    %esi
80105b16:	5f                   	pop    %edi
80105b17:	5d                   	pop    %ebp
80105b18:	c3                   	ret    
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b20 <uartinit>:
{
80105b20:	55                   	push   %ebp
80105b21:	31 c9                	xor    %ecx,%ecx
80105b23:	89 c8                	mov    %ecx,%eax
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	57                   	push   %edi
80105b28:	56                   	push   %esi
80105b29:	53                   	push   %ebx
80105b2a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b2f:	89 da                	mov    %ebx,%edx
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	ee                   	out    %al,(%dx)
80105b35:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b3f:	89 fa                	mov    %edi,%edx
80105b41:	ee                   	out    %al,(%dx)
80105b42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4c:	ee                   	out    %al,(%dx)
80105b4d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b52:	89 c8                	mov    %ecx,%eax
80105b54:	89 f2                	mov    %esi,%edx
80105b56:	ee                   	out    %al,(%dx)
80105b57:	b8 03 00 00 00       	mov    $0x3,%eax
80105b5c:	89 fa                	mov    %edi,%edx
80105b5e:	ee                   	out    %al,(%dx)
80105b5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b64:	89 c8                	mov    %ecx,%eax
80105b66:	ee                   	out    %al,(%dx)
80105b67:	b8 01 00 00 00       	mov    $0x1,%eax
80105b6c:	89 f2                	mov    %esi,%edx
80105b6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b75:	3c ff                	cmp    $0xff,%al
80105b77:	74 56                	je     80105bcf <uartinit+0xaf>
  uart = 1;
80105b79:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105b80:	00 00 00 
80105b83:	89 da                	mov    %ebx,%edx
80105b85:	ec                   	in     (%dx),%al
80105b86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b8c:	83 ec 08             	sub    $0x8,%esp
80105b8f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105b94:	bb 88 78 10 80       	mov    $0x80107888,%ebx
  ioapicenable(IRQ_COM1, 0);
80105b99:	6a 00                	push   $0x0
80105b9b:	6a 04                	push   $0x4
80105b9d:	e8 fe c7 ff ff       	call   801023a0 <ioapicenable>
80105ba2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ba5:	b8 78 00 00 00       	mov    $0x78,%eax
80105baa:	eb 08                	jmp    80105bb4 <uartinit+0x94>
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bb0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bb4:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105bba:	85 d2                	test   %edx,%edx
80105bbc:	74 08                	je     80105bc6 <uartinit+0xa6>
    uartputc(*p);
80105bbe:	0f be c0             	movsbl %al,%eax
80105bc1:	e8 0a ff ff ff       	call   80105ad0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105bc6:	89 f0                	mov    %esi,%eax
80105bc8:	83 c3 01             	add    $0x1,%ebx
80105bcb:	84 c0                	test   %al,%al
80105bcd:	75 e1                	jne    80105bb0 <uartinit+0x90>
}
80105bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd2:	5b                   	pop    %ebx
80105bd3:	5e                   	pop    %esi
80105bd4:	5f                   	pop    %edi
80105bd5:	5d                   	pop    %ebp
80105bd6:	c3                   	ret    
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <uartputc>:
{
80105be0:	55                   	push   %ebp
  if(!uart)
80105be1:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80105be7:	89 e5                	mov    %esp,%ebp
80105be9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bec:	85 d2                	test   %edx,%edx
80105bee:	74 10                	je     80105c00 <uartputc+0x20>
}
80105bf0:	5d                   	pop    %ebp
80105bf1:	e9 da fe ff ff       	jmp    80105ad0 <uartputc.part.0>
80105bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
80105c00:	5d                   	pop    %ebp
80105c01:	c3                   	ret    
80105c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c10 <uartintr>:

void
uartintr(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c16:	68 a0 5a 10 80       	push   $0x80105aa0
80105c1b:	e8 40 ac ff ff       	call   80100860 <consoleintr>
}
80105c20:	83 c4 10             	add    $0x10,%esp
80105c23:	c9                   	leave  
80105c24:	c3                   	ret    

80105c25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $0
80105c27:	6a 00                	push   $0x0
  jmp alltraps
80105c29:	e9 1c fb ff ff       	jmp    8010574a <alltraps>

80105c2e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $1
80105c30:	6a 01                	push   $0x1
  jmp alltraps
80105c32:	e9 13 fb ff ff       	jmp    8010574a <alltraps>

80105c37 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $2
80105c39:	6a 02                	push   $0x2
  jmp alltraps
80105c3b:	e9 0a fb ff ff       	jmp    8010574a <alltraps>

80105c40 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $3
80105c42:	6a 03                	push   $0x3
  jmp alltraps
80105c44:	e9 01 fb ff ff       	jmp    8010574a <alltraps>

80105c49 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $4
80105c4b:	6a 04                	push   $0x4
  jmp alltraps
80105c4d:	e9 f8 fa ff ff       	jmp    8010574a <alltraps>

80105c52 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $5
80105c54:	6a 05                	push   $0x5
  jmp alltraps
80105c56:	e9 ef fa ff ff       	jmp    8010574a <alltraps>

80105c5b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $6
80105c5d:	6a 06                	push   $0x6
  jmp alltraps
80105c5f:	e9 e6 fa ff ff       	jmp    8010574a <alltraps>

80105c64 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $7
80105c66:	6a 07                	push   $0x7
  jmp alltraps
80105c68:	e9 dd fa ff ff       	jmp    8010574a <alltraps>

80105c6d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c6d:	6a 08                	push   $0x8
  jmp alltraps
80105c6f:	e9 d6 fa ff ff       	jmp    8010574a <alltraps>

80105c74 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $9
80105c76:	6a 09                	push   $0x9
  jmp alltraps
80105c78:	e9 cd fa ff ff       	jmp    8010574a <alltraps>

80105c7d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c7d:	6a 0a                	push   $0xa
  jmp alltraps
80105c7f:	e9 c6 fa ff ff       	jmp    8010574a <alltraps>

80105c84 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c84:	6a 0b                	push   $0xb
  jmp alltraps
80105c86:	e9 bf fa ff ff       	jmp    8010574a <alltraps>

80105c8b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c8b:	6a 0c                	push   $0xc
  jmp alltraps
80105c8d:	e9 b8 fa ff ff       	jmp    8010574a <alltraps>

80105c92 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c92:	6a 0d                	push   $0xd
  jmp alltraps
80105c94:	e9 b1 fa ff ff       	jmp    8010574a <alltraps>

80105c99 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c99:	6a 0e                	push   $0xe
  jmp alltraps
80105c9b:	e9 aa fa ff ff       	jmp    8010574a <alltraps>

80105ca0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $15
80105ca2:	6a 0f                	push   $0xf
  jmp alltraps
80105ca4:	e9 a1 fa ff ff       	jmp    8010574a <alltraps>

80105ca9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $16
80105cab:	6a 10                	push   $0x10
  jmp alltraps
80105cad:	e9 98 fa ff ff       	jmp    8010574a <alltraps>

80105cb2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cb2:	6a 11                	push   $0x11
  jmp alltraps
80105cb4:	e9 91 fa ff ff       	jmp    8010574a <alltraps>

80105cb9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $18
80105cbb:	6a 12                	push   $0x12
  jmp alltraps
80105cbd:	e9 88 fa ff ff       	jmp    8010574a <alltraps>

80105cc2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $19
80105cc4:	6a 13                	push   $0x13
  jmp alltraps
80105cc6:	e9 7f fa ff ff       	jmp    8010574a <alltraps>

80105ccb <vector20>:
.globl vector20
vector20:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $20
80105ccd:	6a 14                	push   $0x14
  jmp alltraps
80105ccf:	e9 76 fa ff ff       	jmp    8010574a <alltraps>

80105cd4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $21
80105cd6:	6a 15                	push   $0x15
  jmp alltraps
80105cd8:	e9 6d fa ff ff       	jmp    8010574a <alltraps>

80105cdd <vector22>:
.globl vector22
vector22:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $22
80105cdf:	6a 16                	push   $0x16
  jmp alltraps
80105ce1:	e9 64 fa ff ff       	jmp    8010574a <alltraps>

80105ce6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $23
80105ce8:	6a 17                	push   $0x17
  jmp alltraps
80105cea:	e9 5b fa ff ff       	jmp    8010574a <alltraps>

80105cef <vector24>:
.globl vector24
vector24:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $24
80105cf1:	6a 18                	push   $0x18
  jmp alltraps
80105cf3:	e9 52 fa ff ff       	jmp    8010574a <alltraps>

80105cf8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $25
80105cfa:	6a 19                	push   $0x19
  jmp alltraps
80105cfc:	e9 49 fa ff ff       	jmp    8010574a <alltraps>

80105d01 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $26
80105d03:	6a 1a                	push   $0x1a
  jmp alltraps
80105d05:	e9 40 fa ff ff       	jmp    8010574a <alltraps>

80105d0a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $27
80105d0c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d0e:	e9 37 fa ff ff       	jmp    8010574a <alltraps>

80105d13 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $28
80105d15:	6a 1c                	push   $0x1c
  jmp alltraps
80105d17:	e9 2e fa ff ff       	jmp    8010574a <alltraps>

80105d1c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $29
80105d1e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d20:	e9 25 fa ff ff       	jmp    8010574a <alltraps>

80105d25 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $30
80105d27:	6a 1e                	push   $0x1e
  jmp alltraps
80105d29:	e9 1c fa ff ff       	jmp    8010574a <alltraps>

80105d2e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $31
80105d30:	6a 1f                	push   $0x1f
  jmp alltraps
80105d32:	e9 13 fa ff ff       	jmp    8010574a <alltraps>

80105d37 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $32
80105d39:	6a 20                	push   $0x20
  jmp alltraps
80105d3b:	e9 0a fa ff ff       	jmp    8010574a <alltraps>

80105d40 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $33
80105d42:	6a 21                	push   $0x21
  jmp alltraps
80105d44:	e9 01 fa ff ff       	jmp    8010574a <alltraps>

80105d49 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $34
80105d4b:	6a 22                	push   $0x22
  jmp alltraps
80105d4d:	e9 f8 f9 ff ff       	jmp    8010574a <alltraps>

80105d52 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $35
80105d54:	6a 23                	push   $0x23
  jmp alltraps
80105d56:	e9 ef f9 ff ff       	jmp    8010574a <alltraps>

80105d5b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $36
80105d5d:	6a 24                	push   $0x24
  jmp alltraps
80105d5f:	e9 e6 f9 ff ff       	jmp    8010574a <alltraps>

80105d64 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $37
80105d66:	6a 25                	push   $0x25
  jmp alltraps
80105d68:	e9 dd f9 ff ff       	jmp    8010574a <alltraps>

80105d6d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $38
80105d6f:	6a 26                	push   $0x26
  jmp alltraps
80105d71:	e9 d4 f9 ff ff       	jmp    8010574a <alltraps>

80105d76 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $39
80105d78:	6a 27                	push   $0x27
  jmp alltraps
80105d7a:	e9 cb f9 ff ff       	jmp    8010574a <alltraps>

80105d7f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $40
80105d81:	6a 28                	push   $0x28
  jmp alltraps
80105d83:	e9 c2 f9 ff ff       	jmp    8010574a <alltraps>

80105d88 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $41
80105d8a:	6a 29                	push   $0x29
  jmp alltraps
80105d8c:	e9 b9 f9 ff ff       	jmp    8010574a <alltraps>

80105d91 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $42
80105d93:	6a 2a                	push   $0x2a
  jmp alltraps
80105d95:	e9 b0 f9 ff ff       	jmp    8010574a <alltraps>

80105d9a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $43
80105d9c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d9e:	e9 a7 f9 ff ff       	jmp    8010574a <alltraps>

80105da3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $44
80105da5:	6a 2c                	push   $0x2c
  jmp alltraps
80105da7:	e9 9e f9 ff ff       	jmp    8010574a <alltraps>

80105dac <vector45>:
.globl vector45
vector45:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $45
80105dae:	6a 2d                	push   $0x2d
  jmp alltraps
80105db0:	e9 95 f9 ff ff       	jmp    8010574a <alltraps>

80105db5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $46
80105db7:	6a 2e                	push   $0x2e
  jmp alltraps
80105db9:	e9 8c f9 ff ff       	jmp    8010574a <alltraps>

80105dbe <vector47>:
.globl vector47
vector47:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $47
80105dc0:	6a 2f                	push   $0x2f
  jmp alltraps
80105dc2:	e9 83 f9 ff ff       	jmp    8010574a <alltraps>

80105dc7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $48
80105dc9:	6a 30                	push   $0x30
  jmp alltraps
80105dcb:	e9 7a f9 ff ff       	jmp    8010574a <alltraps>

80105dd0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $49
80105dd2:	6a 31                	push   $0x31
  jmp alltraps
80105dd4:	e9 71 f9 ff ff       	jmp    8010574a <alltraps>

80105dd9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $50
80105ddb:	6a 32                	push   $0x32
  jmp alltraps
80105ddd:	e9 68 f9 ff ff       	jmp    8010574a <alltraps>

80105de2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $51
80105de4:	6a 33                	push   $0x33
  jmp alltraps
80105de6:	e9 5f f9 ff ff       	jmp    8010574a <alltraps>

80105deb <vector52>:
.globl vector52
vector52:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $52
80105ded:	6a 34                	push   $0x34
  jmp alltraps
80105def:	e9 56 f9 ff ff       	jmp    8010574a <alltraps>

80105df4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $53
80105df6:	6a 35                	push   $0x35
  jmp alltraps
80105df8:	e9 4d f9 ff ff       	jmp    8010574a <alltraps>

80105dfd <vector54>:
.globl vector54
vector54:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $54
80105dff:	6a 36                	push   $0x36
  jmp alltraps
80105e01:	e9 44 f9 ff ff       	jmp    8010574a <alltraps>

80105e06 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $55
80105e08:	6a 37                	push   $0x37
  jmp alltraps
80105e0a:	e9 3b f9 ff ff       	jmp    8010574a <alltraps>

80105e0f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $56
80105e11:	6a 38                	push   $0x38
  jmp alltraps
80105e13:	e9 32 f9 ff ff       	jmp    8010574a <alltraps>

80105e18 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $57
80105e1a:	6a 39                	push   $0x39
  jmp alltraps
80105e1c:	e9 29 f9 ff ff       	jmp    8010574a <alltraps>

80105e21 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $58
80105e23:	6a 3a                	push   $0x3a
  jmp alltraps
80105e25:	e9 20 f9 ff ff       	jmp    8010574a <alltraps>

80105e2a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $59
80105e2c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e2e:	e9 17 f9 ff ff       	jmp    8010574a <alltraps>

80105e33 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $60
80105e35:	6a 3c                	push   $0x3c
  jmp alltraps
80105e37:	e9 0e f9 ff ff       	jmp    8010574a <alltraps>

80105e3c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $61
80105e3e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e40:	e9 05 f9 ff ff       	jmp    8010574a <alltraps>

80105e45 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $62
80105e47:	6a 3e                	push   $0x3e
  jmp alltraps
80105e49:	e9 fc f8 ff ff       	jmp    8010574a <alltraps>

80105e4e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $63
80105e50:	6a 3f                	push   $0x3f
  jmp alltraps
80105e52:	e9 f3 f8 ff ff       	jmp    8010574a <alltraps>

80105e57 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $64
80105e59:	6a 40                	push   $0x40
  jmp alltraps
80105e5b:	e9 ea f8 ff ff       	jmp    8010574a <alltraps>

80105e60 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $65
80105e62:	6a 41                	push   $0x41
  jmp alltraps
80105e64:	e9 e1 f8 ff ff       	jmp    8010574a <alltraps>

80105e69 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $66
80105e6b:	6a 42                	push   $0x42
  jmp alltraps
80105e6d:	e9 d8 f8 ff ff       	jmp    8010574a <alltraps>

80105e72 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $67
80105e74:	6a 43                	push   $0x43
  jmp alltraps
80105e76:	e9 cf f8 ff ff       	jmp    8010574a <alltraps>

80105e7b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $68
80105e7d:	6a 44                	push   $0x44
  jmp alltraps
80105e7f:	e9 c6 f8 ff ff       	jmp    8010574a <alltraps>

80105e84 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $69
80105e86:	6a 45                	push   $0x45
  jmp alltraps
80105e88:	e9 bd f8 ff ff       	jmp    8010574a <alltraps>

80105e8d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $70
80105e8f:	6a 46                	push   $0x46
  jmp alltraps
80105e91:	e9 b4 f8 ff ff       	jmp    8010574a <alltraps>

80105e96 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $71
80105e98:	6a 47                	push   $0x47
  jmp alltraps
80105e9a:	e9 ab f8 ff ff       	jmp    8010574a <alltraps>

80105e9f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $72
80105ea1:	6a 48                	push   $0x48
  jmp alltraps
80105ea3:	e9 a2 f8 ff ff       	jmp    8010574a <alltraps>

80105ea8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $73
80105eaa:	6a 49                	push   $0x49
  jmp alltraps
80105eac:	e9 99 f8 ff ff       	jmp    8010574a <alltraps>

80105eb1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $74
80105eb3:	6a 4a                	push   $0x4a
  jmp alltraps
80105eb5:	e9 90 f8 ff ff       	jmp    8010574a <alltraps>

80105eba <vector75>:
.globl vector75
vector75:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $75
80105ebc:	6a 4b                	push   $0x4b
  jmp alltraps
80105ebe:	e9 87 f8 ff ff       	jmp    8010574a <alltraps>

80105ec3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $76
80105ec5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ec7:	e9 7e f8 ff ff       	jmp    8010574a <alltraps>

80105ecc <vector77>:
.globl vector77
vector77:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $77
80105ece:	6a 4d                	push   $0x4d
  jmp alltraps
80105ed0:	e9 75 f8 ff ff       	jmp    8010574a <alltraps>

80105ed5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $78
80105ed7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ed9:	e9 6c f8 ff ff       	jmp    8010574a <alltraps>

80105ede <vector79>:
.globl vector79
vector79:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $79
80105ee0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ee2:	e9 63 f8 ff ff       	jmp    8010574a <alltraps>

80105ee7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $80
80105ee9:	6a 50                	push   $0x50
  jmp alltraps
80105eeb:	e9 5a f8 ff ff       	jmp    8010574a <alltraps>

80105ef0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $81
80105ef2:	6a 51                	push   $0x51
  jmp alltraps
80105ef4:	e9 51 f8 ff ff       	jmp    8010574a <alltraps>

80105ef9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $82
80105efb:	6a 52                	push   $0x52
  jmp alltraps
80105efd:	e9 48 f8 ff ff       	jmp    8010574a <alltraps>

80105f02 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $83
80105f04:	6a 53                	push   $0x53
  jmp alltraps
80105f06:	e9 3f f8 ff ff       	jmp    8010574a <alltraps>

80105f0b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $84
80105f0d:	6a 54                	push   $0x54
  jmp alltraps
80105f0f:	e9 36 f8 ff ff       	jmp    8010574a <alltraps>

80105f14 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $85
80105f16:	6a 55                	push   $0x55
  jmp alltraps
80105f18:	e9 2d f8 ff ff       	jmp    8010574a <alltraps>

80105f1d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $86
80105f1f:	6a 56                	push   $0x56
  jmp alltraps
80105f21:	e9 24 f8 ff ff       	jmp    8010574a <alltraps>

80105f26 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $87
80105f28:	6a 57                	push   $0x57
  jmp alltraps
80105f2a:	e9 1b f8 ff ff       	jmp    8010574a <alltraps>

80105f2f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $88
80105f31:	6a 58                	push   $0x58
  jmp alltraps
80105f33:	e9 12 f8 ff ff       	jmp    8010574a <alltraps>

80105f38 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $89
80105f3a:	6a 59                	push   $0x59
  jmp alltraps
80105f3c:	e9 09 f8 ff ff       	jmp    8010574a <alltraps>

80105f41 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $90
80105f43:	6a 5a                	push   $0x5a
  jmp alltraps
80105f45:	e9 00 f8 ff ff       	jmp    8010574a <alltraps>

80105f4a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $91
80105f4c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f4e:	e9 f7 f7 ff ff       	jmp    8010574a <alltraps>

80105f53 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $92
80105f55:	6a 5c                	push   $0x5c
  jmp alltraps
80105f57:	e9 ee f7 ff ff       	jmp    8010574a <alltraps>

80105f5c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $93
80105f5e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f60:	e9 e5 f7 ff ff       	jmp    8010574a <alltraps>

80105f65 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $94
80105f67:	6a 5e                	push   $0x5e
  jmp alltraps
80105f69:	e9 dc f7 ff ff       	jmp    8010574a <alltraps>

80105f6e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $95
80105f70:	6a 5f                	push   $0x5f
  jmp alltraps
80105f72:	e9 d3 f7 ff ff       	jmp    8010574a <alltraps>

80105f77 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $96
80105f79:	6a 60                	push   $0x60
  jmp alltraps
80105f7b:	e9 ca f7 ff ff       	jmp    8010574a <alltraps>

80105f80 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $97
80105f82:	6a 61                	push   $0x61
  jmp alltraps
80105f84:	e9 c1 f7 ff ff       	jmp    8010574a <alltraps>

80105f89 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $98
80105f8b:	6a 62                	push   $0x62
  jmp alltraps
80105f8d:	e9 b8 f7 ff ff       	jmp    8010574a <alltraps>

80105f92 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $99
80105f94:	6a 63                	push   $0x63
  jmp alltraps
80105f96:	e9 af f7 ff ff       	jmp    8010574a <alltraps>

80105f9b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $100
80105f9d:	6a 64                	push   $0x64
  jmp alltraps
80105f9f:	e9 a6 f7 ff ff       	jmp    8010574a <alltraps>

80105fa4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $101
80105fa6:	6a 65                	push   $0x65
  jmp alltraps
80105fa8:	e9 9d f7 ff ff       	jmp    8010574a <alltraps>

80105fad <vector102>:
.globl vector102
vector102:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $102
80105faf:	6a 66                	push   $0x66
  jmp alltraps
80105fb1:	e9 94 f7 ff ff       	jmp    8010574a <alltraps>

80105fb6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $103
80105fb8:	6a 67                	push   $0x67
  jmp alltraps
80105fba:	e9 8b f7 ff ff       	jmp    8010574a <alltraps>

80105fbf <vector104>:
.globl vector104
vector104:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $104
80105fc1:	6a 68                	push   $0x68
  jmp alltraps
80105fc3:	e9 82 f7 ff ff       	jmp    8010574a <alltraps>

80105fc8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $105
80105fca:	6a 69                	push   $0x69
  jmp alltraps
80105fcc:	e9 79 f7 ff ff       	jmp    8010574a <alltraps>

80105fd1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $106
80105fd3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fd5:	e9 70 f7 ff ff       	jmp    8010574a <alltraps>

80105fda <vector107>:
.globl vector107
vector107:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $107
80105fdc:	6a 6b                	push   $0x6b
  jmp alltraps
80105fde:	e9 67 f7 ff ff       	jmp    8010574a <alltraps>

80105fe3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $108
80105fe5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fe7:	e9 5e f7 ff ff       	jmp    8010574a <alltraps>

80105fec <vector109>:
.globl vector109
vector109:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $109
80105fee:	6a 6d                	push   $0x6d
  jmp alltraps
80105ff0:	e9 55 f7 ff ff       	jmp    8010574a <alltraps>

80105ff5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $110
80105ff7:	6a 6e                	push   $0x6e
  jmp alltraps
80105ff9:	e9 4c f7 ff ff       	jmp    8010574a <alltraps>

80105ffe <vector111>:
.globl vector111
vector111:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $111
80106000:	6a 6f                	push   $0x6f
  jmp alltraps
80106002:	e9 43 f7 ff ff       	jmp    8010574a <alltraps>

80106007 <vector112>:
.globl vector112
vector112:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $112
80106009:	6a 70                	push   $0x70
  jmp alltraps
8010600b:	e9 3a f7 ff ff       	jmp    8010574a <alltraps>

80106010 <vector113>:
.globl vector113
vector113:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $113
80106012:	6a 71                	push   $0x71
  jmp alltraps
80106014:	e9 31 f7 ff ff       	jmp    8010574a <alltraps>

80106019 <vector114>:
.globl vector114
vector114:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $114
8010601b:	6a 72                	push   $0x72
  jmp alltraps
8010601d:	e9 28 f7 ff ff       	jmp    8010574a <alltraps>

80106022 <vector115>:
.globl vector115
vector115:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $115
80106024:	6a 73                	push   $0x73
  jmp alltraps
80106026:	e9 1f f7 ff ff       	jmp    8010574a <alltraps>

8010602b <vector116>:
.globl vector116
vector116:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $116
8010602d:	6a 74                	push   $0x74
  jmp alltraps
8010602f:	e9 16 f7 ff ff       	jmp    8010574a <alltraps>

80106034 <vector117>:
.globl vector117
vector117:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $117
80106036:	6a 75                	push   $0x75
  jmp alltraps
80106038:	e9 0d f7 ff ff       	jmp    8010574a <alltraps>

8010603d <vector118>:
.globl vector118
vector118:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $118
8010603f:	6a 76                	push   $0x76
  jmp alltraps
80106041:	e9 04 f7 ff ff       	jmp    8010574a <alltraps>

80106046 <vector119>:
.globl vector119
vector119:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $119
80106048:	6a 77                	push   $0x77
  jmp alltraps
8010604a:	e9 fb f6 ff ff       	jmp    8010574a <alltraps>

8010604f <vector120>:
.globl vector120
vector120:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $120
80106051:	6a 78                	push   $0x78
  jmp alltraps
80106053:	e9 f2 f6 ff ff       	jmp    8010574a <alltraps>

80106058 <vector121>:
.globl vector121
vector121:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $121
8010605a:	6a 79                	push   $0x79
  jmp alltraps
8010605c:	e9 e9 f6 ff ff       	jmp    8010574a <alltraps>

80106061 <vector122>:
.globl vector122
vector122:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $122
80106063:	6a 7a                	push   $0x7a
  jmp alltraps
80106065:	e9 e0 f6 ff ff       	jmp    8010574a <alltraps>

8010606a <vector123>:
.globl vector123
vector123:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $123
8010606c:	6a 7b                	push   $0x7b
  jmp alltraps
8010606e:	e9 d7 f6 ff ff       	jmp    8010574a <alltraps>

80106073 <vector124>:
.globl vector124
vector124:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $124
80106075:	6a 7c                	push   $0x7c
  jmp alltraps
80106077:	e9 ce f6 ff ff       	jmp    8010574a <alltraps>

8010607c <vector125>:
.globl vector125
vector125:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $125
8010607e:	6a 7d                	push   $0x7d
  jmp alltraps
80106080:	e9 c5 f6 ff ff       	jmp    8010574a <alltraps>

80106085 <vector126>:
.globl vector126
vector126:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $126
80106087:	6a 7e                	push   $0x7e
  jmp alltraps
80106089:	e9 bc f6 ff ff       	jmp    8010574a <alltraps>

8010608e <vector127>:
.globl vector127
vector127:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $127
80106090:	6a 7f                	push   $0x7f
  jmp alltraps
80106092:	e9 b3 f6 ff ff       	jmp    8010574a <alltraps>

80106097 <vector128>:
.globl vector128
vector128:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $128
80106099:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010609e:	e9 a7 f6 ff ff       	jmp    8010574a <alltraps>

801060a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $129
801060a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060aa:	e9 9b f6 ff ff       	jmp    8010574a <alltraps>

801060af <vector130>:
.globl vector130
vector130:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $130
801060b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060b6:	e9 8f f6 ff ff       	jmp    8010574a <alltraps>

801060bb <vector131>:
.globl vector131
vector131:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $131
801060bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060c2:	e9 83 f6 ff ff       	jmp    8010574a <alltraps>

801060c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $132
801060c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060ce:	e9 77 f6 ff ff       	jmp    8010574a <alltraps>

801060d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $133
801060d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060da:	e9 6b f6 ff ff       	jmp    8010574a <alltraps>

801060df <vector134>:
.globl vector134
vector134:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $134
801060e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060e6:	e9 5f f6 ff ff       	jmp    8010574a <alltraps>

801060eb <vector135>:
.globl vector135
vector135:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $135
801060ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060f2:	e9 53 f6 ff ff       	jmp    8010574a <alltraps>

801060f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $136
801060f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060fe:	e9 47 f6 ff ff       	jmp    8010574a <alltraps>

80106103 <vector137>:
.globl vector137
vector137:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $137
80106105:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010610a:	e9 3b f6 ff ff       	jmp    8010574a <alltraps>

8010610f <vector138>:
.globl vector138
vector138:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $138
80106111:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106116:	e9 2f f6 ff ff       	jmp    8010574a <alltraps>

8010611b <vector139>:
.globl vector139
vector139:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $139
8010611d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106122:	e9 23 f6 ff ff       	jmp    8010574a <alltraps>

80106127 <vector140>:
.globl vector140
vector140:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $140
80106129:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010612e:	e9 17 f6 ff ff       	jmp    8010574a <alltraps>

80106133 <vector141>:
.globl vector141
vector141:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $141
80106135:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010613a:	e9 0b f6 ff ff       	jmp    8010574a <alltraps>

8010613f <vector142>:
.globl vector142
vector142:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $142
80106141:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106146:	e9 ff f5 ff ff       	jmp    8010574a <alltraps>

8010614b <vector143>:
.globl vector143
vector143:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $143
8010614d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106152:	e9 f3 f5 ff ff       	jmp    8010574a <alltraps>

80106157 <vector144>:
.globl vector144
vector144:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $144
80106159:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010615e:	e9 e7 f5 ff ff       	jmp    8010574a <alltraps>

80106163 <vector145>:
.globl vector145
vector145:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $145
80106165:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010616a:	e9 db f5 ff ff       	jmp    8010574a <alltraps>

8010616f <vector146>:
.globl vector146
vector146:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $146
80106171:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106176:	e9 cf f5 ff ff       	jmp    8010574a <alltraps>

8010617b <vector147>:
.globl vector147
vector147:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $147
8010617d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106182:	e9 c3 f5 ff ff       	jmp    8010574a <alltraps>

80106187 <vector148>:
.globl vector148
vector148:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $148
80106189:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010618e:	e9 b7 f5 ff ff       	jmp    8010574a <alltraps>

80106193 <vector149>:
.globl vector149
vector149:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $149
80106195:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010619a:	e9 ab f5 ff ff       	jmp    8010574a <alltraps>

8010619f <vector150>:
.globl vector150
vector150:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $150
801061a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061a6:	e9 9f f5 ff ff       	jmp    8010574a <alltraps>

801061ab <vector151>:
.globl vector151
vector151:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $151
801061ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061b2:	e9 93 f5 ff ff       	jmp    8010574a <alltraps>

801061b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $152
801061b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061be:	e9 87 f5 ff ff       	jmp    8010574a <alltraps>

801061c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $153
801061c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061ca:	e9 7b f5 ff ff       	jmp    8010574a <alltraps>

801061cf <vector154>:
.globl vector154
vector154:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $154
801061d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061d6:	e9 6f f5 ff ff       	jmp    8010574a <alltraps>

801061db <vector155>:
.globl vector155
vector155:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $155
801061dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061e2:	e9 63 f5 ff ff       	jmp    8010574a <alltraps>

801061e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $156
801061e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061ee:	e9 57 f5 ff ff       	jmp    8010574a <alltraps>

801061f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $157
801061f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061fa:	e9 4b f5 ff ff       	jmp    8010574a <alltraps>

801061ff <vector158>:
.globl vector158
vector158:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $158
80106201:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106206:	e9 3f f5 ff ff       	jmp    8010574a <alltraps>

8010620b <vector159>:
.globl vector159
vector159:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $159
8010620d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106212:	e9 33 f5 ff ff       	jmp    8010574a <alltraps>

80106217 <vector160>:
.globl vector160
vector160:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $160
80106219:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010621e:	e9 27 f5 ff ff       	jmp    8010574a <alltraps>

80106223 <vector161>:
.globl vector161
vector161:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $161
80106225:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010622a:	e9 1b f5 ff ff       	jmp    8010574a <alltraps>

8010622f <vector162>:
.globl vector162
vector162:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $162
80106231:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106236:	e9 0f f5 ff ff       	jmp    8010574a <alltraps>

8010623b <vector163>:
.globl vector163
vector163:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $163
8010623d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106242:	e9 03 f5 ff ff       	jmp    8010574a <alltraps>

80106247 <vector164>:
.globl vector164
vector164:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $164
80106249:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010624e:	e9 f7 f4 ff ff       	jmp    8010574a <alltraps>

80106253 <vector165>:
.globl vector165
vector165:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $165
80106255:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010625a:	e9 eb f4 ff ff       	jmp    8010574a <alltraps>

8010625f <vector166>:
.globl vector166
vector166:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $166
80106261:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106266:	e9 df f4 ff ff       	jmp    8010574a <alltraps>

8010626b <vector167>:
.globl vector167
vector167:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $167
8010626d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106272:	e9 d3 f4 ff ff       	jmp    8010574a <alltraps>

80106277 <vector168>:
.globl vector168
vector168:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $168
80106279:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010627e:	e9 c7 f4 ff ff       	jmp    8010574a <alltraps>

80106283 <vector169>:
.globl vector169
vector169:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $169
80106285:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010628a:	e9 bb f4 ff ff       	jmp    8010574a <alltraps>

8010628f <vector170>:
.globl vector170
vector170:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $170
80106291:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106296:	e9 af f4 ff ff       	jmp    8010574a <alltraps>

8010629b <vector171>:
.globl vector171
vector171:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $171
8010629d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062a2:	e9 a3 f4 ff ff       	jmp    8010574a <alltraps>

801062a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $172
801062a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062ae:	e9 97 f4 ff ff       	jmp    8010574a <alltraps>

801062b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $173
801062b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062ba:	e9 8b f4 ff ff       	jmp    8010574a <alltraps>

801062bf <vector174>:
.globl vector174
vector174:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $174
801062c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062c6:	e9 7f f4 ff ff       	jmp    8010574a <alltraps>

801062cb <vector175>:
.globl vector175
vector175:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $175
801062cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062d2:	e9 73 f4 ff ff       	jmp    8010574a <alltraps>

801062d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $176
801062d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062de:	e9 67 f4 ff ff       	jmp    8010574a <alltraps>

801062e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $177
801062e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062ea:	e9 5b f4 ff ff       	jmp    8010574a <alltraps>

801062ef <vector178>:
.globl vector178
vector178:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $178
801062f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062f6:	e9 4f f4 ff ff       	jmp    8010574a <alltraps>

801062fb <vector179>:
.globl vector179
vector179:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $179
801062fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106302:	e9 43 f4 ff ff       	jmp    8010574a <alltraps>

80106307 <vector180>:
.globl vector180
vector180:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $180
80106309:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010630e:	e9 37 f4 ff ff       	jmp    8010574a <alltraps>

80106313 <vector181>:
.globl vector181
vector181:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $181
80106315:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010631a:	e9 2b f4 ff ff       	jmp    8010574a <alltraps>

8010631f <vector182>:
.globl vector182
vector182:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $182
80106321:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106326:	e9 1f f4 ff ff       	jmp    8010574a <alltraps>

8010632b <vector183>:
.globl vector183
vector183:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $183
8010632d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106332:	e9 13 f4 ff ff       	jmp    8010574a <alltraps>

80106337 <vector184>:
.globl vector184
vector184:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $184
80106339:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010633e:	e9 07 f4 ff ff       	jmp    8010574a <alltraps>

80106343 <vector185>:
.globl vector185
vector185:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $185
80106345:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010634a:	e9 fb f3 ff ff       	jmp    8010574a <alltraps>

8010634f <vector186>:
.globl vector186
vector186:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $186
80106351:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106356:	e9 ef f3 ff ff       	jmp    8010574a <alltraps>

8010635b <vector187>:
.globl vector187
vector187:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $187
8010635d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106362:	e9 e3 f3 ff ff       	jmp    8010574a <alltraps>

80106367 <vector188>:
.globl vector188
vector188:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $188
80106369:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010636e:	e9 d7 f3 ff ff       	jmp    8010574a <alltraps>

80106373 <vector189>:
.globl vector189
vector189:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $189
80106375:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010637a:	e9 cb f3 ff ff       	jmp    8010574a <alltraps>

8010637f <vector190>:
.globl vector190
vector190:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $190
80106381:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106386:	e9 bf f3 ff ff       	jmp    8010574a <alltraps>

8010638b <vector191>:
.globl vector191
vector191:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $191
8010638d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106392:	e9 b3 f3 ff ff       	jmp    8010574a <alltraps>

80106397 <vector192>:
.globl vector192
vector192:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $192
80106399:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010639e:	e9 a7 f3 ff ff       	jmp    8010574a <alltraps>

801063a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $193
801063a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063aa:	e9 9b f3 ff ff       	jmp    8010574a <alltraps>

801063af <vector194>:
.globl vector194
vector194:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $194
801063b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063b6:	e9 8f f3 ff ff       	jmp    8010574a <alltraps>

801063bb <vector195>:
.globl vector195
vector195:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $195
801063bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063c2:	e9 83 f3 ff ff       	jmp    8010574a <alltraps>

801063c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $196
801063c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063ce:	e9 77 f3 ff ff       	jmp    8010574a <alltraps>

801063d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $197
801063d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063da:	e9 6b f3 ff ff       	jmp    8010574a <alltraps>

801063df <vector198>:
.globl vector198
vector198:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $198
801063e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063e6:	e9 5f f3 ff ff       	jmp    8010574a <alltraps>

801063eb <vector199>:
.globl vector199
vector199:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $199
801063ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063f2:	e9 53 f3 ff ff       	jmp    8010574a <alltraps>

801063f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $200
801063f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063fe:	e9 47 f3 ff ff       	jmp    8010574a <alltraps>

80106403 <vector201>:
.globl vector201
vector201:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $201
80106405:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010640a:	e9 3b f3 ff ff       	jmp    8010574a <alltraps>

8010640f <vector202>:
.globl vector202
vector202:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $202
80106411:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106416:	e9 2f f3 ff ff       	jmp    8010574a <alltraps>

8010641b <vector203>:
.globl vector203
vector203:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $203
8010641d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106422:	e9 23 f3 ff ff       	jmp    8010574a <alltraps>

80106427 <vector204>:
.globl vector204
vector204:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $204
80106429:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010642e:	e9 17 f3 ff ff       	jmp    8010574a <alltraps>

80106433 <vector205>:
.globl vector205
vector205:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $205
80106435:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010643a:	e9 0b f3 ff ff       	jmp    8010574a <alltraps>

8010643f <vector206>:
.globl vector206
vector206:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $206
80106441:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106446:	e9 ff f2 ff ff       	jmp    8010574a <alltraps>

8010644b <vector207>:
.globl vector207
vector207:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $207
8010644d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106452:	e9 f3 f2 ff ff       	jmp    8010574a <alltraps>

80106457 <vector208>:
.globl vector208
vector208:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $208
80106459:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010645e:	e9 e7 f2 ff ff       	jmp    8010574a <alltraps>

80106463 <vector209>:
.globl vector209
vector209:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $209
80106465:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010646a:	e9 db f2 ff ff       	jmp    8010574a <alltraps>

8010646f <vector210>:
.globl vector210
vector210:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $210
80106471:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106476:	e9 cf f2 ff ff       	jmp    8010574a <alltraps>

8010647b <vector211>:
.globl vector211
vector211:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $211
8010647d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106482:	e9 c3 f2 ff ff       	jmp    8010574a <alltraps>

80106487 <vector212>:
.globl vector212
vector212:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $212
80106489:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010648e:	e9 b7 f2 ff ff       	jmp    8010574a <alltraps>

80106493 <vector213>:
.globl vector213
vector213:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $213
80106495:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010649a:	e9 ab f2 ff ff       	jmp    8010574a <alltraps>

8010649f <vector214>:
.globl vector214
vector214:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $214
801064a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064a6:	e9 9f f2 ff ff       	jmp    8010574a <alltraps>

801064ab <vector215>:
.globl vector215
vector215:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $215
801064ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064b2:	e9 93 f2 ff ff       	jmp    8010574a <alltraps>

801064b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $216
801064b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064be:	e9 87 f2 ff ff       	jmp    8010574a <alltraps>

801064c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $217
801064c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064ca:	e9 7b f2 ff ff       	jmp    8010574a <alltraps>

801064cf <vector218>:
.globl vector218
vector218:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $218
801064d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064d6:	e9 6f f2 ff ff       	jmp    8010574a <alltraps>

801064db <vector219>:
.globl vector219
vector219:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $219
801064dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064e2:	e9 63 f2 ff ff       	jmp    8010574a <alltraps>

801064e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $220
801064e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064ee:	e9 57 f2 ff ff       	jmp    8010574a <alltraps>

801064f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $221
801064f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064fa:	e9 4b f2 ff ff       	jmp    8010574a <alltraps>

801064ff <vector222>:
.globl vector222
vector222:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $222
80106501:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106506:	e9 3f f2 ff ff       	jmp    8010574a <alltraps>

8010650b <vector223>:
.globl vector223
vector223:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $223
8010650d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106512:	e9 33 f2 ff ff       	jmp    8010574a <alltraps>

80106517 <vector224>:
.globl vector224
vector224:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $224
80106519:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010651e:	e9 27 f2 ff ff       	jmp    8010574a <alltraps>

80106523 <vector225>:
.globl vector225
vector225:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $225
80106525:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010652a:	e9 1b f2 ff ff       	jmp    8010574a <alltraps>

8010652f <vector226>:
.globl vector226
vector226:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $226
80106531:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106536:	e9 0f f2 ff ff       	jmp    8010574a <alltraps>

8010653b <vector227>:
.globl vector227
vector227:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $227
8010653d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106542:	e9 03 f2 ff ff       	jmp    8010574a <alltraps>

80106547 <vector228>:
.globl vector228
vector228:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $228
80106549:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010654e:	e9 f7 f1 ff ff       	jmp    8010574a <alltraps>

80106553 <vector229>:
.globl vector229
vector229:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $229
80106555:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010655a:	e9 eb f1 ff ff       	jmp    8010574a <alltraps>

8010655f <vector230>:
.globl vector230
vector230:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $230
80106561:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106566:	e9 df f1 ff ff       	jmp    8010574a <alltraps>

8010656b <vector231>:
.globl vector231
vector231:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $231
8010656d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106572:	e9 d3 f1 ff ff       	jmp    8010574a <alltraps>

80106577 <vector232>:
.globl vector232
vector232:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $232
80106579:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010657e:	e9 c7 f1 ff ff       	jmp    8010574a <alltraps>

80106583 <vector233>:
.globl vector233
vector233:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $233
80106585:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010658a:	e9 bb f1 ff ff       	jmp    8010574a <alltraps>

8010658f <vector234>:
.globl vector234
vector234:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $234
80106591:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106596:	e9 af f1 ff ff       	jmp    8010574a <alltraps>

8010659b <vector235>:
.globl vector235
vector235:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $235
8010659d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065a2:	e9 a3 f1 ff ff       	jmp    8010574a <alltraps>

801065a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $236
801065a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065ae:	e9 97 f1 ff ff       	jmp    8010574a <alltraps>

801065b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $237
801065b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065ba:	e9 8b f1 ff ff       	jmp    8010574a <alltraps>

801065bf <vector238>:
.globl vector238
vector238:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $238
801065c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065c6:	e9 7f f1 ff ff       	jmp    8010574a <alltraps>

801065cb <vector239>:
.globl vector239
vector239:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $239
801065cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065d2:	e9 73 f1 ff ff       	jmp    8010574a <alltraps>

801065d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $240
801065d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065de:	e9 67 f1 ff ff       	jmp    8010574a <alltraps>

801065e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $241
801065e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065ea:	e9 5b f1 ff ff       	jmp    8010574a <alltraps>

801065ef <vector242>:
.globl vector242
vector242:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $242
801065f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065f6:	e9 4f f1 ff ff       	jmp    8010574a <alltraps>

801065fb <vector243>:
.globl vector243
vector243:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $243
801065fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106602:	e9 43 f1 ff ff       	jmp    8010574a <alltraps>

80106607 <vector244>:
.globl vector244
vector244:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $244
80106609:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010660e:	e9 37 f1 ff ff       	jmp    8010574a <alltraps>

80106613 <vector245>:
.globl vector245
vector245:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $245
80106615:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010661a:	e9 2b f1 ff ff       	jmp    8010574a <alltraps>

8010661f <vector246>:
.globl vector246
vector246:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $246
80106621:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106626:	e9 1f f1 ff ff       	jmp    8010574a <alltraps>

8010662b <vector247>:
.globl vector247
vector247:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $247
8010662d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106632:	e9 13 f1 ff ff       	jmp    8010574a <alltraps>

80106637 <vector248>:
.globl vector248
vector248:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $248
80106639:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010663e:	e9 07 f1 ff ff       	jmp    8010574a <alltraps>

80106643 <vector249>:
.globl vector249
vector249:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $249
80106645:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010664a:	e9 fb f0 ff ff       	jmp    8010574a <alltraps>

8010664f <vector250>:
.globl vector250
vector250:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $250
80106651:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106656:	e9 ef f0 ff ff       	jmp    8010574a <alltraps>

8010665b <vector251>:
.globl vector251
vector251:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $251
8010665d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106662:	e9 e3 f0 ff ff       	jmp    8010574a <alltraps>

80106667 <vector252>:
.globl vector252
vector252:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $252
80106669:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010666e:	e9 d7 f0 ff ff       	jmp    8010574a <alltraps>

80106673 <vector253>:
.globl vector253
vector253:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $253
80106675:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010667a:	e9 cb f0 ff ff       	jmp    8010574a <alltraps>

8010667f <vector254>:
.globl vector254
vector254:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $254
80106681:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106686:	e9 bf f0 ff ff       	jmp    8010574a <alltraps>

8010668b <vector255>:
.globl vector255
vector255:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $255
8010668d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106692:	e9 b3 f0 ff ff       	jmp    8010574a <alltraps>
80106697:	66 90                	xchg   %ax,%ax
80106699:	66 90                	xchg   %ax,%ax
8010669b:	66 90                	xchg   %ax,%ax
8010669d:	66 90                	xchg   %ax,%ax
8010669f:	90                   	nop

801066a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	57                   	push   %edi
801066a4:	56                   	push   %esi
801066a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066a7:	c1 ea 16             	shr    $0x16,%edx
{
801066aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066b1:	8b 07                	mov    (%edi),%eax
801066b3:	a8 01                	test   $0x1,%al
801066b5:	74 29                	je     801066e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066bc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066c2:	c1 ee 0a             	shr    $0xa,%esi
}
801066c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801066c8:	89 f2                	mov    %esi,%edx
801066ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066d0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066d3:	5b                   	pop    %ebx
801066d4:	5e                   	pop    %esi
801066d5:	5f                   	pop    %edi
801066d6:	5d                   	pop    %ebp
801066d7:	c3                   	ret    
801066d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066e0:	85 c9                	test   %ecx,%ecx
801066e2:	74 2c                	je     80106710 <walkpgdir+0x70>
801066e4:	e8 b7 be ff ff       	call   801025a0 <kalloc>
801066e9:	89 c3                	mov    %eax,%ebx
801066eb:	85 c0                	test   %eax,%eax
801066ed:	74 21                	je     80106710 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066ef:	83 ec 04             	sub    $0x4,%esp
801066f2:	68 00 10 00 00       	push   $0x1000
801066f7:	6a 00                	push   $0x0
801066f9:	50                   	push   %eax
801066fa:	e8 a1 de ff ff       	call   801045a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106705:	83 c4 10             	add    $0x10,%esp
80106708:	83 c8 07             	or     $0x7,%eax
8010670b:	89 07                	mov    %eax,(%edi)
8010670d:	eb b3                	jmp    801066c2 <walkpgdir+0x22>
8010670f:	90                   	nop
}
80106710:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106713:	31 c0                	xor    %eax,%eax
}
80106715:	5b                   	pop    %ebx
80106716:	5e                   	pop    %esi
80106717:	5f                   	pop    %edi
80106718:	5d                   	pop    %ebp
80106719:	c3                   	ret    
8010671a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106720 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106725:	89 d6                	mov    %edx,%esi
{
80106727:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106728:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010672e:	83 ec 1c             	sub    $0x1c,%esp
80106731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106734:	8b 7d 08             	mov    0x8(%ebp),%edi
80106737:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010673b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106740:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106743:	29 f7                	sub    %esi,%edi
80106745:	eb 21                	jmp    80106768 <mappages+0x48>
80106747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106750:	f6 00 01             	testb  $0x1,(%eax)
80106753:	75 45                	jne    8010679a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106755:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106758:	83 cb 01             	or     $0x1,%ebx
8010675b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010675d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106760:	74 2e                	je     80106790 <mappages+0x70>
      break;
    a += PGSIZE;
80106762:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010676b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106770:	89 f2                	mov    %esi,%edx
80106772:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106775:	e8 26 ff ff ff       	call   801066a0 <walkpgdir>
8010677a:	85 c0                	test   %eax,%eax
8010677c:	75 d2                	jne    80106750 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010677e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106786:	5b                   	pop    %ebx
80106787:	5e                   	pop    %esi
80106788:	5f                   	pop    %edi
80106789:	5d                   	pop    %ebp
8010678a:	c3                   	ret    
8010678b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010678f:	90                   	nop
80106790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106793:	31 c0                	xor    %eax,%eax
}
80106795:	5b                   	pop    %ebx
80106796:	5e                   	pop    %esi
80106797:	5f                   	pop    %edi
80106798:	5d                   	pop    %ebp
80106799:	c3                   	ret    
      panic("remap");
8010679a:	83 ec 0c             	sub    $0xc,%esp
8010679d:	68 90 78 10 80       	push   $0x80107890
801067a2:	e8 e9 9b ff ff       	call   80100390 <panic>
801067a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ae:	66 90                	xchg   %ax,%ax

801067b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	89 c7                	mov    %eax,%edi
801067b6:	56                   	push   %esi
801067b7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067b8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067c4:	83 ec 1c             	sub    $0x1c,%esp
801067c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801067ca:	39 d3                	cmp    %edx,%ebx
801067cc:	73 5a                	jae    80106828 <deallocuvm.part.0+0x78>
801067ce:	89 d6                	mov    %edx,%esi
801067d0:	eb 10                	jmp    801067e2 <deallocuvm.part.0+0x32>
801067d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067de:	39 de                	cmp    %ebx,%esi
801067e0:	76 46                	jbe    80106828 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067e2:	31 c9                	xor    %ecx,%ecx
801067e4:	89 da                	mov    %ebx,%edx
801067e6:	89 f8                	mov    %edi,%eax
801067e8:	e8 b3 fe ff ff       	call   801066a0 <walkpgdir>
    if(!pte)
801067ed:	85 c0                	test   %eax,%eax
801067ef:	74 47                	je     80106838 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801067f1:	8b 10                	mov    (%eax),%edx
801067f3:	f6 c2 01             	test   $0x1,%dl
801067f6:	74 e0                	je     801067d8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067f8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067fe:	74 46                	je     80106846 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106800:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106803:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010680c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106812:	52                   	push   %edx
80106813:	e8 c8 bb ff ff       	call   801023e0 <kfree>
      *pte = 0;
80106818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010681b:	83 c4 10             	add    $0x10,%esp
8010681e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106824:	39 de                	cmp    %ebx,%esi
80106826:	77 ba                	ja     801067e2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010682b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010682e:	5b                   	pop    %ebx
8010682f:	5e                   	pop    %esi
80106830:	5f                   	pop    %edi
80106831:	5d                   	pop    %ebp
80106832:	c3                   	ret    
80106833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106837:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106838:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010683e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106844:	eb 98                	jmp    801067de <deallocuvm.part.0+0x2e>
        panic("kfree");
80106846:	83 ec 0c             	sub    $0xc,%esp
80106849:	68 26 72 10 80       	push   $0x80107226
8010684e:	e8 3d 9b ff ff       	call   80100390 <panic>
80106853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <seginit>:
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106866:	e8 65 d0 ff ff       	call   801038d0 <cpuid>
  pd[0] = size-1;
8010686b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106870:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106876:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010687a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106881:	ff 00 00 
80106884:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010688b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010688e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106895:	ff 00 00 
80106898:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010689f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068a2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801068a9:	ff 00 00 
801068ac:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801068b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068b6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801068bd:	ff 00 00 
801068c0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801068c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801068ca:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801068cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068d3:	c1 e8 10             	shr    $0x10,%eax
801068d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801068da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068dd:	0f 01 10             	lgdtl  (%eax)
}
801068e0:	c9                   	leave  
801068e1:	c3                   	ret    
801068e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068f0:	a1 c4 54 11 80       	mov    0x801154c4,%eax
801068f5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068fa:	0f 22 d8             	mov    %eax,%cr3
}
801068fd:	c3                   	ret    
801068fe:	66 90                	xchg   %ax,%ax

80106900 <switchuvm>:
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
80106909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010690c:	85 db                	test   %ebx,%ebx
8010690e:	0f 84 cb 00 00 00    	je     801069df <switchuvm+0xdf>
  if(p->kstack == 0)
80106914:	8b 43 08             	mov    0x8(%ebx),%eax
80106917:	85 c0                	test   %eax,%eax
80106919:	0f 84 da 00 00 00    	je     801069f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010691f:	8b 43 04             	mov    0x4(%ebx),%eax
80106922:	85 c0                	test   %eax,%eax
80106924:	0f 84 c2 00 00 00    	je     801069ec <switchuvm+0xec>
  pushcli();
8010692a:	e8 71 da ff ff       	call   801043a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010692f:	e8 1c cf ff ff       	call   80103850 <mycpu>
80106934:	89 c6                	mov    %eax,%esi
80106936:	e8 15 cf ff ff       	call   80103850 <mycpu>
8010693b:	89 c7                	mov    %eax,%edi
8010693d:	e8 0e cf ff ff       	call   80103850 <mycpu>
80106942:	83 c7 08             	add    $0x8,%edi
80106945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106948:	e8 03 cf ff ff       	call   80103850 <mycpu>
8010694d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106950:	ba 67 00 00 00       	mov    $0x67,%edx
80106955:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010695c:	83 c0 08             	add    $0x8,%eax
8010695f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106966:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010696b:	83 c1 08             	add    $0x8,%ecx
8010696e:	c1 e8 18             	shr    $0x18,%eax
80106971:	c1 e9 10             	shr    $0x10,%ecx
80106974:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
8010697a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106980:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106985:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010698c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106991:	e8 ba ce ff ff       	call   80103850 <mycpu>
80106996:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010699d:	e8 ae ce ff ff       	call   80103850 <mycpu>
801069a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069a6:	8b 73 08             	mov    0x8(%ebx),%esi
801069a9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069af:	e8 9c ce ff ff       	call   80103850 <mycpu>
801069b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069b7:	e8 94 ce ff ff       	call   80103850 <mycpu>
801069bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801069c0:	b8 28 00 00 00       	mov    $0x28,%eax
801069c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069c8:	8b 43 04             	mov    0x4(%ebx),%eax
801069cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069d0:	0f 22 d8             	mov    %eax,%cr3
}
801069d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069d6:	5b                   	pop    %ebx
801069d7:	5e                   	pop    %esi
801069d8:	5f                   	pop    %edi
801069d9:	5d                   	pop    %ebp
  popcli();
801069da:	e9 11 da ff ff       	jmp    801043f0 <popcli>
    panic("switchuvm: no process");
801069df:	83 ec 0c             	sub    $0xc,%esp
801069e2:	68 96 78 10 80       	push   $0x80107896
801069e7:	e8 a4 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801069ec:	83 ec 0c             	sub    $0xc,%esp
801069ef:	68 c1 78 10 80       	push   $0x801078c1
801069f4:	e8 97 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801069f9:	83 ec 0c             	sub    $0xc,%esp
801069fc:	68 ac 78 10 80       	push   $0x801078ac
80106a01:	e8 8a 99 ff ff       	call   80100390 <panic>
80106a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a0d:	8d 76 00             	lea    0x0(%esi),%esi

80106a10 <inituvm>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
80106a16:	83 ec 1c             	sub    $0x1c,%esp
80106a19:	8b 45 08             	mov    0x8(%ebp),%eax
80106a1c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a25:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a2b:	77 49                	ja     80106a76 <inituvm+0x66>
  mem = kalloc();
80106a2d:	e8 6e bb ff ff       	call   801025a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a32:	83 ec 04             	sub    $0x4,%esp
80106a35:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a3a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a3c:	6a 00                	push   $0x0
80106a3e:	50                   	push   %eax
80106a3f:	e8 5c db ff ff       	call   801045a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a44:	58                   	pop    %eax
80106a45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a4b:	5a                   	pop    %edx
80106a4c:	6a 06                	push   $0x6
80106a4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a53:	31 d2                	xor    %edx,%edx
80106a55:	50                   	push   %eax
80106a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a59:	e8 c2 fc ff ff       	call   80106720 <mappages>
  memmove(mem, init, sz);
80106a5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a61:	83 c4 10             	add    $0x10,%esp
80106a64:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a6d:	5b                   	pop    %ebx
80106a6e:	5e                   	pop    %esi
80106a6f:	5f                   	pop    %edi
80106a70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a71:	e9 ca db ff ff       	jmp    80104640 <memmove>
    panic("inituvm: more than a page");
80106a76:	83 ec 0c             	sub    $0xc,%esp
80106a79:	68 d5 78 10 80       	push   $0x801078d5
80106a7e:	e8 0d 99 ff ff       	call   80100390 <panic>
80106a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a90 <loaduvm>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a9c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106a9f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106aa4:	0f 85 8d 00 00 00    	jne    80106b37 <loaduvm+0xa7>
80106aaa:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106aac:	89 f3                	mov    %esi,%ebx
80106aae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ab1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ab4:	01 f0                	add    %esi,%eax
80106ab6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ab9:	85 f6                	test   %esi,%esi
80106abb:	75 11                	jne    80106ace <loaduvm+0x3e>
80106abd:	eb 61                	jmp    80106b20 <loaduvm+0x90>
80106abf:	90                   	nop
80106ac0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ac6:	89 f0                	mov    %esi,%eax
80106ac8:	29 d8                	sub    %ebx,%eax
80106aca:	39 c6                	cmp    %eax,%esi
80106acc:	76 52                	jbe    80106b20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad4:	31 c9                	xor    %ecx,%ecx
80106ad6:	29 da                	sub    %ebx,%edx
80106ad8:	e8 c3 fb ff ff       	call   801066a0 <walkpgdir>
80106add:	85 c0                	test   %eax,%eax
80106adf:	74 49                	je     80106b2a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ae1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ae3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ae6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106af0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106af6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af9:	29 d9                	sub    %ebx,%ecx
80106afb:	05 00 00 00 80       	add    $0x80000000,%eax
80106b00:	57                   	push   %edi
80106b01:	51                   	push   %ecx
80106b02:	50                   	push   %eax
80106b03:	ff 75 10             	pushl  0x10(%ebp)
80106b06:	e8 e5 ae ff ff       	call   801019f0 <readi>
80106b0b:	83 c4 10             	add    $0x10,%esp
80106b0e:	39 f8                	cmp    %edi,%eax
80106b10:	74 ae                	je     80106ac0 <loaduvm+0x30>
}
80106b12:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b1a:	5b                   	pop    %ebx
80106b1b:	5e                   	pop    %esi
80106b1c:	5f                   	pop    %edi
80106b1d:	5d                   	pop    %ebp
80106b1e:	c3                   	ret    
80106b1f:	90                   	nop
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	68 ef 78 10 80       	push   $0x801078ef
80106b32:	e8 59 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b37:	83 ec 0c             	sub    $0xc,%esp
80106b3a:	68 90 79 10 80       	push   $0x80107990
80106b3f:	e8 4c 98 ff ff       	call   80100390 <panic>
80106b44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b4f:	90                   	nop

80106b50 <allocuvm>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b59:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b5c:	85 ff                	test   %edi,%edi
80106b5e:	0f 88 bc 00 00 00    	js     80106c20 <allocuvm+0xd0>
  if(newsz < oldsz)
80106b64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b67:	0f 82 a3 00 00 00    	jb     80106c10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b7c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b7f:	0f 86 8e 00 00 00    	jbe    80106c13 <allocuvm+0xc3>
80106b85:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b8b:	eb 42                	jmp    80106bcf <allocuvm+0x7f>
80106b8d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106b90:	83 ec 04             	sub    $0x4,%esp
80106b93:	68 00 10 00 00       	push   $0x1000
80106b98:	6a 00                	push   $0x0
80106b9a:	50                   	push   %eax
80106b9b:	e8 00 da ff ff       	call   801045a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ba0:	58                   	pop    %eax
80106ba1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ba7:	5a                   	pop    %edx
80106ba8:	6a 06                	push   $0x6
80106baa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106baf:	89 da                	mov    %ebx,%edx
80106bb1:	50                   	push   %eax
80106bb2:	89 f8                	mov    %edi,%eax
80106bb4:	e8 67 fb ff ff       	call   80106720 <mappages>
80106bb9:	83 c4 10             	add    $0x10,%esp
80106bbc:	85 c0                	test   %eax,%eax
80106bbe:	78 70                	js     80106c30 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106bc0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bc6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bc9:	0f 86 a1 00 00 00    	jbe    80106c70 <allocuvm+0x120>
    mem = kalloc();
80106bcf:	e8 cc b9 ff ff       	call   801025a0 <kalloc>
80106bd4:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bd6:	85 c0                	test   %eax,%eax
80106bd8:	75 b6                	jne    80106b90 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 0d 79 10 80       	push   $0x8010790d
80106be2:	e8 c9 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106be7:	83 c4 10             	add    $0x10,%esp
80106bea:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bed:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bf0:	74 2e                	je     80106c20 <allocuvm+0xd0>
80106bf2:	89 c1                	mov    %eax,%ecx
80106bf4:	8b 55 10             	mov    0x10(%ebp),%edx
80106bf7:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106bfa:	31 ff                	xor    %edi,%edi
80106bfc:	e8 af fb ff ff       	call   801067b0 <deallocuvm.part.0>
}
80106c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c04:	89 f8                	mov    %edi,%eax
80106c06:	5b                   	pop    %ebx
80106c07:	5e                   	pop    %esi
80106c08:	5f                   	pop    %edi
80106c09:	5d                   	pop    %ebp
80106c0a:	c3                   	ret    
80106c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c0f:	90                   	nop
    return oldsz;
80106c10:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	89 f8                	mov    %edi,%eax
80106c18:	5b                   	pop    %ebx
80106c19:	5e                   	pop    %esi
80106c1a:	5f                   	pop    %edi
80106c1b:	5d                   	pop    %ebp
80106c1c:	c3                   	ret    
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
80106c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c23:	31 ff                	xor    %edi,%edi
}
80106c25:	5b                   	pop    %ebx
80106c26:	89 f8                	mov    %edi,%eax
80106c28:	5e                   	pop    %esi
80106c29:	5f                   	pop    %edi
80106c2a:	5d                   	pop    %ebp
80106c2b:	c3                   	ret    
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	68 25 79 10 80       	push   $0x80107925
80106c38:	e8 73 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c3d:	83 c4 10             	add    $0x10,%esp
80106c40:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c43:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c46:	74 0d                	je     80106c55 <allocuvm+0x105>
80106c48:	89 c1                	mov    %eax,%ecx
80106c4a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c50:	e8 5b fb ff ff       	call   801067b0 <deallocuvm.part.0>
      kfree(mem);
80106c55:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c58:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c5a:	56                   	push   %esi
80106c5b:	e8 80 b7 ff ff       	call   801023e0 <kfree>
      return 0;
80106c60:	83 c4 10             	add    $0x10,%esp
}
80106c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c66:	89 f8                	mov    %edi,%eax
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
80106c6c:	c3                   	ret    
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi
80106c70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c76:	5b                   	pop    %ebx
80106c77:	5e                   	pop    %esi
80106c78:	89 f8                	mov    %edi,%eax
80106c7a:	5f                   	pop    %edi
80106c7b:	5d                   	pop    %ebp
80106c7c:	c3                   	ret    
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi

80106c80 <deallocuvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c86:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c89:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c8c:	39 d1                	cmp    %edx,%ecx
80106c8e:	73 10                	jae    80106ca0 <deallocuvm+0x20>
}
80106c90:	5d                   	pop    %ebp
80106c91:	e9 1a fb ff ff       	jmp    801067b0 <deallocuvm.part.0>
80106c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ca0:	89 d0                	mov    %edx,%eax
80106ca2:	5d                   	pop    %ebp
80106ca3:	c3                   	ret    
80106ca4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106caf:	90                   	nop

80106cb0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
80106cb6:	83 ec 0c             	sub    $0xc,%esp
80106cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106cbc:	85 f6                	test   %esi,%esi
80106cbe:	74 59                	je     80106d19 <freevm+0x69>
  if(newsz >= oldsz)
80106cc0:	31 c9                	xor    %ecx,%ecx
80106cc2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106cc7:	89 f0                	mov    %esi,%eax
80106cc9:	89 f3                	mov    %esi,%ebx
80106ccb:	e8 e0 fa ff ff       	call   801067b0 <deallocuvm.part.0>
freevm(pde_t *pgdir)
80106cd0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106cd6:	eb 0f                	jmp    80106ce7 <freevm+0x37>
80106cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cdf:	90                   	nop
80106ce0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ce3:	39 df                	cmp    %ebx,%edi
80106ce5:	74 23                	je     80106d0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ce7:	8b 03                	mov    (%ebx),%eax
80106ce9:	a8 01                	test   $0x1,%al
80106ceb:	74 f3                	je     80106ce0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106cf2:	83 ec 0c             	sub    $0xc,%esp
80106cf5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cf8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106cfd:	50                   	push   %eax
80106cfe:	e8 dd b6 ff ff       	call   801023e0 <kfree>
80106d03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d06:	39 df                	cmp    %ebx,%edi
80106d08:	75 dd                	jne    80106ce7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d10:	5b                   	pop    %ebx
80106d11:	5e                   	pop    %esi
80106d12:	5f                   	pop    %edi
80106d13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d14:	e9 c7 b6 ff ff       	jmp    801023e0 <kfree>
    panic("freevm: no pgdir");
80106d19:	83 ec 0c             	sub    $0xc,%esp
80106d1c:	68 41 79 10 80       	push   $0x80107941
80106d21:	e8 6a 96 ff ff       	call   80100390 <panic>
80106d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2d:	8d 76 00             	lea    0x0(%esi),%esi

80106d30 <setupkvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	56                   	push   %esi
80106d34:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d35:	e8 66 b8 ff ff       	call   801025a0 <kalloc>
80106d3a:	89 c6                	mov    %eax,%esi
80106d3c:	85 c0                	test   %eax,%eax
80106d3e:	74 42                	je     80106d82 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d40:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d43:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d48:	68 00 10 00 00       	push   $0x1000
80106d4d:	6a 00                	push   $0x0
80106d4f:	50                   	push   %eax
80106d50:	e8 4b d8 ff ff       	call   801045a0 <memset>
80106d55:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d58:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d5b:	83 ec 08             	sub    $0x8,%esp
80106d5e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d61:	ff 73 0c             	pushl  0xc(%ebx)
80106d64:	8b 13                	mov    (%ebx),%edx
80106d66:	50                   	push   %eax
80106d67:	29 c1                	sub    %eax,%ecx
80106d69:	89 f0                	mov    %esi,%eax
80106d6b:	e8 b0 f9 ff ff       	call   80106720 <mappages>
80106d70:	83 c4 10             	add    $0x10,%esp
80106d73:	85 c0                	test   %eax,%eax
80106d75:	78 19                	js     80106d90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d77:	83 c3 10             	add    $0x10,%ebx
80106d7a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d80:	75 d6                	jne    80106d58 <setupkvm+0x28>
}
80106d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d85:	89 f0                	mov    %esi,%eax
80106d87:	5b                   	pop    %ebx
80106d88:	5e                   	pop    %esi
80106d89:	5d                   	pop    %ebp
80106d8a:	c3                   	ret    
80106d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d8f:	90                   	nop
      freevm(pgdir);
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	56                   	push   %esi
      return 0;
80106d94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106d96:	e8 15 ff ff ff       	call   80106cb0 <freevm>
      return 0;
80106d9b:	83 c4 10             	add    $0x10,%esp
}
80106d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106da1:	89 f0                	mov    %esi,%eax
80106da3:	5b                   	pop    %ebx
80106da4:	5e                   	pop    %esi
80106da5:	5d                   	pop    %ebp
80106da6:	c3                   	ret    
80106da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dae:	66 90                	xchg   %ax,%ax

80106db0 <kvmalloc>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106db6:	e8 75 ff ff ff       	call   80106d30 <setupkvm>
80106dbb:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dc0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dc5:	0f 22 d8             	mov    %eax,%cr3
}
80106dc8:	c9                   	leave  
80106dc9:	c3                   	ret    
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106dd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106dd1:	31 c9                	xor    %ecx,%ecx
{
80106dd3:	89 e5                	mov    %esp,%ebp
80106dd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dde:	e8 bd f8 ff ff       	call   801066a0 <walkpgdir>
  if(pte == 0)
80106de3:	85 c0                	test   %eax,%eax
80106de5:	74 05                	je     80106dec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106de7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dea:	c9                   	leave  
80106deb:	c3                   	ret    
    panic("clearpteu");
80106dec:	83 ec 0c             	sub    $0xc,%esp
80106def:	68 52 79 10 80       	push   $0x80107952
80106df4:	e8 97 95 ff ff       	call   80100390 <panic>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e09:	e8 22 ff ff ff       	call   80106d30 <setupkvm>
80106e0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e11:	85 c0                	test   %eax,%eax
80106e13:	0f 84 9f 00 00 00    	je     80106eb8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e1c:	85 c9                	test   %ecx,%ecx
80106e1e:	0f 84 94 00 00 00    	je     80106eb8 <copyuvm+0xb8>
80106e24:	31 ff                	xor    %edi,%edi
80106e26:	eb 4a                	jmp    80106e72 <copyuvm+0x72>
80106e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e30:	83 ec 04             	sub    $0x4,%esp
80106e33:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e39:	68 00 10 00 00       	push   $0x1000
80106e3e:	53                   	push   %ebx
80106e3f:	50                   	push   %eax
80106e40:	e8 fb d7 ff ff       	call   80104640 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e45:	58                   	pop    %eax
80106e46:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e4c:	5a                   	pop    %edx
80106e4d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e50:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e55:	89 fa                	mov    %edi,%edx
80106e57:	50                   	push   %eax
80106e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e5b:	e8 c0 f8 ff ff       	call   80106720 <mappages>
80106e60:	83 c4 10             	add    $0x10,%esp
80106e63:	85 c0                	test   %eax,%eax
80106e65:	78 61                	js     80106ec8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e67:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e6d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e70:	76 46                	jbe    80106eb8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e72:	8b 45 08             	mov    0x8(%ebp),%eax
80106e75:	31 c9                	xor    %ecx,%ecx
80106e77:	89 fa                	mov    %edi,%edx
80106e79:	e8 22 f8 ff ff       	call   801066a0 <walkpgdir>
80106e7e:	85 c0                	test   %eax,%eax
80106e80:	74 61                	je     80106ee3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106e82:	8b 00                	mov    (%eax),%eax
80106e84:	a8 01                	test   $0x1,%al
80106e86:	74 4e                	je     80106ed6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106e88:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e8a:	25 ff 0f 00 00       	and    $0xfff,%eax
80106e8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106e92:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
80106e98:	e8 03 b7 ff ff       	call   801025a0 <kalloc>
80106e9d:	89 c6                	mov    %eax,%esi
80106e9f:	85 c0                	test   %eax,%eax
80106ea1:	75 8d                	jne    80106e30 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106ea3:	83 ec 0c             	sub    $0xc,%esp
80106ea6:	ff 75 e0             	pushl  -0x20(%ebp)
80106ea9:	e8 02 fe ff ff       	call   80106cb0 <freevm>
  return 0;
80106eae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106eb5:	83 c4 10             	add    $0x10,%esp
}
80106eb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ebe:	5b                   	pop    %ebx
80106ebf:	5e                   	pop    %esi
80106ec0:	5f                   	pop    %edi
80106ec1:	5d                   	pop    %ebp
80106ec2:	c3                   	ret    
80106ec3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ec7:	90                   	nop
      kfree(mem);
80106ec8:	83 ec 0c             	sub    $0xc,%esp
80106ecb:	56                   	push   %esi
80106ecc:	e8 0f b5 ff ff       	call   801023e0 <kfree>
      goto bad;
80106ed1:	83 c4 10             	add    $0x10,%esp
80106ed4:	eb cd                	jmp    80106ea3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106ed6:	83 ec 0c             	sub    $0xc,%esp
80106ed9:	68 76 79 10 80       	push   $0x80107976
80106ede:	e8 ad 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106ee3:	83 ec 0c             	sub    $0xc,%esp
80106ee6:	68 5c 79 10 80       	push   $0x8010795c
80106eeb:	e8 a0 94 ff ff       	call   80100390 <panic>

80106ef0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ef0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ef1:	31 c9                	xor    %ecx,%ecx
{
80106ef3:	89 e5                	mov    %esp,%ebp
80106ef5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106efb:	8b 45 08             	mov    0x8(%ebp),%eax
80106efe:	e8 9d f7 ff ff       	call   801066a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f03:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f10:	05 00 00 00 80       	add    $0x80000000,%eax
80106f15:	83 fa 05             	cmp    $0x5,%edx
80106f18:	ba 00 00 00 00       	mov    $0x0,%edx
80106f1d:	0f 45 c2             	cmovne %edx,%eax
}
80106f20:	c3                   	ret    
80106f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop

80106f30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 0c             	sub    $0xc,%esp
80106f39:	8b 75 14             	mov    0x14(%ebp),%esi
80106f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f3f:	85 f6                	test   %esi,%esi
80106f41:	75 38                	jne    80106f7b <copyout+0x4b>
80106f43:	eb 6b                	jmp    80106fb0 <copyout+0x80>
80106f45:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f4b:	89 fb                	mov    %edi,%ebx
80106f4d:	29 d3                	sub    %edx,%ebx
80106f4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106f55:	39 f3                	cmp    %esi,%ebx
80106f57:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f5a:	29 fa                	sub    %edi,%edx
80106f5c:	83 ec 04             	sub    $0x4,%esp
80106f5f:	01 c2                	add    %eax,%edx
80106f61:	53                   	push   %ebx
80106f62:	ff 75 10             	pushl  0x10(%ebp)
80106f65:	52                   	push   %edx
80106f66:	e8 d5 d6 ff ff       	call   80104640 <memmove>
    len -= n;
    buf += n;
80106f6b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106f6e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106f74:	83 c4 10             	add    $0x10,%esp
80106f77:	29 de                	sub    %ebx,%esi
80106f79:	74 35                	je     80106fb0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106f7b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f7d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f80:	89 55 0c             	mov    %edx,0xc(%ebp)
80106f83:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f89:	57                   	push   %edi
80106f8a:	ff 75 08             	pushl  0x8(%ebp)
80106f8d:	e8 5e ff ff ff       	call   80106ef0 <uva2ka>
    if(pa0 == 0)
80106f92:	83 c4 10             	add    $0x10,%esp
80106f95:	85 c0                	test   %eax,%eax
80106f97:	75 af                	jne    80106f48 <copyout+0x18>
  }
  return 0;
}
80106f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fa1:	5b                   	pop    %ebx
80106fa2:	5e                   	pop    %esi
80106fa3:	5f                   	pop    %edi
80106fa4:	5d                   	pop    %ebp
80106fa5:	c3                   	ret    
80106fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fad:	8d 76 00             	lea    0x0(%esi),%esi
80106fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fb3:	31 c0                	xor    %eax,%eax
}
80106fb5:	5b                   	pop    %ebx
80106fb6:	5e                   	pop    %esi
80106fb7:	5f                   	pop    %edi
80106fb8:	5d                   	pop    %ebp
80106fb9:	c3                   	ret    
