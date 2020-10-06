
obj/kern/kernel:     file format elf64-x86-64


Disassembly of section .bootstrap:

0000000001500000 <_head64>:

.text
.globl _head64
_head64:
  # Disable interrupts.
  cli
 1500000:	fa                   	cli    

  # Save Loader_block pointer from Bootloader.c in r12.
  movq %rcx,%r12
 1500001:	49 89 cc             	mov    %rcx,%r12

  # Build an early boot pml4 at pml4phys (physical = virtual for it).

  # Initialize the page tables.
  movl $pml4,%edi
 1500004:	bf 00 10 50 01       	mov    $0x1501000,%edi
  xorl %eax,%eax
 1500009:	31 c0                	xor    %eax,%eax
  movl $PML_SIZE,%ecx  # moving these many words to the 11 pages
 150000b:	b9 00 2c 00 00       	mov    $0x2c00,%ecx
  rep stosl
 1500010:	f3 ab                	rep stos %eax,%es:(%rdi)

  # Creating a 4G boot page table...
  # Setting the 4-level page table with only the second entry needed (PML4).
  movl $pml4,%eax
 1500012:	b8 00 10 50 01       	mov    $0x1501000,%eax
  movl $pdpt1, %ebx
 1500017:	bb 00 20 50 01       	mov    $0x1502000,%ebx
  orl $PTE_P,%ebx
 150001c:	83 cb 01             	or     $0x1,%ebx
  orl $PTE_W,%ebx
 150001f:	83 cb 02             	or     $0x2,%ebx
  movl %ebx,(%eax)
 1500022:	67 89 18             	mov    %ebx,(%eax)

  movl $pdpt2, %ebx
 1500025:	bb 00 30 50 01       	mov    $0x1503000,%ebx
  orl $PTE_P,%ebx
 150002a:	83 cb 01             	or     $0x1,%ebx
  orl $PTE_W,%ebx
 150002d:	83 cb 02             	or     $0x2,%ebx
  movl %ebx,0x8(%eax)
 1500030:	67 89 58 08          	mov    %ebx,0x8(%eax)

  # Setting the 3rd level page table (PDPE).
  # 4 entries (counter in ecx), point to the next four physical pages (pgdirs).
  # pgdirs in 0xa0000--0xd000.
  movl $pdpt1,%edi
 1500034:	bf 00 20 50 01       	mov    $0x1502000,%edi
  movl $pde1,%ebx
 1500039:	bb 00 40 50 01       	mov    $0x1504000,%ebx
  orl $PTE_P,%ebx
 150003e:	83 cb 01             	or     $0x1,%ebx
  orl $PTE_W,%ebx
 1500041:	83 cb 02             	or     $0x2,%ebx
  movl %ebx,(%edi)
 1500044:	67 89 1f             	mov    %ebx,(%edi)

  movl $pdpt2,%edi
 1500047:	bf 00 30 50 01       	mov    $0x1503000,%edi
  movl $pde2,%ebx
 150004c:	bb 00 50 50 01       	mov    $0x1505000,%ebx
  orl $PTE_P,%ebx
 1500051:	83 cb 01             	or     $0x1,%ebx
  orl $PTE_W,%ebx
 1500054:	83 cb 02             	or     $0x2,%ebx
  # 2nd entry - 0x8040000000
  movl %ebx,0x8(%edi)
 1500057:	67 89 5f 08          	mov    %ebx,0x8(%edi)

  # Setting the pgdir so that the LA=PA.
  # Mapping first 1024mb of mem at KERNBASE.
  movl $512,%ecx
 150005b:	b9 00 02 00 00       	mov    $0x200,%ecx
  # Start at the end and work backwards
  movl $pde1,%edi
 1500060:	bf 00 40 50 01       	mov    $0x1504000,%edi
  movl $pde2,%ebx
 1500065:	bb 00 50 50 01       	mov    $0x1505000,%ebx
  # 1st entry - 0x8040000000

  # PTE_P|PTE_W|PTE_MBZ
  movl $0x00000183,%eax
 150006a:	b8 83 01 00 00       	mov    $0x183,%eax
1:
  movl %eax,(%edi)
 150006f:	67 89 07             	mov    %eax,(%edi)
  movl %eax,(%ebx)
 1500072:	67 89 03             	mov    %eax,(%ebx)
  addl $0x8,%edi
 1500075:	83 c7 08             	add    $0x8,%edi
  addl $0x8,%ebx
 1500078:	83 c3 08             	add    $0x8,%ebx
  addl $0x00200000,%eax
 150007b:	05 00 00 20 00       	add    $0x200000,%eax
  subl $1,%ecx
 1500080:	83 e9 01             	sub    $0x1,%ecx
  cmp $0x0,%ecx
 1500083:	83 f9 00             	cmp    $0x0,%ecx
  jne 1b
 1500086:	75 e7                	jne    150006f <_head64+0x6f>

  # Update CR3 register.
  movq $pml4,%rax
 1500088:	48 c7 c0 00 10 50 01 	mov    $0x1501000,%rax
  movq %rax, %cr3
 150008f:	0f 22 d8             	mov    %rax,%cr3

  # Transition to high mem entry code and pass LoadParams address.
  movabs $entry,%rax
 1500092:	48 b8 00 00 60 41 80 	movabs $0x8041600000,%rax
 1500099:	00 00 00 
  movq %r12, %rcx
 150009c:	4c 89 e1             	mov    %r12,%rcx
  jmpq *%rax
 150009f:	ff e0                	jmpq   *%rax
 15000a1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000a8:	00 00 00 
 15000ab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000b2:	00 00 00 
 15000b5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000bc:	00 00 00 
 15000bf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000c6:	00 00 00 
 15000c9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000d0:	00 00 00 
 15000d3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000da:	00 00 00 
 15000dd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000e4:	00 00 00 
 15000e7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000ee:	00 00 00 
 15000f1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15000f8:	00 00 00 
 15000fb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500102:	00 00 00 
 1500105:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150010c:	00 00 00 
 150010f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500116:	00 00 00 
 1500119:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500120:	00 00 00 
 1500123:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150012a:	00 00 00 
 150012d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500134:	00 00 00 
 1500137:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150013e:	00 00 00 
 1500141:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500148:	00 00 00 
 150014b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500152:	00 00 00 
 1500155:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150015c:	00 00 00 
 150015f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500166:	00 00 00 
 1500169:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500170:	00 00 00 
 1500173:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150017a:	00 00 00 
 150017d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500184:	00 00 00 
 1500187:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150018e:	00 00 00 
 1500191:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500198:	00 00 00 
 150019b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001a2:	00 00 00 
 15001a5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001ac:	00 00 00 
 15001af:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001b6:	00 00 00 
 15001b9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001c0:	00 00 00 
 15001c3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001ca:	00 00 00 
 15001cd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001d4:	00 00 00 
 15001d7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001de:	00 00 00 
 15001e1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001e8:	00 00 00 
 15001eb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001f2:	00 00 00 
 15001f5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15001fc:	00 00 00 
 15001ff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500206:	00 00 00 
 1500209:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500210:	00 00 00 
 1500213:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150021a:	00 00 00 
 150021d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500224:	00 00 00 
 1500227:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150022e:	00 00 00 
 1500231:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500238:	00 00 00 
 150023b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500242:	00 00 00 
 1500245:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150024c:	00 00 00 
 150024f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500256:	00 00 00 
 1500259:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500260:	00 00 00 
 1500263:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150026a:	00 00 00 
 150026d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500274:	00 00 00 
 1500277:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150027e:	00 00 00 
 1500281:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500288:	00 00 00 
 150028b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500292:	00 00 00 
 1500295:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150029c:	00 00 00 
 150029f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002a6:	00 00 00 
 15002a9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002b0:	00 00 00 
 15002b3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002ba:	00 00 00 
 15002bd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002c4:	00 00 00 
 15002c7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002ce:	00 00 00 
 15002d1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002d8:	00 00 00 
 15002db:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002e2:	00 00 00 
 15002e5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002ec:	00 00 00 
 15002ef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15002f6:	00 00 00 
 15002f9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500300:	00 00 00 
 1500303:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150030a:	00 00 00 
 150030d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500314:	00 00 00 
 1500317:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150031e:	00 00 00 
 1500321:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500328:	00 00 00 
 150032b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500332:	00 00 00 
 1500335:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150033c:	00 00 00 
 150033f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500346:	00 00 00 
 1500349:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500350:	00 00 00 
 1500353:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150035a:	00 00 00 
 150035d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500364:	00 00 00 
 1500367:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150036e:	00 00 00 
 1500371:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500378:	00 00 00 
 150037b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500382:	00 00 00 
 1500385:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150038c:	00 00 00 
 150038f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500396:	00 00 00 
 1500399:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003a0:	00 00 00 
 15003a3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003aa:	00 00 00 
 15003ad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003b4:	00 00 00 
 15003b7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003be:	00 00 00 
 15003c1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003c8:	00 00 00 
 15003cb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003d2:	00 00 00 
 15003d5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003dc:	00 00 00 
 15003df:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003e6:	00 00 00 
 15003e9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003f0:	00 00 00 
 15003f3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15003fa:	00 00 00 
 15003fd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500404:	00 00 00 
 1500407:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150040e:	00 00 00 
 1500411:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500418:	00 00 00 
 150041b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500422:	00 00 00 
 1500425:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150042c:	00 00 00 
 150042f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500436:	00 00 00 
 1500439:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500440:	00 00 00 
 1500443:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150044a:	00 00 00 
 150044d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500454:	00 00 00 
 1500457:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150045e:	00 00 00 
 1500461:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500468:	00 00 00 
 150046b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500472:	00 00 00 
 1500475:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150047c:	00 00 00 
 150047f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500486:	00 00 00 
 1500489:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500490:	00 00 00 
 1500493:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150049a:	00 00 00 
 150049d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004a4:	00 00 00 
 15004a7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004ae:	00 00 00 
 15004b1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004b8:	00 00 00 
 15004bb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004c2:	00 00 00 
 15004c5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004cc:	00 00 00 
 15004cf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004d6:	00 00 00 
 15004d9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004e0:	00 00 00 
 15004e3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004ea:	00 00 00 
 15004ed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004f4:	00 00 00 
 15004f7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15004fe:	00 00 00 
 1500501:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500508:	00 00 00 
 150050b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500512:	00 00 00 
 1500515:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150051c:	00 00 00 
 150051f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500526:	00 00 00 
 1500529:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500530:	00 00 00 
 1500533:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150053a:	00 00 00 
 150053d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500544:	00 00 00 
 1500547:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150054e:	00 00 00 
 1500551:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500558:	00 00 00 
 150055b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500562:	00 00 00 
 1500565:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150056c:	00 00 00 
 150056f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500576:	00 00 00 
 1500579:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500580:	00 00 00 
 1500583:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150058a:	00 00 00 
 150058d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500594:	00 00 00 
 1500597:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150059e:	00 00 00 
 15005a1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005a8:	00 00 00 
 15005ab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005b2:	00 00 00 
 15005b5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005bc:	00 00 00 
 15005bf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005c6:	00 00 00 
 15005c9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005d0:	00 00 00 
 15005d3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005da:	00 00 00 
 15005dd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005e4:	00 00 00 
 15005e7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005ee:	00 00 00 
 15005f1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15005f8:	00 00 00 
 15005fb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500602:	00 00 00 
 1500605:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150060c:	00 00 00 
 150060f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500616:	00 00 00 
 1500619:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500620:	00 00 00 
 1500623:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150062a:	00 00 00 
 150062d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500634:	00 00 00 
 1500637:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150063e:	00 00 00 
 1500641:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500648:	00 00 00 
 150064b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500652:	00 00 00 
 1500655:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150065c:	00 00 00 
 150065f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500666:	00 00 00 
 1500669:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500670:	00 00 00 
 1500673:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150067a:	00 00 00 
 150067d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500684:	00 00 00 
 1500687:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150068e:	00 00 00 
 1500691:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500698:	00 00 00 
 150069b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006a2:	00 00 00 
 15006a5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006ac:	00 00 00 
 15006af:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006b6:	00 00 00 
 15006b9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006c0:	00 00 00 
 15006c3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006ca:	00 00 00 
 15006cd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006d4:	00 00 00 
 15006d7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006de:	00 00 00 
 15006e1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006e8:	00 00 00 
 15006eb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006f2:	00 00 00 
 15006f5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15006fc:	00 00 00 
 15006ff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500706:	00 00 00 
 1500709:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500710:	00 00 00 
 1500713:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150071a:	00 00 00 
 150071d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500724:	00 00 00 
 1500727:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150072e:	00 00 00 
 1500731:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500738:	00 00 00 
 150073b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500742:	00 00 00 
 1500745:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150074c:	00 00 00 
 150074f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500756:	00 00 00 
 1500759:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500760:	00 00 00 
 1500763:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150076a:	00 00 00 
 150076d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500774:	00 00 00 
 1500777:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150077e:	00 00 00 
 1500781:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500788:	00 00 00 
 150078b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500792:	00 00 00 
 1500795:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150079c:	00 00 00 
 150079f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007a6:	00 00 00 
 15007a9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007b0:	00 00 00 
 15007b3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007ba:	00 00 00 
 15007bd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007c4:	00 00 00 
 15007c7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007ce:	00 00 00 
 15007d1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007d8:	00 00 00 
 15007db:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007e2:	00 00 00 
 15007e5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007ec:	00 00 00 
 15007ef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15007f6:	00 00 00 
 15007f9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500800:	00 00 00 
 1500803:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150080a:	00 00 00 
 150080d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500814:	00 00 00 
 1500817:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150081e:	00 00 00 
 1500821:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500828:	00 00 00 
 150082b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500832:	00 00 00 
 1500835:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150083c:	00 00 00 
 150083f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500846:	00 00 00 
 1500849:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500850:	00 00 00 
 1500853:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150085a:	00 00 00 
 150085d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500864:	00 00 00 
 1500867:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150086e:	00 00 00 
 1500871:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500878:	00 00 00 
 150087b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500882:	00 00 00 
 1500885:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150088c:	00 00 00 
 150088f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500896:	00 00 00 
 1500899:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008a0:	00 00 00 
 15008a3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008aa:	00 00 00 
 15008ad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008b4:	00 00 00 
 15008b7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008be:	00 00 00 
 15008c1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008c8:	00 00 00 
 15008cb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008d2:	00 00 00 
 15008d5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008dc:	00 00 00 
 15008df:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008e6:	00 00 00 
 15008e9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008f0:	00 00 00 
 15008f3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15008fa:	00 00 00 
 15008fd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500904:	00 00 00 
 1500907:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150090e:	00 00 00 
 1500911:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500918:	00 00 00 
 150091b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500922:	00 00 00 
 1500925:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150092c:	00 00 00 
 150092f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500936:	00 00 00 
 1500939:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500940:	00 00 00 
 1500943:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150094a:	00 00 00 
 150094d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500954:	00 00 00 
 1500957:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150095e:	00 00 00 
 1500961:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500968:	00 00 00 
 150096b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500972:	00 00 00 
 1500975:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150097c:	00 00 00 
 150097f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500986:	00 00 00 
 1500989:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500990:	00 00 00 
 1500993:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 150099a:	00 00 00 
 150099d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009a4:	00 00 00 
 15009a7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009ae:	00 00 00 
 15009b1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009b8:	00 00 00 
 15009bb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009c2:	00 00 00 
 15009c5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009cc:	00 00 00 
 15009cf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009d6:	00 00 00 
 15009d9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009e0:	00 00 00 
 15009e3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009ea:	00 00 00 
 15009ed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009f4:	00 00 00 
 15009f7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 15009fe:	00 00 00 
 1500a01:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a08:	00 00 00 
 1500a0b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a12:	00 00 00 
 1500a15:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a1c:	00 00 00 
 1500a1f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a26:	00 00 00 
 1500a29:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a30:	00 00 00 
 1500a33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a3a:	00 00 00 
 1500a3d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a44:	00 00 00 
 1500a47:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a4e:	00 00 00 
 1500a51:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a58:	00 00 00 
 1500a5b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a62:	00 00 00 
 1500a65:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a6c:	00 00 00 
 1500a6f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a76:	00 00 00 
 1500a79:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a80:	00 00 00 
 1500a83:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a8a:	00 00 00 
 1500a8d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a94:	00 00 00 
 1500a97:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500a9e:	00 00 00 
 1500aa1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500aa8:	00 00 00 
 1500aab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ab2:	00 00 00 
 1500ab5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500abc:	00 00 00 
 1500abf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ac6:	00 00 00 
 1500ac9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ad0:	00 00 00 
 1500ad3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ada:	00 00 00 
 1500add:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ae4:	00 00 00 
 1500ae7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500aee:	00 00 00 
 1500af1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500af8:	00 00 00 
 1500afb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b02:	00 00 00 
 1500b05:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b0c:	00 00 00 
 1500b0f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b16:	00 00 00 
 1500b19:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b20:	00 00 00 
 1500b23:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b2a:	00 00 00 
 1500b2d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b34:	00 00 00 
 1500b37:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b3e:	00 00 00 
 1500b41:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b48:	00 00 00 
 1500b4b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b52:	00 00 00 
 1500b55:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b5c:	00 00 00 
 1500b5f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b66:	00 00 00 
 1500b69:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b70:	00 00 00 
 1500b73:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b7a:	00 00 00 
 1500b7d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b84:	00 00 00 
 1500b87:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b8e:	00 00 00 
 1500b91:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500b98:	00 00 00 
 1500b9b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ba2:	00 00 00 
 1500ba5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bac:	00 00 00 
 1500baf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bb6:	00 00 00 
 1500bb9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bc0:	00 00 00 
 1500bc3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bca:	00 00 00 
 1500bcd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bd4:	00 00 00 
 1500bd7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bde:	00 00 00 
 1500be1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500be8:	00 00 00 
 1500beb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bf2:	00 00 00 
 1500bf5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500bfc:	00 00 00 
 1500bff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c06:	00 00 00 
 1500c09:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c10:	00 00 00 
 1500c13:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c1a:	00 00 00 
 1500c1d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c24:	00 00 00 
 1500c27:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c2e:	00 00 00 
 1500c31:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c38:	00 00 00 
 1500c3b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c42:	00 00 00 
 1500c45:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c4c:	00 00 00 
 1500c4f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c56:	00 00 00 
 1500c59:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c60:	00 00 00 
 1500c63:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c6a:	00 00 00 
 1500c6d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c74:	00 00 00 
 1500c77:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c7e:	00 00 00 
 1500c81:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c88:	00 00 00 
 1500c8b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c92:	00 00 00 
 1500c95:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500c9c:	00 00 00 
 1500c9f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ca6:	00 00 00 
 1500ca9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cb0:	00 00 00 
 1500cb3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cba:	00 00 00 
 1500cbd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cc4:	00 00 00 
 1500cc7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cce:	00 00 00 
 1500cd1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cd8:	00 00 00 
 1500cdb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ce2:	00 00 00 
 1500ce5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cec:	00 00 00 
 1500cef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500cf6:	00 00 00 
 1500cf9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d00:	00 00 00 
 1500d03:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d0a:	00 00 00 
 1500d0d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d14:	00 00 00 
 1500d17:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d1e:	00 00 00 
 1500d21:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d28:	00 00 00 
 1500d2b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d32:	00 00 00 
 1500d35:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d3c:	00 00 00 
 1500d3f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d46:	00 00 00 
 1500d49:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d50:	00 00 00 
 1500d53:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d5a:	00 00 00 
 1500d5d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d64:	00 00 00 
 1500d67:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d6e:	00 00 00 
 1500d71:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d78:	00 00 00 
 1500d7b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d82:	00 00 00 
 1500d85:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d8c:	00 00 00 
 1500d8f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500d96:	00 00 00 
 1500d99:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500da0:	00 00 00 
 1500da3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500daa:	00 00 00 
 1500dad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500db4:	00 00 00 
 1500db7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500dbe:	00 00 00 
 1500dc1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500dc8:	00 00 00 
 1500dcb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500dd2:	00 00 00 
 1500dd5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ddc:	00 00 00 
 1500ddf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500de6:	00 00 00 
 1500de9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500df0:	00 00 00 
 1500df3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500dfa:	00 00 00 
 1500dfd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e04:	00 00 00 
 1500e07:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e0e:	00 00 00 
 1500e11:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e18:	00 00 00 
 1500e1b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e22:	00 00 00 
 1500e25:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e2c:	00 00 00 
 1500e2f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e36:	00 00 00 
 1500e39:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e40:	00 00 00 
 1500e43:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e4a:	00 00 00 
 1500e4d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e54:	00 00 00 
 1500e57:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e5e:	00 00 00 
 1500e61:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e68:	00 00 00 
 1500e6b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e72:	00 00 00 
 1500e75:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e7c:	00 00 00 
 1500e7f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e86:	00 00 00 
 1500e89:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e90:	00 00 00 
 1500e93:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500e9a:	00 00 00 
 1500e9d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ea4:	00 00 00 
 1500ea7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500eae:	00 00 00 
 1500eb1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500eb8:	00 00 00 
 1500ebb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ec2:	00 00 00 
 1500ec5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ecc:	00 00 00 
 1500ecf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ed6:	00 00 00 
 1500ed9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ee0:	00 00 00 
 1500ee3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500eea:	00 00 00 
 1500eed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ef4:	00 00 00 
 1500ef7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500efe:	00 00 00 
 1500f01:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f08:	00 00 00 
 1500f0b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f12:	00 00 00 
 1500f15:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f1c:	00 00 00 
 1500f1f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f26:	00 00 00 
 1500f29:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f30:	00 00 00 
 1500f33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f3a:	00 00 00 
 1500f3d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f44:	00 00 00 
 1500f47:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f4e:	00 00 00 
 1500f51:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f58:	00 00 00 
 1500f5b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f62:	00 00 00 
 1500f65:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f6c:	00 00 00 
 1500f6f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f76:	00 00 00 
 1500f79:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f80:	00 00 00 
 1500f83:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f8a:	00 00 00 
 1500f8d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f94:	00 00 00 
 1500f97:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500f9e:	00 00 00 
 1500fa1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fa8:	00 00 00 
 1500fab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fb2:	00 00 00 
 1500fb5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fbc:	00 00 00 
 1500fbf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fc6:	00 00 00 
 1500fc9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fd0:	00 00 00 
 1500fd3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fda:	00 00 00 
 1500fdd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fe4:	00 00 00 
 1500fe7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500fee:	00 00 00 
 1500ff1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 1500ff8:	00 00 00 
 1500ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000001501000 <pml4phys>:
	...

0000000001502000 <pdpt1>:
	...

0000000001503000 <pdpt2>:
	...

0000000001504000 <pde1>:
	...

0000000001505000 <pde2>:
	...

0000000001506000 <pdefreestart>:
	...

Disassembly of section .text:

0000008041600000 <__text_start>:
.text

.globl entry
entry:
  # Save LoadParams in uefi_lp.
  movq %rcx, uefi_lp(%rip)
  8041600000:	48 89 0d f9 7f 01 00 	mov    %rcx,0x17ff9(%rip)        # 8041618000 <bootstacktop>

  # Set the stack pointer.
  leaq bootstacktop(%rip),%rsp
  8041600007:	48 8d 25 f2 7f 01 00 	lea    0x17ff2(%rip),%rsp        # 8041618000 <bootstacktop>

  # Clear the frame pointer register (RBP)
  # so that once we get into debugging C code,
  # stack backtraces will be terminated properly.
  xorq %rbp, %rbp      # nuke frame pointer
  804160000e:	48 31 ed             	xor    %rbp,%rbp

  # now to C code
  call i386_init
  8041600011:	e8 f8 01 00 00       	callq  804160020e <i386_init>

0000008041600016 <spin>:

  # Should never get here, but in case we do, just spin.
spin:  jmp  spin
  8041600016:	eb fe                	jmp    8041600016 <spin>

0000008041600018 <_generall_syscall>:
.comm rbp_reg, 8
.comm rsp_reg, 8
.comm _g_ret,  8

_generall_syscall:
  cli
  8041600018:	fa                   	cli    
  popq _g_ret(%rip)
  8041600019:	8f 05 21 47 02 00    	popq   0x24721(%rip)        # 8041624740 <_g_ret>
  popq ret_rip(%rip)
  804160001f:	8f 05 2b 47 02 00    	popq   0x2472b(%rip)        # 8041624750 <ret_rip>
  movq %rbp, rbp_reg(%rip)
  8041600025:	48 89 2d 1c 47 02 00 	mov    %rbp,0x2471c(%rip)        # 8041624748 <rbp_reg>
  movq %rsp, rsp_reg(%rip)
  804160002c:	48 89 25 25 47 02 00 	mov    %rsp,0x24725(%rip)        # 8041624758 <rsp_reg>
  movq $0x0,%rbp
  8041600033:	48 c7 c5 00 00 00 00 	mov    $0x0,%rbp
  leaq bootstacktop(%rip),%rsp
  804160003a:	48 8d 25 bf 7f 01 00 	lea    0x17fbf(%rip),%rsp        # 8041618000 <bootstacktop>
  pushq $GD_KD
  8041600041:	6a 10                	pushq  $0x10
  pushq rsp_reg(%rip)
  8041600043:	ff 35 0f 47 02 00    	pushq  0x2470f(%rip)        # 8041624758 <rsp_reg>
  pushfq
  8041600049:	9c                   	pushfq 
  # Guard to avoid hard to debug errors due to cli misusage.
  orl $FL_IF, (%rsp)
  804160004a:	81 0c 24 00 02 00 00 	orl    $0x200,(%rsp)
  pushq $GD_KT
  8041600051:	6a 08                	pushq  $0x8
  pushq ret_rip(%rip)
  8041600053:	ff 35 f7 46 02 00    	pushq  0x246f7(%rip)        # 8041624750 <ret_rip>
  pushq $0x0
  8041600059:	6a 00                	pushq  $0x0
  pushq $0x0
  804160005b:	6a 00                	pushq  $0x0
  pushq $0x0 // %ds
  804160005d:	6a 00                	pushq  $0x0
  pushq $0x0 // %es
  804160005f:	6a 00                	pushq  $0x0
  pushq %rax
  8041600061:	50                   	push   %rax
  pushq %rbx
  8041600062:	53                   	push   %rbx
  pushq %rcx
  8041600063:	51                   	push   %rcx
  pushq %rdx
  8041600064:	52                   	push   %rdx
  pushq rbp_reg(%rip)
  8041600065:	ff 35 dd 46 02 00    	pushq  0x246dd(%rip)        # 8041624748 <rbp_reg>
  pushq %rdi
  804160006b:	57                   	push   %rdi
  pushq %rsi
  804160006c:	56                   	push   %rsi
  pushq %r8
  804160006d:	41 50                	push   %r8
  pushq %r9
  804160006f:	41 51                	push   %r9
  pushq %r10
  8041600071:	41 52                	push   %r10
  pushq %r11
  8041600073:	41 53                	push   %r11
  pushq %r12
  8041600075:	41 54                	push   %r12
  pushq %r13
  8041600077:	41 55                	push   %r13
  pushq %r14
  8041600079:	41 56                	push   %r14
  pushq %r15
  804160007b:	41 57                	push   %r15
  movq  %rsp, %rdi
  804160007d:	48 89 e7             	mov    %rsp,%rdi
  pushq _g_ret(%rip)
  8041600080:	ff 35 ba 46 02 00    	pushq  0x246ba(%rip)        # 8041624740 <_g_ret>
  ret
  8041600086:	c3                   	retq   

0000008041600087 <sys_yield>:

.globl sys_yield
.type  sys_yield, @function
sys_yield:
  call _generall_syscall
  8041600087:	e8 8c ff ff ff       	callq  8041600018 <_generall_syscall>
  call csys_yield
  804160008c:	e8 ce 41 00 00       	callq  804160425f <csys_yield>
  jmp .
  8041600091:	eb fe                	jmp    8041600091 <sys_yield+0xa>

0000008041600093 <sys_exit>:
# LAB 3: Your code here.
.globl sys_exit
.type  sys_exit, @function
sys_exit:
  # leap address in rsp
  leaq bootstacktop(%rip),%rsp  
  8041600093:	48 8d 25 66 7f 01 00 	lea    0x17f66(%rip),%rsp        # 8041618000 <bootstacktop>
  # register set 0 (xor), % - name of register  
  xor %ebp, %ebp                  
  804160009a:	31 ed                	xor    %ebp,%ebp
  call csys_exit
  804160009c:	e8 9f 41 00 00       	callq  8041604240 <csys_exit>
  jmp .
  80416000a1:	eb fe                	jmp    80416000a1 <sys_exit+0xe>

00000080416000a3 <alloc_pde_early_boot>:
#include <kern/trap.h>
#include <kern/sched.h>
#include <kern/cpu.h>

pde_t *
alloc_pde_early_boot(void) {
  80416000a3:	55                   	push   %rbp
  80416000a4:	48 89 e5             	mov    %rsp,%rbp
  //Assume pde1, pde2 is already used.
  extern uintptr_t pdefreestart, pdefreeend;
  pde_t *ret;
  static uintptr_t pdefree = (uintptr_t)&pdefreestart;

  if (pdefree >= (uintptr_t)&pdefreeend)
  80416000a7:	48 b8 08 80 61 41 80 	movabs $0x8041618008,%rax
  80416000ae:	00 00 00 
  80416000b1:	48 8b 10             	mov    (%rax),%rdx
  80416000b4:	48 b8 00 c0 50 01 00 	movabs $0x150c000,%rax
  80416000bb:	00 00 00 
  80416000be:	48 39 c2             	cmp    %rax,%rdx
  80416000c1:	73 1c                	jae    80416000df <alloc_pde_early_boot+0x3c>
    return NULL;

  ret = (pde_t *)pdefree;
  80416000c3:	48 89 d1             	mov    %rdx,%rcx
  pdefree += PGSIZE;
  80416000c6:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
  80416000cd:	48 89 d0             	mov    %rdx,%rax
  80416000d0:	48 a3 08 80 61 41 80 	movabs %rax,0x8041618008
  80416000d7:	00 00 00 
  return ret;
}
  80416000da:	48 89 c8             	mov    %rcx,%rax
  80416000dd:	5d                   	pop    %rbp
  80416000de:	c3                   	retq   
    return NULL;
  80416000df:	b9 00 00 00 00       	mov    $0x0,%ecx
  80416000e4:	eb f4                	jmp    80416000da <alloc_pde_early_boot+0x37>

00000080416000e6 <map_addr_early_boot>:

void
map_addr_early_boot(uintptr_t addr, uintptr_t addr_phys, size_t sz) {
  80416000e6:	55                   	push   %rbp
  80416000e7:	48 89 e5             	mov    %rsp,%rbp
  80416000ea:	41 57                	push   %r15
  80416000ec:	41 56                	push   %r14
  80416000ee:	41 55                	push   %r13
  80416000f0:	41 54                	push   %r12
  80416000f2:	53                   	push   %rbx
  80416000f3:	48 83 ec 10          	sub    $0x10,%rsp
  pml4e_t *pml4 = &pml4phys;
  pdpe_t *pdpt;
  pde_t *pde;

  uintptr_t addr_curr, addr_curr_phys, addr_end;
  addr_curr      = ROUNDDOWN(addr, PTSIZE);
  80416000f7:	49 89 ff             	mov    %rdi,%r15
  80416000fa:	49 81 e7 00 00 e0 ff 	and    $0xffffffffffe00000,%r15
  addr_curr_phys = ROUNDDOWN(addr_phys, PTSIZE);
  8041600101:	48 81 e6 00 00 e0 ff 	and    $0xffffffffffe00000,%rsi
  8041600108:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  addr_end       = ROUNDUP(addr + sz, PTSIZE);
  804160010c:	4c 8d b4 17 ff ff 1f 	lea    0x1fffff(%rdi,%rdx,1),%r14
  8041600113:	00 
  8041600114:	49 81 e6 00 00 e0 ff 	and    $0xffffffffffe00000,%r14

  pdpt = (pdpe_t *)PTE_ADDR(pml4[PML4(addr_curr)]);
  804160011b:	48 c1 ef 24          	shr    $0x24,%rdi
  804160011f:	81 e7 f8 0f 00 00    	and    $0xff8,%edi
  8041600125:	48 b8 00 10 50 01 00 	movabs $0x1501000,%rax
  804160012c:	00 00 00 
  804160012f:	48 8b 04 38          	mov    (%rax,%rdi,1),%rax
  8041600133:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041600139:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
  804160013d:	4d 39 fe             	cmp    %r15,%r14
  8041600140:	76 67                	jbe    80416001a9 <map_addr_early_boot+0xc3>
  addr_curr      = ROUNDDOWN(addr, PTSIZE);
  8041600142:	4d 89 fc             	mov    %r15,%r12
  8041600145:	eb 24                	jmp    804160016b <map_addr_early_boot+0x85>
    pde = (pde_t *)PTE_ADDR(pdpt[PDPE(addr_curr)]);
    if (!pde) {
      pde                   = alloc_pde_early_boot();
      pdpt[PDPE(addr_curr)] = ((uintptr_t)pde) | PTE_P | PTE_W;
    }
    pde[PDX(addr_curr)] = addr_curr_phys | PTE_P | PTE_W | PTE_MBZ;
  8041600147:	4c 89 e2             	mov    %r12,%rdx
  804160014a:	48 c1 ea 15          	shr    $0x15,%rdx
  804160014e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  8041600154:	49 81 cd 83 01 00 00 	or     $0x183,%r13
  804160015b:	4c 89 2c d0          	mov    %r13,(%rax,%rdx,8)
  for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
  804160015f:	49 81 c4 00 00 20 00 	add    $0x200000,%r12
  8041600166:	4d 39 e6             	cmp    %r12,%r14
  8041600169:	76 3e                	jbe    80416001a9 <map_addr_early_boot+0xc3>
  804160016b:	4c 8b 6d d0          	mov    -0x30(%rbp),%r13
  804160016f:	4d 29 fd             	sub    %r15,%r13
  8041600172:	4d 01 e5             	add    %r12,%r13
    pde = (pde_t *)PTE_ADDR(pdpt[PDPE(addr_curr)]);
  8041600175:	4c 89 e3             	mov    %r12,%rbx
  8041600178:	48 c1 eb 1b          	shr    $0x1b,%rbx
  804160017c:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
  8041600182:	48 03 5d c8          	add    -0x38(%rbp),%rbx
    if (!pde) {
  8041600186:	48 8b 03             	mov    (%rbx),%rax
  8041600189:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804160018f:	75 b6                	jne    8041600147 <map_addr_early_boot+0x61>
      pde                   = alloc_pde_early_boot();
  8041600191:	48 b8 a3 00 60 41 80 	movabs $0x80416000a3,%rax
  8041600198:	00 00 00 
  804160019b:	ff d0                	callq  *%rax
      pdpt[PDPE(addr_curr)] = ((uintptr_t)pde) | PTE_P | PTE_W;
  804160019d:	48 89 c2             	mov    %rax,%rdx
  80416001a0:	48 83 ca 03          	or     $0x3,%rdx
  80416001a4:	48 89 13             	mov    %rdx,(%rbx)
  80416001a7:	eb 9e                	jmp    8041600147 <map_addr_early_boot+0x61>
  }
}
  80416001a9:	48 83 c4 10          	add    $0x10,%rsp
  80416001ad:	5b                   	pop    %rbx
  80416001ae:	41 5c                	pop    %r12
  80416001b0:	41 5d                	pop    %r13
  80416001b2:	41 5e                	pop    %r14
  80416001b4:	41 5f                	pop    %r15
  80416001b6:	5d                   	pop    %rbp
  80416001b7:	c3                   	retq   

00000080416001b8 <early_boot_pml4_init>:
// Additionally maps pml4 memory so that we dont get memory errors on accessing
// uefi_lp, MemMap, KASAN functions.
void
early_boot_pml4_init(void) {
  80416001b8:	55                   	push   %rbp
  80416001b9:	48 89 e5             	mov    %rsp,%rbp
  80416001bc:	41 54                	push   %r12
  80416001be:	53                   	push   %rbx

  map_addr_early_boot((uintptr_t)uefi_lp, (uintptr_t)uefi_lp, sizeof(LOADER_PARAMS));
  80416001bf:	49 bc 00 80 61 41 80 	movabs $0x8041618000,%r12
  80416001c6:	00 00 00 
  80416001c9:	49 8b 3c 24          	mov    (%r12),%rdi
  80416001cd:	ba c8 00 00 00       	mov    $0xc8,%edx
  80416001d2:	48 89 fe             	mov    %rdi,%rsi
  80416001d5:	48 bb e6 00 60 41 80 	movabs $0x80416000e6,%rbx
  80416001dc:	00 00 00 
  80416001df:	ff d3                	callq  *%rbx
  map_addr_early_boot((uintptr_t)uefi_lp->MemoryMap, (uintptr_t)uefi_lp->MemoryMap, uefi_lp->MemoryMapSize);
  80416001e1:	49 8b 04 24          	mov    (%r12),%rax
  80416001e5:	48 8b 78 28          	mov    0x28(%rax),%rdi
  80416001e9:	48 8b 50 38          	mov    0x38(%rax),%rdx
  80416001ed:	48 89 fe             	mov    %rdi,%rsi
  80416001f0:	ff d3                	callq  *%rbx

#ifdef SANITIZE_SHADOW_BASE
  map_addr_early_boot(SANITIZE_SHADOW_BASE, SANITIZE_SHADOW_BASE - KERNBASE, SANITIZE_SHADOW_SIZE);
#endif

  map_addr_early_boot(FBUFFBASE, uefi_lp->FrameBufferBase, uefi_lp->FrameBufferSize);
  80416001f2:	49 8b 04 24          	mov    (%r12),%rax
  80416001f6:	8b 50 48             	mov    0x48(%rax),%edx
  80416001f9:	48 8b 70 40          	mov    0x40(%rax),%rsi
  80416001fd:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600204:	00 00 00 
  8041600207:	ff d3                	callq  *%rbx
}
  8041600209:	5b                   	pop    %rbx
  804160020a:	41 5c                	pop    %r12
  804160020c:	5d                   	pop    %rbp
  804160020d:	c3                   	retq   

000000804160020e <i386_init>:

void
i386_init(void) {
  804160020e:	55                   	push   %rbp
  804160020f:	48 89 e5             	mov    %rsp,%rbp
  8041600212:	41 54                	push   %r12
  8041600214:	53                   	push   %rbx
  extern char end[];

  early_boot_pml4_init();
  8041600215:	48 b8 b8 01 60 41 80 	movabs $0x80416001b8,%rax
  804160021c:	00 00 00 
  804160021f:	ff d0                	callq  *%rax

  // Initialize the console.
  // Can't call cprintf until after we do this!
  cons_init();
  8041600221:	48 b8 0e 0b 60 41 80 	movabs $0x8041600b0e,%rax
  8041600228:	00 00 00 
  804160022b:	ff d0                	callq  *%rax

  cprintf("6828 decimal is %o octal!\n", 6828);
  804160022d:	be ac 1a 00 00       	mov    $0x1aac,%esi
  8041600232:	48 bf c0 63 60 41 80 	movabs $0x80416063c0,%rdi
  8041600239:	00 00 00 
  804160023c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600241:	48 bb 49 44 60 41 80 	movabs $0x8041604449,%rbx
  8041600248:	00 00 00 
  804160024b:	ff d3                	callq  *%rbx
  cprintf("END: %p\n", end);
  804160024d:	48 be 00 70 62 41 80 	movabs $0x8041627000,%rsi
  8041600254:	00 00 00 
  8041600257:	48 bf db 63 60 41 80 	movabs $0x80416063db,%rdi
  804160025e:	00 00 00 
  8041600261:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600266:	ff d3                	callq  *%rbx
  // Perform global constructor initialisation (e.g. asan)
  // This must be done as early as possible
  extern void (*__ctors_start)();
  extern void (*__ctors_end)();
  void (**ctor)() = &__ctors_start;
  while (ctor < &__ctors_end) {
  8041600268:	48 ba b8 40 62 41 80 	movabs $0x80416240b8,%rdx
  804160026f:	00 00 00 
  8041600272:	48 b8 b8 40 62 41 80 	movabs $0x80416240b8,%rax
  8041600279:	00 00 00 
  804160027c:	48 39 c2             	cmp    %rax,%rdx
  804160027f:	73 28                	jae    80416002a9 <i386_init+0x9b>
  8041600281:	48 8d 40 07          	lea    0x7(%rax),%rax
  8041600285:	48 8d 52 08          	lea    0x8(%rdx),%rdx
  8041600289:	48 29 d0             	sub    %rdx,%rax
  804160028c:	48 c1 e8 03          	shr    $0x3,%rax
  8041600290:	48 8d 5a f8          	lea    -0x8(%rdx),%rbx
  8041600294:	4c 8d 64 c3 08       	lea    0x8(%rbx,%rax,8),%r12
    (*ctor)();
  8041600299:	b8 00 00 00 00       	mov    $0x0,%eax
  804160029e:	ff 13                	callq  *(%rbx)
    ctor++;
  80416002a0:	48 83 c3 08          	add    $0x8,%rbx
  while (ctor < &__ctors_end) {
  80416002a4:	4c 39 e3             	cmp    %r12,%rbx
  80416002a7:	75 f0                	jne    8041600299 <i386_init+0x8b>
  }

  // Framebuffer init should be done after memory init.
  fb_init();
  80416002a9:	48 b8 01 0a 60 41 80 	movabs $0x8041600a01,%rax
  80416002b0:	00 00 00 
  80416002b3:	ff d0                	callq  *%rax
  cprintf("Framebuffer initialised\n");
  80416002b5:	48 bf e4 63 60 41 80 	movabs $0x80416063e4,%rdi
  80416002bc:	00 00 00 
  80416002bf:	b8 00 00 00 00       	mov    $0x0,%eax
  80416002c4:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416002cb:	00 00 00 
  80416002ce:	ff d2                	callq  *%rdx

  // user environment initialization functions
  env_init();
  80416002d0:	48 b8 33 3d 60 41 80 	movabs $0x8041603d33,%rax
  80416002d7:	00 00 00 
  80416002da:	ff d0                	callq  *%rax

#ifdef CONFIG_KSPACE
  // Touch all you want.
  ENV_CREATE_KERNEL_TYPE(prog_test1);
  80416002dc:	be 01 00 00 00       	mov    $0x1,%esi
  80416002e1:	48 bf 90 87 61 41 80 	movabs $0x8041618790,%rdi
  80416002e8:	00 00 00 
  80416002eb:	48 bb 0b 3f 60 41 80 	movabs $0x8041603f0b,%rbx
  80416002f2:	00 00 00 
  80416002f5:	ff d3                	callq  *%rbx
  ENV_CREATE_KERNEL_TYPE(prog_test2);
  80416002f7:	be 01 00 00 00       	mov    $0x1,%esi
  80416002fc:	48 bf 30 c4 61 41 80 	movabs $0x804161c430,%rdi
  8041600303:	00 00 00 
  8041600306:	ff d3                	callq  *%rbx
  ENV_CREATE_KERNEL_TYPE(prog_test3);
  8041600308:	be 01 00 00 00       	mov    $0x1,%esi
  804160030d:	48 bf 20 04 62 41 80 	movabs $0x8041620420,%rdi
  8041600314:	00 00 00 
  8041600317:	ff d3                	callq  *%rbx
#endif

  // Schedule and run the first user environment!
  sched_yield();
  8041600319:	48 b8 80 45 60 41 80 	movabs $0x8041604580,%rax
  8041600320:	00 00 00 
  8041600323:	ff d0                	callq  *%rax

0000008041600325 <_panic>:
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8041600325:	55                   	push   %rbp
  8041600326:	48 89 e5             	mov    %rsp,%rbp
  8041600329:	41 54                	push   %r12
  804160032b:	53                   	push   %rbx
  804160032c:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8041600333:	49 89 d4             	mov    %rdx,%r12
  8041600336:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804160033d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8041600344:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804160034b:	84 c0                	test   %al,%al
  804160034d:	74 23                	je     8041600372 <_panic+0x4d>
  804160034f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8041600356:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804160035a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804160035e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8041600362:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8041600366:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804160036a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804160036e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  va_list ap;

  if (panicstr)
  8041600372:	48 b8 c0 40 62 41 80 	movabs $0x80416240c0,%rax
  8041600379:	00 00 00 
  804160037c:	48 83 38 00          	cmpq   $0x0,(%rax)
  8041600380:	74 13                	je     8041600395 <_panic+0x70>
  va_end(ap);

dead:
  /* break into the kernel monitor */
  while (1)
    monitor(NULL);
  8041600382:	48 bb d3 3a 60 41 80 	movabs $0x8041603ad3,%rbx
  8041600389:	00 00 00 
  804160038c:	bf 00 00 00 00       	mov    $0x0,%edi
  8041600391:	ff d3                	callq  *%rbx
  8041600393:	eb f7                	jmp    804160038c <_panic+0x67>
  panicstr = fmt;
  8041600395:	4c 89 e0             	mov    %r12,%rax
  8041600398:	48 a3 c0 40 62 41 80 	movabs %rax,0x80416240c0
  804160039f:	00 00 00 
  __asm __volatile("cli; cld");
  80416003a2:	fa                   	cli    
  80416003a3:	fc                   	cld    
  va_start(ap, fmt);
  80416003a4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80416003ab:	00 00 00 
  80416003ae:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80416003b5:	00 00 00 
  80416003b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80416003bc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80416003c3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80416003ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  cprintf("kernel panic at %s:%d: ", file, line);
  80416003d1:	89 f2                	mov    %esi,%edx
  80416003d3:	48 89 fe             	mov    %rdi,%rsi
  80416003d6:	48 bf fd 63 60 41 80 	movabs $0x80416063fd,%rdi
  80416003dd:	00 00 00 
  80416003e0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416003e5:	48 bb 49 44 60 41 80 	movabs $0x8041604449,%rbx
  80416003ec:	00 00 00 
  80416003ef:	ff d3                	callq  *%rbx
  vcprintf(fmt, ap);
  80416003f1:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  80416003f8:	4c 89 e7             	mov    %r12,%rdi
  80416003fb:	48 b8 15 44 60 41 80 	movabs $0x8041604415,%rax
  8041600402:	00 00 00 
  8041600405:	ff d0                	callq  *%rax
  cprintf("\n");
  8041600407:	48 bf 39 64 60 41 80 	movabs $0x8041606439,%rdi
  804160040e:	00 00 00 
  8041600411:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600416:	ff d3                	callq  *%rbx
  8041600418:	e9 65 ff ff ff       	jmpq   8041600382 <_panic+0x5d>

000000804160041d <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...) {
  804160041d:	55                   	push   %rbp
  804160041e:	48 89 e5             	mov    %rsp,%rbp
  8041600421:	41 54                	push   %r12
  8041600423:	53                   	push   %rbx
  8041600424:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  804160042b:	49 89 d4             	mov    %rdx,%r12
  804160042e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8041600435:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804160043c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8041600443:	84 c0                	test   %al,%al
  8041600445:	74 23                	je     804160046a <_warn+0x4d>
  8041600447:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804160044e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8041600452:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8041600456:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804160045a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804160045e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8041600462:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8041600466:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  va_list ap;

  va_start(ap, fmt);
  804160046a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8041600471:	00 00 00 
  8041600474:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804160047b:	00 00 00 
  804160047e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041600482:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8041600489:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8041600490:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  cprintf("kernel warning at %s:%d: ", file, line);
  8041600497:	89 f2                	mov    %esi,%edx
  8041600499:	48 89 fe             	mov    %rdi,%rsi
  804160049c:	48 bf 15 64 60 41 80 	movabs $0x8041606415,%rdi
  80416004a3:	00 00 00 
  80416004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  80416004ab:	48 bb 49 44 60 41 80 	movabs $0x8041604449,%rbx
  80416004b2:	00 00 00 
  80416004b5:	ff d3                	callq  *%rbx
  vcprintf(fmt, ap);
  80416004b7:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  80416004be:	4c 89 e7             	mov    %r12,%rdi
  80416004c1:	48 b8 15 44 60 41 80 	movabs $0x8041604415,%rax
  80416004c8:	00 00 00 
  80416004cb:	ff d0                	callq  *%rax
  cprintf("\n");
  80416004cd:	48 bf 39 64 60 41 80 	movabs $0x8041606439,%rdi
  80416004d4:	00 00 00 
  80416004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  80416004dc:	ff d3                	callq  *%rbx
  va_end(ap);
}
  80416004de:	48 81 c4 d0 00 00 00 	add    $0xd0,%rsp
  80416004e5:	5b                   	pop    %rbx
  80416004e6:	41 5c                	pop    %r12
  80416004e8:	5d                   	pop    %rbp
  80416004e9:	c3                   	retq   

00000080416004ea <serial_proc_data>:
    }
  }
}

static int
serial_proc_data(void) {
  80416004ea:	55                   	push   %rbp
  80416004eb:	48 89 e5             	mov    %rsp,%rbp
}

static __inline uint8_t
inb(int port) {
  uint8_t data;
  __asm __volatile("inb %w1,%0"
  80416004ee:	ba fd 03 00 00       	mov    $0x3fd,%edx
  80416004f3:	ec                   	in     (%dx),%al
  if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
  80416004f4:	a8 01                	test   $0x1,%al
  80416004f6:	74 0b                	je     8041600503 <serial_proc_data+0x19>
  80416004f8:	ba f8 03 00 00       	mov    $0x3f8,%edx
  80416004fd:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1 + COM_RX);
  80416004fe:	0f b6 c0             	movzbl %al,%eax
}
  8041600501:	5d                   	pop    %rbp
  8041600502:	c3                   	retq   
    return -1;
  8041600503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8041600508:	eb f7                	jmp    8041600501 <serial_proc_data+0x17>

000000804160050a <cons_intr>:
} cons;

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void)) {
  804160050a:	55                   	push   %rbp
  804160050b:	48 89 e5             	mov    %rsp,%rbp
  804160050e:	41 54                	push   %r12
  8041600510:	53                   	push   %rbx
  8041600511:	49 89 fc             	mov    %rdi,%r12
  int c;

  while ((c = (*proc)()) != -1) {
    if (c == 0)
      continue;
    cons.buf[cons.wpos++] = c;
  8041600514:	48 bb 00 41 62 41 80 	movabs $0x8041624100,%rbx
  804160051b:	00 00 00 
  while ((c = (*proc)()) != -1) {
  804160051e:	41 ff d4             	callq  *%r12
  8041600521:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041600524:	74 2c                	je     8041600552 <cons_intr+0x48>
    if (c == 0)
  8041600526:	85 c0                	test   %eax,%eax
  8041600528:	74 f4                	je     804160051e <cons_intr+0x14>
    cons.buf[cons.wpos++] = c;
  804160052a:	8b 93 04 02 00 00    	mov    0x204(%rbx),%edx
  8041600530:	8d 4a 01             	lea    0x1(%rdx),%ecx
  8041600533:	89 8b 04 02 00 00    	mov    %ecx,0x204(%rbx)
  8041600539:	89 d2                	mov    %edx,%edx
  804160053b:	88 04 13             	mov    %al,(%rbx,%rdx,1)
    if (cons.wpos == CONSBUFSIZE)
  804160053e:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  8041600544:	75 d8                	jne    804160051e <cons_intr+0x14>
      cons.wpos = 0;
  8041600546:	c7 83 04 02 00 00 00 	movl   $0x0,0x204(%rbx)
  804160054d:	00 00 00 
  8041600550:	eb cc                	jmp    804160051e <cons_intr+0x14>
  }
}
  8041600552:	5b                   	pop    %rbx
  8041600553:	41 5c                	pop    %r12
  8041600555:	5d                   	pop    %rbp
  8041600556:	c3                   	retq   

0000008041600557 <kbd_proc_data>:
kbd_proc_data(void) {
  8041600557:	55                   	push   %rbp
  8041600558:	48 89 e5             	mov    %rsp,%rbp
  804160055b:	53                   	push   %rbx
  804160055c:	48 83 ec 08          	sub    $0x8,%rsp
  8041600560:	ba 64 00 00 00       	mov    $0x64,%edx
  8041600565:	ec                   	in     (%dx),%al
  if ((inb(KBSTATP) & KBS_DIB) == 0)
  8041600566:	a8 01                	test   $0x1,%al
  8041600568:	0f 84 35 01 00 00    	je     80416006a3 <kbd_proc_data+0x14c>
  804160056e:	ba 60 00 00 00       	mov    $0x60,%edx
  8041600573:	ec                   	in     (%dx),%al
  8041600574:	89 c2                	mov    %eax,%edx
  if (data == 0xE0) {
  8041600576:	3c e0                	cmp    $0xe0,%al
  8041600578:	0f 84 bc 00 00 00    	je     804160063a <kbd_proc_data+0xe3>
  } else if (data & 0x80) {
  804160057e:	84 c0                	test   %al,%al
  8041600580:	0f 88 cf 00 00 00    	js     8041600655 <kbd_proc_data+0xfe>
  } else if (shift & E0ESC) {
  8041600586:	48 bf e0 40 62 41 80 	movabs $0x80416240e0,%rdi
  804160058d:	00 00 00 
  8041600590:	8b 0f                	mov    (%rdi),%ecx
  8041600592:	f6 c1 40             	test   $0x40,%cl
  8041600595:	74 0c                	je     80416005a3 <kbd_proc_data+0x4c>
    data |= 0x80;
  8041600597:	83 c8 80             	or     $0xffffff80,%eax
  804160059a:	89 c2                	mov    %eax,%edx
    shift &= ~E0ESC;
  804160059c:	89 c8                	mov    %ecx,%eax
  804160059e:	83 e0 bf             	and    $0xffffffbf,%eax
  80416005a1:	89 07                	mov    %eax,(%rdi)
  shift |= shiftcode[data];
  80416005a3:	0f b6 f2             	movzbl %dl,%esi
  80416005a6:	48 b8 80 65 60 41 80 	movabs $0x8041606580,%rax
  80416005ad:	00 00 00 
  80416005b0:	0f b6 04 30          	movzbl (%rax,%rsi,1),%eax
  80416005b4:	48 b9 e0 40 62 41 80 	movabs $0x80416240e0,%rcx
  80416005bb:	00 00 00 
  80416005be:	0b 01                	or     (%rcx),%eax
  shift ^= togglecode[data];
  80416005c0:	48 bf 80 64 60 41 80 	movabs $0x8041606480,%rdi
  80416005c7:	00 00 00 
  80416005ca:	0f b6 34 37          	movzbl (%rdi,%rsi,1),%esi
  80416005ce:	31 f0                	xor    %esi,%eax
  80416005d0:	89 01                	mov    %eax,(%rcx)
  c = charcode[shift & (CTL | SHIFT)][data];
  80416005d2:	89 c6                	mov    %eax,%esi
  80416005d4:	83 e6 03             	and    $0x3,%esi
  80416005d7:	0f b6 d2             	movzbl %dl,%edx
  80416005da:	48 b9 60 64 60 41 80 	movabs $0x8041606460,%rcx
  80416005e1:	00 00 00 
  80416005e4:	48 8b 0c f1          	mov    (%rcx,%rsi,8),%rcx
  80416005e8:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
  80416005ec:	0f b6 da             	movzbl %dl,%ebx
  if (shift & CAPSLOCK) {
  80416005ef:	a8 08                	test   $0x8,%al
  80416005f1:	74 11                	je     8041600604 <kbd_proc_data+0xad>
    if ('a' <= c && c <= 'z')
  80416005f3:	89 da                	mov    %ebx,%edx
  80416005f5:	8d 4b 9f             	lea    -0x61(%rbx),%ecx
  80416005f8:	83 f9 19             	cmp    $0x19,%ecx
  80416005fb:	0f 87 91 00 00 00    	ja     8041600692 <kbd_proc_data+0x13b>
      c += 'A' - 'a';
  8041600601:	83 eb 20             	sub    $0x20,%ebx
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  8041600604:	f7 d0                	not    %eax
  8041600606:	a8 06                	test   $0x6,%al
  8041600608:	75 42                	jne    804160064c <kbd_proc_data+0xf5>
  804160060a:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
  8041600610:	75 3a                	jne    804160064c <kbd_proc_data+0xf5>
    cprintf("Rebooting!\n");
  8041600612:	48 bf 2f 64 60 41 80 	movabs $0x804160642f,%rdi
  8041600619:	00 00 00 
  804160061c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600621:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041600628:	00 00 00 
  804160062b:	ff d2                	callq  *%rdx
                   : "memory", "cc");
}

static __inline void
outb(int port, uint8_t data) {
  __asm __volatile("outb %0,%w1"
  804160062d:	b8 03 00 00 00       	mov    $0x3,%eax
  8041600632:	ba 92 00 00 00       	mov    $0x92,%edx
  8041600637:	ee                   	out    %al,(%dx)
  8041600638:	eb 12                	jmp    804160064c <kbd_proc_data+0xf5>
    shift |= E0ESC;
  804160063a:	48 b8 e0 40 62 41 80 	movabs $0x80416240e0,%rax
  8041600641:	00 00 00 
  8041600644:	83 08 40             	orl    $0x40,(%rax)
    return 0;
  8041600647:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  804160064c:	89 d8                	mov    %ebx,%eax
  804160064e:	48 83 c4 08          	add    $0x8,%rsp
  8041600652:	5b                   	pop    %rbx
  8041600653:	5d                   	pop    %rbp
  8041600654:	c3                   	retq   
    data = (shift & E0ESC ? data : data & 0x7F);
  8041600655:	48 bf e0 40 62 41 80 	movabs $0x80416240e0,%rdi
  804160065c:	00 00 00 
  804160065f:	8b 0f                	mov    (%rdi),%ecx
  8041600661:	89 ce                	mov    %ecx,%esi
  8041600663:	83 e6 40             	and    $0x40,%esi
  8041600666:	83 e0 7f             	and    $0x7f,%eax
  8041600669:	85 f6                	test   %esi,%esi
  804160066b:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
  804160066e:	0f b6 d2             	movzbl %dl,%edx
  8041600671:	48 b8 80 65 60 41 80 	movabs $0x8041606580,%rax
  8041600678:	00 00 00 
  804160067b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  804160067f:	83 c8 40             	or     $0x40,%eax
  8041600682:	0f b6 c0             	movzbl %al,%eax
  8041600685:	f7 d0                	not    %eax
  8041600687:	21 c8                	and    %ecx,%eax
  8041600689:	89 07                	mov    %eax,(%rdi)
    return 0;
  804160068b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8041600690:	eb ba                	jmp    804160064c <kbd_proc_data+0xf5>
    else if ('A' <= c && c <= 'Z')
  8041600692:	83 ea 41             	sub    $0x41,%edx
      c += 'a' - 'A';
  8041600695:	8d 4b 20             	lea    0x20(%rbx),%ecx
  8041600698:	83 fa 1a             	cmp    $0x1a,%edx
  804160069b:	0f 42 d9             	cmovb  %ecx,%ebx
  804160069e:	e9 61 ff ff ff       	jmpq   8041600604 <kbd_proc_data+0xad>
    return -1;
  80416006a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  80416006a8:	eb a2                	jmp    804160064c <kbd_proc_data+0xf5>

00000080416006aa <draw_char>:
draw_char(uint32_t *buffer, uint32_t x, uint32_t y, uint32_t color, char charcode) {
  80416006aa:	55                   	push   %rbp
  80416006ab:	48 89 e5             	mov    %rsp,%rbp
        buffer[uefi_hres * SYMBOL_SIZE * y + uefi_hres * h + SYMBOL_SIZE * x + w] = color;
  80416006ae:	48 b8 14 43 62 41 80 	movabs $0x8041624314,%rax
  80416006b5:	00 00 00 
  80416006b8:	44 8b 10             	mov    (%rax),%r10d
  80416006bb:	41 0f af d2          	imul   %r10d,%edx
  80416006bf:	44 8d 0c 32          	lea    (%rdx,%rsi,1),%r9d
  80416006c3:	41 c1 e1 03          	shl    $0x3,%r9d
  char *p = &(font8x8_basic[pos][0]); // Size of a font's character
  80416006c7:	4d 0f be c0          	movsbq %r8b,%r8
  80416006cb:	48 b8 20 83 61 41 80 	movabs $0x8041618320,%rax
  80416006d2:	00 00 00 
  80416006d5:	4a 8d 34 c0          	lea    (%rax,%r8,8),%rsi
  80416006d9:	4c 8d 46 08          	lea    0x8(%rsi),%r8
  80416006dd:	eb 25                	jmp    8041600704 <draw_char+0x5a>
    for (int w = 0; w < 8; w++) {
  80416006df:	83 c0 01             	add    $0x1,%eax
  80416006e2:	83 f8 08             	cmp    $0x8,%eax
  80416006e5:	74 11                	je     80416006f8 <draw_char+0x4e>
      if ((p[h] >> (w)) & 1) {
  80416006e7:	0f be 16             	movsbl (%rsi),%edx
  80416006ea:	0f a3 c2             	bt     %eax,%edx
  80416006ed:	73 f0                	jae    80416006df <draw_char+0x35>
        buffer[uefi_hres * SYMBOL_SIZE * y + uefi_hres * h + SYMBOL_SIZE * x + w] = color;
  80416006ef:	42 8d 14 08          	lea    (%rax,%r9,1),%edx
  80416006f3:	89 0c 97             	mov    %ecx,(%rdi,%rdx,4)
  80416006f6:	eb e7                	jmp    80416006df <draw_char+0x35>
  80416006f8:	48 83 c6 01          	add    $0x1,%rsi
  80416006fc:	45 01 d1             	add    %r10d,%r9d
  for (int h = 0; h < 8; h++) {
  80416006ff:	4c 39 c6             	cmp    %r8,%rsi
  8041600702:	74 07                	je     804160070b <draw_char+0x61>
    for (int w = 0; w < 8; w++) {
  8041600704:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600709:	eb dc                	jmp    80416006e7 <draw_char+0x3d>
}
  804160070b:	5d                   	pop    %rbp
  804160070c:	c3                   	retq   

000000804160070d <cons_putc>:
  __asm __volatile("inb %w1,%0"
  804160070d:	ba fd 03 00 00       	mov    $0x3fd,%edx
  8041600712:	ec                   	in     (%dx),%al
       !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  8041600713:	a8 20                	test   $0x20,%al
  8041600715:	75 29                	jne    8041600740 <cons_putc+0x33>
  for (i = 0;
  8041600717:	be 00 00 00 00       	mov    $0x0,%esi
  804160071c:	b9 84 00 00 00       	mov    $0x84,%ecx
  8041600721:	41 b9 fd 03 00 00    	mov    $0x3fd,%r9d
  8041600727:	89 ca                	mov    %ecx,%edx
  8041600729:	ec                   	in     (%dx),%al
  804160072a:	ec                   	in     (%dx),%al
  804160072b:	ec                   	in     (%dx),%al
  804160072c:	ec                   	in     (%dx),%al
       i++)
  804160072d:	83 c6 01             	add    $0x1,%esi
  8041600730:	44 89 ca             	mov    %r9d,%edx
  8041600733:	ec                   	in     (%dx),%al
       !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  8041600734:	a8 20                	test   $0x20,%al
  8041600736:	75 08                	jne    8041600740 <cons_putc+0x33>
  8041600738:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  804160073e:	7e e7                	jle    8041600727 <cons_putc+0x1a>
  outb(COM1 + COM_TX, c);
  8041600740:	41 89 f8             	mov    %edi,%r8d
  __asm __volatile("outb %0,%w1"
  8041600743:	ba f8 03 00 00       	mov    $0x3f8,%edx
  8041600748:	89 f8                	mov    %edi,%eax
  804160074a:	ee                   	out    %al,(%dx)
  __asm __volatile("inb %w1,%0"
  804160074b:	ba 79 03 00 00       	mov    $0x379,%edx
  8041600750:	ec                   	in     (%dx),%al
  for (i = 0; !(inb(0x378 + 1) & 0x80) && i < 12800; i++)
  8041600751:	84 c0                	test   %al,%al
  8041600753:	78 29                	js     804160077e <cons_putc+0x71>
  8041600755:	be 00 00 00 00       	mov    $0x0,%esi
  804160075a:	b9 84 00 00 00       	mov    $0x84,%ecx
  804160075f:	41 b9 79 03 00 00    	mov    $0x379,%r9d
  8041600765:	89 ca                	mov    %ecx,%edx
  8041600767:	ec                   	in     (%dx),%al
  8041600768:	ec                   	in     (%dx),%al
  8041600769:	ec                   	in     (%dx),%al
  804160076a:	ec                   	in     (%dx),%al
  804160076b:	83 c6 01             	add    $0x1,%esi
  804160076e:	44 89 ca             	mov    %r9d,%edx
  8041600771:	ec                   	in     (%dx),%al
  8041600772:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  8041600778:	7f 04                	jg     804160077e <cons_putc+0x71>
  804160077a:	84 c0                	test   %al,%al
  804160077c:	79 e7                	jns    8041600765 <cons_putc+0x58>
  __asm __volatile("outb %0,%w1"
  804160077e:	ba 78 03 00 00       	mov    $0x378,%edx
  8041600783:	44 89 c0             	mov    %r8d,%eax
  8041600786:	ee                   	out    %al,(%dx)
  8041600787:	ba 7a 03 00 00       	mov    $0x37a,%edx
  804160078c:	b8 0d 00 00 00       	mov    $0xd,%eax
  8041600791:	ee                   	out    %al,(%dx)
  8041600792:	b8 08 00 00 00       	mov    $0x8,%eax
  8041600797:	ee                   	out    %al,(%dx)
  if (!graphics_exists) {
  8041600798:	48 b8 1c 43 62 41 80 	movabs $0x804162431c,%rax
  804160079f:	00 00 00 
  80416007a2:	80 38 00             	cmpb   $0x0,(%rax)
  80416007a5:	0f 84 27 02 00 00    	je     80416009d2 <cons_putc+0x2c5>
  return 0;
}

// output a character to the console
static void
cons_putc(int c) {
  80416007ab:	55                   	push   %rbp
  80416007ac:	48 89 e5             	mov    %rsp,%rbp
  80416007af:	41 54                	push   %r12
  80416007b1:	53                   	push   %rbx
  if (!(c & ~0xFF))
  80416007b2:	89 fa                	mov    %edi,%edx
  80416007b4:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
    c |= 0x0700;
  80416007ba:	89 f8                	mov    %edi,%eax
  80416007bc:	80 cc 07             	or     $0x7,%ah
  80416007bf:	85 d2                	test   %edx,%edx
  80416007c1:	0f 44 f8             	cmove  %eax,%edi
  switch (c & 0xff) {
  80416007c4:	40 0f b6 c7          	movzbl %dil,%eax
  80416007c8:	83 f8 09             	cmp    $0x9,%eax
  80416007cb:	0f 84 e4 00 00 00    	je     80416008b5 <cons_putc+0x1a8>
  80416007d1:	83 f8 09             	cmp    $0x9,%eax
  80416007d4:	7e 5c                	jle    8041600832 <cons_putc+0x125>
  80416007d6:	83 f8 0a             	cmp    $0xa,%eax
  80416007d9:	0f 84 b8 00 00 00    	je     8041600897 <cons_putc+0x18a>
  80416007df:	83 f8 0d             	cmp    $0xd,%eax
  80416007e2:	0f 85 ff 00 00 00    	jne    80416008e7 <cons_putc+0x1da>
      crt_pos -= (crt_pos % crt_cols);
  80416007e8:	48 be 08 43 62 41 80 	movabs $0x8041624308,%rsi
  80416007ef:	00 00 00 
  80416007f2:	0f b7 0e             	movzwl (%rsi),%ecx
  80416007f5:	0f b7 c1             	movzwl %cx,%eax
  80416007f8:	48 bb 10 43 62 41 80 	movabs $0x8041624310,%rbx
  80416007ff:	00 00 00 
  8041600802:	ba 00 00 00 00       	mov    $0x0,%edx
  8041600807:	f7 33                	divl   (%rbx)
  8041600809:	29 d1                	sub    %edx,%ecx
  804160080b:	66 89 0e             	mov    %cx,(%rsi)
  if (crt_pos >= crt_size) {
  804160080e:	48 b8 08 43 62 41 80 	movabs $0x8041624308,%rax
  8041600815:	00 00 00 
  8041600818:	0f b7 10             	movzwl (%rax),%edx
  804160081b:	48 b8 0c 43 62 41 80 	movabs $0x804162430c,%rax
  8041600822:	00 00 00 
  8041600825:	3b 10                	cmp    (%rax),%edx
  8041600827:	0f 83 0f 01 00 00    	jae    804160093c <cons_putc+0x22f>
  serial_putc(c);
  lpt_putc(c);
  fb_putc(c);
}
  804160082d:	5b                   	pop    %rbx
  804160082e:	41 5c                	pop    %r12
  8041600830:	5d                   	pop    %rbp
  8041600831:	c3                   	retq   
  switch (c & 0xff) {
  8041600832:	83 f8 08             	cmp    $0x8,%eax
  8041600835:	0f 85 ac 00 00 00    	jne    80416008e7 <cons_putc+0x1da>
      if (crt_pos > 0) {
  804160083b:	66 a1 08 43 62 41 80 	movabs 0x8041624308,%ax
  8041600842:	00 00 00 
  8041600845:	66 85 c0             	test   %ax,%ax
  8041600848:	74 c4                	je     804160080e <cons_putc+0x101>
        crt_pos--;
  804160084a:	83 e8 01             	sub    $0x1,%eax
  804160084d:	66 a3 08 43 62 41 80 	movabs %ax,0x8041624308
  8041600854:	00 00 00 
        draw_char(crt_buf, crt_pos % crt_cols, crt_pos / crt_cols, 0x0, 0x8);
  8041600857:	0f b7 c0             	movzwl %ax,%eax
  804160085a:	48 bb 10 43 62 41 80 	movabs $0x8041624310,%rbx
  8041600861:	00 00 00 
  8041600864:	8b 1b                	mov    (%rbx),%ebx
  8041600866:	ba 00 00 00 00       	mov    $0x0,%edx
  804160086b:	f7 f3                	div    %ebx
  804160086d:	89 d6                	mov    %edx,%esi
  804160086f:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041600875:	b9 00 00 00 00       	mov    $0x0,%ecx
  804160087a:	89 c2                	mov    %eax,%edx
  804160087c:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600883:	00 00 00 
  8041600886:	48 b8 aa 06 60 41 80 	movabs $0x80416006aa,%rax
  804160088d:	00 00 00 
  8041600890:	ff d0                	callq  *%rax
  8041600892:	e9 77 ff ff ff       	jmpq   804160080e <cons_putc+0x101>
      crt_pos += crt_cols;
  8041600897:	48 b8 08 43 62 41 80 	movabs $0x8041624308,%rax
  804160089e:	00 00 00 
  80416008a1:	48 bb 10 43 62 41 80 	movabs $0x8041624310,%rbx
  80416008a8:	00 00 00 
  80416008ab:	8b 13                	mov    (%rbx),%edx
  80416008ad:	66 01 10             	add    %dx,(%rax)
  80416008b0:	e9 33 ff ff ff       	jmpq   80416007e8 <cons_putc+0xdb>
      cons_putc(' ');
  80416008b5:	bf 20 00 00 00       	mov    $0x20,%edi
  80416008ba:	48 bb 0d 07 60 41 80 	movabs $0x804160070d,%rbx
  80416008c1:	00 00 00 
  80416008c4:	ff d3                	callq  *%rbx
      cons_putc(' ');
  80416008c6:	bf 20 00 00 00       	mov    $0x20,%edi
  80416008cb:	ff d3                	callq  *%rbx
      cons_putc(' ');
  80416008cd:	bf 20 00 00 00       	mov    $0x20,%edi
  80416008d2:	ff d3                	callq  *%rbx
      cons_putc(' ');
  80416008d4:	bf 20 00 00 00       	mov    $0x20,%edi
  80416008d9:	ff d3                	callq  *%rbx
      cons_putc(' ');
  80416008db:	bf 20 00 00 00       	mov    $0x20,%edi
  80416008e0:	ff d3                	callq  *%rbx
  80416008e2:	e9 27 ff ff ff       	jmpq   804160080e <cons_putc+0x101>
      draw_char(crt_buf, crt_pos % crt_cols, crt_pos / crt_cols, 0xffffffff, (char)c); /* write the character */
  80416008e7:	49 bc 08 43 62 41 80 	movabs $0x8041624308,%r12
  80416008ee:	00 00 00 
  80416008f1:	41 0f b7 1c 24       	movzwl (%r12),%ebx
  80416008f6:	0f b7 c3             	movzwl %bx,%eax
  80416008f9:	48 be 10 43 62 41 80 	movabs $0x8041624310,%rsi
  8041600900:	00 00 00 
  8041600903:	8b 36                	mov    (%rsi),%esi
  8041600905:	ba 00 00 00 00       	mov    $0x0,%edx
  804160090a:	f7 f6                	div    %esi
  804160090c:	89 d6                	mov    %edx,%esi
  804160090e:	44 0f be c7          	movsbl %dil,%r8d
  8041600912:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8041600917:	89 c2                	mov    %eax,%edx
  8041600919:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600920:	00 00 00 
  8041600923:	48 b8 aa 06 60 41 80 	movabs $0x80416006aa,%rax
  804160092a:	00 00 00 
  804160092d:	ff d0                	callq  *%rax
      crt_pos++;
  804160092f:	83 c3 01             	add    $0x1,%ebx
  8041600932:	66 41 89 1c 24       	mov    %bx,(%r12)
  8041600937:	e9 d2 fe ff ff       	jmpq   804160080e <cons_putc+0x101>
    memmove(crt_buf, crt_buf + uefi_hres * SYMBOL_SIZE, uefi_hres * (uefi_vres - SYMBOL_SIZE) * sizeof(uint32_t));
  804160093c:	48 bb 14 43 62 41 80 	movabs $0x8041624314,%rbx
  8041600943:	00 00 00 
  8041600946:	8b 03                	mov    (%rbx),%eax
  8041600948:	49 bc 18 43 62 41 80 	movabs $0x8041624318,%r12
  804160094f:	00 00 00 
  8041600952:	41 8b 3c 24          	mov    (%r12),%edi
  8041600956:	8d 57 f8             	lea    -0x8(%rdi),%edx
  8041600959:	0f af d0             	imul   %eax,%edx
  804160095c:	48 c1 e2 02          	shl    $0x2,%rdx
  8041600960:	c1 e0 03             	shl    $0x3,%eax
  8041600963:	89 c0                	mov    %eax,%eax
  8041600965:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  804160096c:	00 00 00 
  804160096f:	48 8d 34 87          	lea    (%rdi,%rax,4),%rsi
  8041600973:	48 b8 c8 55 60 41 80 	movabs $0x80416055c8,%rax
  804160097a:	00 00 00 
  804160097d:	ff d0                	callq  *%rax
    for (i = uefi_hres * (uefi_vres - (uefi_vres % SYMBOL_SIZE) - SYMBOL_SIZE); i < uefi_hres * uefi_vres; i++)
  804160097f:	41 8b 14 24          	mov    (%r12),%edx
  8041600983:	8b 33                	mov    (%rbx),%esi
  8041600985:	89 d1                	mov    %edx,%ecx
  8041600987:	83 e1 f8             	and    $0xfffffff8,%ecx
  804160098a:	83 e9 08             	sub    $0x8,%ecx
  804160098d:	0f af ce             	imul   %esi,%ecx
  8041600990:	89 c8                	mov    %ecx,%eax
  8041600992:	0f af d6             	imul   %esi,%edx
  8041600995:	39 ca                	cmp    %ecx,%edx
  8041600997:	76 1b                	jbe    80416009b4 <cons_putc+0x2a7>
      crt_buf[i] = 0;
  8041600999:	48 be 00 00 c0 3e 80 	movabs $0x803ec00000,%rsi
  80416009a0:	00 00 00 
  80416009a3:	48 63 c8             	movslq %eax,%rcx
  80416009a6:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
    for (i = uefi_hres * (uefi_vres - (uefi_vres % SYMBOL_SIZE) - SYMBOL_SIZE); i < uefi_hres * uefi_vres; i++)
  80416009ad:	83 c0 01             	add    $0x1,%eax
  80416009b0:	39 d0                	cmp    %edx,%eax
  80416009b2:	75 ef                	jne    80416009a3 <cons_putc+0x296>
    crt_pos -= crt_cols;
  80416009b4:	48 b8 08 43 62 41 80 	movabs $0x8041624308,%rax
  80416009bb:	00 00 00 
  80416009be:	48 bb 10 43 62 41 80 	movabs $0x8041624310,%rbx
  80416009c5:	00 00 00 
  80416009c8:	8b 13                	mov    (%rbx),%edx
  80416009ca:	66 29 10             	sub    %dx,(%rax)
}
  80416009cd:	e9 5b fe ff ff       	jmpq   804160082d <cons_putc+0x120>
  80416009d2:	f3 c3                	repz retq 

00000080416009d4 <serial_intr>:
  if (serial_exists)
  80416009d4:	48 b8 0a 43 62 41 80 	movabs $0x804162430a,%rax
  80416009db:	00 00 00 
  80416009de:	80 38 00             	cmpb   $0x0,(%rax)
  80416009e1:	75 02                	jne    80416009e5 <serial_intr+0x11>
  80416009e3:	f3 c3                	repz retq 
serial_intr(void) {
  80416009e5:	55                   	push   %rbp
  80416009e6:	48 89 e5             	mov    %rsp,%rbp
    cons_intr(serial_proc_data);
  80416009e9:	48 bf ea 04 60 41 80 	movabs $0x80416004ea,%rdi
  80416009f0:	00 00 00 
  80416009f3:	48 b8 0a 05 60 41 80 	movabs $0x804160050a,%rax
  80416009fa:	00 00 00 
  80416009fd:	ff d0                	callq  *%rax
}
  80416009ff:	5d                   	pop    %rbp
  8041600a00:	c3                   	retq   

0000008041600a01 <fb_init>:
fb_init(void) {
  8041600a01:	55                   	push   %rbp
  8041600a02:	48 89 e5             	mov    %rsp,%rbp
  LOADER_PARAMS *lp = (LOADER_PARAMS *)uefi_lp;
  8041600a05:	48 b8 00 80 61 41 80 	movabs $0x8041618000,%rax
  8041600a0c:	00 00 00 
  8041600a0f:	48 8b 08             	mov    (%rax),%rcx
  uefi_vres         = lp->VerticalResolution;
  8041600a12:	8b 51 4c             	mov    0x4c(%rcx),%edx
  8041600a15:	89 d0                	mov    %edx,%eax
  8041600a17:	a3 18 43 62 41 80 00 	movabs %eax,0x8041624318
  8041600a1e:	00 00 
  uefi_hres         = lp->HorizontalResolution;
  8041600a20:	8b 41 50             	mov    0x50(%rcx),%eax
  8041600a23:	a3 14 43 62 41 80 00 	movabs %eax,0x8041624314
  8041600a2a:	00 00 
  crt_cols          = uefi_hres / SYMBOL_SIZE;
  8041600a2c:	c1 e8 03             	shr    $0x3,%eax
  8041600a2f:	89 c6                	mov    %eax,%esi
  8041600a31:	a3 10 43 62 41 80 00 	movabs %eax,0x8041624310
  8041600a38:	00 00 
  crt_rows          = uefi_vres / SYMBOL_SIZE;
  8041600a3a:	c1 ea 03             	shr    $0x3,%edx
  crt_size          = crt_rows * crt_cols;
  8041600a3d:	0f af d0             	imul   %eax,%edx
  8041600a40:	89 d0                	mov    %edx,%eax
  8041600a42:	a3 0c 43 62 41 80 00 	movabs %eax,0x804162430c
  8041600a49:	00 00 
  crt_pos           = crt_cols;
  8041600a4b:	89 f0                	mov    %esi,%eax
  8041600a4d:	66 a3 08 43 62 41 80 	movabs %ax,0x8041624308
  8041600a54:	00 00 00 
  memset(crt_buf, 0, lp->FrameBufferSize);
  8041600a57:	8b 51 48             	mov    0x48(%rcx),%edx
  8041600a5a:	be 00 00 00 00       	mov    $0x0,%esi
  8041600a5f:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600a66:	00 00 00 
  8041600a69:	48 b8 7f 55 60 41 80 	movabs $0x804160557f,%rax
  8041600a70:	00 00 00 
  8041600a73:	ff d0                	callq  *%rax
  graphics_exists = true;
  8041600a75:	48 b8 1c 43 62 41 80 	movabs $0x804162431c,%rax
  8041600a7c:	00 00 00 
  8041600a7f:	c6 00 01             	movb   $0x1,(%rax)
}
  8041600a82:	5d                   	pop    %rbp
  8041600a83:	c3                   	retq   

0000008041600a84 <kbd_intr>:
kbd_intr(void) {
  8041600a84:	55                   	push   %rbp
  8041600a85:	48 89 e5             	mov    %rsp,%rbp
  cons_intr(kbd_proc_data);
  8041600a88:	48 bf 57 05 60 41 80 	movabs $0x8041600557,%rdi
  8041600a8f:	00 00 00 
  8041600a92:	48 b8 0a 05 60 41 80 	movabs $0x804160050a,%rax
  8041600a99:	00 00 00 
  8041600a9c:	ff d0                	callq  *%rax
}
  8041600a9e:	5d                   	pop    %rbp
  8041600a9f:	c3                   	retq   

0000008041600aa0 <cons_getc>:
cons_getc(void) {
  8041600aa0:	55                   	push   %rbp
  8041600aa1:	48 89 e5             	mov    %rsp,%rbp
  serial_intr();
  8041600aa4:	48 b8 d4 09 60 41 80 	movabs $0x80416009d4,%rax
  8041600aab:	00 00 00 
  8041600aae:	ff d0                	callq  *%rax
  kbd_intr();
  8041600ab0:	48 b8 84 0a 60 41 80 	movabs $0x8041600a84,%rax
  8041600ab7:	00 00 00 
  8041600aba:	ff d0                	callq  *%rax
  if (cons.rpos != cons.wpos) {
  8041600abc:	48 b9 00 41 62 41 80 	movabs $0x8041624100,%rcx
  8041600ac3:	00 00 00 
  8041600ac6:	8b 91 00 02 00 00    	mov    0x200(%rcx),%edx
  return 0;
  8041600acc:	b8 00 00 00 00       	mov    $0x0,%eax
  if (cons.rpos != cons.wpos) {
  8041600ad1:	3b 91 04 02 00 00    	cmp    0x204(%rcx),%edx
  8041600ad7:	74 21                	je     8041600afa <cons_getc+0x5a>
    c = cons.buf[cons.rpos++];
  8041600ad9:	8d 4a 01             	lea    0x1(%rdx),%ecx
  8041600adc:	48 b8 00 41 62 41 80 	movabs $0x8041624100,%rax
  8041600ae3:	00 00 00 
  8041600ae6:	89 88 00 02 00 00    	mov    %ecx,0x200(%rax)
  8041600aec:	89 d2                	mov    %edx,%edx
  8041600aee:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    if (cons.rpos == CONSBUFSIZE)
  8041600af2:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  8041600af8:	74 02                	je     8041600afc <cons_getc+0x5c>
}
  8041600afa:	5d                   	pop    %rbp
  8041600afb:	c3                   	retq   
      cons.rpos = 0;
  8041600afc:	48 be 00 43 62 41 80 	movabs $0x8041624300,%rsi
  8041600b03:	00 00 00 
  8041600b06:	c7 06 00 00 00 00    	movl   $0x0,(%rsi)
  8041600b0c:	eb ec                	jmp    8041600afa <cons_getc+0x5a>

0000008041600b0e <cons_init>:
  8041600b0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041600b13:	bf fa 03 00 00       	mov    $0x3fa,%edi
  8041600b18:	89 c8                	mov    %ecx,%eax
  8041600b1a:	89 fa                	mov    %edi,%edx
  8041600b1c:	ee                   	out    %al,(%dx)
  8041600b1d:	41 b9 fb 03 00 00    	mov    $0x3fb,%r9d
  8041600b23:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  8041600b28:	44 89 ca             	mov    %r9d,%edx
  8041600b2b:	ee                   	out    %al,(%dx)
  8041600b2c:	be f8 03 00 00       	mov    $0x3f8,%esi
  8041600b31:	b8 0c 00 00 00       	mov    $0xc,%eax
  8041600b36:	89 f2                	mov    %esi,%edx
  8041600b38:	ee                   	out    %al,(%dx)
  8041600b39:	41 b8 f9 03 00 00    	mov    $0x3f9,%r8d
  8041600b3f:	89 c8                	mov    %ecx,%eax
  8041600b41:	44 89 c2             	mov    %r8d,%edx
  8041600b44:	ee                   	out    %al,(%dx)
  8041600b45:	b8 03 00 00 00       	mov    $0x3,%eax
  8041600b4a:	44 89 ca             	mov    %r9d,%edx
  8041600b4d:	ee                   	out    %al,(%dx)
  8041600b4e:	ba fc 03 00 00       	mov    $0x3fc,%edx
  8041600b53:	89 c8                	mov    %ecx,%eax
  8041600b55:	ee                   	out    %al,(%dx)
  8041600b56:	b8 01 00 00 00       	mov    $0x1,%eax
  8041600b5b:	44 89 c2             	mov    %r8d,%edx
  8041600b5e:	ee                   	out    %al,(%dx)
  __asm __volatile("inb %w1,%0"
  8041600b5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
  8041600b64:	ec                   	in     (%dx),%al
  8041600b65:	89 c1                	mov    %eax,%ecx
  serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  8041600b67:	3c ff                	cmp    $0xff,%al
  8041600b69:	0f 95 c0             	setne  %al
  8041600b6c:	a2 0a 43 62 41 80 00 	movabs %al,0x804162430a
  8041600b73:	00 00 
  8041600b75:	89 fa                	mov    %edi,%edx
  8041600b77:	ec                   	in     (%dx),%al
  8041600b78:	89 f2                	mov    %esi,%edx
  8041600b7a:	ec                   	in     (%dx),%al
void
cons_init(void) {
  kbd_init();
  serial_init();

  if (!serial_exists)
  8041600b7b:	80 f9 ff             	cmp    $0xff,%cl
  8041600b7e:	74 02                	je     8041600b82 <cons_init+0x74>
  8041600b80:	f3 c3                	repz retq 
cons_init(void) {
  8041600b82:	55                   	push   %rbp
  8041600b83:	48 89 e5             	mov    %rsp,%rbp
    cprintf("Serial port does not exist!\n");
  8041600b86:	48 bf 3b 64 60 41 80 	movabs $0x804160643b,%rdi
  8041600b8d:	00 00 00 
  8041600b90:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600b95:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041600b9c:	00 00 00 
  8041600b9f:	ff d2                	callq  *%rdx
}
  8041600ba1:	5d                   	pop    %rbp
  8041600ba2:	c3                   	retq   

0000008041600ba3 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c) {
  8041600ba3:	55                   	push   %rbp
  8041600ba4:	48 89 e5             	mov    %rsp,%rbp
  cons_putc(c);
  8041600ba7:	48 b8 0d 07 60 41 80 	movabs $0x804160070d,%rax
  8041600bae:	00 00 00 
  8041600bb1:	ff d0                	callq  *%rax
}
  8041600bb3:	5d                   	pop    %rbp
  8041600bb4:	c3                   	retq   

0000008041600bb5 <getchar>:

int
getchar(void) {
  8041600bb5:	55                   	push   %rbp
  8041600bb6:	48 89 e5             	mov    %rsp,%rbp
  8041600bb9:	53                   	push   %rbx
  8041600bba:	48 83 ec 08          	sub    $0x8,%rsp
  int c;

  while ((c = cons_getc()) == 0)
  8041600bbe:	48 bb a0 0a 60 41 80 	movabs $0x8041600aa0,%rbx
  8041600bc5:	00 00 00 
  8041600bc8:	ff d3                	callq  *%rbx
  8041600bca:	85 c0                	test   %eax,%eax
  8041600bcc:	74 fa                	je     8041600bc8 <getchar+0x13>
    /* do nothing */;
  return c;
}
  8041600bce:	48 83 c4 08          	add    $0x8,%rsp
  8041600bd2:	5b                   	pop    %rbx
  8041600bd3:	5d                   	pop    %rbp
  8041600bd4:	c3                   	retq   

0000008041600bd5 <iscons>:

int
iscons(int fdnum) {
  8041600bd5:	55                   	push   %rbp
  8041600bd6:	48 89 e5             	mov    %rsp,%rbp
  // used by readline
  return 1;
}
  8041600bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  8041600bde:	5d                   	pop    %rbp
  8041600bdf:	c3                   	retq   

0000008041600be0 <dwarf_read_abbrev_entry>:
}

// Read value from .debug_abbrev table in buf. Returns number of bytes read.
static int
dwarf_read_abbrev_entry(const void *entry, unsigned form, void *buf,
                        int bufsize, unsigned address_size) {
  8041600be0:	55                   	push   %rbp
  8041600be1:	48 89 e5             	mov    %rsp,%rbp
  8041600be4:	41 56                	push   %r14
  8041600be6:	41 55                	push   %r13
  8041600be8:	41 54                	push   %r12
  8041600bea:	53                   	push   %rbx
  8041600beb:	48 83 ec 20          	sub    $0x20,%rsp
  8041600bef:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  int bytes = 0;
  switch (form) {
  8041600bf3:	83 fe 20             	cmp    $0x20,%esi
  8041600bf6:	0f 87 56 09 00 00    	ja     8041601552 <dwarf_read_abbrev_entry+0x972>
  8041600bfc:	45 89 c5             	mov    %r8d,%r13d
  8041600bff:	41 89 cc             	mov    %ecx,%r12d
  8041600c02:	48 89 d3             	mov    %rdx,%rbx
  8041600c05:	89 f6                	mov    %esi,%esi
  8041600c07:	48 b8 38 67 60 41 80 	movabs $0x8041606738,%rax
  8041600c0e:	00 00 00 
  8041600c11:	ff 24 f0             	jmpq   *(%rax,%rsi,8)
    case DW_FORM_addr:
      if (buf && bufsize >= sizeof(uintptr_t)) {
  8041600c14:	48 85 d2             	test   %rdx,%rdx
  8041600c17:	74 72                	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  8041600c19:	83 f9 07             	cmp    $0x7,%ecx
  8041600c1c:	76 6d                	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        memcpy(buf, entry, sizeof(uintptr_t));
  8041600c1e:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600c23:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600c27:	48 89 df             	mov    %rbx,%rdi
  8041600c2a:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600c31:	00 00 00 
  8041600c34:	ff d0                	callq  *%rax
      }
      entry += address_size;
      bytes = address_size;
      break;
  8041600c36:	eb 53                	jmp    8041600c8b <dwarf_read_abbrev_entry+0xab>
    case DW_FORM_block2: {
      // Read block of 2-byte length followed by 0 to 65535 contiguous information bytes
      // LAB 2: Your code here:
      unsigned length = get_unaligned(entry, Dwarf_Half);
  8041600c38:	ba 02 00 00 00       	mov    $0x2,%edx
  8041600c3d:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600c41:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600c45:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600c4c:	00 00 00 
  8041600c4f:	ff d0                	callq  *%rax
  8041600c51:	44 0f b7 6d d0       	movzwl -0x30(%rbp),%r13d
      entry += sizeof(Dwarf_Half);
  8041600c56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041600c5a:	48 83 c0 02          	add    $0x2,%rax
  8041600c5e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      struct Slice slice = {
  8041600c62:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8041600c66:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
          .mem = entry,
          .len = length,
      };
      if (buf) {
  8041600c6a:	48 85 db             	test   %rbx,%rbx
  8041600c6d:	74 18                	je     8041600c87 <dwarf_read_abbrev_entry+0xa7>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600c6f:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600c74:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600c78:	48 89 df             	mov    %rbx,%rdi
  8041600c7b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600c82:	00 00 00 
  8041600c85:	ff d0                	callq  *%rax
      }
      entry += length;
      bytes = sizeof(Dwarf_Half) + length;
  8041600c87:	41 83 c5 02          	add    $0x2,%r13d
      }
      bytes = sizeof(uint64_t);
    } break;
  }
  return bytes;
}
  8041600c8b:	44 89 e8             	mov    %r13d,%eax
  8041600c8e:	48 83 c4 20          	add    $0x20,%rsp
  8041600c92:	5b                   	pop    %rbx
  8041600c93:	41 5c                	pop    %r12
  8041600c95:	41 5d                	pop    %r13
  8041600c97:	41 5e                	pop    %r14
  8041600c99:	5d                   	pop    %rbp
  8041600c9a:	c3                   	retq   
      unsigned length = get_unaligned(entry, uint32_t);
  8041600c9b:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600ca0:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600ca4:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600ca8:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600caf:	00 00 00 
  8041600cb2:	ff d0                	callq  *%rax
  8041600cb4:	44 8b 6d d0          	mov    -0x30(%rbp),%r13d
      entry += sizeof(uint32_t);
  8041600cb8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041600cbc:	48 83 c0 04          	add    $0x4,%rax
  8041600cc0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      struct Slice slice = {
  8041600cc4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8041600cc8:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
      if (buf) {
  8041600ccc:	48 85 db             	test   %rbx,%rbx
  8041600ccf:	74 18                	je     8041600ce9 <dwarf_read_abbrev_entry+0x109>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600cd1:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600cd6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600cda:	48 89 df             	mov    %rbx,%rdi
  8041600cdd:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600ce4:	00 00 00 
  8041600ce7:	ff d0                	callq  *%rax
      bytes = sizeof(uint32_t) + length;
  8041600ce9:	41 83 c5 04          	add    $0x4,%r13d
    } break;
  8041600ced:	eb 9c                	jmp    8041600c8b <dwarf_read_abbrev_entry+0xab>
      Dwarf_Half data = get_unaligned(entry, Dwarf_Half);
  8041600cef:	ba 02 00 00 00       	mov    $0x2,%edx
  8041600cf4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600cf8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600cfc:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600d03:	00 00 00 
  8041600d06:	ff d0                	callq  *%rax
      entry += sizeof(Dwarf_Half);
  8041600d08:	48 83 45 c8 02       	addq   $0x2,-0x38(%rbp)
      if (buf && bufsize >= sizeof(Dwarf_Half)) {
  8041600d0d:	48 85 db             	test   %rbx,%rbx
  8041600d10:	74 06                	je     8041600d18 <dwarf_read_abbrev_entry+0x138>
  8041600d12:	41 83 fc 01          	cmp    $0x1,%r12d
  8041600d16:	77 0b                	ja     8041600d23 <dwarf_read_abbrev_entry+0x143>
      bytes = sizeof(Dwarf_Half);
  8041600d18:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  8041600d1e:	e9 68 ff ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (Dwarf_Half *)buf);
  8041600d23:	ba 02 00 00 00       	mov    $0x2,%edx
  8041600d28:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600d2c:	48 89 df             	mov    %rbx,%rdi
  8041600d2f:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600d36:	00 00 00 
  8041600d39:	ff d0                	callq  *%rax
      bytes = sizeof(Dwarf_Half);
  8041600d3b:	41 bd 02 00 00 00    	mov    $0x2,%r13d
        put_unaligned(data, (Dwarf_Half *)buf);
  8041600d41:	e9 45 ff ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      uint32_t data = get_unaligned(entry, uint32_t);
  8041600d46:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600d4b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600d4f:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600d53:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600d5a:	00 00 00 
  8041600d5d:	ff d0                	callq  *%rax
      entry += sizeof(uint32_t);
  8041600d5f:	48 83 45 c8 04       	addq   $0x4,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint32_t)) {
  8041600d64:	48 85 db             	test   %rbx,%rbx
  8041600d67:	74 06                	je     8041600d6f <dwarf_read_abbrev_entry+0x18f>
  8041600d69:	41 83 fc 03          	cmp    $0x3,%r12d
  8041600d6d:	77 0b                	ja     8041600d7a <dwarf_read_abbrev_entry+0x19a>
      bytes = sizeof(uint32_t);
  8041600d6f:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  8041600d75:	e9 11 ff ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint32_t *)buf);
  8041600d7a:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600d7f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600d83:	48 89 df             	mov    %rbx,%rdi
  8041600d86:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600d8d:	00 00 00 
  8041600d90:	ff d0                	callq  *%rax
      bytes = sizeof(uint32_t);
  8041600d92:	41 bd 04 00 00 00    	mov    $0x4,%r13d
        put_unaligned(data, (uint32_t *)buf);
  8041600d98:	e9 ee fe ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      uint64_t data = get_unaligned(entry, uint64_t);
  8041600d9d:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600da2:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600da6:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600daa:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600db1:	00 00 00 
  8041600db4:	ff d0                	callq  *%rax
      entry += sizeof(uint64_t);
  8041600db6:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint64_t)) {
  8041600dbb:	48 85 db             	test   %rbx,%rbx
  8041600dbe:	74 06                	je     8041600dc6 <dwarf_read_abbrev_entry+0x1e6>
  8041600dc0:	41 83 fc 07          	cmp    $0x7,%r12d
  8041600dc4:	77 0b                	ja     8041600dd1 <dwarf_read_abbrev_entry+0x1f1>
      bytes = sizeof(uint64_t);
  8041600dc6:	41 bd 08 00 00 00    	mov    $0x8,%r13d
  8041600dcc:	e9 ba fe ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint64_t *)buf);
  8041600dd1:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600dd6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600dda:	48 89 df             	mov    %rbx,%rdi
  8041600ddd:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600de4:	00 00 00 
  8041600de7:	ff d0                	callq  *%rax
      bytes = sizeof(uint64_t);
  8041600de9:	41 bd 08 00 00 00    	mov    $0x8,%r13d
        put_unaligned(data, (uint64_t *)buf);
  8041600def:	e9 97 fe ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      if (buf && bufsize >= sizeof(char *)) {
  8041600df4:	48 85 d2             	test   %rdx,%rdx
  8041600df7:	74 1d                	je     8041600e16 <dwarf_read_abbrev_entry+0x236>
  8041600df9:	83 f9 07             	cmp    $0x7,%ecx
  8041600dfc:	76 18                	jbe    8041600e16 <dwarf_read_abbrev_entry+0x236>
        memcpy(buf, &entry, sizeof(char *));
  8041600dfe:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600e03:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8041600e07:	48 89 df             	mov    %rbx,%rdi
  8041600e0a:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600e11:	00 00 00 
  8041600e14:	ff d0                	callq  *%rax
      bytes = strlen(entry) + 1;
  8041600e16:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8041600e1a:	48 b8 8b 53 60 41 80 	movabs $0x804160538b,%rax
  8041600e21:	00 00 00 
  8041600e24:	ff d0                	callq  *%rax
  8041600e26:	44 8d 68 01          	lea    0x1(%rax),%r13d
    } break;
  8041600e2a:	e9 5c fe ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      unsigned long count = dwarf_read_uleb128(entry, &length);
  8041600e2f:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8041600e33:	48 89 f8             	mov    %rdi,%rax
  unsigned int result;
  unsigned char byte;
  int shift, count;

  result = 0;
  shift  = 0;
  8041600e36:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041600e3b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  count  = 0;

  while (1) {
    byte = *addr;
  8041600e41:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041600e44:	48 83 c0 01          	add    $0x1,%rax
  8041600e48:	41 89 c4             	mov    %eax,%r12d
  8041600e4b:	41 29 fc             	sub    %edi,%r12d
    count++;

    result |= (byte & 0x7f) << shift;
  8041600e4e:	89 f2                	mov    %esi,%edx
  8041600e50:	83 e2 7f             	and    $0x7f,%edx
  8041600e53:	d3 e2                	shl    %cl,%edx
  8041600e55:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041600e58:	83 c1 07             	add    $0x7,%ecx

    if (!(byte & 0x80))
  8041600e5b:	40 84 f6             	test   %sil,%sil
  8041600e5e:	78 e1                	js     8041600e41 <dwarf_read_abbrev_entry+0x261>
      break;
  }

  *ret = result;

  return count;
  8041600e60:	49 63 c4             	movslq %r12d,%rax
      entry += count;
  8041600e63:	48 01 c7             	add    %rax,%rdi
  8041600e66:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
      struct Slice slice = {
  8041600e6a:	48 89 7d d0          	mov    %rdi,-0x30(%rbp)
  8041600e6e:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
      if (buf) {
  8041600e72:	48 85 db             	test   %rbx,%rbx
  8041600e75:	74 18                	je     8041600e8f <dwarf_read_abbrev_entry+0x2af>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600e77:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600e7c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600e80:	48 89 df             	mov    %rbx,%rdi
  8041600e83:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600e8a:	00 00 00 
  8041600e8d:	ff d0                	callq  *%rax
      bytes = count + length;
  8041600e8f:	45 01 e5             	add    %r12d,%r13d
    } break;
  8041600e92:	e9 f4 fd ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      unsigned length = get_unaligned(entry, Dwarf_Small);
  8041600e97:	ba 01 00 00 00       	mov    $0x1,%edx
  8041600e9c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600ea0:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600ea4:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600eab:	00 00 00 
  8041600eae:	ff d0                	callq  *%rax
  8041600eb0:	44 0f b6 6d d0       	movzbl -0x30(%rbp),%r13d
      entry += sizeof(Dwarf_Small);
  8041600eb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041600eb9:	48 83 c0 01          	add    $0x1,%rax
  8041600ebd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      struct Slice slice = {
  8041600ec1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8041600ec5:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
      if (buf) {
  8041600ec9:	48 85 db             	test   %rbx,%rbx
  8041600ecc:	74 18                	je     8041600ee6 <dwarf_read_abbrev_entry+0x306>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600ece:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600ed3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600ed7:	48 89 df             	mov    %rbx,%rdi
  8041600eda:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600ee1:	00 00 00 
  8041600ee4:	ff d0                	callq  *%rax
      bytes = length + sizeof(Dwarf_Small);
  8041600ee6:	41 83 c5 01          	add    $0x1,%r13d
    } break;
  8041600eea:	e9 9c fd ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      Dwarf_Small data = get_unaligned(entry, Dwarf_Small);
  8041600eef:	ba 01 00 00 00       	mov    $0x1,%edx
  8041600ef4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600ef8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600efc:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600f03:	00 00 00 
  8041600f06:	ff d0                	callq  *%rax
  8041600f08:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
      if (buf && bufsize >= sizeof(Dwarf_Small)) {
  8041600f0c:	48 85 db             	test   %rbx,%rbx
  8041600f0f:	0f 84 48 06 00 00    	je     804160155d <dwarf_read_abbrev_entry+0x97d>
  8041600f15:	45 85 e4             	test   %r12d,%r12d
  8041600f18:	0f 84 3f 06 00 00    	je     804160155d <dwarf_read_abbrev_entry+0x97d>
        put_unaligned(data, (Dwarf_Small *)buf);
  8041600f1e:	88 03                	mov    %al,(%rbx)
      bytes = sizeof(Dwarf_Small);
  8041600f20:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        put_unaligned(data, (Dwarf_Small *)buf);
  8041600f26:	e9 60 fd ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      bool data = get_unaligned(entry, Dwarf_Small);
  8041600f2b:	ba 01 00 00 00       	mov    $0x1,%edx
  8041600f30:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600f34:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600f38:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600f3f:	00 00 00 
  8041600f42:	ff d0                	callq  *%rax
  8041600f44:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
      if (buf && bufsize >= sizeof(bool)) {
  8041600f48:	48 85 db             	test   %rbx,%rbx
  8041600f4b:	0f 84 17 06 00 00    	je     8041601568 <dwarf_read_abbrev_entry+0x988>
  8041600f51:	45 85 e4             	test   %r12d,%r12d
  8041600f54:	0f 84 0e 06 00 00    	je     8041601568 <dwarf_read_abbrev_entry+0x988>
      bool data = get_unaligned(entry, Dwarf_Small);
  8041600f5a:	84 c0                	test   %al,%al
        put_unaligned(data, (bool *)buf);
  8041600f5c:	0f 95 03             	setne  (%rbx)
      bytes = sizeof(Dwarf_Small);
  8041600f5f:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        put_unaligned(data, (bool *)buf);
  8041600f65:	e9 21 fd ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      int count = dwarf_read_leb128(entry, &data);
  8041600f6a:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8041600f6e:	4c 89 c0             	mov    %r8,%rax
  int result, shift;
  int num_bits;
  int count;

  result = 0;
  shift  = 0;
  8041600f71:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041600f76:	bf 00 00 00 00       	mov    $0x0,%edi
  count  = 0;

  while (1) {
    byte = *addr;
  8041600f7b:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041600f7e:	48 83 c0 01          	add    $0x1,%rax
    result |= (byte & 0x7f) << shift;
  8041600f82:	89 f2                	mov    %esi,%edx
  8041600f84:	83 e2 7f             	and    $0x7f,%edx
  8041600f87:	d3 e2                	shl    %cl,%edx
  8041600f89:	09 d7                	or     %edx,%edi
    shift += 7;
  8041600f8b:	83 c1 07             	add    $0x7,%ecx
  8041600f8e:	41 89 c5             	mov    %eax,%r13d
  8041600f91:	45 29 c5             	sub    %r8d,%r13d
    count++;

    if (!(byte & 0x80))
  8041600f94:	40 84 f6             	test   %sil,%sil
  8041600f97:	78 e2                	js     8041600f7b <dwarf_read_abbrev_entry+0x39b>
  }

  /* The number of bits in a signed integer. */
  num_bits = 8 * sizeof(result);

  if ((shift < num_bits) && (byte & 0x40))
  8041600f99:	83 f9 1f             	cmp    $0x1f,%ecx
  8041600f9c:	7f 0f                	jg     8041600fad <dwarf_read_abbrev_entry+0x3cd>
  8041600f9e:	40 f6 c6 40          	test   $0x40,%sil
  8041600fa2:	74 09                	je     8041600fad <dwarf_read_abbrev_entry+0x3cd>
    result |= (-1U << shift);
  8041600fa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8041600fa9:	d3 e0                	shl    %cl,%eax
  8041600fab:	09 c7                	or     %eax,%edi

  *ret = result;

  return count;
  8041600fad:	49 63 c5             	movslq %r13d,%rax
      entry += count;
  8041600fb0:	49 01 c0             	add    %rax,%r8
  8041600fb3:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(int)) {
  8041600fb7:	48 85 db             	test   %rbx,%rbx
  8041600fba:	0f 84 cb fc ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  8041600fc0:	41 83 fc 03          	cmp    $0x3,%r12d
  8041600fc4:	0f 86 c1 fc ff ff    	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (int *)buf);
  8041600fca:	89 7d d0             	mov    %edi,-0x30(%rbp)
  8041600fcd:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600fd2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600fd6:	48 89 df             	mov    %rbx,%rdi
  8041600fd9:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041600fe0:	00 00 00 
  8041600fe3:	ff d0                	callq  *%rax
  8041600fe5:	e9 a1 fc ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      int count            = dwarf_entry_len(entry, &length);
  8041600fea:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
  initial_len = get_unaligned(addr, uint32_t);
  8041600fee:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600ff3:	4c 89 f6             	mov    %r14,%rsi
  8041600ff6:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600ffa:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601001:	00 00 00 
  8041601004:	ff d0                	callq  *%rax
  8041601006:	8b 45 d0             	mov    -0x30(%rbp),%eax
    *len = initial_len;
  8041601009:	89 c2                	mov    %eax,%edx
  count       = 4;
  804160100b:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601011:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601014:	76 2b                	jbe    8041601041 <dwarf_read_abbrev_entry+0x461>
    if (initial_len == DW_EXT_DWARF64) {
  8041601016:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041601019:	74 61                	je     804160107c <dwarf_read_abbrev_entry+0x49c>
      cprintf("Unknown DWARF extension\n");
  804160101b:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041601022:	00 00 00 
  8041601025:	b8 00 00 00 00       	mov    $0x0,%eax
  804160102a:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041601031:	00 00 00 
  8041601034:	ff d2                	callq  *%rdx
      unsigned long length = 0;
  8041601036:	ba 00 00 00 00       	mov    $0x0,%edx
      count = 0;
  804160103b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      entry += count;
  8041601041:	49 63 c5             	movslq %r13d,%rax
  8041601044:	48 01 45 c8          	add    %rax,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned long)) {
  8041601048:	48 85 db             	test   %rbx,%rbx
  804160104b:	0f 84 3a fc ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  8041601051:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601055:	0f 86 30 fc ff ff    	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(length, (unsigned long *)buf);
  804160105b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804160105f:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601064:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601068:	48 89 df             	mov    %rbx,%rdi
  804160106b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601072:	00 00 00 
  8041601075:	ff d0                	callq  *%rax
  8041601077:	e9 0f fc ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160107c:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041601080:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601085:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601089:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601090:	00 00 00 
  8041601093:	ff d0                	callq  *%rax
  8041601095:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
      count = 12;
  8041601099:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  804160109f:	eb a0                	jmp    8041601041 <dwarf_read_abbrev_entry+0x461>
      int count         = dwarf_read_uleb128(entry, &data);
  80416010a1:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  80416010a5:	4c 89 c0             	mov    %r8,%rax
  shift  = 0;
  80416010a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416010ad:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  80416010b2:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416010b5:	48 83 c0 01          	add    $0x1,%rax
  80416010b9:	41 89 c5             	mov    %eax,%r13d
  80416010bc:	45 29 c5             	sub    %r8d,%r13d
    result |= (byte & 0x7f) << shift;
  80416010bf:	89 f2                	mov    %esi,%edx
  80416010c1:	83 e2 7f             	and    $0x7f,%edx
  80416010c4:	d3 e2                	shl    %cl,%edx
  80416010c6:	09 d7                	or     %edx,%edi
    shift += 7;
  80416010c8:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416010cb:	40 84 f6             	test   %sil,%sil
  80416010ce:	78 e2                	js     80416010b2 <dwarf_read_abbrev_entry+0x4d2>
  return count;
  80416010d0:	49 63 c5             	movslq %r13d,%rax
      entry += count;
  80416010d3:	49 01 c0             	add    %rax,%r8
  80416010d6:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned int)) {
  80416010da:	48 85 db             	test   %rbx,%rbx
  80416010dd:	0f 84 a8 fb ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  80416010e3:	41 83 fc 03          	cmp    $0x3,%r12d
  80416010e7:	0f 86 9e fb ff ff    	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (unsigned int *)buf);
  80416010ed:	89 7d d0             	mov    %edi,-0x30(%rbp)
  80416010f0:	ba 04 00 00 00       	mov    $0x4,%edx
  80416010f5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80416010f9:	48 89 df             	mov    %rbx,%rdi
  80416010fc:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601103:	00 00 00 
  8041601106:	ff d0                	callq  *%rax
  8041601108:	e9 7e fb ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      int count            = dwarf_entry_len(entry, &length);
  804160110d:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
  initial_len = get_unaligned(addr, uint32_t);
  8041601111:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601116:	4c 89 f6             	mov    %r14,%rsi
  8041601119:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  804160111d:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601124:	00 00 00 
  8041601127:	ff d0                	callq  *%rax
  8041601129:	8b 45 d0             	mov    -0x30(%rbp),%eax
    *len = initial_len;
  804160112c:	89 c2                	mov    %eax,%edx
  count       = 4;
  804160112e:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601134:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601137:	76 2b                	jbe    8041601164 <dwarf_read_abbrev_entry+0x584>
    if (initial_len == DW_EXT_DWARF64) {
  8041601139:	83 f8 ff             	cmp    $0xffffffff,%eax
  804160113c:	74 61                	je     804160119f <dwarf_read_abbrev_entry+0x5bf>
      cprintf("Unknown DWARF extension\n");
  804160113e:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041601145:	00 00 00 
  8041601148:	b8 00 00 00 00       	mov    $0x0,%eax
  804160114d:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041601154:	00 00 00 
  8041601157:	ff d2                	callq  *%rdx
      unsigned long length = 0;
  8041601159:	ba 00 00 00 00       	mov    $0x0,%edx
      count = 0;
  804160115e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      entry += count;
  8041601164:	49 63 c5             	movslq %r13d,%rax
  8041601167:	48 01 45 c8          	add    %rax,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned long)) {
  804160116b:	48 85 db             	test   %rbx,%rbx
  804160116e:	0f 84 17 fb ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  8041601174:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601178:	0f 86 0d fb ff ff    	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(length, (unsigned long *)buf);
  804160117e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8041601182:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601187:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  804160118b:	48 89 df             	mov    %rbx,%rdi
  804160118e:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601195:	00 00 00 
  8041601198:	ff d0                	callq  *%rax
  804160119a:	e9 ec fa ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160119f:	49 8d 76 20          	lea    0x20(%r14),%rsi
  80416011a3:	ba 08 00 00 00       	mov    $0x8,%edx
  80416011a8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416011ac:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416011b3:	00 00 00 
  80416011b6:	ff d0                	callq  *%rax
  80416011b8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
      count = 12;
  80416011bc:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  80416011c2:	eb a0                	jmp    8041601164 <dwarf_read_abbrev_entry+0x584>
      Dwarf_Small data = get_unaligned(entry, Dwarf_Small);
  80416011c4:	ba 01 00 00 00       	mov    $0x1,%edx
  80416011c9:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80416011cd:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416011d1:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416011d8:	00 00 00 
  80416011db:	ff d0                	callq  *%rax
  80416011dd:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
      if (buf && bufsize >= sizeof(Dwarf_Small)) {
  80416011e1:	48 85 db             	test   %rbx,%rbx
  80416011e4:	0f 84 89 03 00 00    	je     8041601573 <dwarf_read_abbrev_entry+0x993>
  80416011ea:	45 85 e4             	test   %r12d,%r12d
  80416011ed:	0f 84 80 03 00 00    	je     8041601573 <dwarf_read_abbrev_entry+0x993>
        put_unaligned(data, (Dwarf_Small *)buf);
  80416011f3:	88 03                	mov    %al,(%rbx)
      bytes = sizeof(Dwarf_Small);
  80416011f5:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        put_unaligned(data, (Dwarf_Small *)buf);
  80416011fb:	e9 8b fa ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      Dwarf_Half data = get_unaligned(entry, Dwarf_Half);
  8041601200:	ba 02 00 00 00       	mov    $0x2,%edx
  8041601205:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601209:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  804160120d:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601214:	00 00 00 
  8041601217:	ff d0                	callq  *%rax
      entry += sizeof(Dwarf_Half);
  8041601219:	48 83 45 c8 02       	addq   $0x2,-0x38(%rbp)
      if (buf && bufsize >= sizeof(Dwarf_Half)) {
  804160121e:	48 85 db             	test   %rbx,%rbx
  8041601221:	74 06                	je     8041601229 <dwarf_read_abbrev_entry+0x649>
  8041601223:	41 83 fc 01          	cmp    $0x1,%r12d
  8041601227:	77 0b                	ja     8041601234 <dwarf_read_abbrev_entry+0x654>
      bytes = sizeof(Dwarf_Half);
  8041601229:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  804160122f:	e9 57 fa ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (Dwarf_Half *)buf);
  8041601234:	ba 02 00 00 00       	mov    $0x2,%edx
  8041601239:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  804160123d:	48 89 df             	mov    %rbx,%rdi
  8041601240:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601247:	00 00 00 
  804160124a:	ff d0                	callq  *%rax
      bytes = sizeof(Dwarf_Half);
  804160124c:	41 bd 02 00 00 00    	mov    $0x2,%r13d
        put_unaligned(data, (Dwarf_Half *)buf);
  8041601252:	e9 34 fa ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      uint32_t data = get_unaligned(entry, uint32_t);
  8041601257:	ba 04 00 00 00       	mov    $0x4,%edx
  804160125c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601260:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601264:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  804160126b:	00 00 00 
  804160126e:	ff d0                	callq  *%rax
      entry += sizeof(uint32_t);
  8041601270:	48 83 45 c8 04       	addq   $0x4,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint32_t)) {
  8041601275:	48 85 db             	test   %rbx,%rbx
  8041601278:	74 06                	je     8041601280 <dwarf_read_abbrev_entry+0x6a0>
  804160127a:	41 83 fc 03          	cmp    $0x3,%r12d
  804160127e:	77 0b                	ja     804160128b <dwarf_read_abbrev_entry+0x6ab>
      bytes = sizeof(uint32_t);
  8041601280:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  8041601286:	e9 00 fa ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint32_t *)buf);
  804160128b:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601290:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601294:	48 89 df             	mov    %rbx,%rdi
  8041601297:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  804160129e:	00 00 00 
  80416012a1:	ff d0                	callq  *%rax
      bytes = sizeof(uint32_t);
  80416012a3:	41 bd 04 00 00 00    	mov    $0x4,%r13d
        put_unaligned(data, (uint32_t *)buf);
  80416012a9:	e9 dd f9 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      uint64_t data = get_unaligned(entry, uint64_t);
  80416012ae:	ba 08 00 00 00       	mov    $0x8,%edx
  80416012b3:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80416012b7:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416012bb:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416012c2:	00 00 00 
  80416012c5:	ff d0                	callq  *%rax
      entry += sizeof(uint64_t);
  80416012c7:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint64_t)) {
  80416012cc:	48 85 db             	test   %rbx,%rbx
  80416012cf:	74 06                	je     80416012d7 <dwarf_read_abbrev_entry+0x6f7>
  80416012d1:	41 83 fc 07          	cmp    $0x7,%r12d
  80416012d5:	77 0b                	ja     80416012e2 <dwarf_read_abbrev_entry+0x702>
      bytes = sizeof(uint64_t);
  80416012d7:	41 bd 08 00 00 00    	mov    $0x8,%r13d
  80416012dd:	e9 a9 f9 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint64_t *)buf);
  80416012e2:	ba 08 00 00 00       	mov    $0x8,%edx
  80416012e7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80416012eb:	48 89 df             	mov    %rbx,%rdi
  80416012ee:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416012f5:	00 00 00 
  80416012f8:	ff d0                	callq  *%rax
      bytes = sizeof(uint64_t);
  80416012fa:	41 bd 08 00 00 00    	mov    $0x8,%r13d
        put_unaligned(data, (uint64_t *)buf);
  8041601300:	e9 86 f9 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      int count         = dwarf_read_uleb128(entry, &data);
  8041601305:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8041601309:	4c 89 c0             	mov    %r8,%rax
  shift  = 0;
  804160130c:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601311:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041601316:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601319:	48 83 c0 01          	add    $0x1,%rax
  804160131d:	41 89 c5             	mov    %eax,%r13d
  8041601320:	45 29 c5             	sub    %r8d,%r13d
    result |= (byte & 0x7f) << shift;
  8041601323:	89 f2                	mov    %esi,%edx
  8041601325:	83 e2 7f             	and    $0x7f,%edx
  8041601328:	d3 e2                	shl    %cl,%edx
  804160132a:	09 d7                	or     %edx,%edi
    shift += 7;
  804160132c:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160132f:	40 84 f6             	test   %sil,%sil
  8041601332:	78 e2                	js     8041601316 <dwarf_read_abbrev_entry+0x736>
  return count;
  8041601334:	49 63 c5             	movslq %r13d,%rax
      entry += count;
  8041601337:	49 01 c0             	add    %rax,%r8
  804160133a:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned int)) {
  804160133e:	48 85 db             	test   %rbx,%rbx
  8041601341:	0f 84 44 f9 ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  8041601347:	41 83 fc 03          	cmp    $0x3,%r12d
  804160134b:	0f 86 3a f9 ff ff    	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (unsigned int *)buf);
  8041601351:	89 7d d0             	mov    %edi,-0x30(%rbp)
  8041601354:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601359:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  804160135d:	48 89 df             	mov    %rbx,%rdi
  8041601360:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601367:	00 00 00 
  804160136a:	ff d0                	callq  *%rax
  804160136c:	e9 1a f9 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      int count         = dwarf_read_uleb128(entry, &form);
  8041601371:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8041601375:	48 89 f8             	mov    %rdi,%rax
  shift  = 0;
  8041601378:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160137d:	be 00 00 00 00       	mov    $0x0,%esi
    byte = *addr;
  8041601382:	44 0f b6 00          	movzbl (%rax),%r8d
    addr++;
  8041601386:	48 83 c0 01          	add    $0x1,%rax
  804160138a:	41 89 c6             	mov    %eax,%r14d
  804160138d:	41 29 fe             	sub    %edi,%r14d
    result |= (byte & 0x7f) << shift;
  8041601390:	44 89 c2             	mov    %r8d,%edx
  8041601393:	83 e2 7f             	and    $0x7f,%edx
  8041601396:	d3 e2                	shl    %cl,%edx
  8041601398:	09 d6                	or     %edx,%esi
    shift += 7;
  804160139a:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160139d:	45 84 c0             	test   %r8b,%r8b
  80416013a0:	78 e0                	js     8041601382 <dwarf_read_abbrev_entry+0x7a2>
  return count;
  80416013a2:	49 63 c6             	movslq %r14d,%rax
      entry += count;
  80416013a5:	48 01 c7             	add    %rax,%rdi
  80416013a8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
      int read = dwarf_read_abbrev_entry(entry, form, buf, bufsize,
  80416013ac:	45 89 e8             	mov    %r13d,%r8d
  80416013af:	44 89 e1             	mov    %r12d,%ecx
  80416013b2:	48 89 da             	mov    %rbx,%rdx
  80416013b5:	48 b8 e0 0b 60 41 80 	movabs $0x8041600be0,%rax
  80416013bc:	00 00 00 
  80416013bf:	ff d0                	callq  *%rax
      bytes    = count + read;
  80416013c1:	45 8d 2c 06          	lea    (%r14,%rax,1),%r13d
    } break;
  80416013c5:	e9 c1 f8 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      int count            = dwarf_entry_len(entry, &length);
  80416013ca:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
  initial_len = get_unaligned(addr, uint32_t);
  80416013ce:	ba 04 00 00 00       	mov    $0x4,%edx
  80416013d3:	4c 89 f6             	mov    %r14,%rsi
  80416013d6:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416013da:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416013e1:	00 00 00 
  80416013e4:	ff d0                	callq  *%rax
  80416013e6:	8b 45 d0             	mov    -0x30(%rbp),%eax
    *len = initial_len;
  80416013e9:	89 c2                	mov    %eax,%edx
  count       = 4;
  80416013eb:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416013f1:	83 f8 ef             	cmp    $0xffffffef,%eax
  80416013f4:	76 2b                	jbe    8041601421 <dwarf_read_abbrev_entry+0x841>
    if (initial_len == DW_EXT_DWARF64) {
  80416013f6:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416013f9:	74 61                	je     804160145c <dwarf_read_abbrev_entry+0x87c>
      cprintf("Unknown DWARF extension\n");
  80416013fb:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041601402:	00 00 00 
  8041601405:	b8 00 00 00 00       	mov    $0x0,%eax
  804160140a:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041601411:	00 00 00 
  8041601414:	ff d2                	callq  *%rdx
      unsigned long length = 0;
  8041601416:	ba 00 00 00 00       	mov    $0x0,%edx
      count = 0;
  804160141b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      entry += count;
  8041601421:	49 63 c5             	movslq %r13d,%rax
  8041601424:	48 01 45 c8          	add    %rax,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned long)) {
  8041601428:	48 85 db             	test   %rbx,%rbx
  804160142b:	0f 84 5a f8 ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
  8041601431:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601435:	0f 86 50 f8 ff ff    	jbe    8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(length, (unsigned long *)buf);
  804160143b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804160143f:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601444:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601448:	48 89 df             	mov    %rbx,%rdi
  804160144b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601452:	00 00 00 
  8041601455:	ff d0                	callq  *%rax
  8041601457:	e9 2f f8 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160145c:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041601460:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601465:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601469:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601470:	00 00 00 
  8041601473:	ff d0                	callq  *%rax
  8041601475:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
      count = 12;
  8041601479:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  804160147f:	eb a0                	jmp    8041601421 <dwarf_read_abbrev_entry+0x841>
      unsigned long count = dwarf_read_uleb128(entry, &length);
  8041601481:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601485:	48 89 f0             	mov    %rsi,%rax
  shift  = 0;
  8041601488:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160148d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041601493:	0f b6 38             	movzbl (%rax),%edi
    addr++;
  8041601496:	48 83 c0 01          	add    $0x1,%rax
  804160149a:	41 89 c6             	mov    %eax,%r14d
  804160149d:	41 29 f6             	sub    %esi,%r14d
    result |= (byte & 0x7f) << shift;
  80416014a0:	89 fa                	mov    %edi,%edx
  80416014a2:	83 e2 7f             	and    $0x7f,%edx
  80416014a5:	d3 e2                	shl    %cl,%edx
  80416014a7:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  80416014aa:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416014ad:	40 84 ff             	test   %dil,%dil
  80416014b0:	78 e1                	js     8041601493 <dwarf_read_abbrev_entry+0x8b3>
  return count;
  80416014b2:	49 63 c6             	movslq %r14d,%rax
      entry += count;
  80416014b5:	48 01 c6             	add    %rax,%rsi
  80416014b8:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
      if (buf) {
  80416014bc:	48 85 db             	test   %rbx,%rbx
  80416014bf:	74 1b                	je     80416014dc <dwarf_read_abbrev_entry+0x8fc>
        memcpy(buf, entry, MIN(length, bufsize));
  80416014c1:	45 39 ec             	cmp    %r13d,%r12d
  80416014c4:	44 89 e2             	mov    %r12d,%edx
  80416014c7:	41 0f 47 d5          	cmova  %r13d,%edx
  80416014cb:	89 d2                	mov    %edx,%edx
  80416014cd:	48 89 df             	mov    %rbx,%rdi
  80416014d0:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416014d7:	00 00 00 
  80416014da:	ff d0                	callq  *%rax
      bytes = count + length;
  80416014dc:	45 01 f5             	add    %r14d,%r13d
    } break;
  80416014df:	e9 a7 f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      bytes = 0;
  80416014e4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      if (buf && sizeof(buf) >= sizeof(bool)) {
  80416014ea:	48 85 d2             	test   %rdx,%rdx
  80416014ed:	0f 84 98 f7 ff ff    	je     8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(true, (bool *)buf);
  80416014f3:	c6 02 01             	movb   $0x1,(%rdx)
  80416014f6:	e9 90 f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      uint64_t data = get_unaligned(entry, uint64_t);
  80416014fb:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601500:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601504:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601508:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  804160150f:	00 00 00 
  8041601512:	ff d0                	callq  *%rax
      entry += sizeof(uint64_t);
  8041601514:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint64_t)) {
  8041601519:	48 85 db             	test   %rbx,%rbx
  804160151c:	74 06                	je     8041601524 <dwarf_read_abbrev_entry+0x944>
  804160151e:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601522:	77 0b                	ja     804160152f <dwarf_read_abbrev_entry+0x94f>
      bytes = sizeof(uint64_t);
  8041601524:	41 bd 08 00 00 00    	mov    $0x8,%r13d
  return bytes;
  804160152a:	e9 5c f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint64_t *)buf);
  804160152f:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601534:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601538:	48 89 df             	mov    %rbx,%rdi
  804160153b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601542:	00 00 00 
  8041601545:	ff d0                	callq  *%rax
      bytes = sizeof(uint64_t);
  8041601547:	41 bd 08 00 00 00    	mov    $0x8,%r13d
        put_unaligned(data, (uint64_t *)buf);
  804160154d:	e9 39 f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
  int bytes = 0;
  8041601552:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8041601558:	e9 2e f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      bytes = sizeof(Dwarf_Small);
  804160155d:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  8041601563:	e9 23 f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      bytes = sizeof(Dwarf_Small);
  8041601568:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  804160156e:	e9 18 f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>
      bytes = sizeof(Dwarf_Small);
  8041601573:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  8041601579:	e9 0d f7 ff ff       	jmpq   8041600c8b <dwarf_read_abbrev_entry+0xab>

000000804160157e <info_by_address>:
  return 0;
}

int
info_by_address(const struct Dwarf_Addrs *addrs, uintptr_t p,
                Dwarf_Off *store) {
  804160157e:	55                   	push   %rbp
  804160157f:	48 89 e5             	mov    %rsp,%rbp
  8041601582:	41 57                	push   %r15
  8041601584:	41 56                	push   %r14
  8041601586:	41 55                	push   %r13
  8041601588:	41 54                	push   %r12
  804160158a:	53                   	push   %rbx
  804160158b:	48 83 ec 48          	sub    $0x48,%rsp
  804160158f:	48 89 7d b0          	mov    %rdi,-0x50(%rbp)
  8041601593:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8041601597:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  const void *set = addrs->aranges_begin;
  804160159b:	4c 8b 77 10          	mov    0x10(%rdi),%r14
  initial_len = get_unaligned(addr, uint32_t);
  804160159f:	49 bc 41 56 60 41 80 	movabs $0x8041605641,%r12
  80416015a6:	00 00 00 
  80416015a9:	49 89 f5             	mov    %rsi,%r13
  80416015ac:	e9 c8 01 00 00       	jmpq   8041601779 <info_by_address+0x1fb>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416015b1:	49 8d 76 20          	lea    0x20(%r14),%rsi
  80416015b5:	ba 08 00 00 00       	mov    $0x8,%edx
  80416015ba:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416015be:	41 ff d4             	callq  *%r12
  80416015c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416015c5:	ba 0c 00 00 00       	mov    $0xc,%edx
  80416015ca:	eb 07                	jmp    80416015d3 <info_by_address+0x55>
    *len = initial_len;
  80416015cc:	89 c0                	mov    %eax,%eax
  count       = 4;
  80416015ce:	ba 04 00 00 00       	mov    $0x4,%edx
      set += count;
  80416015d3:	48 63 da             	movslq %edx,%rbx
  80416015d6:	48 89 5d b8          	mov    %rbx,-0x48(%rbp)
  80416015da:	4d 8d 3c 1e          	lea    (%r14,%rbx,1),%r15
    const void *set_end = set + len;
  80416015de:	49 8d 1c 07          	lea    (%r15,%rax,1),%rbx
    Dwarf_Half version = get_unaligned(set, Dwarf_Half);
  80416015e2:	ba 02 00 00 00       	mov    $0x2,%edx
  80416015e7:	4c 89 fe             	mov    %r15,%rsi
  80416015ea:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416015ee:	41 ff d4             	callq  *%r12
    set += sizeof(Dwarf_Half);
  80416015f1:	49 83 c7 02          	add    $0x2,%r15
    assert(version == 2);
  80416015f5:	66 83 7d c8 02       	cmpw   $0x2,-0x38(%rbp)
  80416015fa:	0f 85 80 00 00 00    	jne    8041601680 <info_by_address+0x102>
    Dwarf_Off offset = get_unaligned(set, uint32_t);
  8041601600:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601605:	4c 89 fe             	mov    %r15,%rsi
  8041601608:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160160c:	41 ff d4             	callq  *%r12
  804160160f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8041601612:	89 45 a8             	mov    %eax,-0x58(%rbp)
    set += count;
  8041601615:	4c 03 7d b8          	add    -0x48(%rbp),%r15
    Dwarf_Small address_size = get_unaligned(set++, Dwarf_Small);
  8041601619:	49 8d 47 01          	lea    0x1(%r15),%rax
  804160161d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8041601621:	ba 01 00 00 00       	mov    $0x1,%edx
  8041601626:	4c 89 fe             	mov    %r15,%rsi
  8041601629:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160162d:	41 ff d4             	callq  *%r12
    assert(address_size == 8);
  8041601630:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041601634:	75 7f                	jne    80416016b5 <info_by_address+0x137>
    Dwarf_Small segment_size = get_unaligned(set++, Dwarf_Small);
  8041601636:	49 83 c7 02          	add    $0x2,%r15
  804160163a:	ba 01 00 00 00       	mov    $0x1,%edx
  804160163f:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8041601643:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601647:	41 ff d4             	callq  *%r12
    assert(segment_size == 0);
  804160164a:	80 7d c8 00          	cmpb   $0x0,-0x38(%rbp)
  804160164e:	0f 85 96 00 00 00    	jne    80416016ea <info_by_address+0x16c>
    uint32_t remainder  = (set - header) % entry_size;
  8041601654:	4c 89 f8             	mov    %r15,%rax
  8041601657:	4c 29 f0             	sub    %r14,%rax
  804160165a:	48 99                	cqto   
  804160165c:	48 c1 ea 3c          	shr    $0x3c,%rdx
  8041601660:	48 01 d0             	add    %rdx,%rax
  8041601663:	83 e0 0f             	and    $0xf,%eax
    if (remainder) {
  8041601666:	48 29 d0             	sub    %rdx,%rax
  8041601669:	0f 84 b5 00 00 00    	je     8041601724 <info_by_address+0x1a6>
      set += 2 * address_size - remainder;
  804160166f:	ba 10 00 00 00       	mov    $0x10,%edx
  8041601674:	89 d1                	mov    %edx,%ecx
  8041601676:	29 c1                	sub    %eax,%ecx
  8041601678:	49 01 cf             	add    %rcx,%r15
  804160167b:	e9 a4 00 00 00       	jmpq   8041601724 <info_by_address+0x1a6>
    assert(version == 2);
  8041601680:	48 b9 fe 66 60 41 80 	movabs $0x80416066fe,%rcx
  8041601687:	00 00 00 
  804160168a:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601691:	00 00 00 
  8041601694:	be 20 00 00 00       	mov    $0x20,%esi
  8041601699:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416016a0:	00 00 00 
  80416016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  80416016a8:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416016af:	00 00 00 
  80416016b2:	41 ff d0             	callq  *%r8
    assert(address_size == 8);
  80416016b5:	48 b9 bb 66 60 41 80 	movabs $0x80416066bb,%rcx
  80416016bc:	00 00 00 
  80416016bf:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416016c6:	00 00 00 
  80416016c9:	be 24 00 00 00       	mov    $0x24,%esi
  80416016ce:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416016d5:	00 00 00 
  80416016d8:	b8 00 00 00 00       	mov    $0x0,%eax
  80416016dd:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416016e4:	00 00 00 
  80416016e7:	41 ff d0             	callq  *%r8
    assert(segment_size == 0);
  80416016ea:	48 b9 cd 66 60 41 80 	movabs $0x80416066cd,%rcx
  80416016f1:	00 00 00 
  80416016f4:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416016fb:	00 00 00 
  80416016fe:	be 26 00 00 00       	mov    $0x26,%esi
  8041601703:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  804160170a:	00 00 00 
  804160170d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601712:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601719:	00 00 00 
  804160171c:	41 ff d0             	callq  *%r8
    } while (set < set_end);
  804160171f:	4c 39 fb             	cmp    %r15,%rbx
  8041601722:	76 4d                	jbe    8041601771 <info_by_address+0x1f3>
      addr = (void *)get_unaligned(set, uintptr_t);
  8041601724:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601729:	4c 89 fe             	mov    %r15,%rsi
  804160172c:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601730:	41 ff d4             	callq  *%r12
  8041601733:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
      size = get_unaligned(set, uint32_t);
  8041601737:	49 8d 77 08          	lea    0x8(%r15),%rsi
  804160173b:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601740:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601744:	41 ff d4             	callq  *%r12
  8041601747:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804160174a:	49 83 c7 10          	add    $0x10,%r15
      if ((uintptr_t)addr <= p &&
  804160174e:	4d 39 f5             	cmp    %r14,%r13
  8041601751:	72 cc                	jb     804160171f <info_by_address+0x1a1>
      size = get_unaligned(set, uint32_t);
  8041601753:	89 c0                	mov    %eax,%eax
          p <= (uintptr_t)addr + size) {
  8041601755:	49 01 c6             	add    %rax,%r14
      if ((uintptr_t)addr <= p &&
  8041601758:	4d 39 f5             	cmp    %r14,%r13
  804160175b:	77 c2                	ja     804160171f <info_by_address+0x1a1>
    Dwarf_Off offset = get_unaligned(set, uint32_t);
  804160175d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8041601761:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  8041601764:	48 89 18             	mov    %rbx,(%rax)
        return 0;
  8041601767:	b8 00 00 00 00       	mov    $0x0,%eax
  804160176c:	e9 8c 04 00 00       	jmpq   8041601bfd <info_by_address+0x67f>
      set += address_size;
  8041601771:	4d 89 fe             	mov    %r15,%r14
    assert(set == set_end);
  8041601774:	4c 39 fb             	cmp    %r15,%rbx
  8041601777:	75 6e                	jne    80416017e7 <info_by_address+0x269>
  while ((unsigned char *)set < addrs->aranges_end) {
  8041601779:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  804160177d:	4c 3b 70 18          	cmp    0x18(%rax),%r14
  8041601781:	73 3f                	jae    80416017c2 <info_by_address+0x244>
  initial_len = get_unaligned(addr, uint32_t);
  8041601783:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601788:	4c 89 f6             	mov    %r14,%rsi
  804160178b:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160178f:	41 ff d4             	callq  *%r12
  8041601792:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601795:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601798:	0f 86 2e fe ff ff    	jbe    80416015cc <info_by_address+0x4e>
    if (initial_len == DW_EXT_DWARF64) {
  804160179e:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416017a1:	0f 84 0a fe ff ff    	je     80416015b1 <info_by_address+0x33>
      cprintf("Unknown DWARF extension\n");
  80416017a7:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  80416017ae:	00 00 00 
  80416017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416017b6:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416017bd:	00 00 00 
  80416017c0:	ff d2                	callq  *%rdx
  const void *entry = addrs->info_begin;
  80416017c2:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80416017c6:	48 8b 58 20          	mov    0x20(%rax),%rbx
  80416017ca:	48 89 5d b8          	mov    %rbx,-0x48(%rbp)
  while ((unsigned char *)entry < addrs->info_end) {
  80416017ce:	48 3b 58 28          	cmp    0x28(%rax),%rbx
  80416017d2:	0f 83 55 04 00 00    	jae    8041601c2d <info_by_address+0x6af>
        count = dwarf_read_abbrev_entry(
  80416017d8:	49 bf e0 0b 60 41 80 	movabs $0x8041600be0,%r15
  80416017df:	00 00 00 
  80416017e2:	e9 c8 03 00 00       	jmpq   8041601baf <info_by_address+0x631>
    assert(set == set_end);
  80416017e7:	48 b9 df 66 60 41 80 	movabs $0x80416066df,%rcx
  80416017ee:	00 00 00 
  80416017f1:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416017f8:	00 00 00 
  80416017fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  8041601800:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601807:	00 00 00 
  804160180a:	b8 00 00 00 00       	mov    $0x0,%eax
  804160180f:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601816:	00 00 00 
  8041601819:	41 ff d0             	callq  *%r8
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160181c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8041601820:	48 8d 70 20          	lea    0x20(%rax),%rsi
  8041601824:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601829:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160182d:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601834:	00 00 00 
  8041601837:	ff d0                	callq  *%rax
  8041601839:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  804160183d:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  8041601843:	eb 08                	jmp    804160184d <info_by_address+0x2cf>
    *len = initial_len;
  8041601845:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041601847:	41 bd 04 00 00 00    	mov    $0x4,%r13d
      entry += count;
  804160184d:	4d 63 ed             	movslq %r13d,%r13
  8041601850:	48 8b 5d b8          	mov    -0x48(%rbp),%rbx
  8041601854:	4e 8d 24 2b          	lea    (%rbx,%r13,1),%r12
    const void *entry_end = entry + len;
  8041601858:	4c 01 e0             	add    %r12,%rax
  804160185b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
    Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  804160185f:	ba 02 00 00 00       	mov    $0x2,%edx
  8041601864:	4c 89 e6             	mov    %r12,%rsi
  8041601867:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160186b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601872:	00 00 00 
  8041601875:	ff d0                	callq  *%rax
    entry += sizeof(Dwarf_Half);
  8041601877:	49 83 c4 02          	add    $0x2,%r12
    assert(version == 4 || version == 2);
  804160187b:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  804160187f:	83 e8 02             	sub    $0x2,%eax
  8041601882:	66 a9 fd ff          	test   $0xfffd,%ax
  8041601886:	0f 85 12 01 00 00    	jne    804160199e <info_by_address+0x420>
    Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  804160188c:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601891:	4c 89 e6             	mov    %r12,%rsi
  8041601894:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601898:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  804160189f:	00 00 00 
  80416018a2:	ff d0                	callq  *%rax
  80416018a4:	8b 5d c8             	mov    -0x38(%rbp),%ebx
    entry += count;
  80416018a7:	4b 8d 34 2c          	lea    (%r12,%r13,1),%rsi
    Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  80416018ab:	4c 8d 76 01          	lea    0x1(%rsi),%r14
  80416018af:	ba 01 00 00 00       	mov    $0x1,%edx
  80416018b4:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416018b8:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416018bf:	00 00 00 
  80416018c2:	ff d0                	callq  *%rax
    assert(address_size == 8);
  80416018c4:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  80416018c8:	0f 85 05 01 00 00    	jne    80416019d3 <info_by_address+0x455>
  80416018ce:	4c 89 f2             	mov    %r14,%rdx
  count  = 0;
  80416018d1:	bf 00 00 00 00       	mov    $0x0,%edi
  shift  = 0;
  80416018d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416018db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416018e1:	0f b6 32             	movzbl (%rdx),%esi
    addr++;
  80416018e4:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  80416018e8:	83 c7 01             	add    $0x1,%edi
    result |= (byte & 0x7f) << shift;
  80416018eb:	89 f0                	mov    %esi,%eax
  80416018ed:	83 e0 7f             	and    $0x7f,%eax
  80416018f0:	d3 e0                	shl    %cl,%eax
  80416018f2:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  80416018f5:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416018f8:	40 84 f6             	test   %sil,%sil
  80416018fb:	78 e4                	js     80416018e1 <info_by_address+0x363>
  return count;
  80416018fd:	48 63 ff             	movslq %edi,%rdi
    assert(abbrev_code != 0);
  8041601900:	45 85 c0             	test   %r8d,%r8d
  8041601903:	0f 84 ff 00 00 00    	je     8041601a08 <info_by_address+0x48a>
    entry += count;
  8041601909:	49 01 fe             	add    %rdi,%r14
    const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
  804160190c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041601910:	48 03 18             	add    (%rax),%rbx
  8041601913:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601916:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160191b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  8041601921:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601924:	48 83 c0 01          	add    $0x1,%rax
  8041601928:	89 c7                	mov    %eax,%edi
  804160192a:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  804160192c:	89 f2                	mov    %esi,%edx
  804160192e:	83 e2 7f             	and    $0x7f,%edx
  8041601931:	d3 e2                	shl    %cl,%edx
  8041601933:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  8041601936:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601939:	40 84 f6             	test   %sil,%sil
  804160193c:	78 e3                	js     8041601921 <info_by_address+0x3a3>
  return count;
  804160193e:	48 63 ff             	movslq %edi,%rdi
    abbrev_entry += count;
  8041601941:	48 01 fb             	add    %rdi,%rbx
    assert(table_abbrev_code == abbrev_code);
  8041601944:	45 39 c8             	cmp    %r9d,%r8d
  8041601947:	0f 85 f0 00 00 00    	jne    8041601a3d <info_by_address+0x4bf>
  804160194d:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601950:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601955:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  804160195a:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160195d:	48 83 c0 01          	add    $0x1,%rax
  8041601961:	41 89 c0             	mov    %eax,%r8d
  8041601964:	41 29 d8             	sub    %ebx,%r8d
    result |= (byte & 0x7f) << shift;
  8041601967:	89 f2                	mov    %esi,%edx
  8041601969:	83 e2 7f             	and    $0x7f,%edx
  804160196c:	d3 e2                	shl    %cl,%edx
  804160196e:	09 d7                	or     %edx,%edi
    shift += 7;
  8041601970:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601973:	40 84 f6             	test   %sil,%sil
  8041601976:	78 e2                	js     804160195a <info_by_address+0x3dc>
  return count;
  8041601978:	4d 63 c0             	movslq %r8d,%r8
    assert(tag == DW_TAG_compile_unit);
  804160197b:	83 ff 11             	cmp    $0x11,%edi
  804160197e:	0f 85 ee 00 00 00    	jne    8041601a72 <info_by_address+0x4f4>
    abbrev_entry++;
  8041601984:	4a 8d 5c 03 01       	lea    0x1(%rbx,%r8,1),%rbx
    uintptr_t low_pc = 0, high_pc = 0;
  8041601989:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8041601990:	00 
  8041601991:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8041601998:	00 
  8041601999:	e9 4a 01 00 00       	jmpq   8041601ae8 <info_by_address+0x56a>
    assert(version == 4 || version == 2);
  804160199e:	48 b9 ee 66 60 41 80 	movabs $0x80416066ee,%rcx
  80416019a5:	00 00 00 
  80416019a8:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416019af:	00 00 00 
  80416019b2:	be 40 01 00 00       	mov    $0x140,%esi
  80416019b7:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416019be:	00 00 00 
  80416019c1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416019c6:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416019cd:	00 00 00 
  80416019d0:	41 ff d0             	callq  *%r8
    assert(address_size == 8);
  80416019d3:	48 b9 bb 66 60 41 80 	movabs $0x80416066bb,%rcx
  80416019da:	00 00 00 
  80416019dd:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416019e4:	00 00 00 
  80416019e7:	be 44 01 00 00       	mov    $0x144,%esi
  80416019ec:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416019f3:	00 00 00 
  80416019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  80416019fb:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601a02:	00 00 00 
  8041601a05:	41 ff d0             	callq  *%r8
    assert(abbrev_code != 0);
  8041601a08:	48 b9 0b 67 60 41 80 	movabs $0x804160670b,%rcx
  8041601a0f:	00 00 00 
  8041601a12:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601a19:	00 00 00 
  8041601a1c:	be 49 01 00 00       	mov    $0x149,%esi
  8041601a21:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601a28:	00 00 00 
  8041601a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601a30:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601a37:	00 00 00 
  8041601a3a:	41 ff d0             	callq  *%r8
    assert(table_abbrev_code == abbrev_code);
  8041601a3d:	48 b9 40 68 60 41 80 	movabs $0x8041606840,%rcx
  8041601a44:	00 00 00 
  8041601a47:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601a4e:	00 00 00 
  8041601a51:	be 51 01 00 00       	mov    $0x151,%esi
  8041601a56:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601a5d:	00 00 00 
  8041601a60:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601a65:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601a6c:	00 00 00 
  8041601a6f:	41 ff d0             	callq  *%r8
    assert(tag == DW_TAG_compile_unit);
  8041601a72:	48 b9 1c 67 60 41 80 	movabs $0x804160671c,%rcx
  8041601a79:	00 00 00 
  8041601a7c:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601a83:	00 00 00 
  8041601a86:	be 55 01 00 00       	mov    $0x155,%esi
  8041601a8b:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601a92:	00 00 00 
  8041601a95:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601a9a:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601aa1:	00 00 00 
  8041601aa4:	41 ff d0             	callq  *%r8
        count = dwarf_read_abbrev_entry(
  8041601aa7:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601aad:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601ab2:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  8041601ab6:	44 89 ee             	mov    %r13d,%esi
  8041601ab9:	4c 89 f7             	mov    %r14,%rdi
  8041601abc:	41 ff d7             	callq  *%r15
  8041601abf:	eb 19                	jmp    8041601ada <info_by_address+0x55c>
        count = dwarf_read_abbrev_entry(
  8041601ac1:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041601acc:	ba 00 00 00 00       	mov    $0x0,%edx
  8041601ad1:	44 89 ee             	mov    %r13d,%esi
  8041601ad4:	4c 89 f7             	mov    %r14,%rdi
  8041601ad7:	41 ff d7             	callq  *%r15
      entry += count;
  8041601ada:	48 98                	cltq   
  8041601adc:	49 01 c6             	add    %rax,%r14
    } while (name != 0 || form != 0);
  8041601adf:	45 09 ec             	or     %r13d,%r12d
  8041601ae2:	0f 84 a5 00 00 00    	je     8041601b8d <info_by_address+0x60f>
  result = 0;
  8041601ae8:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601aeb:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601af0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041601af6:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601af9:	48 83 c0 01          	add    $0x1,%rax
  8041601afd:	89 c7                	mov    %eax,%edi
  8041601aff:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601b01:	89 f2                	mov    %esi,%edx
  8041601b03:	83 e2 7f             	and    $0x7f,%edx
  8041601b06:	d3 e2                	shl    %cl,%edx
  8041601b08:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041601b0b:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601b0e:	40 84 f6             	test   %sil,%sil
  8041601b11:	78 e3                	js     8041601af6 <info_by_address+0x578>
  return count;
  8041601b13:	48 63 ff             	movslq %edi,%rdi
      abbrev_entry += count;
  8041601b16:	48 01 fb             	add    %rdi,%rbx
  8041601b19:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601b21:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041601b27:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601b2a:	48 83 c0 01          	add    $0x1,%rax
  8041601b2e:	89 c7                	mov    %eax,%edi
  8041601b30:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601b32:	89 f2                	mov    %esi,%edx
  8041601b34:	83 e2 7f             	and    $0x7f,%edx
  8041601b37:	d3 e2                	shl    %cl,%edx
  8041601b39:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041601b3c:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601b3f:	40 84 f6             	test   %sil,%sil
  8041601b42:	78 e3                	js     8041601b27 <info_by_address+0x5a9>
  return count;
  8041601b44:	48 63 ff             	movslq %edi,%rdi
      abbrev_entry += count;
  8041601b47:	48 01 fb             	add    %rdi,%rbx
      if (name == DW_AT_low_pc) {
  8041601b4a:	41 83 fc 11          	cmp    $0x11,%r12d
  8041601b4e:	0f 84 53 ff ff ff    	je     8041601aa7 <info_by_address+0x529>
      } else if (name == DW_AT_high_pc) {
  8041601b54:	41 83 fc 12          	cmp    $0x12,%r12d
  8041601b58:	0f 85 63 ff ff ff    	jne    8041601ac1 <info_by_address+0x543>
        count = dwarf_read_abbrev_entry(
  8041601b5e:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601b64:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601b69:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8041601b6d:	44 89 ee             	mov    %r13d,%esi
  8041601b70:	4c 89 f7             	mov    %r14,%rdi
  8041601b73:	41 ff d7             	callq  *%r15
        if (form != DW_FORM_addr) {
  8041601b76:	41 83 fd 01          	cmp    $0x1,%r13d
  8041601b7a:	0f 84 b4 00 00 00    	je     8041601c34 <info_by_address+0x6b6>
          high_pc += low_pc;
  8041601b80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8041601b84:	48 01 55 c8          	add    %rdx,-0x38(%rbp)
  8041601b88:	e9 4d ff ff ff       	jmpq   8041601ada <info_by_address+0x55c>
    if (p >= low_pc && p <= high_pc) {
  8041601b8d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8041601b91:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8041601b95:	72 06                	jb     8041601b9d <info_by_address+0x61f>
  8041601b97:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041601b9b:	76 6f                	jbe    8041601c0c <info_by_address+0x68e>
    entry = entry_end;
  8041601b9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041601ba1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  while ((unsigned char *)entry < addrs->info_end) {
  8041601ba5:	48 8b 5d b0          	mov    -0x50(%rbp),%rbx
  8041601ba9:	48 3b 43 28          	cmp    0x28(%rbx),%rax
  8041601bad:	73 77                	jae    8041601c26 <info_by_address+0x6a8>
  initial_len = get_unaligned(addr, uint32_t);
  8041601baf:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601bb4:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8041601bb8:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601bbc:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601bc3:	00 00 00 
  8041601bc6:	ff d0                	callq  *%rax
  8041601bc8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601bcb:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601bce:	0f 86 71 fc ff ff    	jbe    8041601845 <info_by_address+0x2c7>
    if (initial_len == DW_EXT_DWARF64) {
  8041601bd4:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041601bd7:	0f 84 3f fc ff ff    	je     804160181c <info_by_address+0x29e>
      cprintf("Unknown DWARF extension\n");
  8041601bdd:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041601be4:	00 00 00 
  8041601be7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601bec:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041601bf3:	00 00 00 
  8041601bf6:	ff d2                	callq  *%rdx
      return -E_BAD_DWARF;
  8041601bf8:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  int code = info_by_address_debug_aranges(addrs, p, store);
  if (code < 0) {
    code = info_by_address_debug_info(addrs, p, store);
  }
  return code;
}
  8041601bfd:	48 83 c4 48          	add    $0x48,%rsp
  8041601c01:	5b                   	pop    %rbx
  8041601c02:	41 5c                	pop    %r12
  8041601c04:	41 5d                	pop    %r13
  8041601c06:	41 5e                	pop    %r14
  8041601c08:	41 5f                	pop    %r15
  8041601c0a:	5d                   	pop    %rbp
  8041601c0b:	c3                   	retq   
          (const unsigned char *)header - addrs->info_begin;
  8041601c0c:	48 8b 5d b0          	mov    -0x50(%rbp),%rbx
  8041601c10:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8041601c14:	48 2b 43 20          	sub    0x20(%rbx),%rax
      *store =
  8041601c18:	48 8b 5d 98          	mov    -0x68(%rbp),%rbx
  8041601c1c:	48 89 03             	mov    %rax,(%rbx)
      return 0;
  8041601c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601c24:	eb d7                	jmp    8041601bfd <info_by_address+0x67f>
  return 0;
  8041601c26:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601c2b:	eb d0                	jmp    8041601bfd <info_by_address+0x67f>
  8041601c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  return code;
  8041601c32:	eb c9                	jmp    8041601bfd <info_by_address+0x67f>
      entry += count;
  8041601c34:	48 98                	cltq   
  8041601c36:	49 01 c6             	add    %rax,%r14
  8041601c39:	e9 aa fe ff ff       	jmpq   8041601ae8 <info_by_address+0x56a>

0000008041601c3e <file_name_by_info>:

int
file_name_by_info(const struct Dwarf_Addrs *addrs, Dwarf_Off offset,
                  char *buf, int buflen, Dwarf_Off *line_off) {
  8041601c3e:	55                   	push   %rbp
  8041601c3f:	48 89 e5             	mov    %rsp,%rbp
  8041601c42:	41 57                	push   %r15
  8041601c44:	41 56                	push   %r14
  8041601c46:	41 55                	push   %r13
  8041601c48:	41 54                	push   %r12
  8041601c4a:	53                   	push   %rbx
  8041601c4b:	48 83 ec 38          	sub    $0x38,%rsp
  if (offset > addrs->info_end - addrs->info_begin) {
  8041601c4f:	48 8b 5f 20          	mov    0x20(%rdi),%rbx
  8041601c53:	48 8b 47 28          	mov    0x28(%rdi),%rax
  8041601c57:	48 29 d8             	sub    %rbx,%rax
  8041601c5a:	48 39 f0             	cmp    %rsi,%rax
  8041601c5d:	0f 82 e6 02 00 00    	jb     8041601f49 <file_name_by_info+0x30b>
  8041601c63:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
  8041601c67:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
  8041601c6a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8041601c6e:	48 89 7d a0          	mov    %rdi,-0x60(%rbp)
    return -E_INVAL;
  }
  const void *entry = addrs->info_begin + offset;
  8041601c72:	48 01 f3             	add    %rsi,%rbx
  initial_len = get_unaligned(addr, uint32_t);
  8041601c75:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601c7a:	48 89 de             	mov    %rbx,%rsi
  8041601c7d:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601c81:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601c88:	00 00 00 
  8041601c8b:	ff d0                	callq  *%rax
  8041601c8d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601c90:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601c93:	0f 86 b7 02 00 00    	jbe    8041601f50 <file_name_by_info+0x312>
    if (initial_len == DW_EXT_DWARF64) {
  8041601c99:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041601c9c:	74 25                	je     8041601cc3 <file_name_by_info+0x85>
      cprintf("Unknown DWARF extension\n");
  8041601c9e:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041601ca5:	00 00 00 
  8041601ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601cad:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041601cb4:	00 00 00 
  8041601cb7:	ff d2                	callq  *%rdx
  int count         = 0;
  unsigned long len = 0;
  count             = dwarf_entry_len(entry, &len);
  if (count == 0) {
    return -E_BAD_DWARF;
  8041601cb9:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  8041601cbe:	e9 77 02 00 00       	jmpq   8041601f3a <file_name_by_info+0x2fc>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041601cc3:	48 8d 73 20          	lea    0x20(%rbx),%rsi
  8041601cc7:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601ccc:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601cd0:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601cd7:	00 00 00 
  8041601cda:	ff d0                	callq  *%rax
      count = 12;
  8041601cdc:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  8041601ce2:	e9 6f 02 00 00       	jmpq   8041601f56 <file_name_by_info+0x318>
  }

  // Parse compilation unit header.
  Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  entry += sizeof(Dwarf_Half);
  assert(version == 4 || version == 2);
  8041601ce7:	48 b9 ee 66 60 41 80 	movabs $0x80416066ee,%rcx
  8041601cee:	00 00 00 
  8041601cf1:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601cf8:	00 00 00 
  8041601cfb:	be 98 01 00 00       	mov    $0x198,%esi
  8041601d00:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601d07:	00 00 00 
  8041601d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601d0f:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601d16:	00 00 00 
  8041601d19:	41 ff d0             	callq  *%r8
  Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  entry += count;
  Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  assert(address_size == 8);
  8041601d1c:	48 b9 bb 66 60 41 80 	movabs $0x80416066bb,%rcx
  8041601d23:	00 00 00 
  8041601d26:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601d2d:	00 00 00 
  8041601d30:	be 9c 01 00 00       	mov    $0x19c,%esi
  8041601d35:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601d3c:	00 00 00 
  8041601d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601d44:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601d4b:	00 00 00 
  8041601d4e:	41 ff d0             	callq  *%r8

  // Read abbreviation code
  unsigned abbrev_code = 0;
  count                = dwarf_read_uleb128(entry, &abbrev_code);
  assert(abbrev_code != 0);
  8041601d51:	48 b9 0b 67 60 41 80 	movabs $0x804160670b,%rcx
  8041601d58:	00 00 00 
  8041601d5b:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601d62:	00 00 00 
  8041601d65:	be a1 01 00 00       	mov    $0x1a1,%esi
  8041601d6a:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601d71:	00 00 00 
  8041601d74:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601d79:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601d80:	00 00 00 
  8041601d83:	41 ff d0             	callq  *%r8
  // Read abbreviations table
  const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
  unsigned table_abbrev_code = 0;
  count                      = dwarf_read_uleb128(abbrev_entry, &table_abbrev_code);
  abbrev_entry += count;
  assert(table_abbrev_code == abbrev_code);
  8041601d86:	48 b9 40 68 60 41 80 	movabs $0x8041606840,%rcx
  8041601d8d:	00 00 00 
  8041601d90:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601d97:	00 00 00 
  8041601d9a:	be a9 01 00 00       	mov    $0x1a9,%esi
  8041601d9f:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601da6:	00 00 00 
  8041601da9:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601dae:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601db5:	00 00 00 
  8041601db8:	41 ff d0             	callq  *%r8
  unsigned tag = 0;
  count        = dwarf_read_uleb128(abbrev_entry, &tag);
  abbrev_entry += count;
  assert(tag == DW_TAG_compile_unit);
  8041601dbb:	48 b9 1c 67 60 41 80 	movabs $0x804160671c,%rcx
  8041601dc2:	00 00 00 
  8041601dc5:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041601dcc:	00 00 00 
  8041601dcf:	be ad 01 00 00       	mov    $0x1ad,%esi
  8041601dd4:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041601ddb:	00 00 00 
  8041601dde:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601de3:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041601dea:	00 00 00 
  8041601ded:	41 ff d0             	callq  *%r8
    count = dwarf_read_uleb128(abbrev_entry, &name);
    abbrev_entry += count;
    count = dwarf_read_uleb128(abbrev_entry, &form);
    abbrev_entry += count;
    if (name == DW_AT_name) {
      if (form == DW_FORM_strp) {
  8041601df0:	41 83 fd 0e          	cmp    $0xe,%r13d
  8041601df4:	0f 84 b8 00 00 00    	je     8041601eb2 <file_name_by_info+0x274>
                  offset,
              (char **)buf);
#pragma GCC diagnostic pop
        }
      } else {
        count = dwarf_read_abbrev_entry(
  8041601dfa:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601e00:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
  8041601e03:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8041601e07:	44 89 ee             	mov    %r13d,%esi
  8041601e0a:	4c 89 f7             	mov    %r14,%rdi
  8041601e0d:	41 ff d7             	callq  *%r15
                                      address_size);
    } else {
      count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
                                      address_size);
    }
    entry += count;
  8041601e10:	48 98                	cltq   
  8041601e12:	49 01 c6             	add    %rax,%r14
  } while (name != 0 || form != 0);
  8041601e15:	45 09 e5             	or     %r12d,%r13d
  8041601e18:	0f 84 17 01 00 00    	je     8041601f35 <file_name_by_info+0x2f7>
  result = 0;
  8041601e1e:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601e21:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601e26:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041601e2c:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601e2f:	48 83 c0 01          	add    $0x1,%rax
  8041601e33:	89 c7                	mov    %eax,%edi
  8041601e35:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601e37:	89 f2                	mov    %esi,%edx
  8041601e39:	83 e2 7f             	and    $0x7f,%edx
  8041601e3c:	d3 e2                	shl    %cl,%edx
  8041601e3e:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041601e41:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601e44:	40 84 f6             	test   %sil,%sil
  8041601e47:	78 e3                	js     8041601e2c <file_name_by_info+0x1ee>
  return count;
  8041601e49:	48 63 ff             	movslq %edi,%rdi
    abbrev_entry += count;
  8041601e4c:	48 01 fb             	add    %rdi,%rbx
  8041601e4f:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601e57:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041601e5d:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601e60:	48 83 c0 01          	add    $0x1,%rax
  8041601e64:	89 c7                	mov    %eax,%edi
  8041601e66:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601e68:	89 f2                	mov    %esi,%edx
  8041601e6a:	83 e2 7f             	and    $0x7f,%edx
  8041601e6d:	d3 e2                	shl    %cl,%edx
  8041601e6f:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041601e72:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601e75:	40 84 f6             	test   %sil,%sil
  8041601e78:	78 e3                	js     8041601e5d <file_name_by_info+0x21f>
  return count;
  8041601e7a:	48 63 ff             	movslq %edi,%rdi
    abbrev_entry += count;
  8041601e7d:	48 01 fb             	add    %rdi,%rbx
    if (name == DW_AT_name) {
  8041601e80:	41 83 fc 03          	cmp    $0x3,%r12d
  8041601e84:	0f 84 66 ff ff ff    	je     8041601df0 <file_name_by_info+0x1b2>
    } else if (name == DW_AT_stmt_list) {
  8041601e8a:	41 83 fc 10          	cmp    $0x10,%r12d
  8041601e8e:	0f 84 84 00 00 00    	je     8041601f18 <file_name_by_info+0x2da>
      count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
  8041601e94:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601e9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041601e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  8041601ea4:	44 89 ee             	mov    %r13d,%esi
  8041601ea7:	4c 89 f7             	mov    %r14,%rdi
  8041601eaa:	41 ff d7             	callq  *%r15
  8041601ead:	e9 5e ff ff ff       	jmpq   8041601e10 <file_name_by_info+0x1d2>
        unsigned long offset = 0;
  8041601eb2:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8041601eb9:	00 
        count                = dwarf_read_abbrev_entry(
  8041601eba:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601ec0:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601ec5:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  8041601ec9:	be 0e 00 00 00       	mov    $0xe,%esi
  8041601ece:	4c 89 f7             	mov    %r14,%rdi
  8041601ed1:	41 ff d7             	callq  *%r15
  8041601ed4:	41 89 c4             	mov    %eax,%r12d
        if (buf && buflen >= sizeof(const char **)) {
  8041601ed7:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8041601edb:	48 85 ff             	test   %rdi,%rdi
  8041601ede:	74 06                	je     8041601ee6 <file_name_by_info+0x2a8>
  8041601ee0:	83 7d b4 07          	cmpl   $0x7,-0x4c(%rbp)
  8041601ee4:	77 0b                	ja     8041601ef1 <file_name_by_info+0x2b3>
    entry += count;
  8041601ee6:	4d 63 e4             	movslq %r12d,%r12
  8041601ee9:	4d 01 e6             	add    %r12,%r14
  8041601eec:	e9 2d ff ff ff       	jmpq   8041601e1e <file_name_by_info+0x1e0>
          put_unaligned(
  8041601ef1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041601ef5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8041601ef9:	48 03 41 40          	add    0x40(%rcx),%rax
  8041601efd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8041601f01:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601f06:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8041601f0a:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601f11:	00 00 00 
  8041601f14:	ff d0                	callq  *%rax
  8041601f16:	eb ce                	jmp    8041601ee6 <file_name_by_info+0x2a8>
      count = dwarf_read_abbrev_entry(entry, form, line_off,
  8041601f18:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601f1e:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601f23:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8041601f27:	44 89 ee             	mov    %r13d,%esi
  8041601f2a:	4c 89 f7             	mov    %r14,%rdi
  8041601f2d:	41 ff d7             	callq  *%r15
  8041601f30:	e9 db fe ff ff       	jmpq   8041601e10 <file_name_by_info+0x1d2>

  return 0;
  8041601f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041601f3a:	48 83 c4 38          	add    $0x38,%rsp
  8041601f3e:	5b                   	pop    %rbx
  8041601f3f:	41 5c                	pop    %r12
  8041601f41:	41 5d                	pop    %r13
  8041601f43:	41 5e                	pop    %r14
  8041601f45:	41 5f                	pop    %r15
  8041601f47:	5d                   	pop    %rbp
  8041601f48:	c3                   	retq   
    return -E_INVAL;
  8041601f49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041601f4e:	eb ea                	jmp    8041601f3a <file_name_by_info+0x2fc>
  count       = 4;
  8041601f50:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    entry += count;
  8041601f56:	4d 63 ed             	movslq %r13d,%r13
  8041601f59:	4c 01 eb             	add    %r13,%rbx
  Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  8041601f5c:	ba 02 00 00 00       	mov    $0x2,%edx
  8041601f61:	48 89 de             	mov    %rbx,%rsi
  8041601f64:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601f68:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041601f6f:	00 00 00 
  8041601f72:	ff d0                	callq  *%rax
  entry += sizeof(Dwarf_Half);
  8041601f74:	48 83 c3 02          	add    $0x2,%rbx
  assert(version == 4 || version == 2);
  8041601f78:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041601f7c:	83 e8 02             	sub    $0x2,%eax
  8041601f7f:	66 a9 fd ff          	test   $0xfffd,%ax
  8041601f83:	0f 85 5e fd ff ff    	jne    8041601ce7 <file_name_by_info+0xa9>
  Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041601f89:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601f8e:	48 89 de             	mov    %rbx,%rsi
  8041601f91:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601f95:	49 bf 41 56 60 41 80 	movabs $0x8041605641,%r15
  8041601f9c:	00 00 00 
  8041601f9f:	41 ff d7             	callq  *%r15
  8041601fa2:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
  entry += count;
  8041601fa6:	4a 8d 34 2b          	lea    (%rbx,%r13,1),%rsi
  Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041601faa:	4c 8d 76 01          	lea    0x1(%rsi),%r14
  8041601fae:	ba 01 00 00 00       	mov    $0x1,%edx
  8041601fb3:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601fb7:	41 ff d7             	callq  *%r15
  assert(address_size == 8);
  8041601fba:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041601fbe:	0f 85 58 fd ff ff    	jne    8041601d1c <file_name_by_info+0xde>
  8041601fc4:	4c 89 f2             	mov    %r14,%rdx
  count  = 0;
  8041601fc7:	bf 00 00 00 00       	mov    $0x0,%edi
  shift  = 0;
  8041601fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601fd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  8041601fd7:	0f b6 32             	movzbl (%rdx),%esi
    addr++;
  8041601fda:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  8041601fde:	83 c7 01             	add    $0x1,%edi
    result |= (byte & 0x7f) << shift;
  8041601fe1:	89 f0                	mov    %esi,%eax
  8041601fe3:	83 e0 7f             	and    $0x7f,%eax
  8041601fe6:	d3 e0                	shl    %cl,%eax
  8041601fe8:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  8041601feb:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601fee:	40 84 f6             	test   %sil,%sil
  8041601ff1:	78 e4                	js     8041601fd7 <file_name_by_info+0x399>
  return count;
  8041601ff3:	48 63 ff             	movslq %edi,%rdi
  assert(abbrev_code != 0);
  8041601ff6:	45 85 c0             	test   %r8d,%r8d
  8041601ff9:	0f 84 52 fd ff ff    	je     8041601d51 <file_name_by_info+0x113>
  entry += count;
  8041601fff:	49 01 fe             	add    %rdi,%r14
  const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
  8041602002:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8041602006:	4c 03 20             	add    (%rax),%r12
  8041602009:	4c 89 e0             	mov    %r12,%rax
  shift  = 0;
  804160200c:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602011:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  8041602017:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160201a:	48 83 c0 01          	add    $0x1,%rax
  804160201e:	89 c7                	mov    %eax,%edi
  8041602020:	44 29 e7             	sub    %r12d,%edi
    result |= (byte & 0x7f) << shift;
  8041602023:	89 f2                	mov    %esi,%edx
  8041602025:	83 e2 7f             	and    $0x7f,%edx
  8041602028:	d3 e2                	shl    %cl,%edx
  804160202a:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  804160202d:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602030:	40 84 f6             	test   %sil,%sil
  8041602033:	78 e2                	js     8041602017 <file_name_by_info+0x3d9>
  return count;
  8041602035:	48 63 ff             	movslq %edi,%rdi
  abbrev_entry += count;
  8041602038:	49 01 fc             	add    %rdi,%r12
  assert(table_abbrev_code == abbrev_code);
  804160203b:	45 39 c8             	cmp    %r9d,%r8d
  804160203e:	0f 85 42 fd ff ff    	jne    8041601d86 <file_name_by_info+0x148>
  8041602044:	4c 89 e0             	mov    %r12,%rax
  shift  = 0;
  8041602047:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160204c:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602051:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602054:	48 83 c0 01          	add    $0x1,%rax
  8041602058:	41 89 c0             	mov    %eax,%r8d
  804160205b:	45 29 e0             	sub    %r12d,%r8d
    result |= (byte & 0x7f) << shift;
  804160205e:	89 f2                	mov    %esi,%edx
  8041602060:	83 e2 7f             	and    $0x7f,%edx
  8041602063:	d3 e2                	shl    %cl,%edx
  8041602065:	09 d7                	or     %edx,%edi
    shift += 7;
  8041602067:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160206a:	40 84 f6             	test   %sil,%sil
  804160206d:	78 e2                	js     8041602051 <file_name_by_info+0x413>
  return count;
  804160206f:	4d 63 c0             	movslq %r8d,%r8
  assert(tag == DW_TAG_compile_unit);
  8041602072:	83 ff 11             	cmp    $0x11,%edi
  8041602075:	0f 85 40 fd ff ff    	jne    8041601dbb <file_name_by_info+0x17d>
  abbrev_entry++;
  804160207b:	4b 8d 5c 04 01       	lea    0x1(%r12,%r8,1),%rbx
      count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
  8041602080:	49 bf e0 0b 60 41 80 	movabs $0x8041600be0,%r15
  8041602087:	00 00 00 
  804160208a:	e9 8f fd ff ff       	jmpq   8041601e1e <file_name_by_info+0x1e0>

000000804160208f <function_by_info>:

int
function_by_info(const struct Dwarf_Addrs *addrs, uintptr_t p,
                 Dwarf_Off cu_offset, char *buf, int buflen,
                 uintptr_t *offset) {
  804160208f:	55                   	push   %rbp
  8041602090:	48 89 e5             	mov    %rsp,%rbp
  8041602093:	41 57                	push   %r15
  8041602095:	41 56                	push   %r14
  8041602097:	41 55                	push   %r13
  8041602099:	41 54                	push   %r12
  804160209b:	53                   	push   %rbx
  804160209c:	48 83 ec 68          	sub    $0x68,%rsp
  80416020a0:	48 89 7d 90          	mov    %rdi,-0x70(%rbp)
  80416020a4:	48 89 b5 78 ff ff ff 	mov    %rsi,-0x88(%rbp)
  80416020ab:	48 89 4d 88          	mov    %rcx,-0x78(%rbp)
  80416020af:	44 89 45 a0          	mov    %r8d,-0x60(%rbp)
  80416020b3:	4c 89 8d 70 ff ff ff 	mov    %r9,-0x90(%rbp)
  const void *entry = addrs->info_begin + cu_offset;
  80416020ba:	48 89 d3             	mov    %rdx,%rbx
  80416020bd:	48 03 5f 20          	add    0x20(%rdi),%rbx
  initial_len = get_unaligned(addr, uint32_t);
  80416020c1:	ba 04 00 00 00       	mov    $0x4,%edx
  80416020c6:	48 89 de             	mov    %rbx,%rsi
  80416020c9:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416020cd:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416020d4:	00 00 00 
  80416020d7:	ff d0                	callq  *%rax
  80416020d9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416020dc:	83 f8 ef             	cmp    $0xffffffef,%eax
  80416020df:	76 59                	jbe    804160213a <function_by_info+0xab>
    if (initial_len == DW_EXT_DWARF64) {
  80416020e1:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416020e4:	74 2f                	je     8041602115 <function_by_info+0x86>
      cprintf("Unknown DWARF extension\n");
  80416020e6:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  80416020ed:	00 00 00 
  80416020f0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416020f5:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416020fc:	00 00 00 
  80416020ff:	ff d2                	callq  *%rdx
  int count         = 0;
  unsigned long len = 0;
  count             = dwarf_entry_len(entry, &len);
  if (count == 0) {
    return -E_BAD_DWARF;
  8041602101:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
        entry += count;
      } while (name != 0 || form != 0);
    }
  }
  return 0;
}
  8041602106:	48 83 c4 68          	add    $0x68,%rsp
  804160210a:	5b                   	pop    %rbx
  804160210b:	41 5c                	pop    %r12
  804160210d:	41 5d                	pop    %r13
  804160210f:	41 5e                	pop    %r14
  8041602111:	41 5f                	pop    %r15
  8041602113:	5d                   	pop    %rbp
  8041602114:	c3                   	retq   
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041602115:	48 8d 73 20          	lea    0x20(%rbx),%rsi
  8041602119:	ba 08 00 00 00       	mov    $0x8,%edx
  804160211e:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602122:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602129:	00 00 00 
  804160212c:	ff d0                	callq  *%rax
  804160212e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  8041602132:	41 be 0c 00 00 00    	mov    $0xc,%r14d
  8041602138:	eb 08                	jmp    8041602142 <function_by_info+0xb3>
    *len = initial_len;
  804160213a:	89 c0                	mov    %eax,%eax
  count       = 4;
  804160213c:	41 be 04 00 00 00    	mov    $0x4,%r14d
  entry += count;
  8041602142:	4d 63 f6             	movslq %r14d,%r14
  8041602145:	4c 01 f3             	add    %r14,%rbx
  const void *entry_end = entry + len;
  8041602148:	48 01 d8             	add    %rbx,%rax
  804160214b:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  804160214f:	ba 02 00 00 00       	mov    $0x2,%edx
  8041602154:	48 89 de             	mov    %rbx,%rsi
  8041602157:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160215b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602162:	00 00 00 
  8041602165:	ff d0                	callq  *%rax
  entry += sizeof(Dwarf_Half);
  8041602167:	48 83 c3 02          	add    $0x2,%rbx
  assert(version == 4 || version == 2);
  804160216b:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  804160216f:	83 e8 02             	sub    $0x2,%eax
  8041602172:	66 a9 fd ff          	test   $0xfffd,%ax
  8041602176:	75 51                	jne    80416021c9 <function_by_info+0x13a>
  Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041602178:	ba 04 00 00 00       	mov    $0x4,%edx
  804160217d:	48 89 de             	mov    %rbx,%rsi
  8041602180:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602184:	49 bc 41 56 60 41 80 	movabs $0x8041605641,%r12
  804160218b:	00 00 00 
  804160218e:	41 ff d4             	callq  *%r12
  8041602191:	44 8b 6d c8          	mov    -0x38(%rbp),%r13d
  entry += count;
  8041602195:	4a 8d 34 33          	lea    (%rbx,%r14,1),%rsi
  Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041602199:	4c 8d 76 01          	lea    0x1(%rsi),%r14
  804160219d:	ba 01 00 00 00       	mov    $0x1,%edx
  80416021a2:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416021a6:	41 ff d4             	callq  *%r12
  assert(address_size == 8);
  80416021a9:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  80416021ad:	75 4f                	jne    80416021fe <function_by_info+0x16f>
  const void *abbrev_entry      = addrs->abbrev_begin + abbrev_offset;
  80416021af:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80416021b3:	4c 03 28             	add    (%rax),%r13
  80416021b6:	4c 89 6d 80          	mov    %r13,-0x80(%rbp)
        count = dwarf_read_abbrev_entry(
  80416021ba:	49 bf e0 0b 60 41 80 	movabs $0x8041600be0,%r15
  80416021c1:	00 00 00 
  while (entry < entry_end) {
  80416021c4:	e9 ff 00 00 00       	jmpq   80416022c8 <function_by_info+0x239>
  assert(version == 4 || version == 2);
  80416021c9:	48 b9 ee 66 60 41 80 	movabs $0x80416066ee,%rcx
  80416021d0:	00 00 00 
  80416021d3:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416021da:	00 00 00 
  80416021dd:	be e6 01 00 00       	mov    $0x1e6,%esi
  80416021e2:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416021e9:	00 00 00 
  80416021ec:	b8 00 00 00 00       	mov    $0x0,%eax
  80416021f1:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416021f8:	00 00 00 
  80416021fb:	41 ff d0             	callq  *%r8
  assert(address_size == 8);
  80416021fe:	48 b9 bb 66 60 41 80 	movabs $0x80416066bb,%rcx
  8041602205:	00 00 00 
  8041602208:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  804160220f:	00 00 00 
  8041602212:	be ea 01 00 00       	mov    $0x1ea,%esi
  8041602217:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  804160221e:	00 00 00 
  8041602221:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602226:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  804160222d:	00 00 00 
  8041602230:	41 ff d0             	callq  *%r8
  8041602233:	48 89 c3             	mov    %rax,%rbx
    if (tag == DW_TAG_subprogram) {
  8041602236:	83 ff 2e             	cmp    $0x2e,%edi
  8041602239:	0f 84 ca 01 00 00    	je     8041602409 <function_by_info+0x37a>
            fn_name_entry = entry;
  804160223f:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602242:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602247:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  804160224d:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602250:	48 83 c0 01          	add    $0x1,%rax
  8041602254:	89 c7                	mov    %eax,%edi
  8041602256:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602258:	89 f2                	mov    %esi,%edx
  804160225a:	83 e2 7f             	and    $0x7f,%edx
  804160225d:	d3 e2                	shl    %cl,%edx
  804160225f:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602262:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602265:	40 84 f6             	test   %sil,%sil
  8041602268:	78 e3                	js     804160224d <function_by_info+0x1be>
  return count;
  804160226a:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160226d:	48 01 fb             	add    %rdi,%rbx
  8041602270:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602273:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602278:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  804160227e:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602281:	48 83 c0 01          	add    $0x1,%rax
  8041602285:	89 c7                	mov    %eax,%edi
  8041602287:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602289:	89 f2                	mov    %esi,%edx
  804160228b:	83 e2 7f             	and    $0x7f,%edx
  804160228e:	d3 e2                	shl    %cl,%edx
  8041602290:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602293:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602296:	40 84 f6             	test   %sil,%sil
  8041602299:	78 e3                	js     804160227e <function_by_info+0x1ef>
  return count;
  804160229b:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160229e:	48 01 fb             	add    %rdi,%rbx
        count = dwarf_read_abbrev_entry(
  80416022a1:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416022a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  80416022ac:	ba 00 00 00 00       	mov    $0x0,%edx
  80416022b1:	44 89 e6             	mov    %r12d,%esi
  80416022b4:	4c 89 f7             	mov    %r14,%rdi
  80416022b7:	41 ff d7             	callq  *%r15
        entry += count;
  80416022ba:	48 98                	cltq   
  80416022bc:	49 01 c6             	add    %rax,%r14
      } while (name != 0 || form != 0);
  80416022bf:	45 09 ec             	or     %r13d,%r12d
  80416022c2:	0f 85 77 ff ff ff    	jne    804160223f <function_by_info+0x1b0>
  while (entry < entry_end) {
  80416022c8:	4c 3b 75 98          	cmp    -0x68(%rbp),%r14
  80416022cc:	0f 83 11 03 00 00    	jae    80416025e3 <function_by_info+0x554>
                 uintptr_t *offset) {
  80416022d2:	4c 89 f0             	mov    %r14,%rax
  shift  = 0;
  80416022d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416022da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416022e0:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416022e3:	48 83 c0 01          	add    $0x1,%rax
  80416022e7:	89 c7                	mov    %eax,%edi
  80416022e9:	44 29 f7             	sub    %r14d,%edi
    result |= (byte & 0x7f) << shift;
  80416022ec:	89 f2                	mov    %esi,%edx
  80416022ee:	83 e2 7f             	and    $0x7f,%edx
  80416022f1:	d3 e2                	shl    %cl,%edx
  80416022f3:	41 09 d0             	or     %edx,%r8d
    shift += 7;
  80416022f6:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416022f9:	40 84 f6             	test   %sil,%sil
  80416022fc:	78 e2                	js     80416022e0 <function_by_info+0x251>
  return count;
  80416022fe:	48 63 ff             	movslq %edi,%rdi
    entry += count;
  8041602301:	49 01 fe             	add    %rdi,%r14
    if (abbrev_code == 0) {
  8041602304:	45 85 c0             	test   %r8d,%r8d
  8041602307:	0f 84 e0 02 00 00    	je     80416025ed <function_by_info+0x55e>
           addrs->abbrev_end) { // unsafe needs to be replaced
  804160230d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8041602311:	4c 8b 48 08          	mov    0x8(%rax),%r9
    curr_abbrev_entry = abbrev_entry;
  8041602315:	48 8b 5d 80          	mov    -0x80(%rbp),%rbx
    unsigned name = 0, form = 0, tag = 0;
  8041602319:	bf 00 00 00 00       	mov    $0x0,%edi
  804160231e:	48 89 d8             	mov    %rbx,%rax
    while ((const unsigned char *)curr_abbrev_entry <
  8041602321:	49 39 c1             	cmp    %rax,%r9
  8041602324:	0f 86 09 ff ff ff    	jbe    8041602233 <function_by_info+0x1a4>
  804160232a:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  804160232d:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602332:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    byte = *addr;
  8041602338:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  804160233b:	48 83 c2 01          	add    $0x1,%rdx
  804160233f:	41 89 d3             	mov    %edx,%r11d
  8041602342:	41 29 c3             	sub    %eax,%r11d
    result |= (byte & 0x7f) << shift;
  8041602345:	89 fe                	mov    %edi,%esi
  8041602347:	83 e6 7f             	and    $0x7f,%esi
  804160234a:	d3 e6                	shl    %cl,%esi
  804160234c:	41 09 f2             	or     %esi,%r10d
    shift += 7;
  804160234f:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602352:	40 84 ff             	test   %dil,%dil
  8041602355:	78 e1                	js     8041602338 <function_by_info+0x2a9>
  return count;
  8041602357:	4d 63 db             	movslq %r11d,%r11
      curr_abbrev_entry += count;
  804160235a:	49 01 c3             	add    %rax,%r11
  804160235d:	4c 89 d8             	mov    %r11,%rax
  shift  = 0;
  8041602360:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602365:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  804160236a:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160236d:	48 83 c0 01          	add    $0x1,%rax
  8041602371:	89 c3                	mov    %eax,%ebx
  8041602373:	44 29 db             	sub    %r11d,%ebx
    result |= (byte & 0x7f) << shift;
  8041602376:	89 f2                	mov    %esi,%edx
  8041602378:	83 e2 7f             	and    $0x7f,%edx
  804160237b:	d3 e2                	shl    %cl,%edx
  804160237d:	09 d7                	or     %edx,%edi
    shift += 7;
  804160237f:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602382:	40 84 f6             	test   %sil,%sil
  8041602385:	78 e3                	js     804160236a <function_by_info+0x2db>
  return count;
  8041602387:	48 63 db             	movslq %ebx,%rbx
      curr_abbrev_entry++;
  804160238a:	49 8d 44 1b 01       	lea    0x1(%r11,%rbx,1),%rax
      if (table_abbrev_code == abbrev_code) {
  804160238f:	45 39 d0             	cmp    %r10d,%r8d
  8041602392:	0f 84 9b fe ff ff    	je     8041602233 <function_by_info+0x1a4>
  result = 0;
  8041602398:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  804160239b:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416023a0:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    byte = *addr;
  80416023a6:	44 0f b6 1a          	movzbl (%rdx),%r11d
    addr++;
  80416023aa:	48 83 c2 01          	add    $0x1,%rdx
  80416023ae:	89 d3                	mov    %edx,%ebx
  80416023b0:	29 c3                	sub    %eax,%ebx
    result |= (byte & 0x7f) << shift;
  80416023b2:	44 89 de             	mov    %r11d,%esi
  80416023b5:	83 e6 7f             	and    $0x7f,%esi
  80416023b8:	d3 e6                	shl    %cl,%esi
  80416023ba:	41 09 f2             	or     %esi,%r10d
    shift += 7;
  80416023bd:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416023c0:	45 84 db             	test   %r11b,%r11b
  80416023c3:	78 e1                	js     80416023a6 <function_by_info+0x317>
  return count;
  80416023c5:	48 63 db             	movslq %ebx,%rbx
        curr_abbrev_entry += count;
  80416023c8:	48 01 c3             	add    %rax,%rbx
  80416023cb:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  80416023ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416023d3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  80416023d9:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416023dc:	48 83 c0 01          	add    $0x1,%rax
  80416023e0:	41 89 c3             	mov    %eax,%r11d
  80416023e3:	41 29 db             	sub    %ebx,%r11d
    result |= (byte & 0x7f) << shift;
  80416023e6:	89 f2                	mov    %esi,%edx
  80416023e8:	83 e2 7f             	and    $0x7f,%edx
  80416023eb:	d3 e2                	shl    %cl,%edx
  80416023ed:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  80416023f0:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416023f3:	40 84 f6             	test   %sil,%sil
  80416023f6:	78 e1                	js     80416023d9 <function_by_info+0x34a>
  return count;
  80416023f8:	4d 63 db             	movslq %r11d,%r11
        curr_abbrev_entry += count;
  80416023fb:	4a 8d 04 1b          	lea    (%rbx,%r11,1),%rax
      } while (name != 0 || form != 0);
  80416023ff:	45 09 d4             	or     %r10d,%r12d
  8041602402:	75 94                	jne    8041602398 <function_by_info+0x309>
  8041602404:	e9 18 ff ff ff       	jmpq   8041602321 <function_by_info+0x292>
      uintptr_t low_pc = 0, high_pc = 0;
  8041602409:	48 c7 45 b0 00 00 00 	movq   $0x0,-0x50(%rbp)
  8041602410:	00 
  8041602411:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8041602418:	00 
      unsigned name_form        = 0;
  8041602419:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%rbp)
      const void *fn_name_entry = 0;
  8041602420:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  8041602427:	00 
  8041602428:	eb 26                	jmp    8041602450 <function_by_info+0x3c1>
          count = dwarf_read_abbrev_entry(
  804160242a:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602430:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041602435:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
  8041602439:	44 89 ee             	mov    %r13d,%esi
  804160243c:	4c 89 f7             	mov    %r14,%rdi
  804160243f:	41 ff d7             	callq  *%r15
        entry += count;
  8041602442:	48 98                	cltq   
  8041602444:	49 01 c6             	add    %rax,%r14
      } while (name != 0 || form != 0);
  8041602447:	45 09 e5             	or     %r12d,%r13d
  804160244a:	0f 84 d9 00 00 00    	je     8041602529 <function_by_info+0x49a>
      const void *fn_name_entry = 0;
  8041602450:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602453:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602458:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  804160245e:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602461:	48 83 c0 01          	add    $0x1,%rax
  8041602465:	89 c7                	mov    %eax,%edi
  8041602467:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602469:	89 f2                	mov    %esi,%edx
  804160246b:	83 e2 7f             	and    $0x7f,%edx
  804160246e:	d3 e2                	shl    %cl,%edx
  8041602470:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602473:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602476:	40 84 f6             	test   %sil,%sil
  8041602479:	78 e3                	js     804160245e <function_by_info+0x3cf>
  return count;
  804160247b:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160247e:	48 01 fb             	add    %rdi,%rbx
  8041602481:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602484:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602489:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  804160248f:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602492:	48 83 c0 01          	add    $0x1,%rax
  8041602496:	89 c7                	mov    %eax,%edi
  8041602498:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  804160249a:	89 f2                	mov    %esi,%edx
  804160249c:	83 e2 7f             	and    $0x7f,%edx
  804160249f:	d3 e2                	shl    %cl,%edx
  80416024a1:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  80416024a4:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416024a7:	40 84 f6             	test   %sil,%sil
  80416024aa:	78 e3                	js     804160248f <function_by_info+0x400>
  return count;
  80416024ac:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  80416024af:	48 01 fb             	add    %rdi,%rbx
        if (name == DW_AT_low_pc) {
  80416024b2:	41 83 fc 11          	cmp    $0x11,%r12d
  80416024b6:	0f 84 6e ff ff ff    	je     804160242a <function_by_info+0x39b>
        } else if (name == DW_AT_high_pc) {
  80416024bc:	41 83 fc 12          	cmp    $0x12,%r12d
  80416024c0:	74 38                	je     80416024fa <function_by_info+0x46b>
    result |= (byte & 0x7f) << shift;
  80416024c2:	41 83 fc 03          	cmp    $0x3,%r12d
  80416024c6:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80416024c9:	41 0f 44 c5          	cmove  %r13d,%eax
  80416024cd:	89 45 a4             	mov    %eax,-0x5c(%rbp)
  80416024d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80416024d4:	49 0f 44 c6          	cmove  %r14,%rax
  80416024d8:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
          count = dwarf_read_abbrev_entry(
  80416024dc:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416024e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  80416024e7:	ba 00 00 00 00       	mov    $0x0,%edx
  80416024ec:	44 89 ee             	mov    %r13d,%esi
  80416024ef:	4c 89 f7             	mov    %r14,%rdi
  80416024f2:	41 ff d7             	callq  *%r15
  80416024f5:	e9 48 ff ff ff       	jmpq   8041602442 <function_by_info+0x3b3>
          count = dwarf_read_abbrev_entry(
  80416024fa:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602500:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041602505:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8041602509:	44 89 ee             	mov    %r13d,%esi
  804160250c:	4c 89 f7             	mov    %r14,%rdi
  804160250f:	41 ff d7             	callq  *%r15
          if (form != DW_FORM_addr) {
  8041602512:	41 83 fd 01          	cmp    $0x1,%r13d
  8041602516:	0f 84 e5 00 00 00    	je     8041602601 <function_by_info+0x572>
            high_pc += low_pc;
  804160251c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8041602520:	48 01 55 b8          	add    %rdx,-0x48(%rbp)
  8041602524:	e9 19 ff ff ff       	jmpq   8041602442 <function_by_info+0x3b3>
      if (p >= low_pc && p <= high_pc) {
  8041602529:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  804160252d:	48 8b bd 78 ff ff ff 	mov    -0x88(%rbp),%rdi
  8041602534:	48 39 f8             	cmp    %rdi,%rax
  8041602537:	0f 87 8b fd ff ff    	ja     80416022c8 <function_by_info+0x239>
  804160253d:	48 39 7d b8          	cmp    %rdi,-0x48(%rbp)
  8041602541:	0f 82 81 fd ff ff    	jb     80416022c8 <function_by_info+0x239>
        *offset = low_pc;
  8041602547:	48 8b bd 70 ff ff ff 	mov    -0x90(%rbp),%rdi
  804160254e:	48 89 07             	mov    %rax,(%rdi)
        if (name_form == DW_FORM_strp) {
  8041602551:	83 7d a4 0e          	cmpl   $0xe,-0x5c(%rbp)
  8041602555:	75 6a                	jne    80416025c1 <function_by_info+0x532>
          unsigned long str_offset = 0;
  8041602557:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804160255e:	00 
          count                    = dwarf_read_abbrev_entry(
  804160255f:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602565:	b9 08 00 00 00       	mov    $0x8,%ecx
  804160256a:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  804160256e:	be 0e 00 00 00       	mov    $0xe,%esi
  8041602573:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  8041602577:	48 b8 e0 0b 60 41 80 	movabs $0x8041600be0,%rax
  804160257e:	00 00 00 
  8041602581:	ff d0                	callq  *%rax
          if (buf &&
  8041602583:	48 8b 7d 88          	mov    -0x78(%rbp),%rdi
  8041602587:	48 85 ff             	test   %rdi,%rdi
  804160258a:	74 2b                	je     80416025b7 <function_by_info+0x528>
  804160258c:	83 7d a0 07          	cmpl   $0x7,-0x60(%rbp)
  8041602590:	76 25                	jbe    80416025b7 <function_by_info+0x528>
            put_unaligned(
  8041602592:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041602596:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  804160259a:	48 03 41 40          	add    0x40(%rcx),%rax
  804160259e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80416025a2:	ba 08 00 00 00       	mov    $0x8,%edx
  80416025a7:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80416025ab:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416025b2:	00 00 00 
  80416025b5:	ff d0                	callq  *%rax
        return 0;
  80416025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  80416025bc:	e9 45 fb ff ff       	jmpq   8041602106 <function_by_info+0x77>
          count = dwarf_read_abbrev_entry(
  80416025c1:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416025c7:	8b 4d a0             	mov    -0x60(%rbp),%ecx
  80416025ca:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  80416025ce:	8b 75 a4             	mov    -0x5c(%rbp),%esi
  80416025d1:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  80416025d5:	48 b8 e0 0b 60 41 80 	movabs $0x8041600be0,%rax
  80416025dc:	00 00 00 
  80416025df:	ff d0                	callq  *%rax
  80416025e1:	eb d4                	jmp    80416025b7 <function_by_info+0x528>
  return 0;
  80416025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  80416025e8:	e9 19 fb ff ff       	jmpq   8041602106 <function_by_info+0x77>
  while (entry < entry_end) {
  80416025ed:	4c 39 75 98          	cmp    %r14,-0x68(%rbp)
  80416025f1:	0f 87 db fc ff ff    	ja     80416022d2 <function_by_info+0x243>
  return 0;
  80416025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  80416025fc:	e9 05 fb ff ff       	jmpq   8041602106 <function_by_info+0x77>
        entry += count;
  8041602601:	48 98                	cltq   
  8041602603:	49 01 c6             	add    %rax,%r14
  8041602606:	e9 45 fe ff ff       	jmpq   8041602450 <function_by_info+0x3c1>

000000804160260b <address_by_fname>:

int
address_by_fname(const struct Dwarf_Addrs *addrs, const char *fname,
                 uintptr_t *offset) {
  804160260b:	55                   	push   %rbp
  804160260c:	48 89 e5             	mov    %rsp,%rbp
  804160260f:	41 57                	push   %r15
  8041602611:	41 56                	push   %r14
  8041602613:	41 55                	push   %r13
  8041602615:	41 54                	push   %r12
  8041602617:	53                   	push   %rbx
  8041602618:	48 83 ec 48          	sub    $0x48,%rsp
  804160261c:	48 89 fb             	mov    %rdi,%rbx
  804160261f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8041602623:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8041602627:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  const int flen = strlen(fname);
  804160262b:	48 89 f7             	mov    %rsi,%rdi
  804160262e:	48 b8 8b 53 60 41 80 	movabs $0x804160538b,%rax
  8041602635:	00 00 00 
  8041602638:	ff d0                	callq  *%rax
  if (flen == 0)
  804160263a:	85 c0                	test   %eax,%eax
  804160263c:	0f 84 39 04 00 00    	je     8041602a7b <address_by_fname+0x470>
    return 0;
  const void *pubnames_entry = addrs->pubnames_begin;
  8041602642:	4c 8b 63 50          	mov    0x50(%rbx),%r12
  initial_len = get_unaligned(addr, uint32_t);
  8041602646:	49 be 41 56 60 41 80 	movabs $0x8041605641,%r14
  804160264d:	00 00 00 
  int count                  = 0;
  unsigned long len          = 0;
  Dwarf_Off cu_offset        = 0;
  Dwarf_Off func_offset      = 0;
  // parse pubnames section
  while ((const unsigned char *)pubnames_entry < addrs->pubnames_end) {
  8041602650:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602654:	4c 39 60 58          	cmp    %r12,0x58(%rax)
  8041602658:	0f 86 13 04 00 00    	jbe    8041602a71 <address_by_fname+0x466>
  804160265e:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602663:	4c 89 e6             	mov    %r12,%rsi
  8041602666:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160266a:	41 ff d6             	callq  *%r14
  804160266d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041602670:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041602673:	76 52                	jbe    80416026c7 <address_by_fname+0xbc>
    if (initial_len == DW_EXT_DWARF64) {
  8041602675:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602678:	74 31                	je     80416026ab <address_by_fname+0xa0>
      cprintf("Unknown DWARF extension\n");
  804160267a:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041602681:	00 00 00 
  8041602684:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602689:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041602690:	00 00 00 
  8041602693:	ff d2                	callq  *%rdx
    count = dwarf_entry_len(pubnames_entry, &len);
    if (count == 0) {
      return -E_BAD_DWARF;
  8041602695:	bb fa ff ff ff       	mov    $0xfffffffa,%ebx
      }
      pubnames_entry += strlen(pubnames_entry) + 1;
    }
  }
  return 0;
}
  804160269a:	89 d8                	mov    %ebx,%eax
  804160269c:	48 83 c4 48          	add    $0x48,%rsp
  80416026a0:	5b                   	pop    %rbx
  80416026a1:	41 5c                	pop    %r12
  80416026a3:	41 5d                	pop    %r13
  80416026a5:	41 5e                	pop    %r14
  80416026a7:	41 5f                	pop    %r15
  80416026a9:	5d                   	pop    %rbp
  80416026aa:	c3                   	retq   
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416026ab:	49 8d 74 24 20       	lea    0x20(%r12),%rsi
  80416026b0:	ba 08 00 00 00       	mov    $0x8,%edx
  80416026b5:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416026b9:	41 ff d6             	callq  *%r14
  80416026bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416026c0:	ba 0c 00 00 00       	mov    $0xc,%edx
  80416026c5:	eb 07                	jmp    80416026ce <address_by_fname+0xc3>
    *len = initial_len;
  80416026c7:	89 c0                	mov    %eax,%eax
  count       = 4;
  80416026c9:	ba 04 00 00 00       	mov    $0x4,%edx
    pubnames_entry += count;
  80416026ce:	48 63 d2             	movslq %edx,%rdx
  80416026d1:	49 01 d4             	add    %rdx,%r12
    const void *pubnames_entry_end = pubnames_entry + len;
  80416026d4:	4c 01 e0             	add    %r12,%rax
  80416026d7:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    Dwarf_Half version             = get_unaligned(pubnames_entry, Dwarf_Half);
  80416026db:	ba 02 00 00 00       	mov    $0x2,%edx
  80416026e0:	4c 89 e6             	mov    %r12,%rsi
  80416026e3:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416026e7:	41 ff d6             	callq  *%r14
    pubnames_entry += sizeof(Dwarf_Half);
  80416026ea:	49 8d 74 24 02       	lea    0x2(%r12),%rsi
    assert(version == 2);
  80416026ef:	66 83 7d c8 02       	cmpw   $0x2,-0x38(%rbp)
  80416026f4:	0f 85 c8 00 00 00    	jne    80416027c2 <address_by_fname+0x1b7>
    cu_offset = get_unaligned(pubnames_entry, uint32_t);
  80416026fa:	ba 04 00 00 00       	mov    $0x4,%edx
  80416026ff:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602703:	41 ff d6             	callq  *%r14
  8041602706:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8041602709:	89 45 a4             	mov    %eax,-0x5c(%rbp)
    pubnames_entry += sizeof(uint32_t);
  804160270c:	49 8d 5c 24 06       	lea    0x6(%r12),%rbx
  initial_len = get_unaligned(addr, uint32_t);
  8041602711:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602716:	48 89 de             	mov    %rbx,%rsi
  8041602719:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160271d:	41 ff d6             	callq  *%r14
  8041602720:	8b 55 c8             	mov    -0x38(%rbp),%edx
  count       = 4;
  8041602723:	b8 04 00 00 00       	mov    $0x4,%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041602728:	83 fa ef             	cmp    $0xffffffef,%edx
  804160272b:	76 29                	jbe    8041602756 <address_by_fname+0x14b>
    if (initial_len == DW_EXT_DWARF64) {
  804160272d:	83 fa ff             	cmp    $0xffffffff,%edx
  8041602730:	0f 84 c1 00 00 00    	je     80416027f7 <address_by_fname+0x1ec>
      cprintf("Unknown DWARF extension\n");
  8041602736:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  804160273d:	00 00 00 
  8041602740:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602745:	48 b9 49 44 60 41 80 	movabs $0x8041604449,%rcx
  804160274c:	00 00 00 
  804160274f:	ff d1                	callq  *%rcx
      count = 0;
  8041602751:	b8 00 00 00 00       	mov    $0x0,%eax
    pubnames_entry += count;
  8041602756:	48 98                	cltq   
  8041602758:	4c 8d 24 03          	lea    (%rbx,%rax,1),%r12
    while (pubnames_entry < pubnames_entry_end) {
  804160275c:	4c 39 65 b8          	cmp    %r12,-0x48(%rbp)
  8041602760:	0f 86 ea fe ff ff    	jbe    8041602650 <address_by_fname+0x45>
      pubnames_entry += strlen(pubnames_entry) + 1;
  8041602766:	49 bf 8b 53 60 41 80 	movabs $0x804160538b,%r15
  804160276d:	00 00 00 
      func_offset = get_unaligned(pubnames_entry, uint32_t);
  8041602770:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602775:	4c 89 e6             	mov    %r12,%rsi
  8041602778:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160277c:	41 ff d6             	callq  *%r14
  804160277f:	44 8b 6d c8          	mov    -0x38(%rbp),%r13d
      pubnames_entry += sizeof(uint32_t);
  8041602783:	49 83 c4 04          	add    $0x4,%r12
      if (func_offset == 0) {
  8041602787:	4d 85 ed             	test   %r13,%r13
  804160278a:	0f 84 c0 fe ff ff    	je     8041602650 <address_by_fname+0x45>
      if (!strcmp(fname, pubnames_entry)) {
  8041602790:	4c 89 e6             	mov    %r12,%rsi
  8041602793:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
  8041602797:	48 b8 ad 54 60 41 80 	movabs $0x80416054ad,%rax
  804160279e:	00 00 00 
  80416027a1:	ff d0                	callq  *%rax
  80416027a3:	89 c3                	mov    %eax,%ebx
  80416027a5:	85 c0                	test   %eax,%eax
  80416027a7:	74 69                	je     8041602812 <address_by_fname+0x207>
      pubnames_entry += strlen(pubnames_entry) + 1;
  80416027a9:	4c 89 e7             	mov    %r12,%rdi
  80416027ac:	41 ff d7             	callq  *%r15
  80416027af:	83 c0 01             	add    $0x1,%eax
  80416027b2:	48 98                	cltq   
  80416027b4:	49 01 c4             	add    %rax,%r12
    while (pubnames_entry < pubnames_entry_end) {
  80416027b7:	4c 39 65 b8          	cmp    %r12,-0x48(%rbp)
  80416027bb:	77 b3                	ja     8041602770 <address_by_fname+0x165>
  80416027bd:	e9 8e fe ff ff       	jmpq   8041602650 <address_by_fname+0x45>
    assert(version == 2);
  80416027c2:	48 b9 fe 66 60 41 80 	movabs $0x80416066fe,%rcx
  80416027c9:	00 00 00 
  80416027cc:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416027d3:	00 00 00 
  80416027d6:	be 73 02 00 00       	mov    $0x273,%esi
  80416027db:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416027e2:	00 00 00 
  80416027e5:	b8 00 00 00 00       	mov    $0x0,%eax
  80416027ea:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416027f1:	00 00 00 
  80416027f4:	41 ff d0             	callq  *%r8
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416027f7:	49 8d 74 24 26       	lea    0x26(%r12),%rsi
  80416027fc:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602801:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602805:	41 ff d6             	callq  *%r14
      count = 12;
  8041602808:	b8 0c 00 00 00       	mov    $0xc,%eax
  804160280d:	e9 44 ff ff ff       	jmpq   8041602756 <address_by_fname+0x14b>
    cu_offset = get_unaligned(pubnames_entry, uint32_t);
  8041602812:	44 8b 75 a4          	mov    -0x5c(%rbp),%r14d
        const void *entry      = addrs->info_begin + cu_offset;
  8041602816:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804160281a:	4c 03 70 20          	add    0x20(%rax),%r14
        const void *func_entry = entry + func_offset;
  804160281e:	4d 01 f5             	add    %r14,%r13
  initial_len = get_unaligned(addr, uint32_t);
  8041602821:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602826:	4c 89 f6             	mov    %r14,%rsi
  8041602829:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160282d:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602834:	00 00 00 
  8041602837:	ff d0                	callq  *%rax
  8041602839:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  804160283c:	83 f8 ef             	cmp    $0xffffffef,%eax
  804160283f:	0f 86 40 02 00 00    	jbe    8041602a85 <address_by_fname+0x47a>
    if (initial_len == DW_EXT_DWARF64) {
  8041602845:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602848:	74 25                	je     804160286f <address_by_fname+0x264>
      cprintf("Unknown DWARF extension\n");
  804160284a:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041602851:	00 00 00 
  8041602854:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602859:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041602860:	00 00 00 
  8041602863:	ff d2                	callq  *%rdx
          return -E_BAD_DWARF;
  8041602865:	bb fa ff ff ff       	mov    $0xfffffffa,%ebx
  804160286a:	e9 2b fe ff ff       	jmpq   804160269a <address_by_fname+0x8f>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160286f:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041602873:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602878:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160287c:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602883:	00 00 00 
  8041602886:	ff d0                	callq  *%rax
      count = 12;
  8041602888:	b8 0c 00 00 00       	mov    $0xc,%eax
  804160288d:	e9 f8 01 00 00       	jmpq   8041602a8a <address_by_fname+0x47f>
        assert(version == 4 || version == 2);
  8041602892:	48 b9 ee 66 60 41 80 	movabs $0x80416066ee,%rcx
  8041602899:	00 00 00 
  804160289c:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416028a3:	00 00 00 
  80416028a6:	be 89 02 00 00       	mov    $0x289,%esi
  80416028ab:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416028b2:	00 00 00 
  80416028b5:	b8 00 00 00 00       	mov    $0x0,%eax
  80416028ba:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416028c1:	00 00 00 
  80416028c4:	41 ff d0             	callq  *%r8
        assert(address_size == 8);
  80416028c7:	48 b9 bb 66 60 41 80 	movabs $0x80416066bb,%rcx
  80416028ce:	00 00 00 
  80416028d1:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416028d8:	00 00 00 
  80416028db:	be 8e 02 00 00       	mov    $0x28e,%esi
  80416028e0:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  80416028e7:	00 00 00 
  80416028ea:	b8 00 00 00 00       	mov    $0x0,%eax
  80416028ef:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416028f6:	00 00 00 
  80416028f9:	41 ff d0             	callq  *%r8
        if (tag == DW_TAG_subprogram) {
  80416028fc:	41 83 f8 2e          	cmp    $0x2e,%r8d
  8041602900:	0f 84 93 00 00 00    	je     8041602999 <address_by_fname+0x38e>
  shift  = 0;
  8041602906:	89 d9                	mov    %ebx,%ecx
  8041602908:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  804160290b:	41 be 00 00 00 00    	mov    $0x0,%r14d
    byte = *addr;
  8041602911:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602914:	48 83 c0 01          	add    $0x1,%rax
  8041602918:	89 c7                	mov    %eax,%edi
  804160291a:	44 29 e7             	sub    %r12d,%edi
    result |= (byte & 0x7f) << shift;
  804160291d:	89 f2                	mov    %esi,%edx
  804160291f:	83 e2 7f             	and    $0x7f,%edx
  8041602922:	d3 e2                	shl    %cl,%edx
  8041602924:	41 09 d6             	or     %edx,%r14d
    shift += 7;
  8041602927:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160292a:	40 84 f6             	test   %sil,%sil
  804160292d:	78 e2                	js     8041602911 <address_by_fname+0x306>
  return count;
  804160292f:	48 63 ff             	movslq %edi,%rdi
            abbrev_entry += count;
  8041602932:	49 01 fc             	add    %rdi,%r12
  shift  = 0;
  8041602935:	89 d9                	mov    %ebx,%ecx
  8041602937:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  804160293a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041602940:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602943:	48 83 c0 01          	add    $0x1,%rax
  8041602947:	89 c7                	mov    %eax,%edi
  8041602949:	44 29 e7             	sub    %r12d,%edi
    result |= (byte & 0x7f) << shift;
  804160294c:	89 f2                	mov    %esi,%edx
  804160294e:	83 e2 7f             	and    $0x7f,%edx
  8041602951:	d3 e2                	shl    %cl,%edx
  8041602953:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602956:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602959:	40 84 f6             	test   %sil,%sil
  804160295c:	78 e2                	js     8041602940 <address_by_fname+0x335>
  return count;
  804160295e:	48 63 ff             	movslq %edi,%rdi
            abbrev_entry += count;
  8041602961:	49 01 fc             	add    %rdi,%r12
            count = dwarf_read_abbrev_entry(
  8041602964:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  804160296a:	b9 00 00 00 00       	mov    $0x0,%ecx
  804160296f:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602974:	44 89 ee             	mov    %r13d,%esi
  8041602977:	4c 89 ff             	mov    %r15,%rdi
  804160297a:	48 b8 e0 0b 60 41 80 	movabs $0x8041600be0,%rax
  8041602981:	00 00 00 
  8041602984:	ff d0                	callq  *%rax
            entry += count;
  8041602986:	48 98                	cltq   
  8041602988:	49 01 c7             	add    %rax,%r15
          } while (name != 0 || form != 0);
  804160298b:	45 09 f5             	or     %r14d,%r13d
  804160298e:	0f 85 72 ff ff ff    	jne    8041602906 <address_by_fname+0x2fb>
  8041602994:	e9 01 fd ff ff       	jmpq   804160269a <address_by_fname+0x8f>
          uintptr_t low_pc = 0;
  8041602999:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80416029a0:	00 
  80416029a1:	eb 2f                	jmp    80416029d2 <address_by_fname+0x3c7>
              count = dwarf_read_abbrev_entry(entry, form, &low_pc, sizeof(low_pc), address_size);
  80416029a3:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416029a9:	b9 08 00 00 00       	mov    $0x8,%ecx
  80416029ae:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  80416029b2:	44 89 f6             	mov    %r14d,%esi
  80416029b5:	4c 89 ff             	mov    %r15,%rdi
  80416029b8:	48 b8 e0 0b 60 41 80 	movabs $0x8041600be0,%rax
  80416029bf:	00 00 00 
  80416029c2:	ff d0                	callq  *%rax
            entry += count;
  80416029c4:	48 98                	cltq   
  80416029c6:	49 01 c7             	add    %rax,%r15
          } while (name || form);
  80416029c9:	45 09 ee             	or     %r13d,%r14d
  80416029cc:	0f 84 8f 00 00 00    	je     8041602a61 <address_by_fname+0x456>
  shift  = 0;
  80416029d2:	89 d9                	mov    %ebx,%ecx
  80416029d4:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  80416029d7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  80416029dd:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416029e0:	48 83 c0 01          	add    $0x1,%rax
  80416029e4:	89 c7                	mov    %eax,%edi
  80416029e6:	44 29 e7             	sub    %r12d,%edi
    result |= (byte & 0x7f) << shift;
  80416029e9:	89 f2                	mov    %esi,%edx
  80416029eb:	83 e2 7f             	and    $0x7f,%edx
  80416029ee:	d3 e2                	shl    %cl,%edx
  80416029f0:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  80416029f3:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416029f6:	40 84 f6             	test   %sil,%sil
  80416029f9:	78 e2                	js     80416029dd <address_by_fname+0x3d2>
  return count;
  80416029fb:	48 63 ff             	movslq %edi,%rdi
            abbrev_entry += count;
  80416029fe:	49 01 fc             	add    %rdi,%r12
  shift  = 0;
  8041602a01:	89 d9                	mov    %ebx,%ecx
  8041602a03:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  8041602a06:	41 be 00 00 00 00    	mov    $0x0,%r14d
    byte = *addr;
  8041602a0c:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602a0f:	48 83 c0 01          	add    $0x1,%rax
  8041602a13:	89 c7                	mov    %eax,%edi
  8041602a15:	44 29 e7             	sub    %r12d,%edi
    result |= (byte & 0x7f) << shift;
  8041602a18:	89 f2                	mov    %esi,%edx
  8041602a1a:	83 e2 7f             	and    $0x7f,%edx
  8041602a1d:	d3 e2                	shl    %cl,%edx
  8041602a1f:	41 09 d6             	or     %edx,%r14d
    shift += 7;
  8041602a22:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602a25:	40 84 f6             	test   %sil,%sil
  8041602a28:	78 e2                	js     8041602a0c <address_by_fname+0x401>
  return count;
  8041602a2a:	48 63 ff             	movslq %edi,%rdi
            abbrev_entry += count;
  8041602a2d:	49 01 fc             	add    %rdi,%r12
            if (name == DW_AT_low_pc) {
  8041602a30:	41 83 fd 11          	cmp    $0x11,%r13d
  8041602a34:	0f 84 69 ff ff ff    	je     80416029a3 <address_by_fname+0x398>
              count = dwarf_read_abbrev_entry(entry, form, NULL, 0, address_size);
  8041602a3a:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602a40:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041602a45:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602a4a:	44 89 f6             	mov    %r14d,%esi
  8041602a4d:	4c 89 ff             	mov    %r15,%rdi
  8041602a50:	48 b8 e0 0b 60 41 80 	movabs $0x8041600be0,%rax
  8041602a57:	00 00 00 
  8041602a5a:	ff d0                	callq  *%rax
  8041602a5c:	e9 63 ff ff ff       	jmpq   80416029c4 <address_by_fname+0x3b9>
          *offset = low_pc;
  8041602a61:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041602a65:	48 8b 7d 98          	mov    -0x68(%rbp),%rdi
  8041602a69:	48 89 07             	mov    %rax,(%rdi)
  8041602a6c:	e9 29 fc ff ff       	jmpq   804160269a <address_by_fname+0x8f>
  return 0;
  8041602a71:	bb 00 00 00 00       	mov    $0x0,%ebx
  8041602a76:	e9 1f fc ff ff       	jmpq   804160269a <address_by_fname+0x8f>
    return 0;
  8041602a7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8041602a80:	e9 15 fc ff ff       	jmpq   804160269a <address_by_fname+0x8f>
  count       = 4;
  8041602a85:	b8 04 00 00 00       	mov    $0x4,%eax
        entry += count;
  8041602a8a:	48 98                	cltq   
  8041602a8c:	49 01 c6             	add    %rax,%r14
        Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  8041602a8f:	ba 02 00 00 00       	mov    $0x2,%edx
  8041602a94:	4c 89 f6             	mov    %r14,%rsi
  8041602a97:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602a9b:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602aa2:	00 00 00 
  8041602aa5:	ff d0                	callq  *%rax
        entry += sizeof(Dwarf_Half);
  8041602aa7:	49 8d 76 02          	lea    0x2(%r14),%rsi
        assert(version == 4 || version == 2);
  8041602aab:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041602aaf:	83 e8 02             	sub    $0x2,%eax
  8041602ab2:	66 a9 fd ff          	test   $0xfffd,%ax
  8041602ab6:	0f 85 d6 fd ff ff    	jne    8041602892 <address_by_fname+0x287>
        Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041602abc:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602ac1:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602ac5:	49 bf 41 56 60 41 80 	movabs $0x8041605641,%r15
  8041602acc:	00 00 00 
  8041602acf:	41 ff d7             	callq  *%r15
  8041602ad2:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
        const void *abbrev_entry = addrs->abbrev_begin + abbrev_offset;
  8041602ad6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602ada:	4c 03 20             	add    (%rax),%r12
        entry += sizeof(uint32_t);
  8041602add:	49 8d 76 06          	lea    0x6(%r14),%rsi
        Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041602ae1:	ba 01 00 00 00       	mov    $0x1,%edx
  8041602ae6:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602aea:	41 ff d7             	callq  *%r15
        assert(address_size == 8);
  8041602aed:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041602af1:	0f 85 d0 fd ff ff    	jne    80416028c7 <address_by_fname+0x2bc>
  shift  = 0;
  8041602af7:	89 d9                	mov    %ebx,%ecx
  8041602af9:	4c 89 e8             	mov    %r13,%rax
  result = 0;
  8041602afc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  8041602b02:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602b05:	48 83 c0 01          	add    $0x1,%rax
  8041602b09:	89 c7                	mov    %eax,%edi
  8041602b0b:	44 29 ef             	sub    %r13d,%edi
    result |= (byte & 0x7f) << shift;
  8041602b0e:	89 f2                	mov    %esi,%edx
  8041602b10:	83 e2 7f             	and    $0x7f,%edx
  8041602b13:	d3 e2                	shl    %cl,%edx
  8041602b15:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  8041602b18:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602b1b:	40 84 f6             	test   %sil,%sil
  8041602b1e:	78 e2                	js     8041602b02 <address_by_fname+0x4f7>
  return count;
  8041602b20:	48 63 ff             	movslq %edi,%rdi
        entry += count;
  8041602b23:	4d 8d 7c 3d 00       	lea    0x0(%r13,%rdi,1),%r15
        while ((const unsigned char *)abbrev_entry < addrs->abbrev_end) { // unsafe needs
  8041602b28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602b2c:	4c 8b 50 08          	mov    0x8(%rax),%r10
        unsigned name = 0, form = 0, tag = 0;
  8041602b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        while ((const unsigned char *)abbrev_entry < addrs->abbrev_end) { // unsafe needs
  8041602b36:	4d 39 e2             	cmp    %r12,%r10
  8041602b39:	0f 86 bd fd ff ff    	jbe    80416028fc <address_by_fname+0x2f1>
  shift  = 0;
  8041602b3f:	89 d9                	mov    %ebx,%ecx
  8041602b41:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  8041602b44:	be 00 00 00 00       	mov    $0x0,%esi
    byte = *addr;
  8041602b49:	0f b6 38             	movzbl (%rax),%edi
    addr++;
  8041602b4c:	48 83 c0 01          	add    $0x1,%rax
  8041602b50:	41 89 c0             	mov    %eax,%r8d
  8041602b53:	45 29 e0             	sub    %r12d,%r8d
    result |= (byte & 0x7f) << shift;
  8041602b56:	89 fa                	mov    %edi,%edx
  8041602b58:	83 e2 7f             	and    $0x7f,%edx
  8041602b5b:	d3 e2                	shl    %cl,%edx
  8041602b5d:	09 d6                	or     %edx,%esi
    shift += 7;
  8041602b5f:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602b62:	40 84 ff             	test   %dil,%dil
  8041602b65:	78 e2                	js     8041602b49 <address_by_fname+0x53e>
  return count;
  8041602b67:	4d 63 c0             	movslq %r8d,%r8
          abbrev_entry += count;
  8041602b6a:	4d 01 c4             	add    %r8,%r12
  shift  = 0;
  8041602b6d:	89 d9                	mov    %ebx,%ecx
  8041602b6f:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  8041602b72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  8041602b78:	0f b6 38             	movzbl (%rax),%edi
    addr++;
  8041602b7b:	48 83 c0 01          	add    $0x1,%rax
  8041602b7f:	41 89 c3             	mov    %eax,%r11d
  8041602b82:	45 29 e3             	sub    %r12d,%r11d
    result |= (byte & 0x7f) << shift;
  8041602b85:	89 fa                	mov    %edi,%edx
  8041602b87:	83 e2 7f             	and    $0x7f,%edx
  8041602b8a:	d3 e2                	shl    %cl,%edx
  8041602b8c:	41 09 d0             	or     %edx,%r8d
    shift += 7;
  8041602b8f:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602b92:	40 84 ff             	test   %dil,%dil
  8041602b95:	78 e1                	js     8041602b78 <address_by_fname+0x56d>
  return count;
  8041602b97:	4d 63 db             	movslq %r11d,%r11
          abbrev_entry++;
  8041602b9a:	4f 8d 64 1c 01       	lea    0x1(%r12,%r11,1),%r12
          if (table_abbrev_code == abbrev_code) {
  8041602b9f:	41 39 f1             	cmp    %esi,%r9d
  8041602ba2:	0f 84 54 fd ff ff    	je     80416028fc <address_by_fname+0x2f1>
  shift  = 0;
  8041602ba8:	89 d9                	mov    %ebx,%ecx
  8041602baa:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  8041602bad:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602bb2:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602bb5:	48 83 c0 01          	add    $0x1,%rax
  8041602bb9:	41 89 c3             	mov    %eax,%r11d
  8041602bbc:	45 29 e3             	sub    %r12d,%r11d
    result |= (byte & 0x7f) << shift;
  8041602bbf:	89 f2                	mov    %esi,%edx
  8041602bc1:	83 e2 7f             	and    $0x7f,%edx
  8041602bc4:	d3 e2                	shl    %cl,%edx
  8041602bc6:	09 d7                	or     %edx,%edi
    shift += 7;
  8041602bc8:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602bcb:	40 84 f6             	test   %sil,%sil
  8041602bce:	78 e2                	js     8041602bb2 <address_by_fname+0x5a7>
  return count;
  8041602bd0:	4d 63 db             	movslq %r11d,%r11
            abbrev_entry += count;
  8041602bd3:	4d 01 dc             	add    %r11,%r12
  shift  = 0;
  8041602bd6:	89 d9                	mov    %ebx,%ecx
  8041602bd8:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  8041602bdb:	41 bb 00 00 00 00    	mov    $0x0,%r11d
    byte = *addr;
  8041602be1:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602be4:	48 83 c0 01          	add    $0x1,%rax
  8041602be8:	41 89 c5             	mov    %eax,%r13d
  8041602beb:	45 29 e5             	sub    %r12d,%r13d
    result |= (byte & 0x7f) << shift;
  8041602bee:	89 f2                	mov    %esi,%edx
  8041602bf0:	83 e2 7f             	and    $0x7f,%edx
  8041602bf3:	d3 e2                	shl    %cl,%edx
  8041602bf5:	41 09 d3             	or     %edx,%r11d
    shift += 7;
  8041602bf8:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602bfb:	40 84 f6             	test   %sil,%sil
  8041602bfe:	78 e1                	js     8041602be1 <address_by_fname+0x5d6>
  return count;
  8041602c00:	4d 63 ed             	movslq %r13d,%r13
            abbrev_entry += count;
  8041602c03:	4d 01 ec             	add    %r13,%r12
          } while (name != 0 || form != 0);
  8041602c06:	41 09 fb             	or     %edi,%r11d
  8041602c09:	75 9d                	jne    8041602ba8 <address_by_fname+0x59d>
  8041602c0b:	e9 26 ff ff ff       	jmpq   8041602b36 <address_by_fname+0x52b>

0000008041602c10 <naive_address_by_fname>:

int
naive_address_by_fname(const struct Dwarf_Addrs *addrs, const char *fname,
                       uintptr_t *offset) {
  8041602c10:	55                   	push   %rbp
  8041602c11:	48 89 e5             	mov    %rsp,%rbp
  8041602c14:	41 57                	push   %r15
  8041602c16:	41 56                	push   %r14
  8041602c18:	41 55                	push   %r13
  8041602c1a:	41 54                	push   %r12
  8041602c1c:	53                   	push   %rbx
  8041602c1d:	48 83 ec 48          	sub    $0x48,%rsp
  8041602c21:	48 89 fb             	mov    %rdi,%rbx
  8041602c24:	48 89 7d b0          	mov    %rdi,-0x50(%rbp)
  8041602c28:	48 89 f7             	mov    %rsi,%rdi
  8041602c2b:	48 89 75 a8          	mov    %rsi,-0x58(%rbp)
  8041602c2f:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  const int flen = strlen(fname);
  8041602c33:	48 b8 8b 53 60 41 80 	movabs $0x804160538b,%rax
  8041602c3a:	00 00 00 
  8041602c3d:	ff d0                	callq  *%rax
  if (flen == 0)
  8041602c3f:	85 c0                	test   %eax,%eax
  8041602c41:	0f 84 09 05 00 00    	je     8041603150 <naive_address_by_fname+0x540>
    return 0;
  const void *entry = addrs->info_begin;
  8041602c47:	4c 8b 7b 20          	mov    0x20(%rbx),%r15
  int count         = 0;
  while ((const unsigned char *)entry < addrs->info_end) {
  8041602c4b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602c4f:	4c 39 78 28          	cmp    %r15,0x28(%rax)
  8041602c53:	0f 86 ed 04 00 00    	jbe    8041603146 <naive_address_by_fname+0x536>
  initial_len = get_unaligned(addr, uint32_t);
  8041602c59:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602c5e:	4c 89 fe             	mov    %r15,%rsi
  8041602c61:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602c65:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602c6c:	00 00 00 
  8041602c6f:	ff d0                	callq  *%rax
  8041602c71:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041602c74:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041602c77:	76 58                	jbe    8041602cd1 <naive_address_by_fname+0xc1>
    if (initial_len == DW_EXT_DWARF64) {
  8041602c79:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602c7c:	74 2f                	je     8041602cad <naive_address_by_fname+0x9d>
      cprintf("Unknown DWARF extension\n");
  8041602c7e:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041602c85:	00 00 00 
  8041602c88:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602c8d:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041602c94:	00 00 00 
  8041602c97:	ff d2                	callq  *%rdx
    unsigned long len = 0;
    count             = dwarf_entry_len(entry, &len);
    if (count == 0) {
      return -E_BAD_DWARF;
  8041602c99:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
      }
    }
  }

  return 0;
  8041602c9e:	48 83 c4 48          	add    $0x48,%rsp
  8041602ca2:	5b                   	pop    %rbx
  8041602ca3:	41 5c                	pop    %r12
  8041602ca5:	41 5d                	pop    %r13
  8041602ca7:	41 5e                	pop    %r14
  8041602ca9:	41 5f                	pop    %r15
  8041602cab:	5d                   	pop    %rbp
  8041602cac:	c3                   	retq   
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041602cad:	49 8d 77 20          	lea    0x20(%r15),%rsi
  8041602cb1:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602cb6:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602cba:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602cc1:	00 00 00 
  8041602cc4:	ff d0                	callq  *%rax
  8041602cc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  8041602cca:	bb 0c 00 00 00       	mov    $0xc,%ebx
  8041602ccf:	eb 07                	jmp    8041602cd8 <naive_address_by_fname+0xc8>
    *len = initial_len;
  8041602cd1:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041602cd3:	bb 04 00 00 00       	mov    $0x4,%ebx
    entry += count;
  8041602cd8:	48 63 db             	movslq %ebx,%rbx
  8041602cdb:	4d 8d 2c 1f          	lea    (%r15,%rbx,1),%r13
    const void *entry_end = entry + len;
  8041602cdf:	4c 01 e8             	add    %r13,%rax
  8041602ce2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
    Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  8041602ce6:	ba 02 00 00 00       	mov    $0x2,%edx
  8041602ceb:	4c 89 ee             	mov    %r13,%rsi
  8041602cee:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602cf2:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041602cf9:	00 00 00 
  8041602cfc:	ff d0                	callq  *%rax
    entry += sizeof(Dwarf_Half);
  8041602cfe:	49 83 c5 02          	add    $0x2,%r13
    assert(version == 4 || version == 2);
  8041602d02:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041602d06:	83 e8 02             	sub    $0x2,%eax
  8041602d09:	66 a9 fd ff          	test   $0xfffd,%ax
  8041602d0d:	75 52                	jne    8041602d61 <naive_address_by_fname+0x151>
    Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041602d0f:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602d14:	4c 89 ee             	mov    %r13,%rsi
  8041602d17:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602d1b:	49 be 41 56 60 41 80 	movabs $0x8041605641,%r14
  8041602d22:	00 00 00 
  8041602d25:	41 ff d6             	callq  *%r14
  8041602d28:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
    entry += count;
  8041602d2c:	49 8d 74 1d 00       	lea    0x0(%r13,%rbx,1),%rsi
    Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041602d31:	4c 8d 7e 01          	lea    0x1(%rsi),%r15
  8041602d35:	ba 01 00 00 00       	mov    $0x1,%edx
  8041602d3a:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602d3e:	41 ff d6             	callq  *%r14
    assert(address_size == 8);
  8041602d41:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041602d45:	75 4f                	jne    8041602d96 <naive_address_by_fname+0x186>
    const void *abbrev_entry      = addrs->abbrev_begin + abbrev_offset;
  8041602d47:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602d4b:	4c 03 20             	add    (%rax),%r12
  8041602d4e:	4c 89 65 98          	mov    %r12,-0x68(%rbp)
            count = dwarf_read_abbrev_entry(
  8041602d52:	49 be e0 0b 60 41 80 	movabs $0x8041600be0,%r14
  8041602d59:	00 00 00 
    while (entry < entry_end) {
  8041602d5c:	e9 0a 01 00 00       	jmpq   8041602e6b <naive_address_by_fname+0x25b>
    assert(version == 4 || version == 2);
  8041602d61:	48 b9 ee 66 60 41 80 	movabs $0x80416066ee,%rcx
  8041602d68:	00 00 00 
  8041602d6b:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041602d72:	00 00 00 
  8041602d75:	be f0 02 00 00       	mov    $0x2f0,%esi
  8041602d7a:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041602d81:	00 00 00 
  8041602d84:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602d89:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041602d90:	00 00 00 
  8041602d93:	41 ff d0             	callq  *%r8
    assert(address_size == 8);
  8041602d96:	48 b9 bb 66 60 41 80 	movabs $0x80416066bb,%rcx
  8041602d9d:	00 00 00 
  8041602da0:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041602da7:	00 00 00 
  8041602daa:	be f4 02 00 00       	mov    $0x2f4,%esi
  8041602daf:	48 bf ae 66 60 41 80 	movabs $0x80416066ae,%rdi
  8041602db6:	00 00 00 
  8041602db9:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602dbe:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041602dc5:	00 00 00 
  8041602dc8:	41 ff d0             	callq  *%r8
  8041602dcb:	48 89 c3             	mov    %rax,%rbx
      if (tag == DW_TAG_subprogram || tag == DW_TAG_label) {
  8041602dce:	41 83 f8 2e          	cmp    $0x2e,%r8d
  8041602dd2:	0f 84 d5 01 00 00    	je     8041602fad <naive_address_by_fname+0x39d>
  8041602dd8:	41 83 f8 0a          	cmp    $0xa,%r8d
  8041602ddc:	0f 84 cb 01 00 00    	je     8041602fad <naive_address_by_fname+0x39d>
                found = 1;
  8041602de2:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602de5:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602dea:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041602df0:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602df3:	48 83 c0 01          	add    $0x1,%rax
  8041602df7:	89 c7                	mov    %eax,%edi
  8041602df9:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602dfb:	89 f2                	mov    %esi,%edx
  8041602dfd:	83 e2 7f             	and    $0x7f,%edx
  8041602e00:	d3 e2                	shl    %cl,%edx
  8041602e02:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602e05:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602e08:	40 84 f6             	test   %sil,%sil
  8041602e0b:	78 e3                	js     8041602df0 <naive_address_by_fname+0x1e0>
  return count;
  8041602e0d:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041602e10:	48 01 fb             	add    %rdi,%rbx
  8041602e13:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602e16:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602e1b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041602e21:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602e24:	48 83 c0 01          	add    $0x1,%rax
  8041602e28:	89 c7                	mov    %eax,%edi
  8041602e2a:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602e2c:	89 f2                	mov    %esi,%edx
  8041602e2e:	83 e2 7f             	and    $0x7f,%edx
  8041602e31:	d3 e2                	shl    %cl,%edx
  8041602e33:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602e36:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602e39:	40 84 f6             	test   %sil,%sil
  8041602e3c:	78 e3                	js     8041602e21 <naive_address_by_fname+0x211>
  return count;
  8041602e3e:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041602e41:	48 01 fb             	add    %rdi,%rbx
          count = dwarf_read_abbrev_entry(
  8041602e44:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041602e4f:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602e54:	44 89 e6             	mov    %r12d,%esi
  8041602e57:	4c 89 ff             	mov    %r15,%rdi
  8041602e5a:	41 ff d6             	callq  *%r14
          entry += count;
  8041602e5d:	48 98                	cltq   
  8041602e5f:	49 01 c7             	add    %rax,%r15
        } while (name != 0 || form != 0);
  8041602e62:	45 09 ec             	or     %r13d,%r12d
  8041602e65:	0f 85 77 ff ff ff    	jne    8041602de2 <naive_address_by_fname+0x1d2>
    while (entry < entry_end) {
  8041602e6b:	4c 3b 7d a0          	cmp    -0x60(%rbp),%r15
  8041602e6f:	0f 83 d6 fd ff ff    	jae    8041602c4b <naive_address_by_fname+0x3b>
                       uintptr_t *offset) {
  8041602e75:	4c 89 f8             	mov    %r15,%rax
  shift  = 0;
  8041602e78:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602e7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  8041602e83:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602e86:	48 83 c0 01          	add    $0x1,%rax
  8041602e8a:	89 c7                	mov    %eax,%edi
  8041602e8c:	44 29 ff             	sub    %r15d,%edi
    result |= (byte & 0x7f) << shift;
  8041602e8f:	89 f2                	mov    %esi,%edx
  8041602e91:	83 e2 7f             	and    $0x7f,%edx
  8041602e94:	d3 e2                	shl    %cl,%edx
  8041602e96:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  8041602e99:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602e9c:	40 84 f6             	test   %sil,%sil
  8041602e9f:	78 e2                	js     8041602e83 <naive_address_by_fname+0x273>
  return count;
  8041602ea1:	48 63 ff             	movslq %edi,%rdi
      entry += count;
  8041602ea4:	49 01 ff             	add    %rdi,%r15
      if (abbrev_code == 0) {
  8041602ea7:	45 85 c9             	test   %r9d,%r9d
  8041602eaa:	0f 84 87 02 00 00    	je     8041603137 <naive_address_by_fname+0x527>
      while ((const unsigned char *)curr_abbrev_entry < addrs->abbrev_end) { // unsafe needs to be
  8041602eb0:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602eb4:	4c 8b 50 08          	mov    0x8(%rax),%r10
      curr_abbrev_entry = abbrev_entry;
  8041602eb8:	48 8b 5d 98          	mov    -0x68(%rbp),%rbx
      unsigned name = 0, form = 0, tag = 0;
  8041602ebc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8041602ec2:	48 89 d8             	mov    %rbx,%rax
      while ((const unsigned char *)curr_abbrev_entry < addrs->abbrev_end) { // unsafe needs to be
  8041602ec5:	49 39 c2             	cmp    %rax,%r10
  8041602ec8:	0f 86 fd fe ff ff    	jbe    8041602dcb <naive_address_by_fname+0x1bb>
  8041602ece:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  8041602ed1:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602ed6:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602edb:	44 0f b6 02          	movzbl (%rdx),%r8d
    addr++;
  8041602edf:	48 83 c2 01          	add    $0x1,%rdx
  8041602ee3:	41 89 d3             	mov    %edx,%r11d
  8041602ee6:	41 29 c3             	sub    %eax,%r11d
    result |= (byte & 0x7f) << shift;
  8041602ee9:	44 89 c6             	mov    %r8d,%esi
  8041602eec:	83 e6 7f             	and    $0x7f,%esi
  8041602eef:	d3 e6                	shl    %cl,%esi
  8041602ef1:	09 f7                	or     %esi,%edi
    shift += 7;
  8041602ef3:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602ef6:	45 84 c0             	test   %r8b,%r8b
  8041602ef9:	78 e0                	js     8041602edb <naive_address_by_fname+0x2cb>
  return count;
  8041602efb:	4d 63 db             	movslq %r11d,%r11
        curr_abbrev_entry += count;
  8041602efe:	49 01 c3             	add    %rax,%r11
  8041602f01:	4c 89 d8             	mov    %r11,%rax
  shift  = 0;
  8041602f04:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602f09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  8041602f0f:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602f12:	48 83 c0 01          	add    $0x1,%rax
  8041602f16:	89 c3                	mov    %eax,%ebx
  8041602f18:	44 29 db             	sub    %r11d,%ebx
    result |= (byte & 0x7f) << shift;
  8041602f1b:	89 f2                	mov    %esi,%edx
  8041602f1d:	83 e2 7f             	and    $0x7f,%edx
  8041602f20:	d3 e2                	shl    %cl,%edx
  8041602f22:	41 09 d0             	or     %edx,%r8d
    shift += 7;
  8041602f25:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602f28:	40 84 f6             	test   %sil,%sil
  8041602f2b:	78 e2                	js     8041602f0f <naive_address_by_fname+0x2ff>
  return count;
  8041602f2d:	48 63 db             	movslq %ebx,%rbx
        curr_abbrev_entry++;
  8041602f30:	49 8d 44 1b 01       	lea    0x1(%r11,%rbx,1),%rax
        if (table_abbrev_code == abbrev_code) {
  8041602f35:	41 39 f9             	cmp    %edi,%r9d
  8041602f38:	0f 84 8d fe ff ff    	je     8041602dcb <naive_address_by_fname+0x1bb>
  result = 0;
  8041602f3e:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  8041602f41:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602f46:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602f4b:	44 0f b6 1a          	movzbl (%rdx),%r11d
    addr++;
  8041602f4f:	48 83 c2 01          	add    $0x1,%rdx
  8041602f53:	89 d3                	mov    %edx,%ebx
  8041602f55:	29 c3                	sub    %eax,%ebx
    result |= (byte & 0x7f) << shift;
  8041602f57:	44 89 de             	mov    %r11d,%esi
  8041602f5a:	83 e6 7f             	and    $0x7f,%esi
  8041602f5d:	d3 e6                	shl    %cl,%esi
  8041602f5f:	09 f7                	or     %esi,%edi
    shift += 7;
  8041602f61:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602f64:	45 84 db             	test   %r11b,%r11b
  8041602f67:	78 e2                	js     8041602f4b <naive_address_by_fname+0x33b>
  return count;
  8041602f69:	48 63 db             	movslq %ebx,%rbx
          curr_abbrev_entry += count;
  8041602f6c:	48 01 c3             	add    %rax,%rbx
  8041602f6f:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602f72:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602f77:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041602f7d:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602f80:	48 83 c0 01          	add    $0x1,%rax
  8041602f84:	41 89 c3             	mov    %eax,%r11d
  8041602f87:	41 29 db             	sub    %ebx,%r11d
    result |= (byte & 0x7f) << shift;
  8041602f8a:	89 f2                	mov    %esi,%edx
  8041602f8c:	83 e2 7f             	and    $0x7f,%edx
  8041602f8f:	d3 e2                	shl    %cl,%edx
  8041602f91:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602f94:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602f97:	40 84 f6             	test   %sil,%sil
  8041602f9a:	78 e1                	js     8041602f7d <naive_address_by_fname+0x36d>
  return count;
  8041602f9c:	4d 63 db             	movslq %r11d,%r11
          curr_abbrev_entry += count;
  8041602f9f:	4a 8d 04 1b          	lea    (%rbx,%r11,1),%rax
        } while (name != 0 || form != 0);
  8041602fa3:	41 09 fc             	or     %edi,%r12d
  8041602fa6:	75 96                	jne    8041602f3e <naive_address_by_fname+0x32e>
  8041602fa8:	e9 18 ff ff ff       	jmpq   8041602ec5 <naive_address_by_fname+0x2b5>
        uintptr_t low_pc = 0;
  8041602fad:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8041602fb4:	00 
        int found        = 0;
  8041602fb5:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%rbp)
  8041602fbc:	e9 98 00 00 00       	jmpq   8041603059 <naive_address_by_fname+0x449>
            count = dwarf_read_abbrev_entry(
  8041602fc1:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602fc7:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041602fcc:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  8041602fd0:	44 89 ee             	mov    %r13d,%esi
  8041602fd3:	4c 89 ff             	mov    %r15,%rdi
  8041602fd6:	41 ff d6             	callq  *%r14
  8041602fd9:	eb 70                	jmp    804160304b <naive_address_by_fname+0x43b>
                  str_offset = 0;
  8041602fdb:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8041602fe2:	00 
              count          = dwarf_read_abbrev_entry(
  8041602fe3:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602fe9:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041602fee:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8041602ff2:	be 0e 00 00 00       	mov    $0xe,%esi
  8041602ff7:	4c 89 ff             	mov    %r15,%rdi
  8041602ffa:	41 ff d6             	callq  *%r14
  8041602ffd:	41 89 c4             	mov    %eax,%r12d
              if (!strcmp(
  8041603000:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041603004:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041603008:	48 03 70 40          	add    0x40(%rax),%rsi
  804160300c:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  8041603010:	48 b8 ad 54 60 41 80 	movabs $0x80416054ad,%rax
  8041603017:	00 00 00 
  804160301a:	ff d0                	callq  *%rax
                found = 1;
  804160301c:	85 c0                	test   %eax,%eax
  804160301e:	b8 01 00 00 00       	mov    $0x1,%eax
  8041603023:	0f 45 45 bc          	cmovne -0x44(%rbp),%eax
  8041603027:	89 45 bc             	mov    %eax,-0x44(%rbp)
          entry += count;
  804160302a:	4d 63 e4             	movslq %r12d,%r12
  804160302d:	4d 01 e7             	add    %r12,%r15
  8041603030:	eb 27                	jmp    8041603059 <naive_address_by_fname+0x449>
            count = dwarf_read_abbrev_entry(
  8041603032:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041603038:	b9 00 00 00 00       	mov    $0x0,%ecx
  804160303d:	ba 00 00 00 00       	mov    $0x0,%edx
  8041603042:	44 89 ee             	mov    %r13d,%esi
  8041603045:	4c 89 ff             	mov    %r15,%rdi
  8041603048:	41 ff d6             	callq  *%r14
          entry += count;
  804160304b:	48 98                	cltq   
  804160304d:	49 01 c7             	add    %rax,%r15
        } while (name != 0 || form != 0);
  8041603050:	45 09 e5             	or     %r12d,%r13d
  8041603053:	0f 84 bf 00 00 00    	je     8041603118 <naive_address_by_fname+0x508>
        int found        = 0;
  8041603059:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  804160305c:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041603061:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041603067:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160306a:	48 83 c0 01          	add    $0x1,%rax
  804160306e:	89 c7                	mov    %eax,%edi
  8041603070:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041603072:	89 f2                	mov    %esi,%edx
  8041603074:	83 e2 7f             	and    $0x7f,%edx
  8041603077:	d3 e2                	shl    %cl,%edx
  8041603079:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  804160307c:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160307f:	40 84 f6             	test   %sil,%sil
  8041603082:	78 e3                	js     8041603067 <naive_address_by_fname+0x457>
  return count;
  8041603084:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041603087:	48 01 fb             	add    %rdi,%rbx
  804160308a:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  804160308d:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041603092:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041603098:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160309b:	48 83 c0 01          	add    $0x1,%rax
  804160309f:	89 c7                	mov    %eax,%edi
  80416030a1:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  80416030a3:	89 f2                	mov    %esi,%edx
  80416030a5:	83 e2 7f             	and    $0x7f,%edx
  80416030a8:	d3 e2                	shl    %cl,%edx
  80416030aa:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  80416030ad:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416030b0:	40 84 f6             	test   %sil,%sil
  80416030b3:	78 e3                	js     8041603098 <naive_address_by_fname+0x488>
  return count;
  80416030b5:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  80416030b8:	48 01 fb             	add    %rdi,%rbx
          if (name == DW_AT_low_pc) {
  80416030bb:	41 83 fc 11          	cmp    $0x11,%r12d
  80416030bf:	0f 84 fc fe ff ff    	je     8041602fc1 <naive_address_by_fname+0x3b1>
          } else if (name == DW_AT_name) {
  80416030c5:	41 83 fc 03          	cmp    $0x3,%r12d
  80416030c9:	0f 85 63 ff ff ff    	jne    8041603032 <naive_address_by_fname+0x422>
            if (form == DW_FORM_strp) {
  80416030cf:	41 83 fd 0e          	cmp    $0xe,%r13d
  80416030d3:	0f 84 02 ff ff ff    	je     8041602fdb <naive_address_by_fname+0x3cb>
              if (!strcmp(fname, entry)) {
  80416030d9:	4c 89 fe             	mov    %r15,%rsi
  80416030dc:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  80416030e0:	48 b8 ad 54 60 41 80 	movabs $0x80416054ad,%rax
  80416030e7:	00 00 00 
  80416030ea:	ff d0                	callq  *%rax
                found = 1;
  80416030ec:	85 c0                	test   %eax,%eax
  80416030ee:	b8 01 00 00 00       	mov    $0x1,%eax
  80416030f3:	0f 45 45 bc          	cmovne -0x44(%rbp),%eax
  80416030f7:	89 45 bc             	mov    %eax,-0x44(%rbp)
              count = dwarf_read_abbrev_entry(
  80416030fa:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041603100:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041603105:	ba 00 00 00 00       	mov    $0x0,%edx
  804160310a:	44 89 ee             	mov    %r13d,%esi
  804160310d:	4c 89 ff             	mov    %r15,%rdi
  8041603110:	41 ff d6             	callq  *%r14
  8041603113:	e9 33 ff ff ff       	jmpq   804160304b <naive_address_by_fname+0x43b>
        if (found) {
  8041603118:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  804160311c:	0f 84 49 fd ff ff    	je     8041602e6b <naive_address_by_fname+0x25b>
          *offset = low_pc;
  8041603122:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041603126:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  804160312a:	48 89 07             	mov    %rax,(%rdi)
          return 0;
  804160312d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603132:	e9 67 fb ff ff       	jmpq   8041602c9e <naive_address_by_fname+0x8e>
    while (entry < entry_end) {
  8041603137:	4c 39 7d a0          	cmp    %r15,-0x60(%rbp)
  804160313b:	0f 87 34 fd ff ff    	ja     8041602e75 <naive_address_by_fname+0x265>
  8041603141:	e9 05 fb ff ff       	jmpq   8041602c4b <naive_address_by_fname+0x3b>
  return 0;
  8041603146:	b8 00 00 00 00       	mov    $0x0,%eax
  804160314b:	e9 4e fb ff ff       	jmpq   8041602c9e <naive_address_by_fname+0x8e>
    return 0;
  8041603150:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603155:	e9 44 fb ff ff       	jmpq   8041602c9e <naive_address_by_fname+0x8e>

000000804160315a <line_for_address>:
// contain an offset in .debug_line of entry associated with compilation unit,
// in which we search address `p`. This offset can be obtained from .debug_info
// section, using the `file_name_by_info` function.
int
line_for_address(const struct Dwarf_Addrs *addrs, uintptr_t p,
                 Dwarf_Off line_offset, int *lineno_store) {
  804160315a:	55                   	push   %rbp
  804160315b:	48 89 e5             	mov    %rsp,%rbp
  804160315e:	41 57                	push   %r15
  8041603160:	41 56                	push   %r14
  8041603162:	41 55                	push   %r13
  8041603164:	41 54                	push   %r12
  8041603166:	53                   	push   %rbx
  8041603167:	48 83 ec 48          	sub    $0x48,%rsp
  if (line_offset > addrs->line_end - addrs->line_begin) {
  804160316b:	48 8b 5f 30          	mov    0x30(%rdi),%rbx
  804160316f:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8041603173:	48 29 d8             	sub    %rbx,%rax
    return -E_INVAL;
  }
  if (lineno_store == NULL) {
  8041603176:	48 39 d0             	cmp    %rdx,%rax
  8041603179:	0f 82 e2 06 00 00    	jb     8041603861 <line_for_address+0x707>
  804160317f:	48 85 c9             	test   %rcx,%rcx
  8041603182:	0f 84 d9 06 00 00    	je     8041603861 <line_for_address+0x707>
  8041603188:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
  804160318c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
    return -E_INVAL;
  }
  const void *curr_addr                  = addrs->line_begin + line_offset;
  8041603190:	48 01 d3             	add    %rdx,%rbx
  initial_len = get_unaligned(addr, uint32_t);
  8041603193:	ba 04 00 00 00       	mov    $0x4,%edx
  8041603198:	48 89 de             	mov    %rbx,%rsi
  804160319b:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160319f:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416031a6:	00 00 00 
  80416031a9:	ff d0                	callq  *%rax
  80416031ab:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416031ae:	83 f8 ef             	cmp    $0xffffffef,%eax
  80416031b1:	76 4e                	jbe    8041603201 <line_for_address+0xa7>
    if (initial_len == DW_EXT_DWARF64) {
  80416031b3:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416031b6:	74 25                	je     80416031dd <line_for_address+0x83>
      cprintf("Unknown DWARF extension\n");
  80416031b8:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  80416031bf:	00 00 00 
  80416031c2:	b8 00 00 00 00       	mov    $0x0,%eax
  80416031c7:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416031ce:	00 00 00 
  80416031d1:	ff d2                	callq  *%rdx

  // Parse Line Number Program Header.
  unsigned long unit_length;
  int count = dwarf_entry_len(curr_addr, &unit_length);
  if (count == 0) {
    return -E_BAD_DWARF;
  80416031d3:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  80416031d8:	e9 75 06 00 00       	jmpq   8041603852 <line_for_address+0x6f8>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416031dd:	48 8d 73 20          	lea    0x20(%rbx),%rsi
  80416031e1:	ba 08 00 00 00       	mov    $0x8,%edx
  80416031e6:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416031ea:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416031f1:	00 00 00 
  80416031f4:	ff d0                	callq  *%rax
  80416031f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416031fa:	ba 0c 00 00 00       	mov    $0xc,%edx
  80416031ff:	eb 07                	jmp    8041603208 <line_for_address+0xae>
    *len = initial_len;
  8041603201:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041603203:	ba 04 00 00 00       	mov    $0x4,%edx
  } else {
    curr_addr += count;
  8041603208:	48 63 d2             	movslq %edx,%rdx
  804160320b:	48 01 d3             	add    %rdx,%rbx
  }
  const void *unit_end = curr_addr + unit_length;
  804160320e:	48 01 d8             	add    %rbx,%rax
  8041603211:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  Dwarf_Half version   = get_unaligned(curr_addr, Dwarf_Half);
  8041603215:	ba 02 00 00 00       	mov    $0x2,%edx
  804160321a:	48 89 de             	mov    %rbx,%rsi
  804160321d:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603221:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041603228:	00 00 00 
  804160322b:	ff d0                	callq  *%rax
  804160322d:	44 0f b7 75 c8       	movzwl -0x38(%rbp),%r14d
  curr_addr += sizeof(Dwarf_Half);
  8041603232:	4c 8d 6b 02          	lea    0x2(%rbx),%r13
  assert(version == 4 || version == 3 || version == 2);
  8041603236:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  804160323a:	66 83 f8 02          	cmp    $0x2,%ax
  804160323e:	77 4e                	ja     804160328e <line_for_address+0x134>
  initial_len = get_unaligned(addr, uint32_t);
  8041603240:	ba 04 00 00 00       	mov    $0x4,%edx
  8041603245:	4c 89 ee             	mov    %r13,%rsi
  8041603248:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160324c:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041603253:	00 00 00 
  8041603256:	ff d0                	callq  *%rax
  8041603258:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  804160325b:	83 f8 ef             	cmp    $0xffffffef,%eax
  804160325e:	0f 86 83 00 00 00    	jbe    80416032e7 <line_for_address+0x18d>
    if (initial_len == DW_EXT_DWARF64) {
  8041603264:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041603267:	74 5a                	je     80416032c3 <line_for_address+0x169>
      cprintf("Unknown DWARF extension\n");
  8041603269:	48 bf 80 66 60 41 80 	movabs $0x8041606680,%rdi
  8041603270:	00 00 00 
  8041603273:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603278:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  804160327f:	00 00 00 
  8041603282:	ff d2                	callq  *%rdx
  unsigned long header_length;
  count = dwarf_entry_len(curr_addr, &header_length);
  if (count == 0) {
    return -E_BAD_DWARF;
  8041603284:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  8041603289:	e9 c4 05 00 00       	jmpq   8041603852 <line_for_address+0x6f8>
  assert(version == 4 || version == 3 || version == 2);
  804160328e:	48 b9 a8 68 60 41 80 	movabs $0x80416068a8,%rcx
  8041603295:	00 00 00 
  8041603298:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  804160329f:	00 00 00 
  80416032a2:	be fc 00 00 00       	mov    $0xfc,%esi
  80416032a7:	48 bf 61 68 60 41 80 	movabs $0x8041606861,%rdi
  80416032ae:	00 00 00 
  80416032b1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416032b6:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416032bd:	00 00 00 
  80416032c0:	41 ff d0             	callq  *%r8
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416032c3:	48 8d 73 22          	lea    0x22(%rbx),%rsi
  80416032c7:	ba 08 00 00 00       	mov    $0x8,%edx
  80416032cc:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416032d0:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416032d7:	00 00 00 
  80416032da:	ff d0                	callq  *%rax
  80416032dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416032e0:	ba 0c 00 00 00       	mov    $0xc,%edx
  80416032e5:	eb 07                	jmp    80416032ee <line_for_address+0x194>
    *len = initial_len;
  80416032e7:	89 c0                	mov    %eax,%eax
  count       = 4;
  80416032e9:	ba 04 00 00 00       	mov    $0x4,%edx
  } else {
    curr_addr += count;
  80416032ee:	48 63 d2             	movslq %edx,%rdx
  80416032f1:	49 01 d5             	add    %rdx,%r13
  }
  const void *program_addr = curr_addr + header_length;
  80416032f4:	49 8d 5c 05 00       	lea    0x0(%r13,%rax,1),%rbx
  Dwarf_Small minimum_instruction_length =
      get_unaligned(curr_addr, Dwarf_Small);
  80416032f9:	ba 01 00 00 00       	mov    $0x1,%edx
  80416032fe:	4c 89 ee             	mov    %r13,%rsi
  8041603301:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603305:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  804160330c:	00 00 00 
  804160330f:	ff d0                	callq  *%rax
  assert(minimum_instruction_length == 1);
  8041603311:	80 7d c8 01          	cmpb   $0x1,-0x38(%rbp)
  8041603315:	0f 85 91 00 00 00    	jne    80416033ac <line_for_address+0x252>
  curr_addr += sizeof(Dwarf_Small);
  804160331b:	4d 8d 65 01          	lea    0x1(%r13),%r12
  Dwarf_Small maximum_operations_per_instruction;
  if (version == 4) {
  804160331f:	66 41 83 fe 04       	cmp    $0x4,%r14w
  8041603324:	0f 84 b7 00 00 00    	je     80416033e1 <line_for_address+0x287>
  } else {
    maximum_operations_per_instruction = 1;
  }
  assert(maximum_operations_per_instruction == 1);
  // Skip default_is_stmt as we don't need it.
  curr_addr += sizeof(Dwarf_Small);
  804160332a:	49 8d 74 24 01       	lea    0x1(%r12),%rsi
  signed char line_base = get_unaligned(curr_addr, signed char);
  804160332f:	ba 01 00 00 00       	mov    $0x1,%edx
  8041603334:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603338:	49 bd 41 56 60 41 80 	movabs $0x8041605641,%r13
  804160333f:	00 00 00 
  8041603342:	41 ff d5             	callq  *%r13
  8041603345:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
  8041603349:	88 45 bd             	mov    %al,-0x43(%rbp)
  curr_addr += sizeof(signed char);
  804160334c:	49 8d 74 24 02       	lea    0x2(%r12),%rsi
  Dwarf_Small line_range = get_unaligned(curr_addr, Dwarf_Small);
  8041603351:	ba 01 00 00 00       	mov    $0x1,%edx
  8041603356:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160335a:	41 ff d5             	callq  *%r13
  804160335d:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
  8041603361:	88 45 be             	mov    %al,-0x42(%rbp)
  curr_addr += sizeof(Dwarf_Small);
  8041603364:	49 8d 74 24 03       	lea    0x3(%r12),%rsi
  Dwarf_Small opcode_base = get_unaligned(curr_addr, Dwarf_Small);
  8041603369:	ba 01 00 00 00       	mov    $0x1,%edx
  804160336e:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603372:	41 ff d5             	callq  *%r13
  8041603375:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
  8041603379:	88 45 bf             	mov    %al,-0x41(%rbp)
  curr_addr += sizeof(Dwarf_Small);
  804160337c:	49 8d 74 24 04       	lea    0x4(%r12),%rsi
  Dwarf_Small *standard_opcode_lengths =
      (Dwarf_Small *)get_unaligned(curr_addr, Dwarf_Small *);
  8041603381:	ba 08 00 00 00       	mov    $0x8,%edx
  8041603386:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160338a:	41 ff d5             	callq  *%r13
  while (program_addr < end_addr) {
  804160338d:	48 39 5d b0          	cmp    %rbx,-0x50(%rbp)
  8041603391:	0f 86 8e 04 00 00    	jbe    8041603825 <line_for_address+0x6cb>
  struct Line_Number_State current_state = {
  8041603397:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
  804160339e:	41 be 00 00 00 00    	mov    $0x0,%r14d
    Dwarf_Small opcode = get_unaligned(program_addr, Dwarf_Small);
  80416033a4:	4d 89 ef             	mov    %r13,%r15
  80416033a7:	e9 e1 01 00 00       	jmpq   804160358d <line_for_address+0x433>
  assert(minimum_instruction_length == 1);
  80416033ac:	48 b9 d8 68 60 41 80 	movabs $0x80416068d8,%rcx
  80416033b3:	00 00 00 
  80416033b6:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  80416033bd:	00 00 00 
  80416033c0:	be 07 01 00 00       	mov    $0x107,%esi
  80416033c5:	48 bf 61 68 60 41 80 	movabs $0x8041606861,%rdi
  80416033cc:	00 00 00 
  80416033cf:	b8 00 00 00 00       	mov    $0x0,%eax
  80416033d4:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416033db:	00 00 00 
  80416033de:	41 ff d0             	callq  *%r8
        get_unaligned(curr_addr, Dwarf_Small);
  80416033e1:	ba 01 00 00 00       	mov    $0x1,%edx
  80416033e6:	4c 89 e6             	mov    %r12,%rsi
  80416033e9:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416033ed:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416033f4:	00 00 00 
  80416033f7:	ff d0                	callq  *%rax
    curr_addr += sizeof(Dwarf_Small);
  80416033f9:	4d 8d 65 02          	lea    0x2(%r13),%r12
  assert(maximum_operations_per_instruction == 1);
  80416033fd:	80 7d c8 01          	cmpb   $0x1,-0x38(%rbp)
  8041603401:	0f 84 23 ff ff ff    	je     804160332a <line_for_address+0x1d0>
  8041603407:	48 b9 f8 68 60 41 80 	movabs $0x80416068f8,%rcx
  804160340e:	00 00 00 
  8041603411:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041603418:	00 00 00 
  804160341b:	be 11 01 00 00       	mov    $0x111,%esi
  8041603420:	48 bf 61 68 60 41 80 	movabs $0x8041606861,%rdi
  8041603427:	00 00 00 
  804160342a:	b8 00 00 00 00       	mov    $0x0,%eax
  804160342f:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041603436:	00 00 00 
  8041603439:	41 ff d0             	callq  *%r8
    if (opcode == 0) {
  804160343c:	48 89 f2             	mov    %rsi,%rdx
  count  = 0;
  804160343f:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  shift  = 0;
  8041603445:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160344a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041603450:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  8041603453:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  8041603457:	41 83 c5 01          	add    $0x1,%r13d
    result |= (byte & 0x7f) << shift;
  804160345b:	89 f8                	mov    %edi,%eax
  804160345d:	83 e0 7f             	and    $0x7f,%eax
  8041603460:	d3 e0                	shl    %cl,%eax
  8041603462:	41 09 c4             	or     %eax,%r12d
    shift += 7;
  8041603465:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041603468:	40 84 ff             	test   %dil,%dil
  804160346b:	78 e3                	js     8041603450 <line_for_address+0x2f6>
  return count;
  804160346d:	4d 63 ed             	movslq %r13d,%r13
      program_addr += count;
  8041603470:	49 01 f5             	add    %rsi,%r13
      const void *opcode_end = program_addr + length;
  8041603473:	45 89 e4             	mov    %r12d,%r12d
  8041603476:	4d 01 ec             	add    %r13,%r12
      opcode                 = get_unaligned(program_addr, Dwarf_Small);
  8041603479:	ba 01 00 00 00       	mov    $0x1,%edx
  804160347e:	4c 89 ee             	mov    %r13,%rsi
  8041603481:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603485:	41 ff d7             	callq  *%r15
  8041603488:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
      program_addr += sizeof(Dwarf_Small);
  804160348c:	49 8d 5d 01          	lea    0x1(%r13),%rbx
      switch (opcode) {
  8041603490:	3c 02                	cmp    $0x2,%al
  8041603492:	0f 84 cb 00 00 00    	je     8041603563 <line_for_address+0x409>
  8041603498:	3c 02                	cmp    $0x2,%al
  804160349a:	76 2d                	jbe    80416034c9 <line_for_address+0x36f>
  804160349c:	3c 03                	cmp    $0x3,%al
  804160349e:	74 61                	je     8041603501 <line_for_address+0x3a7>
  80416034a0:	3c 04                	cmp    $0x4,%al
  80416034a2:	0f 85 25 01 00 00    	jne    80416035cd <line_for_address+0x473>
  80416034a8:	48 89 d8             	mov    %rbx,%rax
  count  = 0;
  80416034ab:	ba 00 00 00 00       	mov    $0x0,%edx
    byte = *addr;
  80416034b0:	0f b6 08             	movzbl (%rax),%ecx
    addr++;
  80416034b3:	48 83 c0 01          	add    $0x1,%rax
    count++;
  80416034b7:	83 c2 01             	add    $0x1,%edx
    if (!(byte & 0x80))
  80416034ba:	84 c9                	test   %cl,%cl
  80416034bc:	78 f2                	js     80416034b0 <line_for_address+0x356>
  return count;
  80416034be:	48 63 d2             	movslq %edx,%rdx
          program_addr += count;
  80416034c1:	48 01 d3             	add    %rdx,%rbx
  80416034c4:	e9 b1 00 00 00       	jmpq   804160357a <line_for_address+0x420>
      switch (opcode) {
  80416034c9:	3c 01                	cmp    $0x1,%al
  80416034cb:	0f 85 fc 00 00 00    	jne    80416035cd <line_for_address+0x473>
          if (last_state.address <= destination_addr &&
  80416034d1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80416034d5:	48 39 45 a8          	cmp    %rax,-0x58(%rbp)
  80416034d9:	0f 87 1c 01 00 00    	ja     80416035fb <line_for_address+0x4a1>
  80416034df:	4c 39 f0             	cmp    %r14,%rax
  80416034e2:	0f 82 46 03 00 00    	jb     804160382e <line_for_address+0x6d4>
          last_state           = *state;
  80416034e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80416034eb:	89 45 9c             	mov    %eax,-0x64(%rbp)
  80416034ee:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
          state->line          = 1;
  80416034f2:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
          state->address       = 0;
  80416034f9:	41 be 00 00 00 00    	mov    $0x0,%r14d
  80416034ff:	eb 79                	jmp    804160357a <line_for_address+0x420>
          while (*(char *)program_addr) {
  8041603501:	41 80 7d 01 00       	cmpb   $0x0,0x1(%r13)
  8041603506:	74 09                	je     8041603511 <line_for_address+0x3b7>
            ++program_addr;
  8041603508:	48 83 c3 01          	add    $0x1,%rbx
          while (*(char *)program_addr) {
  804160350c:	80 3b 00             	cmpb   $0x0,(%rbx)
  804160350f:	75 f7                	jne    8041603508 <line_for_address+0x3ae>
          ++program_addr;
  8041603511:	48 83 c3 01          	add    $0x1,%rbx
  8041603515:	48 89 d8             	mov    %rbx,%rax
  count  = 0;
  8041603518:	ba 00 00 00 00       	mov    $0x0,%edx
    byte = *addr;
  804160351d:	0f b6 08             	movzbl (%rax),%ecx
    addr++;
  8041603520:	48 83 c0 01          	add    $0x1,%rax
    count++;
  8041603524:	83 c2 01             	add    $0x1,%edx
    if (!(byte & 0x80))
  8041603527:	84 c9                	test   %cl,%cl
  8041603529:	78 f2                	js     804160351d <line_for_address+0x3c3>
  return count;
  804160352b:	48 63 d2             	movslq %edx,%rdx
          program_addr += count;
  804160352e:	48 01 d3             	add    %rdx,%rbx
  8041603531:	48 89 d8             	mov    %rbx,%rax
    byte = *addr;
  8041603534:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  8041603537:	48 83 c0 01          	add    $0x1,%rax
  804160353b:	89 c1                	mov    %eax,%ecx
  804160353d:	29 d9                	sub    %ebx,%ecx
    if (!(byte & 0x80))
  804160353f:	84 d2                	test   %dl,%dl
  8041603541:	78 f1                	js     8041603534 <line_for_address+0x3da>
  return count;
  8041603543:	48 63 c9             	movslq %ecx,%rcx
          program_addr += count;
  8041603546:	48 01 cb             	add    %rcx,%rbx
  8041603549:	48 89 d8             	mov    %rbx,%rax
    byte = *addr;
  804160354c:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  804160354f:	48 83 c0 01          	add    $0x1,%rax
  8041603553:	89 c1                	mov    %eax,%ecx
  8041603555:	29 d9                	sub    %ebx,%ecx
    if (!(byte & 0x80))
  8041603557:	84 d2                	test   %dl,%dl
  8041603559:	78 f1                	js     804160354c <line_for_address+0x3f2>
  return count;
  804160355b:	48 63 c9             	movslq %ecx,%rcx
          program_addr += count;
  804160355e:	48 01 cb             	add    %rcx,%rbx
  8041603561:	eb 17                	jmp    804160357a <line_for_address+0x420>
              get_unaligned(program_addr, uintptr_t);
  8041603563:	ba 08 00 00 00       	mov    $0x8,%edx
  8041603568:	48 89 de             	mov    %rbx,%rsi
  804160356b:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160356f:	41 ff d7             	callq  *%r15
  8041603572:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
          program_addr += sizeof(uintptr_t);
  8041603576:	49 8d 5d 09          	lea    0x9(%r13),%rbx
      assert(program_addr == opcode_end);
  804160357a:	49 39 dc             	cmp    %rbx,%r12
  804160357d:	0f 85 94 00 00 00    	jne    8041603617 <line_for_address+0x4bd>
  while (program_addr < end_addr) {
  8041603583:	48 39 5d b0          	cmp    %rbx,-0x50(%rbp)
  8041603587:	0f 86 b7 02 00 00    	jbe    8041603844 <line_for_address+0x6ea>
    Dwarf_Small opcode = get_unaligned(program_addr, Dwarf_Small);
  804160358d:	ba 01 00 00 00       	mov    $0x1,%edx
  8041603592:	48 89 de             	mov    %rbx,%rsi
  8041603595:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603599:	41 ff d7             	callq  *%r15
  804160359c:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
    program_addr += sizeof(Dwarf_Small);
  80416035a0:	48 8d 73 01          	lea    0x1(%rbx),%rsi
    if (opcode == 0) {
  80416035a4:	84 c0                	test   %al,%al
  80416035a6:	0f 84 90 fe ff ff    	je     804160343c <line_for_address+0x2e2>
    } else if (opcode < info->opcode_base) {
  80416035ac:	38 45 bf             	cmp    %al,-0x41(%rbp)
  80416035af:	0f 86 1a 02 00 00    	jbe    80416037cf <line_for_address+0x675>
      switch (opcode) {
  80416035b5:	3c 0c                	cmp    $0xc,%al
  80416035b7:	0f 87 e4 01 00 00    	ja     80416037a1 <line_for_address+0x647>
  80416035bd:	0f b6 d0             	movzbl %al,%edx
  80416035c0:	48 bf 20 69 60 41 80 	movabs $0x8041606920,%rdi
  80416035c7:	00 00 00 
  80416035ca:	ff 24 d7             	jmpq   *(%rdi,%rdx,8)
      switch (opcode) {
  80416035cd:	0f b6 c8             	movzbl %al,%ecx
          panic("Unknown opcode: %x", opcode);
  80416035d0:	48 ba 74 68 60 41 80 	movabs $0x8041606874,%rdx
  80416035d7:	00 00 00 
  80416035da:	be 6b 00 00 00       	mov    $0x6b,%esi
  80416035df:	48 bf 61 68 60 41 80 	movabs $0x8041606861,%rdi
  80416035e6:	00 00 00 
  80416035e9:	b8 00 00 00 00       	mov    $0x0,%eax
  80416035ee:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416035f5:	00 00 00 
  80416035f8:	41 ff d0             	callq  *%r8
          last_state           = *state;
  80416035fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80416035fe:	89 45 9c             	mov    %eax,-0x64(%rbp)
  8041603601:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
          state->line          = 1;
  8041603605:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
          state->address       = 0;
  804160360c:	41 be 00 00 00 00    	mov    $0x0,%r14d
  8041603612:	e9 63 ff ff ff       	jmpq   804160357a <line_for_address+0x420>
      assert(program_addr == opcode_end);
  8041603617:	48 b9 87 68 60 41 80 	movabs $0x8041606887,%rcx
  804160361e:	00 00 00 
  8041603621:	48 ba 99 66 60 41 80 	movabs $0x8041606699,%rdx
  8041603628:	00 00 00 
  804160362b:	be 6e 00 00 00       	mov    $0x6e,%esi
  8041603630:	48 bf 61 68 60 41 80 	movabs $0x8041606861,%rdi
  8041603637:	00 00 00 
  804160363a:	b8 00 00 00 00       	mov    $0x0,%eax
  804160363f:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  8041603646:	00 00 00 
  8041603649:	41 ff d0             	callq  *%r8
          if (last_state.address <= destination_addr &&
  804160364c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8041603650:	48 39 45 a8          	cmp    %rax,-0x58(%rbp)
  8041603654:	0f 87 b9 01 00 00    	ja     8041603813 <line_for_address+0x6b9>
  804160365a:	4c 39 f0             	cmp    %r14,%rax
  804160365d:	0f 82 d3 01 00 00    	jb     8041603836 <line_for_address+0x6dc>
          last_state           = *state;
  8041603663:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8041603666:	89 45 9c             	mov    %eax,-0x64(%rbp)
  8041603669:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
    program_addr += sizeof(Dwarf_Small);
  804160366d:	48 89 f3             	mov    %rsi,%rbx
  8041603670:	e9 0e ff ff ff       	jmpq   8041603583 <line_for_address+0x429>
      switch (opcode) {
  8041603675:	48 89 f2             	mov    %rsi,%rdx
  count  = 0;
  8041603678:	bb 00 00 00 00       	mov    $0x0,%ebx
  shift  = 0;
  804160367d:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041603682:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  8041603688:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  804160368b:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  804160368f:	83 c3 01             	add    $0x1,%ebx
    result |= (byte & 0x7f) << shift;
  8041603692:	89 f8                	mov    %edi,%eax
  8041603694:	83 e0 7f             	and    $0x7f,%eax
  8041603697:	d3 e0                	shl    %cl,%eax
  8041603699:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  804160369c:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160369f:	40 84 ff             	test   %dil,%dil
  80416036a2:	78 e4                	js     8041603688 <line_for_address+0x52e>
              info->minimum_instruction_length *
  80416036a4:	45 89 c0             	mov    %r8d,%r8d
          state->address +=
  80416036a7:	4d 01 c6             	add    %r8,%r14
  return count;
  80416036aa:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  80416036ad:	48 01 f3             	add    %rsi,%rbx
  80416036b0:	e9 ce fe ff ff       	jmpq   8041603583 <line_for_address+0x429>
      switch (opcode) {
  80416036b5:	48 89 f2             	mov    %rsi,%rdx
  count  = 0;
  80416036b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  shift  = 0;
  80416036bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416036c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416036c8:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  80416036cb:	48 83 c2 01          	add    $0x1,%rdx
    result |= (byte & 0x7f) << shift;
  80416036cf:	89 f8                	mov    %edi,%eax
  80416036d1:	83 e0 7f             	and    $0x7f,%eax
  80416036d4:	d3 e0                	shl    %cl,%eax
  80416036d6:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  80416036d9:	83 c1 07             	add    $0x7,%ecx
    count++;
  80416036dc:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  80416036df:	40 84 ff             	test   %dil,%dil
  80416036e2:	78 e4                	js     80416036c8 <line_for_address+0x56e>
  if ((shift < num_bits) && (byte & 0x40))
  80416036e4:	83 f9 1f             	cmp    $0x1f,%ecx
  80416036e7:	7f 10                	jg     80416036f9 <line_for_address+0x59f>
  80416036e9:	40 f6 c7 40          	test   $0x40,%dil
  80416036ed:	74 0a                	je     80416036f9 <line_for_address+0x59f>
    result |= (-1U << shift);
  80416036ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80416036f4:	d3 e0                	shl    %cl,%eax
  80416036f6:	41 09 c0             	or     %eax,%r8d
          state->line += line_incr;
  80416036f9:	44 01 45 b8          	add    %r8d,-0x48(%rbp)
  return count;
  80416036fd:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  8041603700:	48 01 f3             	add    %rsi,%rbx
  8041603703:	e9 7b fe ff ff       	jmpq   8041603583 <line_for_address+0x429>
      switch (opcode) {
  8041603708:	48 89 f0             	mov    %rsi,%rax
  count  = 0;
  804160370b:	bb 00 00 00 00       	mov    $0x0,%ebx
    byte = *addr;
  8041603710:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  8041603713:	48 83 c0 01          	add    $0x1,%rax
    count++;
  8041603717:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  804160371a:	84 d2                	test   %dl,%dl
  804160371c:	78 f2                	js     8041603710 <line_for_address+0x5b6>
  return count;
  804160371e:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  8041603721:	48 01 f3             	add    %rsi,%rbx
  8041603724:	e9 5a fe ff ff       	jmpq   8041603583 <line_for_address+0x429>
      switch (opcode) {
  8041603729:	48 89 f0             	mov    %rsi,%rax
  count  = 0;
  804160372c:	bb 00 00 00 00       	mov    $0x0,%ebx
    byte = *addr;
  8041603731:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  8041603734:	48 83 c0 01          	add    $0x1,%rax
    count++;
  8041603738:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  804160373b:	84 d2                	test   %dl,%dl
  804160373d:	78 f2                	js     8041603731 <line_for_address+0x5d7>
  return count;
  804160373f:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  8041603742:	48 01 f3             	add    %rsi,%rbx
  8041603745:	e9 39 fe ff ff       	jmpq   8041603583 <line_for_address+0x429>
          Dwarf_Small adjusted_opcode =
  804160374a:	0f b6 45 bf          	movzbl -0x41(%rbp),%eax
  804160374e:	f7 d0                	not    %eax
              adjusted_opcode / info->line_range;
  8041603750:	0f b6 c0             	movzbl %al,%eax
  8041603753:	f6 75 be             	divb   -0x42(%rbp)
              info->minimum_instruction_length *
  8041603756:	0f b6 c0             	movzbl %al,%eax
          state->address +=
  8041603759:	49 01 c6             	add    %rax,%r14
    program_addr += sizeof(Dwarf_Small);
  804160375c:	48 89 f3             	mov    %rsi,%rbx
  804160375f:	e9 1f fe ff ff       	jmpq   8041603583 <line_for_address+0x429>
              get_unaligned(program_addr, Dwarf_Half);
  8041603764:	ba 02 00 00 00       	mov    $0x2,%edx
  8041603769:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160376d:	41 ff d7             	callq  *%r15
          state->address += pc_inc;
  8041603770:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041603774:	49 01 c6             	add    %rax,%r14
          program_addr += sizeof(Dwarf_Half);
  8041603777:	48 83 c3 03          	add    $0x3,%rbx
  804160377b:	e9 03 fe ff ff       	jmpq   8041603583 <line_for_address+0x429>
      switch (opcode) {
  8041603780:	48 89 f0             	mov    %rsi,%rax
  count  = 0;
  8041603783:	bb 00 00 00 00       	mov    $0x0,%ebx
    byte = *addr;
  8041603788:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  804160378b:	48 83 c0 01          	add    $0x1,%rax
    count++;
  804160378f:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  8041603792:	84 d2                	test   %dl,%dl
  8041603794:	78 f2                	js     8041603788 <line_for_address+0x62e>
  return count;
  8041603796:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  8041603799:	48 01 f3             	add    %rsi,%rbx
  804160379c:	e9 e2 fd ff ff       	jmpq   8041603583 <line_for_address+0x429>
      switch (opcode) {
  80416037a1:	0f b6 c8             	movzbl %al,%ecx
          panic("Unknown opcode: %x", opcode);
  80416037a4:	48 ba 74 68 60 41 80 	movabs $0x8041606874,%rdx
  80416037ab:	00 00 00 
  80416037ae:	be c1 00 00 00       	mov    $0xc1,%esi
  80416037b3:	48 bf 61 68 60 41 80 	movabs $0x8041606861,%rdi
  80416037ba:	00 00 00 
  80416037bd:	b8 00 00 00 00       	mov    $0x0,%eax
  80416037c2:	49 b8 25 03 60 41 80 	movabs $0x8041600325,%r8
  80416037c9:	00 00 00 
  80416037cc:	41 ff d0             	callq  *%r8
      Dwarf_Small adjusted_opcode =
  80416037cf:	2a 45 bf             	sub    -0x41(%rbp),%al
                      (adjusted_opcode % info->line_range));
  80416037d2:	0f b6 c0             	movzbl %al,%eax
  80416037d5:	f6 75 be             	divb   -0x42(%rbp)
  80416037d8:	0f b6 d4             	movzbl %ah,%edx
      state->line += (info->line_base +
  80416037db:	0f be 4d bd          	movsbl -0x43(%rbp),%ecx
  80416037df:	01 ca                	add    %ecx,%edx
  80416037e1:	01 55 b8             	add    %edx,-0x48(%rbp)
          info->minimum_instruction_length *
  80416037e4:	0f b6 c0             	movzbl %al,%eax
      state->address +=
  80416037e7:	49 01 c6             	add    %rax,%r14
      if (last_state.address <= destination_addr &&
  80416037ea:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80416037ee:	48 39 45 a8          	cmp    %rax,-0x58(%rbp)
  80416037f2:	77 05                	ja     80416037f9 <line_for_address+0x69f>
  80416037f4:	4c 39 f0             	cmp    %r14,%rax
  80416037f7:	72 45                	jb     804160383e <line_for_address+0x6e4>
      last_state = *state;
  80416037f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80416037fc:	89 45 9c             	mov    %eax,-0x64(%rbp)
  80416037ff:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
    program_addr += sizeof(Dwarf_Small);
  8041603803:	48 89 f3             	mov    %rsi,%rbx
  8041603806:	e9 78 fd ff ff       	jmpq   8041603583 <line_for_address+0x429>
  804160380b:	48 89 f3             	mov    %rsi,%rbx
  804160380e:	e9 70 fd ff ff       	jmpq   8041603583 <line_for_address+0x429>
          last_state           = *state;
  8041603813:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8041603816:	89 45 9c             	mov    %eax,-0x64(%rbp)
  8041603819:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
    program_addr += sizeof(Dwarf_Small);
  804160381d:	48 89 f3             	mov    %rsi,%rbx
  8041603820:	e9 5e fd ff ff       	jmpq   8041603583 <line_for_address+0x429>
  struct Line_Number_State current_state = {
  8041603825:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
  804160382c:	eb 16                	jmp    8041603844 <line_for_address+0x6ea>
            *state = last_state;
  804160382e:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8041603831:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8041603834:	eb 0e                	jmp    8041603844 <line_for_address+0x6ea>
            *state = last_state;
  8041603836:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8041603839:	89 45 b8             	mov    %eax,-0x48(%rbp)
  804160383c:	eb 06                	jmp    8041603844 <line_for_address+0x6ea>
        *state = last_state;
  804160383e:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8041603841:	89 45 b8             	mov    %eax,-0x48(%rbp)
  };

  run_line_number_program(program_addr, unit_end, &info, &current_state,
                          p);

  *lineno_store = current_state.line;
  8041603844:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8041603848:	8b 75 b8             	mov    -0x48(%rbp),%esi
  804160384b:	89 30                	mov    %esi,(%rax)

  return 0;
  804160384d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041603852:	48 83 c4 48          	add    $0x48,%rsp
  8041603856:	5b                   	pop    %rbx
  8041603857:	41 5c                	pop    %r12
  8041603859:	41 5d                	pop    %r13
  804160385b:	41 5e                	pop    %r14
  804160385d:	41 5f                	pop    %r15
  804160385f:	5d                   	pop    %rbp
  8041603860:	c3                   	retq   
    return -E_INVAL;
  8041603861:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041603866:	eb ea                	jmp    8041603852 <line_for_address+0x6f8>

0000008041603868 <mon_help>:
#define NCOMMANDS (sizeof(commands) / sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf) {
  8041603868:	55                   	push   %rbp
  8041603869:	48 89 e5             	mov    %rsp,%rbp
  804160386c:	41 55                	push   %r13
  804160386e:	41 54                	push   %r12
  8041603870:	53                   	push   %rbx
  8041603871:	48 83 ec 08          	sub    $0x8,%rsp
  8041603875:	48 bb 60 6c 60 41 80 	movabs $0x8041606c60,%rbx
  804160387c:	00 00 00 
  804160387f:	4c 8d 6b 78          	lea    0x78(%rbx),%r13
  int i;

  for (i = 0; i < NCOMMANDS; i++)
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  8041603883:	49 bc 49 44 60 41 80 	movabs $0x8041604449,%r12
  804160388a:	00 00 00 
  804160388d:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8041603891:	48 8b 33             	mov    (%rbx),%rsi
  8041603894:	48 bf 88 69 60 41 80 	movabs $0x8041606988,%rdi
  804160389b:	00 00 00 
  804160389e:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038a3:	41 ff d4             	callq  *%r12
  80416038a6:	48 83 c3 18          	add    $0x18,%rbx
  for (i = 0; i < NCOMMANDS; i++)
  80416038aa:	4c 39 eb             	cmp    %r13,%rbx
  80416038ad:	75 de                	jne    804160388d <mon_help+0x25>
  return 0;
}
  80416038af:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038b4:	48 83 c4 08          	add    $0x8,%rsp
  80416038b8:	5b                   	pop    %rbx
  80416038b9:	41 5c                	pop    %r12
  80416038bb:	41 5d                	pop    %r13
  80416038bd:	5d                   	pop    %rbp
  80416038be:	c3                   	retq   

00000080416038bf <mon_hello>:

int
mon_hello(int argc, char **argv, struct Trapframe *tf) {
  80416038bf:	55                   	push   %rbp
  80416038c0:	48 89 e5             	mov    %rsp,%rbp
  cprintf("Hello!\n");
  80416038c3:	48 bf 91 69 60 41 80 	movabs $0x8041606991,%rdi
  80416038ca:	00 00 00 
  80416038cd:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038d2:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416038d9:	00 00 00 
  80416038dc:	ff d2                	callq  *%rdx
  return 0;
}
  80416038de:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038e3:	5d                   	pop    %rbp
  80416038e4:	c3                   	retq   

00000080416038e5 <mon_user_name>:

int
mon_user_name(int argc, char **argv, struct Trapframe *tf) {
  80416038e5:	55                   	push   %rbp
  80416038e6:	48 89 e5             	mov    %rsp,%rbp
  cprintf("User name: Andrew\n");
  80416038e9:	48 bf 99 69 60 41 80 	movabs $0x8041606999,%rdi
  80416038f0:	00 00 00 
  80416038f3:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038f8:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416038ff:	00 00 00 
  8041603902:	ff d2                	callq  *%rdx
  return 0;
}
  8041603904:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603909:	5d                   	pop    %rbp
  804160390a:	c3                   	retq   

000000804160390b <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf) {
  804160390b:	55                   	push   %rbp
  804160390c:	48 89 e5             	mov    %rsp,%rbp
  804160390f:	41 54                	push   %r12
  8041603911:	53                   	push   %rbx
  extern char _head64[], entry[], etext[], edata[], end[];

  cprintf("Special kernel symbols:\n");
  8041603912:	48 bf ac 69 60 41 80 	movabs $0x80416069ac,%rdi
  8041603919:	00 00 00 
  804160391c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603921:	48 bb 49 44 60 41 80 	movabs $0x8041604449,%rbx
  8041603928:	00 00 00 
  804160392b:	ff d3                	callq  *%rbx
  cprintf("  _head64                  %08lx (phys)\n",
  804160392d:	48 be 00 00 50 01 00 	movabs $0x1500000,%rsi
  8041603934:	00 00 00 
  8041603937:	48 bf a8 6a 60 41 80 	movabs $0x8041606aa8,%rdi
  804160393e:	00 00 00 
  8041603941:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603946:	ff d3                	callq  *%rbx
          (unsigned long)_head64);
  cprintf("  entry  %08lx (virt)  %08lx (phys)\n",
          (unsigned long)entry, (unsigned long)entry - KERNBASE);
  8041603948:	49 bc 00 00 60 41 80 	movabs $0x8041600000,%r12
  804160394f:	00 00 00 
  cprintf("  entry  %08lx (virt)  %08lx (phys)\n",
  8041603952:	48 ba 00 00 60 01 00 	movabs $0x1600000,%rdx
  8041603959:	00 00 00 
  804160395c:	4c 89 e6             	mov    %r12,%rsi
  804160395f:	48 bf d8 6a 60 41 80 	movabs $0x8041606ad8,%rdi
  8041603966:	00 00 00 
  8041603969:	b8 00 00 00 00       	mov    $0x0,%eax
  804160396e:	ff d3                	callq  *%rbx
  cprintf("  etext  %08lx (virt)  %08lx (phys)\n",
  8041603970:	48 ba a8 63 60 01 00 	movabs $0x16063a8,%rdx
  8041603977:	00 00 00 
  804160397a:	48 be a8 63 60 41 80 	movabs $0x80416063a8,%rsi
  8041603981:	00 00 00 
  8041603984:	48 bf 00 6b 60 41 80 	movabs $0x8041606b00,%rdi
  804160398b:	00 00 00 
  804160398e:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603993:	ff d3                	callq  *%rbx
          (unsigned long)etext, (unsigned long)etext - KERNBASE);
  cprintf("  edata  %08lx (virt)  %08lx (phys)\n",
  8041603995:	48 ba b8 40 62 01 00 	movabs $0x16240b8,%rdx
  804160399c:	00 00 00 
  804160399f:	48 be b8 40 62 41 80 	movabs $0x80416240b8,%rsi
  80416039a6:	00 00 00 
  80416039a9:	48 bf 28 6b 60 41 80 	movabs $0x8041606b28,%rdi
  80416039b0:	00 00 00 
  80416039b3:	b8 00 00 00 00       	mov    $0x0,%eax
  80416039b8:	ff d3                	callq  *%rbx
          (unsigned long)edata, (unsigned long)edata - KERNBASE);
  cprintf("  end    %08lx (virt)  %08lx (phys)\n",
  80416039ba:	48 ba 00 70 62 01 00 	movabs $0x1627000,%rdx
  80416039c1:	00 00 00 
  80416039c4:	48 be 00 70 62 41 80 	movabs $0x8041627000,%rsi
  80416039cb:	00 00 00 
  80416039ce:	48 bf 50 6b 60 41 80 	movabs $0x8041606b50,%rdi
  80416039d5:	00 00 00 
  80416039d8:	b8 00 00 00 00       	mov    $0x0,%eax
  80416039dd:	ff d3                	callq  *%rbx
          (unsigned long)end, (unsigned long)end - KERNBASE);
  cprintf("Kernel executable memory footprint: %luKB\n",
          (unsigned long)ROUNDUP(end - entry, 1024) / 1024);
  80416039df:	48 be ff 73 62 41 80 	movabs $0x80416273ff,%rsi
  80416039e6:	00 00 00 
  80416039e9:	4c 29 e6             	sub    %r12,%rsi
  cprintf("Kernel executable memory footprint: %luKB\n",
  80416039ec:	48 c1 ee 0a          	shr    $0xa,%rsi
  80416039f0:	48 bf 78 6b 60 41 80 	movabs $0x8041606b78,%rdi
  80416039f7:	00 00 00 
  80416039fa:	b8 00 00 00 00       	mov    $0x0,%eax
  80416039ff:	ff d3                	callq  *%rbx
  return 0;
}
  8041603a01:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603a06:	5b                   	pop    %rbx
  8041603a07:	41 5c                	pop    %r12
  8041603a09:	5d                   	pop    %rbp
  8041603a0a:	c3                   	retq   

0000008041603a0b <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf) {
  8041603a0b:	55                   	push   %rbp
  8041603a0c:	48 89 e5             	mov    %rsp,%rbp
  8041603a0f:	41 57                	push   %r15
  8041603a11:	41 56                	push   %r14
  8041603a13:	41 55                	push   %r13
  8041603a15:	41 54                	push   %r12
  8041603a17:	53                   	push   %rbx
  8041603a18:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  // LAB 2: Your code here.

  uint64_t *rbp = 0x0;
  uint64_t rip  = 0x0;
  struct Ripdebuginfo info;
  cprintf("Stack backtrace:\n");
  8041603a1f:	48 bf c5 69 60 41 80 	movabs $0x80416069c5,%rdi
  8041603a26:	00 00 00 
  8041603a29:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603a2e:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041603a35:	00 00 00 
  8041603a38:	ff d2                	callq  *%rdx
}

static __inline uint64_t
read_rbp(void) {
  uint64_t ebp;
  __asm __volatile("movq %%rbp,%0"
  8041603a3a:	48 89 eb             	mov    %rbp,%rbx
  rbp = (uint64_t *)read_rbp(); 
  do {
    rip = rbp[1]; 
    debuginfo_rip(rip, &info);
  8041603a3d:	49 bf a9 46 60 41 80 	movabs $0x80416046a9,%r15
  8041603a44:	00 00 00 
    cprintf("  rbp %016lx  rip %016lx\n", (long unsigned int)rbp, (long unsigned int)rip);
  8041603a47:	49 bd 49 44 60 41 80 	movabs $0x8041604449,%r13
  8041603a4e:	00 00 00 
    cprintf("            %.256s:%d: %.*s+%ld\n", info.rip_file, info.rip_line, info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
  8041603a51:	48 8d 85 b0 fd ff ff 	lea    -0x250(%rbp),%rax
  8041603a58:	4c 8d b0 04 01 00 00 	lea    0x104(%rax),%r14
    rip = rbp[1]; 
  8041603a5f:	4c 8b 63 08          	mov    0x8(%rbx),%r12
    debuginfo_rip(rip, &info);
  8041603a63:	48 8d b5 b0 fd ff ff 	lea    -0x250(%rbp),%rsi
  8041603a6a:	4c 89 e7             	mov    %r12,%rdi
  8041603a6d:	41 ff d7             	callq  *%r15
    cprintf("  rbp %016lx  rip %016lx\n", (long unsigned int)rbp, (long unsigned int)rip);
  8041603a70:	4c 89 e2             	mov    %r12,%rdx
  8041603a73:	48 89 de             	mov    %rbx,%rsi
  8041603a76:	48 bf d7 69 60 41 80 	movabs $0x80416069d7,%rdi
  8041603a7d:	00 00 00 
  8041603a80:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603a85:	41 ff d5             	callq  *%r13
    cprintf("            %.256s:%d: %.*s+%ld\n", info.rip_file, info.rip_line, info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
  8041603a88:	4d 89 e1             	mov    %r12,%r9
  8041603a8b:	4c 2b 4d b8          	sub    -0x48(%rbp),%r9
  8041603a8f:	4d 89 f0             	mov    %r14,%r8
  8041603a92:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
  8041603a95:	8b 95 b0 fe ff ff    	mov    -0x150(%rbp),%edx
  8041603a9b:	48 8d b5 b0 fd ff ff 	lea    -0x250(%rbp),%rsi
  8041603aa2:	48 bf a8 6b 60 41 80 	movabs $0x8041606ba8,%rdi
  8041603aa9:	00 00 00 
  8041603aac:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603ab1:	41 ff d5             	callq  *%r13
    rbp = (uint64_t *)rbp[0];
  8041603ab4:	48 8b 1b             	mov    (%rbx),%rbx
  } while (rbp);
  8041603ab7:	48 85 db             	test   %rbx,%rbx
  8041603aba:	75 a3                	jne    8041603a5f <mon_backtrace+0x54>

  return 0;
}
  8041603abc:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603ac1:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  8041603ac8:	5b                   	pop    %rbx
  8041603ac9:	41 5c                	pop    %r12
  8041603acb:	41 5d                	pop    %r13
  8041603acd:	41 5e                	pop    %r14
  8041603acf:	41 5f                	pop    %r15
  8041603ad1:	5d                   	pop    %rbp
  8041603ad2:	c3                   	retq   

0000008041603ad3 <monitor>:
  cprintf("Unknown command '%s'\n", argv[0]);
  return 0;
}

void
monitor(struct Trapframe *tf) {
  8041603ad3:	55                   	push   %rbp
  8041603ad4:	48 89 e5             	mov    %rsp,%rbp
  8041603ad7:	41 57                	push   %r15
  8041603ad9:	41 56                	push   %r14
  8041603adb:	41 55                	push   %r13
  8041603add:	41 54                	push   %r12
  8041603adf:	53                   	push   %rbx
  8041603ae0:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8041603ae7:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  char *buf;

  cprintf("Welcome to the JOS kernel monitor!\n");
  8041603aee:	48 bf d0 6b 60 41 80 	movabs $0x8041606bd0,%rdi
  8041603af5:	00 00 00 
  8041603af8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603afd:	48 bb 49 44 60 41 80 	movabs $0x8041604449,%rbx
  8041603b04:	00 00 00 
  8041603b07:	ff d3                	callq  *%rbx
  cprintf("Type 'help' for a list of commands.\n");
  8041603b09:	48 bf f8 6b 60 41 80 	movabs $0x8041606bf8,%rdi
  8041603b10:	00 00 00 
  8041603b13:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603b18:	ff d3                	callq  *%rbx

  while (1) {
    buf = readline("K> ");
  8041603b1a:	49 bf 51 52 60 41 80 	movabs $0x8041605251,%r15
  8041603b21:	00 00 00 
    while (*buf && strchr(WHITESPACE, *buf))
  8041603b24:	49 bd 20 55 60 41 80 	movabs $0x8041605520,%r13
  8041603b2b:	00 00 00 
  8041603b2e:	e9 fe 00 00 00       	jmpq   8041603c31 <monitor+0x15e>
  8041603b33:	40 0f be f6          	movsbl %sil,%esi
  8041603b37:	48 bf f5 69 60 41 80 	movabs $0x80416069f5,%rdi
  8041603b3e:	00 00 00 
  8041603b41:	41 ff d5             	callq  *%r13
  8041603b44:	48 85 c0             	test   %rax,%rax
  8041603b47:	74 0c                	je     8041603b55 <monitor+0x82>
      *buf++ = 0;
  8041603b49:	c6 03 00             	movb   $0x0,(%rbx)
  8041603b4c:	45 89 e6             	mov    %r12d,%r14d
  8041603b4f:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
  8041603b53:	eb 49                	jmp    8041603b9e <monitor+0xcb>
    if (*buf == 0)
  8041603b55:	80 3b 00             	cmpb   $0x0,(%rbx)
  8041603b58:	74 4f                	je     8041603ba9 <monitor+0xd6>
    if (argc == MAXARGS - 1) {
  8041603b5a:	41 83 fc 0f          	cmp    $0xf,%r12d
  8041603b5e:	0f 84 b2 00 00 00    	je     8041603c16 <monitor+0x143>
    argv[argc++] = buf;
  8041603b64:	45 8d 74 24 01       	lea    0x1(%r12),%r14d
  8041603b69:	4d 63 e4             	movslq %r12d,%r12
  8041603b6c:	4a 89 9c e5 50 ff ff 	mov    %rbx,-0xb0(%rbp,%r12,8)
  8041603b73:	ff 
    while (*buf && !strchr(WHITESPACE, *buf))
  8041603b74:	0f b6 33             	movzbl (%rbx),%esi
  8041603b77:	40 84 f6             	test   %sil,%sil
  8041603b7a:	74 22                	je     8041603b9e <monitor+0xcb>
  8041603b7c:	40 0f be f6          	movsbl %sil,%esi
  8041603b80:	48 bf f5 69 60 41 80 	movabs $0x80416069f5,%rdi
  8041603b87:	00 00 00 
  8041603b8a:	41 ff d5             	callq  *%r13
  8041603b8d:	48 85 c0             	test   %rax,%rax
  8041603b90:	75 0c                	jne    8041603b9e <monitor+0xcb>
      buf++;
  8041603b92:	48 83 c3 01          	add    $0x1,%rbx
    while (*buf && !strchr(WHITESPACE, *buf))
  8041603b96:	0f b6 33             	movzbl (%rbx),%esi
  8041603b99:	40 84 f6             	test   %sil,%sil
  8041603b9c:	75 de                	jne    8041603b7c <monitor+0xa9>
      *buf++ = 0;
  8041603b9e:	45 89 f4             	mov    %r14d,%r12d
    while (*buf && strchr(WHITESPACE, *buf))
  8041603ba1:	0f b6 33             	movzbl (%rbx),%esi
  8041603ba4:	40 84 f6             	test   %sil,%sil
  8041603ba7:	75 8a                	jne    8041603b33 <monitor+0x60>
  argv[argc] = 0;
  8041603ba9:	49 63 c4             	movslq %r12d,%rax
  8041603bac:	48 c7 84 c5 50 ff ff 	movq   $0x0,-0xb0(%rbp,%rax,8)
  8041603bb3:	ff 00 00 00 00 
  if (argc == 0)
  8041603bb8:	45 85 e4             	test   %r12d,%r12d
  8041603bbb:	74 74                	je     8041603c31 <monitor+0x15e>
  8041603bbd:	49 be 60 6c 60 41 80 	movabs $0x8041606c60,%r14
  8041603bc4:	00 00 00 
  for (i = 0; i < NCOMMANDS; i++) {
  8041603bc7:	bb 00 00 00 00       	mov    $0x0,%ebx
    if (strcmp(argv[0], commands[i].name) == 0)
  8041603bcc:	49 8b 36             	mov    (%r14),%rsi
  8041603bcf:	48 8b bd 50 ff ff ff 	mov    -0xb0(%rbp),%rdi
  8041603bd6:	48 b8 ad 54 60 41 80 	movabs $0x80416054ad,%rax
  8041603bdd:	00 00 00 
  8041603be0:	ff d0                	callq  *%rax
  8041603be2:	85 c0                	test   %eax,%eax
  8041603be4:	74 76                	je     8041603c5c <monitor+0x189>
  for (i = 0; i < NCOMMANDS; i++) {
  8041603be6:	83 c3 01             	add    $0x1,%ebx
  8041603be9:	49 83 c6 18          	add    $0x18,%r14
  8041603bed:	83 fb 05             	cmp    $0x5,%ebx
  8041603bf0:	75 da                	jne    8041603bcc <monitor+0xf9>
  cprintf("Unknown command '%s'\n", argv[0]);
  8041603bf2:	48 8b b5 50 ff ff ff 	mov    -0xb0(%rbp),%rsi
  8041603bf9:	48 bf 17 6a 60 41 80 	movabs $0x8041606a17,%rdi
  8041603c00:	00 00 00 
  8041603c03:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603c08:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041603c0f:	00 00 00 
  8041603c12:	ff d2                	callq  *%rdx
  8041603c14:	eb 1b                	jmp    8041603c31 <monitor+0x15e>
      cprintf("Too many arguments (max %d)\n", MAXARGS);
  8041603c16:	be 10 00 00 00       	mov    $0x10,%esi
  8041603c1b:	48 bf fa 69 60 41 80 	movabs $0x80416069fa,%rdi
  8041603c22:	00 00 00 
  8041603c25:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041603c2c:	00 00 00 
  8041603c2f:	ff d2                	callq  *%rdx
    buf = readline("K> ");
  8041603c31:	48 bf f1 69 60 41 80 	movabs $0x80416069f1,%rdi
  8041603c38:	00 00 00 
  8041603c3b:	41 ff d7             	callq  *%r15
  8041603c3e:	48 89 c3             	mov    %rax,%rbx
    if (buf != NULL)
  8041603c41:	48 85 c0             	test   %rax,%rax
  8041603c44:	74 eb                	je     8041603c31 <monitor+0x15e>
  argv[argc] = 0;
  8041603c46:	48 c7 85 50 ff ff ff 	movq   $0x0,-0xb0(%rbp)
  8041603c4d:	00 00 00 00 
  argc       = 0;
  8041603c51:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8041603c57:	e9 45 ff ff ff       	jmpq   8041603ba1 <monitor+0xce>
      return commands[i].func(argc, argv, tf);
  8041603c5c:	48 63 db             	movslq %ebx,%rbx
  8041603c5f:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  8041603c63:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8041603c6a:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  8041603c71:	44 89 e7             	mov    %r12d,%edi
  8041603c74:	48 b8 60 6c 60 41 80 	movabs $0x8041606c60,%rax
  8041603c7b:	00 00 00 
  8041603c7e:	ff 54 c8 10          	callq  *0x10(%rax,%rcx,8)
      if (runcmd(buf, tf) < 0)
  8041603c82:	85 c0                	test   %eax,%eax
  8041603c84:	79 ab                	jns    8041603c31 <monitor+0x15e>
        break;
  }
  8041603c86:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8041603c8d:	5b                   	pop    %rbx
  8041603c8e:	41 5c                	pop    %r12
  8041603c90:	41 5d                	pop    %r13
  8041603c92:	41 5e                	pop    %r14
  8041603c94:	41 5f                	pop    %r15
  8041603c96:	5d                   	pop    %rbp
  8041603c97:	c3                   	retq   

0000008041603c98 <envid2env>:
//   0 on success, -E_BAD_ENV on error.
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
  8041603c98:	55                   	push   %rbp
  8041603c99:	48 89 e5             	mov    %rsp,%rbp
  struct Env *e;

  // If envid is zero, return the current environment.
  if (envid == 0) {
  8041603c9c:	85 ff                	test   %edi,%edi
  8041603c9e:	74 63                	je     8041603d03 <envid2env+0x6b>
  // Look up the Env structure via the index part of the envid,
  // then check the env_id field in that struct Env
  // to ensure that the envid is not stale
  // (i.e., does not refer to a _previous_ environment
  // that used the same slot in the envs[] array).
  e = &envs[ENVX(envid)];
  8041603ca0:	89 f9                	mov    %edi,%ecx
  8041603ca2:	83 e1 1f             	and    $0x1f,%ecx
  8041603ca5:	48 8d 04 cd 00 00 00 	lea    0x0(,%rcx,8),%rax
  8041603cac:	00 
  8041603cad:	48 29 c8             	sub    %rcx,%rax
  8041603cb0:	48 c1 e0 05          	shl    $0x5,%rax
  8041603cb4:	48 b9 88 87 61 41 80 	movabs $0x8041618788,%rcx
  8041603cbb:	00 00 00 
  8041603cbe:	48 8b 09             	mov    (%rcx),%rcx
  8041603cc1:	48 01 c8             	add    %rcx,%rax
  if (e->env_status == ENV_FREE || e->env_id != envid) {
  8041603cc4:	83 b8 d4 00 00 00 00 	cmpl   $0x0,0xd4(%rax)
  8041603ccb:	74 4a                	je     8041603d17 <envid2env+0x7f>
  8041603ccd:	39 b8 c8 00 00 00    	cmp    %edi,0xc8(%rax)
  8041603cd3:	75 42                	jne    8041603d17 <envid2env+0x7f>
  // Check that the calling environment has legitimate permission
  // to manipulate the specified environment.
  // If checkperm is set, the specified environment
  // must be either the current environment
  // or an immediate child of the current environment.
  if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
  8041603cd5:	84 d2                	test   %dl,%dl
  8041603cd7:	74 20                	je     8041603cf9 <envid2env+0x61>
  8041603cd9:	48 ba 20 43 62 41 80 	movabs $0x8041624320,%rdx
  8041603ce0:	00 00 00 
  8041603ce3:	48 8b 12             	mov    (%rdx),%rdx
  8041603ce6:	48 39 c2             	cmp    %rax,%rdx
  8041603ce9:	74 0e                	je     8041603cf9 <envid2env+0x61>
  8041603ceb:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  8041603cf1:	39 90 cc 00 00 00    	cmp    %edx,0xcc(%rax)
  8041603cf7:	75 2c                	jne    8041603d25 <envid2env+0x8d>
    *env_store = 0;
    return -E_BAD_ENV;
  }

  *env_store = e;
  8041603cf9:	48 89 06             	mov    %rax,(%rsi)
  return 0;
  8041603cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041603d01:	5d                   	pop    %rbp
  8041603d02:	c3                   	retq   
    *env_store = curenv;
  8041603d03:	48 a1 20 43 62 41 80 	movabs 0x8041624320,%rax
  8041603d0a:	00 00 00 
  8041603d0d:	48 89 06             	mov    %rax,(%rsi)
    return 0;
  8041603d10:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603d15:	eb ea                	jmp    8041603d01 <envid2env+0x69>
    *env_store = 0;
  8041603d17:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
    return -E_BAD_ENV;
  8041603d1e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  8041603d23:	eb dc                	jmp    8041603d01 <envid2env+0x69>
    *env_store = 0;
  8041603d25:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
    return -E_BAD_ENV;
  8041603d2c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  8041603d31:	eb ce                	jmp    8041603d01 <envid2env+0x69>

0000008041603d33 <env_init>:
// Make sure the environments are in the free list in the same order
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void) {
  8041603d33:	55                   	push   %rbp
  8041603d34:	48 89 e5             	mov    %rsp,%rbp
  // LAB 3: Your code here.

  env_free_list = NULL; // NULLing new env_list 
  for (int i = NENV - 1; i >= 0; i--) { 
    // initialization in for loop every new environment till max env met
    envs[i].env_link = env_free_list;
  8041603d37:	48 b8 88 87 61 41 80 	movabs $0x8041618788,%rax
  8041603d3e:	00 00 00 
  8041603d41:	48 8b 38             	mov    (%rax),%rdi
  8041603d44:	48 8d 87 20 1b 00 00 	lea    0x1b20(%rdi),%rax
  8041603d4b:	48 8d b7 20 ff ff ff 	lea    -0xe0(%rdi),%rsi
  8041603d52:	ba 00 00 00 00       	mov    $0x0,%edx
  8041603d57:	48 89 c1             	mov    %rax,%rcx
  8041603d5a:	48 89 90 c0 00 00 00 	mov    %rdx,0xc0(%rax)
    envs[i].env_id   = 0;
  8041603d61:	c7 80 c8 00 00 00 00 	movl   $0x0,0xc8(%rax)
  8041603d68:	00 00 00 
  8041603d6b:	48 2d e0 00 00 00    	sub    $0xe0,%rax
    env_free_list    = &envs[i];
  8041603d71:	48 89 ca             	mov    %rcx,%rdx
  for (int i = NENV - 1; i >= 0; i--) { 
  8041603d74:	48 39 f0             	cmp    %rsi,%rax
  8041603d77:	75 de                	jne    8041603d57 <env_init+0x24>
  8041603d79:	48 89 f8             	mov    %rdi,%rax
  8041603d7c:	48 a3 28 43 62 41 80 	movabs %rax,0x8041624328
  8041603d83:	00 00 00 
  }
}
  8041603d86:	5d                   	pop    %rbp
  8041603d87:	c3                   	retq   

0000008041603d88 <env_init_percpu>:

// Load GDT and segment descriptors.
void
env_init_percpu(void) {
  8041603d88:	55                   	push   %rbp
  8041603d89:	48 89 e5             	mov    %rsp,%rbp
  8041603d8c:	53                   	push   %rbx
  __asm __volatile("lgdt (%0)"
  8041603d8d:	48 b8 28 87 61 41 80 	movabs $0x8041618728,%rax
  8041603d94:	00 00 00 
  8041603d97:	0f 01 10             	lgdt   (%rax)
  lgdt(&gdt_pd);
  // The kernel never uses GS or FS, so we leave those set to
  // the user data segment.
  asm volatile("movw %%ax,%%gs" ::"a"(GD_UD | 3));
  8041603d9a:	b8 33 00 00 00       	mov    $0x33,%eax
  8041603d9f:	8e e8                	mov    %eax,%gs
  asm volatile("movw %%ax,%%fs" ::"a"(GD_UD | 3));
  8041603da1:	8e e0                	mov    %eax,%fs
  // The kernel does use ES, DS, and SS.  We'll change between
  // the kernel and user data segments as needed.
  asm volatile("movw %%ax,%%es" ::"a"(GD_KD));
  8041603da3:	b8 10 00 00 00       	mov    $0x10,%eax
  8041603da8:	8e c0                	mov    %eax,%es
  asm volatile("movw %%ax,%%ds" ::"a"(GD_KD));
  8041603daa:	8e d8                	mov    %eax,%ds
  asm volatile("movw %%ax,%%ss" ::"a"(GD_KD));
  8041603dac:	8e d0                	mov    %eax,%ss
  // Load the kernel text segment into CS.
  asm volatile("pushq %%rbx \n \t movabs $1f,%%rax \n \t pushq %%rax \n\t lretq \n 1:\n" ::"b"(GD_KT)
  8041603dae:	bb 08 00 00 00       	mov    $0x8,%ebx
  8041603db3:	53                   	push   %rbx
  8041603db4:	48 b8 c1 3d 60 41 80 	movabs $0x8041603dc1,%rax
  8041603dbb:	00 00 00 
  8041603dbe:	50                   	push   %rax
  8041603dbf:	48 cb                	lretq  
               : "cc", "memory");
  // For good measure, clear the local descriptor table (LDT),
  // since we don't use it.
  asm volatile("movw $0,%%ax \n lldt %%ax\n"
  8041603dc1:	66 b8 00 00          	mov    $0x0,%ax
  8041603dc5:	0f 00 d0             	lldt   %ax
               :
               :
               : "cc", "memory");
}
  8041603dc8:	5b                   	pop    %rbx
  8041603dc9:	5d                   	pop    %rbp
  8041603dca:	c3                   	retq   

0000008041603dcb <env_alloc>:
// Returns 0 on success, < 0 on failure.  Errors include:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id) {
  8041603dcb:	55                   	push   %rbp
  8041603dcc:	48 89 e5             	mov    %rsp,%rbp
  8041603dcf:	41 54                	push   %r12
  8041603dd1:	53                   	push   %rbx
  int32_t generation;
  struct Env *e;

  if (!(e = env_free_list)) {
  8041603dd2:	48 b8 28 43 62 41 80 	movabs $0x8041624328,%rax
  8041603dd9:	00 00 00 
  8041603ddc:	48 8b 18             	mov    (%rax),%rbx
  8041603ddf:	48 85 db             	test   %rbx,%rbx
  8041603de2:	0f 84 1c 01 00 00    	je     8041603f04 <env_alloc+0x139>
  8041603de8:	49 89 fc             	mov    %rdi,%r12
    return -E_NO_FREE_ENV;
  }

  // Generate an env_id for this environment.
  generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
  8041603deb:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  8041603df1:	05 00 10 00 00       	add    $0x1000,%eax
  if (generation <= 0) // Don't create a negative env_id.
  8041603df6:	83 e0 e0             	and    $0xffffffe0,%eax
    generation = 1 << ENVGENSHIFT;
  8041603df9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8041603dfe:	0f 4e c2             	cmovle %edx,%eax
  e->env_id = generation | (e - envs);
  8041603e01:	48 ba 88 87 61 41 80 	movabs $0x8041618788,%rdx
  8041603e08:	00 00 00 
  8041603e0b:	48 89 d9             	mov    %rbx,%rcx
  8041603e0e:	48 2b 0a             	sub    (%rdx),%rcx
  8041603e11:	48 89 ca             	mov    %rcx,%rdx
  8041603e14:	48 c1 fa 05          	sar    $0x5,%rdx
  8041603e18:	69 d2 b7 6d db b6    	imul   $0xb6db6db7,%edx,%edx
  8041603e1e:	09 d0                	or     %edx,%eax
  8041603e20:	89 83 c8 00 00 00    	mov    %eax,0xc8(%rbx)

  // Set the basic status variables.
  e->env_parent_id = parent_id;
  8041603e26:	89 b3 cc 00 00 00    	mov    %esi,0xcc(%rbx)
#ifdef CONFIG_KSPACE
  e->env_type = ENV_TYPE_KERNEL;
  8041603e2c:	c7 83 d0 00 00 00 01 	movl   $0x1,0xd0(%rbx)
  8041603e33:	00 00 00 
#else
#endif
  e->env_status = ENV_RUNNABLE;
  8041603e36:	c7 83 d4 00 00 00 02 	movl   $0x2,0xd4(%rbx)
  8041603e3d:	00 00 00 
  e->env_runs   = 0;
  8041603e40:	c7 83 d8 00 00 00 00 	movl   $0x0,0xd8(%rbx)
  8041603e47:	00 00 00 

  // Clear out all the saved register state,
  // to prevent the register values
  // of a prior environment inhabiting this Env structure
  // from "leaking" into our new environment.
  memset(&e->env_tf, 0, sizeof(e->env_tf));
  8041603e4a:	ba c0 00 00 00       	mov    $0xc0,%edx
  8041603e4f:	be 00 00 00 00       	mov    $0x0,%esi
  8041603e54:	48 89 df             	mov    %rbx,%rdi
  8041603e57:	48 b8 7f 55 60 41 80 	movabs $0x804160557f,%rax
  8041603e5e:	00 00 00 
  8041603e61:	ff d0                	callq  *%rax
  // Requestor Privilege Level (RPL); 3 means user mode, 0 - kernel mode.  When
  // we switch privilege levels, the hardware does various
  // checks involving the RPL and the Descriptor Privilege Level
  // (DPL) stored in the descriptors themselves.
#ifdef CONFIG_KSPACE
  e->env_tf.tf_ds = GD_KD | 0;
  8041603e63:	66 c7 83 80 00 00 00 	movw   $0x10,0x80(%rbx)
  8041603e6a:	10 00 
  e->env_tf.tf_es = GD_KD | 0;
  8041603e6c:	66 c7 43 78 10 00    	movw   $0x10,0x78(%rbx)
  e->env_tf.tf_ss = GD_KD | 0;
  8041603e72:	66 c7 83 b8 00 00 00 	movw   $0x10,0xb8(%rbx)
  8041603e79:	10 00 
  e->env_tf.tf_cs = GD_KT | 0;
  8041603e7b:	66 c7 83 a0 00 00 00 	movw   $0x8,0xa0(%rbx)
  8041603e82:	08 00 

  // LAB 3: Your code here.
  // Allocate stack for new task
  static uintptr_t STACK_TOP = 0x2000000;
  e->env_tf.tf_rsp = STACK_TOP;
  8041603e84:	48 ba 20 87 61 41 80 	movabs $0x8041618720,%rdx
  8041603e8b:	00 00 00 
  8041603e8e:	48 8b 02             	mov    (%rdx),%rax
  8041603e91:	48 89 83 b0 00 00 00 	mov    %rax,0xb0(%rbx)
  STACK_TOP -= 2 * PGSIZE;
  8041603e98:	48 2d 00 20 00 00    	sub    $0x2000,%rax
  8041603e9e:	48 89 02             	mov    %rax,(%rdx)
  __asm __volatile("pushfq; popq %0"
  8041603ea1:	9c                   	pushfq 
  8041603ea2:	58                   	pop    %rax

  // For now init trapframe with current RFLAGS
  e->env_tf.tf_rflags = read_rflags();
  8041603ea3:	48 89 83 a8 00 00 00 	mov    %rax,0xa8(%rbx)
#else
#endif
  // You will set e->env_tf.tf_rip later.

  // commit the allocation
  env_free_list = e->env_link;
  8041603eaa:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8041603eb1:	48 a3 28 43 62 41 80 	movabs %rax,0x8041624328
  8041603eb8:	00 00 00 
  *newenv_store = e;
  8041603ebb:	49 89 1c 24          	mov    %rbx,(%r12)

  cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
  8041603ebf:	8b 93 c8 00 00 00    	mov    0xc8(%rbx),%edx
  8041603ec5:	48 a1 20 43 62 41 80 	movabs 0x8041624320,%rax
  8041603ecc:	00 00 00 
  8041603ecf:	be 00 00 00 00       	mov    $0x0,%esi
  8041603ed4:	48 85 c0             	test   %rax,%rax
  8041603ed7:	74 06                	je     8041603edf <env_alloc+0x114>
  8041603ed9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8041603edf:	48 bf d8 6c 60 41 80 	movabs $0x8041606cd8,%rdi
  8041603ee6:	00 00 00 
  8041603ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603eee:	48 b9 49 44 60 41 80 	movabs $0x8041604449,%rcx
  8041603ef5:	00 00 00 
  8041603ef8:	ff d1                	callq  *%rcx

  return 0;
  8041603efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041603eff:	5b                   	pop    %rbx
  8041603f00:	41 5c                	pop    %r12
  8041603f02:	5d                   	pop    %rbp
  8041603f03:	c3                   	retq   
    return -E_NO_FREE_ENV;
  8041603f04:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
  8041603f09:	eb f4                	jmp    8041603eff <env_alloc+0x134>

0000008041603f0b <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type){
  8041603f0b:	55                   	push   %rbp
  8041603f0c:	48 89 e5             	mov    %rsp,%rbp
  8041603f0f:	41 57                	push   %r15
  8041603f11:	41 56                	push   %r14
  8041603f13:	41 55                	push   %r13
  8041603f15:	41 54                	push   %r12
  8041603f17:	53                   	push   %rbx
  8041603f18:	48 83 ec 48          	sub    $0x48,%rsp
  8041603f1c:	49 89 fc             	mov    %rdi,%r12
  8041603f1f:	89 f3                	mov    %esi,%ebx
  // LAB 3: Your code here.

  struct Env *newenv; 
  if (env_alloc(&newenv, 0) < 0) {
  8041603f21:	be 00 00 00 00       	mov    $0x0,%esi
  8041603f26:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603f2a:	48 b8 cb 3d 60 41 80 	movabs $0x8041603dcb,%rax
  8041603f31:	00 00 00 
  8041603f34:	ff d0                	callq  *%rax
  8041603f36:	85 c0                	test   %eax,%eax
  8041603f38:	78 3a                	js     8041603f74 <env_create+0x69>
    panic("Can't allocate new environment");  // попытка выделить среду – если нет – вылет по панике ядра
  }
  
  newenv->env_type = type;
  8041603f3a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041603f3e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8041603f42:	89 98 d0 00 00 00    	mov    %ebx,0xd0(%rax)
  if (elf->e_magic != ELF_MAGIC) {
  8041603f48:	41 81 3c 24 7f 45 4c 	cmpl   $0x464c457f,(%r12)
  8041603f4f:	46 
  8041603f50:	75 4c                	jne    8041603f9e <env_create+0x93>
  struct Proghdr *ph = (struct Proghdr *)(binary + elf->e_phoff); // Proghdr = prog header. Он лежит со смещением elf->e_phoff относительно начала фаила
  8041603f52:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  for (size_t i = 0; i < elf->e_phnum; i++) { //elf->e_phnum - Число заголовков программы. Если у файла нет таблицы заголовков программы, это поле содержит 0.
  8041603f57:	66 41 83 7c 24 38 00 	cmpw   $0x0,0x38(%r12)
  8041603f5e:	74 59                	je     8041603fb9 <env_create+0xae>
  8041603f60:	4c 01 e0             	add    %r12,%rax
  8041603f63:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
  8041603f67:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8041603f6e:	00 
  8041603f6f:	e9 ce 01 00 00       	jmpq   8041604142 <env_create+0x237>
    panic("Can't allocate new environment");  // попытка выделить среду – если нет – вылет по панике ядра
  8041603f74:	48 ba 60 6d 60 41 80 	movabs $0x8041606d60,%rdx
  8041603f7b:	00 00 00 
  8041603f7e:	be 6b 01 00 00       	mov    $0x16b,%esi
  8041603f83:	48 bf ed 6c 60 41 80 	movabs $0x8041606ced,%rdi
  8041603f8a:	00 00 00 
  8041603f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603f92:	48 b9 25 03 60 41 80 	movabs $0x8041600325,%rcx
  8041603f99:	00 00 00 
  8041603f9c:	ff d1                	callq  *%rcx
    cprintf("Unexpected ELF format\n");
  8041603f9e:	48 bf f8 6c 60 41 80 	movabs $0x8041606cf8,%rdi
  8041603fa5:	00 00 00 
  8041603fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603fad:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041603fb4:	00 00 00 
  8041603fb7:	ff d2                	callq  *%rdx

  load_icode(newenv, binary); // load instruction code
}
  8041603fb9:	48 83 c4 48          	add    $0x48,%rsp
  8041603fbd:	5b                   	pop    %rbx
  8041603fbe:	41 5c                	pop    %r12
  8041603fc0:	41 5d                	pop    %r13
  8041603fc2:	41 5e                	pop    %r14
  8041603fc4:	41 5f                	pop    %r15
  8041603fc6:	5d                   	pop    %rbp
  8041603fc7:	c3                   	retq   
      void *dst = (void *)ph[i].p_va;
  8041603fc8:	4c 8b 68 10          	mov    0x10(%rax),%r13
      size_t memsz  = ph[i].p_memsz;
  8041603fcc:	48 8b 58 28          	mov    0x28(%rax),%rbx
      size_t filesz = MIN(ph[i].p_filesz, memsz);
  8041603fd0:	48 39 58 20          	cmp    %rbx,0x20(%rax)
  8041603fd4:	49 89 de             	mov    %rbx,%r14
  8041603fd7:	4c 0f 46 70 20       	cmovbe 0x20(%rax),%r14
      void *src = binary + ph[i].p_offset;
  8041603fdc:	4c 89 e6             	mov    %r12,%rsi
  8041603fdf:	48 03 70 08          	add    0x8(%rax),%rsi
      memcpy(dst, src, filesz);                // копируем в dst (дистинейшн) src (код) размера filesz
  8041603fe3:	4c 89 f2             	mov    %r14,%rdx
  8041603fe6:	4c 89 ef             	mov    %r13,%rdi
  8041603fe9:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  8041603ff0:	00 00 00 
  8041603ff3:	ff d0                	callq  *%rax
      memset(dst + filesz, 0, memsz - filesz); // обнуление памяти по адресу dst + filesz, где количество нулей = memsz - filesz. Т.е. зануляем всю выделенную память сегмента кода, оставшуюяся после копирования src. Возможно, эта строка не нужна
  8041603ff5:	48 89 da             	mov    %rbx,%rdx
  8041603ff8:	4c 29 f2             	sub    %r14,%rdx
  8041603ffb:	4b 8d 7c 35 00       	lea    0x0(%r13,%r14,1),%rdi
  8041604000:	be 00 00 00 00       	mov    $0x0,%esi
  8041604005:	48 b8 7f 55 60 41 80 	movabs $0x804160557f,%rax
  804160400c:	00 00 00 
  804160400f:	ff d0                	callq  *%rax
  8041604011:	e9 39 01 00 00       	jmpq   804160414f <env_create+0x244>
  for (size_t i = 0; i < elf->e_shnum; i++) {
  8041604016:	48 83 c3 01          	add    $0x1,%rbx
  804160401a:	49 83 c5 40          	add    $0x40,%r13
  804160401e:	41 0f b7 44 24 3c    	movzwl 0x3c(%r12),%eax
  8041604024:	48 39 c3             	cmp    %rax,%rbx
  8041604027:	73 25                	jae    804160404e <env_create+0x143>
    if (sh[i].sh_type == ELF_SHT_STRTAB && !strcmp(".strtab", shstr + sh[i].sh_name)) {
  8041604029:	41 83 7d 04 03       	cmpl   $0x3,0x4(%r13)
  804160402e:	75 e6                	jne    8041604016 <env_create+0x10b>
  8041604030:	41 8b 75 00          	mov    0x0(%r13),%esi
  8041604034:	48 03 75 b0          	add    -0x50(%rbp),%rsi
  8041604038:	4c 01 e6             	add    %r12,%rsi
  804160403b:	48 bf 0f 6d 60 41 80 	movabs $0x8041606d0f,%rdi
  8041604042:	00 00 00 
  8041604045:	41 ff d7             	callq  *%r15
  8041604048:	85 c0                	test   %eax,%eax
  804160404a:	75 ca                	jne    8041604016 <env_create+0x10b>
  804160404c:	eb 07                	jmp    8041604055 <env_create+0x14a>
  size_t strtab = -1UL;
  804160404e:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  const char *strings = (char *)binary + sh[strtab].sh_offset;
  8041604055:	48 c1 e3 06          	shl    $0x6,%rbx
  8041604059:	49 8b 44 1e 18       	mov    0x18(%r14,%rbx,1),%rax
  804160405e:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  for (size_t i = 0; i < elf->e_shnum; i++) {
  8041604062:	66 41 83 7c 24 3c 00 	cmpw   $0x0,0x3c(%r12)
  8041604069:	0f 84 b6 00 00 00    	je     8041604125 <env_create+0x21a>
  804160406f:	49 83 c6 04          	add    $0x4,%r14
  8041604073:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8041604079:	eb 75                	jmp    80416040f0 <env_create+0x1e5>
  804160407b:	48 83 c3 18          	add    $0x18,%rbx
      for (size_t j = 0; j < nsyms; j++) {
  804160407f:	49 39 dd             	cmp    %rbx,%r13
  8041604082:	74 55                	je     80416040d9 <env_create+0x1ce>
        if (ELF64_ST_BIND(syms[j].st_info) == STB_GLOBAL &&
  8041604084:	0f b6 43 04          	movzbl 0x4(%rbx),%eax
  8041604088:	89 c2                	mov    %eax,%edx
  804160408a:	c0 ea 04             	shr    $0x4,%dl
  804160408d:	80 fa 01             	cmp    $0x1,%dl
  8041604090:	75 e9                	jne    804160407b <env_create+0x170>
  8041604092:	83 e0 0f             	and    $0xf,%eax
  8041604095:	3c 01                	cmp    $0x1,%al
  8041604097:	75 e2                	jne    804160407b <env_create+0x170>
            ELF64_ST_TYPE(syms[j].st_info) == STT_OBJECT &&
  8041604099:	48 83 7b 10 08       	cmpq   $0x8,0x10(%rbx)
  804160409e:	75 db                	jne    804160407b <env_create+0x170>
          const char *name = strings + syms[j].st_name;
  80416040a0:	8b 3b                	mov    (%rbx),%edi
  80416040a2:	48 03 7d 98          	add    -0x68(%rbp),%rdi
  80416040a6:	4c 01 e7             	add    %r12,%rdi
          uintptr_t addr = find_function(name);
  80416040a9:	48 b8 c5 48 60 41 80 	movabs $0x80416048c5,%rax
  80416040b0:	00 00 00 
  80416040b3:	ff d0                	callq  *%rax
  80416040b5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
          if (addr) {
  80416040b9:	48 85 c0             	test   %rax,%rax
  80416040bc:	74 bd                	je     804160407b <env_create+0x170>
            memcpy((void *)syms[j].st_value, &addr, sizeof(void *));
  80416040be:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  80416040c2:	ba 08 00 00 00       	mov    $0x8,%edx
  80416040c7:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  80416040cb:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416040d2:	00 00 00 
  80416040d5:	ff d0                	callq  *%rax
  80416040d7:	eb a2                	jmp    804160407b <env_create+0x170>
  80416040d9:	4c 8b 7d b0          	mov    -0x50(%rbp),%r15
  for (size_t i = 0; i < elf->e_shnum; i++) {
  80416040dd:	49 83 c7 01          	add    $0x1,%r15
  80416040e1:	49 83 c6 40          	add    $0x40,%r14
  80416040e5:	41 0f b7 44 24 3c    	movzwl 0x3c(%r12),%eax
  80416040eb:	49 39 c7             	cmp    %rax,%r15
  80416040ee:	73 35                	jae    8041604125 <env_create+0x21a>
    if (sh[i].sh_type == ELF_SHT_SYMTAB) {
  80416040f0:	41 83 3e 02          	cmpl   $0x2,(%r14)
  80416040f4:	75 e7                	jne    80416040dd <env_create+0x1d2>
      struct Elf64_Sym *syms = (struct Elf64_Sym *)(binary + sh[i].sh_offset);
  80416040f6:	49 8b 5e 14          	mov    0x14(%r14),%rbx
      size_t nsyms = sh[i].sh_size / sizeof(*syms);
  80416040fa:	48 b8 ab aa aa aa aa 	movabs $0xaaaaaaaaaaaaaaab,%rax
  8041604101:	aa aa aa 
  8041604104:	49 f7 66 1c          	mulq   0x1c(%r14)
  8041604108:	48 c1 ea 04          	shr    $0x4,%rdx
      for (size_t j = 0; j < nsyms; j++) {
  804160410c:	48 85 d2             	test   %rdx,%rdx
  804160410f:	74 cc                	je     80416040dd <env_create+0x1d2>
  8041604111:	4c 01 e3             	add    %r12,%rbx
  8041604114:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  8041604118:	4c 8d 2c c3          	lea    (%rbx,%rax,8),%r13
            memcpy((void *)syms[j].st_value, &addr, sizeof(void *));
  804160411c:	4c 89 7d b0          	mov    %r15,-0x50(%rbp)
  8041604120:	e9 5f ff ff ff       	jmpq   8041604084 <env_create+0x179>
  for (size_t i = 0; i < elf->e_phnum; i++) { //elf->e_phnum - Число заголовков программы. Если у файла нет таблицы заголовков программы, это поле содержит 0.
  8041604125:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804160412a:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  804160412e:	48 83 45 a8 38       	addq   $0x38,-0x58(%rbp)
  8041604133:	41 0f b7 44 24 38    	movzwl 0x38(%r12),%eax
  8041604139:	48 39 c1             	cmp    %rax,%rcx
  804160413c:	0f 83 77 fe ff ff    	jae    8041603fb9 <env_create+0xae>
    if (ph[i].p_type == ELF_PROG_LOAD) {
  8041604142:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041604146:	83 38 01             	cmpl   $0x1,(%rax)
  8041604149:	0f 84 79 fe ff ff    	je     8041603fc8 <env_create+0xbd>
    e->env_tf.tf_rip = elf->e_entry; //Виртуальный адрес точки входа, которому система передает управление при запуске процесса. в регистр rip записываем адрес точки входа для выполнения процесса
  804160414f:	49 8b 44 24 18       	mov    0x18(%r12),%rax
  8041604154:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8041604158:	48 89 87 98 00 00 00 	mov    %rax,0x98(%rdi)
  struct Secthdr *sh = (struct Secthdr *)(binary + elf->e_shoff);
  804160415f:	4d 89 e6             	mov    %r12,%r14
  8041604162:	4d 03 74 24 28       	add    0x28(%r12),%r14
  const char *shstr  = (char *)binary + sh[elf->e_shstrndx].sh_offset;
  8041604167:	41 0f b7 44 24 3e    	movzwl 0x3e(%r12),%eax
  804160416d:	48 c1 e0 06          	shl    $0x6,%rax
  8041604171:	49 8b 44 06 18       	mov    0x18(%r14,%rax,1),%rax
  8041604176:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  for (size_t i = 0; i < elf->e_shnum; i++) {
  804160417a:	66 41 83 7c 24 3c 00 	cmpw   $0x0,0x3c(%r12)
  8041604181:	74 a2                	je     8041604125 <env_create+0x21a>
  8041604183:	4d 89 f5             	mov    %r14,%r13
  8041604186:	bb 00 00 00 00       	mov    $0x0,%ebx
    if (sh[i].sh_type == ELF_SHT_STRTAB && !strcmp(".strtab", shstr + sh[i].sh_name)) {
  804160418b:	49 bf ad 54 60 41 80 	movabs $0x80416054ad,%r15
  8041604192:	00 00 00 
  8041604195:	e9 8f fe ff ff       	jmpq   8041604029 <env_create+0x11e>

000000804160419a <env_free>:

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
  804160419a:	55                   	push   %rbp
  804160419b:	48 89 e5             	mov    %rsp,%rbp
  804160419e:	53                   	push   %rbx
  804160419f:	48 83 ec 08          	sub    $0x8,%rsp
  80416041a3:	48 89 fb             	mov    %rdi,%rbx
  // Note the environment's demise.
  cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
  80416041a6:	8b 97 c8 00 00 00    	mov    0xc8(%rdi),%edx
  80416041ac:	48 a1 20 43 62 41 80 	movabs 0x8041624320,%rax
  80416041b3:	00 00 00 
  80416041b6:	be 00 00 00 00       	mov    $0x0,%esi
  80416041bb:	48 85 c0             	test   %rax,%rax
  80416041be:	74 06                	je     80416041c6 <env_free+0x2c>
  80416041c0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80416041c6:	48 bf 17 6d 60 41 80 	movabs $0x8041606d17,%rdi
  80416041cd:	00 00 00 
  80416041d0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416041d5:	48 b9 49 44 60 41 80 	movabs $0x8041604449,%rcx
  80416041dc:	00 00 00 
  80416041df:	ff d1                	callq  *%rcx

  // return the environment to the free list
  e->env_status = ENV_FREE;
  80416041e1:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%rbx)
  80416041e8:	00 00 00 
  e->env_link   = env_free_list;
  80416041eb:	48 b8 28 43 62 41 80 	movabs $0x8041624328,%rax
  80416041f2:	00 00 00 
  80416041f5:	48 8b 10             	mov    (%rax),%rdx
  80416041f8:	48 89 93 c0 00 00 00 	mov    %rdx,0xc0(%rbx)
  env_free_list = e;
  80416041ff:	48 89 18             	mov    %rbx,(%rax)
}
  8041604202:	48 83 c4 08          	add    $0x8,%rsp
  8041604206:	5b                   	pop    %rbx
  8041604207:	5d                   	pop    %rbp
  8041604208:	c3                   	retq   

0000008041604209 <env_destroy>:
  // LAB 3: Your code here.
  // If e is currently running on other CPUs, we change its state to
  // ENV_DYING. A zombie environment will be freed the next time
  // it traps to the kernel.

  e->env_status = ENV_DYING; // environment died, long live new environment (not here)!
  8041604209:	c7 87 d4 00 00 00 01 	movl   $0x1,0xd4(%rdi)
  8041604210:	00 00 00 
  if (e == curenv) {
  8041604213:	48 b8 20 43 62 41 80 	movabs $0x8041624320,%rax
  804160421a:	00 00 00 
  804160421d:	48 39 38             	cmp    %rdi,(%rax)
  8041604220:	74 02                	je     8041604224 <env_destroy+0x1b>
  8041604222:	f3 c3                	repz retq 
env_destroy(struct Env *e) {
  8041604224:	55                   	push   %rbp
  8041604225:	48 89 e5             	mov    %rsp,%rbp
    env_free(e); // очистка среды
  8041604228:	48 b8 9a 41 60 41 80 	movabs $0x804160419a,%rax
  804160422f:	00 00 00 
  8041604232:	ff d0                	callq  *%rax
    sched_yield(); // вызывается функция, обрабатывающая смену/удаление среды
  8041604234:	48 b8 80 45 60 41 80 	movabs $0x8041604580,%rax
  804160423b:	00 00 00 
  804160423e:	ff d0                	callq  *%rax

0000008041604240 <csys_exit>:
  }
}

#ifdef CONFIG_KSPACE
void
csys_exit(void) {
  8041604240:	55                   	push   %rbp
  8041604241:	48 89 e5             	mov    %rsp,%rbp
  env_destroy(curenv);
  8041604244:	48 b8 20 43 62 41 80 	movabs $0x8041624320,%rax
  804160424b:	00 00 00 
  804160424e:	48 8b 38             	mov    (%rax),%rdi
  8041604251:	48 b8 09 42 60 41 80 	movabs $0x8041604209,%rax
  8041604258:	00 00 00 
  804160425b:	ff d0                	callq  *%rax
}
  804160425d:	5d                   	pop    %rbp
  804160425e:	c3                   	retq   

000000804160425f <csys_yield>:

void
csys_yield(struct Trapframe *tf) {
  804160425f:	55                   	push   %rbp
  8041604260:	48 89 e5             	mov    %rsp,%rbp
  8041604263:	48 89 fe             	mov    %rdi,%rsi
  memcpy(&curenv->env_tf, tf, sizeof(struct Trapframe));
  8041604266:	ba c0 00 00 00       	mov    $0xc0,%edx
  804160426b:	48 b8 20 43 62 41 80 	movabs $0x8041624320,%rax
  8041604272:	00 00 00 
  8041604275:	48 8b 38             	mov    (%rax),%rdi
  8041604278:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  804160427f:	00 00 00 
  8041604282:	ff d0                	callq  *%rax
  sched_yield();
  8041604284:	48 b8 80 45 60 41 80 	movabs $0x8041604580,%rax
  804160428b:	00 00 00 
  804160428e:	ff d0                	callq  *%rax

0000008041604290 <env_pop_tf>:
// This exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
  8041604290:	55                   	push   %rbp
  8041604291:	48 89 e5             	mov    %rsp,%rbp
  8041604294:	53                   	push   %rbx
  8041604295:	48 83 ec 08          	sub    $0x8,%rsp
  8041604299:	48 89 f8             	mov    %rdi,%rax
#ifdef CONFIG_KSPACE
  static uintptr_t rip = 0;
  rip                  = tf->tf_rip;

  asm volatile(
  804160429c:	48 8b 58 68          	mov    0x68(%rax),%rbx
  80416042a0:	48 8b 48 60          	mov    0x60(%rax),%rcx
  80416042a4:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80416042a8:	48 8b 70 40          	mov    0x40(%rax),%rsi
  80416042ac:	48 8b 78 48          	mov    0x48(%rax),%rdi
  80416042b0:	48 8b 68 50          	mov    0x50(%rax),%rbp
  80416042b4:	48 8b a0 b0 00 00 00 	mov    0xb0(%rax),%rsp
  80416042bb:	4c 8b 40 38          	mov    0x38(%rax),%r8
  80416042bf:	4c 8b 48 30          	mov    0x30(%rax),%r9
  80416042c3:	4c 8b 50 28          	mov    0x28(%rax),%r10
  80416042c7:	4c 8b 58 20          	mov    0x20(%rax),%r11
  80416042cb:	4c 8b 60 18          	mov    0x18(%rax),%r12
  80416042cf:	4c 8b 68 10          	mov    0x10(%rax),%r13
  80416042d3:	4c 8b 70 08          	mov    0x8(%rax),%r14
  80416042d7:	4c 8b 38             	mov    (%rax),%r15
  80416042da:	ff b0 98 00 00 00    	pushq  0x98(%rax)
  80416042e0:	ff b0 a8 00 00 00    	pushq  0xa8(%rax)
  80416042e6:	48 8b 40 70          	mov    0x70(%rax),%rax
  80416042ea:	9d                   	popfq  
  80416042eb:	c3                   	retq   
        [ rflags ] "i"(offsetof(struct Trapframe, tf_rflags)),
        [ rsp ] "i"(offsetof(struct Trapframe, tf_rsp))
      : "cc", "memory", "ebx", "ecx", "edx", "esi", "edi");
#else
#endif
  panic("BUG"); /* mostly to placate the compiler */
  80416042ec:	48 ba 2d 6d 60 41 80 	movabs $0x8041606d2d,%rdx
  80416042f3:	00 00 00 
  80416042f6:	be d9 01 00 00       	mov    $0x1d9,%esi
  80416042fb:	48 bf ed 6c 60 41 80 	movabs $0x8041606ced,%rdi
  8041604302:	00 00 00 
  8041604305:	b8 00 00 00 00       	mov    $0x0,%eax
  804160430a:	48 b9 25 03 60 41 80 	movabs $0x8041600325,%rcx
  8041604311:	00 00 00 
  8041604314:	ff d1                	callq  *%rcx

0000008041604316 <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
  8041604316:	55                   	push   %rbp
  8041604317:	48 89 e5             	mov    %rsp,%rbp
  804160431a:	41 54                	push   %r12
  804160431c:	53                   	push   %rbx
  804160431d:	48 89 fb             	mov    %rdi,%rbx
#ifdef CONFIG_KSPACE
  cprintf("envrun %s: %d\n",
  8041604320:	8b 97 c8 00 00 00    	mov    0xc8(%rdi),%edx
  8041604326:	83 e2 1f             	and    $0x1f,%edx
          e->env_status == ENV_RUNNING ? "RUNNING" :
  8041604329:	8b 87 d4 00 00 00    	mov    0xd4(%rdi),%eax
  cprintf("envrun %s: %d\n",
  804160432f:	48 be 3b 6d 60 41 80 	movabs $0x8041606d3b,%rsi
  8041604336:	00 00 00 
  8041604339:	83 f8 03             	cmp    $0x3,%eax
  804160433c:	74 1b                	je     8041604359 <env_run+0x43>
                                         e->env_status == ENV_RUNNABLE ? "RUNNABLE" : "(unknown)",
  804160433e:	83 f8 02             	cmp    $0x2,%eax
  8041604341:	48 be 43 6d 60 41 80 	movabs $0x8041606d43,%rsi
  8041604348:	00 00 00 
  804160434b:	48 b8 31 6d 60 41 80 	movabs $0x8041606d31,%rax
  8041604352:	00 00 00 
  8041604355:	48 0f 45 f0          	cmovne %rax,%rsi
  cprintf("envrun %s: %d\n",
  8041604359:	48 bf 4c 6d 60 41 80 	movabs $0x8041606d4c,%rdi
  8041604360:	00 00 00 
  8041604363:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604368:	48 b9 49 44 60 41 80 	movabs $0x8041604449,%rcx
  804160436f:	00 00 00 
  8041604372:	ff d1                	callq  *%rcx
  //	and make sure you have set the relevant parts of
  //	e->env_tf to sensible values.
  //
  // LAB 3: Your code here.

  if (curenv) {  // if curenv == False, значит, какого-нибудь исполняемого процесса нет
  8041604374:	48 b8 20 43 62 41 80 	movabs $0x8041624320,%rax
  804160437b:	00 00 00 
  804160437e:	4c 8b 20             	mov    (%rax),%r12
  8041604381:	4d 85 e4             	test   %r12,%r12
  8041604384:	74 12                	je     8041604398 <env_run+0x82>
    if (curenv->env_status == ENV_DYING) { // если процесс стал зомби
  8041604386:	41 8b 84 24 d4 00 00 	mov    0xd4(%r12),%eax
  804160438d:	00 
  804160438e:	83 f8 01             	cmp    $0x1,%eax
  8041604391:	74 32                	je     80416043c5 <env_run+0xaf>
      struct Env *old = curenv;  // ставим старый адрес
      env_free(curenv);  // самурай запятнал свой env – убираем его в ножны дабы стереть кровь
      if (old == e) { // e - аргумент функции, который к нам пришел
        sched_yield();  // переключение системными вызовами 
      }
    } else if (curenv->env_status == ENV_RUNNING) { // если процесс можем запустить
  8041604393:	83 f8 03             	cmp    $0x3,%eax
  8041604396:	74 4d                	je     80416043e5 <env_run+0xcf>
      curenv->env_status = ENV_RUNNABLE;  // запускаем процесс
    }
  }
  
  curenv = e;  // текущая среда – е
  8041604398:	48 89 d8             	mov    %rbx,%rax
  804160439b:	48 a3 20 43 62 41 80 	movabs %rax,0x8041624320
  80416043a2:	00 00 00 
  curenv->env_status = ENV_RUNNING; // устанавливаем статус среды на "выполняется"
  80416043a5:	c7 83 d4 00 00 00 03 	movl   $0x3,0xd4(%rbx)
  80416043ac:	00 00 00 
  curenv->env_runs++; // обновляем количество запусков контекста процесса
  80416043af:	83 83 d8 00 00 00 01 	addl   $0x1,0xd8(%rbx)

  env_pop_tf(&curenv->env_tf); // восстанавливаем из curen все переменные окружения
  80416043b6:	48 89 df             	mov    %rbx,%rdi
  80416043b9:	48 b8 90 42 60 41 80 	movabs $0x8041604290,%rax
  80416043c0:	00 00 00 
  80416043c3:	ff d0                	callq  *%rax
      env_free(curenv);  // самурай запятнал свой env – убираем его в ножны дабы стереть кровь
  80416043c5:	4c 89 e7             	mov    %r12,%rdi
  80416043c8:	48 b8 9a 41 60 41 80 	movabs $0x804160419a,%rax
  80416043cf:	00 00 00 
  80416043d2:	ff d0                	callq  *%rax
      if (old == e) { // e - аргумент функции, который к нам пришел
  80416043d4:	49 39 dc             	cmp    %rbx,%r12
  80416043d7:	75 bf                	jne    8041604398 <env_run+0x82>
        sched_yield();  // переключение системными вызовами 
  80416043d9:	48 b8 80 45 60 41 80 	movabs $0x8041604580,%rax
  80416043e0:	00 00 00 
  80416043e3:	ff d0                	callq  *%rax
      curenv->env_status = ENV_RUNNABLE;  // запускаем процесс
  80416043e5:	41 c7 84 24 d4 00 00 	movl   $0x2,0xd4(%r12)
  80416043ec:	00 02 00 00 00 
  80416043f1:	eb a5                	jmp    8041604398 <env_run+0x82>

00000080416043f3 <putch>:
#include <inc/types.h>
#include <inc/stdio.h>
#include <inc/stdarg.h>

static void
putch(int ch, int *cnt) {
  80416043f3:	55                   	push   %rbp
  80416043f4:	48 89 e5             	mov    %rsp,%rbp
  80416043f7:	53                   	push   %rbx
  80416043f8:	48 83 ec 08          	sub    $0x8,%rsp
  80416043fc:	48 89 f3             	mov    %rsi,%rbx
  cputchar(ch);
  80416043ff:	48 b8 a3 0b 60 41 80 	movabs $0x8041600ba3,%rax
  8041604406:	00 00 00 
  8041604409:	ff d0                	callq  *%rax
  (*cnt)++;
  804160440b:	83 03 01             	addl   $0x1,(%rbx)
}
  804160440e:	48 83 c4 08          	add    $0x8,%rsp
  8041604412:	5b                   	pop    %rbx
  8041604413:	5d                   	pop    %rbp
  8041604414:	c3                   	retq   

0000008041604415 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8041604415:	55                   	push   %rbp
  8041604416:	48 89 e5             	mov    %rsp,%rbp
  8041604419:	48 83 ec 10          	sub    $0x10,%rsp
  804160441d:	48 89 fa             	mov    %rdi,%rdx
  8041604420:	48 89 f1             	mov    %rsi,%rcx
  int cnt = 0;
  8041604423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  vprintfmt((void *)putch, &cnt, fmt, ap);
  804160442a:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
  804160442e:	48 bf f3 43 60 41 80 	movabs $0x80416043f3,%rdi
  8041604435:	00 00 00 
  8041604438:	48 b8 fd 4a 60 41 80 	movabs $0x8041604afd,%rax
  804160443f:	00 00 00 
  8041604442:	ff d0                	callq  *%rax
  return cnt;
}
  8041604444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041604447:	c9                   	leaveq 
  8041604448:	c3                   	retq   

0000008041604449 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8041604449:	55                   	push   %rbp
  804160444a:	48 89 e5             	mov    %rsp,%rbp
  804160444d:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8041604454:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804160445b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8041604462:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8041604469:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041604470:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8041604477:	84 c0                	test   %al,%al
  8041604479:	74 20                	je     804160449b <cprintf+0x52>
  804160447b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804160447f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8041604483:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8041604487:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804160448b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804160448f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8041604493:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8041604497:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int cnt;

  va_start(ap, fmt);
  804160449b:	c7 85 38 ff ff ff 08 	movl   $0x8,-0xc8(%rbp)
  80416044a2:	00 00 00 
  80416044a5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80416044ac:	00 00 00 
  80416044af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80416044b3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80416044ba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80416044c1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  cnt = vcprintf(fmt, ap);
  80416044c8:	48 8d b5 38 ff ff ff 	lea    -0xc8(%rbp),%rsi
  80416044cf:	48 b8 15 44 60 41 80 	movabs $0x8041604415,%rax
  80416044d6:	00 00 00 
  80416044d9:	ff d0                	callq  *%rax
  va_end(ap);

  return cnt;
}
  80416044db:	c9                   	leaveq 
  80416044dc:	c3                   	retq   

00000080416044dd <sched_halt>:
  int i;

  // For debugging and testing purposes, if there are no runnable
  // environments in the system, then drop into the kernel monitor.
  for (i = 0; i < NENV; i++) {
    if ((envs[i].env_status == ENV_RUNNABLE ||
  80416044dd:	48 a1 88 87 61 41 80 	movabs 0x8041618788,%rax
  80416044e4:	00 00 00 
         envs[i].env_status == ENV_RUNNING ||
  80416044e7:	8b b0 d4 00 00 00    	mov    0xd4(%rax),%esi
  80416044ed:	8d 56 ff             	lea    -0x1(%rsi),%edx
    if ((envs[i].env_status == ENV_RUNNABLE ||
  80416044f0:	83 fa 02             	cmp    $0x2,%edx
  80416044f3:	76 5f                	jbe    8041604554 <sched_halt+0x77>
  80416044f5:	48 05 b4 01 00 00    	add    $0x1b4,%rax
  for (i = 0; i < NENV; i++) {
  80416044fb:	b9 01 00 00 00       	mov    $0x1,%ecx
         envs[i].env_status == ENV_RUNNING ||
  8041604500:	8b 30                	mov    (%rax),%esi
  8041604502:	8d 56 ff             	lea    -0x1(%rsi),%edx
    if ((envs[i].env_status == ENV_RUNNABLE ||
  8041604505:	83 fa 02             	cmp    $0x2,%edx
  8041604508:	76 45                	jbe    804160454f <sched_halt+0x72>
  for (i = 0; i < NENV; i++) {
  804160450a:	83 c1 01             	add    $0x1,%ecx
  804160450d:	48 05 e0 00 00 00    	add    $0xe0,%rax
  8041604513:	83 f9 20             	cmp    $0x20,%ecx
  8041604516:	75 e8                	jne    8041604500 <sched_halt+0x23>
sched_halt(void) {
  8041604518:	55                   	push   %rbp
  8041604519:	48 89 e5             	mov    %rsp,%rbp
  804160451c:	53                   	push   %rbx
  804160451d:	48 83 ec 08          	sub    $0x8,%rsp
         envs[i].env_status == ENV_DYING))
      break;
  }
  if (i == NENV) {
    cprintf("No runnable environments in the system!\n");
  8041604521:	48 bf 80 6d 60 41 80 	movabs $0x8041606d80,%rdi
  8041604528:	00 00 00 
  804160452b:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604530:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041604537:	00 00 00 
  804160453a:	ff d2                	callq  *%rdx
    while (1)
      monitor(NULL);
  804160453c:	48 bb d3 3a 60 41 80 	movabs $0x8041603ad3,%rbx
  8041604543:	00 00 00 
  8041604546:	bf 00 00 00 00       	mov    $0x0,%edi
  804160454b:	ff d3                	callq  *%rbx
  804160454d:	eb f7                	jmp    8041604546 <sched_halt+0x69>
  if (i == NENV) {
  804160454f:	83 f9 20             	cmp    $0x20,%ecx
  8041604552:	74 c4                	je     8041604518 <sched_halt+0x3b>
  }

  // Mark that no environment is running on CPU
  curenv = NULL;
  8041604554:	48 b8 20 43 62 41 80 	movabs $0x8041624320,%rax
  804160455b:	00 00 00 
  804160455e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  // Reset stack pointer, enable interrupts and then halt.
  asm volatile(
  8041604565:	48 a1 64 63 62 41 80 	movabs 0x8041626364,%rax
  804160456c:	00 00 00 
  804160456f:	48 c7 c5 00 00 00 00 	mov    $0x0,%rbp
  8041604576:	48 89 c4             	mov    %rax,%rsp
  8041604579:	6a 00                	pushq  $0x0
  804160457b:	6a 00                	pushq  $0x0
  804160457d:	fb                   	sti    
  804160457e:	f4                   	hlt    
  804160457f:	c3                   	retq   

0000008041604580 <sched_yield>:
sched_yield(void) {
  8041604580:	55                   	push   %rbp
  8041604581:	48 89 e5             	mov    %rsp,%rbp
  if (curenv) {
  8041604584:	48 a1 20 43 62 41 80 	movabs 0x8041624320,%rax
  804160458b:	00 00 00 
    id = -1;
  804160458e:	be ff ff ff ff       	mov    $0xffffffff,%esi
  if (curenv) {
  8041604593:	48 85 c0             	test   %rax,%rax
  8041604596:	74 09                	je     80416045a1 <sched_yield+0x21>
    id = ENVX(curenv_getid());
  8041604598:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  804160459e:	83 e6 1f             	and    $0x1f,%esi
    if (envs[id].env_status == ENV_RUNNABLE || 
  80416045a1:	48 b8 88 87 61 41 80 	movabs $0x8041618788,%rax
  80416045a8:	00 00 00 
  80416045ab:	4c 8b 00             	mov    (%rax),%r8
  80416045ae:	89 f2                	mov    %esi,%edx
  80416045b0:	eb 04                	jmp    80416045b6 <sched_yield+0x36>
  } while (id != orig);
  80416045b2:	39 c6                	cmp    %eax,%esi
  80416045b4:	74 45                	je     80416045fb <sched_yield+0x7b>
    id = (id + 1) % NENV;
  80416045b6:	8d 42 01             	lea    0x1(%rdx),%eax
  80416045b9:	99                   	cltd   
  80416045ba:	c1 ea 1b             	shr    $0x1b,%edx
  80416045bd:	01 d0                	add    %edx,%eax
  80416045bf:	83 e0 1f             	and    $0x1f,%eax
  80416045c2:	29 d0                	sub    %edx,%eax
  80416045c4:	89 c2                	mov    %eax,%edx
    if (envs[id].env_status == ENV_RUNNABLE || 
  80416045c6:	48 63 c8             	movslq %eax,%rcx
  80416045c9:	48 8d 3c cd 00 00 00 	lea    0x0(,%rcx,8),%rdi
  80416045d0:	00 
  80416045d1:	48 29 cf             	sub    %rcx,%rdi
  80416045d4:	48 c1 e7 05          	shl    $0x5,%rdi
  80416045d8:	4c 01 c7             	add    %r8,%rdi
  80416045db:	8b 8f d4 00 00 00    	mov    0xd4(%rdi),%ecx
  80416045e1:	83 f9 02             	cmp    $0x2,%ecx
  80416045e4:	74 09                	je     80416045ef <sched_yield+0x6f>
        (id == orig && envs[id].env_status == ENV_RUNNING)) {
  80416045e6:	83 f9 03             	cmp    $0x3,%ecx
  80416045e9:	75 c7                	jne    80416045b2 <sched_yield+0x32>
  80416045eb:	39 c6                	cmp    %eax,%esi
  80416045ed:	75 c3                	jne    80416045b2 <sched_yield+0x32>
      env_run(envs + id); 
  80416045ef:	48 b8 16 43 60 41 80 	movabs $0x8041604316,%rax
  80416045f6:	00 00 00 
  80416045f9:	ff d0                	callq  *%rax
  sched_halt();
  80416045fb:	48 b8 dd 44 60 41 80 	movabs $0x80416044dd,%rax
  8041604602:	00 00 00 
  8041604605:	ff d0                	callq  *%rax
}
  8041604607:	5d                   	pop    %rbp
  8041604608:	c3                   	retq   

0000008041604609 <load_kernel_dwarf_info>:
#include <kern/kdebug.h>
#include <kern/env.h>
#include <inc/uefi.h>

void
load_kernel_dwarf_info(struct Dwarf_Addrs *addrs) {
  8041604609:	55                   	push   %rbp
  804160460a:	48 89 e5             	mov    %rsp,%rbp
  addrs->aranges_begin  = (unsigned char *)(uefi_lp->DebugArangesStart);
  804160460d:	48 ba 00 80 61 41 80 	movabs $0x8041618000,%rdx
  8041604614:	00 00 00 
  8041604617:	48 8b 02             	mov    (%rdx),%rax
  804160461a:	48 8b 48 58          	mov    0x58(%rax),%rcx
  804160461e:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  addrs->aranges_end    = (unsigned char *)(uefi_lp->DebugArangesEnd);
  8041604622:	48 8b 48 60          	mov    0x60(%rax),%rcx
  8041604626:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  addrs->abbrev_begin   = (unsigned char *)(uefi_lp->DebugAbbrevStart);
  804160462a:	48 8b 40 68          	mov    0x68(%rax),%rax
  804160462e:	48 89 07             	mov    %rax,(%rdi)
  addrs->abbrev_end     = (unsigned char *)(uefi_lp->DebugAbbrevEnd);
  8041604631:	48 8b 02             	mov    (%rdx),%rax
  8041604634:	48 8b 50 70          	mov    0x70(%rax),%rdx
  8041604638:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  addrs->info_begin     = (unsigned char *)(uefi_lp->DebugInfoStart);
  804160463c:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8041604640:	48 89 57 20          	mov    %rdx,0x20(%rdi)
  addrs->info_end       = (unsigned char *)(uefi_lp->DebugInfoEnd);
  8041604644:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  804160464b:	48 89 57 28          	mov    %rdx,0x28(%rdi)
  addrs->line_begin     = (unsigned char *)(uefi_lp->DebugLineStart);
  804160464f:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8041604656:	48 89 57 30          	mov    %rdx,0x30(%rdi)
  addrs->line_end       = (unsigned char *)(uefi_lp->DebugLineEnd);
  804160465a:	48 8b 90 90 00 00 00 	mov    0x90(%rax),%rdx
  8041604661:	48 89 57 38          	mov    %rdx,0x38(%rdi)
  addrs->str_begin      = (unsigned char *)(uefi_lp->DebugStrStart);
  8041604665:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  804160466c:	48 89 57 40          	mov    %rdx,0x40(%rdi)
  addrs->str_end        = (unsigned char *)(uefi_lp->DebugStrEnd);
  8041604670:	48 8b 90 a0 00 00 00 	mov    0xa0(%rax),%rdx
  8041604677:	48 89 57 48          	mov    %rdx,0x48(%rdi)
  addrs->pubnames_begin = (unsigned char *)(uefi_lp->DebugPubnamesStart);
  804160467b:	48 8b 90 a8 00 00 00 	mov    0xa8(%rax),%rdx
  8041604682:	48 89 57 50          	mov    %rdx,0x50(%rdi)
  addrs->pubnames_end   = (unsigned char *)(uefi_lp->DebugPubnamesEnd);
  8041604686:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
  804160468d:	48 89 57 58          	mov    %rdx,0x58(%rdi)
  addrs->pubtypes_begin = (unsigned char *)(uefi_lp->DebugPubtypesStart);
  8041604691:	48 8b 90 b8 00 00 00 	mov    0xb8(%rax),%rdx
  8041604698:	48 89 57 60          	mov    %rdx,0x60(%rdi)
  addrs->pubtypes_end   = (unsigned char *)(uefi_lp->DebugPubtypesEnd);
  804160469c:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
  80416046a3:	48 89 47 68          	mov    %rax,0x68(%rdi)
}
  80416046a7:	5d                   	pop    %rbp
  80416046a8:	c3                   	retq   

00000080416046a9 <debuginfo_rip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_rip(uintptr_t addr, struct Ripdebuginfo *info) {
  80416046a9:	55                   	push   %rbp
  80416046aa:	48 89 e5             	mov    %rsp,%rbp
  80416046ad:	41 56                	push   %r14
  80416046af:	41 55                	push   %r13
  80416046b1:	41 54                	push   %r12
  80416046b3:	53                   	push   %rbx
  80416046b4:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  80416046bb:	49 89 fc             	mov    %rdi,%r12
  80416046be:	48 89 f3             	mov    %rsi,%rbx
  int code = 0;
  // Initialize *info
  strcpy(info->rip_file, "<unknown>");
  80416046c1:	48 be a9 6d 60 41 80 	movabs $0x8041606da9,%rsi
  80416046c8:	00 00 00 
  80416046cb:	48 89 df             	mov    %rbx,%rdi
  80416046ce:	49 bd e5 53 60 41 80 	movabs $0x80416053e5,%r13
  80416046d5:	00 00 00 
  80416046d8:	41 ff d5             	callq  *%r13
  info->rip_line = 0;
  80416046db:	c7 83 00 01 00 00 00 	movl   $0x0,0x100(%rbx)
  80416046e2:	00 00 00 
  strcpy(info->rip_fn_name, "<unknown>");
  80416046e5:	4c 8d b3 04 01 00 00 	lea    0x104(%rbx),%r14
  80416046ec:	48 be a9 6d 60 41 80 	movabs $0x8041606da9,%rsi
  80416046f3:	00 00 00 
  80416046f6:	4c 89 f7             	mov    %r14,%rdi
  80416046f9:	41 ff d5             	callq  *%r13
  info->rip_fn_namelen = 9;
  80416046fc:	c7 83 04 02 00 00 09 	movl   $0x9,0x204(%rbx)
  8041604703:	00 00 00 
  info->rip_fn_addr    = addr;
  8041604706:	4c 89 a3 08 02 00 00 	mov    %r12,0x208(%rbx)
  info->rip_fn_narg    = 0;
  804160470d:	c7 83 10 02 00 00 00 	movl   $0x0,0x210(%rbx)
  8041604714:	00 00 00 

  if (!addr) {
  8041604717:	4d 85 e4             	test   %r12,%r12
  804160471a:	0f 84 8c 01 00 00    	je     80416048ac <debuginfo_rip+0x203>
    return 0;
  }

  struct Dwarf_Addrs addrs;
  if (addr <= ULIM) {
  8041604720:	48 b8 00 00 c0 3e 80 	movabs $0x803ec00000,%rax
  8041604727:	00 00 00 
  804160472a:	49 39 c4             	cmp    %rax,%r12
  804160472d:	0f 86 4f 01 00 00    	jbe    8041604882 <debuginfo_rip+0x1d9>
    panic("Can't search for user-level addresses yet!");
  } else {
    load_kernel_dwarf_info(&addrs);
  8041604733:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  804160473a:	48 b8 09 46 60 41 80 	movabs $0x8041604609,%rax
  8041604741:	00 00 00 
  8041604744:	ff d0                	callq  *%rax
  }
  enum {
    BUFSIZE = 20,
  };
  Dwarf_Off offset = 0, line_offset = 0;
  8041604746:	48 c7 85 68 ff ff ff 	movq   $0x0,-0x98(%rbp)
  804160474d:	00 00 00 00 
  8041604751:	48 c7 85 60 ff ff ff 	movq   $0x0,-0xa0(%rbp)
  8041604758:	00 00 00 00 
  code = info_by_address(&addrs, addr, &offset);
  804160475c:	48 8d 95 68 ff ff ff 	lea    -0x98(%rbp),%rdx
  8041604763:	4c 89 e6             	mov    %r12,%rsi
  8041604766:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  804160476d:	48 b8 7e 15 60 41 80 	movabs $0x804160157e,%rax
  8041604774:	00 00 00 
  8041604777:	ff d0                	callq  *%rax
  8041604779:	41 89 c5             	mov    %eax,%r13d
  if (code < 0) {
  804160477c:	85 c0                	test   %eax,%eax
  804160477e:	0f 88 2e 01 00 00    	js     80416048b2 <debuginfo_rip+0x209>
    return code;
  }
  char *tmp_buf;
  void *buf;
  buf  = &tmp_buf;
  code = file_name_by_info(&addrs, offset, buf, sizeof(char *), &line_offset);
  8041604784:	4c 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%r8
  804160478b:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041604790:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8041604797:	48 8b b5 68 ff ff ff 	mov    -0x98(%rbp),%rsi
  804160479e:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  80416047a5:	48 b8 3e 1c 60 41 80 	movabs $0x8041601c3e,%rax
  80416047ac:	00 00 00 
  80416047af:	ff d0                	callq  *%rax
  80416047b1:	41 89 c5             	mov    %eax,%r13d
  strncpy(info->rip_file, tmp_buf, 256);
  80416047b4:	ba 00 01 00 00       	mov    $0x100,%edx
  80416047b9:	48 8b b5 58 ff ff ff 	mov    -0xa8(%rbp),%rsi
  80416047c0:	48 89 df             	mov    %rbx,%rdi
  80416047c3:	48 b8 3a 54 60 41 80 	movabs $0x804160543a,%rax
  80416047ca:	00 00 00 
  80416047cd:	ff d0                	callq  *%rax
  if (code < 0) {
  80416047cf:	45 85 ed             	test   %r13d,%r13d
  80416047d2:	0f 88 da 00 00 00    	js     80416048b2 <debuginfo_rip+0x209>
  // address of the next instruction, so we should substract 5 from it.
  // Hint: use line_for_address from kern/dwarf_lines.c
  // LAB 2: Your code here:

  buf  = &info->rip_line;
  addr = addr - 5;
  80416047d8:	49 83 ec 05          	sub    $0x5,%r12
  buf  = &info->rip_line;
  80416047dc:	48 8d 8b 00 01 00 00 	lea    0x100(%rbx),%rcx
  code = line_for_address(&addrs, addr, line_offset, buf);
  80416047e3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80416047ea:	4c 89 e6             	mov    %r12,%rsi
  80416047ed:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  80416047f4:	48 b8 5a 31 60 41 80 	movabs $0x804160315a,%rax
  80416047fb:	00 00 00 
  80416047fe:	ff d0                	callq  *%rax
  8041604800:	41 89 c5             	mov    %eax,%r13d
  if (code < 0) {
  8041604803:	85 c0                	test   %eax,%eax
  8041604805:	0f 88 a7 00 00 00    	js     80416048b2 <debuginfo_rip+0x209>
    return code;
  }
  buf  = &tmp_buf;
  code = function_by_info(&addrs, addr, offset, buf, sizeof(char *), &info->rip_fn_addr);
  804160480b:	4c 8d 8b 08 02 00 00 	lea    0x208(%rbx),%r9
  8041604812:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041604818:	48 8d 8d 58 ff ff ff 	lea    -0xa8(%rbp),%rcx
  804160481f:	48 8b 95 68 ff ff ff 	mov    -0x98(%rbp),%rdx
  8041604826:	4c 89 e6             	mov    %r12,%rsi
  8041604829:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  8041604830:	48 b8 8f 20 60 41 80 	movabs $0x804160208f,%rax
  8041604837:	00 00 00 
  804160483a:	ff d0                	callq  *%rax
  804160483c:	41 89 c5             	mov    %eax,%r13d
  strncpy(info->rip_fn_name, tmp_buf, 256);
  804160483f:	ba 00 01 00 00       	mov    $0x100,%edx
  8041604844:	48 8b b5 58 ff ff ff 	mov    -0xa8(%rbp),%rsi
  804160484b:	4c 89 f7             	mov    %r14,%rdi
  804160484e:	48 b8 3a 54 60 41 80 	movabs $0x804160543a,%rax
  8041604855:	00 00 00 
  8041604858:	ff d0                	callq  *%rax
  info->rip_fn_namelen = strnlen(info->rip_fn_name, 256);
  804160485a:	be 00 01 00 00       	mov    $0x100,%esi
  804160485f:	4c 89 f7             	mov    %r14,%rdi
  8041604862:	48 b8 ae 53 60 41 80 	movabs $0x80416053ae,%rax
  8041604869:	00 00 00 
  804160486c:	ff d0                	callq  *%rax
  804160486e:	89 83 04 02 00 00    	mov    %eax,0x204(%rbx)
  8041604874:	45 85 ed             	test   %r13d,%r13d
  8041604877:	b8 00 00 00 00       	mov    $0x0,%eax
  804160487c:	44 0f 4f e8          	cmovg  %eax,%r13d
  8041604880:	eb 30                	jmp    80416048b2 <debuginfo_rip+0x209>
    panic("Can't search for user-level addresses yet!");
  8041604882:	48 ba d8 6d 60 41 80 	movabs $0x8041606dd8,%rdx
  8041604889:	00 00 00 
  804160488c:	be 36 00 00 00       	mov    $0x36,%esi
  8041604891:	48 bf b3 6d 60 41 80 	movabs $0x8041606db3,%rdi
  8041604898:	00 00 00 
  804160489b:	b8 00 00 00 00       	mov    $0x0,%eax
  80416048a0:	48 b9 25 03 60 41 80 	movabs $0x8041600325,%rcx
  80416048a7:	00 00 00 
  80416048aa:	ff d1                	callq  *%rcx
    return 0;
  80416048ac:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  if (code < 0) {
    return code;
  }
  return 0;
}
  80416048b2:	44 89 e8             	mov    %r13d,%eax
  80416048b5:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  80416048bc:	5b                   	pop    %rbx
  80416048bd:	41 5c                	pop    %r12
  80416048bf:	41 5d                	pop    %r13
  80416048c1:	41 5e                	pop    %r14
  80416048c3:	5d                   	pop    %rbp
  80416048c4:	c3                   	retq   

00000080416048c5 <find_function>:

uintptr_t
find_function(const char *const fname) {
  80416048c5:	55                   	push   %rbp
  80416048c6:	48 89 e5             	mov    %rsp,%rbp
  80416048c9:	53                   	push   %rbx
  80416048ca:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  80416048d1:	48 89 fb             	mov    %rdi,%rbx
  // LAB 3: Your code here

  struct {
    const char *name;
    uintptr_t addr;
  } scentry[] = {
  80416048d4:	48 b8 87 00 60 41 80 	movabs $0x8041600087,%rax
  80416048db:	00 00 00 
  80416048de:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80416048e2:	48 b8 93 00 60 41 80 	movabs $0x8041600093,%rax
  80416048e9:	00 00 00 
  80416048ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    { "sys_yield", (uintptr_t)sys_yield },
    { "sys_exit", (uintptr_t)sys_exit },
  };

  for (size_t i = 0; i < sizeof(scentry)/sizeof(*scentry); i++) {
    if (!strcmp(scentry[i].name, fname)) {
  80416048f0:	48 89 fe             	mov    %rdi,%rsi
  80416048f3:	48 bf c1 6d 60 41 80 	movabs $0x8041606dc1,%rdi
  80416048fa:	00 00 00 
  80416048fd:	48 b8 ad 54 60 41 80 	movabs $0x80416054ad,%rax
  8041604904:	00 00 00 
  8041604907:	ff d0                	callq  *%rax
  8041604909:	85 c0                	test   %eax,%eax
  804160490b:	0f 84 ad 00 00 00    	je     80416049be <find_function+0xf9>
  8041604911:	48 89 de             	mov    %rbx,%rsi
  8041604914:	48 bf cb 6d 60 41 80 	movabs $0x8041606dcb,%rdi
  804160491b:	00 00 00 
  804160491e:	48 b8 ad 54 60 41 80 	movabs $0x80416054ad,%rax
  8041604925:	00 00 00 
  8041604928:	ff d0                	callq  *%rax
  804160492a:	85 c0                	test   %eax,%eax
  804160492c:	0f 84 85 00 00 00    	je     80416049b7 <find_function+0xf2>
      return scentry[i].addr;
    }
  }

  struct Dwarf_Addrs addrs;
  load_kernel_dwarf_info(&addrs);
  8041604932:	48 8d bd 60 ff ff ff 	lea    -0xa0(%rbp),%rdi
  8041604939:	48 b8 09 46 60 41 80 	movabs $0x8041604609,%rax
  8041604940:	00 00 00 
  8041604943:	ff d0                	callq  *%rax
  uintptr_t offset = 0;
  8041604945:	48 c7 85 58 ff ff ff 	movq   $0x0,-0xa8(%rbp)
  804160494c:	00 00 00 00 

  if (!address_by_fname(&addrs, fname, &offset) && offset) {
  8041604950:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8041604957:	48 89 de             	mov    %rbx,%rsi
  804160495a:	48 8d bd 60 ff ff ff 	lea    -0xa0(%rbp),%rdi
  8041604961:	48 b8 0b 26 60 41 80 	movabs $0x804160260b,%rax
  8041604968:	00 00 00 
  804160496b:	ff d0                	callq  *%rax
  804160496d:	85 c0                	test   %eax,%eax
  804160496f:	75 0c                	jne    804160497d <find_function+0xb8>
  8041604971:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8041604978:	48 85 d2             	test   %rdx,%rdx
  804160497b:	75 2d                	jne    80416049aa <find_function+0xe5>
    return offset;
  }

  if (!naive_address_by_fname(&addrs, fname, &offset)) {
  804160497d:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8041604984:	48 89 de             	mov    %rbx,%rsi
  8041604987:	48 8d bd 60 ff ff ff 	lea    -0xa0(%rbp),%rdi
  804160498e:	48 b8 10 2c 60 41 80 	movabs $0x8041602c10,%rax
  8041604995:	00 00 00 
  8041604998:	ff d0                	callq  *%rax
    return offset;
  }

  return 0;
  804160499a:	ba 00 00 00 00       	mov    $0x0,%edx
  if (!naive_address_by_fname(&addrs, fname, &offset)) {
  804160499f:	85 c0                	test   %eax,%eax
  80416049a1:	75 07                	jne    80416049aa <find_function+0xe5>
    return offset;
  80416049a3:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80416049aa:	48 89 d0             	mov    %rdx,%rax
  80416049ad:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  80416049b4:	5b                   	pop    %rbx
  80416049b5:	5d                   	pop    %rbp
  80416049b6:	c3                   	retq   
  for (size_t i = 0; i < sizeof(scentry)/sizeof(*scentry); i++) {
  80416049b7:	b8 01 00 00 00       	mov    $0x1,%eax
  80416049bc:	eb 05                	jmp    80416049c3 <find_function+0xfe>
  80416049be:	b8 00 00 00 00       	mov    $0x0,%eax
      return scentry[i].addr;
  80416049c3:	48 c1 e0 04          	shl    $0x4,%rax
  80416049c7:	48 8b 54 05 d8       	mov    -0x28(%rbp,%rax,1),%rdx
  80416049cc:	eb dc                	jmp    80416049aa <find_function+0xe5>

00000080416049ce <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc) {
  80416049ce:	55                   	push   %rbp
  80416049cf:	48 89 e5             	mov    %rsp,%rbp
  80416049d2:	41 57                	push   %r15
  80416049d4:	41 56                	push   %r14
  80416049d6:	41 55                	push   %r13
  80416049d8:	41 54                	push   %r12
  80416049da:	53                   	push   %rbx
  80416049db:	48 83 ec 18          	sub    $0x18,%rsp
  80416049df:	49 89 fc             	mov    %rdi,%r12
  80416049e2:	49 89 f5             	mov    %rsi,%r13
  80416049e5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80416049e9:	45 89 ce             	mov    %r9d,%r14d
  // first recursively print all preceding (more significant) digits
  if (num >= base) {
  80416049ec:	41 89 cf             	mov    %ecx,%r15d
  80416049ef:	49 39 d7             	cmp    %rdx,%r15
  80416049f2:	76 45                	jbe    8041604a39 <printnum+0x6b>
    printnum(putch, putdat, num / base, base, width - 1, padc);
  } else {
    // print any needed pad characters before first digit
    while (--width > 0)
  80416049f4:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
  80416049f8:	85 db                	test   %ebx,%ebx
  80416049fa:	7e 0e                	jle    8041604a0a <printnum+0x3c>
      putch(padc, putdat);
  80416049fc:	4c 89 ee             	mov    %r13,%rsi
  80416049ff:	44 89 f7             	mov    %r14d,%edi
  8041604a02:	41 ff d4             	callq  *%r12
    while (--width > 0)
  8041604a05:	83 eb 01             	sub    $0x1,%ebx
  8041604a08:	75 f2                	jne    80416049fc <printnum+0x2e>
  }

  // then print this (the least significant) digit
  putch("0123456789abcdef"[num % base], putdat);
  8041604a0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041604a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  8041604a13:	49 f7 f7             	div    %r15
  8041604a16:	48 b8 03 6e 60 41 80 	movabs $0x8041606e03,%rax
  8041604a1d:	00 00 00 
  8041604a20:	0f be 3c 10          	movsbl (%rax,%rdx,1),%edi
  8041604a24:	4c 89 ee             	mov    %r13,%rsi
  8041604a27:	41 ff d4             	callq  *%r12
}
  8041604a2a:	48 83 c4 18          	add    $0x18,%rsp
  8041604a2e:	5b                   	pop    %rbx
  8041604a2f:	41 5c                	pop    %r12
  8041604a31:	41 5d                	pop    %r13
  8041604a33:	41 5e                	pop    %r14
  8041604a35:	41 5f                	pop    %r15
  8041604a37:	5d                   	pop    %rbp
  8041604a38:	c3                   	retq   
    printnum(putch, putdat, num / base, base, width - 1, padc);
  8041604a39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041604a3d:	ba 00 00 00 00       	mov    $0x0,%edx
  8041604a42:	49 f7 f7             	div    %r15
  8041604a45:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8041604a49:	48 89 c2             	mov    %rax,%rdx
  8041604a4c:	48 b8 ce 49 60 41 80 	movabs $0x80416049ce,%rax
  8041604a53:	00 00 00 
  8041604a56:	ff d0                	callq  *%rax
  8041604a58:	eb b0                	jmp    8041604a0a <printnum+0x3c>

0000008041604a5a <sprintputch>:
  char *ebuf;
  int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b) {
  8041604a5a:	55                   	push   %rbp
  8041604a5b:	48 89 e5             	mov    %rsp,%rbp
  b->cnt++;
  8041604a5e:	83 46 10 01          	addl   $0x1,0x10(%rsi)
  if (b->buf < b->ebuf)
  8041604a62:	48 8b 06             	mov    (%rsi),%rax
  8041604a65:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8041604a69:	73 0a                	jae    8041604a75 <sprintputch+0x1b>
    *b->buf++ = ch;
  8041604a6b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8041604a6f:	48 89 16             	mov    %rdx,(%rsi)
  8041604a72:	40 88 38             	mov    %dil,(%rax)
}
  8041604a75:	5d                   	pop    %rbp
  8041604a76:	c3                   	retq   

0000008041604a77 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8041604a77:	55                   	push   %rbp
  8041604a78:	48 89 e5             	mov    %rsp,%rbp
  8041604a7b:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8041604a82:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8041604a89:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041604a90:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8041604a97:	84 c0                	test   %al,%al
  8041604a99:	74 20                	je     8041604abb <printfmt+0x44>
  8041604a9b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8041604a9f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8041604aa3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8041604aa7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8041604aab:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8041604aaf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8041604ab3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8041604ab7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_start(ap, fmt);
  8041604abb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8041604ac2:	00 00 00 
  8041604ac5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8041604acc:	00 00 00 
  8041604acf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041604ad3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8041604ada:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8041604ae1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  vprintfmt(putch, putdat, fmt, ap);
  8041604ae8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8041604aef:	48 b8 fd 4a 60 41 80 	movabs $0x8041604afd,%rax
  8041604af6:	00 00 00 
  8041604af9:	ff d0                	callq  *%rax
}
  8041604afb:	c9                   	leaveq 
  8041604afc:	c3                   	retq   

0000008041604afd <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap) {
  8041604afd:	55                   	push   %rbp
  8041604afe:	48 89 e5             	mov    %rsp,%rbp
  8041604b01:	41 57                	push   %r15
  8041604b03:	41 56                	push   %r14
  8041604b05:	41 55                	push   %r13
  8041604b07:	41 54                	push   %r12
  8041604b09:	53                   	push   %rbx
  8041604b0a:	48 83 ec 48          	sub    $0x48,%rsp
  8041604b0e:	49 89 fd             	mov    %rdi,%r13
  8041604b11:	49 89 f6             	mov    %rsi,%r14
  8041604b14:	49 89 d7             	mov    %rdx,%r15
  va_copy(aq, ap);
  8041604b17:	48 8b 01             	mov    (%rcx),%rax
  8041604b1a:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  8041604b1e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8041604b22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8041604b26:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8041604b2a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    while ((ch = *(unsigned char *)fmt++) != '%') {
  8041604b2e:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8041604b32:	41 0f b6 3f          	movzbl (%r15),%edi
  8041604b36:	83 ff 25             	cmp    $0x25,%edi
  8041604b39:	74 18                	je     8041604b53 <vprintfmt+0x56>
      if (ch == '\0')
  8041604b3b:	85 ff                	test   %edi,%edi
  8041604b3d:	0f 84 24 06 00 00    	je     8041605167 <vprintfmt+0x66a>
      putch(ch, putdat);
  8041604b43:	4c 89 f6             	mov    %r14,%rsi
  8041604b46:	41 ff d5             	callq  *%r13
    while ((ch = *(unsigned char *)fmt++) != '%') {
  8041604b49:	49 89 df             	mov    %rbx,%r15
  8041604b4c:	eb e0                	jmp    8041604b2e <vprintfmt+0x31>
        for (fmt--; fmt[-1] != '%'; fmt--)
  8041604b4e:	49 89 df             	mov    %rbx,%r15
  8041604b51:	eb db                	jmp    8041604b2e <vprintfmt+0x31>
        precision = va_arg(aq, int);
  8041604b53:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    padc      = ' ';
  8041604b57:	c6 45 98 20          	movb   $0x20,-0x68(%rbp)
    altflag   = 0;
  8041604b5b:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%rbp)
    precision = -1;
  8041604b62:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
    width     = -1;
  8041604b68:	44 89 65 a8          	mov    %r12d,-0x58(%rbp)
    lflag     = 0;
  8041604b6c:	b9 00 00 00 00       	mov    $0x0,%ecx
        altflag = 1;
  8041604b71:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  8041604b77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
        padc = '0';
  8041604b7d:	41 b8 30 00 00 00    	mov    $0x30,%r8d
        padc = '-';
  8041604b83:	bf 2d 00 00 00       	mov    $0x2d,%edi
    switch (ch = *(unsigned char *)fmt++) {
  8041604b88:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8041604b8c:	0f b6 13             	movzbl (%rbx),%edx
  8041604b8f:	8d 42 dd             	lea    -0x23(%rdx),%eax
  8041604b92:	3c 55                	cmp    $0x55,%al
  8041604b94:	0f 87 7d 05 00 00    	ja     8041605117 <vprintfmt+0x61a>
  8041604b9a:	0f b6 c0             	movzbl %al,%eax
  8041604b9d:	49 bb c0 6e 60 41 80 	movabs $0x8041606ec0,%r11
  8041604ba4:	00 00 00 
  8041604ba7:	41 ff 24 c3          	jmpq   *(%r11,%rax,8)
  8041604bab:	4c 89 fb             	mov    %r15,%rbx
        padc = '-';
  8041604bae:	40 88 7d 98          	mov    %dil,-0x68(%rbp)
  8041604bb2:	eb d4                	jmp    8041604b88 <vprintfmt+0x8b>
    switch (ch = *(unsigned char *)fmt++) {
  8041604bb4:	4c 89 fb             	mov    %r15,%rbx
        padc = '0';
  8041604bb7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8041604bbb:	eb cb                	jmp    8041604b88 <vprintfmt+0x8b>
    switch (ch = *(unsigned char *)fmt++) {
  8041604bbd:	0f b6 d2             	movzbl %dl,%edx
          precision = precision * 10 + ch - '0';
  8041604bc0:	44 8d 62 d0          	lea    -0x30(%rdx),%r12d
          ch        = *fmt;
  8041604bc4:	0f be 43 01          	movsbl 0x1(%rbx),%eax
          if (ch < '0' || ch > '9')
  8041604bc8:	8d 50 d0             	lea    -0x30(%rax),%edx
  8041604bcb:	83 fa 09             	cmp    $0x9,%edx
  8041604bce:	77 7e                	ja     8041604c4e <vprintfmt+0x151>
        for (precision = 0;; ++fmt) {
  8041604bd0:	49 83 c7 01          	add    $0x1,%r15
          precision = precision * 10 + ch - '0';
  8041604bd4:	43 8d 14 a4          	lea    (%r12,%r12,4),%edx
  8041604bd8:	44 8d 64 50 d0       	lea    -0x30(%rax,%rdx,2),%r12d
          ch        = *fmt;
  8041604bdd:	41 0f be 07          	movsbl (%r15),%eax
          if (ch < '0' || ch > '9')
  8041604be1:	8d 50 d0             	lea    -0x30(%rax),%edx
  8041604be4:	83 fa 09             	cmp    $0x9,%edx
  8041604be7:	76 e7                	jbe    8041604bd0 <vprintfmt+0xd3>
        for (precision = 0;; ++fmt) {
  8041604be9:	4c 89 fb             	mov    %r15,%rbx
  8041604bec:	eb 19                	jmp    8041604c07 <vprintfmt+0x10a>
        precision = va_arg(aq, int);
  8041604bee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604bf1:	83 fa 2f             	cmp    $0x2f,%edx
  8041604bf4:	77 2a                	ja     8041604c20 <vprintfmt+0x123>
  8041604bf6:	89 d0                	mov    %edx,%eax
  8041604bf8:	48 01 f0             	add    %rsi,%rax
  8041604bfb:	83 c2 08             	add    $0x8,%edx
  8041604bfe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604c01:	44 8b 20             	mov    (%rax),%r12d
    switch (ch = *(unsigned char *)fmt++) {
  8041604c04:	4c 89 fb             	mov    %r15,%rbx
        if (width < 0)
  8041604c07:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  8041604c0b:	0f 89 77 ff ff ff    	jns    8041604b88 <vprintfmt+0x8b>
          width = precision, precision = -1;
  8041604c11:	44 89 65 a8          	mov    %r12d,-0x58(%rbp)
  8041604c15:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  8041604c1b:	e9 68 ff ff ff       	jmpq   8041604b88 <vprintfmt+0x8b>
        precision = va_arg(aq, int);
  8041604c20:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041604c24:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8041604c28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8041604c2c:	eb d3                	jmp    8041604c01 <vprintfmt+0x104>
  8041604c2e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8041604c31:	85 c0                	test   %eax,%eax
  8041604c33:	41 0f 48 c1          	cmovs  %r9d,%eax
  8041604c37:	89 45 a8             	mov    %eax,-0x58(%rbp)
    switch (ch = *(unsigned char *)fmt++) {
  8041604c3a:	4c 89 fb             	mov    %r15,%rbx
  8041604c3d:	e9 46 ff ff ff       	jmpq   8041604b88 <vprintfmt+0x8b>
  8041604c42:	4c 89 fb             	mov    %r15,%rbx
        altflag = 1;
  8041604c45:	44 89 55 a4          	mov    %r10d,-0x5c(%rbp)
        goto reswitch;
  8041604c49:	e9 3a ff ff ff       	jmpq   8041604b88 <vprintfmt+0x8b>
    switch (ch = *(unsigned char *)fmt++) {
  8041604c4e:	4c 89 fb             	mov    %r15,%rbx
  8041604c51:	eb b4                	jmp    8041604c07 <vprintfmt+0x10a>
        lflag++;
  8041604c53:	83 c1 01             	add    $0x1,%ecx
    switch (ch = *(unsigned char *)fmt++) {
  8041604c56:	4c 89 fb             	mov    %r15,%rbx
        goto reswitch;
  8041604c59:	e9 2a ff ff ff       	jmpq   8041604b88 <vprintfmt+0x8b>
        putch(va_arg(aq, int), putdat);
  8041604c5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604c61:	83 fa 2f             	cmp    $0x2f,%edx
  8041604c64:	77 18                	ja     8041604c7e <vprintfmt+0x181>
  8041604c66:	89 d0                	mov    %edx,%eax
  8041604c68:	48 01 f0             	add    %rsi,%rax
  8041604c6b:	83 c2 08             	add    $0x8,%edx
  8041604c6e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604c71:	4c 89 f6             	mov    %r14,%rsi
  8041604c74:	8b 38                	mov    (%rax),%edi
  8041604c76:	41 ff d5             	callq  *%r13
        break;
  8041604c79:	e9 b0 fe ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
        putch(va_arg(aq, int), putdat);
  8041604c7e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041604c82:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8041604c86:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8041604c8a:	eb e5                	jmp    8041604c71 <vprintfmt+0x174>
        err = va_arg(aq, int);
  8041604c8c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604c8f:	83 fa 2f             	cmp    $0x2f,%edx
  8041604c92:	77 5b                	ja     8041604cef <vprintfmt+0x1f2>
  8041604c94:	89 d0                	mov    %edx,%eax
  8041604c96:	48 01 c6             	add    %rax,%rsi
  8041604c99:	83 c2 08             	add    $0x8,%edx
  8041604c9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604c9f:	8b 0e                	mov    (%rsi),%ecx
  8041604ca1:	89 c8                	mov    %ecx,%eax
  8041604ca3:	c1 f8 1f             	sar    $0x1f,%eax
  8041604ca6:	31 c1                	xor    %eax,%ecx
  8041604ca8:	29 c1                	sub    %eax,%ecx
        if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8041604caa:	83 f9 08             	cmp    $0x8,%ecx
  8041604cad:	7f 4e                	jg     8041604cfd <vprintfmt+0x200>
  8041604caf:	48 63 c1             	movslq %ecx,%rax
  8041604cb2:	48 ba 80 71 60 41 80 	movabs $0x8041607180,%rdx
  8041604cb9:	00 00 00 
  8041604cbc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8041604cc0:	48 85 c0             	test   %rax,%rax
  8041604cc3:	74 38                	je     8041604cfd <vprintfmt+0x200>
          printfmt(putch, putdat, "%s", p);
  8041604cc5:	48 89 c1             	mov    %rax,%rcx
  8041604cc8:	48 ba ab 66 60 41 80 	movabs $0x80416066ab,%rdx
  8041604ccf:	00 00 00 
  8041604cd2:	4c 89 f6             	mov    %r14,%rsi
  8041604cd5:	4c 89 ef             	mov    %r13,%rdi
  8041604cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604cdd:	49 b8 77 4a 60 41 80 	movabs $0x8041604a77,%r8
  8041604ce4:	00 00 00 
  8041604ce7:	41 ff d0             	callq  *%r8
  8041604cea:	e9 3f fe ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
        err = va_arg(aq, int);
  8041604cef:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604cf3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604cf7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604cfb:	eb a2                	jmp    8041604c9f <vprintfmt+0x1a2>
          printfmt(putch, putdat, "error %d", err);
  8041604cfd:	48 ba 1b 6e 60 41 80 	movabs $0x8041606e1b,%rdx
  8041604d04:	00 00 00 
  8041604d07:	4c 89 f6             	mov    %r14,%rsi
  8041604d0a:	4c 89 ef             	mov    %r13,%rdi
  8041604d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604d12:	49 b8 77 4a 60 41 80 	movabs $0x8041604a77,%r8
  8041604d19:	00 00 00 
  8041604d1c:	41 ff d0             	callq  *%r8
  8041604d1f:	e9 0a fe ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
        if ((p = va_arg(aq, char *)) == NULL)
  8041604d24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604d27:	83 fa 2f             	cmp    $0x2f,%edx
  8041604d2a:	77 45                	ja     8041604d71 <vprintfmt+0x274>
  8041604d2c:	89 d0                	mov    %edx,%eax
  8041604d2e:	48 01 c6             	add    %rax,%rsi
  8041604d31:	83 c2 08             	add    $0x8,%edx
  8041604d34:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604d37:	48 8b 1e             	mov    (%rsi),%rbx
  8041604d3a:	48 85 db             	test   %rbx,%rbx
  8041604d3d:	0f 84 fb 03 00 00    	je     804160513e <vprintfmt+0x641>
        if (width > 0 && padc != '-')
  8041604d43:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  8041604d47:	7e 06                	jle    8041604d4f <vprintfmt+0x252>
  8041604d49:	80 7d 98 2d          	cmpb   $0x2d,-0x68(%rbp)
  8041604d4d:	75 3a                	jne    8041604d89 <vprintfmt+0x28c>
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8041604d4f:	48 8d 43 01          	lea    0x1(%rbx),%rax
  8041604d53:	0f b6 13             	movzbl (%rbx),%edx
  8041604d56:	0f be fa             	movsbl %dl,%edi
  8041604d59:	85 ff                	test   %edi,%edi
  8041604d5b:	0f 84 d5 00 00 00    	je     8041604e36 <vprintfmt+0x339>
  8041604d61:	48 89 c3             	mov    %rax,%rbx
  8041604d64:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8041604d68:	44 8b 7d a8          	mov    -0x58(%rbp),%r15d
  8041604d6c:	e9 90 00 00 00       	jmpq   8041604e01 <vprintfmt+0x304>
        if ((p = va_arg(aq, char *)) == NULL)
  8041604d71:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604d75:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604d79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604d7d:	eb b8                	jmp    8041604d37 <vprintfmt+0x23a>
          p = "(null)";
  8041604d7f:	48 bb 14 6e 60 41 80 	movabs $0x8041606e14,%rbx
  8041604d86:	00 00 00 
          for (width -= strnlen(p, precision); width > 0; width--)
  8041604d89:	49 63 f4             	movslq %r12d,%rsi
  8041604d8c:	48 89 df             	mov    %rbx,%rdi
  8041604d8f:	48 b8 ae 53 60 41 80 	movabs $0x80416053ae,%rax
  8041604d96:	00 00 00 
  8041604d99:	ff d0                	callq  *%rax
  8041604d9b:	29 45 a8             	sub    %eax,-0x58(%rbp)
  8041604d9e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8041604da1:	85 c0                	test   %eax,%eax
  8041604da3:	7e 2b                	jle    8041604dd0 <vprintfmt+0x2d3>
            putch(padc, putdat);
  8041604da5:	0f be 4d 98          	movsbl -0x68(%rbp),%ecx
  8041604da9:	44 89 65 98          	mov    %r12d,-0x68(%rbp)
  8041604dad:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  8041604db1:	41 89 c4             	mov    %eax,%r12d
  8041604db4:	89 cb                	mov    %ecx,%ebx
  8041604db6:	4c 89 f6             	mov    %r14,%rsi
  8041604db9:	89 df                	mov    %ebx,%edi
  8041604dbb:	41 ff d5             	callq  *%r13
          for (width -= strnlen(p, precision); width > 0; width--)
  8041604dbe:	41 83 ec 01          	sub    $0x1,%r12d
  8041604dc2:	75 f2                	jne    8041604db6 <vprintfmt+0x2b9>
  8041604dc4:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
  8041604dc8:	44 89 65 a8          	mov    %r12d,-0x58(%rbp)
  8041604dcc:	44 8b 65 98          	mov    -0x68(%rbp),%r12d
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8041604dd0:	48 8d 43 01          	lea    0x1(%rbx),%rax
  8041604dd4:	0f b6 13             	movzbl (%rbx),%edx
  8041604dd7:	0f be fa             	movsbl %dl,%edi
  8041604dda:	85 ff                	test   %edi,%edi
  8041604ddc:	75 83                	jne    8041604d61 <vprintfmt+0x264>
  8041604dde:	e9 4b fd ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
          if (altflag && (ch < ' ' || ch > '~'))
  8041604de3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  8041604de7:	75 2d                	jne    8041604e16 <vprintfmt+0x319>
            putch(ch, putdat);
  8041604de9:	4c 89 f6             	mov    %r14,%rsi
  8041604dec:	41 ff d5             	callq  *%r13
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8041604def:	41 83 ef 01          	sub    $0x1,%r15d
  8041604df3:	0f b6 13             	movzbl (%rbx),%edx
  8041604df6:	0f be fa             	movsbl %dl,%edi
  8041604df9:	48 83 c3 01          	add    $0x1,%rbx
  8041604dfd:	85 ff                	test   %edi,%edi
  8041604dff:	74 2d                	je     8041604e2e <vprintfmt+0x331>
  8041604e01:	45 85 e4             	test   %r12d,%r12d
  8041604e04:	78 dd                	js     8041604de3 <vprintfmt+0x2e6>
  8041604e06:	41 83 ec 01          	sub    $0x1,%r12d
  8041604e0a:	79 d7                	jns    8041604de3 <vprintfmt+0x2e6>
  8041604e0c:	44 89 7d a8          	mov    %r15d,-0x58(%rbp)
  8041604e10:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8041604e14:	eb 20                	jmp    8041604e36 <vprintfmt+0x339>
          if (altflag && (ch < ' ' || ch > '~'))
  8041604e16:	0f be d2             	movsbl %dl,%edx
  8041604e19:	83 ea 20             	sub    $0x20,%edx
  8041604e1c:	83 fa 5e             	cmp    $0x5e,%edx
  8041604e1f:	76 c8                	jbe    8041604de9 <vprintfmt+0x2ec>
            putch('?', putdat);
  8041604e21:	4c 89 f6             	mov    %r14,%rsi
  8041604e24:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8041604e29:	41 ff d5             	callq  *%r13
  8041604e2c:	eb c1                	jmp    8041604def <vprintfmt+0x2f2>
  8041604e2e:	44 89 7d a8          	mov    %r15d,-0x58(%rbp)
  8041604e32:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8041604e36:	8b 5d a8             	mov    -0x58(%rbp),%ebx
        for (; width > 0; width--)
  8041604e39:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  8041604e3d:	0f 8e eb fc ff ff    	jle    8041604b2e <vprintfmt+0x31>
          putch(' ', putdat);
  8041604e43:	4c 89 f6             	mov    %r14,%rsi
  8041604e46:	bf 20 00 00 00       	mov    $0x20,%edi
  8041604e4b:	41 ff d5             	callq  *%r13
        for (; width > 0; width--)
  8041604e4e:	83 eb 01             	sub    $0x1,%ebx
  8041604e51:	75 f0                	jne    8041604e43 <vprintfmt+0x346>
  8041604e53:	e9 d6 fc ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
  if (lflag >= 2)
  8041604e58:	83 f9 01             	cmp    $0x1,%ecx
  8041604e5b:	7e 50                	jle    8041604ead <vprintfmt+0x3b0>
    return va_arg(*ap, long long);
  8041604e5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604e60:	83 fa 2f             	cmp    $0x2f,%edx
  8041604e63:	77 3a                	ja     8041604e9f <vprintfmt+0x3a2>
  8041604e65:	89 d0                	mov    %edx,%eax
  8041604e67:	48 01 c6             	add    %rax,%rsi
  8041604e6a:	83 c2 08             	add    $0x8,%edx
  8041604e6d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604e70:	48 8b 1e             	mov    (%rsi),%rbx
        num = getint(&aq, lflag);
  8041604e73:	48 89 da             	mov    %rbx,%rdx
        base = 10;
  8041604e76:	b9 0a 00 00 00       	mov    $0xa,%ecx
        if ((long long)num < 0) {
  8041604e7b:	48 85 db             	test   %rbx,%rbx
  8041604e7e:	0f 89 c9 01 00 00    	jns    804160504d <vprintfmt+0x550>
          putch('-', putdat);
  8041604e84:	4c 89 f6             	mov    %r14,%rsi
  8041604e87:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8041604e8c:	41 ff d5             	callq  *%r13
          num = -(long long)num;
  8041604e8f:	48 89 da             	mov    %rbx,%rdx
  8041604e92:	48 f7 da             	neg    %rdx
        base = 10;
  8041604e95:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8041604e9a:	e9 ae 01 00 00       	jmpq   804160504d <vprintfmt+0x550>
    return va_arg(*ap, long long);
  8041604e9f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604ea3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604ea7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604eab:	eb c3                	jmp    8041604e70 <vprintfmt+0x373>
  else if (lflag)
  8041604ead:	85 c9                	test   %ecx,%ecx
  8041604eaf:	75 18                	jne    8041604ec9 <vprintfmt+0x3cc>
    return va_arg(*ap, int);
  8041604eb1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604eb4:	83 fa 2f             	cmp    $0x2f,%edx
  8041604eb7:	77 36                	ja     8041604eef <vprintfmt+0x3f2>
  8041604eb9:	89 d0                	mov    %edx,%eax
  8041604ebb:	48 01 c6             	add    %rax,%rsi
  8041604ebe:	83 c2 08             	add    $0x8,%edx
  8041604ec1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604ec4:	48 63 1e             	movslq (%rsi),%rbx
  8041604ec7:	eb aa                	jmp    8041604e73 <vprintfmt+0x376>
    return va_arg(*ap, long);
  8041604ec9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604ecc:	83 fa 2f             	cmp    $0x2f,%edx
  8041604ecf:	77 10                	ja     8041604ee1 <vprintfmt+0x3e4>
  8041604ed1:	89 d0                	mov    %edx,%eax
  8041604ed3:	48 01 c6             	add    %rax,%rsi
  8041604ed6:	83 c2 08             	add    $0x8,%edx
  8041604ed9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604edc:	48 8b 1e             	mov    (%rsi),%rbx
  8041604edf:	eb 92                	jmp    8041604e73 <vprintfmt+0x376>
  8041604ee1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604ee5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604ee9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604eed:	eb ed                	jmp    8041604edc <vprintfmt+0x3df>
    return va_arg(*ap, int);
  8041604eef:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604ef3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604ef7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604efb:	eb c7                	jmp    8041604ec4 <vprintfmt+0x3c7>
  if (lflag >= 2)
  8041604efd:	83 f9 01             	cmp    $0x1,%ecx
  8041604f00:	7e 2e                	jle    8041604f30 <vprintfmt+0x433>
    return va_arg(*ap, unsigned long long);
  8041604f02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604f05:	83 fa 2f             	cmp    $0x2f,%edx
  8041604f08:	77 18                	ja     8041604f22 <vprintfmt+0x425>
  8041604f0a:	89 d0                	mov    %edx,%eax
  8041604f0c:	48 01 c6             	add    %rax,%rsi
  8041604f0f:	83 c2 08             	add    $0x8,%edx
  8041604f12:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604f15:	48 8b 16             	mov    (%rsi),%rdx
        base = 10;
  8041604f18:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8041604f1d:	e9 2b 01 00 00       	jmpq   804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long long);
  8041604f22:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604f26:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604f2a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604f2e:	eb e5                	jmp    8041604f15 <vprintfmt+0x418>
  else if (lflag)
  8041604f30:	85 c9                	test   %ecx,%ecx
  8041604f32:	75 1f                	jne    8041604f53 <vprintfmt+0x456>
    return va_arg(*ap, unsigned int);
  8041604f34:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604f37:	83 fa 2f             	cmp    $0x2f,%edx
  8041604f3a:	77 45                	ja     8041604f81 <vprintfmt+0x484>
  8041604f3c:	89 d0                	mov    %edx,%eax
  8041604f3e:	48 01 c6             	add    %rax,%rsi
  8041604f41:	83 c2 08             	add    $0x8,%edx
  8041604f44:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604f47:	8b 16                	mov    (%rsi),%edx
        base = 10;
  8041604f49:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8041604f4e:	e9 fa 00 00 00       	jmpq   804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  8041604f53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604f56:	83 fa 2f             	cmp    $0x2f,%edx
  8041604f59:	77 18                	ja     8041604f73 <vprintfmt+0x476>
  8041604f5b:	89 d0                	mov    %edx,%eax
  8041604f5d:	48 01 c6             	add    %rax,%rsi
  8041604f60:	83 c2 08             	add    $0x8,%edx
  8041604f63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604f66:	48 8b 16             	mov    (%rsi),%rdx
        base = 10;
  8041604f69:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8041604f6e:	e9 da 00 00 00       	jmpq   804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  8041604f73:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604f77:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604f7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604f7f:	eb e5                	jmp    8041604f66 <vprintfmt+0x469>
    return va_arg(*ap, unsigned int);
  8041604f81:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604f85:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604f89:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604f8d:	eb b8                	jmp    8041604f47 <vprintfmt+0x44a>
  if (lflag >= 2)
  8041604f8f:	83 f9 01             	cmp    $0x1,%ecx
  8041604f92:	7e 2e                	jle    8041604fc2 <vprintfmt+0x4c5>
    return va_arg(*ap, unsigned long long);
  8041604f94:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604f97:	83 fa 2f             	cmp    $0x2f,%edx
  8041604f9a:	77 18                	ja     8041604fb4 <vprintfmt+0x4b7>
  8041604f9c:	89 d0                	mov    %edx,%eax
  8041604f9e:	48 01 c6             	add    %rax,%rsi
  8041604fa1:	83 c2 08             	add    $0x8,%edx
  8041604fa4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604fa7:	48 8b 16             	mov    (%rsi),%rdx
        base = 8;
  8041604faa:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041604faf:	e9 99 00 00 00       	jmpq   804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long long);
  8041604fb4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604fb8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604fbc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604fc0:	eb e5                	jmp    8041604fa7 <vprintfmt+0x4aa>
  else if (lflag)
  8041604fc2:	85 c9                	test   %ecx,%ecx
  8041604fc4:	75 1c                	jne    8041604fe2 <vprintfmt+0x4e5>
    return va_arg(*ap, unsigned int);
  8041604fc6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604fc9:	83 fa 2f             	cmp    $0x2f,%edx
  8041604fcc:	77 3f                	ja     804160500d <vprintfmt+0x510>
  8041604fce:	89 d0                	mov    %edx,%eax
  8041604fd0:	48 01 c6             	add    %rax,%rsi
  8041604fd3:	83 c2 08             	add    $0x8,%edx
  8041604fd6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604fd9:	8b 16                	mov    (%rsi),%edx
        base = 8;
  8041604fdb:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041604fe0:	eb 6b                	jmp    804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  8041604fe2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604fe5:	83 fa 2f             	cmp    $0x2f,%edx
  8041604fe8:	77 15                	ja     8041604fff <vprintfmt+0x502>
  8041604fea:	89 d0                	mov    %edx,%eax
  8041604fec:	48 01 c6             	add    %rax,%rsi
  8041604fef:	83 c2 08             	add    $0x8,%edx
  8041604ff2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604ff5:	48 8b 16             	mov    (%rsi),%rdx
        base = 8;
  8041604ff8:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041604ffd:	eb 4e                	jmp    804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  8041604fff:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041605003:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041605007:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160500b:	eb e8                	jmp    8041604ff5 <vprintfmt+0x4f8>
    return va_arg(*ap, unsigned int);
  804160500d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041605011:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041605015:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041605019:	eb be                	jmp    8041604fd9 <vprintfmt+0x4dc>
        putch('0', putdat);
  804160501b:	4c 89 f6             	mov    %r14,%rsi
  804160501e:	bf 30 00 00 00       	mov    $0x30,%edi
  8041605023:	41 ff d5             	callq  *%r13
        putch('x', putdat);
  8041605026:	4c 89 f6             	mov    %r14,%rsi
  8041605029:	bf 78 00 00 00       	mov    $0x78,%edi
  804160502e:	41 ff d5             	callq  *%r13
        num  = (unsigned long long)(uintptr_t)va_arg(aq, void *);
  8041605031:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8041605034:	83 f8 2f             	cmp    $0x2f,%eax
  8041605037:	77 34                	ja     804160506d <vprintfmt+0x570>
  8041605039:	89 c2                	mov    %eax,%edx
  804160503b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804160503f:	83 c0 08             	add    $0x8,%eax
  8041605042:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8041605045:	48 8b 12             	mov    (%rdx),%rdx
        base = 16;
  8041605048:	b9 10 00 00 00       	mov    $0x10,%ecx
        printnum(putch, putdat, num, base, width, padc);
  804160504d:	44 0f be 4d 98       	movsbl -0x68(%rbp),%r9d
  8041605052:	44 8b 45 a8          	mov    -0x58(%rbp),%r8d
  8041605056:	4c 89 f6             	mov    %r14,%rsi
  8041605059:	4c 89 ef             	mov    %r13,%rdi
  804160505c:	48 b8 ce 49 60 41 80 	movabs $0x80416049ce,%rax
  8041605063:	00 00 00 
  8041605066:	ff d0                	callq  *%rax
        break;
  8041605068:	e9 c1 fa ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
        num  = (unsigned long long)(uintptr_t)va_arg(aq, void *);
  804160506d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8041605071:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8041605075:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041605079:	eb ca                	jmp    8041605045 <vprintfmt+0x548>
  if (lflag >= 2)
  804160507b:	83 f9 01             	cmp    $0x1,%ecx
  804160507e:	7e 2b                	jle    80416050ab <vprintfmt+0x5ae>
    return va_arg(*ap, unsigned long long);
  8041605080:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041605083:	83 fa 2f             	cmp    $0x2f,%edx
  8041605086:	77 15                	ja     804160509d <vprintfmt+0x5a0>
  8041605088:	89 d0                	mov    %edx,%eax
  804160508a:	48 01 c6             	add    %rax,%rsi
  804160508d:	83 c2 08             	add    $0x8,%edx
  8041605090:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041605093:	48 8b 16             	mov    (%rsi),%rdx
        base = 16;
  8041605096:	b9 10 00 00 00       	mov    $0x10,%ecx
  804160509b:	eb b0                	jmp    804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long long);
  804160509d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80416050a1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80416050a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80416050a9:	eb e8                	jmp    8041605093 <vprintfmt+0x596>
  else if (lflag)
  80416050ab:	85 c9                	test   %ecx,%ecx
  80416050ad:	75 1c                	jne    80416050cb <vprintfmt+0x5ce>
    return va_arg(*ap, unsigned int);
  80416050af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80416050b2:	83 f8 2f             	cmp    $0x2f,%eax
  80416050b5:	77 42                	ja     80416050f9 <vprintfmt+0x5fc>
  80416050b7:	89 c2                	mov    %eax,%edx
  80416050b9:	48 01 d6             	add    %rdx,%rsi
  80416050bc:	83 c0 08             	add    $0x8,%eax
  80416050bf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80416050c2:	8b 16                	mov    (%rsi),%edx
        base = 16;
  80416050c4:	b9 10 00 00 00       	mov    $0x10,%ecx
  80416050c9:	eb 82                	jmp    804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  80416050cb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80416050ce:	83 fa 2f             	cmp    $0x2f,%edx
  80416050d1:	77 18                	ja     80416050eb <vprintfmt+0x5ee>
  80416050d3:	89 d0                	mov    %edx,%eax
  80416050d5:	48 01 c6             	add    %rax,%rsi
  80416050d8:	83 c2 08             	add    $0x8,%edx
  80416050db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80416050de:	48 8b 16             	mov    (%rsi),%rdx
        base = 16;
  80416050e1:	b9 10 00 00 00       	mov    $0x10,%ecx
  80416050e6:	e9 62 ff ff ff       	jmpq   804160504d <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  80416050eb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80416050ef:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80416050f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80416050f7:	eb e5                	jmp    80416050de <vprintfmt+0x5e1>
    return va_arg(*ap, unsigned int);
  80416050f9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80416050fd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041605101:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041605105:	eb bb                	jmp    80416050c2 <vprintfmt+0x5c5>
        putch(ch, putdat);
  8041605107:	4c 89 f6             	mov    %r14,%rsi
  804160510a:	bf 25 00 00 00       	mov    $0x25,%edi
  804160510f:	41 ff d5             	callq  *%r13
        break;
  8041605112:	e9 17 fa ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
        putch('%', putdat);
  8041605117:	4c 89 f6             	mov    %r14,%rsi
  804160511a:	bf 25 00 00 00       	mov    $0x25,%edi
  804160511f:	41 ff d5             	callq  *%r13
        for (fmt--; fmt[-1] != '%'; fmt--)
  8041605122:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8041605126:	0f 84 22 fa ff ff    	je     8041604b4e <vprintfmt+0x51>
  804160512c:	48 83 eb 01          	sub    $0x1,%rbx
  8041605130:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8041605134:	75 f6                	jne    804160512c <vprintfmt+0x62f>
  8041605136:	49 89 df             	mov    %rbx,%r15
  8041605139:	e9 f0 f9 ff ff       	jmpq   8041604b2e <vprintfmt+0x31>
        if (width > 0 && padc != '-')
  804160513e:	80 7d 98 2d          	cmpb   $0x2d,-0x68(%rbp)
  8041605142:	74 0a                	je     804160514e <vprintfmt+0x651>
  8041605144:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  8041605148:	0f 8f 31 fc ff ff    	jg     8041604d7f <vprintfmt+0x282>
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  804160514e:	48 b8 15 6e 60 41 80 	movabs $0x8041606e15,%rax
  8041605155:	00 00 00 
  8041605158:	bf 28 00 00 00       	mov    $0x28,%edi
  804160515d:	ba 28 00 00 00       	mov    $0x28,%edx
  8041605162:	e9 fa fb ff ff       	jmpq   8041604d61 <vprintfmt+0x264>
}
  8041605167:	48 83 c4 48          	add    $0x48,%rsp
  804160516b:	5b                   	pop    %rbx
  804160516c:	41 5c                	pop    %r12
  804160516e:	41 5d                	pop    %r13
  8041605170:	41 5e                	pop    %r14
  8041605172:	41 5f                	pop    %r15
  8041605174:	5d                   	pop    %rbp
  8041605175:	c3                   	retq   

0000008041605176 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap) {
  8041605176:	55                   	push   %rbp
  8041605177:	48 89 e5             	mov    %rsp,%rbp
  804160517a:	48 83 ec 20          	sub    $0x20,%rsp
  struct sprintbuf b = {buf, buf + n - 1, 0};
  804160517e:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
  8041605182:	48 63 c6             	movslq %esi,%rax
  8041605185:	48 8d 44 07 ff       	lea    -0x1(%rdi,%rax,1),%rax
  804160518a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804160518e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

  if (buf == NULL || n < 1)
  8041605195:	48 85 ff             	test   %rdi,%rdi
  8041605198:	74 2a                	je     80416051c4 <vsnprintf+0x4e>
  804160519a:	85 f6                	test   %esi,%esi
  804160519c:	7e 26                	jle    80416051c4 <vsnprintf+0x4e>
    return -E_INVAL;

  // print the string to the buffer
  vprintfmt((void *)sprintputch, &b, fmt, ap);
  804160519e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80416051a2:	48 bf 5a 4a 60 41 80 	movabs $0x8041604a5a,%rdi
  80416051a9:	00 00 00 
  80416051ac:	48 b8 fd 4a 60 41 80 	movabs $0x8041604afd,%rax
  80416051b3:	00 00 00 
  80416051b6:	ff d0                	callq  *%rax

  // null terminate the buffer
  *b.buf = '\0';
  80416051b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80416051bc:	c6 00 00             	movb   $0x0,(%rax)

  return b.cnt;
  80416051bf:	8b 45 f0             	mov    -0x10(%rbp),%eax
}
  80416051c2:	c9                   	leaveq 
  80416051c3:	c3                   	retq   
    return -E_INVAL;
  80416051c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80416051c9:	eb f7                	jmp    80416051c2 <vsnprintf+0x4c>

00000080416051cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...) {
  80416051cb:	55                   	push   %rbp
  80416051cc:	48 89 e5             	mov    %rsp,%rbp
  80416051cf:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80416051d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80416051dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80416051e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80416051eb:	84 c0                	test   %al,%al
  80416051ed:	74 20                	je     804160520f <snprintf+0x44>
  80416051ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80416051f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80416051f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80416051fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80416051ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8041605203:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8041605207:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804160520b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int rc;

  va_start(ap, fmt);
  804160520f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8041605216:	00 00 00 
  8041605219:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8041605220:	00 00 00 
  8041605223:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041605227:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  804160522e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8041605235:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  rc = vsnprintf(buf, n, fmt, ap);
  804160523c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8041605243:	48 b8 76 51 60 41 80 	movabs $0x8041605176,%rax
  804160524a:	00 00 00 
  804160524d:	ff d0                	callq  *%rax
  va_end(ap);

  return rc;
}
  804160524f:	c9                   	leaveq 
  8041605250:	c3                   	retq   

0000008041605251 <readline>:

#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt) {
  8041605251:	55                   	push   %rbp
  8041605252:	48 89 e5             	mov    %rsp,%rbp
  8041605255:	41 57                	push   %r15
  8041605257:	41 56                	push   %r14
  8041605259:	41 55                	push   %r13
  804160525b:	41 54                	push   %r12
  804160525d:	53                   	push   %rbx
  804160525e:	48 83 ec 08          	sub    $0x8,%rsp
  int i, c, echoing;

  if (prompt != NULL)
  8041605262:	48 85 ff             	test   %rdi,%rdi
  8041605265:	74 1e                	je     8041605285 <readline+0x34>
    cprintf("%s", prompt);
  8041605267:	48 89 fe             	mov    %rdi,%rsi
  804160526a:	48 bf ab 66 60 41 80 	movabs $0x80416066ab,%rdi
  8041605271:	00 00 00 
  8041605274:	b8 00 00 00 00       	mov    $0x0,%eax
  8041605279:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041605280:	00 00 00 
  8041605283:	ff d2                	callq  *%rdx

  i       = 0;
  echoing = iscons(0);
  8041605285:	bf 00 00 00 00       	mov    $0x0,%edi
  804160528a:	48 b8 d5 0b 60 41 80 	movabs $0x8041600bd5,%rax
  8041605291:	00 00 00 
  8041605294:	ff d0                	callq  *%rax
  8041605296:	41 89 c6             	mov    %eax,%r14d
  i       = 0;
  8041605299:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  while (1) {
    c = getchar();
  804160529f:	49 bd b5 0b 60 41 80 	movabs $0x8041600bb5,%r13
  80416052a6:	00 00 00 
      cprintf("read error: %i\n", c);
      return NULL;
    } else if ((c == '\b' || c == '\x7f')) {
      if (i > 0) {
        if (echoing) {
          cputchar('\b');
  80416052a9:	49 bf a3 0b 60 41 80 	movabs $0x8041600ba3,%r15
  80416052b0:	00 00 00 
  80416052b3:	eb 3f                	jmp    80416052f4 <readline+0xa3>
      cprintf("read error: %i\n", c);
  80416052b5:	89 c6                	mov    %eax,%esi
  80416052b7:	48 bf c8 71 60 41 80 	movabs $0x80416071c8,%rdi
  80416052be:	00 00 00 
  80416052c1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416052c6:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416052cd:	00 00 00 
  80416052d0:	ff d2                	callq  *%rdx
      return NULL;
  80416052d2:	b8 00 00 00 00       	mov    $0x0,%eax
        cputchar('\n');
      buf[i] = 0;
      return buf;
    }
  }
}
  80416052d7:	48 83 c4 08          	add    $0x8,%rsp
  80416052db:	5b                   	pop    %rbx
  80416052dc:	41 5c                	pop    %r12
  80416052de:	41 5d                	pop    %r13
  80416052e0:	41 5e                	pop    %r14
  80416052e2:	41 5f                	pop    %r15
  80416052e4:	5d                   	pop    %rbp
  80416052e5:	c3                   	retq   
      if (i > 0) {
  80416052e6:	45 85 e4             	test   %r12d,%r12d
  80416052e9:	7e 09                	jle    80416052f4 <readline+0xa3>
        if (echoing) {
  80416052eb:	45 85 f6             	test   %r14d,%r14d
  80416052ee:	75 41                	jne    8041605331 <readline+0xe0>
        i--;
  80416052f0:	41 83 ec 01          	sub    $0x1,%r12d
    c = getchar();
  80416052f4:	41 ff d5             	callq  *%r13
  80416052f7:	89 c3                	mov    %eax,%ebx
    if (c < 0) {
  80416052f9:	85 c0                	test   %eax,%eax
  80416052fb:	78 b8                	js     80416052b5 <readline+0x64>
    } else if ((c == '\b' || c == '\x7f')) {
  80416052fd:	83 f8 08             	cmp    $0x8,%eax
  8041605300:	74 e4                	je     80416052e6 <readline+0x95>
  8041605302:	83 f8 7f             	cmp    $0x7f,%eax
  8041605305:	74 df                	je     80416052e6 <readline+0x95>
    } else if (c >= ' ' && i < BUFLEN - 1) {
  8041605307:	83 f8 1f             	cmp    $0x1f,%eax
  804160530a:	7e 46                	jle    8041605352 <readline+0x101>
  804160530c:	41 81 fc fe 03 00 00 	cmp    $0x3fe,%r12d
  8041605313:	7f 3d                	jg     8041605352 <readline+0x101>
      if (echoing)
  8041605315:	45 85 f6             	test   %r14d,%r14d
  8041605318:	75 31                	jne    804160534b <readline+0xfa>
      buf[i++] = c;
  804160531a:	49 63 c4             	movslq %r12d,%rax
  804160531d:	48 b9 40 43 62 41 80 	movabs $0x8041624340,%rcx
  8041605324:	00 00 00 
  8041605327:	88 1c 01             	mov    %bl,(%rcx,%rax,1)
  804160532a:	45 8d 64 24 01       	lea    0x1(%r12),%r12d
  804160532f:	eb c3                	jmp    80416052f4 <readline+0xa3>
          cputchar('\b');
  8041605331:	bf 08 00 00 00       	mov    $0x8,%edi
  8041605336:	41 ff d7             	callq  *%r15
          cputchar(' ');
  8041605339:	bf 20 00 00 00       	mov    $0x20,%edi
  804160533e:	41 ff d7             	callq  *%r15
          cputchar('\b');
  8041605341:	bf 08 00 00 00       	mov    $0x8,%edi
  8041605346:	41 ff d7             	callq  *%r15
  8041605349:	eb a5                	jmp    80416052f0 <readline+0x9f>
        cputchar(c);
  804160534b:	89 c7                	mov    %eax,%edi
  804160534d:	41 ff d7             	callq  *%r15
  8041605350:	eb c8                	jmp    804160531a <readline+0xc9>
    } else if (c == '\n' || c == '\r') {
  8041605352:	83 fb 0a             	cmp    $0xa,%ebx
  8041605355:	74 05                	je     804160535c <readline+0x10b>
  8041605357:	83 fb 0d             	cmp    $0xd,%ebx
  804160535a:	75 98                	jne    80416052f4 <readline+0xa3>
      if (echoing)
  804160535c:	45 85 f6             	test   %r14d,%r14d
  804160535f:	75 17                	jne    8041605378 <readline+0x127>
      buf[i] = 0;
  8041605361:	48 b8 40 43 62 41 80 	movabs $0x8041624340,%rax
  8041605368:	00 00 00 
  804160536b:	4d 63 e4             	movslq %r12d,%r12
  804160536e:	42 c6 04 20 00       	movb   $0x0,(%rax,%r12,1)
      return buf;
  8041605373:	e9 5f ff ff ff       	jmpq   80416052d7 <readline+0x86>
        cputchar('\n');
  8041605378:	bf 0a 00 00 00       	mov    $0xa,%edi
  804160537d:	48 b8 a3 0b 60 41 80 	movabs $0x8041600ba3,%rax
  8041605384:	00 00 00 
  8041605387:	ff d0                	callq  *%rax
  8041605389:	eb d6                	jmp    8041605361 <readline+0x110>

000000804160538b <strlen>:
// but it makes an even bigger difference on bochs.
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s) {
  804160538b:	55                   	push   %rbp
  804160538c:	48 89 e5             	mov    %rsp,%rbp
  int n;

  for (n = 0; *s != '\0'; s++)
  804160538f:	80 3f 00             	cmpb   $0x0,(%rdi)
  8041605392:	74 13                	je     80416053a7 <strlen+0x1c>
  8041605394:	b8 00 00 00 00       	mov    $0x0,%eax
    n++;
  8041605399:	83 c0 01             	add    $0x1,%eax
  for (n = 0; *s != '\0'; s++)
  804160539c:	48 83 c7 01          	add    $0x1,%rdi
  80416053a0:	80 3f 00             	cmpb   $0x0,(%rdi)
  80416053a3:	75 f4                	jne    8041605399 <strlen+0xe>
  return n;
}
  80416053a5:	5d                   	pop    %rbp
  80416053a6:	c3                   	retq   
  for (n = 0; *s != '\0'; s++)
  80416053a7:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  80416053ac:	eb f7                	jmp    80416053a5 <strlen+0x1a>

00000080416053ae <strnlen>:

int
strnlen(const char *s, size_t size) {
  80416053ae:	55                   	push   %rbp
  80416053af:	48 89 e5             	mov    %rsp,%rbp
  int n;

  for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80416053b2:	48 85 f6             	test   %rsi,%rsi
  80416053b5:	74 20                	je     80416053d7 <strnlen+0x29>
  80416053b7:	80 3f 00             	cmpb   $0x0,(%rdi)
  80416053ba:	74 22                	je     80416053de <strnlen+0x30>
  80416053bc:	48 01 fe             	add    %rdi,%rsi
  80416053bf:	b8 00 00 00 00       	mov    $0x0,%eax
    n++;
  80416053c4:	83 c0 01             	add    $0x1,%eax
  for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80416053c7:	48 83 c7 01          	add    $0x1,%rdi
  80416053cb:	48 39 fe             	cmp    %rdi,%rsi
  80416053ce:	74 05                	je     80416053d5 <strnlen+0x27>
  80416053d0:	80 3f 00             	cmpb   $0x0,(%rdi)
  80416053d3:	75 ef                	jne    80416053c4 <strnlen+0x16>
  return n;
}
  80416053d5:	5d                   	pop    %rbp
  80416053d6:	c3                   	retq   
  for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80416053d7:	b8 00 00 00 00       	mov    $0x0,%eax
  80416053dc:	eb f7                	jmp    80416053d5 <strnlen+0x27>
  80416053de:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  80416053e3:	eb f0                	jmp    80416053d5 <strnlen+0x27>

00000080416053e5 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  80416053e5:	55                   	push   %rbp
  80416053e6:	48 89 e5             	mov    %rsp,%rbp
  80416053e9:	48 89 f8             	mov    %rdi,%rax
  char *ret;

  ret = dst;
  while ((*dst++ = *src++) != '\0')
  80416053ec:	48 89 fa             	mov    %rdi,%rdx
  80416053ef:	48 83 c6 01          	add    $0x1,%rsi
  80416053f3:	48 83 c2 01          	add    $0x1,%rdx
  80416053f7:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  80416053fb:	88 4a ff             	mov    %cl,-0x1(%rdx)
  80416053fe:	84 c9                	test   %cl,%cl
  8041605400:	75 ed                	jne    80416053ef <strcpy+0xa>
    /* do nothing */;
  return ret;
}
  8041605402:	5d                   	pop    %rbp
  8041605403:	c3                   	retq   

0000008041605404 <strcat>:

char *
strcat(char *dst, const char *src) {
  8041605404:	55                   	push   %rbp
  8041605405:	48 89 e5             	mov    %rsp,%rbp
  8041605408:	41 54                	push   %r12
  804160540a:	53                   	push   %rbx
  804160540b:	48 89 fb             	mov    %rdi,%rbx
  804160540e:	49 89 f4             	mov    %rsi,%r12
  int len = strlen(dst);
  8041605411:	48 b8 8b 53 60 41 80 	movabs $0x804160538b,%rax
  8041605418:	00 00 00 
  804160541b:	ff d0                	callq  *%rax
  strcpy(dst + len, src);
  804160541d:	48 63 f8             	movslq %eax,%rdi
  8041605420:	48 01 df             	add    %rbx,%rdi
  8041605423:	4c 89 e6             	mov    %r12,%rsi
  8041605426:	48 b8 e5 53 60 41 80 	movabs $0x80416053e5,%rax
  804160542d:	00 00 00 
  8041605430:	ff d0                	callq  *%rax
  return dst;
}
  8041605432:	48 89 d8             	mov    %rbx,%rax
  8041605435:	5b                   	pop    %rbx
  8041605436:	41 5c                	pop    %r12
  8041605438:	5d                   	pop    %rbp
  8041605439:	c3                   	retq   

000000804160543a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  804160543a:	55                   	push   %rbp
  804160543b:	48 89 e5             	mov    %rsp,%rbp
  804160543e:	48 89 f8             	mov    %rdi,%rax
  size_t i;
  char *ret;

  ret = dst;
  for (i = 0; i < size; i++) {
  8041605441:	48 85 d2             	test   %rdx,%rdx
  8041605444:	74 1e                	je     8041605464 <strncpy+0x2a>
  8041605446:	48 01 fa             	add    %rdi,%rdx
  8041605449:	48 89 f9             	mov    %rdi,%rcx
    *dst++ = *src;
  804160544c:	48 83 c1 01          	add    $0x1,%rcx
  8041605450:	44 0f b6 06          	movzbl (%rsi),%r8d
  8041605454:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
    // If strlen(src) < size, null-pad 'dst' out to 'size' chars
    if (*src != '\0')
      src++;
  8041605458:	80 3e 01             	cmpb   $0x1,(%rsi)
  804160545b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  for (i = 0; i < size; i++) {
  804160545f:	48 39 ca             	cmp    %rcx,%rdx
  8041605462:	75 e8                	jne    804160544c <strncpy+0x12>
  }
  return ret;
}
  8041605464:	5d                   	pop    %rbp
  8041605465:	c3                   	retq   

0000008041605466 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8041605466:	55                   	push   %rbp
  8041605467:	48 89 e5             	mov    %rsp,%rbp
  804160546a:	48 89 f8             	mov    %rdi,%rax
  char *dst_in;

  dst_in = dst;
  if (size > 0) {
  804160546d:	48 85 d2             	test   %rdx,%rdx
  8041605470:	74 36                	je     80416054a8 <strlcpy+0x42>
    while (--size > 0 && *src != '\0')
  8041605472:	48 83 fa 01          	cmp    $0x1,%rdx
  8041605476:	74 2d                	je     80416054a5 <strlcpy+0x3f>
  8041605478:	44 0f b6 06          	movzbl (%rsi),%r8d
  804160547c:	45 84 c0             	test   %r8b,%r8b
  804160547f:	74 24                	je     80416054a5 <strlcpy+0x3f>
  8041605481:	48 8d 4e 01          	lea    0x1(%rsi),%rcx
  8041605485:	48 8d 54 16 ff       	lea    -0x1(%rsi,%rdx,1),%rdx
      *dst++ = *src++;
  804160548a:	48 83 c0 01          	add    $0x1,%rax
  804160548e:	44 88 40 ff          	mov    %r8b,-0x1(%rax)
    while (--size > 0 && *src != '\0')
  8041605492:	48 39 d1             	cmp    %rdx,%rcx
  8041605495:	74 0e                	je     80416054a5 <strlcpy+0x3f>
  8041605497:	48 83 c1 01          	add    $0x1,%rcx
  804160549b:	44 0f b6 41 ff       	movzbl -0x1(%rcx),%r8d
  80416054a0:	45 84 c0             	test   %r8b,%r8b
  80416054a3:	75 e5                	jne    804160548a <strlcpy+0x24>
    *dst = '\0';
  80416054a5:	c6 00 00             	movb   $0x0,(%rax)
  }
  return dst - dst_in;
  80416054a8:	48 29 f8             	sub    %rdi,%rax
}
  80416054ab:	5d                   	pop    %rbp
  80416054ac:	c3                   	retq   

00000080416054ad <strcmp>:
  }
  return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80416054ad:	55                   	push   %rbp
  80416054ae:	48 89 e5             	mov    %rsp,%rbp
  while (*p && *p == *q)
  80416054b1:	0f b6 07             	movzbl (%rdi),%eax
  80416054b4:	84 c0                	test   %al,%al
  80416054b6:	74 17                	je     80416054cf <strcmp+0x22>
  80416054b8:	3a 06                	cmp    (%rsi),%al
  80416054ba:	75 13                	jne    80416054cf <strcmp+0x22>
    p++, q++;
  80416054bc:	48 83 c7 01          	add    $0x1,%rdi
  80416054c0:	48 83 c6 01          	add    $0x1,%rsi
  while (*p && *p == *q)
  80416054c4:	0f b6 07             	movzbl (%rdi),%eax
  80416054c7:	84 c0                	test   %al,%al
  80416054c9:	74 04                	je     80416054cf <strcmp+0x22>
  80416054cb:	3a 06                	cmp    (%rsi),%al
  80416054cd:	74 ed                	je     80416054bc <strcmp+0xf>
  return (int)((unsigned char)*p - (unsigned char)*q);
  80416054cf:	0f b6 c0             	movzbl %al,%eax
  80416054d2:	0f b6 16             	movzbl (%rsi),%edx
  80416054d5:	29 d0                	sub    %edx,%eax
}
  80416054d7:	5d                   	pop    %rbp
  80416054d8:	c3                   	retq   

00000080416054d9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80416054d9:	55                   	push   %rbp
  80416054da:	48 89 e5             	mov    %rsp,%rbp
  while (n > 0 && *p && *p == *q)
  80416054dd:	48 85 d2             	test   %rdx,%rdx
  80416054e0:	74 30                	je     8041605512 <strncmp+0x39>
  80416054e2:	0f b6 07             	movzbl (%rdi),%eax
  80416054e5:	84 c0                	test   %al,%al
  80416054e7:	74 1f                	je     8041605508 <strncmp+0x2f>
  80416054e9:	3a 06                	cmp    (%rsi),%al
  80416054eb:	75 1b                	jne    8041605508 <strncmp+0x2f>
  80416054ed:	48 01 fa             	add    %rdi,%rdx
    n--, p++, q++;
  80416054f0:	48 83 c7 01          	add    $0x1,%rdi
  80416054f4:	48 83 c6 01          	add    $0x1,%rsi
  while (n > 0 && *p && *p == *q)
  80416054f8:	48 39 d7             	cmp    %rdx,%rdi
  80416054fb:	74 1c                	je     8041605519 <strncmp+0x40>
  80416054fd:	0f b6 07             	movzbl (%rdi),%eax
  8041605500:	84 c0                	test   %al,%al
  8041605502:	74 04                	je     8041605508 <strncmp+0x2f>
  8041605504:	3a 06                	cmp    (%rsi),%al
  8041605506:	74 e8                	je     80416054f0 <strncmp+0x17>
  if (n == 0)
    return 0;
  else
    return (int)((unsigned char)*p - (unsigned char)*q);
  8041605508:	0f b6 07             	movzbl (%rdi),%eax
  804160550b:	0f b6 16             	movzbl (%rsi),%edx
  804160550e:	29 d0                	sub    %edx,%eax
}
  8041605510:	5d                   	pop    %rbp
  8041605511:	c3                   	retq   
    return 0;
  8041605512:	b8 00 00 00 00       	mov    $0x0,%eax
  8041605517:	eb f7                	jmp    8041605510 <strncmp+0x37>
  8041605519:	b8 00 00 00 00       	mov    $0x0,%eax
  804160551e:	eb f0                	jmp    8041605510 <strncmp+0x37>

0000008041605520 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c) {
  8041605520:	55                   	push   %rbp
  8041605521:	48 89 e5             	mov    %rsp,%rbp
  for (; *s; s++)
  8041605524:	0f b6 07             	movzbl (%rdi),%eax
  8041605527:	84 c0                	test   %al,%al
  8041605529:	74 22                	je     804160554d <strchr+0x2d>
  804160552b:	89 f2                	mov    %esi,%edx
    if (*s == c)
  804160552d:	40 38 c6             	cmp    %al,%sil
  8041605530:	74 22                	je     8041605554 <strchr+0x34>
  for (; *s; s++)
  8041605532:	48 83 c7 01          	add    $0x1,%rdi
  8041605536:	0f b6 07             	movzbl (%rdi),%eax
  8041605539:	84 c0                	test   %al,%al
  804160553b:	74 09                	je     8041605546 <strchr+0x26>
    if (*s == c)
  804160553d:	38 d0                	cmp    %dl,%al
  804160553f:	75 f1                	jne    8041605532 <strchr+0x12>
  for (; *s; s++)
  8041605541:	48 89 f8             	mov    %rdi,%rax
  8041605544:	eb 05                	jmp    804160554b <strchr+0x2b>
      return (char *)s;
  return 0;
  8041605546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804160554b:	5d                   	pop    %rbp
  804160554c:	c3                   	retq   
  return 0;
  804160554d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041605552:	eb f7                	jmp    804160554b <strchr+0x2b>
    if (*s == c)
  8041605554:	48 89 f8             	mov    %rdi,%rax
  8041605557:	eb f2                	jmp    804160554b <strchr+0x2b>

0000008041605559 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c) {
  8041605559:	55                   	push   %rbp
  804160555a:	48 89 e5             	mov    %rsp,%rbp
  804160555d:	48 89 f8             	mov    %rdi,%rax
  for (; *s; s++)
  8041605560:	0f b6 17             	movzbl (%rdi),%edx
    if (*s == c)
  8041605563:	40 38 f2             	cmp    %sil,%dl
  8041605566:	74 15                	je     804160557d <strfind+0x24>
  8041605568:	89 f1                	mov    %esi,%ecx
  804160556a:	84 d2                	test   %dl,%dl
  804160556c:	74 0f                	je     804160557d <strfind+0x24>
  for (; *s; s++)
  804160556e:	48 83 c0 01          	add    $0x1,%rax
  8041605572:	0f b6 10             	movzbl (%rax),%edx
    if (*s == c)
  8041605575:	38 ca                	cmp    %cl,%dl
  8041605577:	74 04                	je     804160557d <strfind+0x24>
  8041605579:	84 d2                	test   %dl,%dl
  804160557b:	75 f1                	jne    804160556e <strfind+0x15>
      break;
  return (char *)s;
}
  804160557d:	5d                   	pop    %rbp
  804160557e:	c3                   	retq   

000000804160557f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n) {
  804160557f:	55                   	push   %rbp
  8041605580:	48 89 e5             	mov    %rsp,%rbp
  if (n == 0)
  8041605583:	48 85 d2             	test   %rdx,%rdx
  8041605586:	74 13                	je     804160559b <memset+0x1c>
    return v;
  if ((int64_t)v % 4 == 0 && n % 4 == 0) {
  8041605588:	40 f6 c7 03          	test   $0x3,%dil
  804160558c:	75 05                	jne    8041605593 <memset+0x14>
  804160558e:	f6 c2 03             	test   $0x3,%dl
  8041605591:	74 0d                	je     80416055a0 <memset+0x21>
    uint32_t k = c & 0xFFU;
    k          = (k << 24U) | (k << 16U) | (k << 8U) | k;
    asm volatile("cld; rep stosl\n" ::"D"(v), "a"(k), "c"(n / 4)
                 : "cc", "memory");
  } else
    asm volatile("cld; rep stosb\n" ::"D"(v), "a"(c), "c"(n)
  8041605593:	89 f0                	mov    %esi,%eax
  8041605595:	48 89 d1             	mov    %rdx,%rcx
  8041605598:	fc                   	cld    
  8041605599:	f3 aa                	rep stos %al,%es:(%rdi)
                 : "cc", "memory");
  return v;
}
  804160559b:	48 89 f8             	mov    %rdi,%rax
  804160559e:	5d                   	pop    %rbp
  804160559f:	c3                   	retq   
    uint32_t k = c & 0xFFU;
  80416055a0:	40 0f b6 f6          	movzbl %sil,%esi
    k          = (k << 24U) | (k << 16U) | (k << 8U) | k;
  80416055a4:	89 f0                	mov    %esi,%eax
  80416055a6:	c1 e0 08             	shl    $0x8,%eax
  80416055a9:	89 f1                	mov    %esi,%ecx
  80416055ab:	c1 e1 18             	shl    $0x18,%ecx
  80416055ae:	41 89 f0             	mov    %esi,%r8d
  80416055b1:	41 c1 e0 10          	shl    $0x10,%r8d
  80416055b5:	44 09 c1             	or     %r8d,%ecx
  80416055b8:	09 ce                	or     %ecx,%esi
  80416055ba:	09 f0                	or     %esi,%eax
    asm volatile("cld; rep stosl\n" ::"D"(v), "a"(k), "c"(n / 4)
  80416055bc:	48 c1 ea 02          	shr    $0x2,%rdx
  80416055c0:	48 89 d1             	mov    %rdx,%rcx
  80416055c3:	fc                   	cld    
  80416055c4:	f3 ab                	rep stos %eax,%es:(%rdi)
  if ((int64_t)v % 4 == 0 && n % 4 == 0) {
  80416055c6:	eb d3                	jmp    804160559b <memset+0x1c>

00000080416055c8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80416055c8:	55                   	push   %rbp
  80416055c9:	48 89 e5             	mov    %rsp,%rbp
  80416055cc:	48 89 f8             	mov    %rdi,%rax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
  80416055cf:	48 39 fe             	cmp    %rdi,%rsi
  80416055d2:	73 43                	jae    8041605617 <memmove+0x4f>
  80416055d4:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  80416055d8:	48 39 f9             	cmp    %rdi,%rcx
  80416055db:	76 3a                	jbe    8041605617 <memmove+0x4f>
    s += n;
    d += n;
  80416055dd:	48 8d 3c 17          	lea    (%rdi,%rdx,1),%rdi
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  80416055e1:	48 89 ce             	mov    %rcx,%rsi
  80416055e4:	48 09 fe             	or     %rdi,%rsi
  80416055e7:	40 f6 c6 03          	test   $0x3,%sil
  80416055eb:	74 11                	je     80416055fe <memmove+0x36>
      asm volatile("std; rep movsl\n" ::"D"(d - 4), "S"(s - 4), "c"(n / 4)
                   : "cc", "memory");
    else
      asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80416055ed:	48 83 ef 01          	sub    $0x1,%rdi
  80416055f1:	48 8d 71 ff          	lea    -0x1(%rcx),%rsi
  80416055f5:	48 89 d1             	mov    %rdx,%rcx
  80416055f8:	fd                   	std    
  80416055f9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                   : "cc", "memory");
    // Some versions of GCC rely on DF being clear
    asm volatile("cld" ::
  80416055fb:	fc                   	cld    
  80416055fc:	eb 2d                	jmp    804160562b <memmove+0x63>
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  80416055fe:	f6 c2 03             	test   $0x3,%dl
  8041605601:	75 ea                	jne    80416055ed <memmove+0x25>
      asm volatile("std; rep movsl\n" ::"D"(d - 4), "S"(s - 4), "c"(n / 4)
  8041605603:	48 83 ef 04          	sub    $0x4,%rdi
  8041605607:	48 8d 71 fc          	lea    -0x4(%rcx),%rsi
  804160560b:	48 c1 ea 02          	shr    $0x2,%rdx
  804160560f:	48 89 d1             	mov    %rdx,%rcx
  8041605612:	fd                   	std    
  8041605613:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8041605615:	eb e4                	jmp    80416055fb <memmove+0x33>
                     : "cc");
  } else {
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  8041605617:	48 89 f1             	mov    %rsi,%rcx
  804160561a:	48 09 c1             	or     %rax,%rcx
  804160561d:	f6 c1 03             	test   $0x3,%cl
  8041605620:	74 0b                	je     804160562d <memmove+0x65>
      asm volatile("cld; rep movsl\n" ::"D"(d), "S"(s), "c"(n / 4)
                   : "cc", "memory");
    else
      asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8041605622:	48 89 c7             	mov    %rax,%rdi
  8041605625:	48 89 d1             	mov    %rdx,%rcx
  8041605628:	fc                   	cld    
  8041605629:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                   : "cc", "memory");
  }
  return dst;
}
  804160562b:	5d                   	pop    %rbp
  804160562c:	c3                   	retq   
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  804160562d:	f6 c2 03             	test   $0x3,%dl
  8041605630:	75 f0                	jne    8041605622 <memmove+0x5a>
      asm volatile("cld; rep movsl\n" ::"D"(d), "S"(s), "c"(n / 4)
  8041605632:	48 c1 ea 02          	shr    $0x2,%rdx
  8041605636:	48 89 d1             	mov    %rdx,%rcx
  8041605639:	48 89 c7             	mov    %rax,%rdi
  804160563c:	fc                   	cld    
  804160563d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804160563f:	eb ea                	jmp    804160562b <memmove+0x63>

0000008041605641 <memcpy>:
  return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8041605641:	55                   	push   %rbp
  8041605642:	48 89 e5             	mov    %rsp,%rbp
  return memmove(dst, src, n);
  8041605645:	48 b8 c8 55 60 41 80 	movabs $0x80416055c8,%rax
  804160564c:	00 00 00 
  804160564f:	ff d0                	callq  *%rax
}
  8041605651:	5d                   	pop    %rbp
  8041605652:	c3                   	retq   

0000008041605653 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8041605653:	55                   	push   %rbp
  8041605654:	48 89 e5             	mov    %rsp,%rbp
  8041605657:	41 57                	push   %r15
  8041605659:	41 56                	push   %r14
  804160565b:	41 55                	push   %r13
  804160565d:	41 54                	push   %r12
  804160565f:	53                   	push   %rbx
  8041605660:	49 89 fe             	mov    %rdi,%r14
  8041605663:	49 89 f7             	mov    %rsi,%r15
  8041605666:	49 89 d5             	mov    %rdx,%r13
  const size_t srclen = strlen(src);
  8041605669:	48 89 f7             	mov    %rsi,%rdi
  804160566c:	48 b8 8b 53 60 41 80 	movabs $0x804160538b,%rax
  8041605673:	00 00 00 
  8041605676:	ff d0                	callq  *%rax
  8041605678:	48 63 d8             	movslq %eax,%rbx
  const size_t dstlen = strnlen(dst, maxlen);
  804160567b:	4c 89 ee             	mov    %r13,%rsi
  804160567e:	4c 89 f7             	mov    %r14,%rdi
  8041605681:	48 b8 ae 53 60 41 80 	movabs $0x80416053ae,%rax
  8041605688:	00 00 00 
  804160568b:	ff d0                	callq  *%rax
  804160568d:	4c 63 e0             	movslq %eax,%r12
    return maxlen + srclen;
  8041605690:	4a 8d 04 2b          	lea    (%rbx,%r13,1),%rax
  if (dstlen == maxlen)
  8041605694:	4d 39 e5             	cmp    %r12,%r13
  8041605697:	74 26                	je     80416056bf <strlcat+0x6c>
  if (srclen < maxlen - dstlen) {
  8041605699:	4c 89 e8             	mov    %r13,%rax
  804160569c:	4c 29 e0             	sub    %r12,%rax
  804160569f:	48 39 d8             	cmp    %rbx,%rax
  80416056a2:	76 26                	jbe    80416056ca <strlcat+0x77>
    memcpy(dst + dstlen, src, srclen + 1);
  80416056a4:	48 8d 53 01          	lea    0x1(%rbx),%rdx
  80416056a8:	4b 8d 3c 26          	lea    (%r14,%r12,1),%rdi
  80416056ac:	4c 89 fe             	mov    %r15,%rsi
  80416056af:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416056b6:	00 00 00 
  80416056b9:	ff d0                	callq  *%rax
  return dstlen + srclen;
  80416056bb:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
}
  80416056bf:	5b                   	pop    %rbx
  80416056c0:	41 5c                	pop    %r12
  80416056c2:	41 5d                	pop    %r13
  80416056c4:	41 5e                	pop    %r14
  80416056c6:	41 5f                	pop    %r15
  80416056c8:	5d                   	pop    %rbp
  80416056c9:	c3                   	retq   
    memcpy(dst + dstlen, src, maxlen - 1);
  80416056ca:	49 83 ed 01          	sub    $0x1,%r13
  80416056ce:	4b 8d 3c 26          	lea    (%r14,%r12,1),%rdi
  80416056d2:	4c 89 ea             	mov    %r13,%rdx
  80416056d5:	4c 89 fe             	mov    %r15,%rsi
  80416056d8:	48 b8 41 56 60 41 80 	movabs $0x8041605641,%rax
  80416056df:	00 00 00 
  80416056e2:	ff d0                	callq  *%rax
    dst[dstlen + maxlen - 1] = '\0';
  80416056e4:	4d 01 ee             	add    %r13,%r14
  80416056e7:	43 c6 04 26 00       	movb   $0x0,(%r14,%r12,1)
  80416056ec:	eb cd                	jmp    80416056bb <strlcat+0x68>

00000080416056ee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80416056ee:	55                   	push   %rbp
  80416056ef:	48 89 e5             	mov    %rsp,%rbp
  const uint8_t *s1 = (const uint8_t *)v1;
  const uint8_t *s2 = (const uint8_t *)v2;

  while (n-- > 0) {
  80416056f2:	48 85 d2             	test   %rdx,%rdx
  80416056f5:	74 3c                	je     8041605733 <memcmp+0x45>
    if (*s1 != *s2)
  80416056f7:	0f b6 0f             	movzbl (%rdi),%ecx
  80416056fa:	44 0f b6 06          	movzbl (%rsi),%r8d
  80416056fe:	44 38 c1             	cmp    %r8b,%cl
  8041605701:	75 1d                	jne    8041605720 <memcmp+0x32>
  8041605703:	b8 01 00 00 00       	mov    $0x1,%eax
  while (n-- > 0) {
  8041605708:	48 39 d0             	cmp    %rdx,%rax
  804160570b:	74 1f                	je     804160572c <memcmp+0x3e>
    if (*s1 != *s2)
  804160570d:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8041605711:	48 83 c0 01          	add    $0x1,%rax
  8041605715:	44 0f b6 44 06 ff    	movzbl -0x1(%rsi,%rax,1),%r8d
  804160571b:	44 38 c1             	cmp    %r8b,%cl
  804160571e:	74 e8                	je     8041605708 <memcmp+0x1a>
      return (int)*s1 - (int)*s2;
  8041605720:	0f b6 c1             	movzbl %cl,%eax
  8041605723:	45 0f b6 c0          	movzbl %r8b,%r8d
  8041605727:	44 29 c0             	sub    %r8d,%eax
    s1++, s2++;
  }

  return 0;
}
  804160572a:	5d                   	pop    %rbp
  804160572b:	c3                   	retq   
  return 0;
  804160572c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041605731:	eb f7                	jmp    804160572a <memcmp+0x3c>
  8041605733:	b8 00 00 00 00       	mov    $0x0,%eax
  8041605738:	eb f0                	jmp    804160572a <memcmp+0x3c>

000000804160573a <memfind>:

void *
memfind(const void *s, int c, size_t n) {
  804160573a:	55                   	push   %rbp
  804160573b:	48 89 e5             	mov    %rsp,%rbp
  804160573e:	48 89 f8             	mov    %rdi,%rax
  const void *ends = (const char *)s + n;
  8041605741:	48 01 fa             	add    %rdi,%rdx
  for (; s < ends; s++)
  8041605744:	48 39 d7             	cmp    %rdx,%rdi
  8041605747:	73 14                	jae    804160575d <memfind+0x23>
    if (*(const unsigned char *)s == (unsigned char)c)
  8041605749:	89 f1                	mov    %esi,%ecx
  804160574b:	40 38 37             	cmp    %sil,(%rdi)
  804160574e:	74 0d                	je     804160575d <memfind+0x23>
  for (; s < ends; s++)
  8041605750:	48 83 c0 01          	add    $0x1,%rax
  8041605754:	48 39 c2             	cmp    %rax,%rdx
  8041605757:	74 04                	je     804160575d <memfind+0x23>
    if (*(const unsigned char *)s == (unsigned char)c)
  8041605759:	38 08                	cmp    %cl,(%rax)
  804160575b:	75 f3                	jne    8041605750 <memfind+0x16>
      break;
  return (void *)s;
}
  804160575d:	5d                   	pop    %rbp
  804160575e:	c3                   	retq   

000000804160575f <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  804160575f:	55                   	push   %rbp
  8041605760:	48 89 e5             	mov    %rsp,%rbp
  int neg  = 0;
  long val = 0;

  // gobble initial whitespace
  while (*s == ' ' || *s == '\t')
  8041605763:	0f b6 07             	movzbl (%rdi),%eax
  8041605766:	3c 20                	cmp    $0x20,%al
  8041605768:	74 04                	je     804160576e <strtol+0xf>
  804160576a:	3c 09                	cmp    $0x9,%al
  804160576c:	75 0f                	jne    804160577d <strtol+0x1e>
    s++;
  804160576e:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == ' ' || *s == '\t')
  8041605772:	0f b6 07             	movzbl (%rdi),%eax
  8041605775:	3c 20                	cmp    $0x20,%al
  8041605777:	74 f5                	je     804160576e <strtol+0xf>
  8041605779:	3c 09                	cmp    $0x9,%al
  804160577b:	74 f1                	je     804160576e <strtol+0xf>

  // plus/minus sign
  if (*s == '+')
  804160577d:	3c 2b                	cmp    $0x2b,%al
  804160577f:	74 2f                	je     80416057b0 <strtol+0x51>
  int neg  = 0;
  8041605781:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    s++;
  else if (*s == '-')
  8041605787:	3c 2d                	cmp    $0x2d,%al
  8041605789:	74 31                	je     80416057bc <strtol+0x5d>
    s++, neg = 1;

  // hex or octal base prefix
  if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  804160578b:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8041605791:	75 05                	jne    8041605798 <strtol+0x39>
  8041605793:	80 3f 30             	cmpb   $0x30,(%rdi)
  8041605796:	74 30                	je     80416057c8 <strtol+0x69>
    s += 2, base = 16;
  else if (base == 0 && s[0] == '0')
  8041605798:	85 d2                	test   %edx,%edx
  804160579a:	75 0a                	jne    80416057a6 <strtol+0x47>
    s++, base = 8;
  else if (base == 0)
    base = 10;
  804160579c:	ba 0a 00 00 00       	mov    $0xa,%edx
  else if (base == 0 && s[0] == '0')
  80416057a1:	80 3f 30             	cmpb   $0x30,(%rdi)
  80416057a4:	74 2c                	je     80416057d2 <strtol+0x73>
    base = 10;
  80416057a6:	b8 00 00 00 00       	mov    $0x0,%eax
      dig = *s - 'A' + 10;
    else
      break;
    if (dig >= base)
      break;
    s++, val = (val * base) + dig;
  80416057ab:	4c 63 d2             	movslq %edx,%r10
  80416057ae:	eb 5c                	jmp    804160580c <strtol+0xad>
    s++;
  80416057b0:	48 83 c7 01          	add    $0x1,%rdi
  int neg  = 0;
  80416057b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80416057ba:	eb cf                	jmp    804160578b <strtol+0x2c>
    s++, neg = 1;
  80416057bc:	48 83 c7 01          	add    $0x1,%rdi
  80416057c0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  80416057c6:	eb c3                	jmp    804160578b <strtol+0x2c>
  if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80416057c8:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80416057cc:	74 0f                	je     80416057dd <strtol+0x7e>
  else if (base == 0 && s[0] == '0')
  80416057ce:	85 d2                	test   %edx,%edx
  80416057d0:	75 d4                	jne    80416057a6 <strtol+0x47>
    s++, base = 8;
  80416057d2:	48 83 c7 01          	add    $0x1,%rdi
  80416057d6:	ba 08 00 00 00       	mov    $0x8,%edx
  80416057db:	eb c9                	jmp    80416057a6 <strtol+0x47>
    s += 2, base = 16;
  80416057dd:	48 83 c7 02          	add    $0x2,%rdi
  80416057e1:	ba 10 00 00 00       	mov    $0x10,%edx
  80416057e6:	eb be                	jmp    80416057a6 <strtol+0x47>
    else if (*s >= 'a' && *s <= 'z')
  80416057e8:	44 8d 41 9f          	lea    -0x61(%rcx),%r8d
  80416057ec:	41 80 f8 19          	cmp    $0x19,%r8b
  80416057f0:	77 2f                	ja     8041605821 <strtol+0xc2>
      dig = *s - 'a' + 10;
  80416057f2:	44 0f be c1          	movsbl %cl,%r8d
  80416057f6:	41 8d 48 a9          	lea    -0x57(%r8),%ecx
    if (dig >= base)
  80416057fa:	39 d1                	cmp    %edx,%ecx
  80416057fc:	7d 37                	jge    8041605835 <strtol+0xd6>
    s++, val = (val * base) + dig;
  80416057fe:	48 83 c7 01          	add    $0x1,%rdi
  8041605802:	49 0f af c2          	imul   %r10,%rax
  8041605806:	48 63 c9             	movslq %ecx,%rcx
  8041605809:	48 01 c8             	add    %rcx,%rax
    if (*s >= '0' && *s <= '9')
  804160580c:	0f b6 0f             	movzbl (%rdi),%ecx
  804160580f:	44 8d 41 d0          	lea    -0x30(%rcx),%r8d
  8041605813:	41 80 f8 09          	cmp    $0x9,%r8b
  8041605817:	77 cf                	ja     80416057e8 <strtol+0x89>
      dig = *s - '0';
  8041605819:	0f be c9             	movsbl %cl,%ecx
  804160581c:	83 e9 30             	sub    $0x30,%ecx
  804160581f:	eb d9                	jmp    80416057fa <strtol+0x9b>
    else if (*s >= 'A' && *s <= 'Z')
  8041605821:	44 8d 41 bf          	lea    -0x41(%rcx),%r8d
  8041605825:	41 80 f8 19          	cmp    $0x19,%r8b
  8041605829:	77 0a                	ja     8041605835 <strtol+0xd6>
      dig = *s - 'A' + 10;
  804160582b:	44 0f be c1          	movsbl %cl,%r8d
  804160582f:	41 8d 48 c9          	lea    -0x37(%r8),%ecx
  8041605833:	eb c5                	jmp    80416057fa <strtol+0x9b>
    // we don't properly detect overflow!
  }

  if (endptr)
  8041605835:	48 85 f6             	test   %rsi,%rsi
  8041605838:	74 03                	je     804160583d <strtol+0xde>
    *endptr = (char *)s;
  804160583a:	48 89 3e             	mov    %rdi,(%rsi)
  return (neg ? -val : val);
  804160583d:	48 89 c2             	mov    %rax,%rdx
  8041605840:	48 f7 da             	neg    %rdx
  8041605843:	45 85 c9             	test   %r9d,%r9d
  8041605846:	48 0f 45 c2          	cmovne %rdx,%rax
}
  804160584a:	5d                   	pop    %rbp
  804160584b:	c3                   	retq   

000000804160584c <_efi_call_in_32bit_mode_asm>:

.globl _efi_call_in_32bit_mode_asm
.type _efi_call_in_32bit_mode_asm, @function;
.align 2
_efi_call_in_32bit_mode_asm:
    pushq %rbp
  804160584c:	55                   	push   %rbp
    movq %rsp, %rbp
  804160584d:	48 89 e5             	mov    %rsp,%rbp
    /* save non-volatile registers */
	push	%rbx
  8041605850:	53                   	push   %rbx
	push	%r12
  8041605851:	41 54                	push   %r12
	push	%r13
  8041605853:	41 55                	push   %r13
	push	%r14
  8041605855:	41 56                	push   %r14
	push	%r15
  8041605857:	41 57                	push   %r15

	/* save parameters that we will need later */
	push	%rsi
  8041605859:	56                   	push   %rsi
	push	%rcx
  804160585a:	51                   	push   %rcx

	push	%rbp	/* save %rbp and align to 16-byte boundary */
  804160585b:	55                   	push   %rbp
				/* efi_reg in %rsi */
				/* stack_contents into %rdx */
				/* s_c_s into %rcx */
	sub	%rcx, %rsp	/* make room for stack contents */
  804160585c:	48 29 cc             	sub    %rcx,%rsp

	COPY_STACK(%rdx, %rcx, %r8)
  804160585f:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8

0000008041605866 <copyloop>:
  8041605866:	4a 8b 04 02          	mov    (%rdx,%r8,1),%rax
  804160586a:	4a 89 04 04          	mov    %rax,(%rsp,%r8,1)
  804160586e:	49 83 c0 08          	add    $0x8,%r8
  8041605872:	49 39 c8             	cmp    %rcx,%r8
  8041605875:	75 ef                	jne    8041605866 <copyloop>
	/*
	 * Here in long-mode, with high kernel addresses,
	 * but with the kernel double-mapped in the bottom 4GB.
	 * We now switch to compat mode and call into EFI.
	 */
	ENTER_COMPAT_MODE()
  8041605877:	e8 00 00 00 00       	callq  804160587c <copyloop+0x16>
  804160587c:	48 81 04 24 11 00 00 	addq   $0x11,(%rsp)
  8041605883:	00 
  8041605884:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%rsp)
  804160588b:	00 
  804160588c:	cb                   	lret   

	call	*%edi			/* call EFI runtime */
  804160588d:	ff d7                	callq  *%rdi

	ENTER_64BIT_MODE()
  804160588f:	6a 08                	pushq  $0x8
  8041605891:	e8 00 00 00 00       	callq  8041605896 <copyloop+0x30>
  8041605896:	81 04 24 08 00 00 00 	addl   $0x8,(%rsp)
  804160589d:	cb                   	lret   

	mov	-48(%rbp), %rsi		/* load efi_reg into %esi */
  804160589e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
	mov	%rax, 32(%rsi)		/* save RAX back */
  80416058a2:	48 89 46 20          	mov    %rax,0x20(%rsi)

	mov	-56(%rbp), %rcx	/* load s_c_s into %rcx */
  80416058a6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
	add	%rcx, %rsp	/* discard stack contents */
  80416058aa:	48 01 cc             	add    %rcx,%rsp
	pop	%rbp		/* restore full 64-bit frame pointer */
  80416058ad:	5d                   	pop    %rbp
				/* which the 32-bit EFI will have truncated */
				/* our full %rsp will be restored by EMARF */
	pop	%rcx
  80416058ae:	59                   	pop    %rcx
	pop	%rsi
  80416058af:	5e                   	pop    %rsi
	pop	%r15
  80416058b0:	41 5f                	pop    %r15
	pop	%r14
  80416058b2:	41 5e                	pop    %r14
	pop	%r13
  80416058b4:	41 5d                	pop    %r13
	pop	%r12
  80416058b6:	41 5c                	pop    %r12
	pop	%rbx
  80416058b8:	5b                   	pop    %rbx

	leave
  80416058b9:	c9                   	leaveq 
	ret
  80416058ba:	c3                   	retq   

00000080416058bb <o___7>:
  80416058bb:	55                   	push   %rbp
  80416058bc:	48 89 e5             	mov    %rsp,%rbp
  80416058bf:	48 83 ec 10          	sub    $0x10,%rsp
  80416058c3:	c6 45 f6 a8          	movb   $0xa8,-0xa(%rbp)
  80416058c7:	c6 45 f7 fa          	movb   $0xfa,-0x9(%rbp)
  80416058cb:	c6 45 fc 34          	movb   $0x34,-0x4(%rbp)
  80416058cf:	c6 45 fd 3a          	movb   $0x3a,-0x3(%rbp)
  80416058d3:	c6 45 fa d5          	movb   $0xd5,-0x6(%rbp)
  80416058d7:	c6 45 fb 4e          	movb   $0x4e,-0x5(%rbp)
  80416058db:	c6 45 fe c7          	movb   $0xc7,-0x2(%rbp)
  80416058df:	c6 45 ff e5          	movb   $0xe5,-0x1(%rbp)
  80416058e3:	c6 45 f8 52          	movb   $0x52,-0x8(%rbp)
  80416058e7:	c6 45 f9 e7          	movb   $0xe7,-0x7(%rbp)
  80416058eb:	4c 0f be 07          	movsbq (%rdi),%r8
  80416058ef:	0f b6 47 01          	movzbl 0x1(%rdi),%eax
  80416058f3:	83 f0 a8             	xor    $0xffffffa8,%eax
  80416058f6:	88 07                	mov    %al,(%rdi)
  80416058f8:	49 83 f8 01          	cmp    $0x1,%r8
  80416058fc:	76 41                	jbe    804160593f <o___7+0x84>
  80416058fe:	b9 01 00 00 00       	mov    $0x1,%ecx
  8041605903:	49 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%r9
  804160590a:	cc cc cc 
  804160590d:	0f b6 74 0f 01       	movzbl 0x1(%rdi,%rcx,1),%esi
  8041605912:	40 32 34 0f          	xor    (%rdi,%rcx,1),%sil
  8041605916:	48 89 c8             	mov    %rcx,%rax
  8041605919:	49 f7 e1             	mul    %r9
  804160591c:	48 c1 ea 03          	shr    $0x3,%rdx
  8041605920:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  8041605924:	48 01 c0             	add    %rax,%rax
  8041605927:	48 89 ca             	mov    %rcx,%rdx
  804160592a:	48 29 c2             	sub    %rax,%rdx
  804160592d:	40 32 74 15 f6       	xor    -0xa(%rbp,%rdx,1),%sil
  8041605932:	40 88 34 0f          	mov    %sil,(%rdi,%rcx,1)
  8041605936:	48 83 c1 01          	add    $0x1,%rcx
  804160593a:	49 39 c8             	cmp    %rcx,%r8
  804160593d:	75 ce                	jne    804160590d <o___7+0x52>
  804160593f:	42 c6 44 07 ff 00    	movb   $0x0,-0x1(%rdi,%r8,1)
  8041605945:	c9                   	leaveq 
  8041605946:	c3                   	retq   

0000008041605947 <msg_i$nit>:
  8041605947:	55                   	push   %rbp
  8041605948:	48 89 e5             	mov    %rsp,%rbp
  804160594b:	48 b8 e0 63 62 41 80 	movabs $0x80416263e0,%rax
  8041605952:	00 00 00 
  8041605955:	c6 80 26 05 00 00 02 	movb   $0x2,0x526(%rax)
  804160595c:	c6 80 0c 04 00 00 76 	movb   $0x76,0x40c(%rax)
  8041605963:	c6 80 02 02 00 00 79 	movb   $0x79,0x202(%rax)
  804160596a:	c6 80 2b 01 00 00 5b 	movb   $0x5b,0x12b(%rax)
  8041605971:	c6 80 25 05 00 00 59 	movb   $0x59,0x525(%rax)
  8041605978:	c6 80 17 05 00 00 5c 	movb   $0x5c,0x517(%rax)
  804160597f:	c6 80 41 06 00 00 79 	movb   $0x79,0x641(%rax)
  8041605986:	c6 80 28 03 00 00 5f 	movb   $0x5f,0x328(%rax)
  804160598d:	c6 80 06 03 00 00 1f 	movb   $0x1f,0x306(%rax)
  8041605994:	c6 80 24 03 00 00 2f 	movb   $0x2f,0x324(%rax)
  804160599b:	c6 80 28 01 00 00 64 	movb   $0x64,0x128(%rax)
  80416059a2:	c6 80 1f 02 00 00 b6 	movb   $0xb6,0x21f(%rax)
  80416059a9:	c6 80 18 02 00 00 9f 	movb   $0x9f,0x218(%rax)
  80416059b0:	c6 80 20 06 00 00 06 	movb   $0x6,0x620(%rax)
  80416059b7:	c6 80 53 06 00 00 0a 	movb   $0xa,0x653(%rax)
  80416059be:	c6 80 04 04 00 00 dd 	movb   $0xdd,0x404(%rax)
  80416059c5:	c6 80 02 05 00 00 6d 	movb   $0x6d,0x502(%rax)
  80416059cc:	c6 40 14 01          	movb   $0x1,0x14(%rax)
  80416059d0:	c6 80 0a 05 00 00 36 	movb   $0x36,0x50a(%rax)
  80416059d7:	c6 80 42 06 00 00 5a 	movb   $0x5a,0x642(%rax)
  80416059de:	c6 80 23 06 00 00 40 	movb   $0x40,0x623(%rax)
  80416059e5:	c6 80 0f 03 00 00 4e 	movb   $0x4e,0x30f(%rax)
  80416059ec:	c6 80 01 05 00 00 e2 	movb   $0xe2,0x501(%rax)
  80416059f3:	c6 40 0d 7d          	movb   $0x7d,0xd(%rax)
  80416059f7:	c6 80 11 05 00 00 03 	movb   $0x3,0x511(%rax)
  80416059fe:	c6 80 1d 05 00 00 e1 	movb   $0xe1,0x51d(%rax)
  8041605a05:	c6 80 31 01 00 00 f2 	movb   $0xf2,0x131(%rax)
  8041605a0c:	c6 80 2a 01 00 00 64 	movb   $0x64,0x12a(%rax)
  8041605a13:	c6 80 2a 02 00 00 7a 	movb   $0x7a,0x22a(%rax)
  8041605a1a:	c6 80 30 03 00 00 1c 	movb   $0x1c,0x330(%rax)
  8041605a21:	c6 80 27 06 00 00 82 	movb   $0x82,0x627(%rax)
  8041605a28:	c6 80 5e 06 00 00 81 	movb   $0x81,0x65e(%rax)
  8041605a2f:	c6 80 06 04 00 00 13 	movb   $0x13,0x406(%rax)
  8041605a36:	c6 80 29 03 00 00 99 	movb   $0x99,0x329(%rax)
  8041605a3d:	c6 40 08 5b          	movb   $0x5b,0x8(%rax)
  8041605a41:	c6 80 15 03 00 00 cc 	movb   $0xcc,0x315(%rax)
  8041605a48:	c6 80 05 01 00 00 35 	movb   $0x35,0x105(%rax)
  8041605a4f:	c6 80 3c 06 00 00 7a 	movb   $0x7a,0x63c(%rax)
  8041605a56:	c6 80 3a 06 00 00 45 	movb   $0x45,0x63a(%rax)
  8041605a5d:	c6 80 2b 06 00 00 1f 	movb   $0x1f,0x62b(%rax)
  8041605a64:	c6 80 0c 01 00 00 70 	movb   $0x70,0x10c(%rax)
  8041605a6b:	c6 80 29 01 00 00 be 	movb   $0xbe,0x129(%rax)
  8041605a72:	c6 80 0b 06 00 00 c5 	movb   $0xc5,0x60b(%rax)
  8041605a79:	c6 80 00 04 00 00 1b 	movb   $0x1b,0x400(%rax)
  8041605a80:	c6 80 39 03 00 00 1b 	movb   $0x1b,0x339(%rax)
  8041605a87:	c6 80 10 02 00 00 1a 	movb   $0x1a,0x210(%rax)
  8041605a8e:	c6 80 29 02 00 00 e5 	movb   $0xe5,0x229(%rax)
  8041605a95:	c6 80 54 06 00 00 de 	movb   $0xde,0x654(%rax)
  8041605a9c:	c6 80 32 03 00 00 72 	movb   $0x72,0x332(%rax)
  8041605aa3:	c6 80 22 05 00 00 c5 	movb   $0xc5,0x522(%rax)
  8041605aaa:	c6 80 07 06 00 00 23 	movb   $0x23,0x607(%rax)
  8041605ab1:	c6 80 24 06 00 00 61 	movb   $0x61,0x624(%rax)
  8041605ab8:	c6 80 34 01 00 00 2f 	movb   $0x2f,0x134(%rax)
  8041605abf:	c6 80 12 01 00 00 49 	movb   $0x49,0x112(%rax)
  8041605ac6:	c6 80 31 03 00 00 b7 	movb   $0xb7,0x331(%rax)
  8041605acd:	c6 80 05 03 00 00 70 	movb   $0x70,0x305(%rax)
  8041605ad4:	c6 80 16 05 00 00 77 	movb   $0x77,0x516(%rax)
  8041605adb:	c6 40 0c 5f          	movb   $0x5f,0xc(%rax)
  8041605adf:	c6 80 07 03 00 00 0b 	movb   $0xb,0x307(%rax)
  8041605ae6:	c6 80 08 01 00 00 48 	movb   $0x48,0x108(%rax)
  8041605aed:	c6 80 1a 02 00 00 17 	movb   $0x17,0x21a(%rax)
  8041605af4:	c6 80 08 06 00 00 39 	movb   $0x39,0x608(%rax)
  8041605afb:	c6 80 3f 06 00 00 46 	movb   $0x46,0x63f(%rax)
  8041605b02:	c6 80 1a 01 00 00 59 	movb   $0x59,0x11a(%rax)
  8041605b09:	c6 80 55 06 00 00 31 	movb   $0x31,0x655(%rax)
  8041605b10:	c6 80 1a 06 00 00 66 	movb   $0x66,0x61a(%rax)
  8041605b17:	c6 80 1b 02 00 00 47 	movb   $0x47,0x21b(%rax)
  8041605b1e:	c6 80 33 01 00 00 b0 	movb   $0xb0,0x133(%rax)
  8041605b25:	c6 40 13 c5          	movb   $0xc5,0x13(%rax)
  8041605b29:	c6 80 11 01 00 00 16 	movb   $0x16,0x111(%rax)
  8041605b30:	c6 80 4f 06 00 00 a0 	movb   $0xa0,0x64f(%rax)
  8041605b37:	c6 80 27 01 00 00 f4 	movb   $0xf4,0x127(%rax)
  8041605b3e:	c6 80 0a 01 00 00 70 	movb   $0x70,0x10a(%rax)
  8041605b45:	c6 80 2c 03 00 00 db 	movb   $0xdb,0x32c(%rax)
  8041605b4c:	c6 80 2a 06 00 00 23 	movb   $0x23,0x62a(%rax)
  8041605b53:	c6 80 04 01 00 00 85 	movb   $0x85,0x104(%rax)
  8041605b5a:	c6 80 0d 06 00 00 3e 	movb   $0x3e,0x60d(%rax)
  8041605b61:	c6 80 04 03 00 00 ca 	movb   $0xca,0x304(%rax)
  8041605b68:	c6 80 34 03 00 00 27 	movb   $0x27,0x334(%rax)
  8041605b6f:	c6 80 58 06 00 00 46 	movb   $0x46,0x658(%rax)
  8041605b76:	c6 80 28 05 00 00 33 	movb   $0x33,0x528(%rax)
  8041605b7d:	c6 80 0e 05 00 00 9a 	movb   $0x9a,0x50e(%rax)
  8041605b84:	c6 80 2e 03 00 00 17 	movb   $0x17,0x32e(%rax)
  8041605b8b:	c6 80 08 05 00 00 1d 	movb   $0x1d,0x508(%rax)
  8041605b92:	c6 80 24 01 00 00 0b 	movb   $0xb,0x124(%rax)
  8041605b99:	c6 80 03 03 00 00 41 	movb   $0x41,0x303(%rax)
  8041605ba0:	c6 80 0a 06 00 00 08 	movb   $0x8,0x60a(%rax)
  8041605ba7:	c6 80 08 04 00 00 4d 	movb   $0x4d,0x408(%rax)
  8041605bae:	c6 80 1d 02 00 00 f3 	movb   $0xf3,0x21d(%rax)
  8041605bb5:	c6 80 0f 06 00 00 09 	movb   $0x9,0x60f(%rax)
  8041605bbc:	c6 80 09 06 00 00 9f 	movb   $0x9f,0x609(%rax)
  8041605bc3:	c6 80 12 05 00 00 4f 	movb   $0x4f,0x512(%rax)
  8041605bca:	c6 80 15 01 00 00 bc 	movb   $0xbc,0x115(%rax)
  8041605bd1:	c6 80 18 04 00 00 95 	movb   $0x95,0x418(%rax)
  8041605bd8:	c6 80 09 05 00 00 b6 	movb   $0xb6,0x509(%rax)
  8041605bdf:	c6 80 11 04 00 00 57 	movb   $0x57,0x411(%rax)
  8041605be6:	c6 40 0f 54          	movb   $0x54,0xf(%rax)
  8041605bea:	c6 80 16 02 00 00 69 	movb   $0x69,0x216(%rax)
  8041605bf1:	c6 80 25 03 00 00 74 	movb   $0x74,0x325(%rax)
  8041605bf8:	c6 80 35 03 00 00 10 	movb   $0x10,0x335(%rax)
  8041605bff:	c6 40 0e e8          	movb   $0xe8,0xe(%rax)
  8041605c03:	c6 80 22 01 00 00 9a 	movb   $0x9a,0x122(%rax)
  8041605c0a:	c6 80 1f 03 00 00 99 	movb   $0x99,0x31f(%rax)
  8041605c11:	c6 80 43 06 00 00 0b 	movb   $0xb,0x643(%rax)
  8041605c18:	c6 80 07 05 00 00 4e 	movb   $0x4e,0x507(%rax)
  8041605c1f:	c6 80 57 06 00 00 0b 	movb   $0xb,0x657(%rax)
  8041605c26:	c6 80 0e 02 00 00 d3 	movb   $0xd3,0x20e(%rax)
  8041605c2d:	c6 80 51 06 00 00 a1 	movb   $0xa1,0x651(%rax)
  8041605c34:	c6 80 03 02 00 00 45 	movb   $0x45,0x203(%rax)
  8041605c3b:	c6 80 19 06 00 00 4d 	movb   $0x4d,0x619(%rax)
  8041605c42:	c6 80 38 03 00 00 41 	movb   $0x41,0x338(%rax)
  8041605c49:	c6 80 13 05 00 00 ed 	movb   $0xed,0x513(%rax)
  8041605c50:	c6 80 21 03 00 00 33 	movb   $0x33,0x321(%rax)
  8041605c57:	c6 80 49 06 00 00 51 	movb   $0x51,0x649(%rax)
  8041605c5e:	c6 80 0b 01 00 00 aa 	movb   $0xaa,0x10b(%rax)
  8041605c65:	c6 80 26 01 00 00 5c 	movb   $0x5c,0x126(%rax)
  8041605c6c:	c6 80 10 01 00 00 4a 	movb   $0x4a,0x110(%rax)
  8041605c73:	c6 80 1e 03 00 00 53 	movb   $0x53,0x31e(%rax)
  8041605c7a:	c6 80 1c 02 00 00 5d 	movb   $0x5d,0x21c(%rax)
  8041605c81:	c6 80 1d 01 00 00 f2 	movb   $0xf2,0x11d(%rax)
  8041605c88:	c6 80 32 06 00 00 2c 	movb   $0x2c,0x632(%rax)
  8041605c8f:	c6 80 10 05 00 00 56 	movb   $0x56,0x510(%rax)
  8041605c96:	c6 80 1e 05 00 00 68 	movb   $0x68,0x51e(%rax)
  8041605c9d:	c6 40 11 38          	movb   $0x38,0x11(%rax)
  8041605ca1:	c6 80 07 02 00 00 0a 	movb   $0xa,0x207(%rax)
  8041605ca8:	c6 80 2a 03 00 00 07 	movb   $0x7,0x32a(%rax)
  8041605caf:	c6 80 50 06 00 00 65 	movb   $0x65,0x650(%rax)
  8041605cb6:	c6 80 20 01 00 00 6e 	movb   $0x6e,0x120(%rax)
  8041605cbd:	c6 80 3f 03 00 00 10 	movb   $0x10,0x33f(%rax)
  8041605cc4:	c6 80 5b 06 00 00 aa 	movb   $0xaa,0x65b(%rax)
  8041605ccb:	c6 80 16 04 00 00 2b 	movb   $0x2b,0x416(%rax)
  8041605cd2:	c6 80 28 06 00 00 47 	movb   $0x47,0x628(%rax)
  8041605cd9:	c6 80 60 06 00 00 17 	movb   $0x17,0x660(%rax)
  8041605ce0:	c6 80 4e 06 00 00 5d 	movb   $0x5d,0x64e(%rax)
  8041605ce7:	c6 80 2c 06 00 00 9c 	movb   $0x9c,0x62c(%rax)
  8041605cee:	c6 80 17 06 00 00 3d 	movb   $0x3d,0x617(%rax)
  8041605cf5:	c6 40 12 23          	movb   $0x23,0x12(%rax)
  8041605cf9:	c6 80 08 03 00 00 78 	movb   $0x78,0x308(%rax)
  8041605d00:	c6 80 11 02 00 00 4d 	movb   $0x4d,0x211(%rax)
  8041605d07:	c6 80 14 06 00 00 06 	movb   $0x6,0x614(%rax)
  8041605d0e:	c6 80 2d 03 00 00 2e 	movb   $0x2e,0x32d(%rax)
  8041605d15:	c6 80 1f 05 00 00 a5 	movb   $0xa5,0x51f(%rax)
  8041605d1c:	c6 40 06 43          	movb   $0x43,0x6(%rax)
  8041605d20:	c6 80 27 05 00 00 b3 	movb   $0xb3,0x527(%rax)
  8041605d27:	c6 80 00 01 00 00 36 	movb   $0x36,0x100(%rax)
  8041605d2e:	c6 80 38 06 00 00 1c 	movb   $0x1c,0x638(%rax)
  8041605d35:	c6 80 32 01 00 00 74 	movb   $0x74,0x132(%rax)
  8041605d3c:	c6 80 36 06 00 00 82 	movb   $0x82,0x636(%rax)
  8041605d43:	c6 00 15             	movb   $0x15,(%rax)
  8041605d46:	c6 80 07 01 00 00 0b 	movb   $0xb,0x107(%rax)
  8041605d4d:	c6 80 19 03 00 00 07 	movb   $0x7,0x319(%rax)
  8041605d54:	c6 80 20 02 00 00 23 	movb   $0x23,0x220(%rax)
  8041605d5b:	c6 80 20 03 00 00 02 	movb   $0x2,0x320(%rax)
  8041605d62:	c6 80 47 06 00 00 e9 	movb   $0xe9,0x647(%rax)
  8041605d69:	c6 80 09 01 00 00 e0 	movb   $0xe0,0x109(%rax)
  8041605d70:	c6 80 19 02 00 00 2b 	movb   $0x2b,0x219(%rax)
  8041605d77:	c6 80 10 03 00 00 7a 	movb   $0x7a,0x310(%rax)
  8041605d7e:	c6 80 36 03 00 00 96 	movb   $0x96,0x336(%rax)
  8041605d85:	c6 80 19 01 00 00 37 	movb   $0x37,0x119(%rax)
  8041605d8c:	c6 40 02 74          	movb   $0x74,0x2(%rax)
  8041605d90:	c6 80 02 06 00 00 7b 	movb   $0x7b,0x602(%rax)
  8041605d97:	c6 80 1b 01 00 00 0f 	movb   $0xf,0x11b(%rax)
  8041605d9e:	c6 80 35 01 00 00 5c 	movb   $0x5c,0x135(%rax)
  8041605da5:	c6 80 3e 03 00 00 25 	movb   $0x25,0x33e(%rax)
  8041605dac:	c6 80 17 02 00 00 1b 	movb   $0x1b,0x217(%rax)
  8041605db3:	c6 80 23 02 00 00 78 	movb   $0x78,0x223(%rax)
  8041605dba:	c6 80 1a 03 00 00 2a 	movb   $0x2a,0x31a(%rax)
  8041605dc1:	c6 80 2b 03 00 00 75 	movb   $0x75,0x32b(%rax)
  8041605dc8:	c6 80 46 06 00 00 2e 	movb   $0x2e,0x646(%rax)
  8041605dcf:	c6 80 15 05 00 00 e2 	movb   $0xe2,0x515(%rax)
  8041605dd6:	c6 80 3b 03 00 00 fd 	movb   $0xfd,0x33b(%rax)
  8041605ddd:	c6 80 4d 06 00 00 02 	movb   $0x2,0x64d(%rax)
  8041605de4:	c6 80 1d 06 00 00 ce 	movb   $0xce,0x61d(%rax)
  8041605deb:	c6 80 02 01 00 00 3b 	movb   $0x3b,0x102(%rax)
  8041605df2:	c6 80 40 03 00 00 d9 	movb   $0xd9,0x340(%rax)
  8041605df9:	c6 80 2b 02 00 00 06 	movb   $0x6,0x22b(%rax)
  8041605e00:	c6 80 17 04 00 00 17 	movb   $0x17,0x417(%rax)
  8041605e07:	c6 80 25 06 00 00 3b 	movb   $0x3b,0x625(%rax)
  8041605e0e:	c6 80 14 02 00 00 26 	movb   $0x26,0x214(%rax)
  8041605e15:	c6 80 3d 03 00 00 b1 	movb   $0xb1,0x33d(%rax)
  8041605e1c:	c6 80 12 02 00 00 05 	movb   $0x5,0x212(%rax)
  8041605e23:	c6 80 0c 06 00 00 1f 	movb   $0x1f,0x60c(%rax)
  8041605e2a:	c6 80 27 03 00 00 db 	movb   $0xdb,0x327(%rax)
  8041605e31:	c6 80 0f 01 00 00 70 	movb   $0x70,0x10f(%rax)
  8041605e38:	c6 80 0d 05 00 00 19 	movb   $0x19,0x50d(%rax)
  8041605e3f:	c6 80 13 03 00 00 9a 	movb   $0x9a,0x313(%rax)
  8041605e46:	c6 80 0f 02 00 00 74 	movb   $0x74,0x20f(%rax)
  8041605e4d:	c6 80 12 03 00 00 2d 	movb   $0x2d,0x312(%rax)
  8041605e54:	c6 80 34 06 00 00 3b 	movb   $0x3b,0x634(%rax)
  8041605e5b:	c6 80 09 03 00 00 98 	movb   $0x98,0x309(%rax)
  8041605e62:	c6 80 03 04 00 00 4e 	movb   $0x4e,0x403(%rax)
  8041605e69:	c6 80 18 03 00 00 ff 	movb   $0xff,0x318(%rax)
  8041605e70:	c6 80 05 04 00 00 28 	movb   $0x28,0x405(%rax)
  8041605e77:	c6 80 3d 06 00 00 ba 	movb   $0xba,0x63d(%rax)
  8041605e7e:	c6 80 21 06 00 00 26 	movb   $0x26,0x621(%rax)
  8041605e85:	c6 80 04 02 00 00 85 	movb   $0x85,0x204(%rax)
  8041605e8c:	c6 80 0c 05 00 00 25 	movb   $0x25,0x50c(%rax)
  8041605e93:	c6 80 44 06 00 00 0b 	movb   $0xb,0x644(%rax)
  8041605e9a:	c6 80 1a 05 00 00 5f 	movb   $0x5f,0x51a(%rax)
  8041605ea1:	c6 80 0b 02 00 00 ff 	movb   $0xff,0x20b(%rax)
  8041605ea8:	c6 80 12 04 00 00 00 	movb   $0x0,0x412(%rax)
  8041605eaf:	c6 80 19 04 00 00 39 	movb   $0x39,0x419(%rax)
  8041605eb6:	c6 80 48 06 00 00 60 	movb   $0x60,0x648(%rax)
  8041605ebd:	c6 80 0e 01 00 00 ca 	movb   $0xca,0x10e(%rax)
  8041605ec4:	c6 80 1f 01 00 00 b8 	movb   $0xb8,0x11f(%rax)
  8041605ecb:	c6 80 16 01 00 00 3f 	movb   $0x3f,0x116(%rax)
  8041605ed2:	c6 80 0d 04 00 00 50 	movb   $0x50,0x40d(%rax)
  8041605ed9:	c6 80 1d 03 00 00 96 	movb   $0x96,0x31d(%rax)
  8041605ee0:	c6 80 1c 06 00 00 29 	movb   $0x29,0x61c(%rax)
  8041605ee7:	c6 80 21 05 00 00 4c 	movb   $0x4c,0x521(%rax)
  8041605eee:	c6 80 45 06 00 00 ec 	movb   $0xec,0x645(%rax)
  8041605ef5:	c6 80 01 03 00 00 e0 	movb   $0xe0,0x301(%rax)
  8041605efc:	c6 80 14 03 00 00 0d 	movb   $0xd,0x314(%rax)
  8041605f03:	c6 80 29 06 00 00 bc 	movb   $0xbc,0x629(%rax)
  8041605f0a:	c6 80 0d 03 00 00 71 	movb   $0x71,0x30d(%rax)
  8041605f11:	c6 80 20 05 00 00 7f 	movb   $0x7f,0x520(%rax)
  8041605f18:	c6 80 00 02 00 00 2c 	movb   $0x2c,0x200(%rax)
  8041605f1f:	c6 80 1b 03 00 00 6b 	movb   $0x6b,0x31b(%rax)
  8041605f26:	c6 80 00 06 00 00 28 	movb   $0x28,0x600(%rax)
  8041605f2d:	c6 80 1b 05 00 00 18 	movb   $0x18,0x51b(%rax)
  8041605f34:	c6 80 01 02 00 00 ec 	movb   $0xec,0x201(%rax)
  8041605f3b:	c6 80 05 06 00 00 43 	movb   $0x43,0x605(%rax)
  8041605f42:	c6 80 1a 04 00 00 56 	movb   $0x56,0x41a(%rax)
  8041605f49:	c6 80 5c 06 00 00 3d 	movb   $0x3d,0x65c(%rax)
  8041605f50:	c6 80 37 06 00 00 3e 	movb   $0x3e,0x637(%rax)
  8041605f57:	c6 80 2e 01 00 00 53 	movb   $0x53,0x12e(%rax)
  8041605f5e:	c6 80 40 06 00 00 c9 	movb   $0xc9,0x640(%rax)
  8041605f65:	c6 80 14 05 00 00 28 	movb   $0x28,0x514(%rax)
  8041605f6c:	c6 80 01 06 00 00 e0 	movb   $0xe0,0x601(%rax)
  8041605f73:	c6 80 0a 02 00 00 77 	movb   $0x77,0x20a(%rax)
  8041605f7a:	c6 80 3c 03 00 00 70 	movb   $0x70,0x33c(%rax)
  8041605f81:	c6 40 04 c3          	movb   $0xc3,0x4(%rax)
  8041605f85:	c6 80 0f 04 00 00 68 	movb   $0x68,0x40f(%rax)
  8041605f8c:	c6 80 1e 02 00 00 78 	movb   $0x78,0x21e(%rax)
  8041605f93:	c6 80 0d 01 00 00 41 	movb   $0x41,0x10d(%rax)
  8041605f9a:	c6 80 18 01 00 00 90 	movb   $0x90,0x118(%rax)
  8041605fa1:	c6 80 22 06 00 00 b5 	movb   $0xb5,0x622(%rax)
  8041605fa8:	c6 80 16 06 00 00 00 	movb   $0x0,0x616(%rax)
  8041605faf:	c6 80 05 05 00 00 2a 	movb   $0x2a,0x505(%rax)
  8041605fb6:	c6 80 5d 06 00 00 06 	movb   $0x6,0x65d(%rax)
  8041605fbd:	c6 80 1c 01 00 00 5a 	movb   $0x5a,0x11c(%rax)
  8041605fc4:	c6 80 05 02 00 00 24 	movb   $0x24,0x205(%rax)
  8041605fcb:	c6 40 0a 0a          	movb   $0xa,0xa(%rax)
  8041605fcf:	c6 80 18 05 00 00 c8 	movb   $0xc8,0x518(%rax)
  8041605fd6:	c6 80 18 06 00 00 fa 	movb   $0xfa,0x618(%rax)
  8041605fdd:	c6 80 13 02 00 00 a7 	movb   $0xa7,0x213(%rax)
  8041605fe4:	c6 80 61 06 00 00 5b 	movb   $0x5b,0x661(%rax)
  8041605feb:	c6 40 09 bc          	movb   $0xbc,0x9(%rax)
  8041605fef:	c6 80 65 06 00 00 ad 	movb   $0xad,0x665(%rax)
  8041605ff6:	c6 80 0c 02 00 00 7c 	movb   $0x7c,0x20c(%rax)
  8041605ffd:	c6 80 4b 06 00 00 79 	movb   $0x79,0x64b(%rax)
  8041606004:	c6 80 29 05 00 00 b5 	movb   $0xb5,0x529(%rax)
  804160600b:	c6 80 12 06 00 00 25 	movb   $0x25,0x612(%rax)
  8041606012:	c6 40 01 fb          	movb   $0xfb,0x1(%rax)
  8041606016:	c6 80 06 01 00 00 1f 	movb   $0x1f,0x106(%rax)
  804160601d:	c6 80 01 01 00 00 e1 	movb   $0xe1,0x101(%rax)
  8041606024:	c6 80 15 02 00 00 e7 	movb   $0xe7,0x215(%rax)
  804160602b:	c6 80 11 03 00 00 37 	movb   $0x37,0x311(%rax)
  8041606032:	c6 80 10 06 00 00 37 	movb   $0x37,0x610(%rax)
  8041606039:	c6 80 3a 03 00 00 4e 	movb   $0x4e,0x33a(%rax)
  8041606040:	c6 40 03 54          	movb   $0x54,0x3(%rax)
  8041606044:	c6 80 0b 03 00 00 98 	movb   $0x98,0x30b(%rax)
  804160604b:	c6 80 4c 06 00 00 45 	movb   $0x45,0x64c(%rax)
  8041606052:	c6 80 5f 06 00 00 69 	movb   $0x69,0x65f(%rax)
  8041606059:	c6 80 2f 03 00 00 4a 	movb   $0x4a,0x32f(%rax)
  8041606060:	c6 80 15 06 00 00 8e 	movb   $0x8e,0x615(%rax)
  8041606067:	c6 80 04 05 00 00 df 	movb   $0xdf,0x504(%rax)
  804160606e:	c6 80 26 06 00 00 64 	movb   $0x64,0x626(%rax)
  8041606075:	c6 80 03 01 00 00 07 	movb   $0x7,0x103(%rax)
  804160607c:	c6 80 13 01 00 00 fd 	movb   $0xfd,0x113(%rax)
  8041606083:	c6 80 02 04 00 00 69 	movb   $0x69,0x402(%rax)
  804160608a:	c6 80 0e 03 00 00 fa 	movb   $0xfa,0x30e(%rax)
  8041606091:	c6 80 0b 04 00 00 ac 	movb   $0xac,0x40b(%rax)
  8041606098:	c6 80 23 03 00 00 0e 	movb   $0xe,0x323(%rax)
  804160609f:	c6 80 1b 06 00 00 72 	movb   $0x72,0x61b(%rax)
  80416060a6:	c6 80 27 02 00 00 a9 	movb   $0xa9,0x227(%rax)
  80416060ad:	c6 80 22 03 00 00 bf 	movb   $0xbf,0x322(%rax)
  80416060b4:	c6 80 35 06 00 00 04 	movb   $0x4,0x635(%rax)
  80416060bb:	c6 80 00 05 00 00 2a 	movb   $0x2a,0x500(%rax)
  80416060c2:	c6 80 0a 04 00 00 60 	movb   $0x60,0x40a(%rax)
  80416060c9:	c6 80 0f 05 00 00 6f 	movb   $0x6f,0x50f(%rax)
  80416060d0:	c6 80 0c 03 00 00 03 	movb   $0x3,0x30c(%rax)
  80416060d7:	c6 80 06 06 00 00 62 	movb   $0x62,0x606(%rax)
  80416060de:	c6 80 0a 03 00 00 10 	movb   $0x10,0x30a(%rax)
  80416060e5:	c6 80 25 01 00 00 1f 	movb   $0x1f,0x125(%rax)
  80416060ec:	c6 80 1e 06 00 00 58 	movb   $0x58,0x61e(%rax)
  80416060f3:	c6 80 2d 01 00 00 72 	movb   $0x72,0x12d(%rax)
  80416060fa:	c6 80 52 06 00 00 3a 	movb   $0x3a,0x652(%rax)
  8041606101:	c6 80 11 06 00 00 6c 	movb   $0x6c,0x611(%rax)
  8041606108:	c6 80 5a 06 00 00 63 	movb   $0x63,0x65a(%rax)
  804160610f:	c6 80 16 03 00 00 58 	movb   $0x58,0x316(%rax)
  8041606116:	c6 80 59 06 00 00 e9 	movb   $0xe9,0x659(%rax)
  804160611d:	c6 80 2d 06 00 00 69 	movb   $0x69,0x62d(%rax)
  8041606124:	c6 80 37 03 00 00 2f 	movb   $0x2f,0x337(%rax)
  804160612b:	c6 80 06 05 00 00 17 	movb   $0x17,0x506(%rax)
  8041606132:	c6 80 28 02 00 00 23 	movb   $0x23,0x228(%rax)
  8041606139:	c6 80 23 01 00 00 21 	movb   $0x21,0x123(%rax)
  8041606140:	c6 80 4a 06 00 00 d9 	movb   $0xd9,0x64a(%rax)
  8041606147:	c6 80 0d 02 00 00 41 	movb   $0x41,0x20d(%rax)
  804160614e:	c6 80 04 06 00 00 cf 	movb   $0xcf,0x604(%rax)
  8041606155:	c6 80 14 04 00 00 7b 	movb   $0x7b,0x414(%rax)
  804160615c:	c6 80 1e 01 00 00 63 	movb   $0x63,0x11e(%rax)
  8041606163:	c6 80 1c 05 00 00 4f 	movb   $0x4f,0x51c(%rax)
  804160616a:	c6 80 2f 06 00 00 1b 	movb   $0x1b,0x62f(%rax)
  8041606171:	c6 80 21 01 00 00 1c 	movb   $0x1c,0x121(%rax)
  8041606178:	c6 80 25 02 00 00 43 	movb   $0x43,0x225(%rax)
  804160617f:	c6 40 0b d7          	movb   $0xd7,0xb(%rax)
  8041606183:	c6 80 19 05 00 00 31 	movb   $0x31,0x519(%rax)
  804160618a:	c6 80 24 05 00 00 1a 	movb   $0x1a,0x524(%rax)
  8041606191:	c6 40 05 64          	movb   $0x64,0x5(%rax)
  8041606195:	c6 80 3b 06 00 00 eb 	movb   $0xeb,0x63b(%rax)
  804160619c:	c6 80 24 02 00 00 16 	movb   $0x16,0x224(%rax)
  80416061a3:	c6 80 2c 01 00 00 d3 	movb   $0xd3,0x12c(%rax)
  80416061aa:	c6 80 17 03 00 00 7e 	movb   $0x7e,0x317(%rax)
  80416061b1:	c6 80 39 06 00 00 08 	movb   $0x8,0x639(%rax)
  80416061b8:	c6 80 1c 03 00 00 22 	movb   $0x22,0x31c(%rax)
  80416061bf:	c6 80 02 03 00 00 7f 	movb   $0x7f,0x302(%rax)
  80416061c6:	c6 80 2f 01 00 00 15 	movb   $0x15,0x12f(%rax)
  80416061cd:	c6 80 03 05 00 00 4c 	movb   $0x4c,0x503(%rax)
  80416061d4:	c6 80 03 06 00 00 08 	movb   $0x8,0x603(%rax)
  80416061db:	c6 80 13 06 00 00 87 	movb   $0x87,0x613(%rax)
  80416061e2:	c6 80 30 06 00 00 01 	movb   $0x1,0x630(%rax)
  80416061e9:	c6 80 31 06 00 00 a7 	movb   $0xa7,0x631(%rax)
  80416061f0:	c6 80 0e 04 00 00 d6 	movb   $0xd6,0x40e(%rax)
  80416061f7:	c6 80 09 04 00 00 eb 	movb   $0xeb,0x409(%rax)
  80416061fe:	c6 80 13 04 00 00 be 	movb   $0xbe,0x413(%rax)
  8041606205:	c6 80 14 01 00 00 34 	movb   $0x34,0x114(%rax)
  804160620c:	c6 80 10 04 00 00 43 	movb   $0x43,0x410(%rax)
  8041606213:	c6 80 17 01 00 00 02 	movb   $0x2,0x117(%rax)
  804160621a:	c6 80 63 06 00 00 a3 	movb   $0xa3,0x663(%rax)
  8041606221:	c6 40 07 04          	movb   $0x4,0x7(%rax)
  8041606225:	c6 80 06 02 00 00 4a 	movb   $0x4a,0x206(%rax)
  804160622c:	c6 80 30 01 00 00 4c 	movb   $0x4c,0x130(%rax)
  8041606233:	c6 80 00 03 00 00 41 	movb   $0x41,0x300(%rax)
  804160623a:	c6 80 33 06 00 00 a4 	movb   $0xa4,0x633(%rax)
  8041606241:	c6 80 09 02 00 00 fe 	movb   $0xfe,0x209(%rax)
  8041606248:	c6 80 23 05 00 00 74 	movb   $0x74,0x523(%rax)
  804160624f:	c6 80 3e 06 00 00 60 	movb   $0x60,0x63e(%rax)
  8041606256:	c6 80 0e 06 00 00 ac 	movb   $0xac,0x60e(%rax)
  804160625d:	c6 80 64 06 00 00 22 	movb   $0x22,0x664(%rax)
  8041606264:	c6 80 33 03 00 00 a9 	movb   $0xa9,0x333(%rax)
  804160626b:	c6 80 1f 06 00 00 9d 	movb   $0x9d,0x61f(%rax)
  8041606272:	c6 80 56 06 00 00 5f 	movb   $0x5f,0x656(%rax)
  8041606279:	c6 80 0b 05 00 00 be 	movb   $0xbe,0x50b(%rax)
  8041606280:	c6 80 01 04 00 00 fb 	movb   $0xfb,0x401(%rax)
  8041606287:	c6 80 26 02 00 00 17 	movb   $0x17,0x226(%rax)
  804160628e:	c6 80 26 03 00 00 3c 	movb   $0x3c,0x326(%rax)
  8041606295:	c6 80 62 06 00 00 05 	movb   $0x5,0x662(%rax)
  804160629c:	c6 80 08 02 00 00 55 	movb   $0x55,0x208(%rax)
  80416062a3:	c6 80 07 04 00 00 57 	movb   $0x57,0x407(%rax)
  80416062aa:	c6 80 22 02 00 00 c2 	movb   $0xc2,0x222(%rax)
  80416062b1:	c6 80 15 04 00 00 be 	movb   $0xbe,0x415(%rax)
  80416062b8:	c6 40 10 69          	movb   $0x69,0x10(%rax)
  80416062bc:	c6 80 2e 06 00 00 4a 	movb   $0x4a,0x62e(%rax)
  80416062c3:	c6 80 21 02 00 00 51 	movb   $0x51,0x221(%rax)
  80416062ca:	5d                   	pop    %rbp
  80416062cb:	c3                   	retq   

00000080416062cc <xYlCRKBrN_5ra8nhM2pVAIMI2wu2qivHg9cqCRZTPZu3LSzshpN0gZqZ0cMtiB6lc9rOAxAefhf05d0hdKErasIU4XZCxBunDVg>:
  80416062cc:	55                   	push   %rbp
  80416062cd:	48 89 e5             	mov    %rsp,%rbp
  80416062d0:	53                   	push   %rbx
  80416062d1:	48 83 ec 08          	sub    $0x8,%rsp
  80416062d5:	89 fb                	mov    %edi,%ebx
  80416062d7:	48 b8 47 59 60 41 80 	movabs $0x8041605947,%rax
  80416062de:	00 00 00 
  80416062e1:	ff d0                	callq  *%rax
  80416062e3:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  80416062e8:	89 d8                	mov    %ebx,%eax
  80416062ea:	f7 e2                	mul    %edx
  80416062ec:	c1 ea 02             	shr    $0x2,%edx
  80416062ef:	8d 04 52             	lea    (%rdx,%rdx,2),%eax
  80416062f2:	01 c0                	add    %eax,%eax
  80416062f4:	29 c3                	sub    %eax,%ebx
  80416062f6:	48 c1 e3 08          	shl    $0x8,%rbx
  80416062fa:	48 b8 e0 63 62 41 80 	movabs $0x80416263e0,%rax
  8041606301:	00 00 00 
  8041606304:	48 01 c3             	add    %rax,%rbx
  8041606307:	48 89 df             	mov    %rbx,%rdi
  804160630a:	48 b8 bb 58 60 41 80 	movabs $0x80416058bb,%rax
  8041606311:	00 00 00 
  8041606314:	ff d0                	callq  *%rax
  8041606316:	48 89 da             	mov    %rbx,%rdx
  8041606319:	48 be d8 71 60 41 80 	movabs $0x80416071d8,%rsi
  8041606320:	00 00 00 
  8041606323:	48 bf 40 72 60 41 80 	movabs $0x8041607240,%rdi
  804160632a:	00 00 00 
  804160632d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041606332:	48 b9 49 44 60 41 80 	movabs $0x8041604449,%rcx
  8041606339:	00 00 00 
  804160633c:	ff d1                	callq  *%rcx
  804160633e:	48 83 c4 08          	add    $0x8,%rsp
  8041606342:	5b                   	pop    %rbx
  8041606343:	5d                   	pop    %rbp
  8041606344:	c3                   	retq   

0000008041606345 <nksMRzbqweMKc>:
  8041606345:	55                   	push   %rbp
  8041606346:	48 89 e5             	mov    %rsp,%rbp
  8041606349:	48 bf 47 72 60 41 80 	movabs $0x8041607247,%rdi
  8041606350:	00 00 00 
  8041606353:	b8 00 00 00 00       	mov    $0x0,%eax
  8041606358:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  804160635f:	00 00 00 
  8041606362:	ff d2                	callq  *%rdx
  8041606364:	5d                   	pop    %rbp
  8041606365:	c3                   	retq   

0000008041606366 <nksMRzbqweMKcOn9>:
  8041606366:	55                   	push   %rbp
  8041606367:	48 89 e5             	mov    %rsp,%rbp
  804160636a:	48 bf 56 72 60 41 80 	movabs $0x8041607256,%rdi
  8041606371:	00 00 00 
  8041606374:	b8 00 00 00 00       	mov    $0x0,%eax
  8041606379:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  8041606380:	00 00 00 
  8041606383:	ff d2                	callq  *%rdx
  8041606385:	5d                   	pop    %rbp
  8041606386:	c3                   	retq   

0000008041606387 <nksMRzbqweMKce_cLkcUmgLOn9>:
  8041606387:	55                   	push   %rbp
  8041606388:	48 89 e5             	mov    %rsp,%rbp
  804160638b:	48 bf 65 72 60 41 80 	movabs $0x8041607265,%rdi
  8041606392:	00 00 00 
  8041606395:	b8 00 00 00 00       	mov    $0x0,%eax
  804160639a:	48 ba 49 44 60 41 80 	movabs $0x8041604449,%rdx
  80416063a1:	00 00 00 
  80416063a4:	ff d2                	callq  *%rdx
  80416063a6:	5d                   	pop    %rbp
  80416063a7:	c3                   	retq   
