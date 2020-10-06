
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
  8041600000:	48 89 0d f9 5f 01 00 	mov    %rcx,0x15ff9(%rip)        # 8041616000 <bootstacktop>

  # Set the stack pointer.
  leaq bootstacktop(%rip),%rsp
  8041600007:	48 8d 25 f2 5f 01 00 	lea    0x15ff2(%rip),%rsp        # 8041616000 <bootstacktop>

  # Clear the frame pointer register (RBP)
  # so that once we get into debugging C code,
  # stack backtraces will be terminated properly.
  xorq %rbp, %rbp      # nuke frame pointer
  804160000e:	48 31 ed             	xor    %rbp,%rbp

  # now to C code
  call i386_init
  8041600011:	e8 e9 01 00 00       	callq  80416001ff <i386_init>

0000008041600016 <spin>:

  # Should never get here, but in case we do, just spin.
spin:  jmp  spin
  8041600016:	eb fe                	jmp    8041600016 <spin>

0000008041600018 <alloc_pde_early_boot>:

#include <kern/monitor.h>
#include <kern/console.h>

pde_t *
alloc_pde_early_boot(void) {
  8041600018:	55                   	push   %rbp
  8041600019:	48 89 e5             	mov    %rsp,%rbp
  //Assume pde1, pde2 is already used.
  extern uintptr_t pdefreestart, pdefreeend;
  pde_t *ret;
  static uintptr_t pdefree = (uintptr_t)&pdefreestart;

  if (pdefree >= (uintptr_t)&pdefreeend)
  804160001c:	48 b8 08 60 61 41 80 	movabs $0x8041616008,%rax
  8041600023:	00 00 00 
  8041600026:	48 8b 10             	mov    (%rax),%rdx
  8041600029:	48 b8 00 c0 50 01 00 	movabs $0x150c000,%rax
  8041600030:	00 00 00 
  8041600033:	48 39 c2             	cmp    %rax,%rdx
  8041600036:	73 1c                	jae    8041600054 <alloc_pde_early_boot+0x3c>
    return NULL;

  ret = (pde_t *)pdefree;
  8041600038:	48 89 d1             	mov    %rdx,%rcx
  pdefree += PGSIZE;
  804160003b:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
  8041600042:	48 89 d0             	mov    %rdx,%rax
  8041600045:	48 a3 08 60 61 41 80 	movabs %rax,0x8041616008
  804160004c:	00 00 00 
  return ret;
}
  804160004f:	48 89 c8             	mov    %rcx,%rax
  8041600052:	5d                   	pop    %rbp
  8041600053:	c3                   	retq   
    return NULL;
  8041600054:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041600059:	eb f4                	jmp    804160004f <alloc_pde_early_boot+0x37>

000000804160005b <map_addr_early_boot>:

void
map_addr_early_boot(uintptr_t addr, uintptr_t addr_phys, size_t sz) {
  804160005b:	55                   	push   %rbp
  804160005c:	48 89 e5             	mov    %rsp,%rbp
  804160005f:	41 57                	push   %r15
  8041600061:	41 56                	push   %r14
  8041600063:	41 55                	push   %r13
  8041600065:	41 54                	push   %r12
  8041600067:	53                   	push   %rbx
  8041600068:	48 83 ec 10          	sub    $0x10,%rsp
  pml4e_t *pml4 = &pml4phys;
  pdpe_t *pdpt;
  pde_t *pde;

  uintptr_t addr_curr, addr_curr_phys, addr_end;
  addr_curr      = ROUNDDOWN(addr, PTSIZE);
  804160006c:	49 89 ff             	mov    %rdi,%r15
  804160006f:	49 81 e7 00 00 e0 ff 	and    $0xffffffffffe00000,%r15
  addr_curr_phys = ROUNDDOWN(addr_phys, PTSIZE);
  8041600076:	48 81 e6 00 00 e0 ff 	and    $0xffffffffffe00000,%rsi
  804160007d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  addr_end       = ROUNDUP(addr + sz, PTSIZE);
  8041600081:	4c 8d b4 17 ff ff 1f 	lea    0x1fffff(%rdi,%rdx,1),%r14
  8041600088:	00 
  8041600089:	49 81 e6 00 00 e0 ff 	and    $0xffffffffffe00000,%r14

  pdpt = (pdpe_t *)PTE_ADDR(pml4[PML4(addr_curr)]);
  8041600090:	48 c1 ef 24          	shr    $0x24,%rdi
  8041600094:	81 e7 f8 0f 00 00    	and    $0xff8,%edi
  804160009a:	48 b8 00 10 50 01 00 	movabs $0x1501000,%rax
  80416000a1:	00 00 00 
  80416000a4:	48 8b 04 38          	mov    (%rax,%rdi,1),%rax
  80416000a8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80416000ae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
  80416000b2:	4d 39 fe             	cmp    %r15,%r14
  80416000b5:	76 67                	jbe    804160011e <map_addr_early_boot+0xc3>
  addr_curr      = ROUNDDOWN(addr, PTSIZE);
  80416000b7:	4d 89 fc             	mov    %r15,%r12
  80416000ba:	eb 24                	jmp    80416000e0 <map_addr_early_boot+0x85>
    pde = (pde_t *)PTE_ADDR(pdpt[PDPE(addr_curr)]);
    if (!pde) {
      pde                   = alloc_pde_early_boot();
      pdpt[PDPE(addr_curr)] = ((uintptr_t)pde) | PTE_P | PTE_W;
    }
    pde[PDX(addr_curr)] = addr_curr_phys | PTE_P | PTE_W | PTE_MBZ;
  80416000bc:	4c 89 e2             	mov    %r12,%rdx
  80416000bf:	48 c1 ea 15          	shr    $0x15,%rdx
  80416000c3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  80416000c9:	49 81 cd 83 01 00 00 	or     $0x183,%r13
  80416000d0:	4c 89 2c d0          	mov    %r13,(%rax,%rdx,8)
  for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
  80416000d4:	49 81 c4 00 00 20 00 	add    $0x200000,%r12
  80416000db:	4d 39 e6             	cmp    %r12,%r14
  80416000de:	76 3e                	jbe    804160011e <map_addr_early_boot+0xc3>
  80416000e0:	4c 8b 6d d0          	mov    -0x30(%rbp),%r13
  80416000e4:	4d 29 fd             	sub    %r15,%r13
  80416000e7:	4d 01 e5             	add    %r12,%r13
    pde = (pde_t *)PTE_ADDR(pdpt[PDPE(addr_curr)]);
  80416000ea:	4c 89 e3             	mov    %r12,%rbx
  80416000ed:	48 c1 eb 1b          	shr    $0x1b,%rbx
  80416000f1:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
  80416000f7:	48 03 5d c8          	add    -0x38(%rbp),%rbx
    if (!pde) {
  80416000fb:	48 8b 03             	mov    (%rbx),%rax
  80416000fe:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041600104:	75 b6                	jne    80416000bc <map_addr_early_boot+0x61>
      pde                   = alloc_pde_early_boot();
  8041600106:	48 b8 18 00 60 41 80 	movabs $0x8041600018,%rax
  804160010d:	00 00 00 
  8041600110:	ff d0                	callq  *%rax
      pdpt[PDPE(addr_curr)] = ((uintptr_t)pde) | PTE_P | PTE_W;
  8041600112:	48 89 c2             	mov    %rax,%rdx
  8041600115:	48 83 ca 03          	or     $0x3,%rdx
  8041600119:	48 89 13             	mov    %rdx,(%rbx)
  804160011c:	eb 9e                	jmp    80416000bc <map_addr_early_boot+0x61>
  }
}
  804160011e:	48 83 c4 10          	add    $0x10,%rsp
  8041600122:	5b                   	pop    %rbx
  8041600123:	41 5c                	pop    %r12
  8041600125:	41 5d                	pop    %r13
  8041600127:	41 5e                	pop    %r14
  8041600129:	41 5f                	pop    %r15
  804160012b:	5d                   	pop    %rbp
  804160012c:	c3                   	retq   

000000804160012d <early_boot_pml4_init>:
// Additionally maps pml4 memory so that we dont get memory errors on accessing
// uefi_lp, MemMap, KASAN functions.
void
early_boot_pml4_init(void) {
  804160012d:	55                   	push   %rbp
  804160012e:	48 89 e5             	mov    %rsp,%rbp
  8041600131:	41 54                	push   %r12
  8041600133:	53                   	push   %rbx

  map_addr_early_boot((uintptr_t)uefi_lp, (uintptr_t)uefi_lp, sizeof(LOADER_PARAMS));
  8041600134:	49 bc 00 60 61 41 80 	movabs $0x8041616000,%r12
  804160013b:	00 00 00 
  804160013e:	49 8b 3c 24          	mov    (%r12),%rdi
  8041600142:	ba c8 00 00 00       	mov    $0xc8,%edx
  8041600147:	48 89 fe             	mov    %rdi,%rsi
  804160014a:	48 bb 5b 00 60 41 80 	movabs $0x804160005b,%rbx
  8041600151:	00 00 00 
  8041600154:	ff d3                	callq  *%rbx
  map_addr_early_boot((uintptr_t)uefi_lp->MemoryMap, (uintptr_t)uefi_lp->MemoryMap, uefi_lp->MemoryMapSize);
  8041600156:	49 8b 04 24          	mov    (%r12),%rax
  804160015a:	48 8b 78 28          	mov    0x28(%rax),%rdi
  804160015e:	48 8b 50 38          	mov    0x38(%rax),%rdx
  8041600162:	48 89 fe             	mov    %rdi,%rsi
  8041600165:	ff d3                	callq  *%rbx

#ifdef SANITIZE_SHADOW_BASE
  map_addr_early_boot(SANITIZE_SHADOW_BASE, SANITIZE_SHADOW_BASE - KERNBASE, SANITIZE_SHADOW_SIZE);
#endif

  map_addr_early_boot(FBUFFBASE, uefi_lp->FrameBufferBase, uefi_lp->FrameBufferSize);
  8041600167:	49 8b 04 24          	mov    (%r12),%rax
  804160016b:	8b 50 48             	mov    0x48(%rax),%edx
  804160016e:	48 8b 70 40          	mov    0x40(%rax),%rsi
  8041600172:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600179:	00 00 00 
  804160017c:	ff d3                	callq  *%rbx
}
  804160017e:	5b                   	pop    %rbx
  804160017f:	41 5c                	pop    %r12
  8041600181:	5d                   	pop    %rbp
  8041600182:	c3                   	retq   

0000008041600183 <test_backtrace>:

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x) {
  8041600183:	55                   	push   %rbp
  8041600184:	48 89 e5             	mov    %rsp,%rbp
  8041600187:	53                   	push   %rbx
  8041600188:	48 83 ec 08          	sub    $0x8,%rsp
  804160018c:	89 fb                	mov    %edi,%ebx
  cprintf("entering test_backtrace %d\n", x);
  804160018e:	89 fe                	mov    %edi,%esi
  8041600190:	48 bf 60 4d 60 41 80 	movabs $0x8041604d60,%rdi
  8041600197:	00 00 00 
  804160019a:	b8 00 00 00 00       	mov    $0x0,%eax
  804160019f:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416001a6:	00 00 00 
  80416001a9:	ff d2                	callq  *%rdx
  if (x > 0)
  80416001ab:	85 db                	test   %ebx,%ebx
  80416001ad:	7f 3f                	jg     80416001ee <test_backtrace+0x6b>
    test_backtrace(x - 1);
  else
    mon_backtrace(0, 0, 0);
  80416001af:	ba 00 00 00 00       	mov    $0x0,%edx
  80416001b4:	be 00 00 00 00       	mov    $0x0,%esi
  80416001b9:	bf 00 00 00 00       	mov    $0x0,%edi
  80416001be:	48 b8 2a 38 60 41 80 	movabs $0x804160382a,%rax
  80416001c5:	00 00 00 
  80416001c8:	ff d0                	callq  *%rax
  cprintf("leaving test_backtrace %d\n", x);
  80416001ca:	89 de                	mov    %ebx,%esi
  80416001cc:	48 bf 7c 4d 60 41 80 	movabs $0x8041604d7c,%rdi
  80416001d3:	00 00 00 
  80416001d6:	b8 00 00 00 00       	mov    $0x0,%eax
  80416001db:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416001e2:	00 00 00 
  80416001e5:	ff d2                	callq  *%rdx
}
  80416001e7:	48 83 c4 08          	add    $0x8,%rsp
  80416001eb:	5b                   	pop    %rbx
  80416001ec:	5d                   	pop    %rbp
  80416001ed:	c3                   	retq   
    test_backtrace(x - 1);
  80416001ee:	8d 7b ff             	lea    -0x1(%rbx),%edi
  80416001f1:	48 b8 83 01 60 41 80 	movabs $0x8041600183,%rax
  80416001f8:	00 00 00 
  80416001fb:	ff d0                	callq  *%rax
  80416001fd:	eb cb                	jmp    80416001ca <test_backtrace+0x47>

00000080416001ff <i386_init>:

void
i386_init(void) {
  80416001ff:	55                   	push   %rbp
  8041600200:	48 89 e5             	mov    %rsp,%rbp
  8041600203:	41 54                	push   %r12
  8041600205:	53                   	push   %rbx
  extern char end[];

  early_boot_pml4_init();
  8041600206:	48 b8 2d 01 60 41 80 	movabs $0x804160012d,%rax
  804160020d:	00 00 00 
  8041600210:	ff d0                	callq  *%rax

  // Initialize the console.
  // Can't call cprintf until after we do this!
  cons_init();
  8041600212:	48 b8 ce 0a 60 41 80 	movabs $0x8041600ace,%rax
  8041600219:	00 00 00 
  804160021c:	ff d0                	callq  *%rax

  cprintf("6828 decimal is %o octal!\n", 6828);
  804160021e:	be ac 1a 00 00       	mov    $0x1aac,%esi
  8041600223:	48 bf 97 4d 60 41 80 	movabs $0x8041604d97,%rdi
  804160022a:	00 00 00 
  804160022d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600232:	48 bb 0d 3b 60 41 80 	movabs $0x8041603b0d,%rbx
  8041600239:	00 00 00 
  804160023c:	ff d3                	callq  *%rbx
  cprintf("END: %p\n", end);
  804160023e:	48 be 00 70 61 41 80 	movabs $0x8041617000,%rsi
  8041600245:	00 00 00 
  8041600248:	48 bf b2 4d 60 41 80 	movabs $0x8041604db2,%rdi
  804160024f:	00 00 00 
  8041600252:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600257:	ff d3                	callq  *%rbx
  // Perform global constructor initialisation (e.g. asan)
  // This must be done as early as possible
  extern void (*__ctors_start)();
  extern void (*__ctors_end)();
  void (**ctor)() = &__ctors_start;
  while (ctor < &__ctors_end) {
  8041600259:	48 ba 20 67 61 41 80 	movabs $0x8041616720,%rdx
  8041600260:	00 00 00 
  8041600263:	48 b8 20 67 61 41 80 	movabs $0x8041616720,%rax
  804160026a:	00 00 00 
  804160026d:	48 39 c2             	cmp    %rax,%rdx
  8041600270:	73 28                	jae    804160029a <i386_init+0x9b>
  8041600272:	48 8d 40 07          	lea    0x7(%rax),%rax
  8041600276:	48 8d 52 08          	lea    0x8(%rdx),%rdx
  804160027a:	48 29 d0             	sub    %rdx,%rax
  804160027d:	48 c1 e8 03          	shr    $0x3,%rax
  8041600281:	48 8d 5a f8          	lea    -0x8(%rdx),%rbx
  8041600285:	4c 8d 64 c3 08       	lea    0x8(%rbx,%rax,8),%r12
    (*ctor)();
  804160028a:	b8 00 00 00 00       	mov    $0x0,%eax
  804160028f:	ff 13                	callq  *(%rbx)
    ctor++;
  8041600291:	48 83 c3 08          	add    $0x8,%rbx
  while (ctor < &__ctors_end) {
  8041600295:	4c 39 e3             	cmp    %r12,%rbx
  8041600298:	75 f0                	jne    804160028a <i386_init+0x8b>
  }

  // Framebuffer init should be done after memory init.
  fb_init();
  804160029a:	48 b8 c1 09 60 41 80 	movabs $0x80416009c1,%rax
  80416002a1:	00 00 00 
  80416002a4:	ff d0                	callq  *%rax
  cprintf("Framebuffer initialised\n");
  80416002a6:	48 bf bb 4d 60 41 80 	movabs $0x8041604dbb,%rdi
  80416002ad:	00 00 00 
  80416002b0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416002b5:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416002bc:	00 00 00 
  80416002bf:	ff d2                	callq  *%rdx

  // Test the stack backtrace function (lab 1 only)
  test_backtrace(5);
  80416002c1:	bf 05 00 00 00       	mov    $0x5,%edi
  80416002c6:	48 b8 83 01 60 41 80 	movabs $0x8041600183,%rax
  80416002cd:	00 00 00 
  80416002d0:	ff d0                	callq  *%rax

  // Drop into the kernel monitor.
  while (1)
    monitor(NULL);
  80416002d2:	48 bb f2 38 60 41 80 	movabs $0x80416038f2,%rbx
  80416002d9:	00 00 00 
  80416002dc:	bf 00 00 00 00       	mov    $0x0,%edi
  80416002e1:	ff d3                	callq  *%rbx
  80416002e3:	eb f7                	jmp    80416002dc <i386_init+0xdd>

00000080416002e5 <_panic>:
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80416002e5:	55                   	push   %rbp
  80416002e6:	48 89 e5             	mov    %rsp,%rbp
  80416002e9:	41 54                	push   %r12
  80416002eb:	53                   	push   %rbx
  80416002ec:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80416002f3:	49 89 d4             	mov    %rdx,%r12
  80416002f6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80416002fd:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8041600304:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804160030b:	84 c0                	test   %al,%al
  804160030d:	74 23                	je     8041600332 <_panic+0x4d>
  804160030f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8041600316:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804160031a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804160031e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8041600322:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8041600326:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804160032a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804160032e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  va_list ap;

  if (panicstr)
  8041600332:	48 b8 20 67 61 41 80 	movabs $0x8041616720,%rax
  8041600339:	00 00 00 
  804160033c:	48 83 38 00          	cmpq   $0x0,(%rax)
  8041600340:	74 13                	je     8041600355 <_panic+0x70>
  va_end(ap);

dead:
  /* break into the kernel monitor */
  while (1)
    monitor(NULL);
  8041600342:	48 bb f2 38 60 41 80 	movabs $0x80416038f2,%rbx
  8041600349:	00 00 00 
  804160034c:	bf 00 00 00 00       	mov    $0x0,%edi
  8041600351:	ff d3                	callq  *%rbx
  8041600353:	eb f7                	jmp    804160034c <_panic+0x67>
  panicstr = fmt;
  8041600355:	4c 89 e0             	mov    %r12,%rax
  8041600358:	48 a3 20 67 61 41 80 	movabs %rax,0x8041616720
  804160035f:	00 00 00 
  __asm __volatile("cli; cld");
  8041600362:	fa                   	cli    
  8041600363:	fc                   	cld    
  va_start(ap, fmt);
  8041600364:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804160036b:	00 00 00 
  804160036e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8041600375:	00 00 00 
  8041600378:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804160037c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8041600383:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804160038a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  cprintf("kernel panic at %s:%d: ", file, line);
  8041600391:	89 f2                	mov    %esi,%edx
  8041600393:	48 89 fe             	mov    %rdi,%rsi
  8041600396:	48 bf d4 4d 60 41 80 	movabs $0x8041604dd4,%rdi
  804160039d:	00 00 00 
  80416003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416003a5:	48 bb 0d 3b 60 41 80 	movabs $0x8041603b0d,%rbx
  80416003ac:	00 00 00 
  80416003af:	ff d3                	callq  *%rbx
  vcprintf(fmt, ap);
  80416003b1:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  80416003b8:	4c 89 e7             	mov    %r12,%rdi
  80416003bb:	48 b8 d9 3a 60 41 80 	movabs $0x8041603ad9,%rax
  80416003c2:	00 00 00 
  80416003c5:	ff d0                	callq  *%rax
  cprintf("\n");
  80416003c7:	48 bf 10 4e 60 41 80 	movabs $0x8041604e10,%rdi
  80416003ce:	00 00 00 
  80416003d1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416003d6:	ff d3                	callq  *%rbx
  80416003d8:	e9 65 ff ff ff       	jmpq   8041600342 <_panic+0x5d>

00000080416003dd <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...) {
  80416003dd:	55                   	push   %rbp
  80416003de:	48 89 e5             	mov    %rsp,%rbp
  80416003e1:	41 54                	push   %r12
  80416003e3:	53                   	push   %rbx
  80416003e4:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80416003eb:	49 89 d4             	mov    %rdx,%r12
  80416003ee:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80416003f5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80416003fc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8041600403:	84 c0                	test   %al,%al
  8041600405:	74 23                	je     804160042a <_warn+0x4d>
  8041600407:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804160040e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8041600412:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8041600416:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804160041a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804160041e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8041600422:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8041600426:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  va_list ap;

  va_start(ap, fmt);
  804160042a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8041600431:	00 00 00 
  8041600434:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804160043b:	00 00 00 
  804160043e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041600442:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8041600449:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8041600450:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  cprintf("kernel warning at %s:%d: ", file, line);
  8041600457:	89 f2                	mov    %esi,%edx
  8041600459:	48 89 fe             	mov    %rdi,%rsi
  804160045c:	48 bf ec 4d 60 41 80 	movabs $0x8041604dec,%rdi
  8041600463:	00 00 00 
  8041600466:	b8 00 00 00 00       	mov    $0x0,%eax
  804160046b:	48 bb 0d 3b 60 41 80 	movabs $0x8041603b0d,%rbx
  8041600472:	00 00 00 
  8041600475:	ff d3                	callq  *%rbx
  vcprintf(fmt, ap);
  8041600477:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  804160047e:	4c 89 e7             	mov    %r12,%rdi
  8041600481:	48 b8 d9 3a 60 41 80 	movabs $0x8041603ad9,%rax
  8041600488:	00 00 00 
  804160048b:	ff d0                	callq  *%rax
  cprintf("\n");
  804160048d:	48 bf 10 4e 60 41 80 	movabs $0x8041604e10,%rdi
  8041600494:	00 00 00 
  8041600497:	b8 00 00 00 00       	mov    $0x0,%eax
  804160049c:	ff d3                	callq  *%rbx
  va_end(ap);
}
  804160049e:	48 81 c4 d0 00 00 00 	add    $0xd0,%rsp
  80416004a5:	5b                   	pop    %rbx
  80416004a6:	41 5c                	pop    %r12
  80416004a8:	5d                   	pop    %rbp
  80416004a9:	c3                   	retq   

00000080416004aa <serial_proc_data>:
    }
  }
}

static int
serial_proc_data(void) {
  80416004aa:	55                   	push   %rbp
  80416004ab:	48 89 e5             	mov    %rsp,%rbp
}

static __inline uint8_t
inb(int port) {
  uint8_t data;
  __asm __volatile("inb %w1,%0"
  80416004ae:	ba fd 03 00 00       	mov    $0x3fd,%edx
  80416004b3:	ec                   	in     (%dx),%al
  if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
  80416004b4:	a8 01                	test   $0x1,%al
  80416004b6:	74 0b                	je     80416004c3 <serial_proc_data+0x19>
  80416004b8:	ba f8 03 00 00       	mov    $0x3f8,%edx
  80416004bd:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1 + COM_RX);
  80416004be:	0f b6 c0             	movzbl %al,%eax
}
  80416004c1:	5d                   	pop    %rbp
  80416004c2:	c3                   	retq   
    return -1;
  80416004c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80416004c8:	eb f7                	jmp    80416004c1 <serial_proc_data+0x17>

00000080416004ca <cons_intr>:
} cons;

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void)) {
  80416004ca:	55                   	push   %rbp
  80416004cb:	48 89 e5             	mov    %rsp,%rbp
  80416004ce:	41 54                	push   %r12
  80416004d0:	53                   	push   %rbx
  80416004d1:	49 89 fc             	mov    %rdi,%r12
  int c;

  while ((c = (*proc)()) != -1) {
    if (c == 0)
      continue;
    cons.buf[cons.wpos++] = c;
  80416004d4:	48 bb 60 67 61 41 80 	movabs $0x8041616760,%rbx
  80416004db:	00 00 00 
  while ((c = (*proc)()) != -1) {
  80416004de:	41 ff d4             	callq  *%r12
  80416004e1:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416004e4:	74 2c                	je     8041600512 <cons_intr+0x48>
    if (c == 0)
  80416004e6:	85 c0                	test   %eax,%eax
  80416004e8:	74 f4                	je     80416004de <cons_intr+0x14>
    cons.buf[cons.wpos++] = c;
  80416004ea:	8b 93 04 02 00 00    	mov    0x204(%rbx),%edx
  80416004f0:	8d 4a 01             	lea    0x1(%rdx),%ecx
  80416004f3:	89 8b 04 02 00 00    	mov    %ecx,0x204(%rbx)
  80416004f9:	89 d2                	mov    %edx,%edx
  80416004fb:	88 04 13             	mov    %al,(%rbx,%rdx,1)
    if (cons.wpos == CONSBUFSIZE)
  80416004fe:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  8041600504:	75 d8                	jne    80416004de <cons_intr+0x14>
      cons.wpos = 0;
  8041600506:	c7 83 04 02 00 00 00 	movl   $0x0,0x204(%rbx)
  804160050d:	00 00 00 
  8041600510:	eb cc                	jmp    80416004de <cons_intr+0x14>
  }
}
  8041600512:	5b                   	pop    %rbx
  8041600513:	41 5c                	pop    %r12
  8041600515:	5d                   	pop    %rbp
  8041600516:	c3                   	retq   

0000008041600517 <kbd_proc_data>:
kbd_proc_data(void) {
  8041600517:	55                   	push   %rbp
  8041600518:	48 89 e5             	mov    %rsp,%rbp
  804160051b:	53                   	push   %rbx
  804160051c:	48 83 ec 08          	sub    $0x8,%rsp
  8041600520:	ba 64 00 00 00       	mov    $0x64,%edx
  8041600525:	ec                   	in     (%dx),%al
  if ((inb(KBSTATP) & KBS_DIB) == 0)
  8041600526:	a8 01                	test   $0x1,%al
  8041600528:	0f 84 35 01 00 00    	je     8041600663 <kbd_proc_data+0x14c>
  804160052e:	ba 60 00 00 00       	mov    $0x60,%edx
  8041600533:	ec                   	in     (%dx),%al
  8041600534:	89 c2                	mov    %eax,%edx
  if (data == 0xE0) {
  8041600536:	3c e0                	cmp    $0xe0,%al
  8041600538:	0f 84 bc 00 00 00    	je     80416005fa <kbd_proc_data+0xe3>
  } else if (data & 0x80) {
  804160053e:	84 c0                	test   %al,%al
  8041600540:	0f 88 cf 00 00 00    	js     8041600615 <kbd_proc_data+0xfe>
  } else if (shift & E0ESC) {
  8041600546:	48 bf 40 67 61 41 80 	movabs $0x8041616740,%rdi
  804160054d:	00 00 00 
  8041600550:	8b 0f                	mov    (%rdi),%ecx
  8041600552:	f6 c1 40             	test   $0x40,%cl
  8041600555:	74 0c                	je     8041600563 <kbd_proc_data+0x4c>
    data |= 0x80;
  8041600557:	83 c8 80             	or     $0xffffff80,%eax
  804160055a:	89 c2                	mov    %eax,%edx
    shift &= ~E0ESC;
  804160055c:	89 c8                	mov    %ecx,%eax
  804160055e:	83 e0 bf             	and    $0xffffffbf,%eax
  8041600561:	89 07                	mov    %eax,(%rdi)
  shift |= shiftcode[data];
  8041600563:	0f b6 f2             	movzbl %dl,%esi
  8041600566:	48 b8 60 4f 60 41 80 	movabs $0x8041604f60,%rax
  804160056d:	00 00 00 
  8041600570:	0f b6 04 30          	movzbl (%rax,%rsi,1),%eax
  8041600574:	48 b9 40 67 61 41 80 	movabs $0x8041616740,%rcx
  804160057b:	00 00 00 
  804160057e:	0b 01                	or     (%rcx),%eax
  shift ^= togglecode[data];
  8041600580:	48 bf 60 4e 60 41 80 	movabs $0x8041604e60,%rdi
  8041600587:	00 00 00 
  804160058a:	0f b6 34 37          	movzbl (%rdi,%rsi,1),%esi
  804160058e:	31 f0                	xor    %esi,%eax
  8041600590:	89 01                	mov    %eax,(%rcx)
  c = charcode[shift & (CTL | SHIFT)][data];
  8041600592:	89 c6                	mov    %eax,%esi
  8041600594:	83 e6 03             	and    $0x3,%esi
  8041600597:	0f b6 d2             	movzbl %dl,%edx
  804160059a:	48 b9 40 4e 60 41 80 	movabs $0x8041604e40,%rcx
  80416005a1:	00 00 00 
  80416005a4:	48 8b 0c f1          	mov    (%rcx,%rsi,8),%rcx
  80416005a8:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
  80416005ac:	0f b6 da             	movzbl %dl,%ebx
  if (shift & CAPSLOCK) {
  80416005af:	a8 08                	test   $0x8,%al
  80416005b1:	74 11                	je     80416005c4 <kbd_proc_data+0xad>
    if ('a' <= c && c <= 'z')
  80416005b3:	89 da                	mov    %ebx,%edx
  80416005b5:	8d 4b 9f             	lea    -0x61(%rbx),%ecx
  80416005b8:	83 f9 19             	cmp    $0x19,%ecx
  80416005bb:	0f 87 91 00 00 00    	ja     8041600652 <kbd_proc_data+0x13b>
      c += 'A' - 'a';
  80416005c1:	83 eb 20             	sub    $0x20,%ebx
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  80416005c4:	f7 d0                	not    %eax
  80416005c6:	a8 06                	test   $0x6,%al
  80416005c8:	75 42                	jne    804160060c <kbd_proc_data+0xf5>
  80416005ca:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
  80416005d0:	75 3a                	jne    804160060c <kbd_proc_data+0xf5>
    cprintf("Rebooting!\n");
  80416005d2:	48 bf 06 4e 60 41 80 	movabs $0x8041604e06,%rdi
  80416005d9:	00 00 00 
  80416005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  80416005e1:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416005e8:	00 00 00 
  80416005eb:	ff d2                	callq  *%rdx
                   : "memory", "cc");
}

static __inline void
outb(int port, uint8_t data) {
  __asm __volatile("outb %0,%w1"
  80416005ed:	b8 03 00 00 00       	mov    $0x3,%eax
  80416005f2:	ba 92 00 00 00       	mov    $0x92,%edx
  80416005f7:	ee                   	out    %al,(%dx)
  80416005f8:	eb 12                	jmp    804160060c <kbd_proc_data+0xf5>
    shift |= E0ESC;
  80416005fa:	48 b8 40 67 61 41 80 	movabs $0x8041616740,%rax
  8041600601:	00 00 00 
  8041600604:	83 08 40             	orl    $0x40,(%rax)
    return 0;
  8041600607:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  804160060c:	89 d8                	mov    %ebx,%eax
  804160060e:	48 83 c4 08          	add    $0x8,%rsp
  8041600612:	5b                   	pop    %rbx
  8041600613:	5d                   	pop    %rbp
  8041600614:	c3                   	retq   
    data = (shift & E0ESC ? data : data & 0x7F);
  8041600615:	48 bf 40 67 61 41 80 	movabs $0x8041616740,%rdi
  804160061c:	00 00 00 
  804160061f:	8b 0f                	mov    (%rdi),%ecx
  8041600621:	89 ce                	mov    %ecx,%esi
  8041600623:	83 e6 40             	and    $0x40,%esi
  8041600626:	83 e0 7f             	and    $0x7f,%eax
  8041600629:	85 f6                	test   %esi,%esi
  804160062b:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
  804160062e:	0f b6 d2             	movzbl %dl,%edx
  8041600631:	48 b8 60 4f 60 41 80 	movabs $0x8041604f60,%rax
  8041600638:	00 00 00 
  804160063b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  804160063f:	83 c8 40             	or     $0x40,%eax
  8041600642:	0f b6 c0             	movzbl %al,%eax
  8041600645:	f7 d0                	not    %eax
  8041600647:	21 c8                	and    %ecx,%eax
  8041600649:	89 07                	mov    %eax,(%rdi)
    return 0;
  804160064b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8041600650:	eb ba                	jmp    804160060c <kbd_proc_data+0xf5>
    else if ('A' <= c && c <= 'Z')
  8041600652:	83 ea 41             	sub    $0x41,%edx
      c += 'a' - 'A';
  8041600655:	8d 4b 20             	lea    0x20(%rbx),%ecx
  8041600658:	83 fa 1a             	cmp    $0x1a,%edx
  804160065b:	0f 42 d9             	cmovb  %ecx,%ebx
  804160065e:	e9 61 ff ff ff       	jmpq   80416005c4 <kbd_proc_data+0xad>
    return -1;
  8041600663:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  8041600668:	eb a2                	jmp    804160060c <kbd_proc_data+0xf5>

000000804160066a <draw_char>:
draw_char(uint32_t *buffer, uint32_t x, uint32_t y, uint32_t color, char charcode) {
  804160066a:	55                   	push   %rbp
  804160066b:	48 89 e5             	mov    %rsp,%rbp
        buffer[uefi_hres * SYMBOL_SIZE * y + uefi_hres * h + SYMBOL_SIZE * x + w] = color;
  804160066e:	48 b8 74 69 61 41 80 	movabs $0x8041616974,%rax
  8041600675:	00 00 00 
  8041600678:	44 8b 10             	mov    (%rax),%r10d
  804160067b:	41 0f af d2          	imul   %r10d,%edx
  804160067f:	44 8d 0c 32          	lea    (%rdx,%rsi,1),%r9d
  8041600683:	41 c1 e1 03          	shl    $0x3,%r9d
  char *p = &(font8x8_basic[pos][0]); // Size of a font's character
  8041600687:	4d 0f be c0          	movsbq %r8b,%r8
  804160068b:	48 b8 20 63 61 41 80 	movabs $0x8041616320,%rax
  8041600692:	00 00 00 
  8041600695:	4a 8d 34 c0          	lea    (%rax,%r8,8),%rsi
  8041600699:	4c 8d 46 08          	lea    0x8(%rsi),%r8
  804160069d:	eb 25                	jmp    80416006c4 <draw_char+0x5a>
    for (int w = 0; w < 8; w++) {
  804160069f:	83 c0 01             	add    $0x1,%eax
  80416006a2:	83 f8 08             	cmp    $0x8,%eax
  80416006a5:	74 11                	je     80416006b8 <draw_char+0x4e>
      if ((p[h] >> (w)) & 1) {
  80416006a7:	0f be 16             	movsbl (%rsi),%edx
  80416006aa:	0f a3 c2             	bt     %eax,%edx
  80416006ad:	73 f0                	jae    804160069f <draw_char+0x35>
        buffer[uefi_hres * SYMBOL_SIZE * y + uefi_hres * h + SYMBOL_SIZE * x + w] = color;
  80416006af:	42 8d 14 08          	lea    (%rax,%r9,1),%edx
  80416006b3:	89 0c 97             	mov    %ecx,(%rdi,%rdx,4)
  80416006b6:	eb e7                	jmp    804160069f <draw_char+0x35>
  80416006b8:	48 83 c6 01          	add    $0x1,%rsi
  80416006bc:	45 01 d1             	add    %r10d,%r9d
  for (int h = 0; h < 8; h++) {
  80416006bf:	4c 39 c6             	cmp    %r8,%rsi
  80416006c2:	74 07                	je     80416006cb <draw_char+0x61>
    for (int w = 0; w < 8; w++) {
  80416006c4:	b8 00 00 00 00       	mov    $0x0,%eax
  80416006c9:	eb dc                	jmp    80416006a7 <draw_char+0x3d>
}
  80416006cb:	5d                   	pop    %rbp
  80416006cc:	c3                   	retq   

00000080416006cd <cons_putc>:
  __asm __volatile("inb %w1,%0"
  80416006cd:	ba fd 03 00 00       	mov    $0x3fd,%edx
  80416006d2:	ec                   	in     (%dx),%al
       !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  80416006d3:	a8 20                	test   $0x20,%al
  80416006d5:	75 29                	jne    8041600700 <cons_putc+0x33>
  for (i = 0;
  80416006d7:	be 00 00 00 00       	mov    $0x0,%esi
  80416006dc:	b9 84 00 00 00       	mov    $0x84,%ecx
  80416006e1:	41 b9 fd 03 00 00    	mov    $0x3fd,%r9d
  80416006e7:	89 ca                	mov    %ecx,%edx
  80416006e9:	ec                   	in     (%dx),%al
  80416006ea:	ec                   	in     (%dx),%al
  80416006eb:	ec                   	in     (%dx),%al
  80416006ec:	ec                   	in     (%dx),%al
       i++)
  80416006ed:	83 c6 01             	add    $0x1,%esi
  80416006f0:	44 89 ca             	mov    %r9d,%edx
  80416006f3:	ec                   	in     (%dx),%al
       !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  80416006f4:	a8 20                	test   $0x20,%al
  80416006f6:	75 08                	jne    8041600700 <cons_putc+0x33>
  80416006f8:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  80416006fe:	7e e7                	jle    80416006e7 <cons_putc+0x1a>
  outb(COM1 + COM_TX, c);
  8041600700:	41 89 f8             	mov    %edi,%r8d
  __asm __volatile("outb %0,%w1"
  8041600703:	ba f8 03 00 00       	mov    $0x3f8,%edx
  8041600708:	89 f8                	mov    %edi,%eax
  804160070a:	ee                   	out    %al,(%dx)
  __asm __volatile("inb %w1,%0"
  804160070b:	ba 79 03 00 00       	mov    $0x379,%edx
  8041600710:	ec                   	in     (%dx),%al
  for (i = 0; !(inb(0x378 + 1) & 0x80) && i < 12800; i++)
  8041600711:	84 c0                	test   %al,%al
  8041600713:	78 29                	js     804160073e <cons_putc+0x71>
  8041600715:	be 00 00 00 00       	mov    $0x0,%esi
  804160071a:	b9 84 00 00 00       	mov    $0x84,%ecx
  804160071f:	41 b9 79 03 00 00    	mov    $0x379,%r9d
  8041600725:	89 ca                	mov    %ecx,%edx
  8041600727:	ec                   	in     (%dx),%al
  8041600728:	ec                   	in     (%dx),%al
  8041600729:	ec                   	in     (%dx),%al
  804160072a:	ec                   	in     (%dx),%al
  804160072b:	83 c6 01             	add    $0x1,%esi
  804160072e:	44 89 ca             	mov    %r9d,%edx
  8041600731:	ec                   	in     (%dx),%al
  8041600732:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  8041600738:	7f 04                	jg     804160073e <cons_putc+0x71>
  804160073a:	84 c0                	test   %al,%al
  804160073c:	79 e7                	jns    8041600725 <cons_putc+0x58>
  __asm __volatile("outb %0,%w1"
  804160073e:	ba 78 03 00 00       	mov    $0x378,%edx
  8041600743:	44 89 c0             	mov    %r8d,%eax
  8041600746:	ee                   	out    %al,(%dx)
  8041600747:	ba 7a 03 00 00       	mov    $0x37a,%edx
  804160074c:	b8 0d 00 00 00       	mov    $0xd,%eax
  8041600751:	ee                   	out    %al,(%dx)
  8041600752:	b8 08 00 00 00       	mov    $0x8,%eax
  8041600757:	ee                   	out    %al,(%dx)
  if (!graphics_exists) {
  8041600758:	48 b8 7c 69 61 41 80 	movabs $0x804161697c,%rax
  804160075f:	00 00 00 
  8041600762:	80 38 00             	cmpb   $0x0,(%rax)
  8041600765:	0f 84 27 02 00 00    	je     8041600992 <cons_putc+0x2c5>
  return 0;
}

// output a character to the console
static void
cons_putc(int c) {
  804160076b:	55                   	push   %rbp
  804160076c:	48 89 e5             	mov    %rsp,%rbp
  804160076f:	41 54                	push   %r12
  8041600771:	53                   	push   %rbx
  if (!(c & ~0xFF))
  8041600772:	89 fa                	mov    %edi,%edx
  8041600774:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
    c |= 0x0700;
  804160077a:	89 f8                	mov    %edi,%eax
  804160077c:	80 cc 07             	or     $0x7,%ah
  804160077f:	85 d2                	test   %edx,%edx
  8041600781:	0f 44 f8             	cmove  %eax,%edi
  switch (c & 0xff) {
  8041600784:	40 0f b6 c7          	movzbl %dil,%eax
  8041600788:	83 f8 09             	cmp    $0x9,%eax
  804160078b:	0f 84 e4 00 00 00    	je     8041600875 <cons_putc+0x1a8>
  8041600791:	83 f8 09             	cmp    $0x9,%eax
  8041600794:	7e 5c                	jle    80416007f2 <cons_putc+0x125>
  8041600796:	83 f8 0a             	cmp    $0xa,%eax
  8041600799:	0f 84 b8 00 00 00    	je     8041600857 <cons_putc+0x18a>
  804160079f:	83 f8 0d             	cmp    $0xd,%eax
  80416007a2:	0f 85 ff 00 00 00    	jne    80416008a7 <cons_putc+0x1da>
      crt_pos -= (crt_pos % crt_cols);
  80416007a8:	48 be 68 69 61 41 80 	movabs $0x8041616968,%rsi
  80416007af:	00 00 00 
  80416007b2:	0f b7 0e             	movzwl (%rsi),%ecx
  80416007b5:	0f b7 c1             	movzwl %cx,%eax
  80416007b8:	48 bb 70 69 61 41 80 	movabs $0x8041616970,%rbx
  80416007bf:	00 00 00 
  80416007c2:	ba 00 00 00 00       	mov    $0x0,%edx
  80416007c7:	f7 33                	divl   (%rbx)
  80416007c9:	29 d1                	sub    %edx,%ecx
  80416007cb:	66 89 0e             	mov    %cx,(%rsi)
  if (crt_pos >= crt_size) {
  80416007ce:	48 b8 68 69 61 41 80 	movabs $0x8041616968,%rax
  80416007d5:	00 00 00 
  80416007d8:	0f b7 10             	movzwl (%rax),%edx
  80416007db:	48 b8 6c 69 61 41 80 	movabs $0x804161696c,%rax
  80416007e2:	00 00 00 
  80416007e5:	3b 10                	cmp    (%rax),%edx
  80416007e7:	0f 83 0f 01 00 00    	jae    80416008fc <cons_putc+0x22f>
  serial_putc(c);
  lpt_putc(c);
  fb_putc(c);
}
  80416007ed:	5b                   	pop    %rbx
  80416007ee:	41 5c                	pop    %r12
  80416007f0:	5d                   	pop    %rbp
  80416007f1:	c3                   	retq   
  switch (c & 0xff) {
  80416007f2:	83 f8 08             	cmp    $0x8,%eax
  80416007f5:	0f 85 ac 00 00 00    	jne    80416008a7 <cons_putc+0x1da>
      if (crt_pos > 0) {
  80416007fb:	66 a1 68 69 61 41 80 	movabs 0x8041616968,%ax
  8041600802:	00 00 00 
  8041600805:	66 85 c0             	test   %ax,%ax
  8041600808:	74 c4                	je     80416007ce <cons_putc+0x101>
        crt_pos--;
  804160080a:	83 e8 01             	sub    $0x1,%eax
  804160080d:	66 a3 68 69 61 41 80 	movabs %ax,0x8041616968
  8041600814:	00 00 00 
        draw_char(crt_buf, crt_pos % crt_cols, crt_pos / crt_cols, 0x0, 0x8);
  8041600817:	0f b7 c0             	movzwl %ax,%eax
  804160081a:	48 bb 70 69 61 41 80 	movabs $0x8041616970,%rbx
  8041600821:	00 00 00 
  8041600824:	8b 1b                	mov    (%rbx),%ebx
  8041600826:	ba 00 00 00 00       	mov    $0x0,%edx
  804160082b:	f7 f3                	div    %ebx
  804160082d:	89 d6                	mov    %edx,%esi
  804160082f:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041600835:	b9 00 00 00 00       	mov    $0x0,%ecx
  804160083a:	89 c2                	mov    %eax,%edx
  804160083c:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600843:	00 00 00 
  8041600846:	48 b8 6a 06 60 41 80 	movabs $0x804160066a,%rax
  804160084d:	00 00 00 
  8041600850:	ff d0                	callq  *%rax
  8041600852:	e9 77 ff ff ff       	jmpq   80416007ce <cons_putc+0x101>
      crt_pos += crt_cols;
  8041600857:	48 b8 68 69 61 41 80 	movabs $0x8041616968,%rax
  804160085e:	00 00 00 
  8041600861:	48 bb 70 69 61 41 80 	movabs $0x8041616970,%rbx
  8041600868:	00 00 00 
  804160086b:	8b 13                	mov    (%rbx),%edx
  804160086d:	66 01 10             	add    %dx,(%rax)
  8041600870:	e9 33 ff ff ff       	jmpq   80416007a8 <cons_putc+0xdb>
      cons_putc(' ');
  8041600875:	bf 20 00 00 00       	mov    $0x20,%edi
  804160087a:	48 bb cd 06 60 41 80 	movabs $0x80416006cd,%rbx
  8041600881:	00 00 00 
  8041600884:	ff d3                	callq  *%rbx
      cons_putc(' ');
  8041600886:	bf 20 00 00 00       	mov    $0x20,%edi
  804160088b:	ff d3                	callq  *%rbx
      cons_putc(' ');
  804160088d:	bf 20 00 00 00       	mov    $0x20,%edi
  8041600892:	ff d3                	callq  *%rbx
      cons_putc(' ');
  8041600894:	bf 20 00 00 00       	mov    $0x20,%edi
  8041600899:	ff d3                	callq  *%rbx
      cons_putc(' ');
  804160089b:	bf 20 00 00 00       	mov    $0x20,%edi
  80416008a0:	ff d3                	callq  *%rbx
  80416008a2:	e9 27 ff ff ff       	jmpq   80416007ce <cons_putc+0x101>
      draw_char(crt_buf, crt_pos % crt_cols, crt_pos / crt_cols, 0xffffffff, (char)c); /* write the character */
  80416008a7:	49 bc 68 69 61 41 80 	movabs $0x8041616968,%r12
  80416008ae:	00 00 00 
  80416008b1:	41 0f b7 1c 24       	movzwl (%r12),%ebx
  80416008b6:	0f b7 c3             	movzwl %bx,%eax
  80416008b9:	48 be 70 69 61 41 80 	movabs $0x8041616970,%rsi
  80416008c0:	00 00 00 
  80416008c3:	8b 36                	mov    (%rsi),%esi
  80416008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  80416008ca:	f7 f6                	div    %esi
  80416008cc:	89 d6                	mov    %edx,%esi
  80416008ce:	44 0f be c7          	movsbl %dil,%r8d
  80416008d2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  80416008d7:	89 c2                	mov    %eax,%edx
  80416008d9:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  80416008e0:	00 00 00 
  80416008e3:	48 b8 6a 06 60 41 80 	movabs $0x804160066a,%rax
  80416008ea:	00 00 00 
  80416008ed:	ff d0                	callq  *%rax
      crt_pos++;
  80416008ef:	83 c3 01             	add    $0x1,%ebx
  80416008f2:	66 41 89 1c 24       	mov    %bx,(%r12)
  80416008f7:	e9 d2 fe ff ff       	jmpq   80416007ce <cons_putc+0x101>
    memmove(crt_buf, crt_buf + uefi_hres * SYMBOL_SIZE, uefi_hres * (uefi_vres - SYMBOL_SIZE) * sizeof(uint32_t));
  80416008fc:	48 bb 74 69 61 41 80 	movabs $0x8041616974,%rbx
  8041600903:	00 00 00 
  8041600906:	8b 03                	mov    (%rbx),%eax
  8041600908:	49 bc 78 69 61 41 80 	movabs $0x8041616978,%r12
  804160090f:	00 00 00 
  8041600912:	41 8b 3c 24          	mov    (%r12),%edi
  8041600916:	8d 57 f8             	lea    -0x8(%rdi),%edx
  8041600919:	0f af d0             	imul   %eax,%edx
  804160091c:	48 c1 e2 02          	shl    $0x2,%rdx
  8041600920:	c1 e0 03             	shl    $0x3,%eax
  8041600923:	89 c0                	mov    %eax,%eax
  8041600925:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  804160092c:	00 00 00 
  804160092f:	48 8d 34 87          	lea    (%rdi,%rax,4),%rsi
  8041600933:	48 b8 57 4a 60 41 80 	movabs $0x8041604a57,%rax
  804160093a:	00 00 00 
  804160093d:	ff d0                	callq  *%rax
    for (i = uefi_hres * (uefi_vres - (uefi_vres % SYMBOL_SIZE) - SYMBOL_SIZE); i < uefi_hres * uefi_vres; i++)
  804160093f:	41 8b 14 24          	mov    (%r12),%edx
  8041600943:	8b 33                	mov    (%rbx),%esi
  8041600945:	89 d1                	mov    %edx,%ecx
  8041600947:	83 e1 f8             	and    $0xfffffff8,%ecx
  804160094a:	83 e9 08             	sub    $0x8,%ecx
  804160094d:	0f af ce             	imul   %esi,%ecx
  8041600950:	89 c8                	mov    %ecx,%eax
  8041600952:	0f af d6             	imul   %esi,%edx
  8041600955:	39 ca                	cmp    %ecx,%edx
  8041600957:	76 1b                	jbe    8041600974 <cons_putc+0x2a7>
      crt_buf[i] = 0;
  8041600959:	48 be 00 00 c0 3e 80 	movabs $0x803ec00000,%rsi
  8041600960:	00 00 00 
  8041600963:	48 63 c8             	movslq %eax,%rcx
  8041600966:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
    for (i = uefi_hres * (uefi_vres - (uefi_vres % SYMBOL_SIZE) - SYMBOL_SIZE); i < uefi_hres * uefi_vres; i++)
  804160096d:	83 c0 01             	add    $0x1,%eax
  8041600970:	39 d0                	cmp    %edx,%eax
  8041600972:	75 ef                	jne    8041600963 <cons_putc+0x296>
    crt_pos -= crt_cols;
  8041600974:	48 b8 68 69 61 41 80 	movabs $0x8041616968,%rax
  804160097b:	00 00 00 
  804160097e:	48 bb 70 69 61 41 80 	movabs $0x8041616970,%rbx
  8041600985:	00 00 00 
  8041600988:	8b 13                	mov    (%rbx),%edx
  804160098a:	66 29 10             	sub    %dx,(%rax)
}
  804160098d:	e9 5b fe ff ff       	jmpq   80416007ed <cons_putc+0x120>
  8041600992:	f3 c3                	repz retq 

0000008041600994 <serial_intr>:
  if (serial_exists)
  8041600994:	48 b8 6a 69 61 41 80 	movabs $0x804161696a,%rax
  804160099b:	00 00 00 
  804160099e:	80 38 00             	cmpb   $0x0,(%rax)
  80416009a1:	75 02                	jne    80416009a5 <serial_intr+0x11>
  80416009a3:	f3 c3                	repz retq 
serial_intr(void) {
  80416009a5:	55                   	push   %rbp
  80416009a6:	48 89 e5             	mov    %rsp,%rbp
    cons_intr(serial_proc_data);
  80416009a9:	48 bf aa 04 60 41 80 	movabs $0x80416004aa,%rdi
  80416009b0:	00 00 00 
  80416009b3:	48 b8 ca 04 60 41 80 	movabs $0x80416004ca,%rax
  80416009ba:	00 00 00 
  80416009bd:	ff d0                	callq  *%rax
}
  80416009bf:	5d                   	pop    %rbp
  80416009c0:	c3                   	retq   

00000080416009c1 <fb_init>:
fb_init(void) {
  80416009c1:	55                   	push   %rbp
  80416009c2:	48 89 e5             	mov    %rsp,%rbp
  LOADER_PARAMS *lp = (LOADER_PARAMS *)uefi_lp;
  80416009c5:	48 b8 00 60 61 41 80 	movabs $0x8041616000,%rax
  80416009cc:	00 00 00 
  80416009cf:	48 8b 08             	mov    (%rax),%rcx
  uefi_vres         = lp->VerticalResolution;
  80416009d2:	8b 51 4c             	mov    0x4c(%rcx),%edx
  80416009d5:	89 d0                	mov    %edx,%eax
  80416009d7:	a3 78 69 61 41 80 00 	movabs %eax,0x8041616978
  80416009de:	00 00 
  uefi_hres         = lp->HorizontalResolution;
  80416009e0:	8b 41 50             	mov    0x50(%rcx),%eax
  80416009e3:	a3 74 69 61 41 80 00 	movabs %eax,0x8041616974
  80416009ea:	00 00 
  crt_cols          = uefi_hres / SYMBOL_SIZE;
  80416009ec:	c1 e8 03             	shr    $0x3,%eax
  80416009ef:	89 c6                	mov    %eax,%esi
  80416009f1:	a3 70 69 61 41 80 00 	movabs %eax,0x8041616970
  80416009f8:	00 00 
  crt_rows          = uefi_vres / SYMBOL_SIZE;
  80416009fa:	c1 ea 03             	shr    $0x3,%edx
  crt_size          = crt_rows * crt_cols;
  80416009fd:	0f af d0             	imul   %eax,%edx
  8041600a00:	89 d0                	mov    %edx,%eax
  8041600a02:	a3 6c 69 61 41 80 00 	movabs %eax,0x804161696c
  8041600a09:	00 00 
  crt_pos           = crt_cols;
  8041600a0b:	89 f0                	mov    %esi,%eax
  8041600a0d:	66 a3 68 69 61 41 80 	movabs %ax,0x8041616968
  8041600a14:	00 00 00 
  memset(crt_buf, 0, lp->FrameBufferSize);
  8041600a17:	8b 51 48             	mov    0x48(%rcx),%edx
  8041600a1a:	be 00 00 00 00       	mov    $0x0,%esi
  8041600a1f:	48 bf 00 00 c0 3e 80 	movabs $0x803ec00000,%rdi
  8041600a26:	00 00 00 
  8041600a29:	48 b8 0e 4a 60 41 80 	movabs $0x8041604a0e,%rax
  8041600a30:	00 00 00 
  8041600a33:	ff d0                	callq  *%rax
  graphics_exists = true;
  8041600a35:	48 b8 7c 69 61 41 80 	movabs $0x804161697c,%rax
  8041600a3c:	00 00 00 
  8041600a3f:	c6 00 01             	movb   $0x1,(%rax)
}
  8041600a42:	5d                   	pop    %rbp
  8041600a43:	c3                   	retq   

0000008041600a44 <kbd_intr>:
kbd_intr(void) {
  8041600a44:	55                   	push   %rbp
  8041600a45:	48 89 e5             	mov    %rsp,%rbp
  cons_intr(kbd_proc_data);
  8041600a48:	48 bf 17 05 60 41 80 	movabs $0x8041600517,%rdi
  8041600a4f:	00 00 00 
  8041600a52:	48 b8 ca 04 60 41 80 	movabs $0x80416004ca,%rax
  8041600a59:	00 00 00 
  8041600a5c:	ff d0                	callq  *%rax
}
  8041600a5e:	5d                   	pop    %rbp
  8041600a5f:	c3                   	retq   

0000008041600a60 <cons_getc>:
cons_getc(void) {
  8041600a60:	55                   	push   %rbp
  8041600a61:	48 89 e5             	mov    %rsp,%rbp
  serial_intr();
  8041600a64:	48 b8 94 09 60 41 80 	movabs $0x8041600994,%rax
  8041600a6b:	00 00 00 
  8041600a6e:	ff d0                	callq  *%rax
  kbd_intr();
  8041600a70:	48 b8 44 0a 60 41 80 	movabs $0x8041600a44,%rax
  8041600a77:	00 00 00 
  8041600a7a:	ff d0                	callq  *%rax
  if (cons.rpos != cons.wpos) {
  8041600a7c:	48 b9 60 67 61 41 80 	movabs $0x8041616760,%rcx
  8041600a83:	00 00 00 
  8041600a86:	8b 91 00 02 00 00    	mov    0x200(%rcx),%edx
  return 0;
  8041600a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  if (cons.rpos != cons.wpos) {
  8041600a91:	3b 91 04 02 00 00    	cmp    0x204(%rcx),%edx
  8041600a97:	74 21                	je     8041600aba <cons_getc+0x5a>
    c = cons.buf[cons.rpos++];
  8041600a99:	8d 4a 01             	lea    0x1(%rdx),%ecx
  8041600a9c:	48 b8 60 67 61 41 80 	movabs $0x8041616760,%rax
  8041600aa3:	00 00 00 
  8041600aa6:	89 88 00 02 00 00    	mov    %ecx,0x200(%rax)
  8041600aac:	89 d2                	mov    %edx,%edx
  8041600aae:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    if (cons.rpos == CONSBUFSIZE)
  8041600ab2:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  8041600ab8:	74 02                	je     8041600abc <cons_getc+0x5c>
}
  8041600aba:	5d                   	pop    %rbp
  8041600abb:	c3                   	retq   
      cons.rpos = 0;
  8041600abc:	48 be 60 69 61 41 80 	movabs $0x8041616960,%rsi
  8041600ac3:	00 00 00 
  8041600ac6:	c7 06 00 00 00 00    	movl   $0x0,(%rsi)
  8041600acc:	eb ec                	jmp    8041600aba <cons_getc+0x5a>

0000008041600ace <cons_init>:
  8041600ace:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041600ad3:	bf fa 03 00 00       	mov    $0x3fa,%edi
  8041600ad8:	89 c8                	mov    %ecx,%eax
  8041600ada:	89 fa                	mov    %edi,%edx
  8041600adc:	ee                   	out    %al,(%dx)
  8041600add:	41 b9 fb 03 00 00    	mov    $0x3fb,%r9d
  8041600ae3:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  8041600ae8:	44 89 ca             	mov    %r9d,%edx
  8041600aeb:	ee                   	out    %al,(%dx)
  8041600aec:	be f8 03 00 00       	mov    $0x3f8,%esi
  8041600af1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8041600af6:	89 f2                	mov    %esi,%edx
  8041600af8:	ee                   	out    %al,(%dx)
  8041600af9:	41 b8 f9 03 00 00    	mov    $0x3f9,%r8d
  8041600aff:	89 c8                	mov    %ecx,%eax
  8041600b01:	44 89 c2             	mov    %r8d,%edx
  8041600b04:	ee                   	out    %al,(%dx)
  8041600b05:	b8 03 00 00 00       	mov    $0x3,%eax
  8041600b0a:	44 89 ca             	mov    %r9d,%edx
  8041600b0d:	ee                   	out    %al,(%dx)
  8041600b0e:	ba fc 03 00 00       	mov    $0x3fc,%edx
  8041600b13:	89 c8                	mov    %ecx,%eax
  8041600b15:	ee                   	out    %al,(%dx)
  8041600b16:	b8 01 00 00 00       	mov    $0x1,%eax
  8041600b1b:	44 89 c2             	mov    %r8d,%edx
  8041600b1e:	ee                   	out    %al,(%dx)
  __asm __volatile("inb %w1,%0"
  8041600b1f:	ba fd 03 00 00       	mov    $0x3fd,%edx
  8041600b24:	ec                   	in     (%dx),%al
  8041600b25:	89 c1                	mov    %eax,%ecx
  serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  8041600b27:	3c ff                	cmp    $0xff,%al
  8041600b29:	0f 95 c0             	setne  %al
  8041600b2c:	a2 6a 69 61 41 80 00 	movabs %al,0x804161696a
  8041600b33:	00 00 
  8041600b35:	89 fa                	mov    %edi,%edx
  8041600b37:	ec                   	in     (%dx),%al
  8041600b38:	89 f2                	mov    %esi,%edx
  8041600b3a:	ec                   	in     (%dx),%al
void
cons_init(void) {
  kbd_init();
  serial_init();

  if (!serial_exists)
  8041600b3b:	80 f9 ff             	cmp    $0xff,%cl
  8041600b3e:	74 02                	je     8041600b42 <cons_init+0x74>
  8041600b40:	f3 c3                	repz retq 
cons_init(void) {
  8041600b42:	55                   	push   %rbp
  8041600b43:	48 89 e5             	mov    %rsp,%rbp
    cprintf("Serial port does not exist!\n");
  8041600b46:	48 bf 12 4e 60 41 80 	movabs $0x8041604e12,%rdi
  8041600b4d:	00 00 00 
  8041600b50:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600b55:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041600b5c:	00 00 00 
  8041600b5f:	ff d2                	callq  *%rdx
}
  8041600b61:	5d                   	pop    %rbp
  8041600b62:	c3                   	retq   

0000008041600b63 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c) {
  8041600b63:	55                   	push   %rbp
  8041600b64:	48 89 e5             	mov    %rsp,%rbp
  cons_putc(c);
  8041600b67:	48 b8 cd 06 60 41 80 	movabs $0x80416006cd,%rax
  8041600b6e:	00 00 00 
  8041600b71:	ff d0                	callq  *%rax
}
  8041600b73:	5d                   	pop    %rbp
  8041600b74:	c3                   	retq   

0000008041600b75 <getchar>:

int
getchar(void) {
  8041600b75:	55                   	push   %rbp
  8041600b76:	48 89 e5             	mov    %rsp,%rbp
  8041600b79:	53                   	push   %rbx
  8041600b7a:	48 83 ec 08          	sub    $0x8,%rsp
  int c;

  while ((c = cons_getc()) == 0)
  8041600b7e:	48 bb 60 0a 60 41 80 	movabs $0x8041600a60,%rbx
  8041600b85:	00 00 00 
  8041600b88:	ff d3                	callq  *%rbx
  8041600b8a:	85 c0                	test   %eax,%eax
  8041600b8c:	74 fa                	je     8041600b88 <getchar+0x13>
    /* do nothing */;
  return c;
}
  8041600b8e:	48 83 c4 08          	add    $0x8,%rsp
  8041600b92:	5b                   	pop    %rbx
  8041600b93:	5d                   	pop    %rbp
  8041600b94:	c3                   	retq   

0000008041600b95 <iscons>:

int
iscons(int fdnum) {
  8041600b95:	55                   	push   %rbp
  8041600b96:	48 89 e5             	mov    %rsp,%rbp
  // used by readline
  return 1;
}
  8041600b99:	b8 01 00 00 00       	mov    $0x1,%eax
  8041600b9e:	5d                   	pop    %rbp
  8041600b9f:	c3                   	retq   

0000008041600ba0 <dwarf_read_abbrev_entry>:
}

// Read value from .debug_abbrev table in buf. Returns number of bytes read.
static int
dwarf_read_abbrev_entry(const void *entry, unsigned form, void *buf,
                        int bufsize, unsigned address_size) {
  8041600ba0:	55                   	push   %rbp
  8041600ba1:	48 89 e5             	mov    %rsp,%rbp
  8041600ba4:	41 56                	push   %r14
  8041600ba6:	41 55                	push   %r13
  8041600ba8:	41 54                	push   %r12
  8041600baa:	53                   	push   %rbx
  8041600bab:	48 83 ec 20          	sub    $0x20,%rsp
  8041600baf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  int bytes = 0;
  switch (form) {
  8041600bb3:	83 fe 20             	cmp    $0x20,%esi
  8041600bb6:	0f 87 56 09 00 00    	ja     8041601512 <dwarf_read_abbrev_entry+0x972>
  8041600bbc:	45 89 c5             	mov    %r8d,%r13d
  8041600bbf:	41 89 cc             	mov    %ecx,%r12d
  8041600bc2:	48 89 d3             	mov    %rdx,%rbx
  8041600bc5:	89 f6                	mov    %esi,%esi
  8041600bc7:	48 b8 18 51 60 41 80 	movabs $0x8041605118,%rax
  8041600bce:	00 00 00 
  8041600bd1:	ff 24 f0             	jmpq   *(%rax,%rsi,8)
    case DW_FORM_addr:
      if (buf && bufsize >= sizeof(uintptr_t)) {
  8041600bd4:	48 85 d2             	test   %rdx,%rdx
  8041600bd7:	74 72                	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  8041600bd9:	83 f9 07             	cmp    $0x7,%ecx
  8041600bdc:	76 6d                	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        memcpy(buf, entry, sizeof(uintptr_t));
  8041600bde:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600be3:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600be7:	48 89 df             	mov    %rbx,%rdi
  8041600bea:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600bf1:	00 00 00 
  8041600bf4:	ff d0                	callq  *%rax
      }
      entry += address_size;
      bytes = address_size;
      break;
  8041600bf6:	eb 53                	jmp    8041600c4b <dwarf_read_abbrev_entry+0xab>
    case DW_FORM_block2: {
      // Read block of 2-byte length followed by 0 to 65535 contiguous information bytes
      // LAB 2: Your code here:
      unsigned length = get_unaligned(entry, Dwarf_Half);
  8041600bf8:	ba 02 00 00 00       	mov    $0x2,%edx
  8041600bfd:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600c01:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600c05:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600c0c:	00 00 00 
  8041600c0f:	ff d0                	callq  *%rax
  8041600c11:	44 0f b7 6d d0       	movzwl -0x30(%rbp),%r13d
      entry += sizeof(Dwarf_Half);
  8041600c16:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041600c1a:	48 83 c0 02          	add    $0x2,%rax
  8041600c1e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      struct Slice slice = {
  8041600c22:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8041600c26:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
          .mem = entry,
          .len = length,
      };
      if (buf) {
  8041600c2a:	48 85 db             	test   %rbx,%rbx
  8041600c2d:	74 18                	je     8041600c47 <dwarf_read_abbrev_entry+0xa7>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600c2f:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600c34:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600c38:	48 89 df             	mov    %rbx,%rdi
  8041600c3b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600c42:	00 00 00 
  8041600c45:	ff d0                	callq  *%rax
      }
      entry += length;
      bytes = sizeof(Dwarf_Half) + length;
  8041600c47:	41 83 c5 02          	add    $0x2,%r13d
      }
      bytes = sizeof(uint64_t);
    } break;
  }
  return bytes;
}
  8041600c4b:	44 89 e8             	mov    %r13d,%eax
  8041600c4e:	48 83 c4 20          	add    $0x20,%rsp
  8041600c52:	5b                   	pop    %rbx
  8041600c53:	41 5c                	pop    %r12
  8041600c55:	41 5d                	pop    %r13
  8041600c57:	41 5e                	pop    %r14
  8041600c59:	5d                   	pop    %rbp
  8041600c5a:	c3                   	retq   
      unsigned length = get_unaligned(entry, uint32_t);
  8041600c5b:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600c60:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600c64:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600c68:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600c6f:	00 00 00 
  8041600c72:	ff d0                	callq  *%rax
  8041600c74:	44 8b 6d d0          	mov    -0x30(%rbp),%r13d
      entry += sizeof(uint32_t);
  8041600c78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041600c7c:	48 83 c0 04          	add    $0x4,%rax
  8041600c80:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      struct Slice slice = {
  8041600c84:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8041600c88:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
      if (buf) {
  8041600c8c:	48 85 db             	test   %rbx,%rbx
  8041600c8f:	74 18                	je     8041600ca9 <dwarf_read_abbrev_entry+0x109>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600c91:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600c96:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600c9a:	48 89 df             	mov    %rbx,%rdi
  8041600c9d:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600ca4:	00 00 00 
  8041600ca7:	ff d0                	callq  *%rax
      bytes = sizeof(uint32_t) + length;
  8041600ca9:	41 83 c5 04          	add    $0x4,%r13d
    } break;
  8041600cad:	eb 9c                	jmp    8041600c4b <dwarf_read_abbrev_entry+0xab>
      Dwarf_Half data = get_unaligned(entry, Dwarf_Half);
  8041600caf:	ba 02 00 00 00       	mov    $0x2,%edx
  8041600cb4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600cb8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600cbc:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600cc3:	00 00 00 
  8041600cc6:	ff d0                	callq  *%rax
      entry += sizeof(Dwarf_Half);
  8041600cc8:	48 83 45 c8 02       	addq   $0x2,-0x38(%rbp)
      if (buf && bufsize >= sizeof(Dwarf_Half)) {
  8041600ccd:	48 85 db             	test   %rbx,%rbx
  8041600cd0:	74 06                	je     8041600cd8 <dwarf_read_abbrev_entry+0x138>
  8041600cd2:	41 83 fc 01          	cmp    $0x1,%r12d
  8041600cd6:	77 0b                	ja     8041600ce3 <dwarf_read_abbrev_entry+0x143>
      bytes = sizeof(Dwarf_Half);
  8041600cd8:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  8041600cde:	e9 68 ff ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (Dwarf_Half *)buf);
  8041600ce3:	ba 02 00 00 00       	mov    $0x2,%edx
  8041600ce8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600cec:	48 89 df             	mov    %rbx,%rdi
  8041600cef:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600cf6:	00 00 00 
  8041600cf9:	ff d0                	callq  *%rax
      bytes = sizeof(Dwarf_Half);
  8041600cfb:	41 bd 02 00 00 00    	mov    $0x2,%r13d
        put_unaligned(data, (Dwarf_Half *)buf);
  8041600d01:	e9 45 ff ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      uint32_t data = get_unaligned(entry, uint32_t);
  8041600d06:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600d0b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600d0f:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600d13:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600d1a:	00 00 00 
  8041600d1d:	ff d0                	callq  *%rax
      entry += sizeof(uint32_t);
  8041600d1f:	48 83 45 c8 04       	addq   $0x4,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint32_t)) {
  8041600d24:	48 85 db             	test   %rbx,%rbx
  8041600d27:	74 06                	je     8041600d2f <dwarf_read_abbrev_entry+0x18f>
  8041600d29:	41 83 fc 03          	cmp    $0x3,%r12d
  8041600d2d:	77 0b                	ja     8041600d3a <dwarf_read_abbrev_entry+0x19a>
      bytes = sizeof(uint32_t);
  8041600d2f:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  8041600d35:	e9 11 ff ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint32_t *)buf);
  8041600d3a:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600d3f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600d43:	48 89 df             	mov    %rbx,%rdi
  8041600d46:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600d4d:	00 00 00 
  8041600d50:	ff d0                	callq  *%rax
      bytes = sizeof(uint32_t);
  8041600d52:	41 bd 04 00 00 00    	mov    $0x4,%r13d
        put_unaligned(data, (uint32_t *)buf);
  8041600d58:	e9 ee fe ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      uint64_t data = get_unaligned(entry, uint64_t);
  8041600d5d:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600d62:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600d66:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600d6a:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600d71:	00 00 00 
  8041600d74:	ff d0                	callq  *%rax
      entry += sizeof(uint64_t);
  8041600d76:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint64_t)) {
  8041600d7b:	48 85 db             	test   %rbx,%rbx
  8041600d7e:	74 06                	je     8041600d86 <dwarf_read_abbrev_entry+0x1e6>
  8041600d80:	41 83 fc 07          	cmp    $0x7,%r12d
  8041600d84:	77 0b                	ja     8041600d91 <dwarf_read_abbrev_entry+0x1f1>
      bytes = sizeof(uint64_t);
  8041600d86:	41 bd 08 00 00 00    	mov    $0x8,%r13d
  8041600d8c:	e9 ba fe ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint64_t *)buf);
  8041600d91:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600d96:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600d9a:	48 89 df             	mov    %rbx,%rdi
  8041600d9d:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600da4:	00 00 00 
  8041600da7:	ff d0                	callq  *%rax
      bytes = sizeof(uint64_t);
  8041600da9:	41 bd 08 00 00 00    	mov    $0x8,%r13d
        put_unaligned(data, (uint64_t *)buf);
  8041600daf:	e9 97 fe ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      if (buf && bufsize >= sizeof(char *)) {
  8041600db4:	48 85 d2             	test   %rdx,%rdx
  8041600db7:	74 1d                	je     8041600dd6 <dwarf_read_abbrev_entry+0x236>
  8041600db9:	83 f9 07             	cmp    $0x7,%ecx
  8041600dbc:	76 18                	jbe    8041600dd6 <dwarf_read_abbrev_entry+0x236>
        memcpy(buf, &entry, sizeof(char *));
  8041600dbe:	ba 08 00 00 00       	mov    $0x8,%edx
  8041600dc3:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8041600dc7:	48 89 df             	mov    %rbx,%rdi
  8041600dca:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600dd1:	00 00 00 
  8041600dd4:	ff d0                	callq  *%rax
      bytes = strlen(entry) + 1;
  8041600dd6:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8041600dda:	48 b8 1a 48 60 41 80 	movabs $0x804160481a,%rax
  8041600de1:	00 00 00 
  8041600de4:	ff d0                	callq  *%rax
  8041600de6:	44 8d 68 01          	lea    0x1(%rax),%r13d
    } break;
  8041600dea:	e9 5c fe ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      unsigned long count = dwarf_read_uleb128(entry, &length);
  8041600def:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8041600df3:	48 89 f8             	mov    %rdi,%rax
  unsigned int result;
  unsigned char byte;
  int shift, count;

  result = 0;
  shift  = 0;
  8041600df6:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041600dfb:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  count  = 0;

  while (1) {
    byte = *addr;
  8041600e01:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041600e04:	48 83 c0 01          	add    $0x1,%rax
  8041600e08:	41 89 c4             	mov    %eax,%r12d
  8041600e0b:	41 29 fc             	sub    %edi,%r12d
    count++;

    result |= (byte & 0x7f) << shift;
  8041600e0e:	89 f2                	mov    %esi,%edx
  8041600e10:	83 e2 7f             	and    $0x7f,%edx
  8041600e13:	d3 e2                	shl    %cl,%edx
  8041600e15:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041600e18:	83 c1 07             	add    $0x7,%ecx

    if (!(byte & 0x80))
  8041600e1b:	40 84 f6             	test   %sil,%sil
  8041600e1e:	78 e1                	js     8041600e01 <dwarf_read_abbrev_entry+0x261>
      break;
  }

  *ret = result;

  return count;
  8041600e20:	49 63 c4             	movslq %r12d,%rax
      entry += count;
  8041600e23:	48 01 c7             	add    %rax,%rdi
  8041600e26:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
      struct Slice slice = {
  8041600e2a:	48 89 7d d0          	mov    %rdi,-0x30(%rbp)
  8041600e2e:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
      if (buf) {
  8041600e32:	48 85 db             	test   %rbx,%rbx
  8041600e35:	74 18                	je     8041600e4f <dwarf_read_abbrev_entry+0x2af>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600e37:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600e3c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600e40:	48 89 df             	mov    %rbx,%rdi
  8041600e43:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600e4a:	00 00 00 
  8041600e4d:	ff d0                	callq  *%rax
      bytes = count + length;
  8041600e4f:	45 01 e5             	add    %r12d,%r13d
    } break;
  8041600e52:	e9 f4 fd ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      unsigned length = get_unaligned(entry, Dwarf_Small);
  8041600e57:	ba 01 00 00 00       	mov    $0x1,%edx
  8041600e5c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600e60:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600e64:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600e6b:	00 00 00 
  8041600e6e:	ff d0                	callq  *%rax
  8041600e70:	44 0f b6 6d d0       	movzbl -0x30(%rbp),%r13d
      entry += sizeof(Dwarf_Small);
  8041600e75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041600e79:	48 83 c0 01          	add    $0x1,%rax
  8041600e7d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      struct Slice slice = {
  8041600e81:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8041600e85:	44 89 6d d8          	mov    %r13d,-0x28(%rbp)
      if (buf) {
  8041600e89:	48 85 db             	test   %rbx,%rbx
  8041600e8c:	74 18                	je     8041600ea6 <dwarf_read_abbrev_entry+0x306>
        memcpy(buf, &slice, sizeof(struct Slice));
  8041600e8e:	ba 10 00 00 00       	mov    $0x10,%edx
  8041600e93:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600e97:	48 89 df             	mov    %rbx,%rdi
  8041600e9a:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600ea1:	00 00 00 
  8041600ea4:	ff d0                	callq  *%rax
      bytes = length + sizeof(Dwarf_Small);
  8041600ea6:	41 83 c5 01          	add    $0x1,%r13d
    } break;
  8041600eaa:	e9 9c fd ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      Dwarf_Small data = get_unaligned(entry, Dwarf_Small);
  8041600eaf:	ba 01 00 00 00       	mov    $0x1,%edx
  8041600eb4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600eb8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600ebc:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600ec3:	00 00 00 
  8041600ec6:	ff d0                	callq  *%rax
  8041600ec8:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
      if (buf && bufsize >= sizeof(Dwarf_Small)) {
  8041600ecc:	48 85 db             	test   %rbx,%rbx
  8041600ecf:	0f 84 48 06 00 00    	je     804160151d <dwarf_read_abbrev_entry+0x97d>
  8041600ed5:	45 85 e4             	test   %r12d,%r12d
  8041600ed8:	0f 84 3f 06 00 00    	je     804160151d <dwarf_read_abbrev_entry+0x97d>
        put_unaligned(data, (Dwarf_Small *)buf);
  8041600ede:	88 03                	mov    %al,(%rbx)
      bytes = sizeof(Dwarf_Small);
  8041600ee0:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        put_unaligned(data, (Dwarf_Small *)buf);
  8041600ee6:	e9 60 fd ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      bool data = get_unaligned(entry, Dwarf_Small);
  8041600eeb:	ba 01 00 00 00       	mov    $0x1,%edx
  8041600ef0:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041600ef4:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600ef8:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600eff:	00 00 00 
  8041600f02:	ff d0                	callq  *%rax
  8041600f04:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
      if (buf && bufsize >= sizeof(bool)) {
  8041600f08:	48 85 db             	test   %rbx,%rbx
  8041600f0b:	0f 84 17 06 00 00    	je     8041601528 <dwarf_read_abbrev_entry+0x988>
  8041600f11:	45 85 e4             	test   %r12d,%r12d
  8041600f14:	0f 84 0e 06 00 00    	je     8041601528 <dwarf_read_abbrev_entry+0x988>
      bool data = get_unaligned(entry, Dwarf_Small);
  8041600f1a:	84 c0                	test   %al,%al
        put_unaligned(data, (bool *)buf);
  8041600f1c:	0f 95 03             	setne  (%rbx)
      bytes = sizeof(Dwarf_Small);
  8041600f1f:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        put_unaligned(data, (bool *)buf);
  8041600f25:	e9 21 fd ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      int count = dwarf_read_leb128(entry, &data);
  8041600f2a:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8041600f2e:	4c 89 c0             	mov    %r8,%rax
  int result, shift;
  int num_bits;
  int count;

  result = 0;
  shift  = 0;
  8041600f31:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041600f36:	bf 00 00 00 00       	mov    $0x0,%edi
  count  = 0;

  while (1) {
    byte = *addr;
  8041600f3b:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041600f3e:	48 83 c0 01          	add    $0x1,%rax
    result |= (byte & 0x7f) << shift;
  8041600f42:	89 f2                	mov    %esi,%edx
  8041600f44:	83 e2 7f             	and    $0x7f,%edx
  8041600f47:	d3 e2                	shl    %cl,%edx
  8041600f49:	09 d7                	or     %edx,%edi
    shift += 7;
  8041600f4b:	83 c1 07             	add    $0x7,%ecx
  8041600f4e:	41 89 c5             	mov    %eax,%r13d
  8041600f51:	45 29 c5             	sub    %r8d,%r13d
    count++;

    if (!(byte & 0x80))
  8041600f54:	40 84 f6             	test   %sil,%sil
  8041600f57:	78 e2                	js     8041600f3b <dwarf_read_abbrev_entry+0x39b>
  }

  /* The number of bits in a signed integer. */
  num_bits = 8 * sizeof(result);

  if ((shift < num_bits) && (byte & 0x40))
  8041600f59:	83 f9 1f             	cmp    $0x1f,%ecx
  8041600f5c:	7f 0f                	jg     8041600f6d <dwarf_read_abbrev_entry+0x3cd>
  8041600f5e:	40 f6 c6 40          	test   $0x40,%sil
  8041600f62:	74 09                	je     8041600f6d <dwarf_read_abbrev_entry+0x3cd>
    result |= (-1U << shift);
  8041600f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8041600f69:	d3 e0                	shl    %cl,%eax
  8041600f6b:	09 c7                	or     %eax,%edi

  *ret = result;

  return count;
  8041600f6d:	49 63 c5             	movslq %r13d,%rax
      entry += count;
  8041600f70:	49 01 c0             	add    %rax,%r8
  8041600f73:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(int)) {
  8041600f77:	48 85 db             	test   %rbx,%rbx
  8041600f7a:	0f 84 cb fc ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  8041600f80:	41 83 fc 03          	cmp    $0x3,%r12d
  8041600f84:	0f 86 c1 fc ff ff    	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (int *)buf);
  8041600f8a:	89 7d d0             	mov    %edi,-0x30(%rbp)
  8041600f8d:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600f92:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041600f96:	48 89 df             	mov    %rbx,%rdi
  8041600f99:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600fa0:	00 00 00 
  8041600fa3:	ff d0                	callq  *%rax
  8041600fa5:	e9 a1 fc ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      int count            = dwarf_entry_len(entry, &length);
  8041600faa:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
  initial_len = get_unaligned(addr, uint32_t);
  8041600fae:	ba 04 00 00 00       	mov    $0x4,%edx
  8041600fb3:	4c 89 f6             	mov    %r14,%rsi
  8041600fb6:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041600fba:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041600fc1:	00 00 00 
  8041600fc4:	ff d0                	callq  *%rax
  8041600fc6:	8b 45 d0             	mov    -0x30(%rbp),%eax
    *len = initial_len;
  8041600fc9:	89 c2                	mov    %eax,%edx
  count       = 4;
  8041600fcb:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041600fd1:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041600fd4:	76 2b                	jbe    8041601001 <dwarf_read_abbrev_entry+0x461>
    if (initial_len == DW_EXT_DWARF64) {
  8041600fd6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041600fd9:	74 61                	je     804160103c <dwarf_read_abbrev_entry+0x49c>
      cprintf("Unknown DWARF extension\n");
  8041600fdb:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  8041600fe2:	00 00 00 
  8041600fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041600fea:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041600ff1:	00 00 00 
  8041600ff4:	ff d2                	callq  *%rdx
      unsigned long length = 0;
  8041600ff6:	ba 00 00 00 00       	mov    $0x0,%edx
      count = 0;
  8041600ffb:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      entry += count;
  8041601001:	49 63 c5             	movslq %r13d,%rax
  8041601004:	48 01 45 c8          	add    %rax,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned long)) {
  8041601008:	48 85 db             	test   %rbx,%rbx
  804160100b:	0f 84 3a fc ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  8041601011:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601015:	0f 86 30 fc ff ff    	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(length, (unsigned long *)buf);
  804160101b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804160101f:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601024:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601028:	48 89 df             	mov    %rbx,%rdi
  804160102b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601032:	00 00 00 
  8041601035:	ff d0                	callq  *%rax
  8041601037:	e9 0f fc ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160103c:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041601040:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601045:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601049:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601050:	00 00 00 
  8041601053:	ff d0                	callq  *%rax
  8041601055:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
      count = 12;
  8041601059:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  804160105f:	eb a0                	jmp    8041601001 <dwarf_read_abbrev_entry+0x461>
      int count         = dwarf_read_uleb128(entry, &data);
  8041601061:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8041601065:	4c 89 c0             	mov    %r8,%rax
  shift  = 0;
  8041601068:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160106d:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041601072:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601075:	48 83 c0 01          	add    $0x1,%rax
  8041601079:	41 89 c5             	mov    %eax,%r13d
  804160107c:	45 29 c5             	sub    %r8d,%r13d
    result |= (byte & 0x7f) << shift;
  804160107f:	89 f2                	mov    %esi,%edx
  8041601081:	83 e2 7f             	and    $0x7f,%edx
  8041601084:	d3 e2                	shl    %cl,%edx
  8041601086:	09 d7                	or     %edx,%edi
    shift += 7;
  8041601088:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160108b:	40 84 f6             	test   %sil,%sil
  804160108e:	78 e2                	js     8041601072 <dwarf_read_abbrev_entry+0x4d2>
  return count;
  8041601090:	49 63 c5             	movslq %r13d,%rax
      entry += count;
  8041601093:	49 01 c0             	add    %rax,%r8
  8041601096:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned int)) {
  804160109a:	48 85 db             	test   %rbx,%rbx
  804160109d:	0f 84 a8 fb ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  80416010a3:	41 83 fc 03          	cmp    $0x3,%r12d
  80416010a7:	0f 86 9e fb ff ff    	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (unsigned int *)buf);
  80416010ad:	89 7d d0             	mov    %edi,-0x30(%rbp)
  80416010b0:	ba 04 00 00 00       	mov    $0x4,%edx
  80416010b5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80416010b9:	48 89 df             	mov    %rbx,%rdi
  80416010bc:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416010c3:	00 00 00 
  80416010c6:	ff d0                	callq  *%rax
  80416010c8:	e9 7e fb ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      int count            = dwarf_entry_len(entry, &length);
  80416010cd:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
  initial_len = get_unaligned(addr, uint32_t);
  80416010d1:	ba 04 00 00 00       	mov    $0x4,%edx
  80416010d6:	4c 89 f6             	mov    %r14,%rsi
  80416010d9:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416010dd:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416010e4:	00 00 00 
  80416010e7:	ff d0                	callq  *%rax
  80416010e9:	8b 45 d0             	mov    -0x30(%rbp),%eax
    *len = initial_len;
  80416010ec:	89 c2                	mov    %eax,%edx
  count       = 4;
  80416010ee:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416010f4:	83 f8 ef             	cmp    $0xffffffef,%eax
  80416010f7:	76 2b                	jbe    8041601124 <dwarf_read_abbrev_entry+0x584>
    if (initial_len == DW_EXT_DWARF64) {
  80416010f9:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416010fc:	74 61                	je     804160115f <dwarf_read_abbrev_entry+0x5bf>
      cprintf("Unknown DWARF extension\n");
  80416010fe:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  8041601105:	00 00 00 
  8041601108:	b8 00 00 00 00       	mov    $0x0,%eax
  804160110d:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041601114:	00 00 00 
  8041601117:	ff d2                	callq  *%rdx
      unsigned long length = 0;
  8041601119:	ba 00 00 00 00       	mov    $0x0,%edx
      count = 0;
  804160111e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      entry += count;
  8041601124:	49 63 c5             	movslq %r13d,%rax
  8041601127:	48 01 45 c8          	add    %rax,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned long)) {
  804160112b:	48 85 db             	test   %rbx,%rbx
  804160112e:	0f 84 17 fb ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  8041601134:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601138:	0f 86 0d fb ff ff    	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(length, (unsigned long *)buf);
  804160113e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8041601142:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601147:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  804160114b:	48 89 df             	mov    %rbx,%rdi
  804160114e:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601155:	00 00 00 
  8041601158:	ff d0                	callq  *%rax
  804160115a:	e9 ec fa ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160115f:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041601163:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601168:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  804160116c:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601173:	00 00 00 
  8041601176:	ff d0                	callq  *%rax
  8041601178:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
      count = 12;
  804160117c:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  8041601182:	eb a0                	jmp    8041601124 <dwarf_read_abbrev_entry+0x584>
      Dwarf_Small data = get_unaligned(entry, Dwarf_Small);
  8041601184:	ba 01 00 00 00       	mov    $0x1,%edx
  8041601189:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804160118d:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601191:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601198:	00 00 00 
  804160119b:	ff d0                	callq  *%rax
  804160119d:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
      if (buf && bufsize >= sizeof(Dwarf_Small)) {
  80416011a1:	48 85 db             	test   %rbx,%rbx
  80416011a4:	0f 84 89 03 00 00    	je     8041601533 <dwarf_read_abbrev_entry+0x993>
  80416011aa:	45 85 e4             	test   %r12d,%r12d
  80416011ad:	0f 84 80 03 00 00    	je     8041601533 <dwarf_read_abbrev_entry+0x993>
        put_unaligned(data, (Dwarf_Small *)buf);
  80416011b3:	88 03                	mov    %al,(%rbx)
      bytes = sizeof(Dwarf_Small);
  80416011b5:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        put_unaligned(data, (Dwarf_Small *)buf);
  80416011bb:	e9 8b fa ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      Dwarf_Half data = get_unaligned(entry, Dwarf_Half);
  80416011c0:	ba 02 00 00 00       	mov    $0x2,%edx
  80416011c5:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80416011c9:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416011cd:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416011d4:	00 00 00 
  80416011d7:	ff d0                	callq  *%rax
      entry += sizeof(Dwarf_Half);
  80416011d9:	48 83 45 c8 02       	addq   $0x2,-0x38(%rbp)
      if (buf && bufsize >= sizeof(Dwarf_Half)) {
  80416011de:	48 85 db             	test   %rbx,%rbx
  80416011e1:	74 06                	je     80416011e9 <dwarf_read_abbrev_entry+0x649>
  80416011e3:	41 83 fc 01          	cmp    $0x1,%r12d
  80416011e7:	77 0b                	ja     80416011f4 <dwarf_read_abbrev_entry+0x654>
      bytes = sizeof(Dwarf_Half);
  80416011e9:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  80416011ef:	e9 57 fa ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (Dwarf_Half *)buf);
  80416011f4:	ba 02 00 00 00       	mov    $0x2,%edx
  80416011f9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80416011fd:	48 89 df             	mov    %rbx,%rdi
  8041601200:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601207:	00 00 00 
  804160120a:	ff d0                	callq  *%rax
      bytes = sizeof(Dwarf_Half);
  804160120c:	41 bd 02 00 00 00    	mov    $0x2,%r13d
        put_unaligned(data, (Dwarf_Half *)buf);
  8041601212:	e9 34 fa ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      uint32_t data = get_unaligned(entry, uint32_t);
  8041601217:	ba 04 00 00 00       	mov    $0x4,%edx
  804160121c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601220:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601224:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  804160122b:	00 00 00 
  804160122e:	ff d0                	callq  *%rax
      entry += sizeof(uint32_t);
  8041601230:	48 83 45 c8 04       	addq   $0x4,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint32_t)) {
  8041601235:	48 85 db             	test   %rbx,%rbx
  8041601238:	74 06                	je     8041601240 <dwarf_read_abbrev_entry+0x6a0>
  804160123a:	41 83 fc 03          	cmp    $0x3,%r12d
  804160123e:	77 0b                	ja     804160124b <dwarf_read_abbrev_entry+0x6ab>
      bytes = sizeof(uint32_t);
  8041601240:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  8041601246:	e9 00 fa ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint32_t *)buf);
  804160124b:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601250:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601254:	48 89 df             	mov    %rbx,%rdi
  8041601257:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  804160125e:	00 00 00 
  8041601261:	ff d0                	callq  *%rax
      bytes = sizeof(uint32_t);
  8041601263:	41 bd 04 00 00 00    	mov    $0x4,%r13d
        put_unaligned(data, (uint32_t *)buf);
  8041601269:	e9 dd f9 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      uint64_t data = get_unaligned(entry, uint64_t);
  804160126e:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601273:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601277:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  804160127b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601282:	00 00 00 
  8041601285:	ff d0                	callq  *%rax
      entry += sizeof(uint64_t);
  8041601287:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint64_t)) {
  804160128c:	48 85 db             	test   %rbx,%rbx
  804160128f:	74 06                	je     8041601297 <dwarf_read_abbrev_entry+0x6f7>
  8041601291:	41 83 fc 07          	cmp    $0x7,%r12d
  8041601295:	77 0b                	ja     80416012a2 <dwarf_read_abbrev_entry+0x702>
      bytes = sizeof(uint64_t);
  8041601297:	41 bd 08 00 00 00    	mov    $0x8,%r13d
  804160129d:	e9 a9 f9 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint64_t *)buf);
  80416012a2:	ba 08 00 00 00       	mov    $0x8,%edx
  80416012a7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80416012ab:	48 89 df             	mov    %rbx,%rdi
  80416012ae:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416012b5:	00 00 00 
  80416012b8:	ff d0                	callq  *%rax
      bytes = sizeof(uint64_t);
  80416012ba:	41 bd 08 00 00 00    	mov    $0x8,%r13d
        put_unaligned(data, (uint64_t *)buf);
  80416012c0:	e9 86 f9 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      int count         = dwarf_read_uleb128(entry, &data);
  80416012c5:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  80416012c9:	4c 89 c0             	mov    %r8,%rax
  shift  = 0;
  80416012cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416012d1:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  80416012d6:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416012d9:	48 83 c0 01          	add    $0x1,%rax
  80416012dd:	41 89 c5             	mov    %eax,%r13d
  80416012e0:	45 29 c5             	sub    %r8d,%r13d
    result |= (byte & 0x7f) << shift;
  80416012e3:	89 f2                	mov    %esi,%edx
  80416012e5:	83 e2 7f             	and    $0x7f,%edx
  80416012e8:	d3 e2                	shl    %cl,%edx
  80416012ea:	09 d7                	or     %edx,%edi
    shift += 7;
  80416012ec:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416012ef:	40 84 f6             	test   %sil,%sil
  80416012f2:	78 e2                	js     80416012d6 <dwarf_read_abbrev_entry+0x736>
  return count;
  80416012f4:	49 63 c5             	movslq %r13d,%rax
      entry += count;
  80416012f7:	49 01 c0             	add    %rax,%r8
  80416012fa:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned int)) {
  80416012fe:	48 85 db             	test   %rbx,%rbx
  8041601301:	0f 84 44 f9 ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  8041601307:	41 83 fc 03          	cmp    $0x3,%r12d
  804160130b:	0f 86 3a f9 ff ff    	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (unsigned int *)buf);
  8041601311:	89 7d d0             	mov    %edi,-0x30(%rbp)
  8041601314:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601319:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  804160131d:	48 89 df             	mov    %rbx,%rdi
  8041601320:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601327:	00 00 00 
  804160132a:	ff d0                	callq  *%rax
  804160132c:	e9 1a f9 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      int count         = dwarf_read_uleb128(entry, &form);
  8041601331:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8041601335:	48 89 f8             	mov    %rdi,%rax
  shift  = 0;
  8041601338:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160133d:	be 00 00 00 00       	mov    $0x0,%esi
    byte = *addr;
  8041601342:	44 0f b6 00          	movzbl (%rax),%r8d
    addr++;
  8041601346:	48 83 c0 01          	add    $0x1,%rax
  804160134a:	41 89 c6             	mov    %eax,%r14d
  804160134d:	41 29 fe             	sub    %edi,%r14d
    result |= (byte & 0x7f) << shift;
  8041601350:	44 89 c2             	mov    %r8d,%edx
  8041601353:	83 e2 7f             	and    $0x7f,%edx
  8041601356:	d3 e2                	shl    %cl,%edx
  8041601358:	09 d6                	or     %edx,%esi
    shift += 7;
  804160135a:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160135d:	45 84 c0             	test   %r8b,%r8b
  8041601360:	78 e0                	js     8041601342 <dwarf_read_abbrev_entry+0x7a2>
  return count;
  8041601362:	49 63 c6             	movslq %r14d,%rax
      entry += count;
  8041601365:	48 01 c7             	add    %rax,%rdi
  8041601368:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
      int read = dwarf_read_abbrev_entry(entry, form, buf, bufsize,
  804160136c:	45 89 e8             	mov    %r13d,%r8d
  804160136f:	44 89 e1             	mov    %r12d,%ecx
  8041601372:	48 89 da             	mov    %rbx,%rdx
  8041601375:	48 b8 a0 0b 60 41 80 	movabs $0x8041600ba0,%rax
  804160137c:	00 00 00 
  804160137f:	ff d0                	callq  *%rax
      bytes    = count + read;
  8041601381:	45 8d 2c 06          	lea    (%r14,%rax,1),%r13d
    } break;
  8041601385:	e9 c1 f8 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      int count            = dwarf_entry_len(entry, &length);
  804160138a:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
  initial_len = get_unaligned(addr, uint32_t);
  804160138e:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601393:	4c 89 f6             	mov    %r14,%rsi
  8041601396:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  804160139a:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416013a1:	00 00 00 
  80416013a4:	ff d0                	callq  *%rax
  80416013a6:	8b 45 d0             	mov    -0x30(%rbp),%eax
    *len = initial_len;
  80416013a9:	89 c2                	mov    %eax,%edx
  count       = 4;
  80416013ab:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416013b1:	83 f8 ef             	cmp    $0xffffffef,%eax
  80416013b4:	76 2b                	jbe    80416013e1 <dwarf_read_abbrev_entry+0x841>
    if (initial_len == DW_EXT_DWARF64) {
  80416013b6:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416013b9:	74 61                	je     804160141c <dwarf_read_abbrev_entry+0x87c>
      cprintf("Unknown DWARF extension\n");
  80416013bb:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  80416013c2:	00 00 00 
  80416013c5:	b8 00 00 00 00       	mov    $0x0,%eax
  80416013ca:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416013d1:	00 00 00 
  80416013d4:	ff d2                	callq  *%rdx
      unsigned long length = 0;
  80416013d6:	ba 00 00 00 00       	mov    $0x0,%edx
      count = 0;
  80416013db:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      entry += count;
  80416013e1:	49 63 c5             	movslq %r13d,%rax
  80416013e4:	48 01 45 c8          	add    %rax,-0x38(%rbp)
      if (buf && bufsize >= sizeof(unsigned long)) {
  80416013e8:	48 85 db             	test   %rbx,%rbx
  80416013eb:	0f 84 5a f8 ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
  80416013f1:	41 83 fc 07          	cmp    $0x7,%r12d
  80416013f5:	0f 86 50 f8 ff ff    	jbe    8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(length, (unsigned long *)buf);
  80416013fb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80416013ff:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601404:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8041601408:	48 89 df             	mov    %rbx,%rdi
  804160140b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601412:	00 00 00 
  8041601415:	ff d0                	callq  *%rax
  8041601417:	e9 2f f8 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160141c:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041601420:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601425:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8041601429:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601430:	00 00 00 
  8041601433:	ff d0                	callq  *%rax
  8041601435:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
      count = 12;
  8041601439:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  804160143f:	eb a0                	jmp    80416013e1 <dwarf_read_abbrev_entry+0x841>
      unsigned long count = dwarf_read_uleb128(entry, &length);
  8041601441:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041601445:	48 89 f0             	mov    %rsi,%rax
  shift  = 0;
  8041601448:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160144d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041601453:	0f b6 38             	movzbl (%rax),%edi
    addr++;
  8041601456:	48 83 c0 01          	add    $0x1,%rax
  804160145a:	41 89 c6             	mov    %eax,%r14d
  804160145d:	41 29 f6             	sub    %esi,%r14d
    result |= (byte & 0x7f) << shift;
  8041601460:	89 fa                	mov    %edi,%edx
  8041601462:	83 e2 7f             	and    $0x7f,%edx
  8041601465:	d3 e2                	shl    %cl,%edx
  8041601467:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  804160146a:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160146d:	40 84 ff             	test   %dil,%dil
  8041601470:	78 e1                	js     8041601453 <dwarf_read_abbrev_entry+0x8b3>
  return count;
  8041601472:	49 63 c6             	movslq %r14d,%rax
      entry += count;
  8041601475:	48 01 c6             	add    %rax,%rsi
  8041601478:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
      if (buf) {
  804160147c:	48 85 db             	test   %rbx,%rbx
  804160147f:	74 1b                	je     804160149c <dwarf_read_abbrev_entry+0x8fc>
        memcpy(buf, entry, MIN(length, bufsize));
  8041601481:	45 39 ec             	cmp    %r13d,%r12d
  8041601484:	44 89 e2             	mov    %r12d,%edx
  8041601487:	41 0f 47 d5          	cmova  %r13d,%edx
  804160148b:	89 d2                	mov    %edx,%edx
  804160148d:	48 89 df             	mov    %rbx,%rdi
  8041601490:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601497:	00 00 00 
  804160149a:	ff d0                	callq  *%rax
      bytes = count + length;
  804160149c:	45 01 f5             	add    %r14d,%r13d
    } break;
  804160149f:	e9 a7 f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      bytes = 0;
  80416014a4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
      if (buf && sizeof(buf) >= sizeof(bool)) {
  80416014aa:	48 85 d2             	test   %rdx,%rdx
  80416014ad:	0f 84 98 f7 ff ff    	je     8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(true, (bool *)buf);
  80416014b3:	c6 02 01             	movb   $0x1,(%rdx)
  80416014b6:	e9 90 f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      uint64_t data = get_unaligned(entry, uint64_t);
  80416014bb:	ba 08 00 00 00       	mov    $0x8,%edx
  80416014c0:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80416014c4:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80416014c8:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416014cf:	00 00 00 
  80416014d2:	ff d0                	callq  *%rax
      entry += sizeof(uint64_t);
  80416014d4:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
      if (buf && bufsize >= sizeof(uint64_t)) {
  80416014d9:	48 85 db             	test   %rbx,%rbx
  80416014dc:	74 06                	je     80416014e4 <dwarf_read_abbrev_entry+0x944>
  80416014de:	41 83 fc 07          	cmp    $0x7,%r12d
  80416014e2:	77 0b                	ja     80416014ef <dwarf_read_abbrev_entry+0x94f>
      bytes = sizeof(uint64_t);
  80416014e4:	41 bd 08 00 00 00    	mov    $0x8,%r13d
  return bytes;
  80416014ea:	e9 5c f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
        put_unaligned(data, (uint64_t *)buf);
  80416014ef:	ba 08 00 00 00       	mov    $0x8,%edx
  80416014f4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80416014f8:	48 89 df             	mov    %rbx,%rdi
  80416014fb:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601502:	00 00 00 
  8041601505:	ff d0                	callq  *%rax
      bytes = sizeof(uint64_t);
  8041601507:	41 bd 08 00 00 00    	mov    $0x8,%r13d
        put_unaligned(data, (uint64_t *)buf);
  804160150d:	e9 39 f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
  int bytes = 0;
  8041601512:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8041601518:	e9 2e f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      bytes = sizeof(Dwarf_Small);
  804160151d:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  8041601523:	e9 23 f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      bytes = sizeof(Dwarf_Small);
  8041601528:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  804160152e:	e9 18 f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>
      bytes = sizeof(Dwarf_Small);
  8041601533:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  8041601539:	e9 0d f7 ff ff       	jmpq   8041600c4b <dwarf_read_abbrev_entry+0xab>

000000804160153e <info_by_address>:
  return 0;
}

int
info_by_address(const struct Dwarf_Addrs *addrs, uintptr_t p,
                Dwarf_Off *store) {
  804160153e:	55                   	push   %rbp
  804160153f:	48 89 e5             	mov    %rsp,%rbp
  8041601542:	41 57                	push   %r15
  8041601544:	41 56                	push   %r14
  8041601546:	41 55                	push   %r13
  8041601548:	41 54                	push   %r12
  804160154a:	53                   	push   %rbx
  804160154b:	48 83 ec 48          	sub    $0x48,%rsp
  804160154f:	48 89 7d b0          	mov    %rdi,-0x50(%rbp)
  8041601553:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8041601557:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  const void *set = addrs->aranges_begin;
  804160155b:	4c 8b 77 10          	mov    0x10(%rdi),%r14
  initial_len = get_unaligned(addr, uint32_t);
  804160155f:	49 bc d0 4a 60 41 80 	movabs $0x8041604ad0,%r12
  8041601566:	00 00 00 
  8041601569:	49 89 f5             	mov    %rsi,%r13
  804160156c:	e9 c8 01 00 00       	jmpq   8041601739 <info_by_address+0x1fb>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041601571:	49 8d 76 20          	lea    0x20(%r14),%rsi
  8041601575:	ba 08 00 00 00       	mov    $0x8,%edx
  804160157a:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160157e:	41 ff d4             	callq  *%r12
  8041601581:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  8041601585:	ba 0c 00 00 00       	mov    $0xc,%edx
  804160158a:	eb 07                	jmp    8041601593 <info_by_address+0x55>
    *len = initial_len;
  804160158c:	89 c0                	mov    %eax,%eax
  count       = 4;
  804160158e:	ba 04 00 00 00       	mov    $0x4,%edx
      set += count;
  8041601593:	48 63 da             	movslq %edx,%rbx
  8041601596:	48 89 5d b8          	mov    %rbx,-0x48(%rbp)
  804160159a:	4d 8d 3c 1e          	lea    (%r14,%rbx,1),%r15
    const void *set_end = set + len;
  804160159e:	49 8d 1c 07          	lea    (%r15,%rax,1),%rbx
    Dwarf_Half version = get_unaligned(set, Dwarf_Half);
  80416015a2:	ba 02 00 00 00       	mov    $0x2,%edx
  80416015a7:	4c 89 fe             	mov    %r15,%rsi
  80416015aa:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416015ae:	41 ff d4             	callq  *%r12
    set += sizeof(Dwarf_Half);
  80416015b1:	49 83 c7 02          	add    $0x2,%r15
    assert(version == 2);
  80416015b5:	66 83 7d c8 02       	cmpw   $0x2,-0x38(%rbp)
  80416015ba:	0f 85 80 00 00 00    	jne    8041601640 <info_by_address+0x102>
    Dwarf_Off offset = get_unaligned(set, uint32_t);
  80416015c0:	ba 04 00 00 00       	mov    $0x4,%edx
  80416015c5:	4c 89 fe             	mov    %r15,%rsi
  80416015c8:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416015cc:	41 ff d4             	callq  *%r12
  80416015cf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80416015d2:	89 45 a8             	mov    %eax,-0x58(%rbp)
    set += count;
  80416015d5:	4c 03 7d b8          	add    -0x48(%rbp),%r15
    Dwarf_Small address_size = get_unaligned(set++, Dwarf_Small);
  80416015d9:	49 8d 47 01          	lea    0x1(%r15),%rax
  80416015dd:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80416015e1:	ba 01 00 00 00       	mov    $0x1,%edx
  80416015e6:	4c 89 fe             	mov    %r15,%rsi
  80416015e9:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416015ed:	41 ff d4             	callq  *%r12
    assert(address_size == 8);
  80416015f0:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  80416015f4:	75 7f                	jne    8041601675 <info_by_address+0x137>
    Dwarf_Small segment_size = get_unaligned(set++, Dwarf_Small);
  80416015f6:	49 83 c7 02          	add    $0x2,%r15
  80416015fa:	ba 01 00 00 00       	mov    $0x1,%edx
  80416015ff:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8041601603:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601607:	41 ff d4             	callq  *%r12
    assert(segment_size == 0);
  804160160a:	80 7d c8 00          	cmpb   $0x0,-0x38(%rbp)
  804160160e:	0f 85 96 00 00 00    	jne    80416016aa <info_by_address+0x16c>
    uint32_t remainder  = (set - header) % entry_size;
  8041601614:	4c 89 f8             	mov    %r15,%rax
  8041601617:	4c 29 f0             	sub    %r14,%rax
  804160161a:	48 99                	cqto   
  804160161c:	48 c1 ea 3c          	shr    $0x3c,%rdx
  8041601620:	48 01 d0             	add    %rdx,%rax
  8041601623:	83 e0 0f             	and    $0xf,%eax
    if (remainder) {
  8041601626:	48 29 d0             	sub    %rdx,%rax
  8041601629:	0f 84 b5 00 00 00    	je     80416016e4 <info_by_address+0x1a6>
      set += 2 * address_size - remainder;
  804160162f:	ba 10 00 00 00       	mov    $0x10,%edx
  8041601634:	89 d1                	mov    %edx,%ecx
  8041601636:	29 c1                	sub    %eax,%ecx
  8041601638:	49 01 cf             	add    %rcx,%r15
  804160163b:	e9 a4 00 00 00       	jmpq   80416016e4 <info_by_address+0x1a6>
    assert(version == 2);
  8041601640:	48 b9 de 50 60 41 80 	movabs $0x80416050de,%rcx
  8041601647:	00 00 00 
  804160164a:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601651:	00 00 00 
  8041601654:	be 20 00 00 00       	mov    $0x20,%esi
  8041601659:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601660:	00 00 00 
  8041601663:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601668:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  804160166f:	00 00 00 
  8041601672:	41 ff d0             	callq  *%r8
    assert(address_size == 8);
  8041601675:	48 b9 9b 50 60 41 80 	movabs $0x804160509b,%rcx
  804160167c:	00 00 00 
  804160167f:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601686:	00 00 00 
  8041601689:	be 24 00 00 00       	mov    $0x24,%esi
  804160168e:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601695:	00 00 00 
  8041601698:	b8 00 00 00 00       	mov    $0x0,%eax
  804160169d:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416016a4:	00 00 00 
  80416016a7:	41 ff d0             	callq  *%r8
    assert(segment_size == 0);
  80416016aa:	48 b9 ad 50 60 41 80 	movabs $0x80416050ad,%rcx
  80416016b1:	00 00 00 
  80416016b4:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416016bb:	00 00 00 
  80416016be:	be 26 00 00 00       	mov    $0x26,%esi
  80416016c3:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416016ca:	00 00 00 
  80416016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  80416016d2:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416016d9:	00 00 00 
  80416016dc:	41 ff d0             	callq  *%r8
    } while (set < set_end);
  80416016df:	4c 39 fb             	cmp    %r15,%rbx
  80416016e2:	76 4d                	jbe    8041601731 <info_by_address+0x1f3>
      addr = (void *)get_unaligned(set, uintptr_t);
  80416016e4:	ba 08 00 00 00       	mov    $0x8,%edx
  80416016e9:	4c 89 fe             	mov    %r15,%rsi
  80416016ec:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416016f0:	41 ff d4             	callq  *%r12
  80416016f3:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
      size = get_unaligned(set, uint32_t);
  80416016f7:	49 8d 77 08          	lea    0x8(%r15),%rsi
  80416016fb:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601700:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601704:	41 ff d4             	callq  *%r12
  8041601707:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804160170a:	49 83 c7 10          	add    $0x10,%r15
      if ((uintptr_t)addr <= p &&
  804160170e:	4d 39 f5             	cmp    %r14,%r13
  8041601711:	72 cc                	jb     80416016df <info_by_address+0x1a1>
      size = get_unaligned(set, uint32_t);
  8041601713:	89 c0                	mov    %eax,%eax
          p <= (uintptr_t)addr + size) {
  8041601715:	49 01 c6             	add    %rax,%r14
      if ((uintptr_t)addr <= p &&
  8041601718:	4d 39 f5             	cmp    %r14,%r13
  804160171b:	77 c2                	ja     80416016df <info_by_address+0x1a1>
    Dwarf_Off offset = get_unaligned(set, uint32_t);
  804160171d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8041601721:	8b 5d a8             	mov    -0x58(%rbp),%ebx
  8041601724:	48 89 18             	mov    %rbx,(%rax)
        return 0;
  8041601727:	b8 00 00 00 00       	mov    $0x0,%eax
  804160172c:	e9 8c 04 00 00       	jmpq   8041601bbd <info_by_address+0x67f>
      set += address_size;
  8041601731:	4d 89 fe             	mov    %r15,%r14
    assert(set == set_end);
  8041601734:	4c 39 fb             	cmp    %r15,%rbx
  8041601737:	75 6e                	jne    80416017a7 <info_by_address+0x269>
  while ((unsigned char *)set < addrs->aranges_end) {
  8041601739:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  804160173d:	4c 3b 70 18          	cmp    0x18(%rax),%r14
  8041601741:	73 3f                	jae    8041601782 <info_by_address+0x244>
  initial_len = get_unaligned(addr, uint32_t);
  8041601743:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601748:	4c 89 f6             	mov    %r14,%rsi
  804160174b:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160174f:	41 ff d4             	callq  *%r12
  8041601752:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601755:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601758:	0f 86 2e fe ff ff    	jbe    804160158c <info_by_address+0x4e>
    if (initial_len == DW_EXT_DWARF64) {
  804160175e:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041601761:	0f 84 0a fe ff ff    	je     8041601571 <info_by_address+0x33>
      cprintf("Unknown DWARF extension\n");
  8041601767:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  804160176e:	00 00 00 
  8041601771:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601776:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160177d:	00 00 00 
  8041601780:	ff d2                	callq  *%rdx
  const void *entry = addrs->info_begin;
  8041601782:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041601786:	48 8b 58 20          	mov    0x20(%rax),%rbx
  804160178a:	48 89 5d b8          	mov    %rbx,-0x48(%rbp)
  while ((unsigned char *)entry < addrs->info_end) {
  804160178e:	48 3b 58 28          	cmp    0x28(%rax),%rbx
  8041601792:	0f 83 55 04 00 00    	jae    8041601bed <info_by_address+0x6af>
        count = dwarf_read_abbrev_entry(
  8041601798:	49 bf a0 0b 60 41 80 	movabs $0x8041600ba0,%r15
  804160179f:	00 00 00 
  80416017a2:	e9 c8 03 00 00       	jmpq   8041601b6f <info_by_address+0x631>
    assert(set == set_end);
  80416017a7:	48 b9 bf 50 60 41 80 	movabs $0x80416050bf,%rcx
  80416017ae:	00 00 00 
  80416017b1:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416017b8:	00 00 00 
  80416017bb:	be 3a 00 00 00       	mov    $0x3a,%esi
  80416017c0:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416017c7:	00 00 00 
  80416017ca:	b8 00 00 00 00       	mov    $0x0,%eax
  80416017cf:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416017d6:	00 00 00 
  80416017d9:	41 ff d0             	callq  *%r8
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416017dc:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80416017e0:	48 8d 70 20          	lea    0x20(%rax),%rsi
  80416017e4:	ba 08 00 00 00       	mov    $0x8,%edx
  80416017e9:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416017ed:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416017f4:	00 00 00 
  80416017f7:	ff d0                	callq  *%rax
  80416017f9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416017fd:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  8041601803:	eb 08                	jmp    804160180d <info_by_address+0x2cf>
    *len = initial_len;
  8041601805:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041601807:	41 bd 04 00 00 00    	mov    $0x4,%r13d
      entry += count;
  804160180d:	4d 63 ed             	movslq %r13d,%r13
  8041601810:	48 8b 5d b8          	mov    -0x48(%rbp),%rbx
  8041601814:	4e 8d 24 2b          	lea    (%rbx,%r13,1),%r12
    const void *entry_end = entry + len;
  8041601818:	4c 01 e0             	add    %r12,%rax
  804160181b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
    Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  804160181f:	ba 02 00 00 00       	mov    $0x2,%edx
  8041601824:	4c 89 e6             	mov    %r12,%rsi
  8041601827:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160182b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601832:	00 00 00 
  8041601835:	ff d0                	callq  *%rax
    entry += sizeof(Dwarf_Half);
  8041601837:	49 83 c4 02          	add    $0x2,%r12
    assert(version == 4 || version == 2);
  804160183b:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  804160183f:	83 e8 02             	sub    $0x2,%eax
  8041601842:	66 a9 fd ff          	test   $0xfffd,%ax
  8041601846:	0f 85 12 01 00 00    	jne    804160195e <info_by_address+0x420>
    Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  804160184c:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601851:	4c 89 e6             	mov    %r12,%rsi
  8041601854:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601858:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  804160185f:	00 00 00 
  8041601862:	ff d0                	callq  *%rax
  8041601864:	8b 5d c8             	mov    -0x38(%rbp),%ebx
    entry += count;
  8041601867:	4b 8d 34 2c          	lea    (%r12,%r13,1),%rsi
    Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  804160186b:	4c 8d 76 01          	lea    0x1(%rsi),%r14
  804160186f:	ba 01 00 00 00       	mov    $0x1,%edx
  8041601874:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601878:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  804160187f:	00 00 00 
  8041601882:	ff d0                	callq  *%rax
    assert(address_size == 8);
  8041601884:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041601888:	0f 85 05 01 00 00    	jne    8041601993 <info_by_address+0x455>
  804160188e:	4c 89 f2             	mov    %r14,%rdx
  count  = 0;
  8041601891:	bf 00 00 00 00       	mov    $0x0,%edi
  shift  = 0;
  8041601896:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160189b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416018a1:	0f b6 32             	movzbl (%rdx),%esi
    addr++;
  80416018a4:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  80416018a8:	83 c7 01             	add    $0x1,%edi
    result |= (byte & 0x7f) << shift;
  80416018ab:	89 f0                	mov    %esi,%eax
  80416018ad:	83 e0 7f             	and    $0x7f,%eax
  80416018b0:	d3 e0                	shl    %cl,%eax
  80416018b2:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  80416018b5:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416018b8:	40 84 f6             	test   %sil,%sil
  80416018bb:	78 e4                	js     80416018a1 <info_by_address+0x363>
  return count;
  80416018bd:	48 63 ff             	movslq %edi,%rdi
    assert(abbrev_code != 0);
  80416018c0:	45 85 c0             	test   %r8d,%r8d
  80416018c3:	0f 84 ff 00 00 00    	je     80416019c8 <info_by_address+0x48a>
    entry += count;
  80416018c9:	49 01 fe             	add    %rdi,%r14
    const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
  80416018cc:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80416018d0:	48 03 18             	add    (%rax),%rbx
  80416018d3:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  80416018d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416018db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  80416018e1:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416018e4:	48 83 c0 01          	add    $0x1,%rax
  80416018e8:	89 c7                	mov    %eax,%edi
  80416018ea:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  80416018ec:	89 f2                	mov    %esi,%edx
  80416018ee:	83 e2 7f             	and    $0x7f,%edx
  80416018f1:	d3 e2                	shl    %cl,%edx
  80416018f3:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  80416018f6:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416018f9:	40 84 f6             	test   %sil,%sil
  80416018fc:	78 e3                	js     80416018e1 <info_by_address+0x3a3>
  return count;
  80416018fe:	48 63 ff             	movslq %edi,%rdi
    abbrev_entry += count;
  8041601901:	48 01 fb             	add    %rdi,%rbx
    assert(table_abbrev_code == abbrev_code);
  8041601904:	45 39 c8             	cmp    %r9d,%r8d
  8041601907:	0f 85 f0 00 00 00    	jne    80416019fd <info_by_address+0x4bf>
  804160190d:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601910:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601915:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  804160191a:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160191d:	48 83 c0 01          	add    $0x1,%rax
  8041601921:	41 89 c0             	mov    %eax,%r8d
  8041601924:	41 29 d8             	sub    %ebx,%r8d
    result |= (byte & 0x7f) << shift;
  8041601927:	89 f2                	mov    %esi,%edx
  8041601929:	83 e2 7f             	and    $0x7f,%edx
  804160192c:	d3 e2                	shl    %cl,%edx
  804160192e:	09 d7                	or     %edx,%edi
    shift += 7;
  8041601930:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601933:	40 84 f6             	test   %sil,%sil
  8041601936:	78 e2                	js     804160191a <info_by_address+0x3dc>
  return count;
  8041601938:	4d 63 c0             	movslq %r8d,%r8
    assert(tag == DW_TAG_compile_unit);
  804160193b:	83 ff 11             	cmp    $0x11,%edi
  804160193e:	0f 85 ee 00 00 00    	jne    8041601a32 <info_by_address+0x4f4>
    abbrev_entry++;
  8041601944:	4a 8d 5c 03 01       	lea    0x1(%rbx,%r8,1),%rbx
    uintptr_t low_pc = 0, high_pc = 0;
  8041601949:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8041601950:	00 
  8041601951:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8041601958:	00 
  8041601959:	e9 4a 01 00 00       	jmpq   8041601aa8 <info_by_address+0x56a>
    assert(version == 4 || version == 2);
  804160195e:	48 b9 ce 50 60 41 80 	movabs $0x80416050ce,%rcx
  8041601965:	00 00 00 
  8041601968:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  804160196f:	00 00 00 
  8041601972:	be 40 01 00 00       	mov    $0x140,%esi
  8041601977:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  804160197e:	00 00 00 
  8041601981:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601986:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  804160198d:	00 00 00 
  8041601990:	41 ff d0             	callq  *%r8
    assert(address_size == 8);
  8041601993:	48 b9 9b 50 60 41 80 	movabs $0x804160509b,%rcx
  804160199a:	00 00 00 
  804160199d:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416019a4:	00 00 00 
  80416019a7:	be 44 01 00 00       	mov    $0x144,%esi
  80416019ac:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416019b3:	00 00 00 
  80416019b6:	b8 00 00 00 00       	mov    $0x0,%eax
  80416019bb:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416019c2:	00 00 00 
  80416019c5:	41 ff d0             	callq  *%r8
    assert(abbrev_code != 0);
  80416019c8:	48 b9 eb 50 60 41 80 	movabs $0x80416050eb,%rcx
  80416019cf:	00 00 00 
  80416019d2:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416019d9:	00 00 00 
  80416019dc:	be 49 01 00 00       	mov    $0x149,%esi
  80416019e1:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416019e8:	00 00 00 
  80416019eb:	b8 00 00 00 00       	mov    $0x0,%eax
  80416019f0:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416019f7:	00 00 00 
  80416019fa:	41 ff d0             	callq  *%r8
    assert(table_abbrev_code == abbrev_code);
  80416019fd:	48 b9 20 52 60 41 80 	movabs $0x8041605220,%rcx
  8041601a04:	00 00 00 
  8041601a07:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601a0e:	00 00 00 
  8041601a11:	be 51 01 00 00       	mov    $0x151,%esi
  8041601a16:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601a1d:	00 00 00 
  8041601a20:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601a25:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601a2c:	00 00 00 
  8041601a2f:	41 ff d0             	callq  *%r8
    assert(tag == DW_TAG_compile_unit);
  8041601a32:	48 b9 fc 50 60 41 80 	movabs $0x80416050fc,%rcx
  8041601a39:	00 00 00 
  8041601a3c:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601a43:	00 00 00 
  8041601a46:	be 55 01 00 00       	mov    $0x155,%esi
  8041601a4b:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601a52:	00 00 00 
  8041601a55:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601a5a:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601a61:	00 00 00 
  8041601a64:	41 ff d0             	callq  *%r8
        count = dwarf_read_abbrev_entry(
  8041601a67:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601a6d:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601a72:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  8041601a76:	44 89 ee             	mov    %r13d,%esi
  8041601a79:	4c 89 f7             	mov    %r14,%rdi
  8041601a7c:	41 ff d7             	callq  *%r15
  8041601a7f:	eb 19                	jmp    8041601a9a <info_by_address+0x55c>
        count = dwarf_read_abbrev_entry(
  8041601a81:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601a87:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041601a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  8041601a91:	44 89 ee             	mov    %r13d,%esi
  8041601a94:	4c 89 f7             	mov    %r14,%rdi
  8041601a97:	41 ff d7             	callq  *%r15
      entry += count;
  8041601a9a:	48 98                	cltq   
  8041601a9c:	49 01 c6             	add    %rax,%r14
    } while (name != 0 || form != 0);
  8041601a9f:	45 09 ec             	or     %r13d,%r12d
  8041601aa2:	0f 84 a5 00 00 00    	je     8041601b4d <info_by_address+0x60f>
  result = 0;
  8041601aa8:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601aab:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601ab0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041601ab6:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601ab9:	48 83 c0 01          	add    $0x1,%rax
  8041601abd:	89 c7                	mov    %eax,%edi
  8041601abf:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601ac1:	89 f2                	mov    %esi,%edx
  8041601ac3:	83 e2 7f             	and    $0x7f,%edx
  8041601ac6:	d3 e2                	shl    %cl,%edx
  8041601ac8:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041601acb:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601ace:	40 84 f6             	test   %sil,%sil
  8041601ad1:	78 e3                	js     8041601ab6 <info_by_address+0x578>
  return count;
  8041601ad3:	48 63 ff             	movslq %edi,%rdi
      abbrev_entry += count;
  8041601ad6:	48 01 fb             	add    %rdi,%rbx
  8041601ad9:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601adc:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601ae1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041601ae7:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601aea:	48 83 c0 01          	add    $0x1,%rax
  8041601aee:	89 c7                	mov    %eax,%edi
  8041601af0:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601af2:	89 f2                	mov    %esi,%edx
  8041601af4:	83 e2 7f             	and    $0x7f,%edx
  8041601af7:	d3 e2                	shl    %cl,%edx
  8041601af9:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041601afc:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601aff:	40 84 f6             	test   %sil,%sil
  8041601b02:	78 e3                	js     8041601ae7 <info_by_address+0x5a9>
  return count;
  8041601b04:	48 63 ff             	movslq %edi,%rdi
      abbrev_entry += count;
  8041601b07:	48 01 fb             	add    %rdi,%rbx
      if (name == DW_AT_low_pc) {
  8041601b0a:	41 83 fc 11          	cmp    $0x11,%r12d
  8041601b0e:	0f 84 53 ff ff ff    	je     8041601a67 <info_by_address+0x529>
      } else if (name == DW_AT_high_pc) {
  8041601b14:	41 83 fc 12          	cmp    $0x12,%r12d
  8041601b18:	0f 85 63 ff ff ff    	jne    8041601a81 <info_by_address+0x543>
        count = dwarf_read_abbrev_entry(
  8041601b1e:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601b24:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601b29:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8041601b2d:	44 89 ee             	mov    %r13d,%esi
  8041601b30:	4c 89 f7             	mov    %r14,%rdi
  8041601b33:	41 ff d7             	callq  *%r15
        if (form != DW_FORM_addr) {
  8041601b36:	41 83 fd 01          	cmp    $0x1,%r13d
  8041601b3a:	0f 84 b4 00 00 00    	je     8041601bf4 <info_by_address+0x6b6>
          high_pc += low_pc;
  8041601b40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8041601b44:	48 01 55 c8          	add    %rdx,-0x38(%rbp)
  8041601b48:	e9 4d ff ff ff       	jmpq   8041601a9a <info_by_address+0x55c>
    if (p >= low_pc && p <= high_pc) {
  8041601b4d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8041601b51:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8041601b55:	72 06                	jb     8041601b5d <info_by_address+0x61f>
  8041601b57:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041601b5b:	76 6f                	jbe    8041601bcc <info_by_address+0x68e>
    entry = entry_end;
  8041601b5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041601b61:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  while ((unsigned char *)entry < addrs->info_end) {
  8041601b65:	48 8b 5d b0          	mov    -0x50(%rbp),%rbx
  8041601b69:	48 3b 43 28          	cmp    0x28(%rbx),%rax
  8041601b6d:	73 77                	jae    8041601be6 <info_by_address+0x6a8>
  initial_len = get_unaligned(addr, uint32_t);
  8041601b6f:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601b74:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8041601b78:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601b7c:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601b83:	00 00 00 
  8041601b86:	ff d0                	callq  *%rax
  8041601b88:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601b8b:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601b8e:	0f 86 71 fc ff ff    	jbe    8041601805 <info_by_address+0x2c7>
    if (initial_len == DW_EXT_DWARF64) {
  8041601b94:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041601b97:	0f 84 3f fc ff ff    	je     80416017dc <info_by_address+0x29e>
      cprintf("Unknown DWARF extension\n");
  8041601b9d:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  8041601ba4:	00 00 00 
  8041601ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601bac:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041601bb3:	00 00 00 
  8041601bb6:	ff d2                	callq  *%rdx
      return -E_BAD_DWARF;
  8041601bb8:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  int code = info_by_address_debug_aranges(addrs, p, store);
  if (code < 0) {
    code = info_by_address_debug_info(addrs, p, store);
  }
  return code;
}
  8041601bbd:	48 83 c4 48          	add    $0x48,%rsp
  8041601bc1:	5b                   	pop    %rbx
  8041601bc2:	41 5c                	pop    %r12
  8041601bc4:	41 5d                	pop    %r13
  8041601bc6:	41 5e                	pop    %r14
  8041601bc8:	41 5f                	pop    %r15
  8041601bca:	5d                   	pop    %rbp
  8041601bcb:	c3                   	retq   
          (const unsigned char *)header - addrs->info_begin;
  8041601bcc:	48 8b 5d b0          	mov    -0x50(%rbp),%rbx
  8041601bd0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8041601bd4:	48 2b 43 20          	sub    0x20(%rbx),%rax
      *store =
  8041601bd8:	48 8b 5d 98          	mov    -0x68(%rbp),%rbx
  8041601bdc:	48 89 03             	mov    %rax,(%rbx)
      return 0;
  8041601bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601be4:	eb d7                	jmp    8041601bbd <info_by_address+0x67f>
  return 0;
  8041601be6:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601beb:	eb d0                	jmp    8041601bbd <info_by_address+0x67f>
  8041601bed:	b8 00 00 00 00       	mov    $0x0,%eax
  return code;
  8041601bf2:	eb c9                	jmp    8041601bbd <info_by_address+0x67f>
      entry += count;
  8041601bf4:	48 98                	cltq   
  8041601bf6:	49 01 c6             	add    %rax,%r14
  8041601bf9:	e9 aa fe ff ff       	jmpq   8041601aa8 <info_by_address+0x56a>

0000008041601bfe <file_name_by_info>:

int
file_name_by_info(const struct Dwarf_Addrs *addrs, Dwarf_Off offset,
                  char *buf, int buflen, Dwarf_Off *line_off) {
  8041601bfe:	55                   	push   %rbp
  8041601bff:	48 89 e5             	mov    %rsp,%rbp
  8041601c02:	41 57                	push   %r15
  8041601c04:	41 56                	push   %r14
  8041601c06:	41 55                	push   %r13
  8041601c08:	41 54                	push   %r12
  8041601c0a:	53                   	push   %rbx
  8041601c0b:	48 83 ec 38          	sub    $0x38,%rsp
  if (offset > addrs->info_end - addrs->info_begin) {
  8041601c0f:	48 8b 5f 20          	mov    0x20(%rdi),%rbx
  8041601c13:	48 8b 47 28          	mov    0x28(%rdi),%rax
  8041601c17:	48 29 d8             	sub    %rbx,%rax
  8041601c1a:	48 39 f0             	cmp    %rsi,%rax
  8041601c1d:	0f 82 e6 02 00 00    	jb     8041601f09 <file_name_by_info+0x30b>
  8041601c23:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
  8041601c27:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
  8041601c2a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8041601c2e:	48 89 7d a0          	mov    %rdi,-0x60(%rbp)
    return -E_INVAL;
  }
  const void *entry = addrs->info_begin + offset;
  8041601c32:	48 01 f3             	add    %rsi,%rbx
  initial_len = get_unaligned(addr, uint32_t);
  8041601c35:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601c3a:	48 89 de             	mov    %rbx,%rsi
  8041601c3d:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601c41:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601c48:	00 00 00 
  8041601c4b:	ff d0                	callq  *%rax
  8041601c4d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041601c50:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041601c53:	0f 86 b7 02 00 00    	jbe    8041601f10 <file_name_by_info+0x312>
    if (initial_len == DW_EXT_DWARF64) {
  8041601c59:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041601c5c:	74 25                	je     8041601c83 <file_name_by_info+0x85>
      cprintf("Unknown DWARF extension\n");
  8041601c5e:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  8041601c65:	00 00 00 
  8041601c68:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601c6d:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041601c74:	00 00 00 
  8041601c77:	ff d2                	callq  *%rdx
  int count         = 0;
  unsigned long len = 0;
  count             = dwarf_entry_len(entry, &len);
  if (count == 0) {
    return -E_BAD_DWARF;
  8041601c79:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  8041601c7e:	e9 77 02 00 00       	jmpq   8041601efa <file_name_by_info+0x2fc>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041601c83:	48 8d 73 20          	lea    0x20(%rbx),%rsi
  8041601c87:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601c8c:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601c90:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601c97:	00 00 00 
  8041601c9a:	ff d0                	callq  *%rax
      count = 12;
  8041601c9c:	41 bd 0c 00 00 00    	mov    $0xc,%r13d
  8041601ca2:	e9 6f 02 00 00       	jmpq   8041601f16 <file_name_by_info+0x318>
  }

  // Parse compilation unit header.
  Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  entry += sizeof(Dwarf_Half);
  assert(version == 4 || version == 2);
  8041601ca7:	48 b9 ce 50 60 41 80 	movabs $0x80416050ce,%rcx
  8041601cae:	00 00 00 
  8041601cb1:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601cb8:	00 00 00 
  8041601cbb:	be 98 01 00 00       	mov    $0x198,%esi
  8041601cc0:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601cc7:	00 00 00 
  8041601cca:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601ccf:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601cd6:	00 00 00 
  8041601cd9:	41 ff d0             	callq  *%r8
  Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  entry += count;
  Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  assert(address_size == 8);
  8041601cdc:	48 b9 9b 50 60 41 80 	movabs $0x804160509b,%rcx
  8041601ce3:	00 00 00 
  8041601ce6:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601ced:	00 00 00 
  8041601cf0:	be 9c 01 00 00       	mov    $0x19c,%esi
  8041601cf5:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601cfc:	00 00 00 
  8041601cff:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601d04:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601d0b:	00 00 00 
  8041601d0e:	41 ff d0             	callq  *%r8

  // Read abbreviation code
  unsigned abbrev_code = 0;
  count                = dwarf_read_uleb128(entry, &abbrev_code);
  assert(abbrev_code != 0);
  8041601d11:	48 b9 eb 50 60 41 80 	movabs $0x80416050eb,%rcx
  8041601d18:	00 00 00 
  8041601d1b:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601d22:	00 00 00 
  8041601d25:	be a1 01 00 00       	mov    $0x1a1,%esi
  8041601d2a:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601d31:	00 00 00 
  8041601d34:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601d39:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601d40:	00 00 00 
  8041601d43:	41 ff d0             	callq  *%r8
  // Read abbreviations table
  const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
  unsigned table_abbrev_code = 0;
  count                      = dwarf_read_uleb128(abbrev_entry, &table_abbrev_code);
  abbrev_entry += count;
  assert(table_abbrev_code == abbrev_code);
  8041601d46:	48 b9 20 52 60 41 80 	movabs $0x8041605220,%rcx
  8041601d4d:	00 00 00 
  8041601d50:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601d57:	00 00 00 
  8041601d5a:	be a9 01 00 00       	mov    $0x1a9,%esi
  8041601d5f:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601d66:	00 00 00 
  8041601d69:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601d6e:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601d75:	00 00 00 
  8041601d78:	41 ff d0             	callq  *%r8
  unsigned tag = 0;
  count        = dwarf_read_uleb128(abbrev_entry, &tag);
  abbrev_entry += count;
  assert(tag == DW_TAG_compile_unit);
  8041601d7b:	48 b9 fc 50 60 41 80 	movabs $0x80416050fc,%rcx
  8041601d82:	00 00 00 
  8041601d85:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041601d8c:	00 00 00 
  8041601d8f:	be ad 01 00 00       	mov    $0x1ad,%esi
  8041601d94:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041601d9b:	00 00 00 
  8041601d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  8041601da3:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041601daa:	00 00 00 
  8041601dad:	41 ff d0             	callq  *%r8
    count = dwarf_read_uleb128(abbrev_entry, &name);
    abbrev_entry += count;
    count = dwarf_read_uleb128(abbrev_entry, &form);
    abbrev_entry += count;
    if (name == DW_AT_name) {
      if (form == DW_FORM_strp) {
  8041601db0:	41 83 fd 0e          	cmp    $0xe,%r13d
  8041601db4:	0f 84 b8 00 00 00    	je     8041601e72 <file_name_by_info+0x274>
                  offset,
              (char **)buf);
#pragma GCC diagnostic pop
        }
      } else {
        count = dwarf_read_abbrev_entry(
  8041601dba:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601dc0:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
  8041601dc3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8041601dc7:	44 89 ee             	mov    %r13d,%esi
  8041601dca:	4c 89 f7             	mov    %r14,%rdi
  8041601dcd:	41 ff d7             	callq  *%r15
                                      address_size);
    } else {
      count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
                                      address_size);
    }
    entry += count;
  8041601dd0:	48 98                	cltq   
  8041601dd2:	49 01 c6             	add    %rax,%r14
  } while (name != 0 || form != 0);
  8041601dd5:	45 09 e5             	or     %r12d,%r13d
  8041601dd8:	0f 84 17 01 00 00    	je     8041601ef5 <file_name_by_info+0x2f7>
  result = 0;
  8041601dde:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601de1:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601de6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041601dec:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601def:	48 83 c0 01          	add    $0x1,%rax
  8041601df3:	89 c7                	mov    %eax,%edi
  8041601df5:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601df7:	89 f2                	mov    %esi,%edx
  8041601df9:	83 e2 7f             	and    $0x7f,%edx
  8041601dfc:	d3 e2                	shl    %cl,%edx
  8041601dfe:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041601e01:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601e04:	40 84 f6             	test   %sil,%sil
  8041601e07:	78 e3                	js     8041601dec <file_name_by_info+0x1ee>
  return count;
  8041601e09:	48 63 ff             	movslq %edi,%rdi
    abbrev_entry += count;
  8041601e0c:	48 01 fb             	add    %rdi,%rbx
  8041601e0f:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041601e12:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601e17:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041601e1d:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601e20:	48 83 c0 01          	add    $0x1,%rax
  8041601e24:	89 c7                	mov    %eax,%edi
  8041601e26:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041601e28:	89 f2                	mov    %esi,%edx
  8041601e2a:	83 e2 7f             	and    $0x7f,%edx
  8041601e2d:	d3 e2                	shl    %cl,%edx
  8041601e2f:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041601e32:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601e35:	40 84 f6             	test   %sil,%sil
  8041601e38:	78 e3                	js     8041601e1d <file_name_by_info+0x21f>
  return count;
  8041601e3a:	48 63 ff             	movslq %edi,%rdi
    abbrev_entry += count;
  8041601e3d:	48 01 fb             	add    %rdi,%rbx
    if (name == DW_AT_name) {
  8041601e40:	41 83 fc 03          	cmp    $0x3,%r12d
  8041601e44:	0f 84 66 ff ff ff    	je     8041601db0 <file_name_by_info+0x1b2>
    } else if (name == DW_AT_stmt_list) {
  8041601e4a:	41 83 fc 10          	cmp    $0x10,%r12d
  8041601e4e:	0f 84 84 00 00 00    	je     8041601ed8 <file_name_by_info+0x2da>
      count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
  8041601e54:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041601e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  8041601e64:	44 89 ee             	mov    %r13d,%esi
  8041601e67:	4c 89 f7             	mov    %r14,%rdi
  8041601e6a:	41 ff d7             	callq  *%r15
  8041601e6d:	e9 5e ff ff ff       	jmpq   8041601dd0 <file_name_by_info+0x1d2>
        unsigned long offset = 0;
  8041601e72:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8041601e79:	00 
        count                = dwarf_read_abbrev_entry(
  8041601e7a:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601e80:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601e85:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  8041601e89:	be 0e 00 00 00       	mov    $0xe,%esi
  8041601e8e:	4c 89 f7             	mov    %r14,%rdi
  8041601e91:	41 ff d7             	callq  *%r15
  8041601e94:	41 89 c4             	mov    %eax,%r12d
        if (buf && buflen >= sizeof(const char **)) {
  8041601e97:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8041601e9b:	48 85 ff             	test   %rdi,%rdi
  8041601e9e:	74 06                	je     8041601ea6 <file_name_by_info+0x2a8>
  8041601ea0:	83 7d b4 07          	cmpl   $0x7,-0x4c(%rbp)
  8041601ea4:	77 0b                	ja     8041601eb1 <file_name_by_info+0x2b3>
    entry += count;
  8041601ea6:	4d 63 e4             	movslq %r12d,%r12
  8041601ea9:	4d 01 e6             	add    %r12,%r14
  8041601eac:	e9 2d ff ff ff       	jmpq   8041601dde <file_name_by_info+0x1e0>
          put_unaligned(
  8041601eb1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041601eb5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8041601eb9:	48 03 41 40          	add    0x40(%rcx),%rax
  8041601ebd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8041601ec1:	ba 08 00 00 00       	mov    $0x8,%edx
  8041601ec6:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8041601eca:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601ed1:	00 00 00 
  8041601ed4:	ff d0                	callq  *%rax
  8041601ed6:	eb ce                	jmp    8041601ea6 <file_name_by_info+0x2a8>
      count = dwarf_read_abbrev_entry(entry, form, line_off,
  8041601ed8:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041601ede:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041601ee3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8041601ee7:	44 89 ee             	mov    %r13d,%esi
  8041601eea:	4c 89 f7             	mov    %r14,%rdi
  8041601eed:	41 ff d7             	callq  *%r15
  8041601ef0:	e9 db fe ff ff       	jmpq   8041601dd0 <file_name_by_info+0x1d2>

  return 0;
  8041601ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041601efa:	48 83 c4 38          	add    $0x38,%rsp
  8041601efe:	5b                   	pop    %rbx
  8041601eff:	41 5c                	pop    %r12
  8041601f01:	41 5d                	pop    %r13
  8041601f03:	41 5e                	pop    %r14
  8041601f05:	41 5f                	pop    %r15
  8041601f07:	5d                   	pop    %rbp
  8041601f08:	c3                   	retq   
    return -E_INVAL;
  8041601f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041601f0e:	eb ea                	jmp    8041601efa <file_name_by_info+0x2fc>
  count       = 4;
  8041601f10:	41 bd 04 00 00 00    	mov    $0x4,%r13d
    entry += count;
  8041601f16:	4d 63 ed             	movslq %r13d,%r13
  8041601f19:	4c 01 eb             	add    %r13,%rbx
  Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  8041601f1c:	ba 02 00 00 00       	mov    $0x2,%edx
  8041601f21:	48 89 de             	mov    %rbx,%rsi
  8041601f24:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601f28:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041601f2f:	00 00 00 
  8041601f32:	ff d0                	callq  *%rax
  entry += sizeof(Dwarf_Half);
  8041601f34:	48 83 c3 02          	add    $0x2,%rbx
  assert(version == 4 || version == 2);
  8041601f38:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041601f3c:	83 e8 02             	sub    $0x2,%eax
  8041601f3f:	66 a9 fd ff          	test   $0xfffd,%ax
  8041601f43:	0f 85 5e fd ff ff    	jne    8041601ca7 <file_name_by_info+0xa9>
  Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041601f49:	ba 04 00 00 00       	mov    $0x4,%edx
  8041601f4e:	48 89 de             	mov    %rbx,%rsi
  8041601f51:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601f55:	49 bf d0 4a 60 41 80 	movabs $0x8041604ad0,%r15
  8041601f5c:	00 00 00 
  8041601f5f:	41 ff d7             	callq  *%r15
  8041601f62:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
  entry += count;
  8041601f66:	4a 8d 34 2b          	lea    (%rbx,%r13,1),%rsi
  Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041601f6a:	4c 8d 76 01          	lea    0x1(%rsi),%r14
  8041601f6e:	ba 01 00 00 00       	mov    $0x1,%edx
  8041601f73:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041601f77:	41 ff d7             	callq  *%r15
  assert(address_size == 8);
  8041601f7a:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041601f7e:	0f 85 58 fd ff ff    	jne    8041601cdc <file_name_by_info+0xde>
  8041601f84:	4c 89 f2             	mov    %r14,%rdx
  count  = 0;
  8041601f87:	bf 00 00 00 00       	mov    $0x0,%edi
  shift  = 0;
  8041601f8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601f91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  8041601f97:	0f b6 32             	movzbl (%rdx),%esi
    addr++;
  8041601f9a:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  8041601f9e:	83 c7 01             	add    $0x1,%edi
    result |= (byte & 0x7f) << shift;
  8041601fa1:	89 f0                	mov    %esi,%eax
  8041601fa3:	83 e0 7f             	and    $0x7f,%eax
  8041601fa6:	d3 e0                	shl    %cl,%eax
  8041601fa8:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  8041601fab:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601fae:	40 84 f6             	test   %sil,%sil
  8041601fb1:	78 e4                	js     8041601f97 <file_name_by_info+0x399>
  return count;
  8041601fb3:	48 63 ff             	movslq %edi,%rdi
  assert(abbrev_code != 0);
  8041601fb6:	45 85 c0             	test   %r8d,%r8d
  8041601fb9:	0f 84 52 fd ff ff    	je     8041601d11 <file_name_by_info+0x113>
  entry += count;
  8041601fbf:	49 01 fe             	add    %rdi,%r14
  const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
  8041601fc2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8041601fc6:	4c 03 20             	add    (%rax),%r12
  8041601fc9:	4c 89 e0             	mov    %r12,%rax
  shift  = 0;
  8041601fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041601fd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  8041601fd7:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041601fda:	48 83 c0 01          	add    $0x1,%rax
  8041601fde:	89 c7                	mov    %eax,%edi
  8041601fe0:	44 29 e7             	sub    %r12d,%edi
    result |= (byte & 0x7f) << shift;
  8041601fe3:	89 f2                	mov    %esi,%edx
  8041601fe5:	83 e2 7f             	and    $0x7f,%edx
  8041601fe8:	d3 e2                	shl    %cl,%edx
  8041601fea:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  8041601fed:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041601ff0:	40 84 f6             	test   %sil,%sil
  8041601ff3:	78 e2                	js     8041601fd7 <file_name_by_info+0x3d9>
  return count;
  8041601ff5:	48 63 ff             	movslq %edi,%rdi
  abbrev_entry += count;
  8041601ff8:	49 01 fc             	add    %rdi,%r12
  assert(table_abbrev_code == abbrev_code);
  8041601ffb:	45 39 c8             	cmp    %r9d,%r8d
  8041601ffe:	0f 85 42 fd ff ff    	jne    8041601d46 <file_name_by_info+0x148>
  8041602004:	4c 89 e0             	mov    %r12,%rax
  shift  = 0;
  8041602007:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160200c:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602011:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602014:	48 83 c0 01          	add    $0x1,%rax
  8041602018:	41 89 c0             	mov    %eax,%r8d
  804160201b:	45 29 e0             	sub    %r12d,%r8d
    result |= (byte & 0x7f) << shift;
  804160201e:	89 f2                	mov    %esi,%edx
  8041602020:	83 e2 7f             	and    $0x7f,%edx
  8041602023:	d3 e2                	shl    %cl,%edx
  8041602025:	09 d7                	or     %edx,%edi
    shift += 7;
  8041602027:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160202a:	40 84 f6             	test   %sil,%sil
  804160202d:	78 e2                	js     8041602011 <file_name_by_info+0x413>
  return count;
  804160202f:	4d 63 c0             	movslq %r8d,%r8
  assert(tag == DW_TAG_compile_unit);
  8041602032:	83 ff 11             	cmp    $0x11,%edi
  8041602035:	0f 85 40 fd ff ff    	jne    8041601d7b <file_name_by_info+0x17d>
  abbrev_entry++;
  804160203b:	4b 8d 5c 04 01       	lea    0x1(%r12,%r8,1),%rbx
      count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
  8041602040:	49 bf a0 0b 60 41 80 	movabs $0x8041600ba0,%r15
  8041602047:	00 00 00 
  804160204a:	e9 8f fd ff ff       	jmpq   8041601dde <file_name_by_info+0x1e0>

000000804160204f <function_by_info>:

int
function_by_info(const struct Dwarf_Addrs *addrs, uintptr_t p,
                 Dwarf_Off cu_offset, char *buf, int buflen,
                 uintptr_t *offset) {
  804160204f:	55                   	push   %rbp
  8041602050:	48 89 e5             	mov    %rsp,%rbp
  8041602053:	41 57                	push   %r15
  8041602055:	41 56                	push   %r14
  8041602057:	41 55                	push   %r13
  8041602059:	41 54                	push   %r12
  804160205b:	53                   	push   %rbx
  804160205c:	48 83 ec 68          	sub    $0x68,%rsp
  8041602060:	48 89 7d 90          	mov    %rdi,-0x70(%rbp)
  8041602064:	48 89 b5 78 ff ff ff 	mov    %rsi,-0x88(%rbp)
  804160206b:	48 89 4d 88          	mov    %rcx,-0x78(%rbp)
  804160206f:	44 89 45 a0          	mov    %r8d,-0x60(%rbp)
  8041602073:	4c 89 8d 70 ff ff ff 	mov    %r9,-0x90(%rbp)
  const void *entry = addrs->info_begin + cu_offset;
  804160207a:	48 89 d3             	mov    %rdx,%rbx
  804160207d:	48 03 5f 20          	add    0x20(%rdi),%rbx
  initial_len = get_unaligned(addr, uint32_t);
  8041602081:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602086:	48 89 de             	mov    %rbx,%rsi
  8041602089:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160208d:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602094:	00 00 00 
  8041602097:	ff d0                	callq  *%rax
  8041602099:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  804160209c:	83 f8 ef             	cmp    $0xffffffef,%eax
  804160209f:	76 59                	jbe    80416020fa <function_by_info+0xab>
    if (initial_len == DW_EXT_DWARF64) {
  80416020a1:	83 f8 ff             	cmp    $0xffffffff,%eax
  80416020a4:	74 2f                	je     80416020d5 <function_by_info+0x86>
      cprintf("Unknown DWARF extension\n");
  80416020a6:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  80416020ad:	00 00 00 
  80416020b0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416020b5:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416020bc:	00 00 00 
  80416020bf:	ff d2                	callq  *%rdx
  int count         = 0;
  unsigned long len = 0;
  count             = dwarf_entry_len(entry, &len);
  if (count == 0) {
    return -E_BAD_DWARF;
  80416020c1:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
        entry += count;
      } while (name != 0 || form != 0);
    }
  }
  return 0;
}
  80416020c6:	48 83 c4 68          	add    $0x68,%rsp
  80416020ca:	5b                   	pop    %rbx
  80416020cb:	41 5c                	pop    %r12
  80416020cd:	41 5d                	pop    %r13
  80416020cf:	41 5e                	pop    %r14
  80416020d1:	41 5f                	pop    %r15
  80416020d3:	5d                   	pop    %rbp
  80416020d4:	c3                   	retq   
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416020d5:	48 8d 73 20          	lea    0x20(%rbx),%rsi
  80416020d9:	ba 08 00 00 00       	mov    $0x8,%edx
  80416020de:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416020e2:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416020e9:	00 00 00 
  80416020ec:	ff d0                	callq  *%rax
  80416020ee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416020f2:	41 be 0c 00 00 00    	mov    $0xc,%r14d
  80416020f8:	eb 08                	jmp    8041602102 <function_by_info+0xb3>
    *len = initial_len;
  80416020fa:	89 c0                	mov    %eax,%eax
  count       = 4;
  80416020fc:	41 be 04 00 00 00    	mov    $0x4,%r14d
  entry += count;
  8041602102:	4d 63 f6             	movslq %r14d,%r14
  8041602105:	4c 01 f3             	add    %r14,%rbx
  const void *entry_end = entry + len;
  8041602108:	48 01 d8             	add    %rbx,%rax
  804160210b:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  804160210f:	ba 02 00 00 00       	mov    $0x2,%edx
  8041602114:	48 89 de             	mov    %rbx,%rsi
  8041602117:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160211b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602122:	00 00 00 
  8041602125:	ff d0                	callq  *%rax
  entry += sizeof(Dwarf_Half);
  8041602127:	48 83 c3 02          	add    $0x2,%rbx
  assert(version == 4 || version == 2);
  804160212b:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  804160212f:	83 e8 02             	sub    $0x2,%eax
  8041602132:	66 a9 fd ff          	test   $0xfffd,%ax
  8041602136:	75 51                	jne    8041602189 <function_by_info+0x13a>
  Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041602138:	ba 04 00 00 00       	mov    $0x4,%edx
  804160213d:	48 89 de             	mov    %rbx,%rsi
  8041602140:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602144:	49 bc d0 4a 60 41 80 	movabs $0x8041604ad0,%r12
  804160214b:	00 00 00 
  804160214e:	41 ff d4             	callq  *%r12
  8041602151:	44 8b 6d c8          	mov    -0x38(%rbp),%r13d
  entry += count;
  8041602155:	4a 8d 34 33          	lea    (%rbx,%r14,1),%rsi
  Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041602159:	4c 8d 76 01          	lea    0x1(%rsi),%r14
  804160215d:	ba 01 00 00 00       	mov    $0x1,%edx
  8041602162:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602166:	41 ff d4             	callq  *%r12
  assert(address_size == 8);
  8041602169:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  804160216d:	75 4f                	jne    80416021be <function_by_info+0x16f>
  const void *abbrev_entry      = addrs->abbrev_begin + abbrev_offset;
  804160216f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8041602173:	4c 03 28             	add    (%rax),%r13
  8041602176:	4c 89 6d 80          	mov    %r13,-0x80(%rbp)
        count = dwarf_read_abbrev_entry(
  804160217a:	49 bf a0 0b 60 41 80 	movabs $0x8041600ba0,%r15
  8041602181:	00 00 00 
  while (entry < entry_end) {
  8041602184:	e9 ff 00 00 00       	jmpq   8041602288 <function_by_info+0x239>
  assert(version == 4 || version == 2);
  8041602189:	48 b9 ce 50 60 41 80 	movabs $0x80416050ce,%rcx
  8041602190:	00 00 00 
  8041602193:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  804160219a:	00 00 00 
  804160219d:	be e6 01 00 00       	mov    $0x1e6,%esi
  80416021a2:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416021a9:	00 00 00 
  80416021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  80416021b1:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416021b8:	00 00 00 
  80416021bb:	41 ff d0             	callq  *%r8
  assert(address_size == 8);
  80416021be:	48 b9 9b 50 60 41 80 	movabs $0x804160509b,%rcx
  80416021c5:	00 00 00 
  80416021c8:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416021cf:	00 00 00 
  80416021d2:	be ea 01 00 00       	mov    $0x1ea,%esi
  80416021d7:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416021de:	00 00 00 
  80416021e1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416021e6:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416021ed:	00 00 00 
  80416021f0:	41 ff d0             	callq  *%r8
  80416021f3:	48 89 c3             	mov    %rax,%rbx
    if (tag == DW_TAG_subprogram) {
  80416021f6:	83 ff 2e             	cmp    $0x2e,%edi
  80416021f9:	0f 84 ca 01 00 00    	je     80416023c9 <function_by_info+0x37a>
            fn_name_entry = entry;
  80416021ff:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602202:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602207:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  804160220d:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602210:	48 83 c0 01          	add    $0x1,%rax
  8041602214:	89 c7                	mov    %eax,%edi
  8041602216:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602218:	89 f2                	mov    %esi,%edx
  804160221a:	83 e2 7f             	and    $0x7f,%edx
  804160221d:	d3 e2                	shl    %cl,%edx
  804160221f:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602222:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602225:	40 84 f6             	test   %sil,%sil
  8041602228:	78 e3                	js     804160220d <function_by_info+0x1be>
  return count;
  804160222a:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160222d:	48 01 fb             	add    %rdi,%rbx
  8041602230:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602233:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602238:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  804160223e:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602241:	48 83 c0 01          	add    $0x1,%rax
  8041602245:	89 c7                	mov    %eax,%edi
  8041602247:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602249:	89 f2                	mov    %esi,%edx
  804160224b:	83 e2 7f             	and    $0x7f,%edx
  804160224e:	d3 e2                	shl    %cl,%edx
  8041602250:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602253:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602256:	40 84 f6             	test   %sil,%sil
  8041602259:	78 e3                	js     804160223e <function_by_info+0x1ef>
  return count;
  804160225b:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160225e:	48 01 fb             	add    %rdi,%rbx
        count = dwarf_read_abbrev_entry(
  8041602261:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602267:	b9 00 00 00 00       	mov    $0x0,%ecx
  804160226c:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602271:	44 89 e6             	mov    %r12d,%esi
  8041602274:	4c 89 f7             	mov    %r14,%rdi
  8041602277:	41 ff d7             	callq  *%r15
        entry += count;
  804160227a:	48 98                	cltq   
  804160227c:	49 01 c6             	add    %rax,%r14
      } while (name != 0 || form != 0);
  804160227f:	45 09 ec             	or     %r13d,%r12d
  8041602282:	0f 85 77 ff ff ff    	jne    80416021ff <function_by_info+0x1b0>
  while (entry < entry_end) {
  8041602288:	4c 3b 75 98          	cmp    -0x68(%rbp),%r14
  804160228c:	0f 83 11 03 00 00    	jae    80416025a3 <function_by_info+0x554>
                 uintptr_t *offset) {
  8041602292:	4c 89 f0             	mov    %r14,%rax
  shift  = 0;
  8041602295:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  804160229a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416022a0:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  80416022a3:	48 83 c0 01          	add    $0x1,%rax
  80416022a7:	89 c7                	mov    %eax,%edi
  80416022a9:	44 29 f7             	sub    %r14d,%edi
    result |= (byte & 0x7f) << shift;
  80416022ac:	89 f2                	mov    %esi,%edx
  80416022ae:	83 e2 7f             	and    $0x7f,%edx
  80416022b1:	d3 e2                	shl    %cl,%edx
  80416022b3:	41 09 d0             	or     %edx,%r8d
    shift += 7;
  80416022b6:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416022b9:	40 84 f6             	test   %sil,%sil
  80416022bc:	78 e2                	js     80416022a0 <function_by_info+0x251>
  return count;
  80416022be:	48 63 ff             	movslq %edi,%rdi
    entry += count;
  80416022c1:	49 01 fe             	add    %rdi,%r14
    if (abbrev_code == 0) {
  80416022c4:	45 85 c0             	test   %r8d,%r8d
  80416022c7:	0f 84 e0 02 00 00    	je     80416025ad <function_by_info+0x55e>
           addrs->abbrev_end) { // unsafe needs to be replaced
  80416022cd:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80416022d1:	4c 8b 48 08          	mov    0x8(%rax),%r9
    curr_abbrev_entry = abbrev_entry;
  80416022d5:	48 8b 5d 80          	mov    -0x80(%rbp),%rbx
    unsigned name = 0, form = 0, tag = 0;
  80416022d9:	bf 00 00 00 00       	mov    $0x0,%edi
  80416022de:	48 89 d8             	mov    %rbx,%rax
    while ((const unsigned char *)curr_abbrev_entry <
  80416022e1:	49 39 c1             	cmp    %rax,%r9
  80416022e4:	0f 86 09 ff ff ff    	jbe    80416021f3 <function_by_info+0x1a4>
  80416022ea:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  80416022ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416022f2:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    byte = *addr;
  80416022f8:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  80416022fb:	48 83 c2 01          	add    $0x1,%rdx
  80416022ff:	41 89 d3             	mov    %edx,%r11d
  8041602302:	41 29 c3             	sub    %eax,%r11d
    result |= (byte & 0x7f) << shift;
  8041602305:	89 fe                	mov    %edi,%esi
  8041602307:	83 e6 7f             	and    $0x7f,%esi
  804160230a:	d3 e6                	shl    %cl,%esi
  804160230c:	41 09 f2             	or     %esi,%r10d
    shift += 7;
  804160230f:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602312:	40 84 ff             	test   %dil,%dil
  8041602315:	78 e1                	js     80416022f8 <function_by_info+0x2a9>
  return count;
  8041602317:	4d 63 db             	movslq %r11d,%r11
      curr_abbrev_entry += count;
  804160231a:	49 01 c3             	add    %rax,%r11
  804160231d:	4c 89 d8             	mov    %r11,%rax
  shift  = 0;
  8041602320:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602325:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  804160232a:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160232d:	48 83 c0 01          	add    $0x1,%rax
  8041602331:	89 c3                	mov    %eax,%ebx
  8041602333:	44 29 db             	sub    %r11d,%ebx
    result |= (byte & 0x7f) << shift;
  8041602336:	89 f2                	mov    %esi,%edx
  8041602338:	83 e2 7f             	and    $0x7f,%edx
  804160233b:	d3 e2                	shl    %cl,%edx
  804160233d:	09 d7                	or     %edx,%edi
    shift += 7;
  804160233f:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602342:	40 84 f6             	test   %sil,%sil
  8041602345:	78 e3                	js     804160232a <function_by_info+0x2db>
  return count;
  8041602347:	48 63 db             	movslq %ebx,%rbx
      curr_abbrev_entry++;
  804160234a:	49 8d 44 1b 01       	lea    0x1(%r11,%rbx,1),%rax
      if (table_abbrev_code == abbrev_code) {
  804160234f:	45 39 d0             	cmp    %r10d,%r8d
  8041602352:	0f 84 9b fe ff ff    	je     80416021f3 <function_by_info+0x1a4>
  result = 0;
  8041602358:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  804160235b:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602360:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    byte = *addr;
  8041602366:	44 0f b6 1a          	movzbl (%rdx),%r11d
    addr++;
  804160236a:	48 83 c2 01          	add    $0x1,%rdx
  804160236e:	89 d3                	mov    %edx,%ebx
  8041602370:	29 c3                	sub    %eax,%ebx
    result |= (byte & 0x7f) << shift;
  8041602372:	44 89 de             	mov    %r11d,%esi
  8041602375:	83 e6 7f             	and    $0x7f,%esi
  8041602378:	d3 e6                	shl    %cl,%esi
  804160237a:	41 09 f2             	or     %esi,%r10d
    shift += 7;
  804160237d:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602380:	45 84 db             	test   %r11b,%r11b
  8041602383:	78 e1                	js     8041602366 <function_by_info+0x317>
  return count;
  8041602385:	48 63 db             	movslq %ebx,%rbx
        curr_abbrev_entry += count;
  8041602388:	48 01 c3             	add    %rax,%rbx
  804160238b:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  804160238e:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602393:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041602399:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  804160239c:	48 83 c0 01          	add    $0x1,%rax
  80416023a0:	41 89 c3             	mov    %eax,%r11d
  80416023a3:	41 29 db             	sub    %ebx,%r11d
    result |= (byte & 0x7f) << shift;
  80416023a6:	89 f2                	mov    %esi,%edx
  80416023a8:	83 e2 7f             	and    $0x7f,%edx
  80416023ab:	d3 e2                	shl    %cl,%edx
  80416023ad:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  80416023b0:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416023b3:	40 84 f6             	test   %sil,%sil
  80416023b6:	78 e1                	js     8041602399 <function_by_info+0x34a>
  return count;
  80416023b8:	4d 63 db             	movslq %r11d,%r11
        curr_abbrev_entry += count;
  80416023bb:	4a 8d 04 1b          	lea    (%rbx,%r11,1),%rax
      } while (name != 0 || form != 0);
  80416023bf:	45 09 d4             	or     %r10d,%r12d
  80416023c2:	75 94                	jne    8041602358 <function_by_info+0x309>
  80416023c4:	e9 18 ff ff ff       	jmpq   80416022e1 <function_by_info+0x292>
      uintptr_t low_pc = 0, high_pc = 0;
  80416023c9:	48 c7 45 b0 00 00 00 	movq   $0x0,-0x50(%rbp)
  80416023d0:	00 
  80416023d1:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  80416023d8:	00 
      unsigned name_form        = 0;
  80416023d9:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%rbp)
      const void *fn_name_entry = 0;
  80416023e0:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  80416023e7:	00 
  80416023e8:	eb 26                	jmp    8041602410 <function_by_info+0x3c1>
          count = dwarf_read_abbrev_entry(
  80416023ea:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416023f0:	b9 08 00 00 00       	mov    $0x8,%ecx
  80416023f5:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
  80416023f9:	44 89 ee             	mov    %r13d,%esi
  80416023fc:	4c 89 f7             	mov    %r14,%rdi
  80416023ff:	41 ff d7             	callq  *%r15
        entry += count;
  8041602402:	48 98                	cltq   
  8041602404:	49 01 c6             	add    %rax,%r14
      } while (name != 0 || form != 0);
  8041602407:	45 09 e5             	or     %r12d,%r13d
  804160240a:	0f 84 d9 00 00 00    	je     80416024e9 <function_by_info+0x49a>
      const void *fn_name_entry = 0;
  8041602410:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602413:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602418:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  804160241e:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602421:	48 83 c0 01          	add    $0x1,%rax
  8041602425:	89 c7                	mov    %eax,%edi
  8041602427:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602429:	89 f2                	mov    %esi,%edx
  804160242b:	83 e2 7f             	and    $0x7f,%edx
  804160242e:	d3 e2                	shl    %cl,%edx
  8041602430:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602433:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602436:	40 84 f6             	test   %sil,%sil
  8041602439:	78 e3                	js     804160241e <function_by_info+0x3cf>
  return count;
  804160243b:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160243e:	48 01 fb             	add    %rdi,%rbx
  8041602441:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602444:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602449:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  804160244f:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602452:	48 83 c0 01          	add    $0x1,%rax
  8041602456:	89 c7                	mov    %eax,%edi
  8041602458:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  804160245a:	89 f2                	mov    %esi,%edx
  804160245c:	83 e2 7f             	and    $0x7f,%edx
  804160245f:	d3 e2                	shl    %cl,%edx
  8041602461:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602464:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602467:	40 84 f6             	test   %sil,%sil
  804160246a:	78 e3                	js     804160244f <function_by_info+0x400>
  return count;
  804160246c:	48 63 ff             	movslq %edi,%rdi
        curr_abbrev_entry += count;
  804160246f:	48 01 fb             	add    %rdi,%rbx
        if (name == DW_AT_low_pc) {
  8041602472:	41 83 fc 11          	cmp    $0x11,%r12d
  8041602476:	0f 84 6e ff ff ff    	je     80416023ea <function_by_info+0x39b>
        } else if (name == DW_AT_high_pc) {
  804160247c:	41 83 fc 12          	cmp    $0x12,%r12d
  8041602480:	74 38                	je     80416024ba <function_by_info+0x46b>
    result |= (byte & 0x7f) << shift;
  8041602482:	41 83 fc 03          	cmp    $0x3,%r12d
  8041602486:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8041602489:	41 0f 44 c5          	cmove  %r13d,%eax
  804160248d:	89 45 a4             	mov    %eax,-0x5c(%rbp)
  8041602490:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602494:	49 0f 44 c6          	cmove  %r14,%rax
  8041602498:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
          count = dwarf_read_abbrev_entry(
  804160249c:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416024a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  80416024a7:	ba 00 00 00 00       	mov    $0x0,%edx
  80416024ac:	44 89 ee             	mov    %r13d,%esi
  80416024af:	4c 89 f7             	mov    %r14,%rdi
  80416024b2:	41 ff d7             	callq  *%r15
  80416024b5:	e9 48 ff ff ff       	jmpq   8041602402 <function_by_info+0x3b3>
          count = dwarf_read_abbrev_entry(
  80416024ba:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  80416024c0:	b9 08 00 00 00       	mov    $0x8,%ecx
  80416024c5:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  80416024c9:	44 89 ee             	mov    %r13d,%esi
  80416024cc:	4c 89 f7             	mov    %r14,%rdi
  80416024cf:	41 ff d7             	callq  *%r15
          if (form != DW_FORM_addr) {
  80416024d2:	41 83 fd 01          	cmp    $0x1,%r13d
  80416024d6:	0f 84 e5 00 00 00    	je     80416025c1 <function_by_info+0x572>
            high_pc += low_pc;
  80416024dc:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80416024e0:	48 01 55 b8          	add    %rdx,-0x48(%rbp)
  80416024e4:	e9 19 ff ff ff       	jmpq   8041602402 <function_by_info+0x3b3>
      if (p >= low_pc && p <= high_pc) {
  80416024e9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80416024ed:	48 8b bd 78 ff ff ff 	mov    -0x88(%rbp),%rdi
  80416024f4:	48 39 f8             	cmp    %rdi,%rax
  80416024f7:	0f 87 8b fd ff ff    	ja     8041602288 <function_by_info+0x239>
  80416024fd:	48 39 7d b8          	cmp    %rdi,-0x48(%rbp)
  8041602501:	0f 82 81 fd ff ff    	jb     8041602288 <function_by_info+0x239>
        *offset = low_pc;
  8041602507:	48 8b bd 70 ff ff ff 	mov    -0x90(%rbp),%rdi
  804160250e:	48 89 07             	mov    %rax,(%rdi)
        if (name_form == DW_FORM_strp) {
  8041602511:	83 7d a4 0e          	cmpl   $0xe,-0x5c(%rbp)
  8041602515:	75 6a                	jne    8041602581 <function_by_info+0x532>
          unsigned long str_offset = 0;
  8041602517:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804160251e:	00 
          count                    = dwarf_read_abbrev_entry(
  804160251f:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602525:	b9 08 00 00 00       	mov    $0x8,%ecx
  804160252a:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  804160252e:	be 0e 00 00 00       	mov    $0xe,%esi
  8041602533:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  8041602537:	48 b8 a0 0b 60 41 80 	movabs $0x8041600ba0,%rax
  804160253e:	00 00 00 
  8041602541:	ff d0                	callq  *%rax
          if (buf &&
  8041602543:	48 8b 7d 88          	mov    -0x78(%rbp),%rdi
  8041602547:	48 85 ff             	test   %rdi,%rdi
  804160254a:	74 2b                	je     8041602577 <function_by_info+0x528>
  804160254c:	83 7d a0 07          	cmpl   $0x7,-0x60(%rbp)
  8041602550:	76 25                	jbe    8041602577 <function_by_info+0x528>
            put_unaligned(
  8041602552:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041602556:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  804160255a:	48 03 41 40          	add    0x40(%rcx),%rax
  804160255e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8041602562:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602567:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  804160256b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602572:	00 00 00 
  8041602575:	ff d0                	callq  *%rax
        return 0;
  8041602577:	b8 00 00 00 00       	mov    $0x0,%eax
  804160257c:	e9 45 fb ff ff       	jmpq   80416020c6 <function_by_info+0x77>
          count = dwarf_read_abbrev_entry(
  8041602581:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602587:	8b 4d a0             	mov    -0x60(%rbp),%ecx
  804160258a:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  804160258e:	8b 75 a4             	mov    -0x5c(%rbp),%esi
  8041602591:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  8041602595:	48 b8 a0 0b 60 41 80 	movabs $0x8041600ba0,%rax
  804160259c:	00 00 00 
  804160259f:	ff d0                	callq  *%rax
  80416025a1:	eb d4                	jmp    8041602577 <function_by_info+0x528>
  return 0;
  80416025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  80416025a8:	e9 19 fb ff ff       	jmpq   80416020c6 <function_by_info+0x77>
  while (entry < entry_end) {
  80416025ad:	4c 39 75 98          	cmp    %r14,-0x68(%rbp)
  80416025b1:	0f 87 db fc ff ff    	ja     8041602292 <function_by_info+0x243>
  return 0;
  80416025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  80416025bc:	e9 05 fb ff ff       	jmpq   80416020c6 <function_by_info+0x77>
        entry += count;
  80416025c1:	48 98                	cltq   
  80416025c3:	49 01 c6             	add    %rax,%r14
  80416025c6:	e9 45 fe ff ff       	jmpq   8041602410 <function_by_info+0x3c1>

00000080416025cb <address_by_fname>:

int
address_by_fname(const struct Dwarf_Addrs *addrs, const char *fname,
                 uintptr_t *offset) {
  80416025cb:	55                   	push   %rbp
  80416025cc:	48 89 e5             	mov    %rsp,%rbp
  80416025cf:	41 57                	push   %r15
  80416025d1:	41 56                	push   %r14
  80416025d3:	41 55                	push   %r13
  80416025d5:	41 54                	push   %r12
  80416025d7:	53                   	push   %rbx
  80416025d8:	48 83 ec 38          	sub    $0x38,%rsp
  80416025dc:	48 89 fb             	mov    %rdi,%rbx
  80416025df:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80416025e3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  const int flen = strlen(fname);
  80416025e7:	48 89 f7             	mov    %rsi,%rdi
  80416025ea:	48 b8 1a 48 60 41 80 	movabs $0x804160481a,%rax
  80416025f1:	00 00 00 
  80416025f4:	ff d0                	callq  *%rax
  if (flen == 0)
  80416025f6:	85 c0                	test   %eax,%eax
  80416025f8:	0f 84 c4 02 00 00    	je     80416028c2 <address_by_fname+0x2f7>
    return 0;
  const void *pubnames_entry = addrs->pubnames_begin;
  80416025fe:	4c 8b 63 50          	mov    0x50(%rbx),%r12
  initial_len = get_unaligned(addr, uint32_t);
  8041602602:	49 be d0 4a 60 41 80 	movabs $0x8041604ad0,%r14
  8041602609:	00 00 00 
  int count                  = 0;
  unsigned long len          = 0;
  Dwarf_Off cu_offset        = 0;
  Dwarf_Off func_offset      = 0;
  // parse pubnames section
  while ((const unsigned char *)pubnames_entry < addrs->pubnames_end) {
  804160260c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602610:	4c 39 60 58          	cmp    %r12,0x58(%rax)
  8041602614:	0f 86 9e 02 00 00    	jbe    80416028b8 <address_by_fname+0x2ed>
  804160261a:	ba 04 00 00 00       	mov    $0x4,%edx
  804160261f:	4c 89 e6             	mov    %r12,%rsi
  8041602622:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602626:	41 ff d6             	callq  *%r14
  8041602629:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  804160262c:	83 f8 ef             	cmp    $0xffffffef,%eax
  804160262f:	76 52                	jbe    8041602683 <address_by_fname+0xb8>
    if (initial_len == DW_EXT_DWARF64) {
  8041602631:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602634:	74 31                	je     8041602667 <address_by_fname+0x9c>
      cprintf("Unknown DWARF extension\n");
  8041602636:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  804160263d:	00 00 00 
  8041602640:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602645:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160264c:	00 00 00 
  804160264f:	ff d2                	callq  *%rdx
    count = dwarf_entry_len(pubnames_entry, &len);
    if (count == 0) {
      return -E_BAD_DWARF;
  8041602651:	bb fa ff ff ff       	mov    $0xfffffffa,%ebx
      }
      pubnames_entry += strlen(pubnames_entry) + 1;
    }
  }
  return 0;
}
  8041602656:	89 d8                	mov    %ebx,%eax
  8041602658:	48 83 c4 38          	add    $0x38,%rsp
  804160265c:	5b                   	pop    %rbx
  804160265d:	41 5c                	pop    %r12
  804160265f:	41 5d                	pop    %r13
  8041602661:	41 5e                	pop    %r14
  8041602663:	41 5f                	pop    %r15
  8041602665:	5d                   	pop    %rbp
  8041602666:	c3                   	retq   
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041602667:	49 8d 74 24 20       	lea    0x20(%r12),%rsi
  804160266c:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602671:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602675:	41 ff d6             	callq  *%r14
  8041602678:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  804160267c:	ba 0c 00 00 00       	mov    $0xc,%edx
  8041602681:	eb 07                	jmp    804160268a <address_by_fname+0xbf>
    *len = initial_len;
  8041602683:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041602685:	ba 04 00 00 00       	mov    $0x4,%edx
    pubnames_entry += count;
  804160268a:	48 63 d2             	movslq %edx,%rdx
  804160268d:	49 01 d4             	add    %rdx,%r12
    const void *pubnames_entry_end = pubnames_entry + len;
  8041602690:	4c 01 e0             	add    %r12,%rax
  8041602693:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    Dwarf_Half version             = get_unaligned(pubnames_entry, Dwarf_Half);
  8041602697:	ba 02 00 00 00       	mov    $0x2,%edx
  804160269c:	4c 89 e6             	mov    %r12,%rsi
  804160269f:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416026a3:	41 ff d6             	callq  *%r14
    pubnames_entry += sizeof(Dwarf_Half);
  80416026a6:	49 8d 74 24 02       	lea    0x2(%r12),%rsi
    assert(version == 2);
  80416026ab:	66 83 7d c8 02       	cmpw   $0x2,-0x38(%rbp)
  80416026b0:	0f 85 c8 00 00 00    	jne    804160277e <address_by_fname+0x1b3>
    cu_offset = get_unaligned(pubnames_entry, uint32_t);
  80416026b6:	ba 04 00 00 00       	mov    $0x4,%edx
  80416026bb:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416026bf:	41 ff d6             	callq  *%r14
  80416026c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80416026c5:	89 45 a4             	mov    %eax,-0x5c(%rbp)
    pubnames_entry += sizeof(uint32_t);
  80416026c8:	49 8d 5c 24 06       	lea    0x6(%r12),%rbx
  initial_len = get_unaligned(addr, uint32_t);
  80416026cd:	ba 04 00 00 00       	mov    $0x4,%edx
  80416026d2:	48 89 de             	mov    %rbx,%rsi
  80416026d5:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416026d9:	41 ff d6             	callq  *%r14
  80416026dc:	8b 55 c8             	mov    -0x38(%rbp),%edx
  count       = 4;
  80416026df:	b8 04 00 00 00       	mov    $0x4,%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416026e4:	83 fa ef             	cmp    $0xffffffef,%edx
  80416026e7:	76 29                	jbe    8041602712 <address_by_fname+0x147>
    if (initial_len == DW_EXT_DWARF64) {
  80416026e9:	83 fa ff             	cmp    $0xffffffff,%edx
  80416026ec:	0f 84 c1 00 00 00    	je     80416027b3 <address_by_fname+0x1e8>
      cprintf("Unknown DWARF extension\n");
  80416026f2:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  80416026f9:	00 00 00 
  80416026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602701:	48 be 0d 3b 60 41 80 	movabs $0x8041603b0d,%rsi
  8041602708:	00 00 00 
  804160270b:	ff d6                	callq  *%rsi
      count = 0;
  804160270d:	b8 00 00 00 00       	mov    $0x0,%eax
    pubnames_entry += count;
  8041602712:	48 98                	cltq   
  8041602714:	4c 8d 24 03          	lea    (%rbx,%rax,1),%r12
    while (pubnames_entry < pubnames_entry_end) {
  8041602718:	4c 39 65 b8          	cmp    %r12,-0x48(%rbp)
  804160271c:	0f 86 ea fe ff ff    	jbe    804160260c <address_by_fname+0x41>
      pubnames_entry += strlen(pubnames_entry) + 1;
  8041602722:	49 bf 1a 48 60 41 80 	movabs $0x804160481a,%r15
  8041602729:	00 00 00 
      func_offset = get_unaligned(pubnames_entry, uint32_t);
  804160272c:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602731:	4c 89 e6             	mov    %r12,%rsi
  8041602734:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602738:	41 ff d6             	callq  *%r14
  804160273b:	44 8b 6d c8          	mov    -0x38(%rbp),%r13d
      pubnames_entry += sizeof(uint32_t);
  804160273f:	49 83 c4 04          	add    $0x4,%r12
      if (func_offset == 0) {
  8041602743:	4d 85 ed             	test   %r13,%r13
  8041602746:	0f 84 c0 fe ff ff    	je     804160260c <address_by_fname+0x41>
      if (!strcmp(fname, pubnames_entry)) {
  804160274c:	4c 89 e6             	mov    %r12,%rsi
  804160274f:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
  8041602753:	48 b8 3c 49 60 41 80 	movabs $0x804160493c,%rax
  804160275a:	00 00 00 
  804160275d:	ff d0                	callq  *%rax
  804160275f:	89 c3                	mov    %eax,%ebx
  8041602761:	85 c0                	test   %eax,%eax
  8041602763:	74 69                	je     80416027ce <address_by_fname+0x203>
      pubnames_entry += strlen(pubnames_entry) + 1;
  8041602765:	4c 89 e7             	mov    %r12,%rdi
  8041602768:	41 ff d7             	callq  *%r15
  804160276b:	83 c0 01             	add    $0x1,%eax
  804160276e:	48 98                	cltq   
  8041602770:	49 01 c4             	add    %rax,%r12
    while (pubnames_entry < pubnames_entry_end) {
  8041602773:	4c 39 65 b8          	cmp    %r12,-0x48(%rbp)
  8041602777:	77 b3                	ja     804160272c <address_by_fname+0x161>
  8041602779:	e9 8e fe ff ff       	jmpq   804160260c <address_by_fname+0x41>
    assert(version == 2);
  804160277e:	48 b9 de 50 60 41 80 	movabs $0x80416050de,%rcx
  8041602785:	00 00 00 
  8041602788:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  804160278f:	00 00 00 
  8041602792:	be 73 02 00 00       	mov    $0x273,%esi
  8041602797:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  804160279e:	00 00 00 
  80416027a1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416027a6:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416027ad:	00 00 00 
  80416027b0:	41 ff d0             	callq  *%r8
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416027b3:	49 8d 74 24 26       	lea    0x26(%r12),%rsi
  80416027b8:	ba 08 00 00 00       	mov    $0x8,%edx
  80416027bd:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416027c1:	41 ff d6             	callq  *%r14
      count = 12;
  80416027c4:	b8 0c 00 00 00       	mov    $0xc,%eax
  80416027c9:	e9 44 ff ff ff       	jmpq   8041602712 <address_by_fname+0x147>
    cu_offset = get_unaligned(pubnames_entry, uint32_t);
  80416027ce:	44 8b 75 a4          	mov    -0x5c(%rbp),%r14d
        const void *entry      = addrs->info_begin + cu_offset;
  80416027d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80416027d6:	4c 03 70 20          	add    0x20(%rax),%r14
        const void *func_entry = entry + func_offset;
  80416027da:	4d 01 f5             	add    %r14,%r13
  initial_len = get_unaligned(addr, uint32_t);
  80416027dd:	ba 04 00 00 00       	mov    $0x4,%edx
  80416027e2:	4c 89 f6             	mov    %r14,%rsi
  80416027e5:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416027e9:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416027f0:	00 00 00 
  80416027f3:	ff d0                	callq  *%rax
  80416027f5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  80416027f8:	83 f8 ef             	cmp    $0xffffffef,%eax
  80416027fb:	0f 86 cb 00 00 00    	jbe    80416028cc <address_by_fname+0x301>
    if (initial_len == DW_EXT_DWARF64) {
  8041602801:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602804:	74 25                	je     804160282b <address_by_fname+0x260>
      cprintf("Unknown DWARF extension\n");
  8041602806:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  804160280d:	00 00 00 
  8041602810:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602815:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160281c:	00 00 00 
  804160281f:	ff d2                	callq  *%rdx
          return -E_BAD_DWARF;
  8041602821:	bb fa ff ff ff       	mov    $0xfffffffa,%ebx
  8041602826:	e9 2b fe ff ff       	jmpq   8041602656 <address_by_fname+0x8b>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  804160282b:	49 8d 76 20          	lea    0x20(%r14),%rsi
  804160282f:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602834:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602838:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  804160283f:	00 00 00 
  8041602842:	ff d0                	callq  *%rax
      count = 12;
  8041602844:	b8 0c 00 00 00       	mov    $0xc,%eax
  8041602849:	e9 83 00 00 00       	jmpq   80416028d1 <address_by_fname+0x306>
        assert(version == 4 || version == 2);
  804160284e:	48 b9 ce 50 60 41 80 	movabs $0x80416050ce,%rcx
  8041602855:	00 00 00 
  8041602858:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  804160285f:	00 00 00 
  8041602862:	be 89 02 00 00       	mov    $0x289,%esi
  8041602867:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  804160286e:	00 00 00 
  8041602871:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602876:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  804160287d:	00 00 00 
  8041602880:	41 ff d0             	callq  *%r8
        assert(address_size == 8);
  8041602883:	48 b9 9b 50 60 41 80 	movabs $0x804160509b,%rcx
  804160288a:	00 00 00 
  804160288d:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041602894:	00 00 00 
  8041602897:	be 8e 02 00 00       	mov    $0x28e,%esi
  804160289c:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  80416028a3:	00 00 00 
  80416028a6:	b8 00 00 00 00       	mov    $0x0,%eax
  80416028ab:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416028b2:	00 00 00 
  80416028b5:	41 ff d0             	callq  *%r8
  return 0;
  80416028b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  80416028bd:	e9 94 fd ff ff       	jmpq   8041602656 <address_by_fname+0x8b>
    return 0;
  80416028c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  80416028c7:	e9 8a fd ff ff       	jmpq   8041602656 <address_by_fname+0x8b>
  count       = 4;
  80416028cc:	b8 04 00 00 00       	mov    $0x4,%eax
        entry += count;
  80416028d1:	48 98                	cltq   
  80416028d3:	49 01 c6             	add    %rax,%r14
        Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  80416028d6:	ba 02 00 00 00       	mov    $0x2,%edx
  80416028db:	4c 89 f6             	mov    %r14,%rsi
  80416028de:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416028e2:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416028e9:	00 00 00 
  80416028ec:	ff d0                	callq  *%rax
        entry += sizeof(Dwarf_Half);
  80416028ee:	49 8d 76 02          	lea    0x2(%r14),%rsi
        assert(version == 4 || version == 2);
  80416028f2:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  80416028f6:	83 e8 02             	sub    $0x2,%eax
  80416028f9:	66 a9 fd ff          	test   $0xfffd,%ax
  80416028fd:	0f 85 4b ff ff ff    	jne    804160284e <address_by_fname+0x283>
        Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041602903:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602908:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160290c:	49 bf d0 4a 60 41 80 	movabs $0x8041604ad0,%r15
  8041602913:	00 00 00 
  8041602916:	41 ff d7             	callq  *%r15
  8041602919:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
        const void *abbrev_entry = addrs->abbrev_begin + abbrev_offset;
  804160291d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602921:	4c 03 20             	add    (%rax),%r12
        entry += sizeof(uint32_t);
  8041602924:	49 8d 76 06          	lea    0x6(%r14),%rsi
        Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041602928:	ba 01 00 00 00       	mov    $0x1,%edx
  804160292d:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602931:	41 ff d7             	callq  *%r15
        assert(address_size == 8);
  8041602934:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041602938:	0f 85 45 ff ff ff    	jne    8041602883 <address_by_fname+0x2b8>
  shift  = 0;
  804160293e:	89 d9                	mov    %ebx,%ecx
  result = 0;
  8041602940:	be 00 00 00 00       	mov    $0x0,%esi
    byte = *addr;
  8041602945:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
    addr++;
  804160294a:	49 83 c5 01          	add    $0x1,%r13
    result |= (byte & 0x7f) << shift;
  804160294e:	89 d0                	mov    %edx,%eax
  8041602950:	83 e0 7f             	and    $0x7f,%eax
  8041602953:	d3 e0                	shl    %cl,%eax
  8041602955:	09 c6                	or     %eax,%esi
    shift += 7;
  8041602957:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  804160295a:	84 d2                	test   %dl,%dl
  804160295c:	78 e7                	js     8041602945 <address_by_fname+0x37a>
        while ((const unsigned char *)abbrev_entry < addrs->abbrev_end) { // unsafe needs
  804160295e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8041602962:	4c 8b 40 08          	mov    0x8(%rax),%r8
  8041602966:	4d 39 e0             	cmp    %r12,%r8
  8041602969:	0f 86 e7 fc ff ff    	jbe    8041602656 <address_by_fname+0x8b>
  shift  = 0;
  804160296f:	89 d9                	mov    %ebx,%ecx
  8041602971:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  8041602974:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    byte = *addr;
  804160297a:	0f b6 38             	movzbl (%rax),%edi
    addr++;
  804160297d:	48 83 c0 01          	add    $0x1,%rax
  8041602981:	41 89 c1             	mov    %eax,%r9d
  8041602984:	45 29 e1             	sub    %r12d,%r9d
    result |= (byte & 0x7f) << shift;
  8041602987:	89 fa                	mov    %edi,%edx
  8041602989:	83 e2 7f             	and    $0x7f,%edx
  804160298c:	d3 e2                	shl    %cl,%edx
  804160298e:	41 09 d2             	or     %edx,%r10d
    shift += 7;
  8041602991:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602994:	40 84 ff             	test   %dil,%dil
  8041602997:	78 e1                	js     804160297a <address_by_fname+0x3af>
  return count;
  8041602999:	4d 63 c9             	movslq %r9d,%r9
          abbrev_entry += count;
  804160299c:	4d 01 cc             	add    %r9,%r12
  804160299f:	4c 89 e0             	mov    %r12,%rax
    byte = *addr;
  80416029a2:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  80416029a5:	48 83 c0 01          	add    $0x1,%rax
  80416029a9:	89 c1                	mov    %eax,%ecx
  80416029ab:	44 29 e1             	sub    %r12d,%ecx
    if (!(byte & 0x80))
  80416029ae:	84 d2                	test   %dl,%dl
  80416029b0:	78 f0                	js     80416029a2 <address_by_fname+0x3d7>
  return count;
  80416029b2:	48 63 c9             	movslq %ecx,%rcx
          abbrev_entry++;
  80416029b5:	4d 8d 64 0c 01       	lea    0x1(%r12,%rcx,1),%r12
          if (table_abbrev_code == abbrev_code) {
  80416029ba:	44 39 d6             	cmp    %r10d,%esi
  80416029bd:	0f 84 93 fc ff ff    	je     8041602656 <address_by_fname+0x8b>
  shift  = 0;
  80416029c3:	89 d9                	mov    %ebx,%ecx
  80416029c5:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  80416029c8:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  80416029cd:	44 0f b6 08          	movzbl (%rax),%r9d
    addr++;
  80416029d1:	48 83 c0 01          	add    $0x1,%rax
  80416029d5:	41 89 c2             	mov    %eax,%r10d
  80416029d8:	45 29 e2             	sub    %r12d,%r10d
    result |= (byte & 0x7f) << shift;
  80416029db:	44 89 ca             	mov    %r9d,%edx
  80416029de:	83 e2 7f             	and    $0x7f,%edx
  80416029e1:	d3 e2                	shl    %cl,%edx
  80416029e3:	09 d7                	or     %edx,%edi
    shift += 7;
  80416029e5:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416029e8:	45 84 c9             	test   %r9b,%r9b
  80416029eb:	78 e0                	js     80416029cd <address_by_fname+0x402>
  return count;
  80416029ed:	4d 63 d2             	movslq %r10d,%r10
            abbrev_entry += count;
  80416029f0:	4d 01 d4             	add    %r10,%r12
  shift  = 0;
  80416029f3:	89 d9                	mov    %ebx,%ecx
  80416029f5:	4c 89 e0             	mov    %r12,%rax
  result = 0;
  80416029f8:	41 ba 00 00 00 00    	mov    $0x0,%r10d
    byte = *addr;
  80416029fe:	44 0f b6 08          	movzbl (%rax),%r9d
    addr++;
  8041602a02:	48 83 c0 01          	add    $0x1,%rax
  8041602a06:	41 89 c3             	mov    %eax,%r11d
  8041602a09:	45 29 e3             	sub    %r12d,%r11d
    result |= (byte & 0x7f) << shift;
  8041602a0c:	44 89 ca             	mov    %r9d,%edx
  8041602a0f:	83 e2 7f             	and    $0x7f,%edx
  8041602a12:	d3 e2                	shl    %cl,%edx
  8041602a14:	41 09 d2             	or     %edx,%r10d
    shift += 7;
  8041602a17:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602a1a:	45 84 c9             	test   %r9b,%r9b
  8041602a1d:	78 df                	js     80416029fe <address_by_fname+0x433>
  return count;
  8041602a1f:	4d 63 db             	movslq %r11d,%r11
            abbrev_entry += count;
  8041602a22:	4d 01 dc             	add    %r11,%r12
          } while (name != 0 || form != 0);
  8041602a25:	41 09 fa             	or     %edi,%r10d
  8041602a28:	75 99                	jne    80416029c3 <address_by_fname+0x3f8>
  8041602a2a:	e9 37 ff ff ff       	jmpq   8041602966 <address_by_fname+0x39b>

0000008041602a2f <naive_address_by_fname>:

int
naive_address_by_fname(const struct Dwarf_Addrs *addrs, const char *fname,
                       uintptr_t *offset) {
  8041602a2f:	55                   	push   %rbp
  8041602a30:	48 89 e5             	mov    %rsp,%rbp
  8041602a33:	41 57                	push   %r15
  8041602a35:	41 56                	push   %r14
  8041602a37:	41 55                	push   %r13
  8041602a39:	41 54                	push   %r12
  8041602a3b:	53                   	push   %rbx
  8041602a3c:	48 83 ec 48          	sub    $0x48,%rsp
  8041602a40:	48 89 fb             	mov    %rdi,%rbx
  8041602a43:	48 89 7d b0          	mov    %rdi,-0x50(%rbp)
  8041602a47:	48 89 f7             	mov    %rsi,%rdi
  8041602a4a:	48 89 75 a8          	mov    %rsi,-0x58(%rbp)
  8041602a4e:	48 89 55 90          	mov    %rdx,-0x70(%rbp)
  const int flen = strlen(fname);
  8041602a52:	48 b8 1a 48 60 41 80 	movabs $0x804160481a,%rax
  8041602a59:	00 00 00 
  8041602a5c:	ff d0                	callq  *%rax
  if (flen == 0)
  8041602a5e:	85 c0                	test   %eax,%eax
  8041602a60:	0f 84 09 05 00 00    	je     8041602f6f <naive_address_by_fname+0x540>
    return 0;
  const void *entry = addrs->info_begin;
  8041602a66:	4c 8b 7b 20          	mov    0x20(%rbx),%r15
  int count         = 0;
  while ((const unsigned char *)entry < addrs->info_end) {
  8041602a6a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602a6e:	4c 39 78 28          	cmp    %r15,0x28(%rax)
  8041602a72:	0f 86 ed 04 00 00    	jbe    8041602f65 <naive_address_by_fname+0x536>
  initial_len = get_unaligned(addr, uint32_t);
  8041602a78:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602a7d:	4c 89 fe             	mov    %r15,%rsi
  8041602a80:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602a84:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602a8b:	00 00 00 
  8041602a8e:	ff d0                	callq  *%rax
  8041602a90:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041602a93:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041602a96:	76 58                	jbe    8041602af0 <naive_address_by_fname+0xc1>
    if (initial_len == DW_EXT_DWARF64) {
  8041602a98:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602a9b:	74 2f                	je     8041602acc <naive_address_by_fname+0x9d>
      cprintf("Unknown DWARF extension\n");
  8041602a9d:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  8041602aa4:	00 00 00 
  8041602aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602aac:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041602ab3:	00 00 00 
  8041602ab6:	ff d2                	callq  *%rdx
    unsigned long len = 0;
    count             = dwarf_entry_len(entry, &len);
    if (count == 0) {
      return -E_BAD_DWARF;
  8041602ab8:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
      }
    }
  }

  return 0;
  8041602abd:	48 83 c4 48          	add    $0x48,%rsp
  8041602ac1:	5b                   	pop    %rbx
  8041602ac2:	41 5c                	pop    %r12
  8041602ac4:	41 5d                	pop    %r13
  8041602ac6:	41 5e                	pop    %r14
  8041602ac8:	41 5f                	pop    %r15
  8041602aca:	5d                   	pop    %rbp
  8041602acb:	c3                   	retq   
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041602acc:	49 8d 77 20          	lea    0x20(%r15),%rsi
  8041602ad0:	ba 08 00 00 00       	mov    $0x8,%edx
  8041602ad5:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602ad9:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602ae0:	00 00 00 
  8041602ae3:	ff d0                	callq  *%rax
  8041602ae5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  8041602ae9:	bb 0c 00 00 00       	mov    $0xc,%ebx
  8041602aee:	eb 07                	jmp    8041602af7 <naive_address_by_fname+0xc8>
    *len = initial_len;
  8041602af0:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041602af2:	bb 04 00 00 00       	mov    $0x4,%ebx
    entry += count;
  8041602af7:	48 63 db             	movslq %ebx,%rbx
  8041602afa:	4d 8d 2c 1f          	lea    (%r15,%rbx,1),%r13
    const void *entry_end = entry + len;
  8041602afe:	4c 01 e8             	add    %r13,%rax
  8041602b01:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
    Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
  8041602b05:	ba 02 00 00 00       	mov    $0x2,%edx
  8041602b0a:	4c 89 ee             	mov    %r13,%rsi
  8041602b0d:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602b11:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602b18:	00 00 00 
  8041602b1b:	ff d0                	callq  *%rax
    entry += sizeof(Dwarf_Half);
  8041602b1d:	49 83 c5 02          	add    $0x2,%r13
    assert(version == 4 || version == 2);
  8041602b21:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041602b25:	83 e8 02             	sub    $0x2,%eax
  8041602b28:	66 a9 fd ff          	test   $0xfffd,%ax
  8041602b2c:	75 52                	jne    8041602b80 <naive_address_by_fname+0x151>
    Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
  8041602b2e:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602b33:	4c 89 ee             	mov    %r13,%rsi
  8041602b36:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602b3a:	49 be d0 4a 60 41 80 	movabs $0x8041604ad0,%r14
  8041602b41:	00 00 00 
  8041602b44:	41 ff d6             	callq  *%r14
  8041602b47:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
    entry += count;
  8041602b4b:	49 8d 74 1d 00       	lea    0x0(%r13,%rbx,1),%rsi
    Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
  8041602b50:	4c 8d 7e 01          	lea    0x1(%rsi),%r15
  8041602b54:	ba 01 00 00 00       	mov    $0x1,%edx
  8041602b59:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602b5d:	41 ff d6             	callq  *%r14
    assert(address_size == 8);
  8041602b60:	80 7d c8 08          	cmpb   $0x8,-0x38(%rbp)
  8041602b64:	75 4f                	jne    8041602bb5 <naive_address_by_fname+0x186>
    const void *abbrev_entry      = addrs->abbrev_begin + abbrev_offset;
  8041602b66:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602b6a:	4c 03 20             	add    (%rax),%r12
  8041602b6d:	4c 89 65 98          	mov    %r12,-0x68(%rbp)
            count = dwarf_read_abbrev_entry(
  8041602b71:	49 be a0 0b 60 41 80 	movabs $0x8041600ba0,%r14
  8041602b78:	00 00 00 
    while (entry < entry_end) {
  8041602b7b:	e9 0a 01 00 00       	jmpq   8041602c8a <naive_address_by_fname+0x25b>
    assert(version == 4 || version == 2);
  8041602b80:	48 b9 ce 50 60 41 80 	movabs $0x80416050ce,%rcx
  8041602b87:	00 00 00 
  8041602b8a:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041602b91:	00 00 00 
  8041602b94:	be d4 02 00 00       	mov    $0x2d4,%esi
  8041602b99:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041602ba0:	00 00 00 
  8041602ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602ba8:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041602baf:	00 00 00 
  8041602bb2:	41 ff d0             	callq  *%r8
    assert(address_size == 8);
  8041602bb5:	48 b9 9b 50 60 41 80 	movabs $0x804160509b,%rcx
  8041602bbc:	00 00 00 
  8041602bbf:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041602bc6:	00 00 00 
  8041602bc9:	be d8 02 00 00       	mov    $0x2d8,%esi
  8041602bce:	48 bf 8e 50 60 41 80 	movabs $0x804160508e,%rdi
  8041602bd5:	00 00 00 
  8041602bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602bdd:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041602be4:	00 00 00 
  8041602be7:	41 ff d0             	callq  *%r8
  8041602bea:	48 89 c3             	mov    %rax,%rbx
      if (tag == DW_TAG_subprogram || tag == DW_TAG_label) {
  8041602bed:	41 83 f8 2e          	cmp    $0x2e,%r8d
  8041602bf1:	0f 84 d5 01 00 00    	je     8041602dcc <naive_address_by_fname+0x39d>
  8041602bf7:	41 83 f8 0a          	cmp    $0xa,%r8d
  8041602bfb:	0f 84 cb 01 00 00    	je     8041602dcc <naive_address_by_fname+0x39d>
                found = 1;
  8041602c01:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602c09:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041602c0f:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602c12:	48 83 c0 01          	add    $0x1,%rax
  8041602c16:	89 c7                	mov    %eax,%edi
  8041602c18:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602c1a:	89 f2                	mov    %esi,%edx
  8041602c1c:	83 e2 7f             	and    $0x7f,%edx
  8041602c1f:	d3 e2                	shl    %cl,%edx
  8041602c21:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602c24:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602c27:	40 84 f6             	test   %sil,%sil
  8041602c2a:	78 e3                	js     8041602c0f <naive_address_by_fname+0x1e0>
  return count;
  8041602c2c:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041602c2f:	48 01 fb             	add    %rdi,%rbx
  8041602c32:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602c35:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602c3a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041602c40:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602c43:	48 83 c0 01          	add    $0x1,%rax
  8041602c47:	89 c7                	mov    %eax,%edi
  8041602c49:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602c4b:	89 f2                	mov    %esi,%edx
  8041602c4d:	83 e2 7f             	and    $0x7f,%edx
  8041602c50:	d3 e2                	shl    %cl,%edx
  8041602c52:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602c55:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602c58:	40 84 f6             	test   %sil,%sil
  8041602c5b:	78 e3                	js     8041602c40 <naive_address_by_fname+0x211>
  return count;
  8041602c5d:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041602c60:	48 01 fb             	add    %rdi,%rbx
          count = dwarf_read_abbrev_entry(
  8041602c63:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602c69:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041602c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602c73:	44 89 e6             	mov    %r12d,%esi
  8041602c76:	4c 89 ff             	mov    %r15,%rdi
  8041602c79:	41 ff d6             	callq  *%r14
          entry += count;
  8041602c7c:	48 98                	cltq   
  8041602c7e:	49 01 c7             	add    %rax,%r15
        } while (name != 0 || form != 0);
  8041602c81:	45 09 ec             	or     %r13d,%r12d
  8041602c84:	0f 85 77 ff ff ff    	jne    8041602c01 <naive_address_by_fname+0x1d2>
    while (entry < entry_end) {
  8041602c8a:	4c 3b 7d a0          	cmp    -0x60(%rbp),%r15
  8041602c8e:	0f 83 d6 fd ff ff    	jae    8041602a6a <naive_address_by_fname+0x3b>
                       uintptr_t *offset) {
  8041602c94:	4c 89 f8             	mov    %r15,%rax
  shift  = 0;
  8041602c97:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602c9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    byte = *addr;
  8041602ca2:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602ca5:	48 83 c0 01          	add    $0x1,%rax
  8041602ca9:	89 c7                	mov    %eax,%edi
  8041602cab:	44 29 ff             	sub    %r15d,%edi
    result |= (byte & 0x7f) << shift;
  8041602cae:	89 f2                	mov    %esi,%edx
  8041602cb0:	83 e2 7f             	and    $0x7f,%edx
  8041602cb3:	d3 e2                	shl    %cl,%edx
  8041602cb5:	41 09 d1             	or     %edx,%r9d
    shift += 7;
  8041602cb8:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602cbb:	40 84 f6             	test   %sil,%sil
  8041602cbe:	78 e2                	js     8041602ca2 <naive_address_by_fname+0x273>
  return count;
  8041602cc0:	48 63 ff             	movslq %edi,%rdi
      entry += count;
  8041602cc3:	49 01 ff             	add    %rdi,%r15
      if (abbrev_code == 0) {
  8041602cc6:	45 85 c9             	test   %r9d,%r9d
  8041602cc9:	0f 84 87 02 00 00    	je     8041602f56 <naive_address_by_fname+0x527>
      while ((const unsigned char *)curr_abbrev_entry < addrs->abbrev_end) { // unsafe needs to be
  8041602ccf:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602cd3:	4c 8b 50 08          	mov    0x8(%rax),%r10
      curr_abbrev_entry = abbrev_entry;
  8041602cd7:	48 8b 5d 98          	mov    -0x68(%rbp),%rbx
      unsigned name = 0, form = 0, tag = 0;
  8041602cdb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8041602ce1:	48 89 d8             	mov    %rbx,%rax
      while ((const unsigned char *)curr_abbrev_entry < addrs->abbrev_end) { // unsafe needs to be
  8041602ce4:	49 39 c2             	cmp    %rax,%r10
  8041602ce7:	0f 86 fd fe ff ff    	jbe    8041602bea <naive_address_by_fname+0x1bb>
  8041602ced:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  8041602cf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602cf5:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602cfa:	44 0f b6 02          	movzbl (%rdx),%r8d
    addr++;
  8041602cfe:	48 83 c2 01          	add    $0x1,%rdx
  8041602d02:	41 89 d3             	mov    %edx,%r11d
  8041602d05:	41 29 c3             	sub    %eax,%r11d
    result |= (byte & 0x7f) << shift;
  8041602d08:	44 89 c6             	mov    %r8d,%esi
  8041602d0b:	83 e6 7f             	and    $0x7f,%esi
  8041602d0e:	d3 e6                	shl    %cl,%esi
  8041602d10:	09 f7                	or     %esi,%edi
    shift += 7;
  8041602d12:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602d15:	45 84 c0             	test   %r8b,%r8b
  8041602d18:	78 e0                	js     8041602cfa <naive_address_by_fname+0x2cb>
  return count;
  8041602d1a:	4d 63 db             	movslq %r11d,%r11
        curr_abbrev_entry += count;
  8041602d1d:	49 01 c3             	add    %rax,%r11
  8041602d20:	4c 89 d8             	mov    %r11,%rax
  shift  = 0;
  8041602d23:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602d28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  8041602d2e:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602d31:	48 83 c0 01          	add    $0x1,%rax
  8041602d35:	89 c3                	mov    %eax,%ebx
  8041602d37:	44 29 db             	sub    %r11d,%ebx
    result |= (byte & 0x7f) << shift;
  8041602d3a:	89 f2                	mov    %esi,%edx
  8041602d3c:	83 e2 7f             	and    $0x7f,%edx
  8041602d3f:	d3 e2                	shl    %cl,%edx
  8041602d41:	41 09 d0             	or     %edx,%r8d
    shift += 7;
  8041602d44:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602d47:	40 84 f6             	test   %sil,%sil
  8041602d4a:	78 e2                	js     8041602d2e <naive_address_by_fname+0x2ff>
  return count;
  8041602d4c:	48 63 db             	movslq %ebx,%rbx
        curr_abbrev_entry++;
  8041602d4f:	49 8d 44 1b 01       	lea    0x1(%r11,%rbx,1),%rax
        if (table_abbrev_code == abbrev_code) {
  8041602d54:	41 39 f9             	cmp    %edi,%r9d
  8041602d57:	0f 84 8d fe ff ff    	je     8041602bea <naive_address_by_fname+0x1bb>
  result = 0;
  8041602d5d:	48 89 c2             	mov    %rax,%rdx
  shift  = 0;
  8041602d60:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602d65:	bf 00 00 00 00       	mov    $0x0,%edi
    byte = *addr;
  8041602d6a:	44 0f b6 1a          	movzbl (%rdx),%r11d
    addr++;
  8041602d6e:	48 83 c2 01          	add    $0x1,%rdx
  8041602d72:	89 d3                	mov    %edx,%ebx
  8041602d74:	29 c3                	sub    %eax,%ebx
    result |= (byte & 0x7f) << shift;
  8041602d76:	44 89 de             	mov    %r11d,%esi
  8041602d79:	83 e6 7f             	and    $0x7f,%esi
  8041602d7c:	d3 e6                	shl    %cl,%esi
  8041602d7e:	09 f7                	or     %esi,%edi
    shift += 7;
  8041602d80:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602d83:	45 84 db             	test   %r11b,%r11b
  8041602d86:	78 e2                	js     8041602d6a <naive_address_by_fname+0x33b>
  return count;
  8041602d88:	48 63 db             	movslq %ebx,%rbx
          curr_abbrev_entry += count;
  8041602d8b:	48 01 c3             	add    %rax,%rbx
  8041602d8e:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602d91:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602d96:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041602d9c:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602d9f:	48 83 c0 01          	add    $0x1,%rax
  8041602da3:	41 89 c3             	mov    %eax,%r11d
  8041602da6:	41 29 db             	sub    %ebx,%r11d
    result |= (byte & 0x7f) << shift;
  8041602da9:	89 f2                	mov    %esi,%edx
  8041602dab:	83 e2 7f             	and    $0x7f,%edx
  8041602dae:	d3 e2                	shl    %cl,%edx
  8041602db0:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602db3:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602db6:	40 84 f6             	test   %sil,%sil
  8041602db9:	78 e1                	js     8041602d9c <naive_address_by_fname+0x36d>
  return count;
  8041602dbb:	4d 63 db             	movslq %r11d,%r11
          curr_abbrev_entry += count;
  8041602dbe:	4a 8d 04 1b          	lea    (%rbx,%r11,1),%rax
        } while (name != 0 || form != 0);
  8041602dc2:	41 09 fc             	or     %edi,%r12d
  8041602dc5:	75 96                	jne    8041602d5d <naive_address_by_fname+0x32e>
  8041602dc7:	e9 18 ff ff ff       	jmpq   8041602ce4 <naive_address_by_fname+0x2b5>
        uintptr_t low_pc = 0;
  8041602dcc:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8041602dd3:	00 
        int found        = 0;
  8041602dd4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%rbp)
  8041602ddb:	e9 98 00 00 00       	jmpq   8041602e78 <naive_address_by_fname+0x449>
            count = dwarf_read_abbrev_entry(
  8041602de0:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602de6:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041602deb:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  8041602def:	44 89 ee             	mov    %r13d,%esi
  8041602df2:	4c 89 ff             	mov    %r15,%rdi
  8041602df5:	41 ff d6             	callq  *%r14
  8041602df8:	eb 70                	jmp    8041602e6a <naive_address_by_fname+0x43b>
                  str_offset = 0;
  8041602dfa:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8041602e01:	00 
              count          = dwarf_read_abbrev_entry(
  8041602e02:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602e08:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041602e0d:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8041602e11:	be 0e 00 00 00       	mov    $0xe,%esi
  8041602e16:	4c 89 ff             	mov    %r15,%rdi
  8041602e19:	41 ff d6             	callq  *%r14
  8041602e1c:	41 89 c4             	mov    %eax,%r12d
              if (!strcmp(
  8041602e1f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8041602e23:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8041602e27:	48 03 70 40          	add    0x40(%rax),%rsi
  8041602e2b:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  8041602e2f:	48 b8 3c 49 60 41 80 	movabs $0x804160493c,%rax
  8041602e36:	00 00 00 
  8041602e39:	ff d0                	callq  *%rax
                found = 1;
  8041602e3b:	85 c0                	test   %eax,%eax
  8041602e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  8041602e42:	0f 45 45 bc          	cmovne -0x44(%rbp),%eax
  8041602e46:	89 45 bc             	mov    %eax,-0x44(%rbp)
          entry += count;
  8041602e49:	4d 63 e4             	movslq %r12d,%r12
  8041602e4c:	4d 01 e7             	add    %r12,%r15
  8041602e4f:	eb 27                	jmp    8041602e78 <naive_address_by_fname+0x449>
            count = dwarf_read_abbrev_entry(
  8041602e51:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602e57:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041602e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602e61:	44 89 ee             	mov    %r13d,%esi
  8041602e64:	4c 89 ff             	mov    %r15,%rdi
  8041602e67:	41 ff d6             	callq  *%r14
          entry += count;
  8041602e6a:	48 98                	cltq   
  8041602e6c:	49 01 c7             	add    %rax,%r15
        } while (name != 0 || form != 0);
  8041602e6f:	45 09 e5             	or     %r12d,%r13d
  8041602e72:	0f 84 bf 00 00 00    	je     8041602f37 <naive_address_by_fname+0x508>
        int found        = 0;
  8041602e78:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602e7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602e80:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  8041602e86:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602e89:	48 83 c0 01          	add    $0x1,%rax
  8041602e8d:	89 c7                	mov    %eax,%edi
  8041602e8f:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602e91:	89 f2                	mov    %esi,%edx
  8041602e93:	83 e2 7f             	and    $0x7f,%edx
  8041602e96:	d3 e2                	shl    %cl,%edx
  8041602e98:	41 09 d4             	or     %edx,%r12d
    shift += 7;
  8041602e9b:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602e9e:	40 84 f6             	test   %sil,%sil
  8041602ea1:	78 e3                	js     8041602e86 <naive_address_by_fname+0x457>
  return count;
  8041602ea3:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041602ea6:	48 01 fb             	add    %rdi,%rbx
  8041602ea9:	48 89 d8             	mov    %rbx,%rax
  shift  = 0;
  8041602eac:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041602eb1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    byte = *addr;
  8041602eb7:	0f b6 30             	movzbl (%rax),%esi
    addr++;
  8041602eba:	48 83 c0 01          	add    $0x1,%rax
  8041602ebe:	89 c7                	mov    %eax,%edi
  8041602ec0:	29 df                	sub    %ebx,%edi
    result |= (byte & 0x7f) << shift;
  8041602ec2:	89 f2                	mov    %esi,%edx
  8041602ec4:	83 e2 7f             	and    $0x7f,%edx
  8041602ec7:	d3 e2                	shl    %cl,%edx
  8041602ec9:	41 09 d5             	or     %edx,%r13d
    shift += 7;
  8041602ecc:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041602ecf:	40 84 f6             	test   %sil,%sil
  8041602ed2:	78 e3                	js     8041602eb7 <naive_address_by_fname+0x488>
  return count;
  8041602ed4:	48 63 ff             	movslq %edi,%rdi
          curr_abbrev_entry += count;
  8041602ed7:	48 01 fb             	add    %rdi,%rbx
          if (name == DW_AT_low_pc) {
  8041602eda:	41 83 fc 11          	cmp    $0x11,%r12d
  8041602ede:	0f 84 fc fe ff ff    	je     8041602de0 <naive_address_by_fname+0x3b1>
          } else if (name == DW_AT_name) {
  8041602ee4:	41 83 fc 03          	cmp    $0x3,%r12d
  8041602ee8:	0f 85 63 ff ff ff    	jne    8041602e51 <naive_address_by_fname+0x422>
            if (form == DW_FORM_strp) {
  8041602eee:	41 83 fd 0e          	cmp    $0xe,%r13d
  8041602ef2:	0f 84 02 ff ff ff    	je     8041602dfa <naive_address_by_fname+0x3cb>
              if (!strcmp(fname, entry)) {
  8041602ef8:	4c 89 fe             	mov    %r15,%rsi
  8041602efb:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  8041602eff:	48 b8 3c 49 60 41 80 	movabs $0x804160493c,%rax
  8041602f06:	00 00 00 
  8041602f09:	ff d0                	callq  *%rax
                found = 1;
  8041602f0b:	85 c0                	test   %eax,%eax
  8041602f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  8041602f12:	0f 45 45 bc          	cmovne -0x44(%rbp),%eax
  8041602f16:	89 45 bc             	mov    %eax,-0x44(%rbp)
              count = dwarf_read_abbrev_entry(
  8041602f19:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041602f1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8041602f24:	ba 00 00 00 00       	mov    $0x0,%edx
  8041602f29:	44 89 ee             	mov    %r13d,%esi
  8041602f2c:	4c 89 ff             	mov    %r15,%rdi
  8041602f2f:	41 ff d6             	callq  *%r14
  8041602f32:	e9 33 ff ff ff       	jmpq   8041602e6a <naive_address_by_fname+0x43b>
        if (found) {
  8041602f37:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  8041602f3b:	0f 84 49 fd ff ff    	je     8041602c8a <naive_address_by_fname+0x25b>
          *offset = low_pc;
  8041602f41:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041602f45:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8041602f49:	48 89 07             	mov    %rax,(%rdi)
          return 0;
  8041602f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602f51:	e9 67 fb ff ff       	jmpq   8041602abd <naive_address_by_fname+0x8e>
    while (entry < entry_end) {
  8041602f56:	4c 39 7d a0          	cmp    %r15,-0x60(%rbp)
  8041602f5a:	0f 87 34 fd ff ff    	ja     8041602c94 <naive_address_by_fname+0x265>
  8041602f60:	e9 05 fb ff ff       	jmpq   8041602a6a <naive_address_by_fname+0x3b>
  return 0;
  8041602f65:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602f6a:	e9 4e fb ff ff       	jmpq   8041602abd <naive_address_by_fname+0x8e>
    return 0;
  8041602f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602f74:	e9 44 fb ff ff       	jmpq   8041602abd <naive_address_by_fname+0x8e>

0000008041602f79 <line_for_address>:
// contain an offset in .debug_line of entry associated with compilation unit,
// in which we search address `p`. This offset can be obtained from .debug_info
// section, using the `file_name_by_info` function.
int
line_for_address(const struct Dwarf_Addrs *addrs, uintptr_t p,
                 Dwarf_Off line_offset, int *lineno_store) {
  8041602f79:	55                   	push   %rbp
  8041602f7a:	48 89 e5             	mov    %rsp,%rbp
  8041602f7d:	41 57                	push   %r15
  8041602f7f:	41 56                	push   %r14
  8041602f81:	41 55                	push   %r13
  8041602f83:	41 54                	push   %r12
  8041602f85:	53                   	push   %rbx
  8041602f86:	48 83 ec 48          	sub    $0x48,%rsp
  if (line_offset > addrs->line_end - addrs->line_begin) {
  8041602f8a:	48 8b 5f 30          	mov    0x30(%rdi),%rbx
  8041602f8e:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8041602f92:	48 29 d8             	sub    %rbx,%rax
    return -E_INVAL;
  }
  if (lineno_store == NULL) {
  8041602f95:	48 39 d0             	cmp    %rdx,%rax
  8041602f98:	0f 82 e2 06 00 00    	jb     8041603680 <line_for_address+0x707>
  8041602f9e:	48 85 c9             	test   %rcx,%rcx
  8041602fa1:	0f 84 d9 06 00 00    	je     8041603680 <line_for_address+0x707>
  8041602fa7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
  8041602fab:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
    return -E_INVAL;
  }
  const void *curr_addr                  = addrs->line_begin + line_offset;
  8041602faf:	48 01 d3             	add    %rdx,%rbx
  initial_len = get_unaligned(addr, uint32_t);
  8041602fb2:	ba 04 00 00 00       	mov    $0x4,%edx
  8041602fb7:	48 89 de             	mov    %rbx,%rsi
  8041602fba:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041602fbe:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041602fc5:	00 00 00 
  8041602fc8:	ff d0                	callq  *%rax
  8041602fca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  8041602fcd:	83 f8 ef             	cmp    $0xffffffef,%eax
  8041602fd0:	76 4e                	jbe    8041603020 <line_for_address+0xa7>
    if (initial_len == DW_EXT_DWARF64) {
  8041602fd2:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041602fd5:	74 25                	je     8041602ffc <line_for_address+0x83>
      cprintf("Unknown DWARF extension\n");
  8041602fd7:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  8041602fde:	00 00 00 
  8041602fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  8041602fe6:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041602fed:	00 00 00 
  8041602ff0:	ff d2                	callq  *%rdx

  // Parse Line Number Program Header.
  unsigned long unit_length;
  int count = dwarf_entry_len(curr_addr, &unit_length);
  if (count == 0) {
    return -E_BAD_DWARF;
  8041602ff2:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  8041602ff7:	e9 75 06 00 00       	jmpq   8041603671 <line_for_address+0x6f8>
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  8041602ffc:	48 8d 73 20          	lea    0x20(%rbx),%rsi
  8041603000:	ba 08 00 00 00       	mov    $0x8,%edx
  8041603005:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603009:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041603010:	00 00 00 
  8041603013:	ff d0                	callq  *%rax
  8041603015:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  8041603019:	ba 0c 00 00 00       	mov    $0xc,%edx
  804160301e:	eb 07                	jmp    8041603027 <line_for_address+0xae>
    *len = initial_len;
  8041603020:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041603022:	ba 04 00 00 00       	mov    $0x4,%edx
  } else {
    curr_addr += count;
  8041603027:	48 63 d2             	movslq %edx,%rdx
  804160302a:	48 01 d3             	add    %rdx,%rbx
  }
  const void *unit_end = curr_addr + unit_length;
  804160302d:	48 01 d8             	add    %rbx,%rax
  8041603030:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  Dwarf_Half version   = get_unaligned(curr_addr, Dwarf_Half);
  8041603034:	ba 02 00 00 00       	mov    $0x2,%edx
  8041603039:	48 89 de             	mov    %rbx,%rsi
  804160303c:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603040:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041603047:	00 00 00 
  804160304a:	ff d0                	callq  *%rax
  804160304c:	44 0f b7 75 c8       	movzwl -0x38(%rbp),%r14d
  curr_addr += sizeof(Dwarf_Half);
  8041603051:	4c 8d 6b 02          	lea    0x2(%rbx),%r13
  assert(version == 4 || version == 3 || version == 2);
  8041603055:	41 8d 46 fe          	lea    -0x2(%r14),%eax
  8041603059:	66 83 f8 02          	cmp    $0x2,%ax
  804160305d:	77 4e                	ja     80416030ad <line_for_address+0x134>
  initial_len = get_unaligned(addr, uint32_t);
  804160305f:	ba 04 00 00 00       	mov    $0x4,%edx
  8041603064:	4c 89 ee             	mov    %r13,%rsi
  8041603067:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160306b:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041603072:	00 00 00 
  8041603075:	ff d0                	callq  *%rax
  8041603077:	8b 45 c8             	mov    -0x38(%rbp),%eax
  if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
  804160307a:	83 f8 ef             	cmp    $0xffffffef,%eax
  804160307d:	0f 86 83 00 00 00    	jbe    8041603106 <line_for_address+0x18d>
    if (initial_len == DW_EXT_DWARF64) {
  8041603083:	83 f8 ff             	cmp    $0xffffffff,%eax
  8041603086:	74 5a                	je     80416030e2 <line_for_address+0x169>
      cprintf("Unknown DWARF extension\n");
  8041603088:	48 bf 60 50 60 41 80 	movabs $0x8041605060,%rdi
  804160308f:	00 00 00 
  8041603092:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603097:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160309e:	00 00 00 
  80416030a1:	ff d2                	callq  *%rdx
  unsigned long header_length;
  count = dwarf_entry_len(curr_addr, &header_length);
  if (count == 0) {
    return -E_BAD_DWARF;
  80416030a3:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
  80416030a8:	e9 c4 05 00 00       	jmpq   8041603671 <line_for_address+0x6f8>
  assert(version == 4 || version == 3 || version == 2);
  80416030ad:	48 b9 88 52 60 41 80 	movabs $0x8041605288,%rcx
  80416030b4:	00 00 00 
  80416030b7:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416030be:	00 00 00 
  80416030c1:	be fc 00 00 00       	mov    $0xfc,%esi
  80416030c6:	48 bf 41 52 60 41 80 	movabs $0x8041605241,%rdi
  80416030cd:	00 00 00 
  80416030d0:	b8 00 00 00 00       	mov    $0x0,%eax
  80416030d5:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416030dc:	00 00 00 
  80416030df:	41 ff d0             	callq  *%r8
      *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
  80416030e2:	48 8d 73 22          	lea    0x22(%rbx),%rsi
  80416030e6:	ba 08 00 00 00       	mov    $0x8,%edx
  80416030eb:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416030ef:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  80416030f6:	00 00 00 
  80416030f9:	ff d0                	callq  *%rax
  80416030fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
      count = 12;
  80416030ff:	ba 0c 00 00 00       	mov    $0xc,%edx
  8041603104:	eb 07                	jmp    804160310d <line_for_address+0x194>
    *len = initial_len;
  8041603106:	89 c0                	mov    %eax,%eax
  count       = 4;
  8041603108:	ba 04 00 00 00       	mov    $0x4,%edx
  } else {
    curr_addr += count;
  804160310d:	48 63 d2             	movslq %edx,%rdx
  8041603110:	49 01 d5             	add    %rdx,%r13
  }
  const void *program_addr = curr_addr + header_length;
  8041603113:	49 8d 5c 05 00       	lea    0x0(%r13,%rax,1),%rbx
  Dwarf_Small minimum_instruction_length =
      get_unaligned(curr_addr, Dwarf_Small);
  8041603118:	ba 01 00 00 00       	mov    $0x1,%edx
  804160311d:	4c 89 ee             	mov    %r13,%rsi
  8041603120:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603124:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  804160312b:	00 00 00 
  804160312e:	ff d0                	callq  *%rax
  assert(minimum_instruction_length == 1);
  8041603130:	80 7d c8 01          	cmpb   $0x1,-0x38(%rbp)
  8041603134:	0f 85 91 00 00 00    	jne    80416031cb <line_for_address+0x252>
  curr_addr += sizeof(Dwarf_Small);
  804160313a:	4d 8d 65 01          	lea    0x1(%r13),%r12
  Dwarf_Small maximum_operations_per_instruction;
  if (version == 4) {
  804160313e:	66 41 83 fe 04       	cmp    $0x4,%r14w
  8041603143:	0f 84 b7 00 00 00    	je     8041603200 <line_for_address+0x287>
  } else {
    maximum_operations_per_instruction = 1;
  }
  assert(maximum_operations_per_instruction == 1);
  // Skip default_is_stmt as we don't need it.
  curr_addr += sizeof(Dwarf_Small);
  8041603149:	49 8d 74 24 01       	lea    0x1(%r12),%rsi
  signed char line_base = get_unaligned(curr_addr, signed char);
  804160314e:	ba 01 00 00 00       	mov    $0x1,%edx
  8041603153:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603157:	49 bd d0 4a 60 41 80 	movabs $0x8041604ad0,%r13
  804160315e:	00 00 00 
  8041603161:	41 ff d5             	callq  *%r13
  8041603164:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
  8041603168:	88 45 bd             	mov    %al,-0x43(%rbp)
  curr_addr += sizeof(signed char);
  804160316b:	49 8d 74 24 02       	lea    0x2(%r12),%rsi
  Dwarf_Small line_range = get_unaligned(curr_addr, Dwarf_Small);
  8041603170:	ba 01 00 00 00       	mov    $0x1,%edx
  8041603175:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603179:	41 ff d5             	callq  *%r13
  804160317c:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
  8041603180:	88 45 be             	mov    %al,-0x42(%rbp)
  curr_addr += sizeof(Dwarf_Small);
  8041603183:	49 8d 74 24 03       	lea    0x3(%r12),%rsi
  Dwarf_Small opcode_base = get_unaligned(curr_addr, Dwarf_Small);
  8041603188:	ba 01 00 00 00       	mov    $0x1,%edx
  804160318d:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  8041603191:	41 ff d5             	callq  *%r13
  8041603194:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
  8041603198:	88 45 bf             	mov    %al,-0x41(%rbp)
  curr_addr += sizeof(Dwarf_Small);
  804160319b:	49 8d 74 24 04       	lea    0x4(%r12),%rsi
  Dwarf_Small *standard_opcode_lengths =
      (Dwarf_Small *)get_unaligned(curr_addr, Dwarf_Small *);
  80416031a0:	ba 08 00 00 00       	mov    $0x8,%edx
  80416031a5:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416031a9:	41 ff d5             	callq  *%r13
  while (program_addr < end_addr) {
  80416031ac:	48 39 5d b0          	cmp    %rbx,-0x50(%rbp)
  80416031b0:	0f 86 8e 04 00 00    	jbe    8041603644 <line_for_address+0x6cb>
  struct Line_Number_State current_state = {
  80416031b6:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
  80416031bd:	41 be 00 00 00 00    	mov    $0x0,%r14d
    Dwarf_Small opcode = get_unaligned(program_addr, Dwarf_Small);
  80416031c3:	4d 89 ef             	mov    %r13,%r15
  80416031c6:	e9 e1 01 00 00       	jmpq   80416033ac <line_for_address+0x433>
  assert(minimum_instruction_length == 1);
  80416031cb:	48 b9 b8 52 60 41 80 	movabs $0x80416052b8,%rcx
  80416031d2:	00 00 00 
  80416031d5:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  80416031dc:	00 00 00 
  80416031df:	be 07 01 00 00       	mov    $0x107,%esi
  80416031e4:	48 bf 41 52 60 41 80 	movabs $0x8041605241,%rdi
  80416031eb:	00 00 00 
  80416031ee:	b8 00 00 00 00       	mov    $0x0,%eax
  80416031f3:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416031fa:	00 00 00 
  80416031fd:	41 ff d0             	callq  *%r8
        get_unaligned(curr_addr, Dwarf_Small);
  8041603200:	ba 01 00 00 00       	mov    $0x1,%edx
  8041603205:	4c 89 e6             	mov    %r12,%rsi
  8041603208:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160320c:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041603213:	00 00 00 
  8041603216:	ff d0                	callq  *%rax
    curr_addr += sizeof(Dwarf_Small);
  8041603218:	4d 8d 65 02          	lea    0x2(%r13),%r12
  assert(maximum_operations_per_instruction == 1);
  804160321c:	80 7d c8 01          	cmpb   $0x1,-0x38(%rbp)
  8041603220:	0f 84 23 ff ff ff    	je     8041603149 <line_for_address+0x1d0>
  8041603226:	48 b9 d8 52 60 41 80 	movabs $0x80416052d8,%rcx
  804160322d:	00 00 00 
  8041603230:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041603237:	00 00 00 
  804160323a:	be 11 01 00 00       	mov    $0x111,%esi
  804160323f:	48 bf 41 52 60 41 80 	movabs $0x8041605241,%rdi
  8041603246:	00 00 00 
  8041603249:	b8 00 00 00 00       	mov    $0x0,%eax
  804160324e:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041603255:	00 00 00 
  8041603258:	41 ff d0             	callq  *%r8
    if (opcode == 0) {
  804160325b:	48 89 f2             	mov    %rsi,%rdx
  count  = 0;
  804160325e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  shift  = 0;
  8041603264:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  8041603269:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    byte = *addr;
  804160326f:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  8041603272:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  8041603276:	41 83 c5 01          	add    $0x1,%r13d
    result |= (byte & 0x7f) << shift;
  804160327a:	89 f8                	mov    %edi,%eax
  804160327c:	83 e0 7f             	and    $0x7f,%eax
  804160327f:	d3 e0                	shl    %cl,%eax
  8041603281:	41 09 c4             	or     %eax,%r12d
    shift += 7;
  8041603284:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  8041603287:	40 84 ff             	test   %dil,%dil
  804160328a:	78 e3                	js     804160326f <line_for_address+0x2f6>
  return count;
  804160328c:	4d 63 ed             	movslq %r13d,%r13
      program_addr += count;
  804160328f:	49 01 f5             	add    %rsi,%r13
      const void *opcode_end = program_addr + length;
  8041603292:	45 89 e4             	mov    %r12d,%r12d
  8041603295:	4d 01 ec             	add    %r13,%r12
      opcode                 = get_unaligned(program_addr, Dwarf_Small);
  8041603298:	ba 01 00 00 00       	mov    $0x1,%edx
  804160329d:	4c 89 ee             	mov    %r13,%rsi
  80416032a0:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416032a4:	41 ff d7             	callq  *%r15
  80416032a7:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
      program_addr += sizeof(Dwarf_Small);
  80416032ab:	49 8d 5d 01          	lea    0x1(%r13),%rbx
      switch (opcode) {
  80416032af:	3c 02                	cmp    $0x2,%al
  80416032b1:	0f 84 cb 00 00 00    	je     8041603382 <line_for_address+0x409>
  80416032b7:	3c 02                	cmp    $0x2,%al
  80416032b9:	76 2d                	jbe    80416032e8 <line_for_address+0x36f>
  80416032bb:	3c 03                	cmp    $0x3,%al
  80416032bd:	74 61                	je     8041603320 <line_for_address+0x3a7>
  80416032bf:	3c 04                	cmp    $0x4,%al
  80416032c1:	0f 85 25 01 00 00    	jne    80416033ec <line_for_address+0x473>
  80416032c7:	48 89 d8             	mov    %rbx,%rax
  count  = 0;
  80416032ca:	ba 00 00 00 00       	mov    $0x0,%edx
    byte = *addr;
  80416032cf:	0f b6 08             	movzbl (%rax),%ecx
    addr++;
  80416032d2:	48 83 c0 01          	add    $0x1,%rax
    count++;
  80416032d6:	83 c2 01             	add    $0x1,%edx
    if (!(byte & 0x80))
  80416032d9:	84 c9                	test   %cl,%cl
  80416032db:	78 f2                	js     80416032cf <line_for_address+0x356>
  return count;
  80416032dd:	48 63 d2             	movslq %edx,%rdx
          program_addr += count;
  80416032e0:	48 01 d3             	add    %rdx,%rbx
  80416032e3:	e9 b1 00 00 00       	jmpq   8041603399 <line_for_address+0x420>
      switch (opcode) {
  80416032e8:	3c 01                	cmp    $0x1,%al
  80416032ea:	0f 85 fc 00 00 00    	jne    80416033ec <line_for_address+0x473>
          if (last_state.address <= destination_addr &&
  80416032f0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80416032f4:	48 39 45 a8          	cmp    %rax,-0x58(%rbp)
  80416032f8:	0f 87 1c 01 00 00    	ja     804160341a <line_for_address+0x4a1>
  80416032fe:	4c 39 f0             	cmp    %r14,%rax
  8041603301:	0f 82 46 03 00 00    	jb     804160364d <line_for_address+0x6d4>
          last_state           = *state;
  8041603307:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804160330a:	89 45 9c             	mov    %eax,-0x64(%rbp)
  804160330d:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
          state->line          = 1;
  8041603311:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
          state->address       = 0;
  8041603318:	41 be 00 00 00 00    	mov    $0x0,%r14d
  804160331e:	eb 79                	jmp    8041603399 <line_for_address+0x420>
          while (*(char *)program_addr) {
  8041603320:	41 80 7d 01 00       	cmpb   $0x0,0x1(%r13)
  8041603325:	74 09                	je     8041603330 <line_for_address+0x3b7>
            ++program_addr;
  8041603327:	48 83 c3 01          	add    $0x1,%rbx
          while (*(char *)program_addr) {
  804160332b:	80 3b 00             	cmpb   $0x0,(%rbx)
  804160332e:	75 f7                	jne    8041603327 <line_for_address+0x3ae>
          ++program_addr;
  8041603330:	48 83 c3 01          	add    $0x1,%rbx
  8041603334:	48 89 d8             	mov    %rbx,%rax
  count  = 0;
  8041603337:	ba 00 00 00 00       	mov    $0x0,%edx
    byte = *addr;
  804160333c:	0f b6 08             	movzbl (%rax),%ecx
    addr++;
  804160333f:	48 83 c0 01          	add    $0x1,%rax
    count++;
  8041603343:	83 c2 01             	add    $0x1,%edx
    if (!(byte & 0x80))
  8041603346:	84 c9                	test   %cl,%cl
  8041603348:	78 f2                	js     804160333c <line_for_address+0x3c3>
  return count;
  804160334a:	48 63 d2             	movslq %edx,%rdx
          program_addr += count;
  804160334d:	48 01 d3             	add    %rdx,%rbx
  8041603350:	48 89 d8             	mov    %rbx,%rax
    byte = *addr;
  8041603353:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  8041603356:	48 83 c0 01          	add    $0x1,%rax
  804160335a:	89 c1                	mov    %eax,%ecx
  804160335c:	29 d9                	sub    %ebx,%ecx
    if (!(byte & 0x80))
  804160335e:	84 d2                	test   %dl,%dl
  8041603360:	78 f1                	js     8041603353 <line_for_address+0x3da>
  return count;
  8041603362:	48 63 c9             	movslq %ecx,%rcx
          program_addr += count;
  8041603365:	48 01 cb             	add    %rcx,%rbx
  8041603368:	48 89 d8             	mov    %rbx,%rax
    byte = *addr;
  804160336b:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  804160336e:	48 83 c0 01          	add    $0x1,%rax
  8041603372:	89 c1                	mov    %eax,%ecx
  8041603374:	29 d9                	sub    %ebx,%ecx
    if (!(byte & 0x80))
  8041603376:	84 d2                	test   %dl,%dl
  8041603378:	78 f1                	js     804160336b <line_for_address+0x3f2>
  return count;
  804160337a:	48 63 c9             	movslq %ecx,%rcx
          program_addr += count;
  804160337d:	48 01 cb             	add    %rcx,%rbx
  8041603380:	eb 17                	jmp    8041603399 <line_for_address+0x420>
              get_unaligned(program_addr, uintptr_t);
  8041603382:	ba 08 00 00 00       	mov    $0x8,%edx
  8041603387:	48 89 de             	mov    %rbx,%rsi
  804160338a:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160338e:	41 ff d7             	callq  *%r15
  8041603391:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
          program_addr += sizeof(uintptr_t);
  8041603395:	49 8d 5d 09          	lea    0x9(%r13),%rbx
      assert(program_addr == opcode_end);
  8041603399:	49 39 dc             	cmp    %rbx,%r12
  804160339c:	0f 85 94 00 00 00    	jne    8041603436 <line_for_address+0x4bd>
  while (program_addr < end_addr) {
  80416033a2:	48 39 5d b0          	cmp    %rbx,-0x50(%rbp)
  80416033a6:	0f 86 b7 02 00 00    	jbe    8041603663 <line_for_address+0x6ea>
    Dwarf_Small opcode = get_unaligned(program_addr, Dwarf_Small);
  80416033ac:	ba 01 00 00 00       	mov    $0x1,%edx
  80416033b1:	48 89 de             	mov    %rbx,%rsi
  80416033b4:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  80416033b8:	41 ff d7             	callq  *%r15
  80416033bb:	0f b6 45 c8          	movzbl -0x38(%rbp),%eax
    program_addr += sizeof(Dwarf_Small);
  80416033bf:	48 8d 73 01          	lea    0x1(%rbx),%rsi
    if (opcode == 0) {
  80416033c3:	84 c0                	test   %al,%al
  80416033c5:	0f 84 90 fe ff ff    	je     804160325b <line_for_address+0x2e2>
    } else if (opcode < info->opcode_base) {
  80416033cb:	38 45 bf             	cmp    %al,-0x41(%rbp)
  80416033ce:	0f 86 1a 02 00 00    	jbe    80416035ee <line_for_address+0x675>
      switch (opcode) {
  80416033d4:	3c 0c                	cmp    $0xc,%al
  80416033d6:	0f 87 e4 01 00 00    	ja     80416035c0 <line_for_address+0x647>
  80416033dc:	0f b6 d0             	movzbl %al,%edx
  80416033df:	48 bf 00 53 60 41 80 	movabs $0x8041605300,%rdi
  80416033e6:	00 00 00 
  80416033e9:	ff 24 d7             	jmpq   *(%rdi,%rdx,8)
      switch (opcode) {
  80416033ec:	0f b6 c8             	movzbl %al,%ecx
          panic("Unknown opcode: %x", opcode);
  80416033ef:	48 ba 54 52 60 41 80 	movabs $0x8041605254,%rdx
  80416033f6:	00 00 00 
  80416033f9:	be 6b 00 00 00       	mov    $0x6b,%esi
  80416033fe:	48 bf 41 52 60 41 80 	movabs $0x8041605241,%rdi
  8041603405:	00 00 00 
  8041603408:	b8 00 00 00 00       	mov    $0x0,%eax
  804160340d:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041603414:	00 00 00 
  8041603417:	41 ff d0             	callq  *%r8
          last_state           = *state;
  804160341a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804160341d:	89 45 9c             	mov    %eax,-0x64(%rbp)
  8041603420:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
          state->line          = 1;
  8041603424:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
          state->address       = 0;
  804160342b:	41 be 00 00 00 00    	mov    $0x0,%r14d
  8041603431:	e9 63 ff ff ff       	jmpq   8041603399 <line_for_address+0x420>
      assert(program_addr == opcode_end);
  8041603436:	48 b9 67 52 60 41 80 	movabs $0x8041605267,%rcx
  804160343d:	00 00 00 
  8041603440:	48 ba 79 50 60 41 80 	movabs $0x8041605079,%rdx
  8041603447:	00 00 00 
  804160344a:	be 6e 00 00 00       	mov    $0x6e,%esi
  804160344f:	48 bf 41 52 60 41 80 	movabs $0x8041605241,%rdi
  8041603456:	00 00 00 
  8041603459:	b8 00 00 00 00       	mov    $0x0,%eax
  804160345e:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  8041603465:	00 00 00 
  8041603468:	41 ff d0             	callq  *%r8
          if (last_state.address <= destination_addr &&
  804160346b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804160346f:	48 39 45 a8          	cmp    %rax,-0x58(%rbp)
  8041603473:	0f 87 b9 01 00 00    	ja     8041603632 <line_for_address+0x6b9>
  8041603479:	4c 39 f0             	cmp    %r14,%rax
  804160347c:	0f 82 d3 01 00 00    	jb     8041603655 <line_for_address+0x6dc>
          last_state           = *state;
  8041603482:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8041603485:	89 45 9c             	mov    %eax,-0x64(%rbp)
  8041603488:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
    program_addr += sizeof(Dwarf_Small);
  804160348c:	48 89 f3             	mov    %rsi,%rbx
  804160348f:	e9 0e ff ff ff       	jmpq   80416033a2 <line_for_address+0x429>
      switch (opcode) {
  8041603494:	48 89 f2             	mov    %rsi,%rdx
  count  = 0;
  8041603497:	bb 00 00 00 00       	mov    $0x0,%ebx
  shift  = 0;
  804160349c:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416034a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416034a7:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  80416034aa:	48 83 c2 01          	add    $0x1,%rdx
    count++;
  80416034ae:	83 c3 01             	add    $0x1,%ebx
    result |= (byte & 0x7f) << shift;
  80416034b1:	89 f8                	mov    %edi,%eax
  80416034b3:	83 e0 7f             	and    $0x7f,%eax
  80416034b6:	d3 e0                	shl    %cl,%eax
  80416034b8:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  80416034bb:	83 c1 07             	add    $0x7,%ecx
    if (!(byte & 0x80))
  80416034be:	40 84 ff             	test   %dil,%dil
  80416034c1:	78 e4                	js     80416034a7 <line_for_address+0x52e>
              info->minimum_instruction_length *
  80416034c3:	45 89 c0             	mov    %r8d,%r8d
          state->address +=
  80416034c6:	4d 01 c6             	add    %r8,%r14
  return count;
  80416034c9:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  80416034cc:	48 01 f3             	add    %rsi,%rbx
  80416034cf:	e9 ce fe ff ff       	jmpq   80416033a2 <line_for_address+0x429>
      switch (opcode) {
  80416034d4:	48 89 f2             	mov    %rsi,%rdx
  count  = 0;
  80416034d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  shift  = 0;
  80416034dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  result = 0;
  80416034e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    byte = *addr;
  80416034e7:	0f b6 3a             	movzbl (%rdx),%edi
    addr++;
  80416034ea:	48 83 c2 01          	add    $0x1,%rdx
    result |= (byte & 0x7f) << shift;
  80416034ee:	89 f8                	mov    %edi,%eax
  80416034f0:	83 e0 7f             	and    $0x7f,%eax
  80416034f3:	d3 e0                	shl    %cl,%eax
  80416034f5:	41 09 c0             	or     %eax,%r8d
    shift += 7;
  80416034f8:	83 c1 07             	add    $0x7,%ecx
    count++;
  80416034fb:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  80416034fe:	40 84 ff             	test   %dil,%dil
  8041603501:	78 e4                	js     80416034e7 <line_for_address+0x56e>
  if ((shift < num_bits) && (byte & 0x40))
  8041603503:	83 f9 1f             	cmp    $0x1f,%ecx
  8041603506:	7f 10                	jg     8041603518 <line_for_address+0x59f>
  8041603508:	40 f6 c7 40          	test   $0x40,%dil
  804160350c:	74 0a                	je     8041603518 <line_for_address+0x59f>
    result |= (-1U << shift);
  804160350e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8041603513:	d3 e0                	shl    %cl,%eax
  8041603515:	41 09 c0             	or     %eax,%r8d
          state->line += line_incr;
  8041603518:	44 01 45 b8          	add    %r8d,-0x48(%rbp)
  return count;
  804160351c:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  804160351f:	48 01 f3             	add    %rsi,%rbx
  8041603522:	e9 7b fe ff ff       	jmpq   80416033a2 <line_for_address+0x429>
      switch (opcode) {
  8041603527:	48 89 f0             	mov    %rsi,%rax
  count  = 0;
  804160352a:	bb 00 00 00 00       	mov    $0x0,%ebx
    byte = *addr;
  804160352f:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  8041603532:	48 83 c0 01          	add    $0x1,%rax
    count++;
  8041603536:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  8041603539:	84 d2                	test   %dl,%dl
  804160353b:	78 f2                	js     804160352f <line_for_address+0x5b6>
  return count;
  804160353d:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  8041603540:	48 01 f3             	add    %rsi,%rbx
  8041603543:	e9 5a fe ff ff       	jmpq   80416033a2 <line_for_address+0x429>
      switch (opcode) {
  8041603548:	48 89 f0             	mov    %rsi,%rax
  count  = 0;
  804160354b:	bb 00 00 00 00       	mov    $0x0,%ebx
    byte = *addr;
  8041603550:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  8041603553:	48 83 c0 01          	add    $0x1,%rax
    count++;
  8041603557:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  804160355a:	84 d2                	test   %dl,%dl
  804160355c:	78 f2                	js     8041603550 <line_for_address+0x5d7>
  return count;
  804160355e:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  8041603561:	48 01 f3             	add    %rsi,%rbx
  8041603564:	e9 39 fe ff ff       	jmpq   80416033a2 <line_for_address+0x429>
          Dwarf_Small adjusted_opcode =
  8041603569:	0f b6 45 bf          	movzbl -0x41(%rbp),%eax
  804160356d:	f7 d0                	not    %eax
              adjusted_opcode / info->line_range;
  804160356f:	0f b6 c0             	movzbl %al,%eax
  8041603572:	f6 75 be             	divb   -0x42(%rbp)
              info->minimum_instruction_length *
  8041603575:	0f b6 c0             	movzbl %al,%eax
          state->address +=
  8041603578:	49 01 c6             	add    %rax,%r14
    program_addr += sizeof(Dwarf_Small);
  804160357b:	48 89 f3             	mov    %rsi,%rbx
  804160357e:	e9 1f fe ff ff       	jmpq   80416033a2 <line_for_address+0x429>
              get_unaligned(program_addr, Dwarf_Half);
  8041603583:	ba 02 00 00 00       	mov    $0x2,%edx
  8041603588:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  804160358c:	41 ff d7             	callq  *%r15
          state->address += pc_inc;
  804160358f:	0f b7 45 c8          	movzwl -0x38(%rbp),%eax
  8041603593:	49 01 c6             	add    %rax,%r14
          program_addr += sizeof(Dwarf_Half);
  8041603596:	48 83 c3 03          	add    $0x3,%rbx
  804160359a:	e9 03 fe ff ff       	jmpq   80416033a2 <line_for_address+0x429>
      switch (opcode) {
  804160359f:	48 89 f0             	mov    %rsi,%rax
  count  = 0;
  80416035a2:	bb 00 00 00 00       	mov    $0x0,%ebx
    byte = *addr;
  80416035a7:	0f b6 10             	movzbl (%rax),%edx
    addr++;
  80416035aa:	48 83 c0 01          	add    $0x1,%rax
    count++;
  80416035ae:	83 c3 01             	add    $0x1,%ebx
    if (!(byte & 0x80))
  80416035b1:	84 d2                	test   %dl,%dl
  80416035b3:	78 f2                	js     80416035a7 <line_for_address+0x62e>
  return count;
  80416035b5:	48 63 db             	movslq %ebx,%rbx
          program_addr += count;
  80416035b8:	48 01 f3             	add    %rsi,%rbx
  80416035bb:	e9 e2 fd ff ff       	jmpq   80416033a2 <line_for_address+0x429>
      switch (opcode) {
  80416035c0:	0f b6 c8             	movzbl %al,%ecx
          panic("Unknown opcode: %x", opcode);
  80416035c3:	48 ba 54 52 60 41 80 	movabs $0x8041605254,%rdx
  80416035ca:	00 00 00 
  80416035cd:	be c1 00 00 00       	mov    $0xc1,%esi
  80416035d2:	48 bf 41 52 60 41 80 	movabs $0x8041605241,%rdi
  80416035d9:	00 00 00 
  80416035dc:	b8 00 00 00 00       	mov    $0x0,%eax
  80416035e1:	49 b8 e5 02 60 41 80 	movabs $0x80416002e5,%r8
  80416035e8:	00 00 00 
  80416035eb:	41 ff d0             	callq  *%r8
      Dwarf_Small adjusted_opcode =
  80416035ee:	2a 45 bf             	sub    -0x41(%rbp),%al
                      (adjusted_opcode % info->line_range));
  80416035f1:	0f b6 c0             	movzbl %al,%eax
  80416035f4:	f6 75 be             	divb   -0x42(%rbp)
  80416035f7:	0f b6 d4             	movzbl %ah,%edx
      state->line += (info->line_base +
  80416035fa:	0f be 4d bd          	movsbl -0x43(%rbp),%ecx
  80416035fe:	01 ca                	add    %ecx,%edx
  8041603600:	01 55 b8             	add    %edx,-0x48(%rbp)
          info->minimum_instruction_length *
  8041603603:	0f b6 c0             	movzbl %al,%eax
      state->address +=
  8041603606:	49 01 c6             	add    %rax,%r14
      if (last_state.address <= destination_addr &&
  8041603609:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804160360d:	48 39 45 a8          	cmp    %rax,-0x58(%rbp)
  8041603611:	77 05                	ja     8041603618 <line_for_address+0x69f>
  8041603613:	4c 39 f0             	cmp    %r14,%rax
  8041603616:	72 45                	jb     804160365d <line_for_address+0x6e4>
      last_state = *state;
  8041603618:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804160361b:	89 45 9c             	mov    %eax,-0x64(%rbp)
  804160361e:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
    program_addr += sizeof(Dwarf_Small);
  8041603622:	48 89 f3             	mov    %rsi,%rbx
  8041603625:	e9 78 fd ff ff       	jmpq   80416033a2 <line_for_address+0x429>
  804160362a:	48 89 f3             	mov    %rsi,%rbx
  804160362d:	e9 70 fd ff ff       	jmpq   80416033a2 <line_for_address+0x429>
          last_state           = *state;
  8041603632:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8041603635:	89 45 9c             	mov    %eax,-0x64(%rbp)
  8041603638:	4c 89 75 a8          	mov    %r14,-0x58(%rbp)
    program_addr += sizeof(Dwarf_Small);
  804160363c:	48 89 f3             	mov    %rsi,%rbx
  804160363f:	e9 5e fd ff ff       	jmpq   80416033a2 <line_for_address+0x429>
  struct Line_Number_State current_state = {
  8041603644:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%rbp)
  804160364b:	eb 16                	jmp    8041603663 <line_for_address+0x6ea>
            *state = last_state;
  804160364d:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8041603650:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8041603653:	eb 0e                	jmp    8041603663 <line_for_address+0x6ea>
            *state = last_state;
  8041603655:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8041603658:	89 45 b8             	mov    %eax,-0x48(%rbp)
  804160365b:	eb 06                	jmp    8041603663 <line_for_address+0x6ea>
        *state = last_state;
  804160365d:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8041603660:	89 45 b8             	mov    %eax,-0x48(%rbp)
  };

  run_line_number_program(program_addr, unit_end, &info, &current_state,
                          p);

  *lineno_store = current_state.line;
  8041603663:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8041603667:	8b 75 b8             	mov    -0x48(%rbp),%esi
  804160366a:	89 30                	mov    %esi,(%rax)

  return 0;
  804160366c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041603671:	48 83 c4 48          	add    $0x48,%rsp
  8041603675:	5b                   	pop    %rbx
  8041603676:	41 5c                	pop    %r12
  8041603678:	41 5d                	pop    %r13
  804160367a:	41 5e                	pop    %r14
  804160367c:	41 5f                	pop    %r15
  804160367e:	5d                   	pop    %rbp
  804160367f:	c3                   	retq   
    return -E_INVAL;
  8041603680:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041603685:	eb ea                	jmp    8041603671 <line_for_address+0x6f8>

0000008041603687 <mon_help>:
#define NCOMMANDS (sizeof(commands) / sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf) {
  8041603687:	55                   	push   %rbp
  8041603688:	48 89 e5             	mov    %rsp,%rbp
  804160368b:	41 55                	push   %r13
  804160368d:	41 54                	push   %r12
  804160368f:	53                   	push   %rbx
  8041603690:	48 83 ec 08          	sub    $0x8,%rsp
  8041603694:	48 bb 40 56 60 41 80 	movabs $0x8041605640,%rbx
  804160369b:	00 00 00 
  804160369e:	4c 8d 6b 78          	lea    0x78(%rbx),%r13
  int i;

  for (i = 0; i < NCOMMANDS; i++)
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  80416036a2:	49 bc 0d 3b 60 41 80 	movabs $0x8041603b0d,%r12
  80416036a9:	00 00 00 
  80416036ac:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  80416036b0:	48 8b 33             	mov    (%rbx),%rsi
  80416036b3:	48 bf 68 53 60 41 80 	movabs $0x8041605368,%rdi
  80416036ba:	00 00 00 
  80416036bd:	b8 00 00 00 00       	mov    $0x0,%eax
  80416036c2:	41 ff d4             	callq  *%r12
  80416036c5:	48 83 c3 18          	add    $0x18,%rbx
  for (i = 0; i < NCOMMANDS; i++)
  80416036c9:	4c 39 eb             	cmp    %r13,%rbx
  80416036cc:	75 de                	jne    80416036ac <mon_help+0x25>
  return 0;
}
  80416036ce:	b8 00 00 00 00       	mov    $0x0,%eax
  80416036d3:	48 83 c4 08          	add    $0x8,%rsp
  80416036d7:	5b                   	pop    %rbx
  80416036d8:	41 5c                	pop    %r12
  80416036da:	41 5d                	pop    %r13
  80416036dc:	5d                   	pop    %rbp
  80416036dd:	c3                   	retq   

00000080416036de <mon_hello>:

int
mon_hello(int argc, char **argv, struct Trapframe *tf) {
  80416036de:	55                   	push   %rbp
  80416036df:	48 89 e5             	mov    %rsp,%rbp
  cprintf("Hello!\n");
  80416036e2:	48 bf 71 53 60 41 80 	movabs $0x8041605371,%rdi
  80416036e9:	00 00 00 
  80416036ec:	b8 00 00 00 00       	mov    $0x0,%eax
  80416036f1:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  80416036f8:	00 00 00 
  80416036fb:	ff d2                	callq  *%rdx
  return 0;
}
  80416036fd:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603702:	5d                   	pop    %rbp
  8041603703:	c3                   	retq   

0000008041603704 <mon_user_name>:

int
mon_user_name(int argc, char **argv, struct Trapframe *tf) {
  8041603704:	55                   	push   %rbp
  8041603705:	48 89 e5             	mov    %rsp,%rbp
  cprintf("User name: Andrew\n");
  8041603708:	48 bf 79 53 60 41 80 	movabs $0x8041605379,%rdi
  804160370f:	00 00 00 
  8041603712:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603717:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160371e:	00 00 00 
  8041603721:	ff d2                	callq  *%rdx
  return 0;
}
  8041603723:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603728:	5d                   	pop    %rbp
  8041603729:	c3                   	retq   

000000804160372a <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf) {
  804160372a:	55                   	push   %rbp
  804160372b:	48 89 e5             	mov    %rsp,%rbp
  804160372e:	41 54                	push   %r12
  8041603730:	53                   	push   %rbx
  extern char _head64[], entry[], etext[], edata[], end[];

  cprintf("Special kernel symbols:\n");
  8041603731:	48 bf 8c 53 60 41 80 	movabs $0x804160538c,%rdi
  8041603738:	00 00 00 
  804160373b:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603740:	48 bb 0d 3b 60 41 80 	movabs $0x8041603b0d,%rbx
  8041603747:	00 00 00 
  804160374a:	ff d3                	callq  *%rbx
  cprintf("  _head64                  %08lx (phys)\n",
  804160374c:	48 be 00 00 50 01 00 	movabs $0x1500000,%rsi
  8041603753:	00 00 00 
  8041603756:	48 bf 88 54 60 41 80 	movabs $0x8041605488,%rdi
  804160375d:	00 00 00 
  8041603760:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603765:	ff d3                	callq  *%rbx
          (unsigned long)_head64);
  cprintf("  entry  %08lx (virt)  %08lx (phys)\n",
          (unsigned long)entry, (unsigned long)entry - KERNBASE);
  8041603767:	49 bc 00 00 60 41 80 	movabs $0x8041600000,%r12
  804160376e:	00 00 00 
  cprintf("  entry  %08lx (virt)  %08lx (phys)\n",
  8041603771:	48 ba 00 00 60 01 00 	movabs $0x1600000,%rdx
  8041603778:	00 00 00 
  804160377b:	4c 89 e6             	mov    %r12,%rsi
  804160377e:	48 bf b8 54 60 41 80 	movabs $0x80416054b8,%rdi
  8041603785:	00 00 00 
  8041603788:	b8 00 00 00 00       	mov    $0x0,%eax
  804160378d:	ff d3                	callq  *%rbx
  cprintf("  etext  %08lx (virt)  %08lx (phys)\n",
  804160378f:	48 ba 50 4d 60 01 00 	movabs $0x1604d50,%rdx
  8041603796:	00 00 00 
  8041603799:	48 be 50 4d 60 41 80 	movabs $0x8041604d50,%rsi
  80416037a0:	00 00 00 
  80416037a3:	48 bf e0 54 60 41 80 	movabs $0x80416054e0,%rdi
  80416037aa:	00 00 00 
  80416037ad:	b8 00 00 00 00       	mov    $0x0,%eax
  80416037b2:	ff d3                	callq  *%rbx
          (unsigned long)etext, (unsigned long)etext - KERNBASE);
  cprintf("  edata  %08lx (virt)  %08lx (phys)\n",
  80416037b4:	48 ba 20 67 61 01 00 	movabs $0x1616720,%rdx
  80416037bb:	00 00 00 
  80416037be:	48 be 20 67 61 41 80 	movabs $0x8041616720,%rsi
  80416037c5:	00 00 00 
  80416037c8:	48 bf 08 55 60 41 80 	movabs $0x8041605508,%rdi
  80416037cf:	00 00 00 
  80416037d2:	b8 00 00 00 00       	mov    $0x0,%eax
  80416037d7:	ff d3                	callq  *%rbx
          (unsigned long)edata, (unsigned long)edata - KERNBASE);
  cprintf("  end    %08lx (virt)  %08lx (phys)\n",
  80416037d9:	48 ba 00 70 61 01 00 	movabs $0x1617000,%rdx
  80416037e0:	00 00 00 
  80416037e3:	48 be 00 70 61 41 80 	movabs $0x8041617000,%rsi
  80416037ea:	00 00 00 
  80416037ed:	48 bf 30 55 60 41 80 	movabs $0x8041605530,%rdi
  80416037f4:	00 00 00 
  80416037f7:	b8 00 00 00 00       	mov    $0x0,%eax
  80416037fc:	ff d3                	callq  *%rbx
          (unsigned long)end, (unsigned long)end - KERNBASE);
  cprintf("Kernel executable memory footprint: %luKB\n",
          (unsigned long)ROUNDUP(end - entry, 1024) / 1024);
  80416037fe:	48 be ff 73 61 41 80 	movabs $0x80416173ff,%rsi
  8041603805:	00 00 00 
  8041603808:	4c 29 e6             	sub    %r12,%rsi
  cprintf("Kernel executable memory footprint: %luKB\n",
  804160380b:	48 c1 ee 0a          	shr    $0xa,%rsi
  804160380f:	48 bf 58 55 60 41 80 	movabs $0x8041605558,%rdi
  8041603816:	00 00 00 
  8041603819:	b8 00 00 00 00       	mov    $0x0,%eax
  804160381e:	ff d3                	callq  *%rbx
  return 0;
}
  8041603820:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603825:	5b                   	pop    %rbx
  8041603826:	41 5c                	pop    %r12
  8041603828:	5d                   	pop    %rbp
  8041603829:	c3                   	retq   

000000804160382a <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf) {
  804160382a:	55                   	push   %rbp
  804160382b:	48 89 e5             	mov    %rsp,%rbp
  804160382e:	41 57                	push   %r15
  8041603830:	41 56                	push   %r14
  8041603832:	41 55                	push   %r13
  8041603834:	41 54                	push   %r12
  8041603836:	53                   	push   %rbx
  8041603837:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  // LAB 2: Your code here.

  uint64_t *rbp = 0x0;
  uint64_t rip  = 0x0;
  struct Ripdebuginfo info;
  cprintf("Stack backtrace:\n");
  804160383e:	48 bf a5 53 60 41 80 	movabs $0x80416053a5,%rdi
  8041603845:	00 00 00 
  8041603848:	b8 00 00 00 00       	mov    $0x0,%eax
  804160384d:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041603854:	00 00 00 
  8041603857:	ff d2                	callq  *%rdx
}

static __inline uint64_t
read_rbp(void) {
  uint64_t ebp;
  __asm __volatile("movq %%rbp,%0"
  8041603859:	48 89 eb             	mov    %rbp,%rbx
  rbp = (uint64_t *)read_rbp(); 
  do {
    rip = rbp[1]; 
    debuginfo_rip(rip, &info);
  804160385c:	49 bf 41 3c 60 41 80 	movabs $0x8041603c41,%r15
  8041603863:	00 00 00 
    cprintf("  rbp %016lx  rip %016lx\n", (long unsigned int)rbp, (long unsigned int)rip);
  8041603866:	49 bd 0d 3b 60 41 80 	movabs $0x8041603b0d,%r13
  804160386d:	00 00 00 
    cprintf("            %.256s:%d: %.*s+%ld\n", info.rip_file, info.rip_line, info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
  8041603870:	48 8d 85 b0 fd ff ff 	lea    -0x250(%rbp),%rax
  8041603877:	4c 8d b0 04 01 00 00 	lea    0x104(%rax),%r14
    rip = rbp[1]; 
  804160387e:	4c 8b 63 08          	mov    0x8(%rbx),%r12
    debuginfo_rip(rip, &info);
  8041603882:	48 8d b5 b0 fd ff ff 	lea    -0x250(%rbp),%rsi
  8041603889:	4c 89 e7             	mov    %r12,%rdi
  804160388c:	41 ff d7             	callq  *%r15
    cprintf("  rbp %016lx  rip %016lx\n", (long unsigned int)rbp, (long unsigned int)rip);
  804160388f:	4c 89 e2             	mov    %r12,%rdx
  8041603892:	48 89 de             	mov    %rbx,%rsi
  8041603895:	48 bf b7 53 60 41 80 	movabs $0x80416053b7,%rdi
  804160389c:	00 00 00 
  804160389f:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038a4:	41 ff d5             	callq  *%r13
    cprintf("            %.256s:%d: %.*s+%ld\n", info.rip_file, info.rip_line, info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
  80416038a7:	4d 89 e1             	mov    %r12,%r9
  80416038aa:	4c 2b 4d b8          	sub    -0x48(%rbp),%r9
  80416038ae:	4d 89 f0             	mov    %r14,%r8
  80416038b1:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
  80416038b4:	8b 95 b0 fe ff ff    	mov    -0x150(%rbp),%edx
  80416038ba:	48 8d b5 b0 fd ff ff 	lea    -0x250(%rbp),%rsi
  80416038c1:	48 bf 88 55 60 41 80 	movabs $0x8041605588,%rdi
  80416038c8:	00 00 00 
  80416038cb:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038d0:	41 ff d5             	callq  *%r13
    rbp = (uint64_t *)rbp[0];
  80416038d3:	48 8b 1b             	mov    (%rbx),%rbx
  } while (rbp);
  80416038d6:	48 85 db             	test   %rbx,%rbx
  80416038d9:	75 a3                	jne    804160387e <mon_backtrace+0x54>

  return 0;
}
  80416038db:	b8 00 00 00 00       	mov    $0x0,%eax
  80416038e0:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  80416038e7:	5b                   	pop    %rbx
  80416038e8:	41 5c                	pop    %r12
  80416038ea:	41 5d                	pop    %r13
  80416038ec:	41 5e                	pop    %r14
  80416038ee:	41 5f                	pop    %r15
  80416038f0:	5d                   	pop    %rbp
  80416038f1:	c3                   	retq   

00000080416038f2 <monitor>:
  cprintf("Unknown command '%s'\n", argv[0]);
  return 0;
}

void
monitor(struct Trapframe *tf) {
  80416038f2:	55                   	push   %rbp
  80416038f3:	48 89 e5             	mov    %rsp,%rbp
  80416038f6:	41 57                	push   %r15
  80416038f8:	41 56                	push   %r14
  80416038fa:	41 55                	push   %r13
  80416038fc:	41 54                	push   %r12
  80416038fe:	53                   	push   %rbx
  80416038ff:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8041603906:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  char *buf;

  cprintf("Welcome to the JOS kernel monitor!\n");
  804160390d:	48 bf b0 55 60 41 80 	movabs $0x80416055b0,%rdi
  8041603914:	00 00 00 
  8041603917:	b8 00 00 00 00       	mov    $0x0,%eax
  804160391c:	48 bb 0d 3b 60 41 80 	movabs $0x8041603b0d,%rbx
  8041603923:	00 00 00 
  8041603926:	ff d3                	callq  *%rbx
  cprintf("Type 'help' for a list of commands.\n");
  8041603928:	48 bf d8 55 60 41 80 	movabs $0x80416055d8,%rdi
  804160392f:	00 00 00 
  8041603932:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603937:	ff d3                	callq  *%rbx

  while (1) {
    buf = readline("K> ");
  8041603939:	49 bf e0 46 60 41 80 	movabs $0x80416046e0,%r15
  8041603940:	00 00 00 
    while (*buf && strchr(WHITESPACE, *buf))
  8041603943:	49 bd af 49 60 41 80 	movabs $0x80416049af,%r13
  804160394a:	00 00 00 
  804160394d:	e9 fe 00 00 00       	jmpq   8041603a50 <monitor+0x15e>
  8041603952:	40 0f be f6          	movsbl %sil,%esi
  8041603956:	48 bf d5 53 60 41 80 	movabs $0x80416053d5,%rdi
  804160395d:	00 00 00 
  8041603960:	41 ff d5             	callq  *%r13
  8041603963:	48 85 c0             	test   %rax,%rax
  8041603966:	74 0c                	je     8041603974 <monitor+0x82>
      *buf++ = 0;
  8041603968:	c6 03 00             	movb   $0x0,(%rbx)
  804160396b:	45 89 e6             	mov    %r12d,%r14d
  804160396e:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
  8041603972:	eb 49                	jmp    80416039bd <monitor+0xcb>
    if (*buf == 0)
  8041603974:	80 3b 00             	cmpb   $0x0,(%rbx)
  8041603977:	74 4f                	je     80416039c8 <monitor+0xd6>
    if (argc == MAXARGS - 1) {
  8041603979:	41 83 fc 0f          	cmp    $0xf,%r12d
  804160397d:	0f 84 b2 00 00 00    	je     8041603a35 <monitor+0x143>
    argv[argc++] = buf;
  8041603983:	45 8d 74 24 01       	lea    0x1(%r12),%r14d
  8041603988:	4d 63 e4             	movslq %r12d,%r12
  804160398b:	4a 89 9c e5 50 ff ff 	mov    %rbx,-0xb0(%rbp,%r12,8)
  8041603992:	ff 
    while (*buf && !strchr(WHITESPACE, *buf))
  8041603993:	0f b6 33             	movzbl (%rbx),%esi
  8041603996:	40 84 f6             	test   %sil,%sil
  8041603999:	74 22                	je     80416039bd <monitor+0xcb>
  804160399b:	40 0f be f6          	movsbl %sil,%esi
  804160399f:	48 bf d5 53 60 41 80 	movabs $0x80416053d5,%rdi
  80416039a6:	00 00 00 
  80416039a9:	41 ff d5             	callq  *%r13
  80416039ac:	48 85 c0             	test   %rax,%rax
  80416039af:	75 0c                	jne    80416039bd <monitor+0xcb>
      buf++;
  80416039b1:	48 83 c3 01          	add    $0x1,%rbx
    while (*buf && !strchr(WHITESPACE, *buf))
  80416039b5:	0f b6 33             	movzbl (%rbx),%esi
  80416039b8:	40 84 f6             	test   %sil,%sil
  80416039bb:	75 de                	jne    804160399b <monitor+0xa9>
      *buf++ = 0;
  80416039bd:	45 89 f4             	mov    %r14d,%r12d
    while (*buf && strchr(WHITESPACE, *buf))
  80416039c0:	0f b6 33             	movzbl (%rbx),%esi
  80416039c3:	40 84 f6             	test   %sil,%sil
  80416039c6:	75 8a                	jne    8041603952 <monitor+0x60>
  argv[argc] = 0;
  80416039c8:	49 63 c4             	movslq %r12d,%rax
  80416039cb:	48 c7 84 c5 50 ff ff 	movq   $0x0,-0xb0(%rbp,%rax,8)
  80416039d2:	ff 00 00 00 00 
  if (argc == 0)
  80416039d7:	45 85 e4             	test   %r12d,%r12d
  80416039da:	74 74                	je     8041603a50 <monitor+0x15e>
  80416039dc:	49 be 40 56 60 41 80 	movabs $0x8041605640,%r14
  80416039e3:	00 00 00 
  for (i = 0; i < NCOMMANDS; i++) {
  80416039e6:	bb 00 00 00 00       	mov    $0x0,%ebx
    if (strcmp(argv[0], commands[i].name) == 0)
  80416039eb:	49 8b 36             	mov    (%r14),%rsi
  80416039ee:	48 8b bd 50 ff ff ff 	mov    -0xb0(%rbp),%rdi
  80416039f5:	48 b8 3c 49 60 41 80 	movabs $0x804160493c,%rax
  80416039fc:	00 00 00 
  80416039ff:	ff d0                	callq  *%rax
  8041603a01:	85 c0                	test   %eax,%eax
  8041603a03:	74 76                	je     8041603a7b <monitor+0x189>
  for (i = 0; i < NCOMMANDS; i++) {
  8041603a05:	83 c3 01             	add    $0x1,%ebx
  8041603a08:	49 83 c6 18          	add    $0x18,%r14
  8041603a0c:	83 fb 05             	cmp    $0x5,%ebx
  8041603a0f:	75 da                	jne    80416039eb <monitor+0xf9>
  cprintf("Unknown command '%s'\n", argv[0]);
  8041603a11:	48 8b b5 50 ff ff ff 	mov    -0xb0(%rbp),%rsi
  8041603a18:	48 bf f7 53 60 41 80 	movabs $0x80416053f7,%rdi
  8041603a1f:	00 00 00 
  8041603a22:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603a27:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041603a2e:	00 00 00 
  8041603a31:	ff d2                	callq  *%rdx
  8041603a33:	eb 1b                	jmp    8041603a50 <monitor+0x15e>
      cprintf("Too many arguments (max %d)\n", MAXARGS);
  8041603a35:	be 10 00 00 00       	mov    $0x10,%esi
  8041603a3a:	48 bf da 53 60 41 80 	movabs $0x80416053da,%rdi
  8041603a41:	00 00 00 
  8041603a44:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  8041603a4b:	00 00 00 
  8041603a4e:	ff d2                	callq  *%rdx
    buf = readline("K> ");
  8041603a50:	48 bf d1 53 60 41 80 	movabs $0x80416053d1,%rdi
  8041603a57:	00 00 00 
  8041603a5a:	41 ff d7             	callq  *%r15
  8041603a5d:	48 89 c3             	mov    %rax,%rbx
    if (buf != NULL)
  8041603a60:	48 85 c0             	test   %rax,%rax
  8041603a63:	74 eb                	je     8041603a50 <monitor+0x15e>
  argv[argc] = 0;
  8041603a65:	48 c7 85 50 ff ff ff 	movq   $0x0,-0xb0(%rbp)
  8041603a6c:	00 00 00 00 
  argc       = 0;
  8041603a70:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8041603a76:	e9 45 ff ff ff       	jmpq   80416039c0 <monitor+0xce>
      return commands[i].func(argc, argv, tf);
  8041603a7b:	48 63 db             	movslq %ebx,%rbx
  8041603a7e:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  8041603a82:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8041603a89:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  8041603a90:	44 89 e7             	mov    %r12d,%edi
  8041603a93:	48 b8 40 56 60 41 80 	movabs $0x8041605640,%rax
  8041603a9a:	00 00 00 
  8041603a9d:	ff 54 c8 10          	callq  *0x10(%rax,%rcx,8)
      if (runcmd(buf, tf) < 0)
  8041603aa1:	85 c0                	test   %eax,%eax
  8041603aa3:	79 ab                	jns    8041603a50 <monitor+0x15e>
        break;
  }
  8041603aa5:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8041603aac:	5b                   	pop    %rbx
  8041603aad:	41 5c                	pop    %r12
  8041603aaf:	41 5d                	pop    %r13
  8041603ab1:	41 5e                	pop    %r14
  8041603ab3:	41 5f                	pop    %r15
  8041603ab5:	5d                   	pop    %rbp
  8041603ab6:	c3                   	retq   

0000008041603ab7 <putch>:
#include <inc/types.h>
#include <inc/stdio.h>
#include <inc/stdarg.h>

static void
putch(int ch, int *cnt) {
  8041603ab7:	55                   	push   %rbp
  8041603ab8:	48 89 e5             	mov    %rsp,%rbp
  8041603abb:	53                   	push   %rbx
  8041603abc:	48 83 ec 08          	sub    $0x8,%rsp
  8041603ac0:	48 89 f3             	mov    %rsi,%rbx
  cputchar(ch);
  8041603ac3:	48 b8 63 0b 60 41 80 	movabs $0x8041600b63,%rax
  8041603aca:	00 00 00 
  8041603acd:	ff d0                	callq  *%rax
  (*cnt)++;
  8041603acf:	83 03 01             	addl   $0x1,(%rbx)
}
  8041603ad2:	48 83 c4 08          	add    $0x8,%rsp
  8041603ad6:	5b                   	pop    %rbx
  8041603ad7:	5d                   	pop    %rbp
  8041603ad8:	c3                   	retq   

0000008041603ad9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8041603ad9:	55                   	push   %rbp
  8041603ada:	48 89 e5             	mov    %rsp,%rbp
  8041603add:	48 83 ec 10          	sub    $0x10,%rsp
  8041603ae1:	48 89 fa             	mov    %rdi,%rdx
  8041603ae4:	48 89 f1             	mov    %rsi,%rcx
  int cnt = 0;
  8041603ae7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  vprintfmt((void *)putch, &cnt, fmt, ap);
  8041603aee:	48 8d 75 fc          	lea    -0x4(%rbp),%rsi
  8041603af2:	48 bf b7 3a 60 41 80 	movabs $0x8041603ab7,%rdi
  8041603af9:	00 00 00 
  8041603afc:	48 b8 8c 3f 60 41 80 	movabs $0x8041603f8c,%rax
  8041603b03:	00 00 00 
  8041603b06:	ff d0                	callq  *%rax
  return cnt;
}
  8041603b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041603b0b:	c9                   	leaveq 
  8041603b0c:	c3                   	retq   

0000008041603b0d <cprintf>:

int
cprintf(const char *fmt, ...) {
  8041603b0d:	55                   	push   %rbp
  8041603b0e:	48 89 e5             	mov    %rsp,%rbp
  8041603b11:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8041603b18:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8041603b1f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8041603b26:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8041603b2d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041603b34:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8041603b3b:	84 c0                	test   %al,%al
  8041603b3d:	74 20                	je     8041603b5f <cprintf+0x52>
  8041603b3f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8041603b43:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8041603b47:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8041603b4b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8041603b4f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8041603b53:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8041603b57:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8041603b5b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int cnt;

  va_start(ap, fmt);
  8041603b5f:	c7 85 38 ff ff ff 08 	movl   $0x8,-0xc8(%rbp)
  8041603b66:	00 00 00 
  8041603b69:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8041603b70:	00 00 00 
  8041603b73:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041603b77:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8041603b7e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8041603b85:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  cnt = vcprintf(fmt, ap);
  8041603b8c:	48 8d b5 38 ff ff ff 	lea    -0xc8(%rbp),%rsi
  8041603b93:	48 b8 d9 3a 60 41 80 	movabs $0x8041603ad9,%rax
  8041603b9a:	00 00 00 
  8041603b9d:	ff d0                	callq  *%rax
  va_end(ap);

  return cnt;
}
  8041603b9f:	c9                   	leaveq 
  8041603ba0:	c3                   	retq   

0000008041603ba1 <load_kernel_dwarf_info>:

#include <kern/kdebug.h>
#include <inc/uefi.h>

void
load_kernel_dwarf_info(struct Dwarf_Addrs *addrs) {
  8041603ba1:	55                   	push   %rbp
  8041603ba2:	48 89 e5             	mov    %rsp,%rbp
  addrs->aranges_begin  = (unsigned char *)(uefi_lp->DebugArangesStart);
  8041603ba5:	48 ba 00 60 61 41 80 	movabs $0x8041616000,%rdx
  8041603bac:	00 00 00 
  8041603baf:	48 8b 02             	mov    (%rdx),%rax
  8041603bb2:	48 8b 48 58          	mov    0x58(%rax),%rcx
  8041603bb6:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  addrs->aranges_end    = (unsigned char *)(uefi_lp->DebugArangesEnd);
  8041603bba:	48 8b 48 60          	mov    0x60(%rax),%rcx
  8041603bbe:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  addrs->abbrev_begin   = (unsigned char *)(uefi_lp->DebugAbbrevStart);
  8041603bc2:	48 8b 40 68          	mov    0x68(%rax),%rax
  8041603bc6:	48 89 07             	mov    %rax,(%rdi)
  addrs->abbrev_end     = (unsigned char *)(uefi_lp->DebugAbbrevEnd);
  8041603bc9:	48 8b 02             	mov    (%rdx),%rax
  8041603bcc:	48 8b 50 70          	mov    0x70(%rax),%rdx
  8041603bd0:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  addrs->info_begin     = (unsigned char *)(uefi_lp->DebugInfoStart);
  8041603bd4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8041603bd8:	48 89 57 20          	mov    %rdx,0x20(%rdi)
  addrs->info_end       = (unsigned char *)(uefi_lp->DebugInfoEnd);
  8041603bdc:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  8041603be3:	48 89 57 28          	mov    %rdx,0x28(%rdi)
  addrs->line_begin     = (unsigned char *)(uefi_lp->DebugLineStart);
  8041603be7:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8041603bee:	48 89 57 30          	mov    %rdx,0x30(%rdi)
  addrs->line_end       = (unsigned char *)(uefi_lp->DebugLineEnd);
  8041603bf2:	48 8b 90 90 00 00 00 	mov    0x90(%rax),%rdx
  8041603bf9:	48 89 57 38          	mov    %rdx,0x38(%rdi)
  addrs->str_begin      = (unsigned char *)(uefi_lp->DebugStrStart);
  8041603bfd:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8041603c04:	48 89 57 40          	mov    %rdx,0x40(%rdi)
  addrs->str_end        = (unsigned char *)(uefi_lp->DebugStrEnd);
  8041603c08:	48 8b 90 a0 00 00 00 	mov    0xa0(%rax),%rdx
  8041603c0f:	48 89 57 48          	mov    %rdx,0x48(%rdi)
  addrs->pubnames_begin = (unsigned char *)(uefi_lp->DebugPubnamesStart);
  8041603c13:	48 8b 90 a8 00 00 00 	mov    0xa8(%rax),%rdx
  8041603c1a:	48 89 57 50          	mov    %rdx,0x50(%rdi)
  addrs->pubnames_end   = (unsigned char *)(uefi_lp->DebugPubnamesEnd);
  8041603c1e:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
  8041603c25:	48 89 57 58          	mov    %rdx,0x58(%rdi)
  addrs->pubtypes_begin = (unsigned char *)(uefi_lp->DebugPubtypesStart);
  8041603c29:	48 8b 90 b8 00 00 00 	mov    0xb8(%rax),%rdx
  8041603c30:	48 89 57 60          	mov    %rdx,0x60(%rdi)
  addrs->pubtypes_end   = (unsigned char *)(uefi_lp->DebugPubtypesEnd);
  8041603c34:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
  8041603c3b:	48 89 47 68          	mov    %rax,0x68(%rdi)
}
  8041603c3f:	5d                   	pop    %rbp
  8041603c40:	c3                   	retq   

0000008041603c41 <debuginfo_rip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_rip(uintptr_t addr, struct Ripdebuginfo *info) {
  8041603c41:	55                   	push   %rbp
  8041603c42:	48 89 e5             	mov    %rsp,%rbp
  8041603c45:	41 56                	push   %r14
  8041603c47:	41 55                	push   %r13
  8041603c49:	41 54                	push   %r12
  8041603c4b:	53                   	push   %rbx
  8041603c4c:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  8041603c53:	49 89 fc             	mov    %rdi,%r12
  8041603c56:	48 89 f3             	mov    %rsi,%rbx
  int code = 0;
  // Initialize *info
  strcpy(info->rip_file, "<unknown>");
  8041603c59:	48 be b8 56 60 41 80 	movabs $0x80416056b8,%rsi
  8041603c60:	00 00 00 
  8041603c63:	48 89 df             	mov    %rbx,%rdi
  8041603c66:	49 bd 74 48 60 41 80 	movabs $0x8041604874,%r13
  8041603c6d:	00 00 00 
  8041603c70:	41 ff d5             	callq  *%r13
  info->rip_line = 0;
  8041603c73:	c7 83 00 01 00 00 00 	movl   $0x0,0x100(%rbx)
  8041603c7a:	00 00 00 
  strcpy(info->rip_fn_name, "<unknown>");
  8041603c7d:	4c 8d b3 04 01 00 00 	lea    0x104(%rbx),%r14
  8041603c84:	48 be b8 56 60 41 80 	movabs $0x80416056b8,%rsi
  8041603c8b:	00 00 00 
  8041603c8e:	4c 89 f7             	mov    %r14,%rdi
  8041603c91:	41 ff d5             	callq  *%r13
  info->rip_fn_namelen = 9;
  8041603c94:	c7 83 04 02 00 00 09 	movl   $0x9,0x204(%rbx)
  8041603c9b:	00 00 00 
  info->rip_fn_addr    = addr;
  8041603c9e:	4c 89 a3 08 02 00 00 	mov    %r12,0x208(%rbx)
  info->rip_fn_narg    = 0;
  8041603ca5:	c7 83 10 02 00 00 00 	movl   $0x0,0x210(%rbx)
  8041603cac:	00 00 00 

  if (!addr) {
  8041603caf:	4d 85 e4             	test   %r12,%r12
  8041603cb2:	0f 84 8c 01 00 00    	je     8041603e44 <debuginfo_rip+0x203>
    return 0;
  }

  struct Dwarf_Addrs addrs;
  if (addr <= ULIM) {
  8041603cb8:	48 b8 00 00 c0 3e 80 	movabs $0x803ec00000,%rax
  8041603cbf:	00 00 00 
  8041603cc2:	49 39 c4             	cmp    %rax,%r12
  8041603cc5:	0f 86 4f 01 00 00    	jbe    8041603e1a <debuginfo_rip+0x1d9>
    panic("Can't search for user-level addresses yet!");
  } else {
    load_kernel_dwarf_info(&addrs);
  8041603ccb:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  8041603cd2:	48 b8 a1 3b 60 41 80 	movabs $0x8041603ba1,%rax
  8041603cd9:	00 00 00 
  8041603cdc:	ff d0                	callq  *%rax
  }
  enum {
    BUFSIZE = 20,
  };
  Dwarf_Off offset = 0, line_offset = 0;
  8041603cde:	48 c7 85 68 ff ff ff 	movq   $0x0,-0x98(%rbp)
  8041603ce5:	00 00 00 00 
  8041603ce9:	48 c7 85 60 ff ff ff 	movq   $0x0,-0xa0(%rbp)
  8041603cf0:	00 00 00 00 
  code = info_by_address(&addrs, addr, &offset);
  8041603cf4:	48 8d 95 68 ff ff ff 	lea    -0x98(%rbp),%rdx
  8041603cfb:	4c 89 e6             	mov    %r12,%rsi
  8041603cfe:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  8041603d05:	48 b8 3e 15 60 41 80 	movabs $0x804160153e,%rax
  8041603d0c:	00 00 00 
  8041603d0f:	ff d0                	callq  *%rax
  8041603d11:	41 89 c5             	mov    %eax,%r13d
  if (code < 0) {
  8041603d14:	85 c0                	test   %eax,%eax
  8041603d16:	0f 88 2e 01 00 00    	js     8041603e4a <debuginfo_rip+0x209>
    return code;
  }
  char *tmp_buf;
  void *buf;
  buf  = &tmp_buf;
  code = file_name_by_info(&addrs, offset, buf, sizeof(char *), &line_offset);
  8041603d1c:	4c 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%r8
  8041603d23:	b9 08 00 00 00       	mov    $0x8,%ecx
  8041603d28:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8041603d2f:	48 8b b5 68 ff ff ff 	mov    -0x98(%rbp),%rsi
  8041603d36:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  8041603d3d:	48 b8 fe 1b 60 41 80 	movabs $0x8041601bfe,%rax
  8041603d44:	00 00 00 
  8041603d47:	ff d0                	callq  *%rax
  8041603d49:	41 89 c5             	mov    %eax,%r13d
  strncpy(info->rip_file, tmp_buf, 256);
  8041603d4c:	ba 00 01 00 00       	mov    $0x100,%edx
  8041603d51:	48 8b b5 58 ff ff ff 	mov    -0xa8(%rbp),%rsi
  8041603d58:	48 89 df             	mov    %rbx,%rdi
  8041603d5b:	48 b8 c9 48 60 41 80 	movabs $0x80416048c9,%rax
  8041603d62:	00 00 00 
  8041603d65:	ff d0                	callq  *%rax
  if (code < 0) {
  8041603d67:	45 85 ed             	test   %r13d,%r13d
  8041603d6a:	0f 88 da 00 00 00    	js     8041603e4a <debuginfo_rip+0x209>
  // address of the next instruction, so we should substract 5 from it.
  // Hint: use line_for_address from kern/dwarf_lines.c
  // LAB 2: Your code here:

  buf  = &info->rip_line;
  addr = addr - 5;
  8041603d70:	49 83 ec 05          	sub    $0x5,%r12
  buf  = &info->rip_line;
  8041603d74:	48 8d 8b 00 01 00 00 	lea    0x100(%rbx),%rcx
  code = line_for_address(&addrs, addr, line_offset, buf);
  8041603d7b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8041603d82:	4c 89 e6             	mov    %r12,%rsi
  8041603d85:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  8041603d8c:	48 b8 79 2f 60 41 80 	movabs $0x8041602f79,%rax
  8041603d93:	00 00 00 
  8041603d96:	ff d0                	callq  *%rax
  8041603d98:	41 89 c5             	mov    %eax,%r13d
  if (code < 0) {
  8041603d9b:	85 c0                	test   %eax,%eax
  8041603d9d:	0f 88 a7 00 00 00    	js     8041603e4a <debuginfo_rip+0x209>
    return code;
  }
  buf  = &tmp_buf;
  code = function_by_info(&addrs, addr, offset, buf, sizeof(char *), &info->rip_fn_addr);
  8041603da3:	4c 8d 8b 08 02 00 00 	lea    0x208(%rbx),%r9
  8041603daa:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8041603db0:	48 8d 8d 58 ff ff ff 	lea    -0xa8(%rbp),%rcx
  8041603db7:	48 8b 95 68 ff ff ff 	mov    -0x98(%rbp),%rdx
  8041603dbe:	4c 89 e6             	mov    %r12,%rsi
  8041603dc1:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  8041603dc8:	48 b8 4f 20 60 41 80 	movabs $0x804160204f,%rax
  8041603dcf:	00 00 00 
  8041603dd2:	ff d0                	callq  *%rax
  8041603dd4:	41 89 c5             	mov    %eax,%r13d
  strncpy(info->rip_fn_name, tmp_buf, 256);
  8041603dd7:	ba 00 01 00 00       	mov    $0x100,%edx
  8041603ddc:	48 8b b5 58 ff ff ff 	mov    -0xa8(%rbp),%rsi
  8041603de3:	4c 89 f7             	mov    %r14,%rdi
  8041603de6:	48 b8 c9 48 60 41 80 	movabs $0x80416048c9,%rax
  8041603ded:	00 00 00 
  8041603df0:	ff d0                	callq  *%rax
  info->rip_fn_namelen = strnlen(info->rip_fn_name, 256);
  8041603df2:	be 00 01 00 00       	mov    $0x100,%esi
  8041603df7:	4c 89 f7             	mov    %r14,%rdi
  8041603dfa:	48 b8 3d 48 60 41 80 	movabs $0x804160483d,%rax
  8041603e01:	00 00 00 
  8041603e04:	ff d0                	callq  *%rax
  8041603e06:	89 83 04 02 00 00    	mov    %eax,0x204(%rbx)
  8041603e0c:	45 85 ed             	test   %r13d,%r13d
  8041603e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603e14:	44 0f 4f e8          	cmovg  %eax,%r13d
  8041603e18:	eb 30                	jmp    8041603e4a <debuginfo_rip+0x209>
    panic("Can't search for user-level addresses yet!");
  8041603e1a:	48 ba d0 56 60 41 80 	movabs $0x80416056d0,%rdx
  8041603e21:	00 00 00 
  8041603e24:	be 35 00 00 00       	mov    $0x35,%esi
  8041603e29:	48 bf c2 56 60 41 80 	movabs $0x80416056c2,%rdi
  8041603e30:	00 00 00 
  8041603e33:	b8 00 00 00 00       	mov    $0x0,%eax
  8041603e38:	48 b9 e5 02 60 41 80 	movabs $0x80416002e5,%rcx
  8041603e3f:	00 00 00 
  8041603e42:	ff d1                	callq  *%rcx
    return 0;
  8041603e44:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  if (code < 0) {
    return code;
  }
  return 0;
}
  8041603e4a:	44 89 e8             	mov    %r13d,%eax
  8041603e4d:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  8041603e54:	5b                   	pop    %rbx
  8041603e55:	41 5c                	pop    %r12
  8041603e57:	41 5d                	pop    %r13
  8041603e59:	41 5e                	pop    %r14
  8041603e5b:	5d                   	pop    %rbp
  8041603e5c:	c3                   	retq   

0000008041603e5d <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc) {
  8041603e5d:	55                   	push   %rbp
  8041603e5e:	48 89 e5             	mov    %rsp,%rbp
  8041603e61:	41 57                	push   %r15
  8041603e63:	41 56                	push   %r14
  8041603e65:	41 55                	push   %r13
  8041603e67:	41 54                	push   %r12
  8041603e69:	53                   	push   %rbx
  8041603e6a:	48 83 ec 18          	sub    $0x18,%rsp
  8041603e6e:	49 89 fc             	mov    %rdi,%r12
  8041603e71:	49 89 f5             	mov    %rsi,%r13
  8041603e74:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8041603e78:	45 89 ce             	mov    %r9d,%r14d
  // first recursively print all preceding (more significant) digits
  if (num >= base) {
  8041603e7b:	41 89 cf             	mov    %ecx,%r15d
  8041603e7e:	49 39 d7             	cmp    %rdx,%r15
  8041603e81:	76 45                	jbe    8041603ec8 <printnum+0x6b>
    printnum(putch, putdat, num / base, base, width - 1, padc);
  } else {
    // print any needed pad characters before first digit
    while (--width > 0)
  8041603e83:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
  8041603e87:	85 db                	test   %ebx,%ebx
  8041603e89:	7e 0e                	jle    8041603e99 <printnum+0x3c>
      putch(padc, putdat);
  8041603e8b:	4c 89 ee             	mov    %r13,%rsi
  8041603e8e:	44 89 f7             	mov    %r14d,%edi
  8041603e91:	41 ff d4             	callq  *%r12
    while (--width > 0)
  8041603e94:	83 eb 01             	sub    $0x1,%ebx
  8041603e97:	75 f2                	jne    8041603e8b <printnum+0x2e>
  }

  // then print this (the least significant) digit
  putch("0123456789abcdef"[num % base], putdat);
  8041603e99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041603e9d:	ba 00 00 00 00       	mov    $0x0,%edx
  8041603ea2:	49 f7 f7             	div    %r15
  8041603ea5:	48 b8 00 57 60 41 80 	movabs $0x8041605700,%rax
  8041603eac:	00 00 00 
  8041603eaf:	0f be 3c 10          	movsbl (%rax,%rdx,1),%edi
  8041603eb3:	4c 89 ee             	mov    %r13,%rsi
  8041603eb6:	41 ff d4             	callq  *%r12
}
  8041603eb9:	48 83 c4 18          	add    $0x18,%rsp
  8041603ebd:	5b                   	pop    %rbx
  8041603ebe:	41 5c                	pop    %r12
  8041603ec0:	41 5d                	pop    %r13
  8041603ec2:	41 5e                	pop    %r14
  8041603ec4:	41 5f                	pop    %r15
  8041603ec6:	5d                   	pop    %rbp
  8041603ec7:	c3                   	retq   
    printnum(putch, putdat, num / base, base, width - 1, padc);
  8041603ec8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041603ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  8041603ed1:	49 f7 f7             	div    %r15
  8041603ed4:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8041603ed8:	48 89 c2             	mov    %rax,%rdx
  8041603edb:	48 b8 5d 3e 60 41 80 	movabs $0x8041603e5d,%rax
  8041603ee2:	00 00 00 
  8041603ee5:	ff d0                	callq  *%rax
  8041603ee7:	eb b0                	jmp    8041603e99 <printnum+0x3c>

0000008041603ee9 <sprintputch>:
  char *ebuf;
  int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b) {
  8041603ee9:	55                   	push   %rbp
  8041603eea:	48 89 e5             	mov    %rsp,%rbp
  b->cnt++;
  8041603eed:	83 46 10 01          	addl   $0x1,0x10(%rsi)
  if (b->buf < b->ebuf)
  8041603ef1:	48 8b 06             	mov    (%rsi),%rax
  8041603ef4:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8041603ef8:	73 0a                	jae    8041603f04 <sprintputch+0x1b>
    *b->buf++ = ch;
  8041603efa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8041603efe:	48 89 16             	mov    %rdx,(%rsi)
  8041603f01:	40 88 38             	mov    %dil,(%rax)
}
  8041603f04:	5d                   	pop    %rbp
  8041603f05:	c3                   	retq   

0000008041603f06 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8041603f06:	55                   	push   %rbp
  8041603f07:	48 89 e5             	mov    %rsp,%rbp
  8041603f0a:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8041603f11:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8041603f18:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041603f1f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8041603f26:	84 c0                	test   %al,%al
  8041603f28:	74 20                	je     8041603f4a <printfmt+0x44>
  8041603f2a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8041603f2e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8041603f32:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8041603f36:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8041603f3a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8041603f3e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8041603f42:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8041603f46:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_start(ap, fmt);
  8041603f4a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8041603f51:	00 00 00 
  8041603f54:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8041603f5b:	00 00 00 
  8041603f5e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8041603f62:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8041603f69:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8041603f70:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  vprintfmt(putch, putdat, fmt, ap);
  8041603f77:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8041603f7e:	48 b8 8c 3f 60 41 80 	movabs $0x8041603f8c,%rax
  8041603f85:	00 00 00 
  8041603f88:	ff d0                	callq  *%rax
}
  8041603f8a:	c9                   	leaveq 
  8041603f8b:	c3                   	retq   

0000008041603f8c <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap) {
  8041603f8c:	55                   	push   %rbp
  8041603f8d:	48 89 e5             	mov    %rsp,%rbp
  8041603f90:	41 57                	push   %r15
  8041603f92:	41 56                	push   %r14
  8041603f94:	41 55                	push   %r13
  8041603f96:	41 54                	push   %r12
  8041603f98:	53                   	push   %rbx
  8041603f99:	48 83 ec 48          	sub    $0x48,%rsp
  8041603f9d:	49 89 fd             	mov    %rdi,%r13
  8041603fa0:	49 89 f6             	mov    %rsi,%r14
  8041603fa3:	49 89 d7             	mov    %rdx,%r15
  va_copy(aq, ap);
  8041603fa6:	48 8b 01             	mov    (%rcx),%rax
  8041603fa9:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  8041603fad:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8041603fb1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8041603fb5:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8041603fb9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    while ((ch = *(unsigned char *)fmt++) != '%') {
  8041603fbd:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8041603fc1:	41 0f b6 3f          	movzbl (%r15),%edi
  8041603fc5:	83 ff 25             	cmp    $0x25,%edi
  8041603fc8:	74 18                	je     8041603fe2 <vprintfmt+0x56>
      if (ch == '\0')
  8041603fca:	85 ff                	test   %edi,%edi
  8041603fcc:	0f 84 24 06 00 00    	je     80416045f6 <vprintfmt+0x66a>
      putch(ch, putdat);
  8041603fd2:	4c 89 f6             	mov    %r14,%rsi
  8041603fd5:	41 ff d5             	callq  *%r13
    while ((ch = *(unsigned char *)fmt++) != '%') {
  8041603fd8:	49 89 df             	mov    %rbx,%r15
  8041603fdb:	eb e0                	jmp    8041603fbd <vprintfmt+0x31>
        for (fmt--; fmt[-1] != '%'; fmt--)
  8041603fdd:	49 89 df             	mov    %rbx,%r15
  8041603fe0:	eb db                	jmp    8041603fbd <vprintfmt+0x31>
        precision = va_arg(aq, int);
  8041603fe2:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    padc      = ' ';
  8041603fe6:	c6 45 98 20          	movb   $0x20,-0x68(%rbp)
    altflag   = 0;
  8041603fea:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%rbp)
    precision = -1;
  8041603ff1:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
    width     = -1;
  8041603ff7:	44 89 65 a8          	mov    %r12d,-0x58(%rbp)
    lflag     = 0;
  8041603ffb:	b9 00 00 00 00       	mov    $0x0,%ecx
        altflag = 1;
  8041604000:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  8041604006:	41 b9 00 00 00 00    	mov    $0x0,%r9d
        padc = '0';
  804160400c:	41 b8 30 00 00 00    	mov    $0x30,%r8d
        padc = '-';
  8041604012:	bf 2d 00 00 00       	mov    $0x2d,%edi
    switch (ch = *(unsigned char *)fmt++) {
  8041604017:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  804160401b:	0f b6 13             	movzbl (%rbx),%edx
  804160401e:	8d 42 dd             	lea    -0x23(%rdx),%eax
  8041604021:	3c 55                	cmp    $0x55,%al
  8041604023:	0f 87 7d 05 00 00    	ja     80416045a6 <vprintfmt+0x61a>
  8041604029:	0f b6 c0             	movzbl %al,%eax
  804160402c:	49 bb a0 57 60 41 80 	movabs $0x80416057a0,%r11
  8041604033:	00 00 00 
  8041604036:	41 ff 24 c3          	jmpq   *(%r11,%rax,8)
  804160403a:	4c 89 fb             	mov    %r15,%rbx
        padc = '-';
  804160403d:	40 88 7d 98          	mov    %dil,-0x68(%rbp)
  8041604041:	eb d4                	jmp    8041604017 <vprintfmt+0x8b>
    switch (ch = *(unsigned char *)fmt++) {
  8041604043:	4c 89 fb             	mov    %r15,%rbx
        padc = '0';
  8041604046:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  804160404a:	eb cb                	jmp    8041604017 <vprintfmt+0x8b>
    switch (ch = *(unsigned char *)fmt++) {
  804160404c:	0f b6 d2             	movzbl %dl,%edx
          precision = precision * 10 + ch - '0';
  804160404f:	44 8d 62 d0          	lea    -0x30(%rdx),%r12d
          ch        = *fmt;
  8041604053:	0f be 43 01          	movsbl 0x1(%rbx),%eax
          if (ch < '0' || ch > '9')
  8041604057:	8d 50 d0             	lea    -0x30(%rax),%edx
  804160405a:	83 fa 09             	cmp    $0x9,%edx
  804160405d:	77 7e                	ja     80416040dd <vprintfmt+0x151>
        for (precision = 0;; ++fmt) {
  804160405f:	49 83 c7 01          	add    $0x1,%r15
          precision = precision * 10 + ch - '0';
  8041604063:	43 8d 14 a4          	lea    (%r12,%r12,4),%edx
  8041604067:	44 8d 64 50 d0       	lea    -0x30(%rax,%rdx,2),%r12d
          ch        = *fmt;
  804160406c:	41 0f be 07          	movsbl (%r15),%eax
          if (ch < '0' || ch > '9')
  8041604070:	8d 50 d0             	lea    -0x30(%rax),%edx
  8041604073:	83 fa 09             	cmp    $0x9,%edx
  8041604076:	76 e7                	jbe    804160405f <vprintfmt+0xd3>
        for (precision = 0;; ++fmt) {
  8041604078:	4c 89 fb             	mov    %r15,%rbx
  804160407b:	eb 19                	jmp    8041604096 <vprintfmt+0x10a>
        precision = va_arg(aq, int);
  804160407d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604080:	83 fa 2f             	cmp    $0x2f,%edx
  8041604083:	77 2a                	ja     80416040af <vprintfmt+0x123>
  8041604085:	89 d0                	mov    %edx,%eax
  8041604087:	48 01 f0             	add    %rsi,%rax
  804160408a:	83 c2 08             	add    $0x8,%edx
  804160408d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604090:	44 8b 20             	mov    (%rax),%r12d
    switch (ch = *(unsigned char *)fmt++) {
  8041604093:	4c 89 fb             	mov    %r15,%rbx
        if (width < 0)
  8041604096:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  804160409a:	0f 89 77 ff ff ff    	jns    8041604017 <vprintfmt+0x8b>
          width = precision, precision = -1;
  80416040a0:	44 89 65 a8          	mov    %r12d,-0x58(%rbp)
  80416040a4:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  80416040aa:	e9 68 ff ff ff       	jmpq   8041604017 <vprintfmt+0x8b>
        precision = va_arg(aq, int);
  80416040af:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80416040b3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80416040b7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80416040bb:	eb d3                	jmp    8041604090 <vprintfmt+0x104>
  80416040bd:	8b 45 a8             	mov    -0x58(%rbp),%eax
  80416040c0:	85 c0                	test   %eax,%eax
  80416040c2:	41 0f 48 c1          	cmovs  %r9d,%eax
  80416040c6:	89 45 a8             	mov    %eax,-0x58(%rbp)
    switch (ch = *(unsigned char *)fmt++) {
  80416040c9:	4c 89 fb             	mov    %r15,%rbx
  80416040cc:	e9 46 ff ff ff       	jmpq   8041604017 <vprintfmt+0x8b>
  80416040d1:	4c 89 fb             	mov    %r15,%rbx
        altflag = 1;
  80416040d4:	44 89 55 a4          	mov    %r10d,-0x5c(%rbp)
        goto reswitch;
  80416040d8:	e9 3a ff ff ff       	jmpq   8041604017 <vprintfmt+0x8b>
    switch (ch = *(unsigned char *)fmt++) {
  80416040dd:	4c 89 fb             	mov    %r15,%rbx
  80416040e0:	eb b4                	jmp    8041604096 <vprintfmt+0x10a>
        lflag++;
  80416040e2:	83 c1 01             	add    $0x1,%ecx
    switch (ch = *(unsigned char *)fmt++) {
  80416040e5:	4c 89 fb             	mov    %r15,%rbx
        goto reswitch;
  80416040e8:	e9 2a ff ff ff       	jmpq   8041604017 <vprintfmt+0x8b>
        putch(va_arg(aq, int), putdat);
  80416040ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80416040f0:	83 fa 2f             	cmp    $0x2f,%edx
  80416040f3:	77 18                	ja     804160410d <vprintfmt+0x181>
  80416040f5:	89 d0                	mov    %edx,%eax
  80416040f7:	48 01 f0             	add    %rsi,%rax
  80416040fa:	83 c2 08             	add    $0x8,%edx
  80416040fd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604100:	4c 89 f6             	mov    %r14,%rsi
  8041604103:	8b 38                	mov    (%rax),%edi
  8041604105:	41 ff d5             	callq  *%r13
        break;
  8041604108:	e9 b0 fe ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
        putch(va_arg(aq, int), putdat);
  804160410d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041604111:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8041604115:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8041604119:	eb e5                	jmp    8041604100 <vprintfmt+0x174>
        err = va_arg(aq, int);
  804160411b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804160411e:	83 fa 2f             	cmp    $0x2f,%edx
  8041604121:	77 5b                	ja     804160417e <vprintfmt+0x1f2>
  8041604123:	89 d0                	mov    %edx,%eax
  8041604125:	48 01 c6             	add    %rax,%rsi
  8041604128:	83 c2 08             	add    $0x8,%edx
  804160412b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804160412e:	8b 0e                	mov    (%rsi),%ecx
  8041604130:	89 c8                	mov    %ecx,%eax
  8041604132:	c1 f8 1f             	sar    $0x1f,%eax
  8041604135:	31 c1                	xor    %eax,%ecx
  8041604137:	29 c1                	sub    %eax,%ecx
        if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8041604139:	83 f9 07             	cmp    $0x7,%ecx
  804160413c:	7f 4e                	jg     804160418c <vprintfmt+0x200>
  804160413e:	48 63 c1             	movslq %ecx,%rax
  8041604141:	48 ba 60 5a 60 41 80 	movabs $0x8041605a60,%rdx
  8041604148:	00 00 00 
  804160414b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  804160414f:	48 85 c0             	test   %rax,%rax
  8041604152:	74 38                	je     804160418c <vprintfmt+0x200>
          printfmt(putch, putdat, "%s", p);
  8041604154:	48 89 c1             	mov    %rax,%rcx
  8041604157:	48 ba 8b 50 60 41 80 	movabs $0x804160508b,%rdx
  804160415e:	00 00 00 
  8041604161:	4c 89 f6             	mov    %r14,%rsi
  8041604164:	4c 89 ef             	mov    %r13,%rdi
  8041604167:	b8 00 00 00 00       	mov    $0x0,%eax
  804160416c:	49 b8 06 3f 60 41 80 	movabs $0x8041603f06,%r8
  8041604173:	00 00 00 
  8041604176:	41 ff d0             	callq  *%r8
  8041604179:	e9 3f fe ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
        err = va_arg(aq, int);
  804160417e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604182:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604186:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160418a:	eb a2                	jmp    804160412e <vprintfmt+0x1a2>
          printfmt(putch, putdat, "error %d", err);
  804160418c:	48 ba 18 57 60 41 80 	movabs $0x8041605718,%rdx
  8041604193:	00 00 00 
  8041604196:	4c 89 f6             	mov    %r14,%rsi
  8041604199:	4c 89 ef             	mov    %r13,%rdi
  804160419c:	b8 00 00 00 00       	mov    $0x0,%eax
  80416041a1:	49 b8 06 3f 60 41 80 	movabs $0x8041603f06,%r8
  80416041a8:	00 00 00 
  80416041ab:	41 ff d0             	callq  *%r8
  80416041ae:	e9 0a fe ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
        if ((p = va_arg(aq, char *)) == NULL)
  80416041b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80416041b6:	83 fa 2f             	cmp    $0x2f,%edx
  80416041b9:	77 45                	ja     8041604200 <vprintfmt+0x274>
  80416041bb:	89 d0                	mov    %edx,%eax
  80416041bd:	48 01 c6             	add    %rax,%rsi
  80416041c0:	83 c2 08             	add    $0x8,%edx
  80416041c3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80416041c6:	48 8b 1e             	mov    (%rsi),%rbx
  80416041c9:	48 85 db             	test   %rbx,%rbx
  80416041cc:	0f 84 fb 03 00 00    	je     80416045cd <vprintfmt+0x641>
        if (width > 0 && padc != '-')
  80416041d2:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  80416041d6:	7e 06                	jle    80416041de <vprintfmt+0x252>
  80416041d8:	80 7d 98 2d          	cmpb   $0x2d,-0x68(%rbp)
  80416041dc:	75 3a                	jne    8041604218 <vprintfmt+0x28c>
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80416041de:	48 8d 43 01          	lea    0x1(%rbx),%rax
  80416041e2:	0f b6 13             	movzbl (%rbx),%edx
  80416041e5:	0f be fa             	movsbl %dl,%edi
  80416041e8:	85 ff                	test   %edi,%edi
  80416041ea:	0f 84 d5 00 00 00    	je     80416042c5 <vprintfmt+0x339>
  80416041f0:	48 89 c3             	mov    %rax,%rbx
  80416041f3:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  80416041f7:	44 8b 7d a8          	mov    -0x58(%rbp),%r15d
  80416041fb:	e9 90 00 00 00       	jmpq   8041604290 <vprintfmt+0x304>
        if ((p = va_arg(aq, char *)) == NULL)
  8041604200:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604204:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604208:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160420c:	eb b8                	jmp    80416041c6 <vprintfmt+0x23a>
          p = "(null)";
  804160420e:	48 bb 11 57 60 41 80 	movabs $0x8041605711,%rbx
  8041604215:	00 00 00 
          for (width -= strnlen(p, precision); width > 0; width--)
  8041604218:	49 63 f4             	movslq %r12d,%rsi
  804160421b:	48 89 df             	mov    %rbx,%rdi
  804160421e:	48 b8 3d 48 60 41 80 	movabs $0x804160483d,%rax
  8041604225:	00 00 00 
  8041604228:	ff d0                	callq  *%rax
  804160422a:	29 45 a8             	sub    %eax,-0x58(%rbp)
  804160422d:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8041604230:	85 c0                	test   %eax,%eax
  8041604232:	7e 2b                	jle    804160425f <vprintfmt+0x2d3>
            putch(padc, putdat);
  8041604234:	0f be 4d 98          	movsbl -0x68(%rbp),%ecx
  8041604238:	44 89 65 98          	mov    %r12d,-0x68(%rbp)
  804160423c:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  8041604240:	41 89 c4             	mov    %eax,%r12d
  8041604243:	89 cb                	mov    %ecx,%ebx
  8041604245:	4c 89 f6             	mov    %r14,%rsi
  8041604248:	89 df                	mov    %ebx,%edi
  804160424a:	41 ff d5             	callq  *%r13
          for (width -= strnlen(p, precision); width > 0; width--)
  804160424d:	41 83 ec 01          	sub    $0x1,%r12d
  8041604251:	75 f2                	jne    8041604245 <vprintfmt+0x2b9>
  8041604253:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
  8041604257:	44 89 65 a8          	mov    %r12d,-0x58(%rbp)
  804160425b:	44 8b 65 98          	mov    -0x68(%rbp),%r12d
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  804160425f:	48 8d 43 01          	lea    0x1(%rbx),%rax
  8041604263:	0f b6 13             	movzbl (%rbx),%edx
  8041604266:	0f be fa             	movsbl %dl,%edi
  8041604269:	85 ff                	test   %edi,%edi
  804160426b:	75 83                	jne    80416041f0 <vprintfmt+0x264>
  804160426d:	e9 4b fd ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
          if (altflag && (ch < ' ' || ch > '~'))
  8041604272:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  8041604276:	75 2d                	jne    80416042a5 <vprintfmt+0x319>
            putch(ch, putdat);
  8041604278:	4c 89 f6             	mov    %r14,%rsi
  804160427b:	41 ff d5             	callq  *%r13
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  804160427e:	41 83 ef 01          	sub    $0x1,%r15d
  8041604282:	0f b6 13             	movzbl (%rbx),%edx
  8041604285:	0f be fa             	movsbl %dl,%edi
  8041604288:	48 83 c3 01          	add    $0x1,%rbx
  804160428c:	85 ff                	test   %edi,%edi
  804160428e:	74 2d                	je     80416042bd <vprintfmt+0x331>
  8041604290:	45 85 e4             	test   %r12d,%r12d
  8041604293:	78 dd                	js     8041604272 <vprintfmt+0x2e6>
  8041604295:	41 83 ec 01          	sub    $0x1,%r12d
  8041604299:	79 d7                	jns    8041604272 <vprintfmt+0x2e6>
  804160429b:	44 89 7d a8          	mov    %r15d,-0x58(%rbp)
  804160429f:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80416042a3:	eb 20                	jmp    80416042c5 <vprintfmt+0x339>
          if (altflag && (ch < ' ' || ch > '~'))
  80416042a5:	0f be d2             	movsbl %dl,%edx
  80416042a8:	83 ea 20             	sub    $0x20,%edx
  80416042ab:	83 fa 5e             	cmp    $0x5e,%edx
  80416042ae:	76 c8                	jbe    8041604278 <vprintfmt+0x2ec>
            putch('?', putdat);
  80416042b0:	4c 89 f6             	mov    %r14,%rsi
  80416042b3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80416042b8:	41 ff d5             	callq  *%r13
  80416042bb:	eb c1                	jmp    804160427e <vprintfmt+0x2f2>
  80416042bd:	44 89 7d a8          	mov    %r15d,-0x58(%rbp)
  80416042c1:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80416042c5:	8b 5d a8             	mov    -0x58(%rbp),%ebx
        for (; width > 0; width--)
  80416042c8:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  80416042cc:	0f 8e eb fc ff ff    	jle    8041603fbd <vprintfmt+0x31>
          putch(' ', putdat);
  80416042d2:	4c 89 f6             	mov    %r14,%rsi
  80416042d5:	bf 20 00 00 00       	mov    $0x20,%edi
  80416042da:	41 ff d5             	callq  *%r13
        for (; width > 0; width--)
  80416042dd:	83 eb 01             	sub    $0x1,%ebx
  80416042e0:	75 f0                	jne    80416042d2 <vprintfmt+0x346>
  80416042e2:	e9 d6 fc ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
  if (lflag >= 2)
  80416042e7:	83 f9 01             	cmp    $0x1,%ecx
  80416042ea:	7e 50                	jle    804160433c <vprintfmt+0x3b0>
    return va_arg(*ap, long long);
  80416042ec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80416042ef:	83 fa 2f             	cmp    $0x2f,%edx
  80416042f2:	77 3a                	ja     804160432e <vprintfmt+0x3a2>
  80416042f4:	89 d0                	mov    %edx,%eax
  80416042f6:	48 01 c6             	add    %rax,%rsi
  80416042f9:	83 c2 08             	add    $0x8,%edx
  80416042fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80416042ff:	48 8b 1e             	mov    (%rsi),%rbx
        num = getint(&aq, lflag);
  8041604302:	48 89 da             	mov    %rbx,%rdx
        base = 10;
  8041604305:	b9 0a 00 00 00       	mov    $0xa,%ecx
        if ((long long)num < 0) {
  804160430a:	48 85 db             	test   %rbx,%rbx
  804160430d:	0f 89 c9 01 00 00    	jns    80416044dc <vprintfmt+0x550>
          putch('-', putdat);
  8041604313:	4c 89 f6             	mov    %r14,%rsi
  8041604316:	bf 2d 00 00 00       	mov    $0x2d,%edi
  804160431b:	41 ff d5             	callq  *%r13
          num = -(long long)num;
  804160431e:	48 89 da             	mov    %rbx,%rdx
  8041604321:	48 f7 da             	neg    %rdx
        base = 10;
  8041604324:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8041604329:	e9 ae 01 00 00       	jmpq   80416044dc <vprintfmt+0x550>
    return va_arg(*ap, long long);
  804160432e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604332:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604336:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160433a:	eb c3                	jmp    80416042ff <vprintfmt+0x373>
  else if (lflag)
  804160433c:	85 c9                	test   %ecx,%ecx
  804160433e:	75 18                	jne    8041604358 <vprintfmt+0x3cc>
    return va_arg(*ap, int);
  8041604340:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604343:	83 fa 2f             	cmp    $0x2f,%edx
  8041604346:	77 36                	ja     804160437e <vprintfmt+0x3f2>
  8041604348:	89 d0                	mov    %edx,%eax
  804160434a:	48 01 c6             	add    %rax,%rsi
  804160434d:	83 c2 08             	add    $0x8,%edx
  8041604350:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604353:	48 63 1e             	movslq (%rsi),%rbx
  8041604356:	eb aa                	jmp    8041604302 <vprintfmt+0x376>
    return va_arg(*ap, long);
  8041604358:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804160435b:	83 fa 2f             	cmp    $0x2f,%edx
  804160435e:	77 10                	ja     8041604370 <vprintfmt+0x3e4>
  8041604360:	89 d0                	mov    %edx,%eax
  8041604362:	48 01 c6             	add    %rax,%rsi
  8041604365:	83 c2 08             	add    $0x8,%edx
  8041604368:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804160436b:	48 8b 1e             	mov    (%rsi),%rbx
  804160436e:	eb 92                	jmp    8041604302 <vprintfmt+0x376>
  8041604370:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604374:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604378:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160437c:	eb ed                	jmp    804160436b <vprintfmt+0x3df>
    return va_arg(*ap, int);
  804160437e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604382:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604386:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160438a:	eb c7                	jmp    8041604353 <vprintfmt+0x3c7>
  if (lflag >= 2)
  804160438c:	83 f9 01             	cmp    $0x1,%ecx
  804160438f:	7e 2e                	jle    80416043bf <vprintfmt+0x433>
    return va_arg(*ap, unsigned long long);
  8041604391:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604394:	83 fa 2f             	cmp    $0x2f,%edx
  8041604397:	77 18                	ja     80416043b1 <vprintfmt+0x425>
  8041604399:	89 d0                	mov    %edx,%eax
  804160439b:	48 01 c6             	add    %rax,%rsi
  804160439e:	83 c2 08             	add    $0x8,%edx
  80416043a1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80416043a4:	48 8b 16             	mov    (%rsi),%rdx
        base = 10;
  80416043a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80416043ac:	e9 2b 01 00 00       	jmpq   80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long long);
  80416043b1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80416043b5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80416043b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80416043bd:	eb e5                	jmp    80416043a4 <vprintfmt+0x418>
  else if (lflag)
  80416043bf:	85 c9                	test   %ecx,%ecx
  80416043c1:	75 1f                	jne    80416043e2 <vprintfmt+0x456>
    return va_arg(*ap, unsigned int);
  80416043c3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80416043c6:	83 fa 2f             	cmp    $0x2f,%edx
  80416043c9:	77 45                	ja     8041604410 <vprintfmt+0x484>
  80416043cb:	89 d0                	mov    %edx,%eax
  80416043cd:	48 01 c6             	add    %rax,%rsi
  80416043d0:	83 c2 08             	add    $0x8,%edx
  80416043d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80416043d6:	8b 16                	mov    (%rsi),%edx
        base = 10;
  80416043d8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80416043dd:	e9 fa 00 00 00       	jmpq   80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  80416043e2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80416043e5:	83 fa 2f             	cmp    $0x2f,%edx
  80416043e8:	77 18                	ja     8041604402 <vprintfmt+0x476>
  80416043ea:	89 d0                	mov    %edx,%eax
  80416043ec:	48 01 c6             	add    %rax,%rsi
  80416043ef:	83 c2 08             	add    $0x8,%edx
  80416043f2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80416043f5:	48 8b 16             	mov    (%rsi),%rdx
        base = 10;
  80416043f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80416043fd:	e9 da 00 00 00       	jmpq   80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  8041604402:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604406:	48 8d 46 08          	lea    0x8(%rsi),%rax
  804160440a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160440e:	eb e5                	jmp    80416043f5 <vprintfmt+0x469>
    return va_arg(*ap, unsigned int);
  8041604410:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604414:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604418:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160441c:	eb b8                	jmp    80416043d6 <vprintfmt+0x44a>
  if (lflag >= 2)
  804160441e:	83 f9 01             	cmp    $0x1,%ecx
  8041604421:	7e 2e                	jle    8041604451 <vprintfmt+0x4c5>
    return va_arg(*ap, unsigned long long);
  8041604423:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604426:	83 fa 2f             	cmp    $0x2f,%edx
  8041604429:	77 18                	ja     8041604443 <vprintfmt+0x4b7>
  804160442b:	89 d0                	mov    %edx,%eax
  804160442d:	48 01 c6             	add    %rax,%rsi
  8041604430:	83 c2 08             	add    $0x8,%edx
  8041604433:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604436:	48 8b 16             	mov    (%rsi),%rdx
        base = 8;
  8041604439:	b9 08 00 00 00       	mov    $0x8,%ecx
  804160443e:	e9 99 00 00 00       	jmpq   80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long long);
  8041604443:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604447:	48 8d 46 08          	lea    0x8(%rsi),%rax
  804160444b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160444f:	eb e5                	jmp    8041604436 <vprintfmt+0x4aa>
  else if (lflag)
  8041604451:	85 c9                	test   %ecx,%ecx
  8041604453:	75 1c                	jne    8041604471 <vprintfmt+0x4e5>
    return va_arg(*ap, unsigned int);
  8041604455:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604458:	83 fa 2f             	cmp    $0x2f,%edx
  804160445b:	77 3f                	ja     804160449c <vprintfmt+0x510>
  804160445d:	89 d0                	mov    %edx,%eax
  804160445f:	48 01 c6             	add    %rax,%rsi
  8041604462:	83 c2 08             	add    $0x8,%edx
  8041604465:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604468:	8b 16                	mov    (%rsi),%edx
        base = 8;
  804160446a:	b9 08 00 00 00       	mov    $0x8,%ecx
  804160446f:	eb 6b                	jmp    80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  8041604471:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604474:	83 fa 2f             	cmp    $0x2f,%edx
  8041604477:	77 15                	ja     804160448e <vprintfmt+0x502>
  8041604479:	89 d0                	mov    %edx,%eax
  804160447b:	48 01 c6             	add    %rax,%rsi
  804160447e:	83 c2 08             	add    $0x8,%edx
  8041604481:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604484:	48 8b 16             	mov    (%rsi),%rdx
        base = 8;
  8041604487:	b9 08 00 00 00       	mov    $0x8,%ecx
  804160448c:	eb 4e                	jmp    80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  804160448e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604492:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604496:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804160449a:	eb e8                	jmp    8041604484 <vprintfmt+0x4f8>
    return va_arg(*ap, unsigned int);
  804160449c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80416044a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80416044a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80416044a8:	eb be                	jmp    8041604468 <vprintfmt+0x4dc>
        putch('0', putdat);
  80416044aa:	4c 89 f6             	mov    %r14,%rsi
  80416044ad:	bf 30 00 00 00       	mov    $0x30,%edi
  80416044b2:	41 ff d5             	callq  *%r13
        putch('x', putdat);
  80416044b5:	4c 89 f6             	mov    %r14,%rsi
  80416044b8:	bf 78 00 00 00       	mov    $0x78,%edi
  80416044bd:	41 ff d5             	callq  *%r13
        num  = (unsigned long long)(uintptr_t)va_arg(aq, void *);
  80416044c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80416044c3:	83 f8 2f             	cmp    $0x2f,%eax
  80416044c6:	77 34                	ja     80416044fc <vprintfmt+0x570>
  80416044c8:	89 c2                	mov    %eax,%edx
  80416044ca:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80416044ce:	83 c0 08             	add    $0x8,%eax
  80416044d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80416044d4:	48 8b 12             	mov    (%rdx),%rdx
        base = 16;
  80416044d7:	b9 10 00 00 00       	mov    $0x10,%ecx
        printnum(putch, putdat, num, base, width, padc);
  80416044dc:	44 0f be 4d 98       	movsbl -0x68(%rbp),%r9d
  80416044e1:	44 8b 45 a8          	mov    -0x58(%rbp),%r8d
  80416044e5:	4c 89 f6             	mov    %r14,%rsi
  80416044e8:	4c 89 ef             	mov    %r13,%rdi
  80416044eb:	48 b8 5d 3e 60 41 80 	movabs $0x8041603e5d,%rax
  80416044f2:	00 00 00 
  80416044f5:	ff d0                	callq  *%rax
        break;
  80416044f7:	e9 c1 fa ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
        num  = (unsigned long long)(uintptr_t)va_arg(aq, void *);
  80416044fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8041604500:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8041604504:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604508:	eb ca                	jmp    80416044d4 <vprintfmt+0x548>
  if (lflag >= 2)
  804160450a:	83 f9 01             	cmp    $0x1,%ecx
  804160450d:	7e 2b                	jle    804160453a <vprintfmt+0x5ae>
    return va_arg(*ap, unsigned long long);
  804160450f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8041604512:	83 fa 2f             	cmp    $0x2f,%edx
  8041604515:	77 15                	ja     804160452c <vprintfmt+0x5a0>
  8041604517:	89 d0                	mov    %edx,%eax
  8041604519:	48 01 c6             	add    %rax,%rsi
  804160451c:	83 c2 08             	add    $0x8,%edx
  804160451f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8041604522:	48 8b 16             	mov    (%rsi),%rdx
        base = 16;
  8041604525:	b9 10 00 00 00       	mov    $0x10,%ecx
  804160452a:	eb b0                	jmp    80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long long);
  804160452c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8041604530:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604534:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604538:	eb e8                	jmp    8041604522 <vprintfmt+0x596>
  else if (lflag)
  804160453a:	85 c9                	test   %ecx,%ecx
  804160453c:	75 1c                	jne    804160455a <vprintfmt+0x5ce>
    return va_arg(*ap, unsigned int);
  804160453e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8041604541:	83 f8 2f             	cmp    $0x2f,%eax
  8041604544:	77 42                	ja     8041604588 <vprintfmt+0x5fc>
  8041604546:	89 c2                	mov    %eax,%edx
  8041604548:	48 01 d6             	add    %rdx,%rsi
  804160454b:	83 c0 08             	add    $0x8,%eax
  804160454e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8041604551:	8b 16                	mov    (%rsi),%edx
        base = 16;
  8041604553:	b9 10 00 00 00       	mov    $0x10,%ecx
  8041604558:	eb 82                	jmp    80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  804160455a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804160455d:	83 fa 2f             	cmp    $0x2f,%edx
  8041604560:	77 18                	ja     804160457a <vprintfmt+0x5ee>
  8041604562:	89 d0                	mov    %edx,%eax
  8041604564:	48 01 c6             	add    %rax,%rsi
  8041604567:	83 c2 08             	add    $0x8,%edx
  804160456a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804160456d:	48 8b 16             	mov    (%rsi),%rdx
        base = 16;
  8041604570:	b9 10 00 00 00       	mov    $0x10,%ecx
  8041604575:	e9 62 ff ff ff       	jmpq   80416044dc <vprintfmt+0x550>
    return va_arg(*ap, unsigned long);
  804160457a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804160457e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604582:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604586:	eb e5                	jmp    804160456d <vprintfmt+0x5e1>
    return va_arg(*ap, unsigned int);
  8041604588:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804160458c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8041604590:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041604594:	eb bb                	jmp    8041604551 <vprintfmt+0x5c5>
        putch(ch, putdat);
  8041604596:	4c 89 f6             	mov    %r14,%rsi
  8041604599:	bf 25 00 00 00       	mov    $0x25,%edi
  804160459e:	41 ff d5             	callq  *%r13
        break;
  80416045a1:	e9 17 fa ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
        putch('%', putdat);
  80416045a6:	4c 89 f6             	mov    %r14,%rsi
  80416045a9:	bf 25 00 00 00       	mov    $0x25,%edi
  80416045ae:	41 ff d5             	callq  *%r13
        for (fmt--; fmt[-1] != '%'; fmt--)
  80416045b1:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  80416045b5:	0f 84 22 fa ff ff    	je     8041603fdd <vprintfmt+0x51>
  80416045bb:	48 83 eb 01          	sub    $0x1,%rbx
  80416045bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  80416045c3:	75 f6                	jne    80416045bb <vprintfmt+0x62f>
  80416045c5:	49 89 df             	mov    %rbx,%r15
  80416045c8:	e9 f0 f9 ff ff       	jmpq   8041603fbd <vprintfmt+0x31>
        if (width > 0 && padc != '-')
  80416045cd:	80 7d 98 2d          	cmpb   $0x2d,-0x68(%rbp)
  80416045d1:	74 0a                	je     80416045dd <vprintfmt+0x651>
  80416045d3:	83 7d a8 00          	cmpl   $0x0,-0x58(%rbp)
  80416045d7:	0f 8f 31 fc ff ff    	jg     804160420e <vprintfmt+0x282>
        for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80416045dd:	48 b8 12 57 60 41 80 	movabs $0x8041605712,%rax
  80416045e4:	00 00 00 
  80416045e7:	bf 28 00 00 00       	mov    $0x28,%edi
  80416045ec:	ba 28 00 00 00       	mov    $0x28,%edx
  80416045f1:	e9 fa fb ff ff       	jmpq   80416041f0 <vprintfmt+0x264>
}
  80416045f6:	48 83 c4 48          	add    $0x48,%rsp
  80416045fa:	5b                   	pop    %rbx
  80416045fb:	41 5c                	pop    %r12
  80416045fd:	41 5d                	pop    %r13
  80416045ff:	41 5e                	pop    %r14
  8041604601:	41 5f                	pop    %r15
  8041604603:	5d                   	pop    %rbp
  8041604604:	c3                   	retq   

0000008041604605 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap) {
  8041604605:	55                   	push   %rbp
  8041604606:	48 89 e5             	mov    %rsp,%rbp
  8041604609:	48 83 ec 20          	sub    $0x20,%rsp
  struct sprintbuf b = {buf, buf + n - 1, 0};
  804160460d:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
  8041604611:	48 63 c6             	movslq %esi,%rax
  8041604614:	48 8d 44 07 ff       	lea    -0x1(%rdi,%rax,1),%rax
  8041604619:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804160461d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

  if (buf == NULL || n < 1)
  8041604624:	48 85 ff             	test   %rdi,%rdi
  8041604627:	74 2a                	je     8041604653 <vsnprintf+0x4e>
  8041604629:	85 f6                	test   %esi,%esi
  804160462b:	7e 26                	jle    8041604653 <vsnprintf+0x4e>
    return -E_INVAL;

  // print the string to the buffer
  vprintfmt((void *)sprintputch, &b, fmt, ap);
  804160462d:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8041604631:	48 bf e9 3e 60 41 80 	movabs $0x8041603ee9,%rdi
  8041604638:	00 00 00 
  804160463b:	48 b8 8c 3f 60 41 80 	movabs $0x8041603f8c,%rax
  8041604642:	00 00 00 
  8041604645:	ff d0                	callq  *%rax

  // null terminate the buffer
  *b.buf = '\0';
  8041604647:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804160464b:	c6 00 00             	movb   $0x0,(%rax)

  return b.cnt;
  804160464e:	8b 45 f0             	mov    -0x10(%rbp),%eax
}
  8041604651:	c9                   	leaveq 
  8041604652:	c3                   	retq   
    return -E_INVAL;
  8041604653:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041604658:	eb f7                	jmp    8041604651 <vsnprintf+0x4c>

000000804160465a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...) {
  804160465a:	55                   	push   %rbp
  804160465b:	48 89 e5             	mov    %rsp,%rbp
  804160465e:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8041604665:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804160466c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041604673:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804160467a:	84 c0                	test   %al,%al
  804160467c:	74 20                	je     804160469e <snprintf+0x44>
  804160467e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8041604682:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8041604686:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804160468a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804160468e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8041604692:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8041604696:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804160469a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int rc;

  va_start(ap, fmt);
  804160469e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80416046a5:	00 00 00 
  80416046a8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80416046af:	00 00 00 
  80416046b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80416046b6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80416046bd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80416046c4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  rc = vsnprintf(buf, n, fmt, ap);
  80416046cb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80416046d2:	48 b8 05 46 60 41 80 	movabs $0x8041604605,%rax
  80416046d9:	00 00 00 
  80416046dc:	ff d0                	callq  *%rax
  va_end(ap);

  return rc;
}
  80416046de:	c9                   	leaveq 
  80416046df:	c3                   	retq   

00000080416046e0 <readline>:

#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt) {
  80416046e0:	55                   	push   %rbp
  80416046e1:	48 89 e5             	mov    %rsp,%rbp
  80416046e4:	41 57                	push   %r15
  80416046e6:	41 56                	push   %r14
  80416046e8:	41 55                	push   %r13
  80416046ea:	41 54                	push   %r12
  80416046ec:	53                   	push   %rbx
  80416046ed:	48 83 ec 08          	sub    $0x8,%rsp
  int i, c, echoing;

  if (prompt != NULL)
  80416046f1:	48 85 ff             	test   %rdi,%rdi
  80416046f4:	74 1e                	je     8041604714 <readline+0x34>
    cprintf("%s", prompt);
  80416046f6:	48 89 fe             	mov    %rdi,%rsi
  80416046f9:	48 bf 8b 50 60 41 80 	movabs $0x804160508b,%rdi
  8041604700:	00 00 00 
  8041604703:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604708:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160470f:	00 00 00 
  8041604712:	ff d2                	callq  *%rdx

  i       = 0;
  echoing = iscons(0);
  8041604714:	bf 00 00 00 00       	mov    $0x0,%edi
  8041604719:	48 b8 95 0b 60 41 80 	movabs $0x8041600b95,%rax
  8041604720:	00 00 00 
  8041604723:	ff d0                	callq  *%rax
  8041604725:	41 89 c6             	mov    %eax,%r14d
  i       = 0;
  8041604728:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  while (1) {
    c = getchar();
  804160472e:	49 bd 75 0b 60 41 80 	movabs $0x8041600b75,%r13
  8041604735:	00 00 00 
      cprintf("read error: %i\n", c);
      return NULL;
    } else if ((c == '\b' || c == '\x7f')) {
      if (i > 0) {
        if (echoing) {
          cputchar('\b');
  8041604738:	49 bf 63 0b 60 41 80 	movabs $0x8041600b63,%r15
  804160473f:	00 00 00 
  8041604742:	eb 3f                	jmp    8041604783 <readline+0xa3>
      cprintf("read error: %i\n", c);
  8041604744:	89 c6                	mov    %eax,%esi
  8041604746:	48 bf a0 5a 60 41 80 	movabs $0x8041605aa0,%rdi
  804160474d:	00 00 00 
  8041604750:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604755:	48 ba 0d 3b 60 41 80 	movabs $0x8041603b0d,%rdx
  804160475c:	00 00 00 
  804160475f:	ff d2                	callq  *%rdx
      return NULL;
  8041604761:	b8 00 00 00 00       	mov    $0x0,%eax
        cputchar('\n');
      buf[i] = 0;
      return buf;
    }
  }
}
  8041604766:	48 83 c4 08          	add    $0x8,%rsp
  804160476a:	5b                   	pop    %rbx
  804160476b:	41 5c                	pop    %r12
  804160476d:	41 5d                	pop    %r13
  804160476f:	41 5e                	pop    %r14
  8041604771:	41 5f                	pop    %r15
  8041604773:	5d                   	pop    %rbp
  8041604774:	c3                   	retq   
      if (i > 0) {
  8041604775:	45 85 e4             	test   %r12d,%r12d
  8041604778:	7e 09                	jle    8041604783 <readline+0xa3>
        if (echoing) {
  804160477a:	45 85 f6             	test   %r14d,%r14d
  804160477d:	75 41                	jne    80416047c0 <readline+0xe0>
        i--;
  804160477f:	41 83 ec 01          	sub    $0x1,%r12d
    c = getchar();
  8041604783:	41 ff d5             	callq  *%r13
  8041604786:	89 c3                	mov    %eax,%ebx
    if (c < 0) {
  8041604788:	85 c0                	test   %eax,%eax
  804160478a:	78 b8                	js     8041604744 <readline+0x64>
    } else if ((c == '\b' || c == '\x7f')) {
  804160478c:	83 f8 08             	cmp    $0x8,%eax
  804160478f:	74 e4                	je     8041604775 <readline+0x95>
  8041604791:	83 f8 7f             	cmp    $0x7f,%eax
  8041604794:	74 df                	je     8041604775 <readline+0x95>
    } else if (c >= ' ' && i < BUFLEN - 1) {
  8041604796:	83 f8 1f             	cmp    $0x1f,%eax
  8041604799:	7e 46                	jle    80416047e1 <readline+0x101>
  804160479b:	41 81 fc fe 03 00 00 	cmp    $0x3fe,%r12d
  80416047a2:	7f 3d                	jg     80416047e1 <readline+0x101>
      if (echoing)
  80416047a4:	45 85 f6             	test   %r14d,%r14d
  80416047a7:	75 31                	jne    80416047da <readline+0xfa>
      buf[i++] = c;
  80416047a9:	49 63 c4             	movslq %r12d,%rax
  80416047ac:	48 b9 80 69 61 41 80 	movabs $0x8041616980,%rcx
  80416047b3:	00 00 00 
  80416047b6:	88 1c 01             	mov    %bl,(%rcx,%rax,1)
  80416047b9:	45 8d 64 24 01       	lea    0x1(%r12),%r12d
  80416047be:	eb c3                	jmp    8041604783 <readline+0xa3>
          cputchar('\b');
  80416047c0:	bf 08 00 00 00       	mov    $0x8,%edi
  80416047c5:	41 ff d7             	callq  *%r15
          cputchar(' ');
  80416047c8:	bf 20 00 00 00       	mov    $0x20,%edi
  80416047cd:	41 ff d7             	callq  *%r15
          cputchar('\b');
  80416047d0:	bf 08 00 00 00       	mov    $0x8,%edi
  80416047d5:	41 ff d7             	callq  *%r15
  80416047d8:	eb a5                	jmp    804160477f <readline+0x9f>
        cputchar(c);
  80416047da:	89 c7                	mov    %eax,%edi
  80416047dc:	41 ff d7             	callq  *%r15
  80416047df:	eb c8                	jmp    80416047a9 <readline+0xc9>
    } else if (c == '\n' || c == '\r') {
  80416047e1:	83 fb 0a             	cmp    $0xa,%ebx
  80416047e4:	74 05                	je     80416047eb <readline+0x10b>
  80416047e6:	83 fb 0d             	cmp    $0xd,%ebx
  80416047e9:	75 98                	jne    8041604783 <readline+0xa3>
      if (echoing)
  80416047eb:	45 85 f6             	test   %r14d,%r14d
  80416047ee:	75 17                	jne    8041604807 <readline+0x127>
      buf[i] = 0;
  80416047f0:	48 b8 80 69 61 41 80 	movabs $0x8041616980,%rax
  80416047f7:	00 00 00 
  80416047fa:	4d 63 e4             	movslq %r12d,%r12
  80416047fd:	42 c6 04 20 00       	movb   $0x0,(%rax,%r12,1)
      return buf;
  8041604802:	e9 5f ff ff ff       	jmpq   8041604766 <readline+0x86>
        cputchar('\n');
  8041604807:	bf 0a 00 00 00       	mov    $0xa,%edi
  804160480c:	48 b8 63 0b 60 41 80 	movabs $0x8041600b63,%rax
  8041604813:	00 00 00 
  8041604816:	ff d0                	callq  *%rax
  8041604818:	eb d6                	jmp    80416047f0 <readline+0x110>

000000804160481a <strlen>:
// but it makes an even bigger difference on bochs.
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s) {
  804160481a:	55                   	push   %rbp
  804160481b:	48 89 e5             	mov    %rsp,%rbp
  int n;

  for (n = 0; *s != '\0'; s++)
  804160481e:	80 3f 00             	cmpb   $0x0,(%rdi)
  8041604821:	74 13                	je     8041604836 <strlen+0x1c>
  8041604823:	b8 00 00 00 00       	mov    $0x0,%eax
    n++;
  8041604828:	83 c0 01             	add    $0x1,%eax
  for (n = 0; *s != '\0'; s++)
  804160482b:	48 83 c7 01          	add    $0x1,%rdi
  804160482f:	80 3f 00             	cmpb   $0x0,(%rdi)
  8041604832:	75 f4                	jne    8041604828 <strlen+0xe>
  return n;
}
  8041604834:	5d                   	pop    %rbp
  8041604835:	c3                   	retq   
  for (n = 0; *s != '\0'; s++)
  8041604836:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  804160483b:	eb f7                	jmp    8041604834 <strlen+0x1a>

000000804160483d <strnlen>:

int
strnlen(const char *s, size_t size) {
  804160483d:	55                   	push   %rbp
  804160483e:	48 89 e5             	mov    %rsp,%rbp
  int n;

  for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8041604841:	48 85 f6             	test   %rsi,%rsi
  8041604844:	74 20                	je     8041604866 <strnlen+0x29>
  8041604846:	80 3f 00             	cmpb   $0x0,(%rdi)
  8041604849:	74 22                	je     804160486d <strnlen+0x30>
  804160484b:	48 01 fe             	add    %rdi,%rsi
  804160484e:	b8 00 00 00 00       	mov    $0x0,%eax
    n++;
  8041604853:	83 c0 01             	add    $0x1,%eax
  for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8041604856:	48 83 c7 01          	add    $0x1,%rdi
  804160485a:	48 39 fe             	cmp    %rdi,%rsi
  804160485d:	74 05                	je     8041604864 <strnlen+0x27>
  804160485f:	80 3f 00             	cmpb   $0x0,(%rdi)
  8041604862:	75 ef                	jne    8041604853 <strnlen+0x16>
  return n;
}
  8041604864:	5d                   	pop    %rbp
  8041604865:	c3                   	retq   
  for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8041604866:	b8 00 00 00 00       	mov    $0x0,%eax
  804160486b:	eb f7                	jmp    8041604864 <strnlen+0x27>
  804160486d:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  8041604872:	eb f0                	jmp    8041604864 <strnlen+0x27>

0000008041604874 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  8041604874:	55                   	push   %rbp
  8041604875:	48 89 e5             	mov    %rsp,%rbp
  8041604878:	48 89 f8             	mov    %rdi,%rax
  char *ret;

  ret = dst;
  while ((*dst++ = *src++) != '\0')
  804160487b:	48 89 fa             	mov    %rdi,%rdx
  804160487e:	48 83 c6 01          	add    $0x1,%rsi
  8041604882:	48 83 c2 01          	add    $0x1,%rdx
  8041604886:	0f b6 4e ff          	movzbl -0x1(%rsi),%ecx
  804160488a:	88 4a ff             	mov    %cl,-0x1(%rdx)
  804160488d:	84 c9                	test   %cl,%cl
  804160488f:	75 ed                	jne    804160487e <strcpy+0xa>
    /* do nothing */;
  return ret;
}
  8041604891:	5d                   	pop    %rbp
  8041604892:	c3                   	retq   

0000008041604893 <strcat>:

char *
strcat(char *dst, const char *src) {
  8041604893:	55                   	push   %rbp
  8041604894:	48 89 e5             	mov    %rsp,%rbp
  8041604897:	41 54                	push   %r12
  8041604899:	53                   	push   %rbx
  804160489a:	48 89 fb             	mov    %rdi,%rbx
  804160489d:	49 89 f4             	mov    %rsi,%r12
  int len = strlen(dst);
  80416048a0:	48 b8 1a 48 60 41 80 	movabs $0x804160481a,%rax
  80416048a7:	00 00 00 
  80416048aa:	ff d0                	callq  *%rax
  strcpy(dst + len, src);
  80416048ac:	48 63 f8             	movslq %eax,%rdi
  80416048af:	48 01 df             	add    %rbx,%rdi
  80416048b2:	4c 89 e6             	mov    %r12,%rsi
  80416048b5:	48 b8 74 48 60 41 80 	movabs $0x8041604874,%rax
  80416048bc:	00 00 00 
  80416048bf:	ff d0                	callq  *%rax
  return dst;
}
  80416048c1:	48 89 d8             	mov    %rbx,%rax
  80416048c4:	5b                   	pop    %rbx
  80416048c5:	41 5c                	pop    %r12
  80416048c7:	5d                   	pop    %rbp
  80416048c8:	c3                   	retq   

00000080416048c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80416048c9:	55                   	push   %rbp
  80416048ca:	48 89 e5             	mov    %rsp,%rbp
  80416048cd:	48 89 f8             	mov    %rdi,%rax
  size_t i;
  char *ret;

  ret = dst;
  for (i = 0; i < size; i++) {
  80416048d0:	48 85 d2             	test   %rdx,%rdx
  80416048d3:	74 1e                	je     80416048f3 <strncpy+0x2a>
  80416048d5:	48 01 fa             	add    %rdi,%rdx
  80416048d8:	48 89 f9             	mov    %rdi,%rcx
    *dst++ = *src;
  80416048db:	48 83 c1 01          	add    $0x1,%rcx
  80416048df:	44 0f b6 06          	movzbl (%rsi),%r8d
  80416048e3:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
    // If strlen(src) < size, null-pad 'dst' out to 'size' chars
    if (*src != '\0')
      src++;
  80416048e7:	80 3e 01             	cmpb   $0x1,(%rsi)
  80416048ea:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  for (i = 0; i < size; i++) {
  80416048ee:	48 39 ca             	cmp    %rcx,%rdx
  80416048f1:	75 e8                	jne    80416048db <strncpy+0x12>
  }
  return ret;
}
  80416048f3:	5d                   	pop    %rbp
  80416048f4:	c3                   	retq   

00000080416048f5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  80416048f5:	55                   	push   %rbp
  80416048f6:	48 89 e5             	mov    %rsp,%rbp
  80416048f9:	48 89 f8             	mov    %rdi,%rax
  char *dst_in;

  dst_in = dst;
  if (size > 0) {
  80416048fc:	48 85 d2             	test   %rdx,%rdx
  80416048ff:	74 36                	je     8041604937 <strlcpy+0x42>
    while (--size > 0 && *src != '\0')
  8041604901:	48 83 fa 01          	cmp    $0x1,%rdx
  8041604905:	74 2d                	je     8041604934 <strlcpy+0x3f>
  8041604907:	44 0f b6 06          	movzbl (%rsi),%r8d
  804160490b:	45 84 c0             	test   %r8b,%r8b
  804160490e:	74 24                	je     8041604934 <strlcpy+0x3f>
  8041604910:	48 8d 4e 01          	lea    0x1(%rsi),%rcx
  8041604914:	48 8d 54 16 ff       	lea    -0x1(%rsi,%rdx,1),%rdx
      *dst++ = *src++;
  8041604919:	48 83 c0 01          	add    $0x1,%rax
  804160491d:	44 88 40 ff          	mov    %r8b,-0x1(%rax)
    while (--size > 0 && *src != '\0')
  8041604921:	48 39 d1             	cmp    %rdx,%rcx
  8041604924:	74 0e                	je     8041604934 <strlcpy+0x3f>
  8041604926:	48 83 c1 01          	add    $0x1,%rcx
  804160492a:	44 0f b6 41 ff       	movzbl -0x1(%rcx),%r8d
  804160492f:	45 84 c0             	test   %r8b,%r8b
  8041604932:	75 e5                	jne    8041604919 <strlcpy+0x24>
    *dst = '\0';
  8041604934:	c6 00 00             	movb   $0x0,(%rax)
  }
  return dst - dst_in;
  8041604937:	48 29 f8             	sub    %rdi,%rax
}
  804160493a:	5d                   	pop    %rbp
  804160493b:	c3                   	retq   

000000804160493c <strcmp>:
  }
  return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  804160493c:	55                   	push   %rbp
  804160493d:	48 89 e5             	mov    %rsp,%rbp
  while (*p && *p == *q)
  8041604940:	0f b6 07             	movzbl (%rdi),%eax
  8041604943:	84 c0                	test   %al,%al
  8041604945:	74 17                	je     804160495e <strcmp+0x22>
  8041604947:	3a 06                	cmp    (%rsi),%al
  8041604949:	75 13                	jne    804160495e <strcmp+0x22>
    p++, q++;
  804160494b:	48 83 c7 01          	add    $0x1,%rdi
  804160494f:	48 83 c6 01          	add    $0x1,%rsi
  while (*p && *p == *q)
  8041604953:	0f b6 07             	movzbl (%rdi),%eax
  8041604956:	84 c0                	test   %al,%al
  8041604958:	74 04                	je     804160495e <strcmp+0x22>
  804160495a:	3a 06                	cmp    (%rsi),%al
  804160495c:	74 ed                	je     804160494b <strcmp+0xf>
  return (int)((unsigned char)*p - (unsigned char)*q);
  804160495e:	0f b6 c0             	movzbl %al,%eax
  8041604961:	0f b6 16             	movzbl (%rsi),%edx
  8041604964:	29 d0                	sub    %edx,%eax
}
  8041604966:	5d                   	pop    %rbp
  8041604967:	c3                   	retq   

0000008041604968 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  8041604968:	55                   	push   %rbp
  8041604969:	48 89 e5             	mov    %rsp,%rbp
  while (n > 0 && *p && *p == *q)
  804160496c:	48 85 d2             	test   %rdx,%rdx
  804160496f:	74 30                	je     80416049a1 <strncmp+0x39>
  8041604971:	0f b6 07             	movzbl (%rdi),%eax
  8041604974:	84 c0                	test   %al,%al
  8041604976:	74 1f                	je     8041604997 <strncmp+0x2f>
  8041604978:	3a 06                	cmp    (%rsi),%al
  804160497a:	75 1b                	jne    8041604997 <strncmp+0x2f>
  804160497c:	48 01 fa             	add    %rdi,%rdx
    n--, p++, q++;
  804160497f:	48 83 c7 01          	add    $0x1,%rdi
  8041604983:	48 83 c6 01          	add    $0x1,%rsi
  while (n > 0 && *p && *p == *q)
  8041604987:	48 39 d7             	cmp    %rdx,%rdi
  804160498a:	74 1c                	je     80416049a8 <strncmp+0x40>
  804160498c:	0f b6 07             	movzbl (%rdi),%eax
  804160498f:	84 c0                	test   %al,%al
  8041604991:	74 04                	je     8041604997 <strncmp+0x2f>
  8041604993:	3a 06                	cmp    (%rsi),%al
  8041604995:	74 e8                	je     804160497f <strncmp+0x17>
  if (n == 0)
    return 0;
  else
    return (int)((unsigned char)*p - (unsigned char)*q);
  8041604997:	0f b6 07             	movzbl (%rdi),%eax
  804160499a:	0f b6 16             	movzbl (%rsi),%edx
  804160499d:	29 d0                	sub    %edx,%eax
}
  804160499f:	5d                   	pop    %rbp
  80416049a0:	c3                   	retq   
    return 0;
  80416049a1:	b8 00 00 00 00       	mov    $0x0,%eax
  80416049a6:	eb f7                	jmp    804160499f <strncmp+0x37>
  80416049a8:	b8 00 00 00 00       	mov    $0x0,%eax
  80416049ad:	eb f0                	jmp    804160499f <strncmp+0x37>

00000080416049af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c) {
  80416049af:	55                   	push   %rbp
  80416049b0:	48 89 e5             	mov    %rsp,%rbp
  for (; *s; s++)
  80416049b3:	0f b6 07             	movzbl (%rdi),%eax
  80416049b6:	84 c0                	test   %al,%al
  80416049b8:	74 22                	je     80416049dc <strchr+0x2d>
  80416049ba:	89 f2                	mov    %esi,%edx
    if (*s == c)
  80416049bc:	40 38 c6             	cmp    %al,%sil
  80416049bf:	74 22                	je     80416049e3 <strchr+0x34>
  for (; *s; s++)
  80416049c1:	48 83 c7 01          	add    $0x1,%rdi
  80416049c5:	0f b6 07             	movzbl (%rdi),%eax
  80416049c8:	84 c0                	test   %al,%al
  80416049ca:	74 09                	je     80416049d5 <strchr+0x26>
    if (*s == c)
  80416049cc:	38 d0                	cmp    %dl,%al
  80416049ce:	75 f1                	jne    80416049c1 <strchr+0x12>
  for (; *s; s++)
  80416049d0:	48 89 f8             	mov    %rdi,%rax
  80416049d3:	eb 05                	jmp    80416049da <strchr+0x2b>
      return (char *)s;
  return 0;
  80416049d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80416049da:	5d                   	pop    %rbp
  80416049db:	c3                   	retq   
  return 0;
  80416049dc:	b8 00 00 00 00       	mov    $0x0,%eax
  80416049e1:	eb f7                	jmp    80416049da <strchr+0x2b>
    if (*s == c)
  80416049e3:	48 89 f8             	mov    %rdi,%rax
  80416049e6:	eb f2                	jmp    80416049da <strchr+0x2b>

00000080416049e8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c) {
  80416049e8:	55                   	push   %rbp
  80416049e9:	48 89 e5             	mov    %rsp,%rbp
  80416049ec:	48 89 f8             	mov    %rdi,%rax
  for (; *s; s++)
  80416049ef:	0f b6 17             	movzbl (%rdi),%edx
    if (*s == c)
  80416049f2:	40 38 f2             	cmp    %sil,%dl
  80416049f5:	74 15                	je     8041604a0c <strfind+0x24>
  80416049f7:	89 f1                	mov    %esi,%ecx
  80416049f9:	84 d2                	test   %dl,%dl
  80416049fb:	74 0f                	je     8041604a0c <strfind+0x24>
  for (; *s; s++)
  80416049fd:	48 83 c0 01          	add    $0x1,%rax
  8041604a01:	0f b6 10             	movzbl (%rax),%edx
    if (*s == c)
  8041604a04:	38 ca                	cmp    %cl,%dl
  8041604a06:	74 04                	je     8041604a0c <strfind+0x24>
  8041604a08:	84 d2                	test   %dl,%dl
  8041604a0a:	75 f1                	jne    80416049fd <strfind+0x15>
      break;
  return (char *)s;
}
  8041604a0c:	5d                   	pop    %rbp
  8041604a0d:	c3                   	retq   

0000008041604a0e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n) {
  8041604a0e:	55                   	push   %rbp
  8041604a0f:	48 89 e5             	mov    %rsp,%rbp
  if (n == 0)
  8041604a12:	48 85 d2             	test   %rdx,%rdx
  8041604a15:	74 13                	je     8041604a2a <memset+0x1c>
    return v;
  if ((int64_t)v % 4 == 0 && n % 4 == 0) {
  8041604a17:	40 f6 c7 03          	test   $0x3,%dil
  8041604a1b:	75 05                	jne    8041604a22 <memset+0x14>
  8041604a1d:	f6 c2 03             	test   $0x3,%dl
  8041604a20:	74 0d                	je     8041604a2f <memset+0x21>
    uint32_t k = c & 0xFFU;
    k          = (k << 24U) | (k << 16U) | (k << 8U) | k;
    asm volatile("cld; rep stosl\n" ::"D"(v), "a"(k), "c"(n / 4)
                 : "cc", "memory");
  } else
    asm volatile("cld; rep stosb\n" ::"D"(v), "a"(c), "c"(n)
  8041604a22:	89 f0                	mov    %esi,%eax
  8041604a24:	48 89 d1             	mov    %rdx,%rcx
  8041604a27:	fc                   	cld    
  8041604a28:	f3 aa                	rep stos %al,%es:(%rdi)
                 : "cc", "memory");
  return v;
}
  8041604a2a:	48 89 f8             	mov    %rdi,%rax
  8041604a2d:	5d                   	pop    %rbp
  8041604a2e:	c3                   	retq   
    uint32_t k = c & 0xFFU;
  8041604a2f:	40 0f b6 f6          	movzbl %sil,%esi
    k          = (k << 24U) | (k << 16U) | (k << 8U) | k;
  8041604a33:	89 f0                	mov    %esi,%eax
  8041604a35:	c1 e0 08             	shl    $0x8,%eax
  8041604a38:	89 f1                	mov    %esi,%ecx
  8041604a3a:	c1 e1 18             	shl    $0x18,%ecx
  8041604a3d:	41 89 f0             	mov    %esi,%r8d
  8041604a40:	41 c1 e0 10          	shl    $0x10,%r8d
  8041604a44:	44 09 c1             	or     %r8d,%ecx
  8041604a47:	09 ce                	or     %ecx,%esi
  8041604a49:	09 f0                	or     %esi,%eax
    asm volatile("cld; rep stosl\n" ::"D"(v), "a"(k), "c"(n / 4)
  8041604a4b:	48 c1 ea 02          	shr    $0x2,%rdx
  8041604a4f:	48 89 d1             	mov    %rdx,%rcx
  8041604a52:	fc                   	cld    
  8041604a53:	f3 ab                	rep stos %eax,%es:(%rdi)
  if ((int64_t)v % 4 == 0 && n % 4 == 0) {
  8041604a55:	eb d3                	jmp    8041604a2a <memset+0x1c>

0000008041604a57 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8041604a57:	55                   	push   %rbp
  8041604a58:	48 89 e5             	mov    %rsp,%rbp
  8041604a5b:	48 89 f8             	mov    %rdi,%rax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
  8041604a5e:	48 39 fe             	cmp    %rdi,%rsi
  8041604a61:	73 43                	jae    8041604aa6 <memmove+0x4f>
  8041604a63:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  8041604a67:	48 39 f9             	cmp    %rdi,%rcx
  8041604a6a:	76 3a                	jbe    8041604aa6 <memmove+0x4f>
    s += n;
    d += n;
  8041604a6c:	48 8d 3c 17          	lea    (%rdi,%rdx,1),%rdi
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  8041604a70:	48 89 ce             	mov    %rcx,%rsi
  8041604a73:	48 09 fe             	or     %rdi,%rsi
  8041604a76:	40 f6 c6 03          	test   $0x3,%sil
  8041604a7a:	74 11                	je     8041604a8d <memmove+0x36>
      asm volatile("std; rep movsl\n" ::"D"(d - 4), "S"(s - 4), "c"(n / 4)
                   : "cc", "memory");
    else
      asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8041604a7c:	48 83 ef 01          	sub    $0x1,%rdi
  8041604a80:	48 8d 71 ff          	lea    -0x1(%rcx),%rsi
  8041604a84:	48 89 d1             	mov    %rdx,%rcx
  8041604a87:	fd                   	std    
  8041604a88:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                   : "cc", "memory");
    // Some versions of GCC rely on DF being clear
    asm volatile("cld" ::
  8041604a8a:	fc                   	cld    
  8041604a8b:	eb 2d                	jmp    8041604aba <memmove+0x63>
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  8041604a8d:	f6 c2 03             	test   $0x3,%dl
  8041604a90:	75 ea                	jne    8041604a7c <memmove+0x25>
      asm volatile("std; rep movsl\n" ::"D"(d - 4), "S"(s - 4), "c"(n / 4)
  8041604a92:	48 83 ef 04          	sub    $0x4,%rdi
  8041604a96:	48 8d 71 fc          	lea    -0x4(%rcx),%rsi
  8041604a9a:	48 c1 ea 02          	shr    $0x2,%rdx
  8041604a9e:	48 89 d1             	mov    %rdx,%rcx
  8041604aa1:	fd                   	std    
  8041604aa2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8041604aa4:	eb e4                	jmp    8041604a8a <memmove+0x33>
                     : "cc");
  } else {
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  8041604aa6:	48 89 f1             	mov    %rsi,%rcx
  8041604aa9:	48 09 c1             	or     %rax,%rcx
  8041604aac:	f6 c1 03             	test   $0x3,%cl
  8041604aaf:	74 0b                	je     8041604abc <memmove+0x65>
      asm volatile("cld; rep movsl\n" ::"D"(d), "S"(s), "c"(n / 4)
                   : "cc", "memory");
    else
      asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8041604ab1:	48 89 c7             	mov    %rax,%rdi
  8041604ab4:	48 89 d1             	mov    %rdx,%rcx
  8041604ab7:	fc                   	cld    
  8041604ab8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                   : "cc", "memory");
  }
  return dst;
}
  8041604aba:	5d                   	pop    %rbp
  8041604abb:	c3                   	retq   
    if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
  8041604abc:	f6 c2 03             	test   $0x3,%dl
  8041604abf:	75 f0                	jne    8041604ab1 <memmove+0x5a>
      asm volatile("cld; rep movsl\n" ::"D"(d), "S"(s), "c"(n / 4)
  8041604ac1:	48 c1 ea 02          	shr    $0x2,%rdx
  8041604ac5:	48 89 d1             	mov    %rdx,%rcx
  8041604ac8:	48 89 c7             	mov    %rax,%rdi
  8041604acb:	fc                   	cld    
  8041604acc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8041604ace:	eb ea                	jmp    8041604aba <memmove+0x63>

0000008041604ad0 <memcpy>:
  return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8041604ad0:	55                   	push   %rbp
  8041604ad1:	48 89 e5             	mov    %rsp,%rbp
  return memmove(dst, src, n);
  8041604ad4:	48 b8 57 4a 60 41 80 	movabs $0x8041604a57,%rax
  8041604adb:	00 00 00 
  8041604ade:	ff d0                	callq  *%rax
}
  8041604ae0:	5d                   	pop    %rbp
  8041604ae1:	c3                   	retq   

0000008041604ae2 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8041604ae2:	55                   	push   %rbp
  8041604ae3:	48 89 e5             	mov    %rsp,%rbp
  8041604ae6:	41 57                	push   %r15
  8041604ae8:	41 56                	push   %r14
  8041604aea:	41 55                	push   %r13
  8041604aec:	41 54                	push   %r12
  8041604aee:	53                   	push   %rbx
  8041604aef:	49 89 fe             	mov    %rdi,%r14
  8041604af2:	49 89 f7             	mov    %rsi,%r15
  8041604af5:	49 89 d5             	mov    %rdx,%r13
  const size_t srclen = strlen(src);
  8041604af8:	48 89 f7             	mov    %rsi,%rdi
  8041604afb:	48 b8 1a 48 60 41 80 	movabs $0x804160481a,%rax
  8041604b02:	00 00 00 
  8041604b05:	ff d0                	callq  *%rax
  8041604b07:	48 63 d8             	movslq %eax,%rbx
  const size_t dstlen = strnlen(dst, maxlen);
  8041604b0a:	4c 89 ee             	mov    %r13,%rsi
  8041604b0d:	4c 89 f7             	mov    %r14,%rdi
  8041604b10:	48 b8 3d 48 60 41 80 	movabs $0x804160483d,%rax
  8041604b17:	00 00 00 
  8041604b1a:	ff d0                	callq  *%rax
  8041604b1c:	4c 63 e0             	movslq %eax,%r12
    return maxlen + srclen;
  8041604b1f:	4a 8d 04 2b          	lea    (%rbx,%r13,1),%rax
  if (dstlen == maxlen)
  8041604b23:	4d 39 e5             	cmp    %r12,%r13
  8041604b26:	74 26                	je     8041604b4e <strlcat+0x6c>
  if (srclen < maxlen - dstlen) {
  8041604b28:	4c 89 e8             	mov    %r13,%rax
  8041604b2b:	4c 29 e0             	sub    %r12,%rax
  8041604b2e:	48 39 d8             	cmp    %rbx,%rax
  8041604b31:	76 26                	jbe    8041604b59 <strlcat+0x77>
    memcpy(dst + dstlen, src, srclen + 1);
  8041604b33:	48 8d 53 01          	lea    0x1(%rbx),%rdx
  8041604b37:	4b 8d 3c 26          	lea    (%r14,%r12,1),%rdi
  8041604b3b:	4c 89 fe             	mov    %r15,%rsi
  8041604b3e:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041604b45:	00 00 00 
  8041604b48:	ff d0                	callq  *%rax
  return dstlen + srclen;
  8041604b4a:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
}
  8041604b4e:	5b                   	pop    %rbx
  8041604b4f:	41 5c                	pop    %r12
  8041604b51:	41 5d                	pop    %r13
  8041604b53:	41 5e                	pop    %r14
  8041604b55:	41 5f                	pop    %r15
  8041604b57:	5d                   	pop    %rbp
  8041604b58:	c3                   	retq   
    memcpy(dst + dstlen, src, maxlen - 1);
  8041604b59:	49 83 ed 01          	sub    $0x1,%r13
  8041604b5d:	4b 8d 3c 26          	lea    (%r14,%r12,1),%rdi
  8041604b61:	4c 89 ea             	mov    %r13,%rdx
  8041604b64:	4c 89 fe             	mov    %r15,%rsi
  8041604b67:	48 b8 d0 4a 60 41 80 	movabs $0x8041604ad0,%rax
  8041604b6e:	00 00 00 
  8041604b71:	ff d0                	callq  *%rax
    dst[dstlen + maxlen - 1] = '\0';
  8041604b73:	4d 01 ee             	add    %r13,%r14
  8041604b76:	43 c6 04 26 00       	movb   $0x0,(%r14,%r12,1)
  8041604b7b:	eb cd                	jmp    8041604b4a <strlcat+0x68>

0000008041604b7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8041604b7d:	55                   	push   %rbp
  8041604b7e:	48 89 e5             	mov    %rsp,%rbp
  const uint8_t *s1 = (const uint8_t *)v1;
  const uint8_t *s2 = (const uint8_t *)v2;

  while (n-- > 0) {
  8041604b81:	48 85 d2             	test   %rdx,%rdx
  8041604b84:	74 3c                	je     8041604bc2 <memcmp+0x45>
    if (*s1 != *s2)
  8041604b86:	0f b6 0f             	movzbl (%rdi),%ecx
  8041604b89:	44 0f b6 06          	movzbl (%rsi),%r8d
  8041604b8d:	44 38 c1             	cmp    %r8b,%cl
  8041604b90:	75 1d                	jne    8041604baf <memcmp+0x32>
  8041604b92:	b8 01 00 00 00       	mov    $0x1,%eax
  while (n-- > 0) {
  8041604b97:	48 39 d0             	cmp    %rdx,%rax
  8041604b9a:	74 1f                	je     8041604bbb <memcmp+0x3e>
    if (*s1 != *s2)
  8041604b9c:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8041604ba0:	48 83 c0 01          	add    $0x1,%rax
  8041604ba4:	44 0f b6 44 06 ff    	movzbl -0x1(%rsi,%rax,1),%r8d
  8041604baa:	44 38 c1             	cmp    %r8b,%cl
  8041604bad:	74 e8                	je     8041604b97 <memcmp+0x1a>
      return (int)*s1 - (int)*s2;
  8041604baf:	0f b6 c1             	movzbl %cl,%eax
  8041604bb2:	45 0f b6 c0          	movzbl %r8b,%r8d
  8041604bb6:	44 29 c0             	sub    %r8d,%eax
    s1++, s2++;
  }

  return 0;
}
  8041604bb9:	5d                   	pop    %rbp
  8041604bba:	c3                   	retq   
  return 0;
  8041604bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604bc0:	eb f7                	jmp    8041604bb9 <memcmp+0x3c>
  8041604bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  8041604bc7:	eb f0                	jmp    8041604bb9 <memcmp+0x3c>

0000008041604bc9 <memfind>:

void *
memfind(const void *s, int c, size_t n) {
  8041604bc9:	55                   	push   %rbp
  8041604bca:	48 89 e5             	mov    %rsp,%rbp
  8041604bcd:	48 89 f8             	mov    %rdi,%rax
  const void *ends = (const char *)s + n;
  8041604bd0:	48 01 fa             	add    %rdi,%rdx
  for (; s < ends; s++)
  8041604bd3:	48 39 d7             	cmp    %rdx,%rdi
  8041604bd6:	73 14                	jae    8041604bec <memfind+0x23>
    if (*(const unsigned char *)s == (unsigned char)c)
  8041604bd8:	89 f1                	mov    %esi,%ecx
  8041604bda:	40 38 37             	cmp    %sil,(%rdi)
  8041604bdd:	74 0d                	je     8041604bec <memfind+0x23>
  for (; s < ends; s++)
  8041604bdf:	48 83 c0 01          	add    $0x1,%rax
  8041604be3:	48 39 c2             	cmp    %rax,%rdx
  8041604be6:	74 04                	je     8041604bec <memfind+0x23>
    if (*(const unsigned char *)s == (unsigned char)c)
  8041604be8:	38 08                	cmp    %cl,(%rax)
  8041604bea:	75 f3                	jne    8041604bdf <memfind+0x16>
      break;
  return (void *)s;
}
  8041604bec:	5d                   	pop    %rbp
  8041604bed:	c3                   	retq   

0000008041604bee <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8041604bee:	55                   	push   %rbp
  8041604bef:	48 89 e5             	mov    %rsp,%rbp
  int neg  = 0;
  long val = 0;

  // gobble initial whitespace
  while (*s == ' ' || *s == '\t')
  8041604bf2:	0f b6 07             	movzbl (%rdi),%eax
  8041604bf5:	3c 20                	cmp    $0x20,%al
  8041604bf7:	74 04                	je     8041604bfd <strtol+0xf>
  8041604bf9:	3c 09                	cmp    $0x9,%al
  8041604bfb:	75 0f                	jne    8041604c0c <strtol+0x1e>
    s++;
  8041604bfd:	48 83 c7 01          	add    $0x1,%rdi
  while (*s == ' ' || *s == '\t')
  8041604c01:	0f b6 07             	movzbl (%rdi),%eax
  8041604c04:	3c 20                	cmp    $0x20,%al
  8041604c06:	74 f5                	je     8041604bfd <strtol+0xf>
  8041604c08:	3c 09                	cmp    $0x9,%al
  8041604c0a:	74 f1                	je     8041604bfd <strtol+0xf>

  // plus/minus sign
  if (*s == '+')
  8041604c0c:	3c 2b                	cmp    $0x2b,%al
  8041604c0e:	74 2f                	je     8041604c3f <strtol+0x51>
  int neg  = 0;
  8041604c10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
    s++;
  else if (*s == '-')
  8041604c16:	3c 2d                	cmp    $0x2d,%al
  8041604c18:	74 31                	je     8041604c4b <strtol+0x5d>
    s++, neg = 1;

  // hex or octal base prefix
  if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8041604c1a:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8041604c20:	75 05                	jne    8041604c27 <strtol+0x39>
  8041604c22:	80 3f 30             	cmpb   $0x30,(%rdi)
  8041604c25:	74 30                	je     8041604c57 <strtol+0x69>
    s += 2, base = 16;
  else if (base == 0 && s[0] == '0')
  8041604c27:	85 d2                	test   %edx,%edx
  8041604c29:	75 0a                	jne    8041604c35 <strtol+0x47>
    s++, base = 8;
  else if (base == 0)
    base = 10;
  8041604c2b:	ba 0a 00 00 00       	mov    $0xa,%edx
  else if (base == 0 && s[0] == '0')
  8041604c30:	80 3f 30             	cmpb   $0x30,(%rdi)
  8041604c33:	74 2c                	je     8041604c61 <strtol+0x73>
    base = 10;
  8041604c35:	b8 00 00 00 00       	mov    $0x0,%eax
      dig = *s - 'A' + 10;
    else
      break;
    if (dig >= base)
      break;
    s++, val = (val * base) + dig;
  8041604c3a:	4c 63 d2             	movslq %edx,%r10
  8041604c3d:	eb 5c                	jmp    8041604c9b <strtol+0xad>
    s++;
  8041604c3f:	48 83 c7 01          	add    $0x1,%rdi
  int neg  = 0;
  8041604c43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8041604c49:	eb cf                	jmp    8041604c1a <strtol+0x2c>
    s++, neg = 1;
  8041604c4b:	48 83 c7 01          	add    $0x1,%rdi
  8041604c4f:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8041604c55:	eb c3                	jmp    8041604c1a <strtol+0x2c>
  if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8041604c57:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8041604c5b:	74 0f                	je     8041604c6c <strtol+0x7e>
  else if (base == 0 && s[0] == '0')
  8041604c5d:	85 d2                	test   %edx,%edx
  8041604c5f:	75 d4                	jne    8041604c35 <strtol+0x47>
    s++, base = 8;
  8041604c61:	48 83 c7 01          	add    $0x1,%rdi
  8041604c65:	ba 08 00 00 00       	mov    $0x8,%edx
  8041604c6a:	eb c9                	jmp    8041604c35 <strtol+0x47>
    s += 2, base = 16;
  8041604c6c:	48 83 c7 02          	add    $0x2,%rdi
  8041604c70:	ba 10 00 00 00       	mov    $0x10,%edx
  8041604c75:	eb be                	jmp    8041604c35 <strtol+0x47>
    else if (*s >= 'a' && *s <= 'z')
  8041604c77:	44 8d 41 9f          	lea    -0x61(%rcx),%r8d
  8041604c7b:	41 80 f8 19          	cmp    $0x19,%r8b
  8041604c7f:	77 2f                	ja     8041604cb0 <strtol+0xc2>
      dig = *s - 'a' + 10;
  8041604c81:	44 0f be c1          	movsbl %cl,%r8d
  8041604c85:	41 8d 48 a9          	lea    -0x57(%r8),%ecx
    if (dig >= base)
  8041604c89:	39 d1                	cmp    %edx,%ecx
  8041604c8b:	7d 37                	jge    8041604cc4 <strtol+0xd6>
    s++, val = (val * base) + dig;
  8041604c8d:	48 83 c7 01          	add    $0x1,%rdi
  8041604c91:	49 0f af c2          	imul   %r10,%rax
  8041604c95:	48 63 c9             	movslq %ecx,%rcx
  8041604c98:	48 01 c8             	add    %rcx,%rax
    if (*s >= '0' && *s <= '9')
  8041604c9b:	0f b6 0f             	movzbl (%rdi),%ecx
  8041604c9e:	44 8d 41 d0          	lea    -0x30(%rcx),%r8d
  8041604ca2:	41 80 f8 09          	cmp    $0x9,%r8b
  8041604ca6:	77 cf                	ja     8041604c77 <strtol+0x89>
      dig = *s - '0';
  8041604ca8:	0f be c9             	movsbl %cl,%ecx
  8041604cab:	83 e9 30             	sub    $0x30,%ecx
  8041604cae:	eb d9                	jmp    8041604c89 <strtol+0x9b>
    else if (*s >= 'A' && *s <= 'Z')
  8041604cb0:	44 8d 41 bf          	lea    -0x41(%rcx),%r8d
  8041604cb4:	41 80 f8 19          	cmp    $0x19,%r8b
  8041604cb8:	77 0a                	ja     8041604cc4 <strtol+0xd6>
      dig = *s - 'A' + 10;
  8041604cba:	44 0f be c1          	movsbl %cl,%r8d
  8041604cbe:	41 8d 48 c9          	lea    -0x37(%r8),%ecx
  8041604cc2:	eb c5                	jmp    8041604c89 <strtol+0x9b>
    // we don't properly detect overflow!
  }

  if (endptr)
  8041604cc4:	48 85 f6             	test   %rsi,%rsi
  8041604cc7:	74 03                	je     8041604ccc <strtol+0xde>
    *endptr = (char *)s;
  8041604cc9:	48 89 3e             	mov    %rdi,(%rsi)
  return (neg ? -val : val);
  8041604ccc:	48 89 c2             	mov    %rax,%rdx
  8041604ccf:	48 f7 da             	neg    %rdx
  8041604cd2:	45 85 c9             	test   %r9d,%r9d
  8041604cd5:	48 0f 45 c2          	cmovne %rdx,%rax
}
  8041604cd9:	5d                   	pop    %rbp
  8041604cda:	c3                   	retq   
  8041604cdb:	90                   	nop

0000008041604cdc <_efi_call_in_32bit_mode_asm>:

.globl _efi_call_in_32bit_mode_asm
.type _efi_call_in_32bit_mode_asm, @function;
.align 2
_efi_call_in_32bit_mode_asm:
    pushq %rbp
  8041604cdc:	55                   	push   %rbp
    movq %rsp, %rbp
  8041604cdd:	48 89 e5             	mov    %rsp,%rbp
    /* save non-volatile registers */
	push	%rbx
  8041604ce0:	53                   	push   %rbx
	push	%r12
  8041604ce1:	41 54                	push   %r12
	push	%r13
  8041604ce3:	41 55                	push   %r13
	push	%r14
  8041604ce5:	41 56                	push   %r14
	push	%r15
  8041604ce7:	41 57                	push   %r15

	/* save parameters that we will need later */
	push	%rsi
  8041604ce9:	56                   	push   %rsi
	push	%rcx
  8041604cea:	51                   	push   %rcx

	push	%rbp	/* save %rbp and align to 16-byte boundary */
  8041604ceb:	55                   	push   %rbp
				/* efi_reg in %rsi */
				/* stack_contents into %rdx */
				/* s_c_s into %rcx */
	sub	%rcx, %rsp	/* make room for stack contents */
  8041604cec:	48 29 cc             	sub    %rcx,%rsp

	COPY_STACK(%rdx, %rcx, %r8)
  8041604cef:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8

0000008041604cf6 <copyloop>:
  8041604cf6:	4a 8b 04 02          	mov    (%rdx,%r8,1),%rax
  8041604cfa:	4a 89 04 04          	mov    %rax,(%rsp,%r8,1)
  8041604cfe:	49 83 c0 08          	add    $0x8,%r8
  8041604d02:	49 39 c8             	cmp    %rcx,%r8
  8041604d05:	75 ef                	jne    8041604cf6 <copyloop>
	/*
	 * Here in long-mode, with high kernel addresses,
	 * but with the kernel double-mapped in the bottom 4GB.
	 * We now switch to compat mode and call into EFI.
	 */
	ENTER_COMPAT_MODE()
  8041604d07:	e8 00 00 00 00       	callq  8041604d0c <copyloop+0x16>
  8041604d0c:	48 81 04 24 11 00 00 	addq   $0x11,(%rsp)
  8041604d13:	00 
  8041604d14:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%rsp)
  8041604d1b:	00 
  8041604d1c:	cb                   	lret   

	call	*%edi			/* call EFI runtime */
  8041604d1d:	ff d7                	callq  *%rdi

	ENTER_64BIT_MODE()
  8041604d1f:	6a 08                	pushq  $0x8
  8041604d21:	e8 00 00 00 00       	callq  8041604d26 <copyloop+0x30>
  8041604d26:	81 04 24 08 00 00 00 	addl   $0x8,(%rsp)
  8041604d2d:	cb                   	lret   

	mov	-48(%rbp), %rsi		/* load efi_reg into %esi */
  8041604d2e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
	mov	%rax, 32(%rsi)		/* save RAX back */
  8041604d32:	48 89 46 20          	mov    %rax,0x20(%rsi)

	mov	-56(%rbp), %rcx	/* load s_c_s into %rcx */
  8041604d36:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
	add	%rcx, %rsp	/* discard stack contents */
  8041604d3a:	48 01 cc             	add    %rcx,%rsp
	pop	%rbp		/* restore full 64-bit frame pointer */
  8041604d3d:	5d                   	pop    %rbp
				/* which the 32-bit EFI will have truncated */
				/* our full %rsp will be restored by EMARF */
	pop	%rcx
  8041604d3e:	59                   	pop    %rcx
	pop	%rsi
  8041604d3f:	5e                   	pop    %rsi
	pop	%r15
  8041604d40:	41 5f                	pop    %r15
	pop	%r14
  8041604d42:	41 5e                	pop    %r14
	pop	%r13
  8041604d44:	41 5d                	pop    %r13
	pop	%r12
  8041604d46:	41 5c                	pop    %r12
	pop	%rbx
  8041604d48:	5b                   	pop    %rbx

	leave
  8041604d49:	c9                   	leaveq 
	ret
  8041604d4a:	c3                   	retq   
  8041604d4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
