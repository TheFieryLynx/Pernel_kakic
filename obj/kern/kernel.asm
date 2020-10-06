
obj/kern/kernel:	file format ELF64-x86-64


Disassembly of section .bootstrap:

0000000001500000 _head64:
;   cli
 1500000: fa                           	cli
;   movq %rcx,%r12
 1500001: 49 89 cc                     	movq	%rcx, %r12
;   movl $pml4,%edi
 1500004: bf 00 10 50 01               	movl	$22024192, %edi
;   xorl %eax,%eax
 1500009: 31 c0                        	xorl	%eax, %eax
;   movl $PML_SIZE,%ecx  # moving these many words to the 11 pages
 150000b: b9 00 2c 00 00               	movl	$11264, %ecx
;   rep stosl
 1500010: f3 ab                        	rep		stosl	%eax, %es:(%rdi)
;   movl $pml4,%eax
 1500012: b8 00 10 50 01               	movl	$22024192, %eax
;   movl $pdpt1, %ebx
 1500017: bb 00 20 50 01               	movl	$22028288, %ebx
;   orl $PTE_P,%ebx
 150001c: 83 cb 01                     	orl	$1, %ebx
;   orl $PTE_W,%ebx
 150001f: 83 cb 02                     	orl	$2, %ebx
;   movl %ebx,(%eax)
 1500022: 67 89 18                     	movl	%ebx, (%eax)
;   movl $pdpt2, %ebx
 1500025: bb 00 30 50 01               	movl	$22032384, %ebx
;   orl $PTE_P,%ebx
 150002a: 83 cb 01                     	orl	$1, %ebx
;   orl $PTE_W,%ebx
 150002d: 83 cb 02                     	orl	$2, %ebx
;   movl %ebx,0x8(%eax)
 1500030: 67 89 58 08                  	movl	%ebx, 8(%eax)
;   movl $pdpt1,%edi
 1500034: bf 00 20 50 01               	movl	$22028288, %edi
;   movl $pde1,%ebx
 1500039: bb 00 40 50 01               	movl	$22036480, %ebx
;   orl $PTE_P,%ebx
 150003e: 83 cb 01                     	orl	$1, %ebx
;   orl $PTE_W,%ebx
 1500041: 83 cb 02                     	orl	$2, %ebx
;   movl %ebx,(%edi)
 1500044: 67 89 1f                     	movl	%ebx, (%edi)
;   movl $pdpt2,%edi
 1500047: bf 00 30 50 01               	movl	$22032384, %edi
;   movl $pde2,%ebx
 150004c: bb 00 50 50 01               	movl	$22040576, %ebx
;   orl $PTE_P,%ebx
 1500051: 83 cb 01                     	orl	$1, %ebx
;   orl $PTE_W,%ebx
 1500054: 83 cb 02                     	orl	$2, %ebx
;   movl %ebx,0x8(%edi)
 1500057: 67 89 5f 08                  	movl	%ebx, 8(%edi)
;   movl $512,%ecx
 150005b: b9 00 02 00 00               	movl	$512, %ecx
;   movl $pde1,%edi
 1500060: bf 00 40 50 01               	movl	$22036480, %edi
;   movl $pde2,%ebx
 1500065: bb 00 50 50 01               	movl	$22040576, %ebx
;   movl $0x00000183,%eax
 150006a: b8 83 01 00 00               	movl	$387, %eax
;   movl %eax,(%edi)
 150006f: 67 89 07                     	movl	%eax, (%edi)
;   movl %eax,(%ebx)
 1500072: 67 89 03                     	movl	%eax, (%ebx)
;   addl $0x8,%edi
 1500075: 83 c7 08                     	addl	$8, %edi
;   addl $0x8,%ebx
 1500078: 83 c3 08                     	addl	$8, %ebx
;   addl $0x00200000,%eax
 150007b: 05 00 00 20 00               	addl	$2097152, %eax
;   subl $1,%ecx
 1500080: 83 e9 01                     	subl	$1, %ecx
;   cmp $0x0,%ecx
 1500083: 83 f9 00                     	cmpl	$0, %ecx
;   jne 1b
 1500086: 75 e7                        	jne	-25 <_head64+0x6f>
;   movq $pml4,%rax
 1500088: 48 c7 c0 00 10 50 01         	movq	$22024192, %rax
;   movq %rax, %cr3
 150008f: 0f 22 d8                     	movq	%rax, %cr3
;   movabs $entry,%rax
 1500092: 48 b8 00 00 60 41 80 00 00 00	movabsq	$550852624384, %rax
;   movq %r12, %rcx
 150009c: 4c 89 e1                     	movq	%r12, %rcx
;   jmpq *%rax
 150009f: ff e0                        	jmpq	*%rax
 15000a1: cc                           	int3
 15000a2: cc                           	int3
 15000a3: cc                           	int3
 15000a4: cc                           	int3
 15000a5: cc                           	int3
 15000a6: cc                           	int3
 15000a7: cc                           	int3
 15000a8: cc                           	int3
 15000a9: cc                           	int3
 15000aa: cc                           	int3
 15000ab: cc                           	int3
 15000ac: cc                           	int3
 15000ad: cc                           	int3
 15000ae: cc                           	int3
 15000af: cc                           	int3
 15000b0: cc                           	int3
 15000b1: cc                           	int3
 15000b2: cc                           	int3
 15000b3: cc                           	int3
 15000b4: cc                           	int3
 15000b5: cc                           	int3
 15000b6: cc                           	int3
 15000b7: cc                           	int3
 15000b8: cc                           	int3
 15000b9: cc                           	int3
 15000ba: cc                           	int3
 15000bb: cc                           	int3
 15000bc: cc                           	int3
 15000bd: cc                           	int3
 15000be: cc                           	int3
 15000bf: cc                           	int3
 15000c0: cc                           	int3
 15000c1: cc                           	int3
 15000c2: cc                           	int3
 15000c3: cc                           	int3
 15000c4: cc                           	int3
 15000c5: cc                           	int3
 15000c6: cc                           	int3
 15000c7: cc                           	int3
 15000c8: cc                           	int3
 15000c9: cc                           	int3
 15000ca: cc                           	int3
 15000cb: cc                           	int3
 15000cc: cc                           	int3
 15000cd: cc                           	int3
 15000ce: cc                           	int3
 15000cf: cc                           	int3
 15000d0: cc                           	int3
 15000d1: cc                           	int3
 15000d2: cc                           	int3
 15000d3: cc                           	int3
 15000d4: cc                           	int3
 15000d5: cc                           	int3
 15000d6: cc                           	int3
 15000d7: cc                           	int3
 15000d8: cc                           	int3
 15000d9: cc                           	int3
 15000da: cc                           	int3
 15000db: cc                           	int3
 15000dc: cc                           	int3
 15000dd: cc                           	int3
 15000de: cc                           	int3
 15000df: cc                           	int3
 15000e0: cc                           	int3
 15000e1: cc                           	int3
 15000e2: cc                           	int3
 15000e3: cc                           	int3
 15000e4: cc                           	int3
 15000e5: cc                           	int3
 15000e6: cc                           	int3
 15000e7: cc                           	int3
 15000e8: cc                           	int3
 15000e9: cc                           	int3
 15000ea: cc                           	int3
 15000eb: cc                           	int3
 15000ec: cc                           	int3
 15000ed: cc                           	int3
 15000ee: cc                           	int3
 15000ef: cc                           	int3
 15000f0: cc                           	int3
 15000f1: cc                           	int3
 15000f2: cc                           	int3
 15000f3: cc                           	int3
 15000f4: cc                           	int3
 15000f5: cc                           	int3
 15000f6: cc                           	int3
 15000f7: cc                           	int3
 15000f8: cc                           	int3
 15000f9: cc                           	int3
 15000fa: cc                           	int3
 15000fb: cc                           	int3
 15000fc: cc                           	int3
 15000fd: cc                           	int3
 15000fe: cc                           	int3
 15000ff: cc                           	int3
 1500100: cc                           	int3
 1500101: cc                           	int3
 1500102: cc                           	int3
 1500103: cc                           	int3
 1500104: cc                           	int3
 1500105: cc                           	int3
 1500106: cc                           	int3
 1500107: cc                           	int3
 1500108: cc                           	int3
 1500109: cc                           	int3
 150010a: cc                           	int3
 150010b: cc                           	int3
 150010c: cc                           	int3
 150010d: cc                           	int3
 150010e: cc                           	int3
 150010f: cc                           	int3
 1500110: cc                           	int3
 1500111: cc                           	int3
 1500112: cc                           	int3
 1500113: cc                           	int3
 1500114: cc                           	int3
 1500115: cc                           	int3
 1500116: cc                           	int3
 1500117: cc                           	int3
 1500118: cc                           	int3
 1500119: cc                           	int3
 150011a: cc                           	int3
 150011b: cc                           	int3
 150011c: cc                           	int3
 150011d: cc                           	int3
 150011e: cc                           	int3
 150011f: cc                           	int3
 1500120: cc                           	int3
 1500121: cc                           	int3
 1500122: cc                           	int3
 1500123: cc                           	int3
 1500124: cc                           	int3
 1500125: cc                           	int3
 1500126: cc                           	int3
 1500127: cc                           	int3
 1500128: cc                           	int3
 1500129: cc                           	int3
 150012a: cc                           	int3
 150012b: cc                           	int3
 150012c: cc                           	int3
 150012d: cc                           	int3
 150012e: cc                           	int3
 150012f: cc                           	int3
 1500130: cc                           	int3
 1500131: cc                           	int3
 1500132: cc                           	int3
 1500133: cc                           	int3
 1500134: cc                           	int3
 1500135: cc                           	int3
 1500136: cc                           	int3
 1500137: cc                           	int3
 1500138: cc                           	int3
 1500139: cc                           	int3
 150013a: cc                           	int3
 150013b: cc                           	int3
 150013c: cc                           	int3
 150013d: cc                           	int3
 150013e: cc                           	int3
 150013f: cc                           	int3
 1500140: cc                           	int3
 1500141: cc                           	int3
 1500142: cc                           	int3
 1500143: cc                           	int3
 1500144: cc                           	int3
 1500145: cc                           	int3
 1500146: cc                           	int3
 1500147: cc                           	int3
 1500148: cc                           	int3
 1500149: cc                           	int3
 150014a: cc                           	int3
 150014b: cc                           	int3
 150014c: cc                           	int3
 150014d: cc                           	int3
 150014e: cc                           	int3
 150014f: cc                           	int3
 1500150: cc                           	int3
 1500151: cc                           	int3
 1500152: cc                           	int3
 1500153: cc                           	int3
 1500154: cc                           	int3
 1500155: cc                           	int3
 1500156: cc                           	int3
 1500157: cc                           	int3
 1500158: cc                           	int3
 1500159: cc                           	int3
 150015a: cc                           	int3
 150015b: cc                           	int3
 150015c: cc                           	int3
 150015d: cc                           	int3
 150015e: cc                           	int3
 150015f: cc                           	int3
 1500160: cc                           	int3
 1500161: cc                           	int3
 1500162: cc                           	int3
 1500163: cc                           	int3
 1500164: cc                           	int3
 1500165: cc                           	int3
 1500166: cc                           	int3
 1500167: cc                           	int3
 1500168: cc                           	int3
 1500169: cc                           	int3
 150016a: cc                           	int3
 150016b: cc                           	int3
 150016c: cc                           	int3
 150016d: cc                           	int3
 150016e: cc                           	int3
 150016f: cc                           	int3
 1500170: cc                           	int3
 1500171: cc                           	int3
 1500172: cc                           	int3
 1500173: cc                           	int3
 1500174: cc                           	int3
 1500175: cc                           	int3
 1500176: cc                           	int3
 1500177: cc                           	int3
 1500178: cc                           	int3
 1500179: cc                           	int3
 150017a: cc                           	int3
 150017b: cc                           	int3
 150017c: cc                           	int3
 150017d: cc                           	int3
 150017e: cc                           	int3
 150017f: cc                           	int3
 1500180: cc                           	int3
 1500181: cc                           	int3
 1500182: cc                           	int3
 1500183: cc                           	int3
 1500184: cc                           	int3
 1500185: cc                           	int3
 1500186: cc                           	int3
 1500187: cc                           	int3
 1500188: cc                           	int3
 1500189: cc                           	int3
 150018a: cc                           	int3
 150018b: cc                           	int3
 150018c: cc                           	int3
 150018d: cc                           	int3
 150018e: cc                           	int3
 150018f: cc                           	int3
 1500190: cc                           	int3
 1500191: cc                           	int3
 1500192: cc                           	int3
 1500193: cc                           	int3
 1500194: cc                           	int3
 1500195: cc                           	int3
 1500196: cc                           	int3
 1500197: cc                           	int3
 1500198: cc                           	int3
 1500199: cc                           	int3
 150019a: cc                           	int3
 150019b: cc                           	int3
 150019c: cc                           	int3
 150019d: cc                           	int3
 150019e: cc                           	int3
 150019f: cc                           	int3
 15001a0: cc                           	int3
 15001a1: cc                           	int3
 15001a2: cc                           	int3
 15001a3: cc                           	int3
 15001a4: cc                           	int3
 15001a5: cc                           	int3
 15001a6: cc                           	int3
 15001a7: cc                           	int3
 15001a8: cc                           	int3
 15001a9: cc                           	int3
 15001aa: cc                           	int3
 15001ab: cc                           	int3
 15001ac: cc                           	int3
 15001ad: cc                           	int3
 15001ae: cc                           	int3
 15001af: cc                           	int3
 15001b0: cc                           	int3
 15001b1: cc                           	int3
 15001b2: cc                           	int3
 15001b3: cc                           	int3
 15001b4: cc                           	int3
 15001b5: cc                           	int3
 15001b6: cc                           	int3
 15001b7: cc                           	int3
 15001b8: cc                           	int3
 15001b9: cc                           	int3
 15001ba: cc                           	int3
 15001bb: cc                           	int3
 15001bc: cc                           	int3
 15001bd: cc                           	int3
 15001be: cc                           	int3
 15001bf: cc                           	int3
 15001c0: cc                           	int3
 15001c1: cc                           	int3
 15001c2: cc                           	int3
 15001c3: cc                           	int3
 15001c4: cc                           	int3
 15001c5: cc                           	int3
 15001c6: cc                           	int3
 15001c7: cc                           	int3
 15001c8: cc                           	int3
 15001c9: cc                           	int3
 15001ca: cc                           	int3
 15001cb: cc                           	int3
 15001cc: cc                           	int3
 15001cd: cc                           	int3
 15001ce: cc                           	int3
 15001cf: cc                           	int3
 15001d0: cc                           	int3
 15001d1: cc                           	int3
 15001d2: cc                           	int3
 15001d3: cc                           	int3
 15001d4: cc                           	int3
 15001d5: cc                           	int3
 15001d6: cc                           	int3
 15001d7: cc                           	int3
 15001d8: cc                           	int3
 15001d9: cc                           	int3
 15001da: cc                           	int3
 15001db: cc                           	int3
 15001dc: cc                           	int3
 15001dd: cc                           	int3
 15001de: cc                           	int3
 15001df: cc                           	int3
 15001e0: cc                           	int3
 15001e1: cc                           	int3
 15001e2: cc                           	int3
 15001e3: cc                           	int3
 15001e4: cc                           	int3
 15001e5: cc                           	int3
 15001e6: cc                           	int3
 15001e7: cc                           	int3
 15001e8: cc                           	int3
 15001e9: cc                           	int3
 15001ea: cc                           	int3
 15001eb: cc                           	int3
 15001ec: cc                           	int3
 15001ed: cc                           	int3
 15001ee: cc                           	int3
 15001ef: cc                           	int3
 15001f0: cc                           	int3
 15001f1: cc                           	int3
 15001f2: cc                           	int3
 15001f3: cc                           	int3
 15001f4: cc                           	int3
 15001f5: cc                           	int3
 15001f6: cc                           	int3
 15001f7: cc                           	int3
 15001f8: cc                           	int3
 15001f9: cc                           	int3
 15001fa: cc                           	int3
 15001fb: cc                           	int3
 15001fc: cc                           	int3
 15001fd: cc                           	int3
 15001fe: cc                           	int3
 15001ff: cc                           	int3
 1500200: cc                           	int3
 1500201: cc                           	int3
 1500202: cc                           	int3
 1500203: cc                           	int3
 1500204: cc                           	int3
 1500205: cc                           	int3
 1500206: cc                           	int3
 1500207: cc                           	int3
 1500208: cc                           	int3
 1500209: cc                           	int3
 150020a: cc                           	int3
 150020b: cc                           	int3
 150020c: cc                           	int3
 150020d: cc                           	int3
 150020e: cc                           	int3
 150020f: cc                           	int3
 1500210: cc                           	int3
 1500211: cc                           	int3
 1500212: cc                           	int3
 1500213: cc                           	int3
 1500214: cc                           	int3
 1500215: cc                           	int3
 1500216: cc                           	int3
 1500217: cc                           	int3
 1500218: cc                           	int3
 1500219: cc                           	int3
 150021a: cc                           	int3
 150021b: cc                           	int3
 150021c: cc                           	int3
 150021d: cc                           	int3
 150021e: cc                           	int3
 150021f: cc                           	int3
 1500220: cc                           	int3
 1500221: cc                           	int3
 1500222: cc                           	int3
 1500223: cc                           	int3
 1500224: cc                           	int3
 1500225: cc                           	int3
 1500226: cc                           	int3
 1500227: cc                           	int3
 1500228: cc                           	int3
 1500229: cc                           	int3
 150022a: cc                           	int3
 150022b: cc                           	int3
 150022c: cc                           	int3
 150022d: cc                           	int3
 150022e: cc                           	int3
 150022f: cc                           	int3
 1500230: cc                           	int3
 1500231: cc                           	int3
 1500232: cc                           	int3
 1500233: cc                           	int3
 1500234: cc                           	int3
 1500235: cc                           	int3
 1500236: cc                           	int3
 1500237: cc                           	int3
 1500238: cc                           	int3
 1500239: cc                           	int3
 150023a: cc                           	int3
 150023b: cc                           	int3
 150023c: cc                           	int3
 150023d: cc                           	int3
 150023e: cc                           	int3
 150023f: cc                           	int3
 1500240: cc                           	int3
 1500241: cc                           	int3
 1500242: cc                           	int3
 1500243: cc                           	int3
 1500244: cc                           	int3
 1500245: cc                           	int3
 1500246: cc                           	int3
 1500247: cc                           	int3
 1500248: cc                           	int3
 1500249: cc                           	int3
 150024a: cc                           	int3
 150024b: cc                           	int3
 150024c: cc                           	int3
 150024d: cc                           	int3
 150024e: cc                           	int3
 150024f: cc                           	int3
 1500250: cc                           	int3
 1500251: cc                           	int3
 1500252: cc                           	int3
 1500253: cc                           	int3
 1500254: cc                           	int3
 1500255: cc                           	int3
 1500256: cc                           	int3
 1500257: cc                           	int3
 1500258: cc                           	int3
 1500259: cc                           	int3
 150025a: cc                           	int3
 150025b: cc                           	int3
 150025c: cc                           	int3
 150025d: cc                           	int3
 150025e: cc                           	int3
 150025f: cc                           	int3
 1500260: cc                           	int3
 1500261: cc                           	int3
 1500262: cc                           	int3
 1500263: cc                           	int3
 1500264: cc                           	int3
 1500265: cc                           	int3
 1500266: cc                           	int3
 1500267: cc                           	int3
 1500268: cc                           	int3
 1500269: cc                           	int3
 150026a: cc                           	int3
 150026b: cc                           	int3
 150026c: cc                           	int3
 150026d: cc                           	int3
 150026e: cc                           	int3
 150026f: cc                           	int3
 1500270: cc                           	int3
 1500271: cc                           	int3
 1500272: cc                           	int3
 1500273: cc                           	int3
 1500274: cc                           	int3
 1500275: cc                           	int3
 1500276: cc                           	int3
 1500277: cc                           	int3
 1500278: cc                           	int3
 1500279: cc                           	int3
 150027a: cc                           	int3
 150027b: cc                           	int3
 150027c: cc                           	int3
 150027d: cc                           	int3
 150027e: cc                           	int3
 150027f: cc                           	int3
 1500280: cc                           	int3
 1500281: cc                           	int3
 1500282: cc                           	int3
 1500283: cc                           	int3
 1500284: cc                           	int3
 1500285: cc                           	int3
 1500286: cc                           	int3
 1500287: cc                           	int3
 1500288: cc                           	int3
 1500289: cc                           	int3
 150028a: cc                           	int3
 150028b: cc                           	int3
 150028c: cc                           	int3
 150028d: cc                           	int3
 150028e: cc                           	int3
 150028f: cc                           	int3
 1500290: cc                           	int3
 1500291: cc                           	int3
 1500292: cc                           	int3
 1500293: cc                           	int3
 1500294: cc                           	int3
 1500295: cc                           	int3
 1500296: cc                           	int3
 1500297: cc                           	int3
 1500298: cc                           	int3
 1500299: cc                           	int3
 150029a: cc                           	int3
 150029b: cc                           	int3
 150029c: cc                           	int3
 150029d: cc                           	int3
 150029e: cc                           	int3
 150029f: cc                           	int3
 15002a0: cc                           	int3
 15002a1: cc                           	int3
 15002a2: cc                           	int3
 15002a3: cc                           	int3
 15002a4: cc                           	int3
 15002a5: cc                           	int3
 15002a6: cc                           	int3
 15002a7: cc                           	int3
 15002a8: cc                           	int3
 15002a9: cc                           	int3
 15002aa: cc                           	int3
 15002ab: cc                           	int3
 15002ac: cc                           	int3
 15002ad: cc                           	int3
 15002ae: cc                           	int3
 15002af: cc                           	int3
 15002b0: cc                           	int3
 15002b1: cc                           	int3
 15002b2: cc                           	int3
 15002b3: cc                           	int3
 15002b4: cc                           	int3
 15002b5: cc                           	int3
 15002b6: cc                           	int3
 15002b7: cc                           	int3
 15002b8: cc                           	int3
 15002b9: cc                           	int3
 15002ba: cc                           	int3
 15002bb: cc                           	int3
 15002bc: cc                           	int3
 15002bd: cc                           	int3
 15002be: cc                           	int3
 15002bf: cc                           	int3
 15002c0: cc                           	int3
 15002c1: cc                           	int3
 15002c2: cc                           	int3
 15002c3: cc                           	int3
 15002c4: cc                           	int3
 15002c5: cc                           	int3
 15002c6: cc                           	int3
 15002c7: cc                           	int3
 15002c8: cc                           	int3
 15002c9: cc                           	int3
 15002ca: cc                           	int3
 15002cb: cc                           	int3
 15002cc: cc                           	int3
 15002cd: cc                           	int3
 15002ce: cc                           	int3
 15002cf: cc                           	int3
 15002d0: cc                           	int3
 15002d1: cc                           	int3
 15002d2: cc                           	int3
 15002d3: cc                           	int3
 15002d4: cc                           	int3
 15002d5: cc                           	int3
 15002d6: cc                           	int3
 15002d7: cc                           	int3
 15002d8: cc                           	int3
 15002d9: cc                           	int3
 15002da: cc                           	int3
 15002db: cc                           	int3
 15002dc: cc                           	int3
 15002dd: cc                           	int3
 15002de: cc                           	int3
 15002df: cc                           	int3
 15002e0: cc                           	int3
 15002e1: cc                           	int3
 15002e2: cc                           	int3
 15002e3: cc                           	int3
 15002e4: cc                           	int3
 15002e5: cc                           	int3
 15002e6: cc                           	int3
 15002e7: cc                           	int3
 15002e8: cc                           	int3
 15002e9: cc                           	int3
 15002ea: cc                           	int3
 15002eb: cc                           	int3
 15002ec: cc                           	int3
 15002ed: cc                           	int3
 15002ee: cc                           	int3
 15002ef: cc                           	int3
 15002f0: cc                           	int3
 15002f1: cc                           	int3
 15002f2: cc                           	int3
 15002f3: cc                           	int3
 15002f4: cc                           	int3
 15002f5: cc                           	int3
 15002f6: cc                           	int3
 15002f7: cc                           	int3
 15002f8: cc                           	int3
 15002f9: cc                           	int3
 15002fa: cc                           	int3
 15002fb: cc                           	int3
 15002fc: cc                           	int3
 15002fd: cc                           	int3
 15002fe: cc                           	int3
 15002ff: cc                           	int3
 1500300: cc                           	int3
 1500301: cc                           	int3
 1500302: cc                           	int3
 1500303: cc                           	int3
 1500304: cc                           	int3
 1500305: cc                           	int3
 1500306: cc                           	int3
 1500307: cc                           	int3
 1500308: cc                           	int3
 1500309: cc                           	int3
 150030a: cc                           	int3
 150030b: cc                           	int3
 150030c: cc                           	int3
 150030d: cc                           	int3
 150030e: cc                           	int3
 150030f: cc                           	int3
 1500310: cc                           	int3
 1500311: cc                           	int3
 1500312: cc                           	int3
 1500313: cc                           	int3
 1500314: cc                           	int3
 1500315: cc                           	int3
 1500316: cc                           	int3
 1500317: cc                           	int3
 1500318: cc                           	int3
 1500319: cc                           	int3
 150031a: cc                           	int3
 150031b: cc                           	int3
 150031c: cc                           	int3
 150031d: cc                           	int3
 150031e: cc                           	int3
 150031f: cc                           	int3
 1500320: cc                           	int3
 1500321: cc                           	int3
 1500322: cc                           	int3
 1500323: cc                           	int3
 1500324: cc                           	int3
 1500325: cc                           	int3
 1500326: cc                           	int3
 1500327: cc                           	int3
 1500328: cc                           	int3
 1500329: cc                           	int3
 150032a: cc                           	int3
 150032b: cc                           	int3
 150032c: cc                           	int3
 150032d: cc                           	int3
 150032e: cc                           	int3
 150032f: cc                           	int3
 1500330: cc                           	int3
 1500331: cc                           	int3
 1500332: cc                           	int3
 1500333: cc                           	int3
 1500334: cc                           	int3
 1500335: cc                           	int3
 1500336: cc                           	int3
 1500337: cc                           	int3
 1500338: cc                           	int3
 1500339: cc                           	int3
 150033a: cc                           	int3
 150033b: cc                           	int3
 150033c: cc                           	int3
 150033d: cc                           	int3
 150033e: cc                           	int3
 150033f: cc                           	int3
 1500340: cc                           	int3
 1500341: cc                           	int3
 1500342: cc                           	int3
 1500343: cc                           	int3
 1500344: cc                           	int3
 1500345: cc                           	int3
 1500346: cc                           	int3
 1500347: cc                           	int3
 1500348: cc                           	int3
 1500349: cc                           	int3
 150034a: cc                           	int3
 150034b: cc                           	int3
 150034c: cc                           	int3
 150034d: cc                           	int3
 150034e: cc                           	int3
 150034f: cc                           	int3
 1500350: cc                           	int3
 1500351: cc                           	int3
 1500352: cc                           	int3
 1500353: cc                           	int3
 1500354: cc                           	int3
 1500355: cc                           	int3
 1500356: cc                           	int3
 1500357: cc                           	int3
 1500358: cc                           	int3
 1500359: cc                           	int3
 150035a: cc                           	int3
 150035b: cc                           	int3
 150035c: cc                           	int3
 150035d: cc                           	int3
 150035e: cc                           	int3
 150035f: cc                           	int3
 1500360: cc                           	int3
 1500361: cc                           	int3
 1500362: cc                           	int3
 1500363: cc                           	int3
 1500364: cc                           	int3
 1500365: cc                           	int3
 1500366: cc                           	int3
 1500367: cc                           	int3
 1500368: cc                           	int3
 1500369: cc                           	int3
 150036a: cc                           	int3
 150036b: cc                           	int3
 150036c: cc                           	int3
 150036d: cc                           	int3
 150036e: cc                           	int3
 150036f: cc                           	int3
 1500370: cc                           	int3
 1500371: cc                           	int3
 1500372: cc                           	int3
 1500373: cc                           	int3
 1500374: cc                           	int3
 1500375: cc                           	int3
 1500376: cc                           	int3
 1500377: cc                           	int3
 1500378: cc                           	int3
 1500379: cc                           	int3
 150037a: cc                           	int3
 150037b: cc                           	int3
 150037c: cc                           	int3
 150037d: cc                           	int3
 150037e: cc                           	int3
 150037f: cc                           	int3
 1500380: cc                           	int3
 1500381: cc                           	int3
 1500382: cc                           	int3
 1500383: cc                           	int3
 1500384: cc                           	int3
 1500385: cc                           	int3
 1500386: cc                           	int3
 1500387: cc                           	int3
 1500388: cc                           	int3
 1500389: cc                           	int3
 150038a: cc                           	int3
 150038b: cc                           	int3
 150038c: cc                           	int3
 150038d: cc                           	int3
 150038e: cc                           	int3
 150038f: cc                           	int3
 1500390: cc                           	int3
 1500391: cc                           	int3
 1500392: cc                           	int3
 1500393: cc                           	int3
 1500394: cc                           	int3
 1500395: cc                           	int3
 1500396: cc                           	int3
 1500397: cc                           	int3
 1500398: cc                           	int3
 1500399: cc                           	int3
 150039a: cc                           	int3
 150039b: cc                           	int3
 150039c: cc                           	int3
 150039d: cc                           	int3
 150039e: cc                           	int3
 150039f: cc                           	int3
 15003a0: cc                           	int3
 15003a1: cc                           	int3
 15003a2: cc                           	int3
 15003a3: cc                           	int3
 15003a4: cc                           	int3
 15003a5: cc                           	int3
 15003a6: cc                           	int3
 15003a7: cc                           	int3
 15003a8: cc                           	int3
 15003a9: cc                           	int3
 15003aa: cc                           	int3
 15003ab: cc                           	int3
 15003ac: cc                           	int3
 15003ad: cc                           	int3
 15003ae: cc                           	int3
 15003af: cc                           	int3
 15003b0: cc                           	int3
 15003b1: cc                           	int3
 15003b2: cc                           	int3
 15003b3: cc                           	int3
 15003b4: cc                           	int3
 15003b5: cc                           	int3
 15003b6: cc                           	int3
 15003b7: cc                           	int3
 15003b8: cc                           	int3
 15003b9: cc                           	int3
 15003ba: cc                           	int3
 15003bb: cc                           	int3
 15003bc: cc                           	int3
 15003bd: cc                           	int3
 15003be: cc                           	int3
 15003bf: cc                           	int3
 15003c0: cc                           	int3
 15003c1: cc                           	int3
 15003c2: cc                           	int3
 15003c3: cc                           	int3
 15003c4: cc                           	int3
 15003c5: cc                           	int3
 15003c6: cc                           	int3
 15003c7: cc                           	int3
 15003c8: cc                           	int3
 15003c9: cc                           	int3
 15003ca: cc                           	int3
 15003cb: cc                           	int3
 15003cc: cc                           	int3
 15003cd: cc                           	int3
 15003ce: cc                           	int3
 15003cf: cc                           	int3
 15003d0: cc                           	int3
 15003d1: cc                           	int3
 15003d2: cc                           	int3
 15003d3: cc                           	int3
 15003d4: cc                           	int3
 15003d5: cc                           	int3
 15003d6: cc                           	int3
 15003d7: cc                           	int3
 15003d8: cc                           	int3
 15003d9: cc                           	int3
 15003da: cc                           	int3
 15003db: cc                           	int3
 15003dc: cc                           	int3
 15003dd: cc                           	int3
 15003de: cc                           	int3
 15003df: cc                           	int3
 15003e0: cc                           	int3
 15003e1: cc                           	int3
 15003e2: cc                           	int3
 15003e3: cc                           	int3
 15003e4: cc                           	int3
 15003e5: cc                           	int3
 15003e6: cc                           	int3
 15003e7: cc                           	int3
 15003e8: cc                           	int3
 15003e9: cc                           	int3
 15003ea: cc                           	int3
 15003eb: cc                           	int3
 15003ec: cc                           	int3
 15003ed: cc                           	int3
 15003ee: cc                           	int3
 15003ef: cc                           	int3
 15003f0: cc                           	int3
 15003f1: cc                           	int3
 15003f2: cc                           	int3
 15003f3: cc                           	int3
 15003f4: cc                           	int3
 15003f5: cc                           	int3
 15003f6: cc                           	int3
 15003f7: cc                           	int3
 15003f8: cc                           	int3
 15003f9: cc                           	int3
 15003fa: cc                           	int3
 15003fb: cc                           	int3
 15003fc: cc                           	int3
 15003fd: cc                           	int3
 15003fe: cc                           	int3
 15003ff: cc                           	int3
 1500400: cc                           	int3
 1500401: cc                           	int3
 1500402: cc                           	int3
 1500403: cc                           	int3
 1500404: cc                           	int3
 1500405: cc                           	int3
 1500406: cc                           	int3
 1500407: cc                           	int3
 1500408: cc                           	int3
 1500409: cc                           	int3
 150040a: cc                           	int3
 150040b: cc                           	int3
 150040c: cc                           	int3
 150040d: cc                           	int3
 150040e: cc                           	int3
 150040f: cc                           	int3
 1500410: cc                           	int3
 1500411: cc                           	int3
 1500412: cc                           	int3
 1500413: cc                           	int3
 1500414: cc                           	int3
 1500415: cc                           	int3
 1500416: cc                           	int3
 1500417: cc                           	int3
 1500418: cc                           	int3
 1500419: cc                           	int3
 150041a: cc                           	int3
 150041b: cc                           	int3
 150041c: cc                           	int3
 150041d: cc                           	int3
 150041e: cc                           	int3
 150041f: cc                           	int3
 1500420: cc                           	int3
 1500421: cc                           	int3
 1500422: cc                           	int3
 1500423: cc                           	int3
 1500424: cc                           	int3
 1500425: cc                           	int3
 1500426: cc                           	int3
 1500427: cc                           	int3
 1500428: cc                           	int3
 1500429: cc                           	int3
 150042a: cc                           	int3
 150042b: cc                           	int3
 150042c: cc                           	int3
 150042d: cc                           	int3
 150042e: cc                           	int3
 150042f: cc                           	int3
 1500430: cc                           	int3
 1500431: cc                           	int3
 1500432: cc                           	int3
 1500433: cc                           	int3
 1500434: cc                           	int3
 1500435: cc                           	int3
 1500436: cc                           	int3
 1500437: cc                           	int3
 1500438: cc                           	int3
 1500439: cc                           	int3
 150043a: cc                           	int3
 150043b: cc                           	int3
 150043c: cc                           	int3
 150043d: cc                           	int3
 150043e: cc                           	int3
 150043f: cc                           	int3
 1500440: cc                           	int3
 1500441: cc                           	int3
 1500442: cc                           	int3
 1500443: cc                           	int3
 1500444: cc                           	int3
 1500445: cc                           	int3
 1500446: cc                           	int3
 1500447: cc                           	int3
 1500448: cc                           	int3
 1500449: cc                           	int3
 150044a: cc                           	int3
 150044b: cc                           	int3
 150044c: cc                           	int3
 150044d: cc                           	int3
 150044e: cc                           	int3
 150044f: cc                           	int3
 1500450: cc                           	int3
 1500451: cc                           	int3
 1500452: cc                           	int3
 1500453: cc                           	int3
 1500454: cc                           	int3
 1500455: cc                           	int3
 1500456: cc                           	int3
 1500457: cc                           	int3
 1500458: cc                           	int3
 1500459: cc                           	int3
 150045a: cc                           	int3
 150045b: cc                           	int3
 150045c: cc                           	int3
 150045d: cc                           	int3
 150045e: cc                           	int3
 150045f: cc                           	int3
 1500460: cc                           	int3
 1500461: cc                           	int3
 1500462: cc                           	int3
 1500463: cc                           	int3
 1500464: cc                           	int3
 1500465: cc                           	int3
 1500466: cc                           	int3
 1500467: cc                           	int3
 1500468: cc                           	int3
 1500469: cc                           	int3
 150046a: cc                           	int3
 150046b: cc                           	int3
 150046c: cc                           	int3
 150046d: cc                           	int3
 150046e: cc                           	int3
 150046f: cc                           	int3
 1500470: cc                           	int3
 1500471: cc                           	int3
 1500472: cc                           	int3
 1500473: cc                           	int3
 1500474: cc                           	int3
 1500475: cc                           	int3
 1500476: cc                           	int3
 1500477: cc                           	int3
 1500478: cc                           	int3
 1500479: cc                           	int3
 150047a: cc                           	int3
 150047b: cc                           	int3
 150047c: cc                           	int3
 150047d: cc                           	int3
 150047e: cc                           	int3
 150047f: cc                           	int3
 1500480: cc                           	int3
 1500481: cc                           	int3
 1500482: cc                           	int3
 1500483: cc                           	int3
 1500484: cc                           	int3
 1500485: cc                           	int3
 1500486: cc                           	int3
 1500487: cc                           	int3
 1500488: cc                           	int3
 1500489: cc                           	int3
 150048a: cc                           	int3
 150048b: cc                           	int3
 150048c: cc                           	int3
 150048d: cc                           	int3
 150048e: cc                           	int3
 150048f: cc                           	int3
 1500490: cc                           	int3
 1500491: cc                           	int3
 1500492: cc                           	int3
 1500493: cc                           	int3
 1500494: cc                           	int3
 1500495: cc                           	int3
 1500496: cc                           	int3
 1500497: cc                           	int3
 1500498: cc                           	int3
 1500499: cc                           	int3
 150049a: cc                           	int3
 150049b: cc                           	int3
 150049c: cc                           	int3
 150049d: cc                           	int3
 150049e: cc                           	int3
 150049f: cc                           	int3
 15004a0: cc                           	int3
 15004a1: cc                           	int3
 15004a2: cc                           	int3
 15004a3: cc                           	int3
 15004a4: cc                           	int3
 15004a5: cc                           	int3
 15004a6: cc                           	int3
 15004a7: cc                           	int3
 15004a8: cc                           	int3
 15004a9: cc                           	int3
 15004aa: cc                           	int3
 15004ab: cc                           	int3
 15004ac: cc                           	int3
 15004ad: cc                           	int3
 15004ae: cc                           	int3
 15004af: cc                           	int3
 15004b0: cc                           	int3
 15004b1: cc                           	int3
 15004b2: cc                           	int3
 15004b3: cc                           	int3
 15004b4: cc                           	int3
 15004b5: cc                           	int3
 15004b6: cc                           	int3
 15004b7: cc                           	int3
 15004b8: cc                           	int3
 15004b9: cc                           	int3
 15004ba: cc                           	int3
 15004bb: cc                           	int3
 15004bc: cc                           	int3
 15004bd: cc                           	int3
 15004be: cc                           	int3
 15004bf: cc                           	int3
 15004c0: cc                           	int3
 15004c1: cc                           	int3
 15004c2: cc                           	int3
 15004c3: cc                           	int3
 15004c4: cc                           	int3
 15004c5: cc                           	int3
 15004c6: cc                           	int3
 15004c7: cc                           	int3
 15004c8: cc                           	int3
 15004c9: cc                           	int3
 15004ca: cc                           	int3
 15004cb: cc                           	int3
 15004cc: cc                           	int3
 15004cd: cc                           	int3
 15004ce: cc                           	int3
 15004cf: cc                           	int3
 15004d0: cc                           	int3
 15004d1: cc                           	int3
 15004d2: cc                           	int3
 15004d3: cc                           	int3
 15004d4: cc                           	int3
 15004d5: cc                           	int3
 15004d6: cc                           	int3
 15004d7: cc                           	int3
 15004d8: cc                           	int3
 15004d9: cc                           	int3
 15004da: cc                           	int3
 15004db: cc                           	int3
 15004dc: cc                           	int3
 15004dd: cc                           	int3
 15004de: cc                           	int3
 15004df: cc                           	int3
 15004e0: cc                           	int3
 15004e1: cc                           	int3
 15004e2: cc                           	int3
 15004e3: cc                           	int3
 15004e4: cc                           	int3
 15004e5: cc                           	int3
 15004e6: cc                           	int3
 15004e7: cc                           	int3
 15004e8: cc                           	int3
 15004e9: cc                           	int3
 15004ea: cc                           	int3
 15004eb: cc                           	int3
 15004ec: cc                           	int3
 15004ed: cc                           	int3
 15004ee: cc                           	int3
 15004ef: cc                           	int3
 15004f0: cc                           	int3
 15004f1: cc                           	int3
 15004f2: cc                           	int3
 15004f3: cc                           	int3
 15004f4: cc                           	int3
 15004f5: cc                           	int3
 15004f6: cc                           	int3
 15004f7: cc                           	int3
 15004f8: cc                           	int3
 15004f9: cc                           	int3
 15004fa: cc                           	int3
 15004fb: cc                           	int3
 15004fc: cc                           	int3
 15004fd: cc                           	int3
 15004fe: cc                           	int3
 15004ff: cc                           	int3
 1500500: cc                           	int3
 1500501: cc                           	int3
 1500502: cc                           	int3
 1500503: cc                           	int3
 1500504: cc                           	int3
 1500505: cc                           	int3
 1500506: cc                           	int3
 1500507: cc                           	int3
 1500508: cc                           	int3
 1500509: cc                           	int3
 150050a: cc                           	int3
 150050b: cc                           	int3
 150050c: cc                           	int3
 150050d: cc                           	int3
 150050e: cc                           	int3
 150050f: cc                           	int3
 1500510: cc                           	int3
 1500511: cc                           	int3
 1500512: cc                           	int3
 1500513: cc                           	int3
 1500514: cc                           	int3
 1500515: cc                           	int3
 1500516: cc                           	int3
 1500517: cc                           	int3
 1500518: cc                           	int3
 1500519: cc                           	int3
 150051a: cc                           	int3
 150051b: cc                           	int3
 150051c: cc                           	int3
 150051d: cc                           	int3
 150051e: cc                           	int3
 150051f: cc                           	int3
 1500520: cc                           	int3
 1500521: cc                           	int3
 1500522: cc                           	int3
 1500523: cc                           	int3
 1500524: cc                           	int3
 1500525: cc                           	int3
 1500526: cc                           	int3
 1500527: cc                           	int3
 1500528: cc                           	int3
 1500529: cc                           	int3
 150052a: cc                           	int3
 150052b: cc                           	int3
 150052c: cc                           	int3
 150052d: cc                           	int3
 150052e: cc                           	int3
 150052f: cc                           	int3
 1500530: cc                           	int3
 1500531: cc                           	int3
 1500532: cc                           	int3
 1500533: cc                           	int3
 1500534: cc                           	int3
 1500535: cc                           	int3
 1500536: cc                           	int3
 1500537: cc                           	int3
 1500538: cc                           	int3
 1500539: cc                           	int3
 150053a: cc                           	int3
 150053b: cc                           	int3
 150053c: cc                           	int3
 150053d: cc                           	int3
 150053e: cc                           	int3
 150053f: cc                           	int3
 1500540: cc                           	int3
 1500541: cc                           	int3
 1500542: cc                           	int3
 1500543: cc                           	int3
 1500544: cc                           	int3
 1500545: cc                           	int3
 1500546: cc                           	int3
 1500547: cc                           	int3
 1500548: cc                           	int3
 1500549: cc                           	int3
 150054a: cc                           	int3
 150054b: cc                           	int3
 150054c: cc                           	int3
 150054d: cc                           	int3
 150054e: cc                           	int3
 150054f: cc                           	int3
 1500550: cc                           	int3
 1500551: cc                           	int3
 1500552: cc                           	int3
 1500553: cc                           	int3
 1500554: cc                           	int3
 1500555: cc                           	int3
 1500556: cc                           	int3
 1500557: cc                           	int3
 1500558: cc                           	int3
 1500559: cc                           	int3
 150055a: cc                           	int3
 150055b: cc                           	int3
 150055c: cc                           	int3
 150055d: cc                           	int3
 150055e: cc                           	int3
 150055f: cc                           	int3
 1500560: cc                           	int3
 1500561: cc                           	int3
 1500562: cc                           	int3
 1500563: cc                           	int3
 1500564: cc                           	int3
 1500565: cc                           	int3
 1500566: cc                           	int3
 1500567: cc                           	int3
 1500568: cc                           	int3
 1500569: cc                           	int3
 150056a: cc                           	int3
 150056b: cc                           	int3
 150056c: cc                           	int3
 150056d: cc                           	int3
 150056e: cc                           	int3
 150056f: cc                           	int3
 1500570: cc                           	int3
 1500571: cc                           	int3
 1500572: cc                           	int3
 1500573: cc                           	int3
 1500574: cc                           	int3
 1500575: cc                           	int3
 1500576: cc                           	int3
 1500577: cc                           	int3
 1500578: cc                           	int3
 1500579: cc                           	int3
 150057a: cc                           	int3
 150057b: cc                           	int3
 150057c: cc                           	int3
 150057d: cc                           	int3
 150057e: cc                           	int3
 150057f: cc                           	int3
 1500580: cc                           	int3
 1500581: cc                           	int3
 1500582: cc                           	int3
 1500583: cc                           	int3
 1500584: cc                           	int3
 1500585: cc                           	int3
 1500586: cc                           	int3
 1500587: cc                           	int3
 1500588: cc                           	int3
 1500589: cc                           	int3
 150058a: cc                           	int3
 150058b: cc                           	int3
 150058c: cc                           	int3
 150058d: cc                           	int3
 150058e: cc                           	int3
 150058f: cc                           	int3
 1500590: cc                           	int3
 1500591: cc                           	int3
 1500592: cc                           	int3
 1500593: cc                           	int3
 1500594: cc                           	int3
 1500595: cc                           	int3
 1500596: cc                           	int3
 1500597: cc                           	int3
 1500598: cc                           	int3
 1500599: cc                           	int3
 150059a: cc                           	int3
 150059b: cc                           	int3
 150059c: cc                           	int3
 150059d: cc                           	int3
 150059e: cc                           	int3
 150059f: cc                           	int3
 15005a0: cc                           	int3
 15005a1: cc                           	int3
 15005a2: cc                           	int3
 15005a3: cc                           	int3
 15005a4: cc                           	int3
 15005a5: cc                           	int3
 15005a6: cc                           	int3
 15005a7: cc                           	int3
 15005a8: cc                           	int3
 15005a9: cc                           	int3
 15005aa: cc                           	int3
 15005ab: cc                           	int3
 15005ac: cc                           	int3
 15005ad: cc                           	int3
 15005ae: cc                           	int3
 15005af: cc                           	int3
 15005b0: cc                           	int3
 15005b1: cc                           	int3
 15005b2: cc                           	int3
 15005b3: cc                           	int3
 15005b4: cc                           	int3
 15005b5: cc                           	int3
 15005b6: cc                           	int3
 15005b7: cc                           	int3
 15005b8: cc                           	int3
 15005b9: cc                           	int3
 15005ba: cc                           	int3
 15005bb: cc                           	int3
 15005bc: cc                           	int3
 15005bd: cc                           	int3
 15005be: cc                           	int3
 15005bf: cc                           	int3
 15005c0: cc                           	int3
 15005c1: cc                           	int3
 15005c2: cc                           	int3
 15005c3: cc                           	int3
 15005c4: cc                           	int3
 15005c5: cc                           	int3
 15005c6: cc                           	int3
 15005c7: cc                           	int3
 15005c8: cc                           	int3
 15005c9: cc                           	int3
 15005ca: cc                           	int3
 15005cb: cc                           	int3
 15005cc: cc                           	int3
 15005cd: cc                           	int3
 15005ce: cc                           	int3
 15005cf: cc                           	int3
 15005d0: cc                           	int3
 15005d1: cc                           	int3
 15005d2: cc                           	int3
 15005d3: cc                           	int3
 15005d4: cc                           	int3
 15005d5: cc                           	int3
 15005d6: cc                           	int3
 15005d7: cc                           	int3
 15005d8: cc                           	int3
 15005d9: cc                           	int3
 15005da: cc                           	int3
 15005db: cc                           	int3
 15005dc: cc                           	int3
 15005dd: cc                           	int3
 15005de: cc                           	int3
 15005df: cc                           	int3
 15005e0: cc                           	int3
 15005e1: cc                           	int3
 15005e2: cc                           	int3
 15005e3: cc                           	int3
 15005e4: cc                           	int3
 15005e5: cc                           	int3
 15005e6: cc                           	int3
 15005e7: cc                           	int3
 15005e8: cc                           	int3
 15005e9: cc                           	int3
 15005ea: cc                           	int3
 15005eb: cc                           	int3
 15005ec: cc                           	int3
 15005ed: cc                           	int3
 15005ee: cc                           	int3
 15005ef: cc                           	int3
 15005f0: cc                           	int3
 15005f1: cc                           	int3
 15005f2: cc                           	int3
 15005f3: cc                           	int3
 15005f4: cc                           	int3
 15005f5: cc                           	int3
 15005f6: cc                           	int3
 15005f7: cc                           	int3
 15005f8: cc                           	int3
 15005f9: cc                           	int3
 15005fa: cc                           	int3
 15005fb: cc                           	int3
 15005fc: cc                           	int3
 15005fd: cc                           	int3
 15005fe: cc                           	int3
 15005ff: cc                           	int3
 1500600: cc                           	int3
 1500601: cc                           	int3
 1500602: cc                           	int3
 1500603: cc                           	int3
 1500604: cc                           	int3
 1500605: cc                           	int3
 1500606: cc                           	int3
 1500607: cc                           	int3
 1500608: cc                           	int3
 1500609: cc                           	int3
 150060a: cc                           	int3
 150060b: cc                           	int3
 150060c: cc                           	int3
 150060d: cc                           	int3
 150060e: cc                           	int3
 150060f: cc                           	int3
 1500610: cc                           	int3
 1500611: cc                           	int3
 1500612: cc                           	int3
 1500613: cc                           	int3
 1500614: cc                           	int3
 1500615: cc                           	int3
 1500616: cc                           	int3
 1500617: cc                           	int3
 1500618: cc                           	int3
 1500619: cc                           	int3
 150061a: cc                           	int3
 150061b: cc                           	int3
 150061c: cc                           	int3
 150061d: cc                           	int3
 150061e: cc                           	int3
 150061f: cc                           	int3
 1500620: cc                           	int3
 1500621: cc                           	int3
 1500622: cc                           	int3
 1500623: cc                           	int3
 1500624: cc                           	int3
 1500625: cc                           	int3
 1500626: cc                           	int3
 1500627: cc                           	int3
 1500628: cc                           	int3
 1500629: cc                           	int3
 150062a: cc                           	int3
 150062b: cc                           	int3
 150062c: cc                           	int3
 150062d: cc                           	int3
 150062e: cc                           	int3
 150062f: cc                           	int3
 1500630: cc                           	int3
 1500631: cc                           	int3
 1500632: cc                           	int3
 1500633: cc                           	int3
 1500634: cc                           	int3
 1500635: cc                           	int3
 1500636: cc                           	int3
 1500637: cc                           	int3
 1500638: cc                           	int3
 1500639: cc                           	int3
 150063a: cc                           	int3
 150063b: cc                           	int3
 150063c: cc                           	int3
 150063d: cc                           	int3
 150063e: cc                           	int3
 150063f: cc                           	int3
 1500640: cc                           	int3
 1500641: cc                           	int3
 1500642: cc                           	int3
 1500643: cc                           	int3
 1500644: cc                           	int3
 1500645: cc                           	int3
 1500646: cc                           	int3
 1500647: cc                           	int3
 1500648: cc                           	int3
 1500649: cc                           	int3
 150064a: cc                           	int3
 150064b: cc                           	int3
 150064c: cc                           	int3
 150064d: cc                           	int3
 150064e: cc                           	int3
 150064f: cc                           	int3
 1500650: cc                           	int3
 1500651: cc                           	int3
 1500652: cc                           	int3
 1500653: cc                           	int3
 1500654: cc                           	int3
 1500655: cc                           	int3
 1500656: cc                           	int3
 1500657: cc                           	int3
 1500658: cc                           	int3
 1500659: cc                           	int3
 150065a: cc                           	int3
 150065b: cc                           	int3
 150065c: cc                           	int3
 150065d: cc                           	int3
 150065e: cc                           	int3
 150065f: cc                           	int3
 1500660: cc                           	int3
 1500661: cc                           	int3
 1500662: cc                           	int3
 1500663: cc                           	int3
 1500664: cc                           	int3
 1500665: cc                           	int3
 1500666: cc                           	int3
 1500667: cc                           	int3
 1500668: cc                           	int3
 1500669: cc                           	int3
 150066a: cc                           	int3
 150066b: cc                           	int3
 150066c: cc                           	int3
 150066d: cc                           	int3
 150066e: cc                           	int3
 150066f: cc                           	int3
 1500670: cc                           	int3
 1500671: cc                           	int3
 1500672: cc                           	int3
 1500673: cc                           	int3
 1500674: cc                           	int3
 1500675: cc                           	int3
 1500676: cc                           	int3
 1500677: cc                           	int3
 1500678: cc                           	int3
 1500679: cc                           	int3
 150067a: cc                           	int3
 150067b: cc                           	int3
 150067c: cc                           	int3
 150067d: cc                           	int3
 150067e: cc                           	int3
 150067f: cc                           	int3
 1500680: cc                           	int3
 1500681: cc                           	int3
 1500682: cc                           	int3
 1500683: cc                           	int3
 1500684: cc                           	int3
 1500685: cc                           	int3
 1500686: cc                           	int3
 1500687: cc                           	int3
 1500688: cc                           	int3
 1500689: cc                           	int3
 150068a: cc                           	int3
 150068b: cc                           	int3
 150068c: cc                           	int3
 150068d: cc                           	int3
 150068e: cc                           	int3
 150068f: cc                           	int3
 1500690: cc                           	int3
 1500691: cc                           	int3
 1500692: cc                           	int3
 1500693: cc                           	int3
 1500694: cc                           	int3
 1500695: cc                           	int3
 1500696: cc                           	int3
 1500697: cc                           	int3
 1500698: cc                           	int3
 1500699: cc                           	int3
 150069a: cc                           	int3
 150069b: cc                           	int3
 150069c: cc                           	int3
 150069d: cc                           	int3
 150069e: cc                           	int3
 150069f: cc                           	int3
 15006a0: cc                           	int3
 15006a1: cc                           	int3
 15006a2: cc                           	int3
 15006a3: cc                           	int3
 15006a4: cc                           	int3
 15006a5: cc                           	int3
 15006a6: cc                           	int3
 15006a7: cc                           	int3
 15006a8: cc                           	int3
 15006a9: cc                           	int3
 15006aa: cc                           	int3
 15006ab: cc                           	int3
 15006ac: cc                           	int3
 15006ad: cc                           	int3
 15006ae: cc                           	int3
 15006af: cc                           	int3
 15006b0: cc                           	int3
 15006b1: cc                           	int3
 15006b2: cc                           	int3
 15006b3: cc                           	int3
 15006b4: cc                           	int3
 15006b5: cc                           	int3
 15006b6: cc                           	int3
 15006b7: cc                           	int3
 15006b8: cc                           	int3
 15006b9: cc                           	int3
 15006ba: cc                           	int3
 15006bb: cc                           	int3
 15006bc: cc                           	int3
 15006bd: cc                           	int3
 15006be: cc                           	int3
 15006bf: cc                           	int3
 15006c0: cc                           	int3
 15006c1: cc                           	int3
 15006c2: cc                           	int3
 15006c3: cc                           	int3
 15006c4: cc                           	int3
 15006c5: cc                           	int3
 15006c6: cc                           	int3
 15006c7: cc                           	int3
 15006c8: cc                           	int3
 15006c9: cc                           	int3
 15006ca: cc                           	int3
 15006cb: cc                           	int3
 15006cc: cc                           	int3
 15006cd: cc                           	int3
 15006ce: cc                           	int3
 15006cf: cc                           	int3
 15006d0: cc                           	int3
 15006d1: cc                           	int3
 15006d2: cc                           	int3
 15006d3: cc                           	int3
 15006d4: cc                           	int3
 15006d5: cc                           	int3
 15006d6: cc                           	int3
 15006d7: cc                           	int3
 15006d8: cc                           	int3
 15006d9: cc                           	int3
 15006da: cc                           	int3
 15006db: cc                           	int3
 15006dc: cc                           	int3
 15006dd: cc                           	int3
 15006de: cc                           	int3
 15006df: cc                           	int3
 15006e0: cc                           	int3
 15006e1: cc                           	int3
 15006e2: cc                           	int3
 15006e3: cc                           	int3
 15006e4: cc                           	int3
 15006e5: cc                           	int3
 15006e6: cc                           	int3
 15006e7: cc                           	int3
 15006e8: cc                           	int3
 15006e9: cc                           	int3
 15006ea: cc                           	int3
 15006eb: cc                           	int3
 15006ec: cc                           	int3
 15006ed: cc                           	int3
 15006ee: cc                           	int3
 15006ef: cc                           	int3
 15006f0: cc                           	int3
 15006f1: cc                           	int3
 15006f2: cc                           	int3
 15006f3: cc                           	int3
 15006f4: cc                           	int3
 15006f5: cc                           	int3
 15006f6: cc                           	int3
 15006f7: cc                           	int3
 15006f8: cc                           	int3
 15006f9: cc                           	int3
 15006fa: cc                           	int3
 15006fb: cc                           	int3
 15006fc: cc                           	int3
 15006fd: cc                           	int3
 15006fe: cc                           	int3
 15006ff: cc                           	int3
 1500700: cc                           	int3
 1500701: cc                           	int3
 1500702: cc                           	int3
 1500703: cc                           	int3
 1500704: cc                           	int3
 1500705: cc                           	int3
 1500706: cc                           	int3
 1500707: cc                           	int3
 1500708: cc                           	int3
 1500709: cc                           	int3
 150070a: cc                           	int3
 150070b: cc                           	int3
 150070c: cc                           	int3
 150070d: cc                           	int3
 150070e: cc                           	int3
 150070f: cc                           	int3
 1500710: cc                           	int3
 1500711: cc                           	int3
 1500712: cc                           	int3
 1500713: cc                           	int3
 1500714: cc                           	int3
 1500715: cc                           	int3
 1500716: cc                           	int3
 1500717: cc                           	int3
 1500718: cc                           	int3
 1500719: cc                           	int3
 150071a: cc                           	int3
 150071b: cc                           	int3
 150071c: cc                           	int3
 150071d: cc                           	int3
 150071e: cc                           	int3
 150071f: cc                           	int3
 1500720: cc                           	int3
 1500721: cc                           	int3
 1500722: cc                           	int3
 1500723: cc                           	int3
 1500724: cc                           	int3
 1500725: cc                           	int3
 1500726: cc                           	int3
 1500727: cc                           	int3
 1500728: cc                           	int3
 1500729: cc                           	int3
 150072a: cc                           	int3
 150072b: cc                           	int3
 150072c: cc                           	int3
 150072d: cc                           	int3
 150072e: cc                           	int3
 150072f: cc                           	int3
 1500730: cc                           	int3
 1500731: cc                           	int3
 1500732: cc                           	int3
 1500733: cc                           	int3
 1500734: cc                           	int3
 1500735: cc                           	int3
 1500736: cc                           	int3
 1500737: cc                           	int3
 1500738: cc                           	int3
 1500739: cc                           	int3
 150073a: cc                           	int3
 150073b: cc                           	int3
 150073c: cc                           	int3
 150073d: cc                           	int3
 150073e: cc                           	int3
 150073f: cc                           	int3
 1500740: cc                           	int3
 1500741: cc                           	int3
 1500742: cc                           	int3
 1500743: cc                           	int3
 1500744: cc                           	int3
 1500745: cc                           	int3
 1500746: cc                           	int3
 1500747: cc                           	int3
 1500748: cc                           	int3
 1500749: cc                           	int3
 150074a: cc                           	int3
 150074b: cc                           	int3
 150074c: cc                           	int3
 150074d: cc                           	int3
 150074e: cc                           	int3
 150074f: cc                           	int3
 1500750: cc                           	int3
 1500751: cc                           	int3
 1500752: cc                           	int3
 1500753: cc                           	int3
 1500754: cc                           	int3
 1500755: cc                           	int3
 1500756: cc                           	int3
 1500757: cc                           	int3
 1500758: cc                           	int3
 1500759: cc                           	int3
 150075a: cc                           	int3
 150075b: cc                           	int3
 150075c: cc                           	int3
 150075d: cc                           	int3
 150075e: cc                           	int3
 150075f: cc                           	int3
 1500760: cc                           	int3
 1500761: cc                           	int3
 1500762: cc                           	int3
 1500763: cc                           	int3
 1500764: cc                           	int3
 1500765: cc                           	int3
 1500766: cc                           	int3
 1500767: cc                           	int3
 1500768: cc                           	int3
 1500769: cc                           	int3
 150076a: cc                           	int3
 150076b: cc                           	int3
 150076c: cc                           	int3
 150076d: cc                           	int3
 150076e: cc                           	int3
 150076f: cc                           	int3
 1500770: cc                           	int3
 1500771: cc                           	int3
 1500772: cc                           	int3
 1500773: cc                           	int3
 1500774: cc                           	int3
 1500775: cc                           	int3
 1500776: cc                           	int3
 1500777: cc                           	int3
 1500778: cc                           	int3
 1500779: cc                           	int3
 150077a: cc                           	int3
 150077b: cc                           	int3
 150077c: cc                           	int3
 150077d: cc                           	int3
 150077e: cc                           	int3
 150077f: cc                           	int3
 1500780: cc                           	int3
 1500781: cc                           	int3
 1500782: cc                           	int3
 1500783: cc                           	int3
 1500784: cc                           	int3
 1500785: cc                           	int3
 1500786: cc                           	int3
 1500787: cc                           	int3
 1500788: cc                           	int3
 1500789: cc                           	int3
 150078a: cc                           	int3
 150078b: cc                           	int3
 150078c: cc                           	int3
 150078d: cc                           	int3
 150078e: cc                           	int3
 150078f: cc                           	int3
 1500790: cc                           	int3
 1500791: cc                           	int3
 1500792: cc                           	int3
 1500793: cc                           	int3
 1500794: cc                           	int3
 1500795: cc                           	int3
 1500796: cc                           	int3
 1500797: cc                           	int3
 1500798: cc                           	int3
 1500799: cc                           	int3
 150079a: cc                           	int3
 150079b: cc                           	int3
 150079c: cc                           	int3
 150079d: cc                           	int3
 150079e: cc                           	int3
 150079f: cc                           	int3
 15007a0: cc                           	int3
 15007a1: cc                           	int3
 15007a2: cc                           	int3
 15007a3: cc                           	int3
 15007a4: cc                           	int3
 15007a5: cc                           	int3
 15007a6: cc                           	int3
 15007a7: cc                           	int3
 15007a8: cc                           	int3
 15007a9: cc                           	int3
 15007aa: cc                           	int3
 15007ab: cc                           	int3
 15007ac: cc                           	int3
 15007ad: cc                           	int3
 15007ae: cc                           	int3
 15007af: cc                           	int3
 15007b0: cc                           	int3
 15007b1: cc                           	int3
 15007b2: cc                           	int3
 15007b3: cc                           	int3
 15007b4: cc                           	int3
 15007b5: cc                           	int3
 15007b6: cc                           	int3
 15007b7: cc                           	int3
 15007b8: cc                           	int3
 15007b9: cc                           	int3
 15007ba: cc                           	int3
 15007bb: cc                           	int3
 15007bc: cc                           	int3
 15007bd: cc                           	int3
 15007be: cc                           	int3
 15007bf: cc                           	int3
 15007c0: cc                           	int3
 15007c1: cc                           	int3
 15007c2: cc                           	int3
 15007c3: cc                           	int3
 15007c4: cc                           	int3
 15007c5: cc                           	int3
 15007c6: cc                           	int3
 15007c7: cc                           	int3
 15007c8: cc                           	int3
 15007c9: cc                           	int3
 15007ca: cc                           	int3
 15007cb: cc                           	int3
 15007cc: cc                           	int3
 15007cd: cc                           	int3
 15007ce: cc                           	int3
 15007cf: cc                           	int3
 15007d0: cc                           	int3
 15007d1: cc                           	int3
 15007d2: cc                           	int3
 15007d3: cc                           	int3
 15007d4: cc                           	int3
 15007d5: cc                           	int3
 15007d6: cc                           	int3
 15007d7: cc                           	int3
 15007d8: cc                           	int3
 15007d9: cc                           	int3
 15007da: cc                           	int3
 15007db: cc                           	int3
 15007dc: cc                           	int3
 15007dd: cc                           	int3
 15007de: cc                           	int3
 15007df: cc                           	int3
 15007e0: cc                           	int3
 15007e1: cc                           	int3
 15007e2: cc                           	int3
 15007e3: cc                           	int3
 15007e4: cc                           	int3
 15007e5: cc                           	int3
 15007e6: cc                           	int3
 15007e7: cc                           	int3
 15007e8: cc                           	int3
 15007e9: cc                           	int3
 15007ea: cc                           	int3
 15007eb: cc                           	int3
 15007ec: cc                           	int3
 15007ed: cc                           	int3
 15007ee: cc                           	int3
 15007ef: cc                           	int3
 15007f0: cc                           	int3
 15007f1: cc                           	int3
 15007f2: cc                           	int3
 15007f3: cc                           	int3
 15007f4: cc                           	int3
 15007f5: cc                           	int3
 15007f6: cc                           	int3
 15007f7: cc                           	int3
 15007f8: cc                           	int3
 15007f9: cc                           	int3
 15007fa: cc                           	int3
 15007fb: cc                           	int3
 15007fc: cc                           	int3
 15007fd: cc                           	int3
 15007fe: cc                           	int3
 15007ff: cc                           	int3
 1500800: cc                           	int3
 1500801: cc                           	int3
 1500802: cc                           	int3
 1500803: cc                           	int3
 1500804: cc                           	int3
 1500805: cc                           	int3
 1500806: cc                           	int3
 1500807: cc                           	int3
 1500808: cc                           	int3
 1500809: cc                           	int3
 150080a: cc                           	int3
 150080b: cc                           	int3
 150080c: cc                           	int3
 150080d: cc                           	int3
 150080e: cc                           	int3
 150080f: cc                           	int3
 1500810: cc                           	int3
 1500811: cc                           	int3
 1500812: cc                           	int3
 1500813: cc                           	int3
 1500814: cc                           	int3
 1500815: cc                           	int3
 1500816: cc                           	int3
 1500817: cc                           	int3
 1500818: cc                           	int3
 1500819: cc                           	int3
 150081a: cc                           	int3
 150081b: cc                           	int3
 150081c: cc                           	int3
 150081d: cc                           	int3
 150081e: cc                           	int3
 150081f: cc                           	int3
 1500820: cc                           	int3
 1500821: cc                           	int3
 1500822: cc                           	int3
 1500823: cc                           	int3
 1500824: cc                           	int3
 1500825: cc                           	int3
 1500826: cc                           	int3
 1500827: cc                           	int3
 1500828: cc                           	int3
 1500829: cc                           	int3
 150082a: cc                           	int3
 150082b: cc                           	int3
 150082c: cc                           	int3
 150082d: cc                           	int3
 150082e: cc                           	int3
 150082f: cc                           	int3
 1500830: cc                           	int3
 1500831: cc                           	int3
 1500832: cc                           	int3
 1500833: cc                           	int3
 1500834: cc                           	int3
 1500835: cc                           	int3
 1500836: cc                           	int3
 1500837: cc                           	int3
 1500838: cc                           	int3
 1500839: cc                           	int3
 150083a: cc                           	int3
 150083b: cc                           	int3
 150083c: cc                           	int3
 150083d: cc                           	int3
 150083e: cc                           	int3
 150083f: cc                           	int3
 1500840: cc                           	int3
 1500841: cc                           	int3
 1500842: cc                           	int3
 1500843: cc                           	int3
 1500844: cc                           	int3
 1500845: cc                           	int3
 1500846: cc                           	int3
 1500847: cc                           	int3
 1500848: cc                           	int3
 1500849: cc                           	int3
 150084a: cc                           	int3
 150084b: cc                           	int3
 150084c: cc                           	int3
 150084d: cc                           	int3
 150084e: cc                           	int3
 150084f: cc                           	int3
 1500850: cc                           	int3
 1500851: cc                           	int3
 1500852: cc                           	int3
 1500853: cc                           	int3
 1500854: cc                           	int3
 1500855: cc                           	int3
 1500856: cc                           	int3
 1500857: cc                           	int3
 1500858: cc                           	int3
 1500859: cc                           	int3
 150085a: cc                           	int3
 150085b: cc                           	int3
 150085c: cc                           	int3
 150085d: cc                           	int3
 150085e: cc                           	int3
 150085f: cc                           	int3
 1500860: cc                           	int3
 1500861: cc                           	int3
 1500862: cc                           	int3
 1500863: cc                           	int3
 1500864: cc                           	int3
 1500865: cc                           	int3
 1500866: cc                           	int3
 1500867: cc                           	int3
 1500868: cc                           	int3
 1500869: cc                           	int3
 150086a: cc                           	int3
 150086b: cc                           	int3
 150086c: cc                           	int3
 150086d: cc                           	int3
 150086e: cc                           	int3
 150086f: cc                           	int3
 1500870: cc                           	int3
 1500871: cc                           	int3
 1500872: cc                           	int3
 1500873: cc                           	int3
 1500874: cc                           	int3
 1500875: cc                           	int3
 1500876: cc                           	int3
 1500877: cc                           	int3
 1500878: cc                           	int3
 1500879: cc                           	int3
 150087a: cc                           	int3
 150087b: cc                           	int3
 150087c: cc                           	int3
 150087d: cc                           	int3
 150087e: cc                           	int3
 150087f: cc                           	int3
 1500880: cc                           	int3
 1500881: cc                           	int3
 1500882: cc                           	int3
 1500883: cc                           	int3
 1500884: cc                           	int3
 1500885: cc                           	int3
 1500886: cc                           	int3
 1500887: cc                           	int3
 1500888: cc                           	int3
 1500889: cc                           	int3
 150088a: cc                           	int3
 150088b: cc                           	int3
 150088c: cc                           	int3
 150088d: cc                           	int3
 150088e: cc                           	int3
 150088f: cc                           	int3
 1500890: cc                           	int3
 1500891: cc                           	int3
 1500892: cc                           	int3
 1500893: cc                           	int3
 1500894: cc                           	int3
 1500895: cc                           	int3
 1500896: cc                           	int3
 1500897: cc                           	int3
 1500898: cc                           	int3
 1500899: cc                           	int3
 150089a: cc                           	int3
 150089b: cc                           	int3
 150089c: cc                           	int3
 150089d: cc                           	int3
 150089e: cc                           	int3
 150089f: cc                           	int3
 15008a0: cc                           	int3
 15008a1: cc                           	int3
 15008a2: cc                           	int3
 15008a3: cc                           	int3
 15008a4: cc                           	int3
 15008a5: cc                           	int3
 15008a6: cc                           	int3
 15008a7: cc                           	int3
 15008a8: cc                           	int3
 15008a9: cc                           	int3
 15008aa: cc                           	int3
 15008ab: cc                           	int3
 15008ac: cc                           	int3
 15008ad: cc                           	int3
 15008ae: cc                           	int3
 15008af: cc                           	int3
 15008b0: cc                           	int3
 15008b1: cc                           	int3
 15008b2: cc                           	int3
 15008b3: cc                           	int3
 15008b4: cc                           	int3
 15008b5: cc                           	int3
 15008b6: cc                           	int3
 15008b7: cc                           	int3
 15008b8: cc                           	int3
 15008b9: cc                           	int3
 15008ba: cc                           	int3
 15008bb: cc                           	int3
 15008bc: cc                           	int3
 15008bd: cc                           	int3
 15008be: cc                           	int3
 15008bf: cc                           	int3
 15008c0: cc                           	int3
 15008c1: cc                           	int3
 15008c2: cc                           	int3
 15008c3: cc                           	int3
 15008c4: cc                           	int3
 15008c5: cc                           	int3
 15008c6: cc                           	int3
 15008c7: cc                           	int3
 15008c8: cc                           	int3
 15008c9: cc                           	int3
 15008ca: cc                           	int3
 15008cb: cc                           	int3
 15008cc: cc                           	int3
 15008cd: cc                           	int3
 15008ce: cc                           	int3
 15008cf: cc                           	int3
 15008d0: cc                           	int3
 15008d1: cc                           	int3
 15008d2: cc                           	int3
 15008d3: cc                           	int3
 15008d4: cc                           	int3
 15008d5: cc                           	int3
 15008d6: cc                           	int3
 15008d7: cc                           	int3
 15008d8: cc                           	int3
 15008d9: cc                           	int3
 15008da: cc                           	int3
 15008db: cc                           	int3
 15008dc: cc                           	int3
 15008dd: cc                           	int3
 15008de: cc                           	int3
 15008df: cc                           	int3
 15008e0: cc                           	int3
 15008e1: cc                           	int3
 15008e2: cc                           	int3
 15008e3: cc                           	int3
 15008e4: cc                           	int3
 15008e5: cc                           	int3
 15008e6: cc                           	int3
 15008e7: cc                           	int3
 15008e8: cc                           	int3
 15008e9: cc                           	int3
 15008ea: cc                           	int3
 15008eb: cc                           	int3
 15008ec: cc                           	int3
 15008ed: cc                           	int3
 15008ee: cc                           	int3
 15008ef: cc                           	int3
 15008f0: cc                           	int3
 15008f1: cc                           	int3
 15008f2: cc                           	int3
 15008f3: cc                           	int3
 15008f4: cc                           	int3
 15008f5: cc                           	int3
 15008f6: cc                           	int3
 15008f7: cc                           	int3
 15008f8: cc                           	int3
 15008f9: cc                           	int3
 15008fa: cc                           	int3
 15008fb: cc                           	int3
 15008fc: cc                           	int3
 15008fd: cc                           	int3
 15008fe: cc                           	int3
 15008ff: cc                           	int3
 1500900: cc                           	int3
 1500901: cc                           	int3
 1500902: cc                           	int3
 1500903: cc                           	int3
 1500904: cc                           	int3
 1500905: cc                           	int3
 1500906: cc                           	int3
 1500907: cc                           	int3
 1500908: cc                           	int3
 1500909: cc                           	int3
 150090a: cc                           	int3
 150090b: cc                           	int3
 150090c: cc                           	int3
 150090d: cc                           	int3
 150090e: cc                           	int3
 150090f: cc                           	int3
 1500910: cc                           	int3
 1500911: cc                           	int3
 1500912: cc                           	int3
 1500913: cc                           	int3
 1500914: cc                           	int3
 1500915: cc                           	int3
 1500916: cc                           	int3
 1500917: cc                           	int3
 1500918: cc                           	int3
 1500919: cc                           	int3
 150091a: cc                           	int3
 150091b: cc                           	int3
 150091c: cc                           	int3
 150091d: cc                           	int3
 150091e: cc                           	int3
 150091f: cc                           	int3
 1500920: cc                           	int3
 1500921: cc                           	int3
 1500922: cc                           	int3
 1500923: cc                           	int3
 1500924: cc                           	int3
 1500925: cc                           	int3
 1500926: cc                           	int3
 1500927: cc                           	int3
 1500928: cc                           	int3
 1500929: cc                           	int3
 150092a: cc                           	int3
 150092b: cc                           	int3
 150092c: cc                           	int3
 150092d: cc                           	int3
 150092e: cc                           	int3
 150092f: cc                           	int3
 1500930: cc                           	int3
 1500931: cc                           	int3
 1500932: cc                           	int3
 1500933: cc                           	int3
 1500934: cc                           	int3
 1500935: cc                           	int3
 1500936: cc                           	int3
 1500937: cc                           	int3
 1500938: cc                           	int3
 1500939: cc                           	int3
 150093a: cc                           	int3
 150093b: cc                           	int3
 150093c: cc                           	int3
 150093d: cc                           	int3
 150093e: cc                           	int3
 150093f: cc                           	int3
 1500940: cc                           	int3
 1500941: cc                           	int3
 1500942: cc                           	int3
 1500943: cc                           	int3
 1500944: cc                           	int3
 1500945: cc                           	int3
 1500946: cc                           	int3
 1500947: cc                           	int3
 1500948: cc                           	int3
 1500949: cc                           	int3
 150094a: cc                           	int3
 150094b: cc                           	int3
 150094c: cc                           	int3
 150094d: cc                           	int3
 150094e: cc                           	int3
 150094f: cc                           	int3
 1500950: cc                           	int3
 1500951: cc                           	int3
 1500952: cc                           	int3
 1500953: cc                           	int3
 1500954: cc                           	int3
 1500955: cc                           	int3
 1500956: cc                           	int3
 1500957: cc                           	int3
 1500958: cc                           	int3
 1500959: cc                           	int3
 150095a: cc                           	int3
 150095b: cc                           	int3
 150095c: cc                           	int3
 150095d: cc                           	int3
 150095e: cc                           	int3
 150095f: cc                           	int3
 1500960: cc                           	int3
 1500961: cc                           	int3
 1500962: cc                           	int3
 1500963: cc                           	int3
 1500964: cc                           	int3
 1500965: cc                           	int3
 1500966: cc                           	int3
 1500967: cc                           	int3
 1500968: cc                           	int3
 1500969: cc                           	int3
 150096a: cc                           	int3
 150096b: cc                           	int3
 150096c: cc                           	int3
 150096d: cc                           	int3
 150096e: cc                           	int3
 150096f: cc                           	int3
 1500970: cc                           	int3
 1500971: cc                           	int3
 1500972: cc                           	int3
 1500973: cc                           	int3
 1500974: cc                           	int3
 1500975: cc                           	int3
 1500976: cc                           	int3
 1500977: cc                           	int3
 1500978: cc                           	int3
 1500979: cc                           	int3
 150097a: cc                           	int3
 150097b: cc                           	int3
 150097c: cc                           	int3
 150097d: cc                           	int3
 150097e: cc                           	int3
 150097f: cc                           	int3
 1500980: cc                           	int3
 1500981: cc                           	int3
 1500982: cc                           	int3
 1500983: cc                           	int3
 1500984: cc                           	int3
 1500985: cc                           	int3
 1500986: cc                           	int3
 1500987: cc                           	int3
 1500988: cc                           	int3
 1500989: cc                           	int3
 150098a: cc                           	int3
 150098b: cc                           	int3
 150098c: cc                           	int3
 150098d: cc                           	int3
 150098e: cc                           	int3
 150098f: cc                           	int3
 1500990: cc                           	int3
 1500991: cc                           	int3
 1500992: cc                           	int3
 1500993: cc                           	int3
 1500994: cc                           	int3
 1500995: cc                           	int3
 1500996: cc                           	int3
 1500997: cc                           	int3
 1500998: cc                           	int3
 1500999: cc                           	int3
 150099a: cc                           	int3
 150099b: cc                           	int3
 150099c: cc                           	int3
 150099d: cc                           	int3
 150099e: cc                           	int3
 150099f: cc                           	int3
 15009a0: cc                           	int3
 15009a1: cc                           	int3
 15009a2: cc                           	int3
 15009a3: cc                           	int3
 15009a4: cc                           	int3
 15009a5: cc                           	int3
 15009a6: cc                           	int3
 15009a7: cc                           	int3
 15009a8: cc                           	int3
 15009a9: cc                           	int3
 15009aa: cc                           	int3
 15009ab: cc                           	int3
 15009ac: cc                           	int3
 15009ad: cc                           	int3
 15009ae: cc                           	int3
 15009af: cc                           	int3
 15009b0: cc                           	int3
 15009b1: cc                           	int3
 15009b2: cc                           	int3
 15009b3: cc                           	int3
 15009b4: cc                           	int3
 15009b5: cc                           	int3
 15009b6: cc                           	int3
 15009b7: cc                           	int3
 15009b8: cc                           	int3
 15009b9: cc                           	int3
 15009ba: cc                           	int3
 15009bb: cc                           	int3
 15009bc: cc                           	int3
 15009bd: cc                           	int3
 15009be: cc                           	int3
 15009bf: cc                           	int3
 15009c0: cc                           	int3
 15009c1: cc                           	int3
 15009c2: cc                           	int3
 15009c3: cc                           	int3
 15009c4: cc                           	int3
 15009c5: cc                           	int3
 15009c6: cc                           	int3
 15009c7: cc                           	int3
 15009c8: cc                           	int3
 15009c9: cc                           	int3
 15009ca: cc                           	int3
 15009cb: cc                           	int3
 15009cc: cc                           	int3
 15009cd: cc                           	int3
 15009ce: cc                           	int3
 15009cf: cc                           	int3
 15009d0: cc                           	int3
 15009d1: cc                           	int3
 15009d2: cc                           	int3
 15009d3: cc                           	int3
 15009d4: cc                           	int3
 15009d5: cc                           	int3
 15009d6: cc                           	int3
 15009d7: cc                           	int3
 15009d8: cc                           	int3
 15009d9: cc                           	int3
 15009da: cc                           	int3
 15009db: cc                           	int3
 15009dc: cc                           	int3
 15009dd: cc                           	int3
 15009de: cc                           	int3
 15009df: cc                           	int3
 15009e0: cc                           	int3
 15009e1: cc                           	int3
 15009e2: cc                           	int3
 15009e3: cc                           	int3
 15009e4: cc                           	int3
 15009e5: cc                           	int3
 15009e6: cc                           	int3
 15009e7: cc                           	int3
 15009e8: cc                           	int3
 15009e9: cc                           	int3
 15009ea: cc                           	int3
 15009eb: cc                           	int3
 15009ec: cc                           	int3
 15009ed: cc                           	int3
 15009ee: cc                           	int3
 15009ef: cc                           	int3
 15009f0: cc                           	int3
 15009f1: cc                           	int3
 15009f2: cc                           	int3
 15009f3: cc                           	int3
 15009f4: cc                           	int3
 15009f5: cc                           	int3
 15009f6: cc                           	int3
 15009f7: cc                           	int3
 15009f8: cc                           	int3
 15009f9: cc                           	int3
 15009fa: cc                           	int3
 15009fb: cc                           	int3
 15009fc: cc                           	int3
 15009fd: cc                           	int3
 15009fe: cc                           	int3
 15009ff: cc                           	int3
 1500a00: cc                           	int3
 1500a01: cc                           	int3
 1500a02: cc                           	int3
 1500a03: cc                           	int3
 1500a04: cc                           	int3
 1500a05: cc                           	int3
 1500a06: cc                           	int3
 1500a07: cc                           	int3
 1500a08: cc                           	int3
 1500a09: cc                           	int3
 1500a0a: cc                           	int3
 1500a0b: cc                           	int3
 1500a0c: cc                           	int3
 1500a0d: cc                           	int3
 1500a0e: cc                           	int3
 1500a0f: cc                           	int3
 1500a10: cc                           	int3
 1500a11: cc                           	int3
 1500a12: cc                           	int3
 1500a13: cc                           	int3
 1500a14: cc                           	int3
 1500a15: cc                           	int3
 1500a16: cc                           	int3
 1500a17: cc                           	int3
 1500a18: cc                           	int3
 1500a19: cc                           	int3
 1500a1a: cc                           	int3
 1500a1b: cc                           	int3
 1500a1c: cc                           	int3
 1500a1d: cc                           	int3
 1500a1e: cc                           	int3
 1500a1f: cc                           	int3
 1500a20: cc                           	int3
 1500a21: cc                           	int3
 1500a22: cc                           	int3
 1500a23: cc                           	int3
 1500a24: cc                           	int3
 1500a25: cc                           	int3
 1500a26: cc                           	int3
 1500a27: cc                           	int3
 1500a28: cc                           	int3
 1500a29: cc                           	int3
 1500a2a: cc                           	int3
 1500a2b: cc                           	int3
 1500a2c: cc                           	int3
 1500a2d: cc                           	int3
 1500a2e: cc                           	int3
 1500a2f: cc                           	int3
 1500a30: cc                           	int3
 1500a31: cc                           	int3
 1500a32: cc                           	int3
 1500a33: cc                           	int3
 1500a34: cc                           	int3
 1500a35: cc                           	int3
 1500a36: cc                           	int3
 1500a37: cc                           	int3
 1500a38: cc                           	int3
 1500a39: cc                           	int3
 1500a3a: cc                           	int3
 1500a3b: cc                           	int3
 1500a3c: cc                           	int3
 1500a3d: cc                           	int3
 1500a3e: cc                           	int3
 1500a3f: cc                           	int3
 1500a40: cc                           	int3
 1500a41: cc                           	int3
 1500a42: cc                           	int3
 1500a43: cc                           	int3
 1500a44: cc                           	int3
 1500a45: cc                           	int3
 1500a46: cc                           	int3
 1500a47: cc                           	int3
 1500a48: cc                           	int3
 1500a49: cc                           	int3
 1500a4a: cc                           	int3
 1500a4b: cc                           	int3
 1500a4c: cc                           	int3
 1500a4d: cc                           	int3
 1500a4e: cc                           	int3
 1500a4f: cc                           	int3
 1500a50: cc                           	int3
 1500a51: cc                           	int3
 1500a52: cc                           	int3
 1500a53: cc                           	int3
 1500a54: cc                           	int3
 1500a55: cc                           	int3
 1500a56: cc                           	int3
 1500a57: cc                           	int3
 1500a58: cc                           	int3
 1500a59: cc                           	int3
 1500a5a: cc                           	int3
 1500a5b: cc                           	int3
 1500a5c: cc                           	int3
 1500a5d: cc                           	int3
 1500a5e: cc                           	int3
 1500a5f: cc                           	int3
 1500a60: cc                           	int3
 1500a61: cc                           	int3
 1500a62: cc                           	int3
 1500a63: cc                           	int3
 1500a64: cc                           	int3
 1500a65: cc                           	int3
 1500a66: cc                           	int3
 1500a67: cc                           	int3
 1500a68: cc                           	int3
 1500a69: cc                           	int3
 1500a6a: cc                           	int3
 1500a6b: cc                           	int3
 1500a6c: cc                           	int3
 1500a6d: cc                           	int3
 1500a6e: cc                           	int3
 1500a6f: cc                           	int3
 1500a70: cc                           	int3
 1500a71: cc                           	int3
 1500a72: cc                           	int3
 1500a73: cc                           	int3
 1500a74: cc                           	int3
 1500a75: cc                           	int3
 1500a76: cc                           	int3
 1500a77: cc                           	int3
 1500a78: cc                           	int3
 1500a79: cc                           	int3
 1500a7a: cc                           	int3
 1500a7b: cc                           	int3
 1500a7c: cc                           	int3
 1500a7d: cc                           	int3
 1500a7e: cc                           	int3
 1500a7f: cc                           	int3
 1500a80: cc                           	int3
 1500a81: cc                           	int3
 1500a82: cc                           	int3
 1500a83: cc                           	int3
 1500a84: cc                           	int3
 1500a85: cc                           	int3
 1500a86: cc                           	int3
 1500a87: cc                           	int3
 1500a88: cc                           	int3
 1500a89: cc                           	int3
 1500a8a: cc                           	int3
 1500a8b: cc                           	int3
 1500a8c: cc                           	int3
 1500a8d: cc                           	int3
 1500a8e: cc                           	int3
 1500a8f: cc                           	int3
 1500a90: cc                           	int3
 1500a91: cc                           	int3
 1500a92: cc                           	int3
 1500a93: cc                           	int3
 1500a94: cc                           	int3
 1500a95: cc                           	int3
 1500a96: cc                           	int3
 1500a97: cc                           	int3
 1500a98: cc                           	int3
 1500a99: cc                           	int3
 1500a9a: cc                           	int3
 1500a9b: cc                           	int3
 1500a9c: cc                           	int3
 1500a9d: cc                           	int3
 1500a9e: cc                           	int3
 1500a9f: cc                           	int3
 1500aa0: cc                           	int3
 1500aa1: cc                           	int3
 1500aa2: cc                           	int3
 1500aa3: cc                           	int3
 1500aa4: cc                           	int3
 1500aa5: cc                           	int3
 1500aa6: cc                           	int3
 1500aa7: cc                           	int3
 1500aa8: cc                           	int3
 1500aa9: cc                           	int3
 1500aaa: cc                           	int3
 1500aab: cc                           	int3
 1500aac: cc                           	int3
 1500aad: cc                           	int3
 1500aae: cc                           	int3
 1500aaf: cc                           	int3
 1500ab0: cc                           	int3
 1500ab1: cc                           	int3
 1500ab2: cc                           	int3
 1500ab3: cc                           	int3
 1500ab4: cc                           	int3
 1500ab5: cc                           	int3
 1500ab6: cc                           	int3
 1500ab7: cc                           	int3
 1500ab8: cc                           	int3
 1500ab9: cc                           	int3
 1500aba: cc                           	int3
 1500abb: cc                           	int3
 1500abc: cc                           	int3
 1500abd: cc                           	int3
 1500abe: cc                           	int3
 1500abf: cc                           	int3
 1500ac0: cc                           	int3
 1500ac1: cc                           	int3
 1500ac2: cc                           	int3
 1500ac3: cc                           	int3
 1500ac4: cc                           	int3
 1500ac5: cc                           	int3
 1500ac6: cc                           	int3
 1500ac7: cc                           	int3
 1500ac8: cc                           	int3
 1500ac9: cc                           	int3
 1500aca: cc                           	int3
 1500acb: cc                           	int3
 1500acc: cc                           	int3
 1500acd: cc                           	int3
 1500ace: cc                           	int3
 1500acf: cc                           	int3
 1500ad0: cc                           	int3
 1500ad1: cc                           	int3
 1500ad2: cc                           	int3
 1500ad3: cc                           	int3
 1500ad4: cc                           	int3
 1500ad5: cc                           	int3
 1500ad6: cc                           	int3
 1500ad7: cc                           	int3
 1500ad8: cc                           	int3
 1500ad9: cc                           	int3
 1500ada: cc                           	int3
 1500adb: cc                           	int3
 1500adc: cc                           	int3
 1500add: cc                           	int3
 1500ade: cc                           	int3
 1500adf: cc                           	int3
 1500ae0: cc                           	int3
 1500ae1: cc                           	int3
 1500ae2: cc                           	int3
 1500ae3: cc                           	int3
 1500ae4: cc                           	int3
 1500ae5: cc                           	int3
 1500ae6: cc                           	int3
 1500ae7: cc                           	int3
 1500ae8: cc                           	int3
 1500ae9: cc                           	int3
 1500aea: cc                           	int3
 1500aeb: cc                           	int3
 1500aec: cc                           	int3
 1500aed: cc                           	int3
 1500aee: cc                           	int3
 1500aef: cc                           	int3
 1500af0: cc                           	int3
 1500af1: cc                           	int3
 1500af2: cc                           	int3
 1500af3: cc                           	int3
 1500af4: cc                           	int3
 1500af5: cc                           	int3
 1500af6: cc                           	int3
 1500af7: cc                           	int3
 1500af8: cc                           	int3
 1500af9: cc                           	int3
 1500afa: cc                           	int3
 1500afb: cc                           	int3
 1500afc: cc                           	int3
 1500afd: cc                           	int3
 1500afe: cc                           	int3
 1500aff: cc                           	int3
 1500b00: cc                           	int3
 1500b01: cc                           	int3
 1500b02: cc                           	int3
 1500b03: cc                           	int3
 1500b04: cc                           	int3
 1500b05: cc                           	int3
 1500b06: cc                           	int3
 1500b07: cc                           	int3
 1500b08: cc                           	int3
 1500b09: cc                           	int3
 1500b0a: cc                           	int3
 1500b0b: cc                           	int3
 1500b0c: cc                           	int3
 1500b0d: cc                           	int3
 1500b0e: cc                           	int3
 1500b0f: cc                           	int3
 1500b10: cc                           	int3
 1500b11: cc                           	int3
 1500b12: cc                           	int3
 1500b13: cc                           	int3
 1500b14: cc                           	int3
 1500b15: cc                           	int3
 1500b16: cc                           	int3
 1500b17: cc                           	int3
 1500b18: cc                           	int3
 1500b19: cc                           	int3
 1500b1a: cc                           	int3
 1500b1b: cc                           	int3
 1500b1c: cc                           	int3
 1500b1d: cc                           	int3
 1500b1e: cc                           	int3
 1500b1f: cc                           	int3
 1500b20: cc                           	int3
 1500b21: cc                           	int3
 1500b22: cc                           	int3
 1500b23: cc                           	int3
 1500b24: cc                           	int3
 1500b25: cc                           	int3
 1500b26: cc                           	int3
 1500b27: cc                           	int3
 1500b28: cc                           	int3
 1500b29: cc                           	int3
 1500b2a: cc                           	int3
 1500b2b: cc                           	int3
 1500b2c: cc                           	int3
 1500b2d: cc                           	int3
 1500b2e: cc                           	int3
 1500b2f: cc                           	int3
 1500b30: cc                           	int3
 1500b31: cc                           	int3
 1500b32: cc                           	int3
 1500b33: cc                           	int3
 1500b34: cc                           	int3
 1500b35: cc                           	int3
 1500b36: cc                           	int3
 1500b37: cc                           	int3
 1500b38: cc                           	int3
 1500b39: cc                           	int3
 1500b3a: cc                           	int3
 1500b3b: cc                           	int3
 1500b3c: cc                           	int3
 1500b3d: cc                           	int3
 1500b3e: cc                           	int3
 1500b3f: cc                           	int3
 1500b40: cc                           	int3
 1500b41: cc                           	int3
 1500b42: cc                           	int3
 1500b43: cc                           	int3
 1500b44: cc                           	int3
 1500b45: cc                           	int3
 1500b46: cc                           	int3
 1500b47: cc                           	int3
 1500b48: cc                           	int3
 1500b49: cc                           	int3
 1500b4a: cc                           	int3
 1500b4b: cc                           	int3
 1500b4c: cc                           	int3
 1500b4d: cc                           	int3
 1500b4e: cc                           	int3
 1500b4f: cc                           	int3
 1500b50: cc                           	int3
 1500b51: cc                           	int3
 1500b52: cc                           	int3
 1500b53: cc                           	int3
 1500b54: cc                           	int3
 1500b55: cc                           	int3
 1500b56: cc                           	int3
 1500b57: cc                           	int3
 1500b58: cc                           	int3
 1500b59: cc                           	int3
 1500b5a: cc                           	int3
 1500b5b: cc                           	int3
 1500b5c: cc                           	int3
 1500b5d: cc                           	int3
 1500b5e: cc                           	int3
 1500b5f: cc                           	int3
 1500b60: cc                           	int3
 1500b61: cc                           	int3
 1500b62: cc                           	int3
 1500b63: cc                           	int3
 1500b64: cc                           	int3
 1500b65: cc                           	int3
 1500b66: cc                           	int3
 1500b67: cc                           	int3
 1500b68: cc                           	int3
 1500b69: cc                           	int3
 1500b6a: cc                           	int3
 1500b6b: cc                           	int3
 1500b6c: cc                           	int3
 1500b6d: cc                           	int3
 1500b6e: cc                           	int3
 1500b6f: cc                           	int3
 1500b70: cc                           	int3
 1500b71: cc                           	int3
 1500b72: cc                           	int3
 1500b73: cc                           	int3
 1500b74: cc                           	int3
 1500b75: cc                           	int3
 1500b76: cc                           	int3
 1500b77: cc                           	int3
 1500b78: cc                           	int3
 1500b79: cc                           	int3
 1500b7a: cc                           	int3
 1500b7b: cc                           	int3
 1500b7c: cc                           	int3
 1500b7d: cc                           	int3
 1500b7e: cc                           	int3
 1500b7f: cc                           	int3
 1500b80: cc                           	int3
 1500b81: cc                           	int3
 1500b82: cc                           	int3
 1500b83: cc                           	int3
 1500b84: cc                           	int3
 1500b85: cc                           	int3
 1500b86: cc                           	int3
 1500b87: cc                           	int3
 1500b88: cc                           	int3
 1500b89: cc                           	int3
 1500b8a: cc                           	int3
 1500b8b: cc                           	int3
 1500b8c: cc                           	int3
 1500b8d: cc                           	int3
 1500b8e: cc                           	int3
 1500b8f: cc                           	int3
 1500b90: cc                           	int3
 1500b91: cc                           	int3
 1500b92: cc                           	int3
 1500b93: cc                           	int3
 1500b94: cc                           	int3
 1500b95: cc                           	int3
 1500b96: cc                           	int3
 1500b97: cc                           	int3
 1500b98: cc                           	int3
 1500b99: cc                           	int3
 1500b9a: cc                           	int3
 1500b9b: cc                           	int3
 1500b9c: cc                           	int3
 1500b9d: cc                           	int3
 1500b9e: cc                           	int3
 1500b9f: cc                           	int3
 1500ba0: cc                           	int3
 1500ba1: cc                           	int3
 1500ba2: cc                           	int3
 1500ba3: cc                           	int3
 1500ba4: cc                           	int3
 1500ba5: cc                           	int3
 1500ba6: cc                           	int3
 1500ba7: cc                           	int3
 1500ba8: cc                           	int3
 1500ba9: cc                           	int3
 1500baa: cc                           	int3
 1500bab: cc                           	int3
 1500bac: cc                           	int3
 1500bad: cc                           	int3
 1500bae: cc                           	int3
 1500baf: cc                           	int3
 1500bb0: cc                           	int3
 1500bb1: cc                           	int3
 1500bb2: cc                           	int3
 1500bb3: cc                           	int3
 1500bb4: cc                           	int3
 1500bb5: cc                           	int3
 1500bb6: cc                           	int3
 1500bb7: cc                           	int3
 1500bb8: cc                           	int3
 1500bb9: cc                           	int3
 1500bba: cc                           	int3
 1500bbb: cc                           	int3
 1500bbc: cc                           	int3
 1500bbd: cc                           	int3
 1500bbe: cc                           	int3
 1500bbf: cc                           	int3
 1500bc0: cc                           	int3
 1500bc1: cc                           	int3
 1500bc2: cc                           	int3
 1500bc3: cc                           	int3
 1500bc4: cc                           	int3
 1500bc5: cc                           	int3
 1500bc6: cc                           	int3
 1500bc7: cc                           	int3
 1500bc8: cc                           	int3
 1500bc9: cc                           	int3
 1500bca: cc                           	int3
 1500bcb: cc                           	int3
 1500bcc: cc                           	int3
 1500bcd: cc                           	int3
 1500bce: cc                           	int3
 1500bcf: cc                           	int3
 1500bd0: cc                           	int3
 1500bd1: cc                           	int3
 1500bd2: cc                           	int3
 1500bd3: cc                           	int3
 1500bd4: cc                           	int3
 1500bd5: cc                           	int3
 1500bd6: cc                           	int3
 1500bd7: cc                           	int3
 1500bd8: cc                           	int3
 1500bd9: cc                           	int3
 1500bda: cc                           	int3
 1500bdb: cc                           	int3
 1500bdc: cc                           	int3
 1500bdd: cc                           	int3
 1500bde: cc                           	int3
 1500bdf: cc                           	int3
 1500be0: cc                           	int3
 1500be1: cc                           	int3
 1500be2: cc                           	int3
 1500be3: cc                           	int3
 1500be4: cc                           	int3
 1500be5: cc                           	int3
 1500be6: cc                           	int3
 1500be7: cc                           	int3
 1500be8: cc                           	int3
 1500be9: cc                           	int3
 1500bea: cc                           	int3
 1500beb: cc                           	int3
 1500bec: cc                           	int3
 1500bed: cc                           	int3
 1500bee: cc                           	int3
 1500bef: cc                           	int3
 1500bf0: cc                           	int3
 1500bf1: cc                           	int3
 1500bf2: cc                           	int3
 1500bf3: cc                           	int3
 1500bf4: cc                           	int3
 1500bf5: cc                           	int3
 1500bf6: cc                           	int3
 1500bf7: cc                           	int3
 1500bf8: cc                           	int3
 1500bf9: cc                           	int3
 1500bfa: cc                           	int3
 1500bfb: cc                           	int3
 1500bfc: cc                           	int3
 1500bfd: cc                           	int3
 1500bfe: cc                           	int3
 1500bff: cc                           	int3
 1500c00: cc                           	int3
 1500c01: cc                           	int3
 1500c02: cc                           	int3
 1500c03: cc                           	int3
 1500c04: cc                           	int3
 1500c05: cc                           	int3
 1500c06: cc                           	int3
 1500c07: cc                           	int3
 1500c08: cc                           	int3
 1500c09: cc                           	int3
 1500c0a: cc                           	int3
 1500c0b: cc                           	int3
 1500c0c: cc                           	int3
 1500c0d: cc                           	int3
 1500c0e: cc                           	int3
 1500c0f: cc                           	int3
 1500c10: cc                           	int3
 1500c11: cc                           	int3
 1500c12: cc                           	int3
 1500c13: cc                           	int3
 1500c14: cc                           	int3
 1500c15: cc                           	int3
 1500c16: cc                           	int3
 1500c17: cc                           	int3
 1500c18: cc                           	int3
 1500c19: cc                           	int3
 1500c1a: cc                           	int3
 1500c1b: cc                           	int3
 1500c1c: cc                           	int3
 1500c1d: cc                           	int3
 1500c1e: cc                           	int3
 1500c1f: cc                           	int3
 1500c20: cc                           	int3
 1500c21: cc                           	int3
 1500c22: cc                           	int3
 1500c23: cc                           	int3
 1500c24: cc                           	int3
 1500c25: cc                           	int3
 1500c26: cc                           	int3
 1500c27: cc                           	int3
 1500c28: cc                           	int3
 1500c29: cc                           	int3
 1500c2a: cc                           	int3
 1500c2b: cc                           	int3
 1500c2c: cc                           	int3
 1500c2d: cc                           	int3
 1500c2e: cc                           	int3
 1500c2f: cc                           	int3
 1500c30: cc                           	int3
 1500c31: cc                           	int3
 1500c32: cc                           	int3
 1500c33: cc                           	int3
 1500c34: cc                           	int3
 1500c35: cc                           	int3
 1500c36: cc                           	int3
 1500c37: cc                           	int3
 1500c38: cc                           	int3
 1500c39: cc                           	int3
 1500c3a: cc                           	int3
 1500c3b: cc                           	int3
 1500c3c: cc                           	int3
 1500c3d: cc                           	int3
 1500c3e: cc                           	int3
 1500c3f: cc                           	int3
 1500c40: cc                           	int3
 1500c41: cc                           	int3
 1500c42: cc                           	int3
 1500c43: cc                           	int3
 1500c44: cc                           	int3
 1500c45: cc                           	int3
 1500c46: cc                           	int3
 1500c47: cc                           	int3
 1500c48: cc                           	int3
 1500c49: cc                           	int3
 1500c4a: cc                           	int3
 1500c4b: cc                           	int3
 1500c4c: cc                           	int3
 1500c4d: cc                           	int3
 1500c4e: cc                           	int3
 1500c4f: cc                           	int3
 1500c50: cc                           	int3
 1500c51: cc                           	int3
 1500c52: cc                           	int3
 1500c53: cc                           	int3
 1500c54: cc                           	int3
 1500c55: cc                           	int3
 1500c56: cc                           	int3
 1500c57: cc                           	int3
 1500c58: cc                           	int3
 1500c59: cc                           	int3
 1500c5a: cc                           	int3
 1500c5b: cc                           	int3
 1500c5c: cc                           	int3
 1500c5d: cc                           	int3
 1500c5e: cc                           	int3
 1500c5f: cc                           	int3
 1500c60: cc                           	int3
 1500c61: cc                           	int3
 1500c62: cc                           	int3
 1500c63: cc                           	int3
 1500c64: cc                           	int3
 1500c65: cc                           	int3
 1500c66: cc                           	int3
 1500c67: cc                           	int3
 1500c68: cc                           	int3
 1500c69: cc                           	int3
 1500c6a: cc                           	int3
 1500c6b: cc                           	int3
 1500c6c: cc                           	int3
 1500c6d: cc                           	int3
 1500c6e: cc                           	int3
 1500c6f: cc                           	int3
 1500c70: cc                           	int3
 1500c71: cc                           	int3
 1500c72: cc                           	int3
 1500c73: cc                           	int3
 1500c74: cc                           	int3
 1500c75: cc                           	int3
 1500c76: cc                           	int3
 1500c77: cc                           	int3
 1500c78: cc                           	int3
 1500c79: cc                           	int3
 1500c7a: cc                           	int3
 1500c7b: cc                           	int3
 1500c7c: cc                           	int3
 1500c7d: cc                           	int3
 1500c7e: cc                           	int3
 1500c7f: cc                           	int3
 1500c80: cc                           	int3
 1500c81: cc                           	int3
 1500c82: cc                           	int3
 1500c83: cc                           	int3
 1500c84: cc                           	int3
 1500c85: cc                           	int3
 1500c86: cc                           	int3
 1500c87: cc                           	int3
 1500c88: cc                           	int3
 1500c89: cc                           	int3
 1500c8a: cc                           	int3
 1500c8b: cc                           	int3
 1500c8c: cc                           	int3
 1500c8d: cc                           	int3
 1500c8e: cc                           	int3
 1500c8f: cc                           	int3
 1500c90: cc                           	int3
 1500c91: cc                           	int3
 1500c92: cc                           	int3
 1500c93: cc                           	int3
 1500c94: cc                           	int3
 1500c95: cc                           	int3
 1500c96: cc                           	int3
 1500c97: cc                           	int3
 1500c98: cc                           	int3
 1500c99: cc                           	int3
 1500c9a: cc                           	int3
 1500c9b: cc                           	int3
 1500c9c: cc                           	int3
 1500c9d: cc                           	int3
 1500c9e: cc                           	int3
 1500c9f: cc                           	int3
 1500ca0: cc                           	int3
 1500ca1: cc                           	int3
 1500ca2: cc                           	int3
 1500ca3: cc                           	int3
 1500ca4: cc                           	int3
 1500ca5: cc                           	int3
 1500ca6: cc                           	int3
 1500ca7: cc                           	int3
 1500ca8: cc                           	int3
 1500ca9: cc                           	int3
 1500caa: cc                           	int3
 1500cab: cc                           	int3
 1500cac: cc                           	int3
 1500cad: cc                           	int3
 1500cae: cc                           	int3
 1500caf: cc                           	int3
 1500cb0: cc                           	int3
 1500cb1: cc                           	int3
 1500cb2: cc                           	int3
 1500cb3: cc                           	int3
 1500cb4: cc                           	int3
 1500cb5: cc                           	int3
 1500cb6: cc                           	int3
 1500cb7: cc                           	int3
 1500cb8: cc                           	int3
 1500cb9: cc                           	int3
 1500cba: cc                           	int3
 1500cbb: cc                           	int3
 1500cbc: cc                           	int3
 1500cbd: cc                           	int3
 1500cbe: cc                           	int3
 1500cbf: cc                           	int3
 1500cc0: cc                           	int3
 1500cc1: cc                           	int3
 1500cc2: cc                           	int3
 1500cc3: cc                           	int3
 1500cc4: cc                           	int3
 1500cc5: cc                           	int3
 1500cc6: cc                           	int3
 1500cc7: cc                           	int3
 1500cc8: cc                           	int3
 1500cc9: cc                           	int3
 1500cca: cc                           	int3
 1500ccb: cc                           	int3
 1500ccc: cc                           	int3
 1500ccd: cc                           	int3
 1500cce: cc                           	int3
 1500ccf: cc                           	int3
 1500cd0: cc                           	int3
 1500cd1: cc                           	int3
 1500cd2: cc                           	int3
 1500cd3: cc                           	int3
 1500cd4: cc                           	int3
 1500cd5: cc                           	int3
 1500cd6: cc                           	int3
 1500cd7: cc                           	int3
 1500cd8: cc                           	int3
 1500cd9: cc                           	int3
 1500cda: cc                           	int3
 1500cdb: cc                           	int3
 1500cdc: cc                           	int3
 1500cdd: cc                           	int3
 1500cde: cc                           	int3
 1500cdf: cc                           	int3
 1500ce0: cc                           	int3
 1500ce1: cc                           	int3
 1500ce2: cc                           	int3
 1500ce3: cc                           	int3
 1500ce4: cc                           	int3
 1500ce5: cc                           	int3
 1500ce6: cc                           	int3
 1500ce7: cc                           	int3
 1500ce8: cc                           	int3
 1500ce9: cc                           	int3
 1500cea: cc                           	int3
 1500ceb: cc                           	int3
 1500cec: cc                           	int3
 1500ced: cc                           	int3
 1500cee: cc                           	int3
 1500cef: cc                           	int3
 1500cf0: cc                           	int3
 1500cf1: cc                           	int3
 1500cf2: cc                           	int3
 1500cf3: cc                           	int3
 1500cf4: cc                           	int3
 1500cf5: cc                           	int3
 1500cf6: cc                           	int3
 1500cf7: cc                           	int3
 1500cf8: cc                           	int3
 1500cf9: cc                           	int3
 1500cfa: cc                           	int3
 1500cfb: cc                           	int3
 1500cfc: cc                           	int3
 1500cfd: cc                           	int3
 1500cfe: cc                           	int3
 1500cff: cc                           	int3
 1500d00: cc                           	int3
 1500d01: cc                           	int3
 1500d02: cc                           	int3
 1500d03: cc                           	int3
 1500d04: cc                           	int3
 1500d05: cc                           	int3
 1500d06: cc                           	int3
 1500d07: cc                           	int3
 1500d08: cc                           	int3
 1500d09: cc                           	int3
 1500d0a: cc                           	int3
 1500d0b: cc                           	int3
 1500d0c: cc                           	int3
 1500d0d: cc                           	int3
 1500d0e: cc                           	int3
 1500d0f: cc                           	int3
 1500d10: cc                           	int3
 1500d11: cc                           	int3
 1500d12: cc                           	int3
 1500d13: cc                           	int3
 1500d14: cc                           	int3
 1500d15: cc                           	int3
 1500d16: cc                           	int3
 1500d17: cc                           	int3
 1500d18: cc                           	int3
 1500d19: cc                           	int3
 1500d1a: cc                           	int3
 1500d1b: cc                           	int3
 1500d1c: cc                           	int3
 1500d1d: cc                           	int3
 1500d1e: cc                           	int3
 1500d1f: cc                           	int3
 1500d20: cc                           	int3
 1500d21: cc                           	int3
 1500d22: cc                           	int3
 1500d23: cc                           	int3
 1500d24: cc                           	int3
 1500d25: cc                           	int3
 1500d26: cc                           	int3
 1500d27: cc                           	int3
 1500d28: cc                           	int3
 1500d29: cc                           	int3
 1500d2a: cc                           	int3
 1500d2b: cc                           	int3
 1500d2c: cc                           	int3
 1500d2d: cc                           	int3
 1500d2e: cc                           	int3
 1500d2f: cc                           	int3
 1500d30: cc                           	int3
 1500d31: cc                           	int3
 1500d32: cc                           	int3
 1500d33: cc                           	int3
 1500d34: cc                           	int3
 1500d35: cc                           	int3
 1500d36: cc                           	int3
 1500d37: cc                           	int3
 1500d38: cc                           	int3
 1500d39: cc                           	int3
 1500d3a: cc                           	int3
 1500d3b: cc                           	int3
 1500d3c: cc                           	int3
 1500d3d: cc                           	int3
 1500d3e: cc                           	int3
 1500d3f: cc                           	int3
 1500d40: cc                           	int3
 1500d41: cc                           	int3
 1500d42: cc                           	int3
 1500d43: cc                           	int3
 1500d44: cc                           	int3
 1500d45: cc                           	int3
 1500d46: cc                           	int3
 1500d47: cc                           	int3
 1500d48: cc                           	int3
 1500d49: cc                           	int3
 1500d4a: cc                           	int3
 1500d4b: cc                           	int3
 1500d4c: cc                           	int3
 1500d4d: cc                           	int3
 1500d4e: cc                           	int3
 1500d4f: cc                           	int3
 1500d50: cc                           	int3
 1500d51: cc                           	int3
 1500d52: cc                           	int3
 1500d53: cc                           	int3
 1500d54: cc                           	int3
 1500d55: cc                           	int3
 1500d56: cc                           	int3
 1500d57: cc                           	int3
 1500d58: cc                           	int3
 1500d59: cc                           	int3
 1500d5a: cc                           	int3
 1500d5b: cc                           	int3
 1500d5c: cc                           	int3
 1500d5d: cc                           	int3
 1500d5e: cc                           	int3
 1500d5f: cc                           	int3
 1500d60: cc                           	int3
 1500d61: cc                           	int3
 1500d62: cc                           	int3
 1500d63: cc                           	int3
 1500d64: cc                           	int3
 1500d65: cc                           	int3
 1500d66: cc                           	int3
 1500d67: cc                           	int3
 1500d68: cc                           	int3
 1500d69: cc                           	int3
 1500d6a: cc                           	int3
 1500d6b: cc                           	int3
 1500d6c: cc                           	int3
 1500d6d: cc                           	int3
 1500d6e: cc                           	int3
 1500d6f: cc                           	int3
 1500d70: cc                           	int3
 1500d71: cc                           	int3
 1500d72: cc                           	int3
 1500d73: cc                           	int3
 1500d74: cc                           	int3
 1500d75: cc                           	int3
 1500d76: cc                           	int3
 1500d77: cc                           	int3
 1500d78: cc                           	int3
 1500d79: cc                           	int3
 1500d7a: cc                           	int3
 1500d7b: cc                           	int3
 1500d7c: cc                           	int3
 1500d7d: cc                           	int3
 1500d7e: cc                           	int3
 1500d7f: cc                           	int3
 1500d80: cc                           	int3
 1500d81: cc                           	int3
 1500d82: cc                           	int3
 1500d83: cc                           	int3
 1500d84: cc                           	int3
 1500d85: cc                           	int3
 1500d86: cc                           	int3
 1500d87: cc                           	int3
 1500d88: cc                           	int3
 1500d89: cc                           	int3
 1500d8a: cc                           	int3
 1500d8b: cc                           	int3
 1500d8c: cc                           	int3
 1500d8d: cc                           	int3
 1500d8e: cc                           	int3
 1500d8f: cc                           	int3
 1500d90: cc                           	int3
 1500d91: cc                           	int3
 1500d92: cc                           	int3
 1500d93: cc                           	int3
 1500d94: cc                           	int3
 1500d95: cc                           	int3
 1500d96: cc                           	int3
 1500d97: cc                           	int3
 1500d98: cc                           	int3
 1500d99: cc                           	int3
 1500d9a: cc                           	int3
 1500d9b: cc                           	int3
 1500d9c: cc                           	int3
 1500d9d: cc                           	int3
 1500d9e: cc                           	int3
 1500d9f: cc                           	int3
 1500da0: cc                           	int3
 1500da1: cc                           	int3
 1500da2: cc                           	int3
 1500da3: cc                           	int3
 1500da4: cc                           	int3
 1500da5: cc                           	int3
 1500da6: cc                           	int3
 1500da7: cc                           	int3
 1500da8: cc                           	int3
 1500da9: cc                           	int3
 1500daa: cc                           	int3
 1500dab: cc                           	int3
 1500dac: cc                           	int3
 1500dad: cc                           	int3
 1500dae: cc                           	int3
 1500daf: cc                           	int3
 1500db0: cc                           	int3
 1500db1: cc                           	int3
 1500db2: cc                           	int3
 1500db3: cc                           	int3
 1500db4: cc                           	int3
 1500db5: cc                           	int3
 1500db6: cc                           	int3
 1500db7: cc                           	int3
 1500db8: cc                           	int3
 1500db9: cc                           	int3
 1500dba: cc                           	int3
 1500dbb: cc                           	int3
 1500dbc: cc                           	int3
 1500dbd: cc                           	int3
 1500dbe: cc                           	int3
 1500dbf: cc                           	int3
 1500dc0: cc                           	int3
 1500dc1: cc                           	int3
 1500dc2: cc                           	int3
 1500dc3: cc                           	int3
 1500dc4: cc                           	int3
 1500dc5: cc                           	int3
 1500dc6: cc                           	int3
 1500dc7: cc                           	int3
 1500dc8: cc                           	int3
 1500dc9: cc                           	int3
 1500dca: cc                           	int3
 1500dcb: cc                           	int3
 1500dcc: cc                           	int3
 1500dcd: cc                           	int3
 1500dce: cc                           	int3
 1500dcf: cc                           	int3
 1500dd0: cc                           	int3
 1500dd1: cc                           	int3
 1500dd2: cc                           	int3
 1500dd3: cc                           	int3
 1500dd4: cc                           	int3
 1500dd5: cc                           	int3
 1500dd6: cc                           	int3
 1500dd7: cc                           	int3
 1500dd8: cc                           	int3
 1500dd9: cc                           	int3
 1500dda: cc                           	int3
 1500ddb: cc                           	int3
 1500ddc: cc                           	int3
 1500ddd: cc                           	int3
 1500dde: cc                           	int3
 1500ddf: cc                           	int3
 1500de0: cc                           	int3
 1500de1: cc                           	int3
 1500de2: cc                           	int3
 1500de3: cc                           	int3
 1500de4: cc                           	int3
 1500de5: cc                           	int3
 1500de6: cc                           	int3
 1500de7: cc                           	int3
 1500de8: cc                           	int3
 1500de9: cc                           	int3
 1500dea: cc                           	int3
 1500deb: cc                           	int3
 1500dec: cc                           	int3
 1500ded: cc                           	int3
 1500dee: cc                           	int3
 1500def: cc                           	int3
 1500df0: cc                           	int3
 1500df1: cc                           	int3
 1500df2: cc                           	int3
 1500df3: cc                           	int3
 1500df4: cc                           	int3
 1500df5: cc                           	int3
 1500df6: cc                           	int3
 1500df7: cc                           	int3
 1500df8: cc                           	int3
 1500df9: cc                           	int3
 1500dfa: cc                           	int3
 1500dfb: cc                           	int3
 1500dfc: cc                           	int3
 1500dfd: cc                           	int3
 1500dfe: cc                           	int3
 1500dff: cc                           	int3
 1500e00: cc                           	int3
 1500e01: cc                           	int3
 1500e02: cc                           	int3
 1500e03: cc                           	int3
 1500e04: cc                           	int3
 1500e05: cc                           	int3
 1500e06: cc                           	int3
 1500e07: cc                           	int3
 1500e08: cc                           	int3
 1500e09: cc                           	int3
 1500e0a: cc                           	int3
 1500e0b: cc                           	int3
 1500e0c: cc                           	int3
 1500e0d: cc                           	int3
 1500e0e: cc                           	int3
 1500e0f: cc                           	int3
 1500e10: cc                           	int3
 1500e11: cc                           	int3
 1500e12: cc                           	int3
 1500e13: cc                           	int3
 1500e14: cc                           	int3
 1500e15: cc                           	int3
 1500e16: cc                           	int3
 1500e17: cc                           	int3
 1500e18: cc                           	int3
 1500e19: cc                           	int3
 1500e1a: cc                           	int3
 1500e1b: cc                           	int3
 1500e1c: cc                           	int3
 1500e1d: cc                           	int3
 1500e1e: cc                           	int3
 1500e1f: cc                           	int3
 1500e20: cc                           	int3
 1500e21: cc                           	int3
 1500e22: cc                           	int3
 1500e23: cc                           	int3
 1500e24: cc                           	int3
 1500e25: cc                           	int3
 1500e26: cc                           	int3
 1500e27: cc                           	int3
 1500e28: cc                           	int3
 1500e29: cc                           	int3
 1500e2a: cc                           	int3
 1500e2b: cc                           	int3
 1500e2c: cc                           	int3
 1500e2d: cc                           	int3
 1500e2e: cc                           	int3
 1500e2f: cc                           	int3
 1500e30: cc                           	int3
 1500e31: cc                           	int3
 1500e32: cc                           	int3
 1500e33: cc                           	int3
 1500e34: cc                           	int3
 1500e35: cc                           	int3
 1500e36: cc                           	int3
 1500e37: cc                           	int3
 1500e38: cc                           	int3
 1500e39: cc                           	int3
 1500e3a: cc                           	int3
 1500e3b: cc                           	int3
 1500e3c: cc                           	int3
 1500e3d: cc                           	int3
 1500e3e: cc                           	int3
 1500e3f: cc                           	int3
 1500e40: cc                           	int3
 1500e41: cc                           	int3
 1500e42: cc                           	int3
 1500e43: cc                           	int3
 1500e44: cc                           	int3
 1500e45: cc                           	int3
 1500e46: cc                           	int3
 1500e47: cc                           	int3
 1500e48: cc                           	int3
 1500e49: cc                           	int3
 1500e4a: cc                           	int3
 1500e4b: cc                           	int3
 1500e4c: cc                           	int3
 1500e4d: cc                           	int3
 1500e4e: cc                           	int3
 1500e4f: cc                           	int3
 1500e50: cc                           	int3
 1500e51: cc                           	int3
 1500e52: cc                           	int3
 1500e53: cc                           	int3
 1500e54: cc                           	int3
 1500e55: cc                           	int3
 1500e56: cc                           	int3
 1500e57: cc                           	int3
 1500e58: cc                           	int3
 1500e59: cc                           	int3
 1500e5a: cc                           	int3
 1500e5b: cc                           	int3
 1500e5c: cc                           	int3
 1500e5d: cc                           	int3
 1500e5e: cc                           	int3
 1500e5f: cc                           	int3
 1500e60: cc                           	int3
 1500e61: cc                           	int3
 1500e62: cc                           	int3
 1500e63: cc                           	int3
 1500e64: cc                           	int3
 1500e65: cc                           	int3
 1500e66: cc                           	int3
 1500e67: cc                           	int3
 1500e68: cc                           	int3
 1500e69: cc                           	int3
 1500e6a: cc                           	int3
 1500e6b: cc                           	int3
 1500e6c: cc                           	int3
 1500e6d: cc                           	int3
 1500e6e: cc                           	int3
 1500e6f: cc                           	int3
 1500e70: cc                           	int3
 1500e71: cc                           	int3
 1500e72: cc                           	int3
 1500e73: cc                           	int3
 1500e74: cc                           	int3
 1500e75: cc                           	int3
 1500e76: cc                           	int3
 1500e77: cc                           	int3
 1500e78: cc                           	int3
 1500e79: cc                           	int3
 1500e7a: cc                           	int3
 1500e7b: cc                           	int3
 1500e7c: cc                           	int3
 1500e7d: cc                           	int3
 1500e7e: cc                           	int3
 1500e7f: cc                           	int3
 1500e80: cc                           	int3
 1500e81: cc                           	int3
 1500e82: cc                           	int3
 1500e83: cc                           	int3
 1500e84: cc                           	int3
 1500e85: cc                           	int3
 1500e86: cc                           	int3
 1500e87: cc                           	int3
 1500e88: cc                           	int3
 1500e89: cc                           	int3
 1500e8a: cc                           	int3
 1500e8b: cc                           	int3
 1500e8c: cc                           	int3
 1500e8d: cc                           	int3
 1500e8e: cc                           	int3
 1500e8f: cc                           	int3
 1500e90: cc                           	int3
 1500e91: cc                           	int3
 1500e92: cc                           	int3
 1500e93: cc                           	int3
 1500e94: cc                           	int3
 1500e95: cc                           	int3
 1500e96: cc                           	int3
 1500e97: cc                           	int3
 1500e98: cc                           	int3
 1500e99: cc                           	int3
 1500e9a: cc                           	int3
 1500e9b: cc                           	int3
 1500e9c: cc                           	int3
 1500e9d: cc                           	int3
 1500e9e: cc                           	int3
 1500e9f: cc                           	int3
 1500ea0: cc                           	int3
 1500ea1: cc                           	int3
 1500ea2: cc                           	int3
 1500ea3: cc                           	int3
 1500ea4: cc                           	int3
 1500ea5: cc                           	int3
 1500ea6: cc                           	int3
 1500ea7: cc                           	int3
 1500ea8: cc                           	int3
 1500ea9: cc                           	int3
 1500eaa: cc                           	int3
 1500eab: cc                           	int3
 1500eac: cc                           	int3
 1500ead: cc                           	int3
 1500eae: cc                           	int3
 1500eaf: cc                           	int3
 1500eb0: cc                           	int3
 1500eb1: cc                           	int3
 1500eb2: cc                           	int3
 1500eb3: cc                           	int3
 1500eb4: cc                           	int3
 1500eb5: cc                           	int3
 1500eb6: cc                           	int3
 1500eb7: cc                           	int3
 1500eb8: cc                           	int3
 1500eb9: cc                           	int3
 1500eba: cc                           	int3
 1500ebb: cc                           	int3
 1500ebc: cc                           	int3
 1500ebd: cc                           	int3
 1500ebe: cc                           	int3
 1500ebf: cc                           	int3
 1500ec0: cc                           	int3
 1500ec1: cc                           	int3
 1500ec2: cc                           	int3
 1500ec3: cc                           	int3
 1500ec4: cc                           	int3
 1500ec5: cc                           	int3
 1500ec6: cc                           	int3
 1500ec7: cc                           	int3
 1500ec8: cc                           	int3
 1500ec9: cc                           	int3
 1500eca: cc                           	int3
 1500ecb: cc                           	int3
 1500ecc: cc                           	int3
 1500ecd: cc                           	int3
 1500ece: cc                           	int3
 1500ecf: cc                           	int3
 1500ed0: cc                           	int3
 1500ed1: cc                           	int3
 1500ed2: cc                           	int3
 1500ed3: cc                           	int3
 1500ed4: cc                           	int3
 1500ed5: cc                           	int3
 1500ed6: cc                           	int3
 1500ed7: cc                           	int3
 1500ed8: cc                           	int3
 1500ed9: cc                           	int3
 1500eda: cc                           	int3
 1500edb: cc                           	int3
 1500edc: cc                           	int3
 1500edd: cc                           	int3
 1500ede: cc                           	int3
 1500edf: cc                           	int3
 1500ee0: cc                           	int3
 1500ee1: cc                           	int3
 1500ee2: cc                           	int3
 1500ee3: cc                           	int3
 1500ee4: cc                           	int3
 1500ee5: cc                           	int3
 1500ee6: cc                           	int3
 1500ee7: cc                           	int3
 1500ee8: cc                           	int3
 1500ee9: cc                           	int3
 1500eea: cc                           	int3
 1500eeb: cc                           	int3
 1500eec: cc                           	int3
 1500eed: cc                           	int3
 1500eee: cc                           	int3
 1500eef: cc                           	int3
 1500ef0: cc                           	int3
 1500ef1: cc                           	int3
 1500ef2: cc                           	int3
 1500ef3: cc                           	int3
 1500ef4: cc                           	int3
 1500ef5: cc                           	int3
 1500ef6: cc                           	int3
 1500ef7: cc                           	int3
 1500ef8: cc                           	int3
 1500ef9: cc                           	int3
 1500efa: cc                           	int3
 1500efb: cc                           	int3
 1500efc: cc                           	int3
 1500efd: cc                           	int3
 1500efe: cc                           	int3
 1500eff: cc                           	int3
 1500f00: cc                           	int3
 1500f01: cc                           	int3
 1500f02: cc                           	int3
 1500f03: cc                           	int3
 1500f04: cc                           	int3
 1500f05: cc                           	int3
 1500f06: cc                           	int3
 1500f07: cc                           	int3
 1500f08: cc                           	int3
 1500f09: cc                           	int3
 1500f0a: cc                           	int3
 1500f0b: cc                           	int3
 1500f0c: cc                           	int3
 1500f0d: cc                           	int3
 1500f0e: cc                           	int3
 1500f0f: cc                           	int3
 1500f10: cc                           	int3
 1500f11: cc                           	int3
 1500f12: cc                           	int3
 1500f13: cc                           	int3
 1500f14: cc                           	int3
 1500f15: cc                           	int3
 1500f16: cc                           	int3
 1500f17: cc                           	int3
 1500f18: cc                           	int3
 1500f19: cc                           	int3
 1500f1a: cc                           	int3
 1500f1b: cc                           	int3
 1500f1c: cc                           	int3
 1500f1d: cc                           	int3
 1500f1e: cc                           	int3
 1500f1f: cc                           	int3
 1500f20: cc                           	int3
 1500f21: cc                           	int3
 1500f22: cc                           	int3
 1500f23: cc                           	int3
 1500f24: cc                           	int3
 1500f25: cc                           	int3
 1500f26: cc                           	int3
 1500f27: cc                           	int3
 1500f28: cc                           	int3
 1500f29: cc                           	int3
 1500f2a: cc                           	int3
 1500f2b: cc                           	int3
 1500f2c: cc                           	int3
 1500f2d: cc                           	int3
 1500f2e: cc                           	int3
 1500f2f: cc                           	int3
 1500f30: cc                           	int3
 1500f31: cc                           	int3
 1500f32: cc                           	int3
 1500f33: cc                           	int3
 1500f34: cc                           	int3
 1500f35: cc                           	int3
 1500f36: cc                           	int3
 1500f37: cc                           	int3
 1500f38: cc                           	int3
 1500f39: cc                           	int3
 1500f3a: cc                           	int3
 1500f3b: cc                           	int3
 1500f3c: cc                           	int3
 1500f3d: cc                           	int3
 1500f3e: cc                           	int3
 1500f3f: cc                           	int3
 1500f40: cc                           	int3
 1500f41: cc                           	int3
 1500f42: cc                           	int3
 1500f43: cc                           	int3
 1500f44: cc                           	int3
 1500f45: cc                           	int3
 1500f46: cc                           	int3
 1500f47: cc                           	int3
 1500f48: cc                           	int3
 1500f49: cc                           	int3
 1500f4a: cc                           	int3
 1500f4b: cc                           	int3
 1500f4c: cc                           	int3
 1500f4d: cc                           	int3
 1500f4e: cc                           	int3
 1500f4f: cc                           	int3
 1500f50: cc                           	int3
 1500f51: cc                           	int3
 1500f52: cc                           	int3
 1500f53: cc                           	int3
 1500f54: cc                           	int3
 1500f55: cc                           	int3
 1500f56: cc                           	int3
 1500f57: cc                           	int3
 1500f58: cc                           	int3
 1500f59: cc                           	int3
 1500f5a: cc                           	int3
 1500f5b: cc                           	int3
 1500f5c: cc                           	int3
 1500f5d: cc                           	int3
 1500f5e: cc                           	int3
 1500f5f: cc                           	int3
 1500f60: cc                           	int3
 1500f61: cc                           	int3
 1500f62: cc                           	int3
 1500f63: cc                           	int3
 1500f64: cc                           	int3
 1500f65: cc                           	int3
 1500f66: cc                           	int3
 1500f67: cc                           	int3
 1500f68: cc                           	int3
 1500f69: cc                           	int3
 1500f6a: cc                           	int3
 1500f6b: cc                           	int3
 1500f6c: cc                           	int3
 1500f6d: cc                           	int3
 1500f6e: cc                           	int3
 1500f6f: cc                           	int3
 1500f70: cc                           	int3
 1500f71: cc                           	int3
 1500f72: cc                           	int3
 1500f73: cc                           	int3
 1500f74: cc                           	int3
 1500f75: cc                           	int3
 1500f76: cc                           	int3
 1500f77: cc                           	int3
 1500f78: cc                           	int3
 1500f79: cc                           	int3
 1500f7a: cc                           	int3
 1500f7b: cc                           	int3
 1500f7c: cc                           	int3
 1500f7d: cc                           	int3
 1500f7e: cc                           	int3
 1500f7f: cc                           	int3
 1500f80: cc                           	int3
 1500f81: cc                           	int3
 1500f82: cc                           	int3
 1500f83: cc                           	int3
 1500f84: cc                           	int3
 1500f85: cc                           	int3
 1500f86: cc                           	int3
 1500f87: cc                           	int3
 1500f88: cc                           	int3
 1500f89: cc                           	int3
 1500f8a: cc                           	int3
 1500f8b: cc                           	int3
 1500f8c: cc                           	int3
 1500f8d: cc                           	int3
 1500f8e: cc                           	int3
 1500f8f: cc                           	int3
 1500f90: cc                           	int3
 1500f91: cc                           	int3
 1500f92: cc                           	int3
 1500f93: cc                           	int3
 1500f94: cc                           	int3
 1500f95: cc                           	int3
 1500f96: cc                           	int3
 1500f97: cc                           	int3
 1500f98: cc                           	int3
 1500f99: cc                           	int3
 1500f9a: cc                           	int3
 1500f9b: cc                           	int3
 1500f9c: cc                           	int3
 1500f9d: cc                           	int3
 1500f9e: cc                           	int3
 1500f9f: cc                           	int3
 1500fa0: cc                           	int3
 1500fa1: cc                           	int3
 1500fa2: cc                           	int3
 1500fa3: cc                           	int3
 1500fa4: cc                           	int3
 1500fa5: cc                           	int3
 1500fa6: cc                           	int3
 1500fa7: cc                           	int3
 1500fa8: cc                           	int3
 1500fa9: cc                           	int3
 1500faa: cc                           	int3
 1500fab: cc                           	int3
 1500fac: cc                           	int3
 1500fad: cc                           	int3
 1500fae: cc                           	int3
 1500faf: cc                           	int3
 1500fb0: cc                           	int3
 1500fb1: cc                           	int3
 1500fb2: cc                           	int3
 1500fb3: cc                           	int3
 1500fb4: cc                           	int3
 1500fb5: cc                           	int3
 1500fb6: cc                           	int3
 1500fb7: cc                           	int3
 1500fb8: cc                           	int3
 1500fb9: cc                           	int3
 1500fba: cc                           	int3
 1500fbb: cc                           	int3
 1500fbc: cc                           	int3
 1500fbd: cc                           	int3
 1500fbe: cc                           	int3
 1500fbf: cc                           	int3
 1500fc0: cc                           	int3
 1500fc1: cc                           	int3
 1500fc2: cc                           	int3
 1500fc3: cc                           	int3
 1500fc4: cc                           	int3
 1500fc5: cc                           	int3
 1500fc6: cc                           	int3
 1500fc7: cc                           	int3
 1500fc8: cc                           	int3
 1500fc9: cc                           	int3
 1500fca: cc                           	int3
 1500fcb: cc                           	int3
 1500fcc: cc                           	int3
 1500fcd: cc                           	int3
 1500fce: cc                           	int3
 1500fcf: cc                           	int3
 1500fd0: cc                           	int3
 1500fd1: cc                           	int3
 1500fd2: cc                           	int3
 1500fd3: cc                           	int3
 1500fd4: cc                           	int3
 1500fd5: cc                           	int3
 1500fd6: cc                           	int3
 1500fd7: cc                           	int3
 1500fd8: cc                           	int3
 1500fd9: cc                           	int3
 1500fda: cc                           	int3
 1500fdb: cc                           	int3
 1500fdc: cc                           	int3
 1500fdd: cc                           	int3
 1500fde: cc                           	int3
 1500fdf: cc                           	int3
 1500fe0: cc                           	int3
 1500fe1: cc                           	int3
 1500fe2: cc                           	int3
 1500fe3: cc                           	int3
 1500fe4: cc                           	int3
 1500fe5: cc                           	int3
 1500fe6: cc                           	int3
 1500fe7: cc                           	int3
 1500fe8: cc                           	int3
 1500fe9: cc                           	int3
 1500fea: cc                           	int3
 1500feb: cc                           	int3
 1500fec: cc                           	int3
 1500fed: cc                           	int3
 1500fee: cc                           	int3
 1500fef: cc                           	int3
 1500ff0: cc                           	int3
 1500ff1: cc                           	int3
 1500ff2: cc                           	int3
 1500ff3: cc                           	int3
 1500ff4: cc                           	int3
 1500ff5: cc                           	int3
 1500ff6: cc                           	int3
 1500ff7: cc                           	int3
 1500ff8: cc                           	int3
 1500ff9: cc                           	int3
 1500ffa: cc                           	int3
 1500ffb: cc                           	int3
 1500ffc: cc                           	int3
 1500ffd: cc                           	int3
 1500ffe: cc                           	int3
 1500fff: cc                           	int3

0000000001501000 pml4phys:
		...

0000000001502000 pdpt1:
		...

0000000001503000 pdpt2:
		...

0000000001504000 pde1:
		...

0000000001505000 pde2:
		...

0000000001506000 pdefreestart:
		...

Disassembly of section .text:

0000008041600000 entry:
;   movq %rcx, uefi_lp(%rip)
8041600000: 48 89 0d f9 6f 01 00       	movq	%rcx, 94201(%rip)
;   leaq bootstacktop(%rip),%rsp
8041600007: 48 8d 25 f2 6f 01 00       	leaq	94194(%rip), %rsp
;   xorq %rbp, %rbp      # nuke frame pointer
804160000e: 48 31 ed                   	xorq	%rbp, %rbp
;   call i386_init
8041600011: e8 2a 02 00 00             	callq	554 <i386_init>

0000008041600016 spin:
; spin:  jmp  spin
8041600016: eb fe                      	jmp	-2 <spin>

0000008041600018 _generall_syscall:
;   cli
8041600018: fa                         	cli
;   popq _g_ret(%rip)
8041600019: 8f 05 b1 19 02 00          	popq	137649(%rip)
;   popq ret_rip(%rip)
804160001f: 8f 05 bb 19 02 00          	popq	137659(%rip)
;   movq %rbp, rbp_reg(%rip)
8041600025: 48 89 2d ac 19 02 00       	movq	%rbp, 137644(%rip)
;   movq %rsp, rsp_reg(%rip)
804160002c: 48 89 25 b5 19 02 00       	movq	%rsp, 137653(%rip)
;   movq $0x0,%rbp
8041600033: 48 c7 c5 00 00 00 00       	movq	$0, %rbp
;   leaq bootstacktop(%rip),%rsp
804160003a: 48 8d 25 bf 6f 01 00       	leaq	94143(%rip), %rsp
;   pushq $GD_KD
8041600041: 6a 10                      	pushq	$16
;   pushq rsp_reg(%rip)
8041600043: ff 35 9f 19 02 00          	pushq	137631(%rip)
;   pushfq
8041600049: 9c                         	pushfq
;   orl $FL_IF, (%rsp)
804160004a: 81 0c 24 00 02 00 00       	orl	$512, (%rsp)
;   pushq $GD_KT
8041600051: 6a 08                      	pushq	$8
;   pushq ret_rip(%rip)
8041600053: ff 35 87 19 02 00          	pushq	137607(%rip)
;   pushq $0x0
8041600059: 6a 00                      	pushq	$0
;   pushq $0x0
804160005b: 6a 00                      	pushq	$0
;   pushq $0x0 // %ds
804160005d: 6a 00                      	pushq	$0
;   pushq $0x0 // %es
804160005f: 6a 00                      	pushq	$0
;   pushq %rax
8041600061: 50                         	pushq	%rax
;   pushq %rbx
8041600062: 53                         	pushq	%rbx
;   pushq %rcx
8041600063: 51                         	pushq	%rcx
;   pushq %rdx
8041600064: 52                         	pushq	%rdx
;   pushq rbp_reg(%rip)
8041600065: ff 35 6d 19 02 00          	pushq	137581(%rip)
;   pushq %rdi
804160006b: 57                         	pushq	%rdi
;   pushq %rsi
804160006c: 56                         	pushq	%rsi
;   pushq %r8
804160006d: 41 50                      	pushq	%r8
;   pushq %r9
804160006f: 41 51                      	pushq	%r9
;   pushq %r10
8041600071: 41 52                      	pushq	%r10
;   pushq %r11
8041600073: 41 53                      	pushq	%r11
;   pushq %r12
8041600075: 41 54                      	pushq	%r12
;   pushq %r13
8041600077: 41 55                      	pushq	%r13
;   pushq %r14
8041600079: 41 56                      	pushq	%r14
;   pushq %r15
804160007b: 41 57                      	pushq	%r15
;   movq  %rsp, %rdi
804160007d: 48 89 e7                   	movq	%rsp, %rdi
;   pushq _g_ret(%rip)
8041600080: ff 35 4a 19 02 00          	pushq	137546(%rip)
;   ret
8041600086: c3                         	retq

0000008041600087 sys_yield:
;   call _generall_syscall
8041600087: e8 8c ff ff ff             	callq	-116 <_generall_syscall>
;   call csys_yield
804160008c: e8 0f 3c 00 00             	callq	15375 <csys_yield>
;   jmp .
8041600091: eb fe                      	jmp	-2 <sys_yield+0xa>

0000008041600093 sys_exit:
;   leaq bootstacktop(%rip), %rsp                #загружаем адрес bootstacktop в rsp относительно rip  
8041600093: 48 8d 25 66 6f 01 00       	leaq	94054(%rip), %rsp
;   xor %ebp, %ebp                  
804160009a: 31 ed                      	xorl	%ebp, %ebp
;   call csys_exit
804160009c: e8 df 3b 00 00             	callq	15327 <csys_exit>
;   jmp .
80416000a1: eb fe                      	jmp	-2 <sys_exit+0xe>
80416000a3: cc                         	int3
80416000a4: cc                         	int3
80416000a5: cc                         	int3
80416000a6: cc                         	int3
80416000a7: cc                         	int3
80416000a8: cc                         	int3
80416000a9: cc                         	int3
80416000aa: cc                         	int3
80416000ab: cc                         	int3
80416000ac: cc                         	int3
80416000ad: cc                         	int3
80416000ae: cc                         	int3
80416000af: cc                         	int3

00000080416000b0 alloc_pde_early_boot:
; alloc_pde_early_boot(void) {
80416000b0: 55                         	pushq	%rbp
80416000b1: 48 89 e5                   	movq	%rsp, %rbp
;   if (pdefree >= (uintptr_t)&pdefreeend)
80416000b4: 48 b9 08 70 61 41 80 00 00 00      	movabsq	$550852718600, %rcx
80416000be: 48 8b 01                   	movq	(%rcx), %rax
80416000c1: 48 ba 00 c0 50 01 00 00 00 00      	movabsq	$22069248, %rdx
80416000cb: 48 39 d0                   	cmpq	%rdx, %rax
80416000ce: 73 0f                      	jae	15 <alloc_pde_early_boot+0x2f>
;   pdefree += PGSIZE;
80416000d0: 48 89 c2                   	movq	%rax, %rdx
80416000d3: 48 81 c2 00 10 00 00       	addq	$4096, %rdx
80416000da: 48 89 11                   	movq	%rdx, (%rcx)
; }
80416000dd: 5d                         	popq	%rbp
80416000de: c3                         	retq
80416000df: 31 c0                      	xorl	%eax, %eax
80416000e1: 5d                         	popq	%rbp
80416000e2: c3                         	retq
80416000e3: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416000ed: 0f 1f 00                   	nopl	(%rax)

00000080416000f0 map_addr_early_boot:
; map_addr_early_boot(uintptr_t addr, uintptr_t addr_phys, size_t sz) {
80416000f0: 55                         	pushq	%rbp
80416000f1: 48 89 e5                   	movq	%rsp, %rbp
80416000f4: 41 57                      	pushq	%r15
80416000f6: 41 56                      	pushq	%r14
80416000f8: 41 55                      	pushq	%r13
80416000fa: 41 54                      	pushq	%r12
80416000fc: 53                         	pushq	%rbx
80416000fd: 50                         	pushq	%rax
;   addr_curr      = ROUNDDOWN(addr, PTSIZE);
80416000fe: 49 89 ff                   	movq	%rdi, %r15
8041600101: 49 81 e7 00 00 e0 ff       	andq	$-2097152, %r15
;   addr_end       = ROUNDUP(addr + sz, PTSIZE);
8041600108: 4c 8d 2c 17                	leaq	(%rdi,%rdx), %r13
804160010c: 49 81 c5 ff ff 1f 00       	addq	$2097151, %r13
8041600113: 49 81 e5 00 00 e0 ff       	andq	$-2097152, %r13
;   for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
804160011a: 4d 39 ef                   	cmpq	%r13, %r15
804160011d: 0f 83 ab 00 00 00          	jae	171 <map_addr_early_boot+0xde>
8041600123: 49 89 f6                   	movq	%rsi, %r14
8041600126: 49 89 fc                   	movq	%rdi, %r12
8041600129: 48 89 f8                   	movq	%rdi, %rax
804160012c: 48 c1 e8 24                	shrq	$36, %rax
8041600130: 25 f8 0f 00 00             	andl	$4088, %eax
8041600135: 48 b9 00 10 50 01 00 00 00 00      	movabsq	$22024192, %rcx
804160013f: 48 c7 c6 00 f0 ff ff       	movq	$-4096, %rsi
8041600146: 48 8b 3c 08                	movq	(%rax,%rcx), %rdi
804160014a: 48 21 f7                   	andq	%rsi, %rdi
;   addr_curr_phys = ROUNDDOWN(addr_phys, PTSIZE);
804160014d: 49 81 e6 00 00 e0 ff       	andq	$-2097152, %r14
;   for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
8041600154: 49 c1 ec 15                	shrq	$21, %r12
8041600158: 49 81 ce 83 01 00 00       	orq	$387, %r14
804160015f: 48 89 7d d0                	movq	%rdi, -48(%rbp)
8041600163: eb 2f                      	jmp	47 <map_addr_early_boot+0xa4>
8041600165: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160016f: 90                         	nop
;     pde[PDX(addr_curr)] = addr_curr_phys | PTE_P | PTE_W | PTE_MBZ;
8041600170: 44 89 e1                   	movl	%r12d, %ecx
8041600173: 81 e1 ff 01 00 00          	andl	$511, %ecx
8041600179: 4c 89 34 c8                	movq	%r14, (%rax,%rcx,8)
;   for (; addr_curr < addr_end; addr_curr += PTSIZE, addr_curr_phys += PTSIZE) {
804160017d: 49 81 c7 00 00 20 00       	addq	$2097152, %r15
8041600184: 49 83 c4 01                	addq	$1, %r12
8041600188: 49 81 c6 00 00 20 00       	addq	$2097152, %r14
804160018f: 4d 39 ef                   	cmpq	%r13, %r15
8041600192: 73 3a                      	jae	58 <map_addr_early_boot+0xde>
;     pde = (pde_t *)PTE_ADDR(pdpt[PDPE(addr_curr)]);
8041600194: 4c 89 fb                   	movq	%r15, %rbx
8041600197: 48 c1 eb 1e                	shrq	$30, %rbx
804160019b: 81 e3 ff 01 00 00          	andl	$511, %ebx
80416001a1: 48 8b 04 df                	movq	(%rdi,%rbx,8), %rax
;     if (!pde) {
80416001a5: 48 21 f0                   	andq	%rsi, %rax
80416001a8: 75 c6                      	jne	-58 <map_addr_early_boot+0x80>
;       pde                   = alloc_pde_early_boot();
80416001aa: 48 b8 b0 00 60 41 80 00 00 00      	movabsq	$550852624560, %rax
80416001b4: ff d0                      	callq	*%rax
80416001b6: 48 c7 c6 00 f0 ff ff       	movq	$-4096, %rsi
80416001bd: 48 8b 7d d0                	movq	-48(%rbp), %rdi
;       pdpt[PDPE(addr_curr)] = ((uintptr_t)pde) | PTE_P | PTE_W;
80416001c1: 48 89 c1                   	movq	%rax, %rcx
80416001c4: 48 83 c9 03                	orq	$3, %rcx
80416001c8: 48 89 0c df                	movq	%rcx, (%rdi,%rbx,8)
80416001cc: eb a2                      	jmp	-94 <map_addr_early_boot+0x80>
; }
80416001ce: 48 83 c4 08                	addq	$8, %rsp
80416001d2: 5b                         	popq	%rbx
80416001d3: 41 5c                      	popq	%r12
80416001d5: 41 5d                      	popq	%r13
80416001d7: 41 5e                      	popq	%r14
80416001d9: 41 5f                      	popq	%r15
80416001db: 5d                         	popq	%rbp
80416001dc: c3                         	retq
80416001dd: 0f 1f 00                   	nopl	(%rax)

00000080416001e0 early_boot_pml4_init:
; early_boot_pml4_init(void) {
80416001e0: 55                         	pushq	%rbp
80416001e1: 48 89 e5                   	movq	%rsp, %rbp
80416001e4: 41 56                      	pushq	%r14
80416001e6: 53                         	pushq	%rbx
;   map_addr_early_boot((uintptr_t)uefi_lp, (uintptr_t)uefi_lp, sizeof(LOADER_PARAMS));
80416001e7: 48 bb 00 70 61 41 80 00 00 00      	movabsq	$550852718592, %rbx
80416001f1: 48 8b 3b                   	movq	(%rbx), %rdi
80416001f4: 49 be f0 00 60 41 80 00 00 00      	movabsq	$550852624624, %r14
80416001fe: ba c8 00 00 00             	movl	$200, %edx
8041600203: 48 89 fe                   	movq	%rdi, %rsi
8041600206: 41 ff d6                   	callq	*%r14
;   map_addr_early_boot((uintptr_t)uefi_lp->MemoryMap, (uintptr_t)uefi_lp->MemoryMap, uefi_lp->MemoryMapSize);
8041600209: 48 8b 03                   	movq	(%rbx), %rax
804160020c: 48 8b 78 28                	movq	40(%rax), %rdi
8041600210: 48 8b 50 38                	movq	56(%rax), %rdx
8041600214: 48 89 fe                   	movq	%rdi, %rsi
8041600217: 41 ff d6                   	callq	*%r14
;   map_addr_early_boot(FBUFFBASE, uefi_lp->FrameBufferBase, uefi_lp->FrameBufferSize);
804160021a: 48 8b 03                   	movq	(%rbx), %rax
804160021d: 48 8b 70 40                	movq	64(%rax), %rsi
8041600221: 8b 50 48                   	movl	72(%rax), %edx
8041600224: 48 bf 00 00 c0 3e 80 00 00 00      	movabsq	$550808584192, %rdi
804160022e: 41 ff d6                   	callq	*%r14
; }
8041600231: 5b                         	popq	%rbx
8041600232: 41 5e                      	popq	%r14
8041600234: 5d                         	popq	%rbp
8041600235: c3                         	retq
8041600236: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)

0000008041600240 i386_init:
; i386_init(void) {
8041600240: 55                         	pushq	%rbp
8041600241: 48 89 e5                   	movq	%rsp, %rbp
8041600244: 41 57                      	pushq	%r15
8041600246: 41 56                      	pushq	%r14
8041600248: 53                         	pushq	%rbx
8041600249: 50                         	pushq	%rax
;   early_boot_pml4_init();
804160024a: 48 b8 e0 01 60 41 80 00 00 00      	movabsq	$550852624864, %rax
8041600254: ff d0                      	callq	*%rax
;   cons_init();
8041600256: 48 b8 40 08 60 41 80 00 00 00      	movabsq	$550852626496, %rax
8041600260: ff d0                      	callq	*%rax
;   cprintf("6828 decimal is %o octal!\n", 6828);
8041600262: 48 bf 0b 56 60 41 80 00 00 00      	movabsq	$550852646411, %rdi
804160026c: 49 be 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %r14
8041600276: be ac 1a 00 00             	movl	$6828, %esi
804160027b: 31 c0                      	xorl	%eax, %eax
804160027d: 41 ff d6                   	callq	*%r14
;   cprintf("END: %p\n", end);
8041600280: 48 bf 9d 57 60 41 80 00 00 00      	movabsq	$550852646813, %rdi
804160028a: 48 be 00 40 62 41 80 00 00 00      	movabsq	$550852771840, %rsi
8041600294: 31 c0                      	xorl	%eax, %eax
8041600296: 41 ff d6                   	callq	*%r14
;   while (ctor < &__ctors_end) {
8041600299: 49 bf 90 13 62 41 80 00 00 00      	movabsq	$550852760464, %r15
80416002a3: 48 bb 90 13 62 41 80 00 00 00      	movabsq	$550852760464, %rbx
80416002ad: 4c 39 fb                   	cmpq	%r15, %rbx
80416002b0: 73 0d                      	jae	13 <i386_init+0x7f>
;     (*ctor)();
80416002b2: 31 c0                      	xorl	%eax, %eax
80416002b4: ff 13                      	callq	*(%rbx)
;     ctor++;
80416002b6: 48 83 c3 08                	addq	$8, %rbx
80416002ba: 4c 39 fb                   	cmpq	%r15, %rbx
;   while (ctor < &__ctors_end) {
80416002bd: 72 f3                      	jb	-13 <i386_init+0x72>
;   fb_init();
80416002bf: 48 b8 10 06 60 41 80 00 00 00      	movabsq	$550852625936, %rax
80416002c9: ff d0                      	callq	*%rax
;   cprintf("Framebuffer initialised\n");
80416002cb: 48 bf cb 57 60 41 80 00 00 00      	movabsq	$550852646859, %rdi
80416002d5: 31 c0                      	xorl	%eax, %eax
80416002d7: 41 ff d6                   	callq	*%r14
;   env_init();
80416002da: 48 b8 40 38 60 41 80 00 00 00      	movabsq	$550852638784, %rax
80416002e4: ff d0                      	callq	*%rax
;   ENV_CREATE_KERNEL_TYPE(prog_test1);
80416002e6: 48 bf 80 73 61 41 80 00 00 00      	movabsq	$550852719488, %rdi
80416002f0: 48 bb 50 3a 60 41 80 00 00 00      	movabsq	$550852639312, %rbx
80416002fa: be 01 00 00 00             	movl	$1, %esi
80416002ff: ff d3                      	callq	*%rbx
;   ENV_CREATE_KERNEL_TYPE(prog_test2);
8041600301: 48 bf 50 a8 61 41 80 00 00 00      	movabsq	$550852733008, %rdi
804160030b: be 01 00 00 00             	movl	$1, %esi
8041600310: ff d3                      	callq	*%rbx
;   ENV_CREATE_KERNEL_TYPE(prog_test3);
8041600312: 48 bf 40 de 61 41 80 00 00 00      	movabsq	$550852746816, %rdi
804160031c: be 01 00 00 00             	movl	$1, %esi
8041600321: ff d3                      	callq	*%rbx
;   sched_yield();
8041600323: 48 b8 d0 40 60 41 80 00 00 00      	movabsq	$550852640976, %rax
804160032d: ff d0                      	callq	*%rax
804160032f: 90                         	nop

0000008041600330 _panic:
; _panic(const char *file, int line, const char *fmt, ...) {
8041600330: 55                         	pushq	%rbp
8041600331: 48 89 e5                   	movq	%rsp, %rbp
8041600334: 41 56                      	pushq	%r14
8041600336: 53                         	pushq	%rbx
8041600337: 48 81 ec d0 00 00 00       	subq	$208, %rsp
804160033e: 48 89 d3                   	movq	%rdx, %rbx
8041600341: 89 f2                      	movl	%esi, %edx
8041600343: 48 89 fe                   	movq	%rdi, %rsi
8041600346: 84 c0                      	testb	%al, %al
8041600348: 74 29                      	je	41 <_panic+0x43>
804160034a: 0f 29 85 50 ff ff ff       	movaps	%xmm0, -176(%rbp)
8041600351: 0f 29 8d 60 ff ff ff       	movaps	%xmm1, -160(%rbp)
8041600358: 0f 29 95 70 ff ff ff       	movaps	%xmm2, -144(%rbp)
804160035f: 0f 29 5d 80                	movaps	%xmm3, -128(%rbp)
8041600363: 0f 29 65 90                	movaps	%xmm4, -112(%rbp)
8041600367: 0f 29 6d a0                	movaps	%xmm5, -96(%rbp)
804160036b: 0f 29 75 b0                	movaps	%xmm6, -80(%rbp)
804160036f: 0f 29 7d c0                	movaps	%xmm7, -64(%rbp)
8041600373: 48 89 8d 38 ff ff ff       	movq	%rcx, -200(%rbp)
804160037a: 4c 89 85 40 ff ff ff       	movq	%r8, -192(%rbp)
8041600381: 4c 89 8d 48 ff ff ff       	movq	%r9, -184(%rbp)
;   if (panicstr)
8041600388: 48 b8 90 13 62 41 80 00 00 00      	movabsq	$550852760464, %rax
8041600392: 48 83 38 00                	cmpq	$0, (%rax)
8041600396: 75 61                      	jne	97 <_panic+0xc9>
;   panicstr = fmt;
8041600398: 48 89 18                   	movq	%rbx, (%rax)
;   __asm __volatile("cli; cld");
804160039b: fa                         	cli
804160039c: fc                         	cld
804160039d: 48 8d 85 20 ff ff ff       	leaq	-224(%rbp), %rax
;   va_start(ap, fmt);
80416003a4: 48 89 45 e0                	movq	%rax, -32(%rbp)
80416003a8: 48 8d 45 10                	leaq	16(%rbp), %rax
80416003ac: 48 89 45 d8                	movq	%rax, -40(%rbp)
80416003b0: 48 b8 18 00 00 00 30 00 00 00      	movabsq	$206158430232, %rax
80416003ba: 48 89 45 d0                	movq	%rax, -48(%rbp)
;   cprintf("kernel panic at %s:%d: ", file, line);
80416003be: 48 bf b5 55 60 41 80 00 00 00      	movabsq	$550852646325, %rdi
80416003c8: 49 be 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %r14
80416003d2: 31 c0                      	xorl	%eax, %eax
80416003d4: 41 ff d6                   	callq	*%r14
;   vcprintf(fmt, ap);
80416003d7: 48 b8 d0 3f 60 41 80 00 00 00      	movabsq	$550852640720, %rax
80416003e1: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
80416003e5: 48 89 df                   	movq	%rbx, %rdi
80416003e8: ff d0                      	callq	*%rax
;   cprintf("\n");
80416003ea: 48 bf 25 59 60 41 80 00 00 00      	movabsq	$550852647205, %rdi
80416003f4: 31 c0                      	xorl	%eax, %eax
80416003f6: 41 ff d6                   	callq	*%r14
80416003f9: 48 bb c0 35 60 41 80 00 00 00      	movabsq	$550852638144, %rbx
8041600403: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160040d: 0f 1f 00                   	nopl	(%rax)
;     monitor(NULL);
8041600410: 31 ff                      	xorl	%edi, %edi
8041600412: ff d3                      	callq	*%rbx
;   while (1)
8041600414: eb fa                      	jmp	-6 <_panic+0xe0>
8041600416: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)

0000008041600420 _warn:
; _warn(const char *file, int line, const char *fmt, ...) {
8041600420: 55                         	pushq	%rbp
8041600421: 48 89 e5                   	movq	%rsp, %rbp
8041600424: 41 56                      	pushq	%r14
8041600426: 53                         	pushq	%rbx
8041600427: 48 81 ec d0 00 00 00       	subq	$208, %rsp
804160042e: 49 89 d6                   	movq	%rdx, %r14
8041600431: 89 f2                      	movl	%esi, %edx
8041600433: 48 89 fe                   	movq	%rdi, %rsi
8041600436: 84 c0                      	testb	%al, %al
8041600438: 74 29                      	je	41 <_warn+0x43>
804160043a: 0f 29 85 50 ff ff ff       	movaps	%xmm0, -176(%rbp)
8041600441: 0f 29 8d 60 ff ff ff       	movaps	%xmm1, -160(%rbp)
8041600448: 0f 29 95 70 ff ff ff       	movaps	%xmm2, -144(%rbp)
804160044f: 0f 29 5d 80                	movaps	%xmm3, -128(%rbp)
8041600453: 0f 29 65 90                	movaps	%xmm4, -112(%rbp)
8041600457: 0f 29 6d a0                	movaps	%xmm5, -96(%rbp)
804160045b: 0f 29 75 b0                	movaps	%xmm6, -80(%rbp)
804160045f: 0f 29 7d c0                	movaps	%xmm7, -64(%rbp)
8041600463: 48 89 8d 38 ff ff ff       	movq	%rcx, -200(%rbp)
804160046a: 4c 89 85 40 ff ff ff       	movq	%r8, -192(%rbp)
8041600471: 4c 89 8d 48 ff ff ff       	movq	%r9, -184(%rbp)
8041600478: 48 8d 85 20 ff ff ff       	leaq	-224(%rbp), %rax
;   va_start(ap, fmt);
804160047f: 48 89 45 e0                	movq	%rax, -32(%rbp)
8041600483: 48 8d 45 10                	leaq	16(%rbp), %rax
8041600487: 48 89 45 d8                	movq	%rax, -40(%rbp)
804160048b: 48 b8 18 00 00 00 30 00 00 00      	movabsq	$206158430232, %rax
8041600495: 48 89 45 d0                	movq	%rax, -48(%rbp)
;   cprintf("kernel warning at %s:%d: ", file, line);
8041600499: 48 bf 27 59 60 41 80 00 00 00      	movabsq	$550852647207, %rdi
80416004a3: 48 bb 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rbx
80416004ad: 31 c0                      	xorl	%eax, %eax
80416004af: ff d3                      	callq	*%rbx
;   vcprintf(fmt, ap);
80416004b1: 48 b8 d0 3f 60 41 80 00 00 00      	movabsq	$550852640720, %rax
80416004bb: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
80416004bf: 4c 89 f7                   	movq	%r14, %rdi
80416004c2: ff d0                      	callq	*%rax
;   cprintf("\n");
80416004c4: 48 bf 25 59 60 41 80 00 00 00      	movabsq	$550852647205, %rdi
80416004ce: 31 c0                      	xorl	%eax, %eax
80416004d0: ff d3                      	callq	*%rbx
; }
80416004d2: 48 81 c4 d0 00 00 00       	addq	$208, %rsp
80416004d9: 5b                         	popq	%rbx
80416004da: 41 5e                      	popq	%r14
80416004dc: 5d                         	popq	%rbp
80416004dd: c3                         	retq
80416004de: cc                         	int3
80416004df: cc                         	int3

00000080416004e0 draw_char:
; draw_char(uint32_t *buffer, uint32_t x, uint32_t y, uint32_t color, char charcode) {
80416004e0: 55                         	pushq	%rbp
80416004e1: 48 89 e5                   	movq	%rsp, %rbp
80416004e4: 53                         	pushq	%rbx
;   char *p = &(font8x8_basic[pos][0]); // Size of a font's character
80416004e5: 4d 63 c0                   	movslq	%r8d, %r8
80416004e8: 48 b8 98 13 62 41 80 00 00 00      	movabsq	$550852760472, %rax
80416004f2: 44 8b 10                   	movl	(%rax), %r10d
80416004f5: c1 e6 03                   	shll	$3, %esi
;   for (int h = 0; h < 8; h++) {
80416004f8: 41 0f af d2                	imull	%r10d, %edx
80416004fc: 8d 14 d6                   	leal	(%rsi,%rdx,8), %edx
80416004ff: 45 31 db                   	xorl	%r11d, %r11d
8041600502: 49 b9 80 5b 60 41 80 00 00 00      	movabsq	$550852647808, %r9
804160050c: eb 0f                      	jmp	15 <draw_char+0x3d>
804160050e: 66 90                      	nop
8041600510: 49 83 c3 01                	addq	$1, %r11
8041600514: 4c 01 d2                   	addq	%r10, %rdx
8041600517: 49 83 fb 08                	cmpq	$8, %r11
804160051b: 74 2a                      	je	42 <draw_char+0x67>
804160051d: 4b 8d 04 c3                	leaq	(%r11,%r8,8), %rax
8041600521: 41 0f be 04 01             	movsbl	(%r9,%rax), %eax
8041600526: 31 f6                      	xorl	%esi, %esi
8041600528: eb 10                      	jmp	16 <draw_char+0x5a>
804160052a: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
;     for (int w = 0; w < 8; w++) {
8041600530: 48 83 c6 01                	addq	$1, %rsi
8041600534: 48 83 fe 08                	cmpq	$8, %rsi
8041600538: 74 d6                      	je	-42 <draw_char+0x30>
;       if ((p[h] >> (w)) & 1) {
804160053a: 0f a3 f0                   	btl	%esi, %eax
804160053d: 73 f1                      	jae	-15 <draw_char+0x50>
;         buffer[uefi_hres * SYMBOL_SIZE * y + uefi_hres * h + SYMBOL_SIZE * x + w] = color;
804160053f: 8d 1c 32                   	leal	(%rdx,%rsi), %ebx
8041600542: 89 0c 9f                   	movl	%ecx, (%rdi,%rbx,4)
8041600545: eb e9                      	jmp	-23 <draw_char+0x50>
; }
8041600547: 5b                         	popq	%rbx
8041600548: 5d                         	popq	%rbp
8041600549: c3                         	retq
804160054a: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)

0000008041600550 serial_intr:
; serial_intr(void) {
8041600550: 55                         	pushq	%rbp
8041600551: 48 89 e5                   	movq	%rsp, %rbp
;   if (serial_exists)
8041600554: 48 b8 9c 13 62 41 80 00 00 00      	movabsq	$550852760476, %rax
804160055e: 80 38 00                   	cmpb	$0, (%rax)
8041600561: 74 16                      	je	22 <serial_intr+0x29>
;     cons_intr(serial_proc_data);
8041600563: 48 bf e0 05 60 41 80 00 00 00      	movabsq	$550852625888, %rdi
804160056d: 48 b8 80 05 60 41 80 00 00 00      	movabsq	$550852625792, %rax
8041600577: ff d0                      	callq	*%rax
; }
8041600579: 5d                         	popq	%rbp
804160057a: c3                         	retq
804160057b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041600580 cons_intr:
; cons_intr(int (*proc)(void)) {
8041600580: 55                         	pushq	%rbp
8041600581: 48 89 e5                   	movq	%rsp, %rbp
8041600584: 41 56                      	pushq	%r14
8041600586: 53                         	pushq	%rbx
8041600587: 49 89 fe                   	movq	%rdi, %r14
804160058a: 48 bb b0 13 62 41 80 00 00 00      	movabsq	$550852760496, %rbx
8041600594: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160059e: 66 90                      	nop
;   while ((c = (*proc)()) != -1) {
80416005a0: 41 ff d6                   	callq	*%r14
80416005a3: 85 c0                      	testl	%eax, %eax
80416005a5: 74 f9                      	je	-7 <cons_intr+0x20>
80416005a7: 83 f8 ff                   	cmpl	$-1, %eax
80416005aa: 74 2a                      	je	42 <cons_intr+0x56>
;     cons.buf[cons.wpos++] = c;
80416005ac: 8b 8b 04 02 00 00          	movl	516(%rbx), %ecx
80416005b2: 8d 51 01                   	leal	1(%rcx), %edx
80416005b5: 89 93 04 02 00 00          	movl	%edx, 516(%rbx)
80416005bb: 88 04 19                   	movb	%al, (%rcx,%rbx)
;     if (cons.wpos == CONSBUFSIZE)
80416005be: 81 bb 04 02 00 00 00 02 00 00      	cmpl	$512, 516(%rbx)
80416005c8: 75 d6                      	jne	-42 <cons_intr+0x20>
;       cons.wpos = 0;
80416005ca: c7 83 04 02 00 00 00 00 00 00      	movl	$0, 516(%rbx)
80416005d4: eb ca                      	jmp	-54 <cons_intr+0x20>
; }
80416005d6: 5b                         	popq	%rbx
80416005d7: 41 5e                      	popq	%r14
80416005d9: 5d                         	popq	%rbp
80416005da: c3                         	retq
80416005db: 0f 1f 44 00 00             	nopl	(%rax,%rax)

00000080416005e0 serial_proc_data:
; serial_proc_data(void) {
80416005e0: 55                         	pushq	%rbp
80416005e1: 48 89 e5                   	movq	%rsp, %rbp
;   __asm __volatile("inb %w1,%0"
80416005e4: ba fd 03 00 00             	movl	$1021, %edx
80416005e9: ec                         	inb	%dx, %al
80416005ea: 89 c1                      	movl	%eax, %ecx
80416005ec: b8 ff ff ff ff             	movl	$4294967295, %eax
;   if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
80416005f1: f6 c1 01                   	testb	$1, %cl
80416005f4: 74 09                      	je	9 <serial_proc_data+0x1f>
;   __asm __volatile("inb %w1,%0"
80416005f6: ba f8 03 00 00             	movl	$1016, %edx
80416005fb: ec                         	inb	%dx, %al
;   return inb(COM1 + COM_RX);
80416005fc: 0f b6 c0                   	movzbl	%al, %eax
; }
80416005ff: 5d                         	popq	%rbp
8041600600: c3                         	retq
8041600601: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160060b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041600610 fb_init:
; fb_init(void) {
8041600610: 55                         	pushq	%rbp
8041600611: 48 89 e5                   	movq	%rsp, %rbp
;   LOADER_PARAMS *lp = (LOADER_PARAMS *)uefi_lp;
8041600614: 48 b8 00 70 61 41 80 00 00 00      	movabsq	$550852718592, %rax
804160061e: 48 8b 00                   	movq	(%rax), %rax
;   uefi_vres         = lp->VerticalResolution;
8041600621: 8b 48 4c                   	movl	76(%rax), %ecx
8041600624: 48 ba a0 13 62 41 80 00 00 00      	movabsq	$550852760480, %rdx
804160062e: 89 0a                      	movl	%ecx, (%rdx)
;   uefi_hres         = lp->HorizontalResolution;
8041600630: 8b 50 50                   	movl	80(%rax), %edx
8041600633: 48 be 98 13 62 41 80 00 00 00      	movabsq	$550852760472, %rsi
804160063d: 89 16                      	movl	%edx, (%rsi)
;   crt_rows          = uefi_vres / SYMBOL_SIZE;
804160063f: c1 e9 03                   	shrl	$3, %ecx
;   crt_cols          = uefi_hres / SYMBOL_SIZE;
8041600642: c1 ea 03                   	shrl	$3, %edx
8041600645: 48 be a4 13 62 41 80 00 00 00      	movabsq	$550852760484, %rsi
804160064f: 89 16                      	movl	%edx, (%rsi)
;   crt_size          = crt_rows * crt_cols;
8041600651: 0f af ca                   	imull	%edx, %ecx
8041600654: 48 be a8 13 62 41 80 00 00 00      	movabsq	$550852760488, %rsi
804160065e: 89 0e                      	movl	%ecx, (%rsi)
;   crt_pos           = crt_cols;
8041600660: 48 b9 ac 13 62 41 80 00 00 00      	movabsq	$550852760492, %rcx
804160066a: 66 89 11                   	movw	%dx, (%rcx)
;   memset(crt_buf, 0, lp->FrameBufferSize);
804160066d: 8b 50 48                   	movl	72(%rax), %edx
8041600670: 48 b8 10 52 60 41 80 00 00 00      	movabsq	$550852645392, %rax
804160067a: 48 bf 00 00 c0 3e 80 00 00 00      	movabsq	$550808584192, %rdi
8041600684: 31 f6                      	xorl	%esi, %esi
8041600686: ff d0                      	callq	*%rax
;   graphics_exists = true;
8041600688: 48 b8 ae 13 62 41 80 00 00 00      	movabsq	$550852760494, %rax
8041600692: c6 00 01                   	movb	$1, (%rax)
; }
8041600695: 5d                         	popq	%rbp
8041600696: c3                         	retq
8041600697: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)

00000080416006a0 kbd_intr:
; kbd_intr(void) {
80416006a0: 55                         	pushq	%rbp
80416006a1: 48 89 e5                   	movq	%rsp, %rbp
;   cons_intr(kbd_proc_data);
80416006a4: 48 bf c0 06 60 41 80 00 00 00      	movabsq	$550852626112, %rdi
80416006ae: 48 b8 80 05 60 41 80 00 00 00      	movabsq	$550852625792, %rax
80416006b8: ff d0                      	callq	*%rax
; }
80416006ba: 5d                         	popq	%rbp
80416006bb: c3                         	retq
80416006bc: 0f 1f 40 00                	nopl	(%rax)

00000080416006c0 kbd_proc_data:
; kbd_proc_data(void) {
80416006c0: 55                         	pushq	%rbp
80416006c1: 48 89 e5                   	movq	%rsp, %rbp
80416006c4: 53                         	pushq	%rbx
80416006c5: 50                         	pushq	%rax
;   __asm __volatile("inb %w1,%0"
80416006c6: ba 64 00 00 00             	movl	$100, %edx
80416006cb: ec                         	inb	%dx, %al
80416006cc: bb ff ff ff ff             	movl	$4294967295, %ebx
;   if ((inb(KBSTATP) & KBS_DIB) == 0)
80416006d1: a8 01                      	testb	$1, %al
80416006d3: 0f 84 f1 00 00 00          	je	241 <kbd_proc_data+0x10a>
;   __asm __volatile("inb %w1,%0"
80416006d9: ba 60 00 00 00             	movl	$96, %edx
80416006de: ec                         	inb	%dx, %al
;   if (data == 0xE0) {
80416006df: 3c e0                      	cmpb	$-32, %al
80416006e1: 75 14                      	jne	20 <kbd_proc_data+0x37>
;     shift |= E0ESC;
80416006e3: 48 b8 b8 15 62 41 80 00 00 00      	movabsq	$550852761016, %rax
80416006ed: 80 08 40                   	orb	$64, (%rax)
80416006f0: 31 db                      	xorl	%ebx, %ebx
80416006f2: e9 d3 00 00 00             	jmp	211 <kbd_proc_data+0x10a>
80416006f7: 48 b9 b8 15 62 41 80 00 00 00      	movabsq	$550852761016, %rcx
8041600701: 8b 11                      	movl	(%rcx), %edx
;   } else if (data & 0x80) {
8041600703: 84 c0                      	testb	%al, %al
8041600705: 78 59                      	js	89 <kbd_proc_data+0xa0>
8041600707: f6 c2 40                   	testb	$64, %dl
;   } else if (shift & E0ESC) {
804160070a: 74 07                      	je	7 <kbd_proc_data+0x53>
;     data |= 0x80;
804160070c: 0c 80                      	orb	$-128, %al
;     shift &= ~E0ESC;
804160070e: 83 e2 bf                   	andl	$-65, %edx
8041600711: 89 11                      	movl	%edx, (%rcx)
;   shift |= shiftcode[data];
8041600713: 0f b6 d0                   	movzbl	%al, %edx
8041600716: 48 b8 a0 5f 60 41 80 00 00 00      	movabsq	$550852648864, %rax
8041600720: 0f b6 34 02                	movzbl	(%rdx,%rax), %esi
8041600724: 0b 31                      	orl	(%rcx), %esi
;   shift ^= togglecode[data];
8041600726: 48 b8 a0 60 60 41 80 00 00 00      	movabsq	$550852649120, %rax
8041600730: 0f b6 04 02                	movzbl	(%rdx,%rax), %eax
8041600734: 31 f0                      	xorl	%esi, %eax
8041600736: 89 01                      	movl	%eax, (%rcx)
;   c = charcode[shift & (CTL | SHIFT)][data];
8041600738: 89 c1                      	movl	%eax, %ecx
804160073a: 83 e1 03                   	andl	$3, %ecx
804160073d: 48 be 80 5f 60 41 80 00 00 00      	movabsq	$550852648832, %rsi
8041600747: 48 8b 0c ce                	movq	(%rsi,%rcx,8), %rcx
804160074b: 0f b6 1c 11                	movzbl	(%rcx,%rdx), %ebx
;   if (shift & CAPSLOCK) {
804160074f: a8 08                      	testb	$8, %al
8041600751: 74 47                      	je	71 <kbd_proc_data+0xda>
;     if ('a' <= c && c <= 'z')
8041600753: 8d 4b 9f                   	leal	-97(%rbx), %ecx
8041600756: 80 f9 19                   	cmpb	$25, %cl
8041600759: 77 31                      	ja	49 <kbd_proc_data+0xcc>
;       c += 'A' - 'a';
804160075b: 83 c3 e0                   	addl	$-32, %ebx
804160075e: eb 3a                      	jmp	58 <kbd_proc_data+0xda>
;     data = (shift & E0ESC ? data : data & 0x7F);
8041600760: 0f b6 f0                   	movzbl	%al, %esi
8041600763: 24 7f                      	andb	$127, %al
8041600765: 0f b6 c0                   	movzbl	%al, %eax
8041600768: f6 c2 40                   	testb	$64, %dl
804160076b: 0f 45 c6                   	cmovnel	%esi, %eax
;     shift &= ~(shiftcode[data] | E0ESC);
804160076e: 0f b6 c0                   	movzbl	%al, %eax
8041600771: 48 be a0 5f 60 41 80 00 00 00      	movabsq	$550852648864, %rsi
804160077b: 0f b6 04 30                	movzbl	(%rax,%rsi), %eax
804160077f: f7 d0                      	notl	%eax
8041600781: 21 d0                      	andl	%edx, %eax
8041600783: 83 e0 bf                   	andl	$-65, %eax
8041600786: 89 01                      	movl	%eax, (%rcx)
8041600788: 31 db                      	xorl	%ebx, %ebx
804160078a: eb 3e                      	jmp	62 <kbd_proc_data+0x10a>
;     else if ('A' <= c && c <= 'Z')
804160078c: 8d 4b bf                   	leal	-65(%rbx), %ecx
;       c += 'a' - 'A';
804160078f: 8d 53 20                   	leal	32(%rbx), %edx
;     else if ('A' <= c && c <= 'Z')
8041600792: 80 f9 1a                   	cmpb	$26, %cl
8041600795: 0f 43 d3                   	cmovael	%ebx, %edx
8041600798: 89 d3                      	movl	%edx, %ebx
;   if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
804160079a: 83 e0 06                   	andl	$6, %eax
804160079d: 83 f8 06                   	cmpl	$6, %eax
80416007a0: 75 28                      	jne	40 <kbd_proc_data+0x10a>
80416007a2: 81 fb e9 00 00 00          	cmpl	$233, %ebx
80416007a8: 75 20                      	jne	32 <kbd_proc_data+0x10a>
;     cprintf("Rebooting!\n");
80416007aa: 48 bf 2f 56 60 41 80 00 00 00      	movabsq	$550852646447, %rdi
80416007b4: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
80416007be: 31 c0                      	xorl	%eax, %eax
80416007c0: ff d1                      	callq	*%rcx
;   __asm __volatile("outb %0,%w1"
80416007c2: b0 03                      	movb	$3, %al
80416007c4: ba 92 00 00 00             	movl	$146, %edx
80416007c9: ee                         	outb	%al, %dx
; }
80416007ca: 89 d8                      	movl	%ebx, %eax
80416007cc: 48 83 c4 08                	addq	$8, %rsp
80416007d0: 5b                         	popq	%rbx
80416007d1: 5d                         	popq	%rbp
80416007d2: c3                         	retq
80416007d3: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416007dd: 0f 1f 00                   	nopl	(%rax)

00000080416007e0 cons_getc:
; cons_getc(void) {
80416007e0: 55                         	pushq	%rbp
80416007e1: 48 89 e5                   	movq	%rsp, %rbp
;   serial_intr();
80416007e4: 48 b8 50 05 60 41 80 00 00 00      	movabsq	$550852625744, %rax
80416007ee: ff d0                      	callq	*%rax
;   kbd_intr();
80416007f0: 48 b8 a0 06 60 41 80 00 00 00      	movabsq	$550852626080, %rax
80416007fa: ff d0                      	callq	*%rax
80416007fc: 48 b9 b0 13 62 41 80 00 00 00      	movabsq	$550852760496, %rcx
;   if (cons.rpos != cons.wpos) {
8041600806: 8b 91 00 02 00 00          	movl	512(%rcx), %edx
804160080c: 31 c0                      	xorl	%eax, %eax
804160080e: 3b 91 04 02 00 00          	cmpl	516(%rcx), %edx
8041600814: 74 1e                      	je	30 <cons_getc+0x54>
;     c = cons.buf[cons.rpos++];
8041600816: 8d 72 01                   	leal	1(%rdx), %esi
8041600819: 89 b1 00 02 00 00          	movl	%esi, 512(%rcx)
804160081f: 0f b6 04 0a                	movzbl	(%rdx,%rcx), %eax
8041600823: 31 d2                      	xorl	%edx, %edx
;     if (cons.rpos == CONSBUFSIZE)
8041600825: 81 fe 00 02 00 00          	cmpl	$512, %esi
804160082b: 0f 45 d6                   	cmovnel	%esi, %edx
804160082e: 89 91 00 02 00 00          	movl	%edx, 512(%rcx)
; }
8041600834: 5d                         	popq	%rbp
8041600835: c3                         	retq
8041600836: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)

0000008041600840 cons_init:
; cons_init(void) {
8041600840: 55                         	pushq	%rbp
8041600841: 48 89 e5                   	movq	%rsp, %rbp
;   serial_init();
8041600844: 48 b8 80 08 60 41 80 00 00 00      	movabsq	$550852626560, %rax
804160084e: ff d0                      	callq	*%rax
;   if (!serial_exists)
8041600850: 48 b8 9c 13 62 41 80 00 00 00      	movabsq	$550852760476, %rax
804160085a: 80 38 00                   	cmpb	$0, (%rax)
804160085d: 74 02                      	je	2 <cons_init+0x21>
; }
804160085f: 5d                         	popq	%rbp
8041600860: c3                         	retq
;     cprintf("Serial port does not exist!\n");
8041600861: 48 bf 5a 59 60 41 80 00 00 00      	movabsq	$550852647258, %rdi
804160086b: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041600875: 31 c0                      	xorl	%eax, %eax
8041600877: ff d1                      	callq	*%rcx
; }
8041600879: 5d                         	popq	%rbp
804160087a: c3                         	retq
804160087b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041600880 serial_init:
; serial_init(void) {
8041600880: 55                         	pushq	%rbp
8041600881: 48 89 e5                   	movq	%rsp, %rbp
;   __asm __volatile("outb %0,%w1"
8041600884: 31 c0                      	xorl	%eax, %eax
8041600886: ba fa 03 00 00             	movl	$1018, %edx
804160088b: ee                         	outb	%al, %dx
804160088c: b0 80                      	movb	$-128, %al
804160088e: ba fb 03 00 00             	movl	$1019, %edx
8041600893: ee                         	outb	%al, %dx
8041600894: b0 0c                      	movb	$12, %al
8041600896: ba f8 03 00 00             	movl	$1016, %edx
804160089b: ee                         	outb	%al, %dx
804160089c: 31 c0                      	xorl	%eax, %eax
804160089e: ba f9 03 00 00             	movl	$1017, %edx
80416008a3: ee                         	outb	%al, %dx
80416008a4: b0 03                      	movb	$3, %al
80416008a6: ba fb 03 00 00             	movl	$1019, %edx
80416008ab: ee                         	outb	%al, %dx
80416008ac: 31 c0                      	xorl	%eax, %eax
80416008ae: ba fc 03 00 00             	movl	$1020, %edx
80416008b3: ee                         	outb	%al, %dx
80416008b4: b0 01                      	movb	$1, %al
80416008b6: ba f9 03 00 00             	movl	$1017, %edx
80416008bb: ee                         	outb	%al, %dx
;   __asm __volatile("inb %w1,%0"
80416008bc: ba fd 03 00 00             	movl	$1021, %edx
80416008c1: ec                         	inb	%dx, %al
;   serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
80416008c2: 3c ff                      	cmpb	$-1, %al
80416008c4: 48 b8 9c 13 62 41 80 00 00 00      	movabsq	$550852760476, %rax
80416008ce: 0f 95 00                   	setne	(%rax)
;   __asm __volatile("inb %w1,%0"
80416008d1: ba fa 03 00 00             	movl	$1018, %edx
80416008d6: ec                         	inb	%dx, %al
80416008d7: ba f8 03 00 00             	movl	$1016, %edx
80416008dc: ec                         	inb	%dx, %al
; }
80416008dd: 5d                         	popq	%rbp
80416008de: c3                         	retq
80416008df: 90                         	nop

00000080416008e0 cputchar:
; cputchar(int c) {
80416008e0: 55                         	pushq	%rbp
80416008e1: 48 89 e5                   	movq	%rsp, %rbp
;   cons_putc(c);
80416008e4: 48 b8 00 09 60 41 80 00 00 00      	movabsq	$550852626688, %rax
80416008ee: ff d0                      	callq	*%rax
; }
80416008f0: 5d                         	popq	%rbp
80416008f1: c3                         	retq
80416008f2: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416008fc: 0f 1f 40 00                	nopl	(%rax)

0000008041600900 cons_putc:
; cons_putc(int c) {
8041600900: 55                         	pushq	%rbp
8041600901: 48 89 e5                   	movq	%rsp, %rbp
8041600904: 53                         	pushq	%rbx
8041600905: 50                         	pushq	%rax
8041600906: 89 fb                      	movl	%edi, %ebx
;   serial_putc(c);
8041600908: 48 b8 70 09 60 41 80 00 00 00      	movabsq	$550852626800, %rax
8041600912: ff d0                      	callq	*%rax
;   lpt_putc(c);
8041600914: 48 b8 d0 09 60 41 80 00 00 00      	movabsq	$550852626896, %rax
804160091e: 89 df                      	movl	%ebx, %edi
8041600920: ff d0                      	callq	*%rax
;   fb_putc(c);
8041600922: 48 b8 40 0a 60 41 80 00 00 00      	movabsq	$550852627008, %rax
804160092c: 89 df                      	movl	%ebx, %edi
804160092e: ff d0                      	callq	*%rax
; }
8041600930: 48 83 c4 08                	addq	$8, %rsp
8041600934: 5b                         	popq	%rbx
8041600935: 5d                         	popq	%rbp
8041600936: c3                         	retq
8041600937: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)

0000008041600940 getchar:
; getchar(void) {
8041600940: 55                         	pushq	%rbp
8041600941: 48 89 e5                   	movq	%rsp, %rbp
8041600944: 53                         	pushq	%rbx
8041600945: 50                         	pushq	%rax
8041600946: 48 bb e0 07 60 41 80 00 00 00      	movabsq	$550852626400, %rbx
;   while ((c = cons_getc()) == 0)
8041600950: ff d3                      	callq	*%rbx
8041600952: 85 c0                      	testl	%eax, %eax
8041600954: 74 fa                      	je	-6 <getchar+0x10>
;   return c;
8041600956: 48 83 c4 08                	addq	$8, %rsp
804160095a: 5b                         	popq	%rbx
804160095b: 5d                         	popq	%rbp
804160095c: c3                         	retq
804160095d: 0f 1f 00                   	nopl	(%rax)

0000008041600960 iscons:
; iscons(int fdnum) {
8041600960: 55                         	pushq	%rbp
8041600961: 48 89 e5                   	movq	%rsp, %rbp
;   return 1;
8041600964: b8 01 00 00 00             	movl	$1, %eax
8041600969: 5d                         	popq	%rbp
804160096a: c3                         	retq
804160096b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041600970 serial_putc:
; serial_putc(int c) {
8041600970: 55                         	pushq	%rbp
8041600971: 48 89 e5                   	movq	%rsp, %rbp
8041600974: 41 57                      	pushq	%r15
8041600976: 41 56                      	pushq	%r14
8041600978: 53                         	pushq	%rbx
8041600979: 50                         	pushq	%rax
804160097a: 41 89 fe                   	movl	%edi, %r14d
;   __asm __volatile("inb %w1,%0"
804160097d: ba fd 03 00 00             	movl	$1021, %edx
8041600982: ec                         	inb	%dx, %al
;        !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
8041600983: a8 20                      	testb	$32, %al
;   for (i = 0;
8041600985: 75 31                      	jne	49 <serial_putc+0x48>
8041600987: 31 db                      	xorl	%ebx, %ebx
8041600989: 49 bf 20 0c 60 41 80 00 00 00      	movabsq	$550852627488, %r15
8041600993: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160099d: 0f 1f 00                   	nopl	(%rax)
;     delay();
80416009a0: 41 ff d7                   	callq	*%r15
;   __asm __volatile("inb %w1,%0"
80416009a3: ba fd 03 00 00             	movl	$1021, %edx
80416009a8: ec                         	inb	%dx, %al
;        !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
80416009a9: 81 fb fe 31 00 00          	cmpl	$12798, %ebx
;   for (i = 0;
80416009af: 77 07                      	ja	7 <serial_putc+0x48>
80416009b1: 83 c3 01                   	addl	$1, %ebx
80416009b4: 24 20                      	andb	$32, %al
80416009b6: 74 e8                      	je	-24 <serial_putc+0x30>
;   __asm __volatile("outb %0,%w1"
80416009b8: 44 89 f0                   	movl	%r14d, %eax
80416009bb: ba f8 03 00 00             	movl	$1016, %edx
80416009c0: ee                         	outb	%al, %dx
; }
80416009c1: 48 83 c4 08                	addq	$8, %rsp
80416009c5: 5b                         	popq	%rbx
80416009c6: 41 5e                      	popq	%r14
80416009c8: 41 5f                      	popq	%r15
80416009ca: 5d                         	popq	%rbp
80416009cb: c3                         	retq
80416009cc: 0f 1f 40 00                	nopl	(%rax)

00000080416009d0 lpt_putc:
; lpt_putc(int c) {
80416009d0: 55                         	pushq	%rbp
80416009d1: 48 89 e5                   	movq	%rsp, %rbp
80416009d4: 41 57                      	pushq	%r15
80416009d6: 41 56                      	pushq	%r14
80416009d8: 53                         	pushq	%rbx
80416009d9: 50                         	pushq	%rax
80416009da: 41 89 fe                   	movl	%edi, %r14d
;   __asm __volatile("inb %w1,%0"
80416009dd: ba 79 03 00 00             	movl	$889, %edx
80416009e2: ec                         	inb	%dx, %al
;   for (i = 0; !(inb(0x378 + 1) & 0x80) && i < 12800; i++)
80416009e3: 84 c0                      	testb	%al, %al
80416009e5: 78 31                      	js	49 <lpt_putc+0x48>
80416009e7: 31 db                      	xorl	%ebx, %ebx
80416009e9: 49 bf 20 0c 60 41 80 00 00 00      	movabsq	$550852627488, %r15
80416009f3: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416009fd: 0f 1f 00                   	nopl	(%rax)
;     delay();
8041600a00: 41 ff d7                   	callq	*%r15
;   __asm __volatile("inb %w1,%0"
8041600a03: ba 79 03 00 00             	movl	$889, %edx
8041600a08: ec                         	inb	%dx, %al
;   for (i = 0; !(inb(0x378 + 1) & 0x80) && i < 12800; i++)
8041600a09: 81 fb fe 31 00 00          	cmpl	$12798, %ebx
8041600a0f: 77 07                      	ja	7 <lpt_putc+0x48>
8041600a11: 83 c3 01                   	addl	$1, %ebx
8041600a14: 84 c0                      	testb	%al, %al
8041600a16: 79 e8                      	jns	-24 <lpt_putc+0x30>
;   __asm __volatile("outb %0,%w1"
8041600a18: 44 89 f0                   	movl	%r14d, %eax
8041600a1b: ba 78 03 00 00             	movl	$888, %edx
8041600a20: ee                         	outb	%al, %dx
8041600a21: b0 0d                      	movb	$13, %al
8041600a23: ba 7a 03 00 00             	movl	$890, %edx
8041600a28: ee                         	outb	%al, %dx
8041600a29: b0 08                      	movb	$8, %al
8041600a2b: ba 7a 03 00 00             	movl	$890, %edx
8041600a30: ee                         	outb	%al, %dx
; }
8041600a31: 48 83 c4 08                	addq	$8, %rsp
8041600a35: 5b                         	popq	%rbx
8041600a36: 41 5e                      	popq	%r14
8041600a38: 41 5f                      	popq	%r15
8041600a3a: 5d                         	popq	%rbp
8041600a3b: c3                         	retq
8041600a3c: 0f 1f 40 00                	nopl	(%rax)

0000008041600a40 fb_putc:
; fb_putc(int c) {
8041600a40: 55                         	pushq	%rbp
8041600a41: 48 89 e5                   	movq	%rsp, %rbp
8041600a44: 41 57                      	pushq	%r15
8041600a46: 41 56                      	pushq	%r14
8041600a48: 41 54                      	pushq	%r12
8041600a4a: 53                         	pushq	%rbx
;   if (!graphics_exists) {
8041600a4b: 48 b8 ae 13 62 41 80 00 00 00      	movabsq	$550852760494, %rax
8041600a55: 80 38 01                   	cmpb	$1, (%rax)
8041600a58: 0f 85 ab 01 00 00          	jne	427 <fb_putc+0x1c9>
;   switch (c & 0xff) {
8041600a5e: 8d 47 f8                   	leal	-8(%rdi), %eax
;   if (crt_pos >= crt_size) {
8041600a61: 49 be ac 13 62 41 80 00 00 00      	movabsq	$550852760492, %r14
;   switch (c & 0xff) {
8041600a6b: 3c 05                      	cmpb	$5, %al
8041600a6d: 0f 87 b8 00 00 00          	ja	184 <fb_putc+0xeb>
8041600a73: 0f b6 c0                   	movzbl	%al, %eax
8041600a76: 48 b9 50 5b 60 41 80 00 00 00      	movabsq	$550852647760, %rcx
8041600a80: ff 24 c1                   	jmpq	*(%rcx,%rax,8)
;       if (crt_pos > 0) {
8041600a83: 41 0f b7 06                	movzwl	(%r14), %eax
8041600a87: 66 85 c0                   	testw	%ax, %ax
8041600a8a: 0f 84 d5 00 00 00          	je	213 <fb_putc+0x125>
;         crt_pos--;
8041600a90: 83 c0 ff                   	addl	$-1, %eax
8041600a93: 66 41 89 06                	movw	%ax, (%r14)
;         draw_char(crt_buf, crt_pos % crt_cols, crt_pos / crt_cols, 0x0, 0x8);
8041600a97: 0f b7 c0                   	movzwl	%ax, %eax
8041600a9a: 48 b9 a4 13 62 41 80 00 00 00      	movabsq	$550852760484, %rcx
8041600aa4: 31 d2                      	xorl	%edx, %edx
8041600aa6: f7 31                      	divl	(%rcx)
8041600aa8: 48 bb e0 04 60 41 80 00 00 00      	movabsq	$550852625632, %rbx
8041600ab2: 48 bf 00 00 c0 3e 80 00 00 00      	movabsq	$550808584192, %rdi
8041600abc: 89 d6                      	movl	%edx, %esi
8041600abe: 89 c2                      	movl	%eax, %edx
8041600ac0: 31 c9                      	xorl	%ecx, %ecx
8041600ac2: 41 b8 08 00 00 00          	movl	$8, %r8d
8041600ac8: ff d3                      	callq	*%rbx
8041600aca: e9 96 00 00 00             	jmp	150 <fb_putc+0x125>
;       cons_putc(' ');
8041600acf: 48 bb 00 09 60 41 80 00 00 00      	movabsq	$550852626688, %rbx
8041600ad9: bf 20 00 00 00             	movl	$32, %edi
8041600ade: ff d3                      	callq	*%rbx
;       cons_putc(' ');
8041600ae0: bf 20 00 00 00             	movl	$32, %edi
8041600ae5: ff d3                      	callq	*%rbx
;       cons_putc(' ');
8041600ae7: bf 20 00 00 00             	movl	$32, %edi
8041600aec: ff d3                      	callq	*%rbx
;       cons_putc(' ');
8041600aee: bf 20 00 00 00             	movl	$32, %edi
8041600af3: ff d3                      	callq	*%rbx
;       cons_putc(' ');
8041600af5: bf 20 00 00 00             	movl	$32, %edi
8041600afa: ff d3                      	callq	*%rbx
8041600afc: eb 67                      	jmp	103 <fb_putc+0x125>
;       crt_pos += crt_cols;
8041600afe: 48 b8 a4 13 62 41 80 00 00 00      	movabsq	$550852760484, %rax
8041600b08: 0f b7 00                   	movzwl	(%rax), %eax
8041600b0b: 66 41 01 06                	addw	%ax, (%r14)
;       crt_pos -= (crt_pos % crt_cols);
8041600b0f: 41 0f b7 0e                	movzwl	(%r14), %ecx
8041600b13: 48 be a4 13 62 41 80 00 00 00      	movabsq	$550852760484, %rsi
8041600b1d: 89 c8                      	movl	%ecx, %eax
8041600b1f: 31 d2                      	xorl	%edx, %edx
8041600b21: f7 36                      	divl	(%rsi)
8041600b23: 29 d1                      	subl	%edx, %ecx
8041600b25: 66 41 89 0e                	movw	%cx, (%r14)
8041600b29: eb 3a                      	jmp	58 <fb_putc+0x125>
;       draw_char(crt_buf, crt_pos % crt_cols, crt_pos / crt_cols, 0xffffffff, (char)c); /* write the character */
8041600b2b: 41 0f b7 06                	movzwl	(%r14), %eax
8041600b2f: 48 b9 a4 13 62 41 80 00 00 00      	movabsq	$550852760484, %rcx
8041600b39: 31 d2                      	xorl	%edx, %edx
8041600b3b: f7 31                      	divl	(%rcx)
8041600b3d: 44 0f be c7                	movsbl	%dil, %r8d
8041600b41: 48 bb e0 04 60 41 80 00 00 00      	movabsq	$550852625632, %rbx
8041600b4b: 48 bf 00 00 c0 3e 80 00 00 00      	movabsq	$550808584192, %rdi
8041600b55: 89 d6                      	movl	%edx, %esi
8041600b57: 89 c2                      	movl	%eax, %edx
8041600b59: b9 ff ff ff ff             	movl	$4294967295, %ecx
8041600b5e: ff d3                      	callq	*%rbx
;       crt_pos++;
8041600b60: 66 41 83 06 01             	addw	$1, (%r14)
;   if (crt_pos >= crt_size) {
8041600b65: 41 0f b7 06                	movzwl	(%r14), %eax
8041600b69: 48 b9 a8 13 62 41 80 00 00 00      	movabsq	$550852760488, %rcx
8041600b73: 39 01                      	cmpl	%eax, (%rcx)
8041600b75: 0f 87 8e 00 00 00          	ja	142 <fb_putc+0x1c9>
8041600b7b: 49 bf 00 00 c0 3e 80 00 00 00      	movabsq	$550808584192, %r15
;     memmove(crt_buf, crt_buf + uefi_hres * SYMBOL_SIZE, uefi_hres * (uefi_vres - SYMBOL_SIZE) * sizeof(uint32_t));
8041600b85: 49 bc 98 13 62 41 80 00 00 00      	movabsq	$550852760472, %r12
8041600b8f: 41 8b 04 24                	movl	(%r12), %eax
8041600b93: 8d 0c c5 00 00 00 00       	leal	(,%rax,8), %ecx
8041600b9a: 49 8d 34 8f                	leaq	(%r15,%rcx,4), %rsi
8041600b9e: 48 bb a0 13 62 41 80 00 00 00      	movabsq	$550852760480, %rbx
8041600ba8: 8b 13                      	movl	(%rbx), %edx
8041600baa: 83 c2 f8                   	addl	$-8, %edx
8041600bad: 0f af d0                   	imull	%eax, %edx
8041600bb0: 48 c1 e2 02                	shlq	$2, %rdx
8041600bb4: 48 b8 60 52 60 41 80 00 00 00      	movabsq	$550852645472, %rax
8041600bbe: 4c 89 ff                   	movq	%r15, %rdi
8041600bc1: ff d0                      	callq	*%rax
;     for (i = uefi_hres * (uefi_vres - (uefi_vres % SYMBOL_SIZE) - SYMBOL_SIZE); i < uefi_hres * uefi_vres; i++)
8041600bc3: 41 8b 0c 24                	movl	(%r12), %ecx
8041600bc7: 8b 13                      	movl	(%rbx), %edx
8041600bc9: 8d 42 f8                   	leal	-8(%rdx), %eax
8041600bcc: 83 e0 f8                   	andl	$-8, %eax
8041600bcf: 0f af c1                   	imull	%ecx, %eax
8041600bd2: 0f af d1                   	imull	%ecx, %edx
8041600bd5: 39 d0                      	cmpl	%edx, %eax
8041600bd7: 73 1f                      	jae	31 <fb_putc+0x1b8>
8041600bd9: 48 63 c8                   	movslq	%eax, %rcx
8041600bdc: 49 8d 0c 8f                	leaq	(%r15,%rcx,4), %rcx
;       crt_buf[i] = 0;
8041600be0: c7 01 00 00 00 00          	movl	$0, (%rcx)
;     for (i = uefi_hres * (uefi_vres - (uefi_vres % SYMBOL_SIZE) - SYMBOL_SIZE); i < uefi_hres * uefi_vres; i++)
8041600be6: 8b 13                      	movl	(%rbx), %edx
8041600be8: 41 0f af 14 24             	imull	(%r12), %edx
8041600bed: 48 83 c1 04                	addq	$4, %rcx
8041600bf1: 83 c0 01                   	addl	$1, %eax
8041600bf4: 39 c2                      	cmpl	%eax, %edx
8041600bf6: 77 e8                      	ja	-24 <fb_putc+0x1a0>
;     crt_pos -= crt_cols;
8041600bf8: 48 b8 a4 13 62 41 80 00 00 00      	movabsq	$550852760484, %rax
8041600c02: 0f b7 00                   	movzwl	(%rax), %eax
8041600c05: 66 41 29 06                	subw	%ax, (%r14)
; }
8041600c09: 5b                         	popq	%rbx
8041600c0a: 41 5c                      	popq	%r12
8041600c0c: 41 5e                      	popq	%r14
8041600c0e: 41 5f                      	popq	%r15
8041600c10: 5d                         	popq	%rbp
8041600c11: c3                         	retq
8041600c12: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041600c1c: 0f 1f 40 00                	nopl	(%rax)

0000008041600c20 delay:
; delay(void) {
8041600c20: 55                         	pushq	%rbp
8041600c21: 48 89 e5                   	movq	%rsp, %rbp
;   __asm __volatile("inb %w1,%0"
8041600c24: ba 84 00 00 00             	movl	$132, %edx
8041600c29: ec                         	inb	%dx, %al
8041600c2a: ba 84 00 00 00             	movl	$132, %edx
8041600c2f: ec                         	inb	%dx, %al
8041600c30: ba 84 00 00 00             	movl	$132, %edx
8041600c35: ec                         	inb	%dx, %al
8041600c36: ba 84 00 00 00             	movl	$132, %edx
8041600c3b: ec                         	inb	%dx, %al
; }
8041600c3c: 5d                         	popq	%rbp
8041600c3d: c3                         	retq
8041600c3e: cc                         	int3
8041600c3f: cc                         	int3

0000008041600c40 info_by_address:
;                 Dwarf_Off *store) {
8041600c40: 55                         	pushq	%rbp
8041600c41: 48 89 e5                   	movq	%rsp, %rbp
8041600c44: 41 57                      	pushq	%r15
8041600c46: 41 56                      	pushq	%r14
8041600c48: 53                         	pushq	%rbx
8041600c49: 50                         	pushq	%rax
8041600c4a: 49 89 d6                   	movq	%rdx, %r14
8041600c4d: 49 89 f7                   	movq	%rsi, %r15
8041600c50: 48 89 fb                   	movq	%rdi, %rbx
;   int code = info_by_address_debug_aranges(addrs, p, store);
8041600c53: 48 b8 90 0c 60 41 80 00 00 00      	movabsq	$550852627600, %rax
8041600c5d: ff d0                      	callq	*%rax
;   if (code < 0) {
8041600c5f: 85 c0                      	testl	%eax, %eax
8041600c61: 79 15                      	jns	21 <info_by_address+0x38>
;     code = info_by_address_debug_info(addrs, p, store);
8041600c63: 48 b8 30 0f 60 41 80 00 00 00      	movabsq	$550852628272, %rax
8041600c6d: 48 89 df                   	movq	%rbx, %rdi
8041600c70: 4c 89 fe                   	movq	%r15, %rsi
8041600c73: 4c 89 f2                   	movq	%r14, %rdx
8041600c76: ff d0                      	callq	*%rax
;   return code;
8041600c78: 48 83 c4 08                	addq	$8, %rsp
8041600c7c: 5b                         	popq	%rbx
8041600c7d: 41 5e                      	popq	%r14
8041600c7f: 41 5f                      	popq	%r15
8041600c81: 5d                         	popq	%rbp
8041600c82: c3                         	retq
8041600c83: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041600c8d: 0f 1f 00                   	nopl	(%rax)

0000008041600c90 info_by_address_debug_aranges:
;                               uintptr_t p, Dwarf_Off *store) {
8041600c90: 55                         	pushq	%rbp
8041600c91: 48 89 e5                   	movq	%rsp, %rbp
8041600c94: 41 57                      	pushq	%r15
8041600c96: 41 56                      	pushq	%r14
8041600c98: 41 55                      	pushq	%r13
8041600c9a: 41 54                      	pushq	%r12
8041600c9c: 53                         	pushq	%rbx
8041600c9d: 48 83 ec 48                	subq	$72, %rsp
8041600ca1: 48 89 55 b0                	movq	%rdx, -80(%rbp)
8041600ca5: 48 89 75 b8                	movq	%rsi, -72(%rbp)
8041600ca9: 48 89 7d a0                	movq	%rdi, -96(%rbp)
;   const void *set = addrs->aranges_begin;
8041600cad: 4c 8b 7f 10                	movq	16(%rdi), %r15
8041600cb1: 49 be 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r14
8041600cbb: eb 21                      	jmp	33 <info_by_address_debug_aranges+0x4e>
8041600cbd: 0f 1f 00                   	nopl	(%rax)
8041600cc0: b0 01                      	movb	$1, %al
;     assert(set == set_end);
8041600cc2: 4c 39 7d c0                	cmpq	%r15, -64(%rbp)
8041600cc6: 49 be 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r14
8041600cd0: 0f 85 24 02 00 00          	jne	548 <info_by_address_debug_aranges+0x26a>
8041600cd6: 84 c0                      	testb	%al, %al
8041600cd8: 0f 84 77 01 00 00          	je	375 <info_by_address_debug_aranges+0x1c5>
8041600cde: 48 8b 45 a0                	movq	-96(%rbp), %rax
;   while ((unsigned char *)set < addrs->aranges_end) {
8041600ce2: 4c 3b 78 18                	cmpq	24(%rax), %r15
8041600ce6: 0f 83 62 01 00 00          	jae	354 <info_by_address_debug_aranges+0x1be>
;     count              = dwarf_entry_len(set, &len);
8041600cec: 4c 89 ff                   	movq	%r15, %rdi
8041600cef: 48 8d 75 98                	leaq	-104(%rbp), %rsi
8041600cf3: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
8041600cfd: ff d0                      	callq	*%rax
;     if (count == 0) {
8041600cff: 85 c0                      	testl	%eax, %eax
8041600d01: 0f 84 39 01 00 00          	je	313 <info_by_address_debug_aranges+0x1b0>
;       set += count;
8041600d07: 4c 63 e0                   	movslq	%eax, %r12
8041600d0a: 4b 8d 34 27                	leaq	(%r15,%r12), %rsi
8041600d0e: 4d 89 f5                   	movq	%r14, %r13
8041600d11: 48 8b 45 98                	movq	-104(%rbp), %rax
;     const void *set_end = set + len;
8041600d15: 48 01 f0                   	addq	%rsi, %rax
8041600d18: 48 89 45 c0                	movq	%rax, -64(%rbp)
;     Dwarf_Half version = get_unaligned(set, Dwarf_Half);
8041600d1c: ba 02 00 00 00             	movl	$2, %edx
8041600d21: 4c 8d 75 d0                	leaq	-48(%rbp), %r14
8041600d25: 4c 89 f7                   	movq	%r14, %rdi
8041600d28: 41 ff d5                   	callq	*%r13
;     assert(version == 2);
8041600d2b: 66 83 7d d0 02             	cmpw	$2, -48(%rbp)
8041600d30: 0f 85 31 01 00 00          	jne	305 <info_by_address_debug_aranges+0x1d7>
8041600d36: 4b 8d 1c 27                	leaq	(%r15,%r12), %rbx
8041600d3a: 48 83 c3 02                	addq	$2, %rbx
;     Dwarf_Off offset = get_unaligned(set, uint32_t);
8041600d3e: ba 04 00 00 00             	movl	$4, %edx
8041600d43: 4c 89 f7                   	movq	%r14, %rdi
8041600d46: 48 89 de                   	movq	%rbx, %rsi
8041600d49: 41 ff d5                   	callq	*%r13
8041600d4c: 8b 45 d0                   	movl	-48(%rbp), %eax
8041600d4f: 48 89 45 a8                	movq	%rax, -88(%rbp)
;     set += count;
8041600d53: 4a 8d 34 23                	leaq	(%rbx,%r12), %rsi
;     Dwarf_Small address_size = get_unaligned(set++, Dwarf_Small);
8041600d57: ba 01 00 00 00             	movl	$1, %edx
8041600d5c: 4c 89 f7                   	movq	%r14, %rdi
8041600d5f: 41 ff d5                   	callq	*%r13
;     assert(address_size == 8);
8041600d62: 80 7d d0 08                	cmpb	$8, -48(%rbp)
8041600d66: 0f 85 2c 01 00 00          	jne	300 <info_by_address_debug_aranges+0x208>
8041600d6c: 4c 01 e3                   	addq	%r12, %rbx
8041600d6f: 48 83 c3 01                	addq	$1, %rbx
;     Dwarf_Small segment_size = get_unaligned(set++, Dwarf_Small);
8041600d73: ba 01 00 00 00             	movl	$1, %edx
8041600d78: 4c 89 f7                   	movq	%r14, %rdi
8041600d7b: 48 89 de                   	movq	%rbx, %rsi
8041600d7e: 41 ff d5                   	callq	*%r13
;     assert(segment_size == 0);
8041600d81: 80 7d d0 00                	cmpb	$0, -48(%rbp)
8041600d85: 0f 85 3e 01 00 00          	jne	318 <info_by_address_debug_aranges+0x239>
8041600d8b: 48 83 c3 01                	addq	$1, %rbx
;     uint32_t remainder  = (set - header) % entry_size;
8041600d8f: 48 89 d8                   	movq	%rbx, %rax
8041600d92: 4c 29 f8                   	subq	%r15, %rax
8041600d95: 8d 48 0f                   	leal	15(%rax), %ecx
8041600d98: 48 85 c0                   	testq	%rax, %rax
8041600d9b: 0f 49 c8                   	cmovnsl	%eax, %ecx
8041600d9e: 83 e1 f0                   	andl	$-16, %ecx
8041600da1: 29 c8                      	subl	%ecx, %eax
;     if (remainder) {
8041600da3: 41 bc 10 00 00 00          	movl	$16, %r12d
8041600da9: 41 29 c4                   	subl	%eax, %r12d
8041600dac: 49 01 dc                   	addq	%rbx, %r12
8041600daf: 85 c0                      	testl	%eax, %eax
8041600db1: 4c 0f 44 e3                	cmoveq	%rbx, %r12
8041600db5: eb 1a                      	jmp	26 <info_by_address_debug_aranges+0x141>
8041600db7: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
;     } while (set < set_end);
8041600dc0: 48 83 c3 08                	addq	$8, %rbx
8041600dc4: 49 89 dc                   	movq	%rbx, %r12
8041600dc7: 48 3b 5d c0                	cmpq	-64(%rbp), %rbx
8041600dcb: 0f 83 ef fe ff ff          	jae	-273 <info_by_address_debug_aranges+0x30>
;       addr = (void *)get_unaligned(set, uintptr_t);
8041600dd1: ba 08 00 00 00             	movl	$8, %edx
8041600dd6: 4c 8d 75 d0                	leaq	-48(%rbp), %r14
8041600dda: 4c 89 f7                   	movq	%r14, %rdi
8041600ddd: 4c 89 e6                   	movq	%r12, %rsi
8041600de0: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
8041600dea: 41 ff d7                   	callq	*%r15
8041600ded: 4c 8b 6d d0                	movq	-48(%rbp), %r13
;       size = get_unaligned(set, uint32_t);
8041600df1: 49 8d 5c 24 08             	leaq	8(%r12), %rbx
8041600df6: ba 04 00 00 00             	movl	$4, %edx
8041600dfb: 4c 89 f7                   	movq	%r14, %rdi
8041600dfe: 48 89 de                   	movq	%rbx, %rsi
8041600e01: 41 ff d7                   	callq	*%r15
;       set += address_size;
8041600e04: 4d 89 e7                   	movq	%r12, %r15
8041600e07: 49 83 c7 10                	addq	$16, %r15
;       if ((uintptr_t)addr <= p &&
8041600e0b: 4c 3b 6d b8                	cmpq	-72(%rbp), %r13
8041600e0f: 77 af                      	ja	-81 <info_by_address_debug_aranges+0x130>
8041600e11: 8b 45 d0                   	movl	-48(%rbp), %eax
;           p <= (uintptr_t)addr + size) {
8041600e14: 49 01 c5                   	addq	%rax, %r13
8041600e17: 4c 3b 6d b8                	cmpq	-72(%rbp), %r13
;       if ((uintptr_t)addr <= p &&
8041600e1b: 72 a3                      	jb	-93 <info_by_address_debug_aranges+0x130>
8041600e1d: 48 8b 45 b0                	movq	-80(%rbp), %rax
8041600e21: 48 8b 4d a8                	movq	-88(%rbp), %rcx
;         *store = offset;
8041600e25: 48 89 08                   	movq	%rcx, (%rax)
8041600e28: 31 c0                      	xorl	%eax, %eax
8041600e2a: c7 45 cc 00 00 00 00       	movl	$0, -52(%rbp)
8041600e31: 49 be 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r14
8041600e3b: e9 96 fe ff ff             	jmp	-362 <info_by_address_debug_aranges+0x46>
8041600e40: c7 45 cc fa ff ff ff       	movl	$4294967290, -52(%rbp)
8041600e47: 31 c0                      	xorl	%eax, %eax
8041600e49: e9 88 fe ff ff             	jmp	-376 <info_by_address_debug_aranges+0x46>
8041600e4e: c7 45 cc fa ff ff ff       	movl	$4294967290, -52(%rbp)
8041600e55: 8b 45 cc                   	movl	-52(%rbp), %eax
; }
8041600e58: 48 83 c4 48                	addq	$72, %rsp
8041600e5c: 5b                         	popq	%rbx
8041600e5d: 41 5c                      	popq	%r12
8041600e5f: 41 5d                      	popq	%r13
8041600e61: 41 5e                      	popq	%r14
8041600e63: 41 5f                      	popq	%r15
8041600e65: 5d                         	popq	%rbp
8041600e66: c3                         	retq
;     assert(version == 2);
8041600e67: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041600e71: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041600e7b: 48 b9 e7 54 60 41 80 00 00 00      	movabsq	$550852646119, %rcx
8041600e85: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041600e8f: be 20 00 00 00             	movl	$32, %esi
8041600e94: 31 c0                      	xorl	%eax, %eax
8041600e96: ff d3                      	callq	*%rbx
;     assert(address_size == 8);
8041600e98: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041600ea2: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041600eac: 48 b9 8b 57 60 41 80 00 00 00      	movabsq	$550852646795, %rcx
8041600eb6: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041600ec0: be 24 00 00 00             	movl	$36, %esi
8041600ec5: 31 c0                      	xorl	%eax, %eax
8041600ec7: ff d3                      	callq	*%rbx
;     assert(segment_size == 0);
8041600ec9: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041600ed3: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041600edd: 48 b9 f4 54 60 41 80 00 00 00      	movabsq	$550852646132, %rcx
8041600ee7: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041600ef1: be 26 00 00 00             	movl	$38, %esi
8041600ef6: 31 c0                      	xorl	%eax, %eax
8041600ef8: ff d3                      	callq	*%rbx
;     assert(set == set_end);
8041600efa: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041600f04: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041600f0e: 48 b9 d0 56 60 41 80 00 00 00      	movabsq	$550852646608, %rcx
8041600f18: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041600f22: be 3a 00 00 00             	movl	$58, %esi
8041600f27: 31 c0                      	xorl	%eax, %eax
8041600f29: ff d3                      	callq	*%rbx
8041600f2b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041600f30 info_by_address_debug_info:
;                            uintptr_t p, Dwarf_Off *store) {
8041600f30: 55                         	pushq	%rbp
8041600f31: 48 89 e5                   	movq	%rsp, %rbp
8041600f34: 41 57                      	pushq	%r15
8041600f36: 41 56                      	pushq	%r14
8041600f38: 41 55                      	pushq	%r13
8041600f3a: 41 54                      	pushq	%r12
8041600f3c: 53                         	pushq	%rbx
8041600f3d: 48 83 ec 68                	subq	$104, %rsp
8041600f41: 48 89 55 90                	movq	%rdx, -112(%rbp)
8041600f45: 49 89 f6                   	movq	%rsi, %r14
8041600f48: 48 89 7d a8                	movq	%rdi, -88(%rbp)
;   const void *entry = addrs->info_begin;
8041600f4c: 48 8b 5f 20                	movq	32(%rdi), %rbx
8041600f50: 49 bd 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r13
8041600f5a: 48 89 75 88                	movq	%rsi, -120(%rbp)
8041600f5e: eb 14                      	jmp	20 <info_by_address_debug_info+0x44>
8041600f60: c7 45 c4 fa ff ff ff       	movl	$4294967290, -60(%rbp)
8041600f67: b8 01 00 00 00             	movl	$1, %eax
8041600f6c: 85 c0                      	testl	%eax, %eax
8041600f6e: 0f 85 35 02 00 00          	jne	565 <info_by_address_debug_info+0x279>
8041600f74: 48 8b 45 a8                	movq	-88(%rbp), %rax
;   while ((unsigned char *)entry < addrs->info_end) {
8041600f78: 48 3b 58 28                	cmpq	40(%rax), %rbx
8041600f7c: 0f 83 20 02 00 00          	jae	544 <info_by_address_debug_info+0x272>
;     count              = dwarf_entry_len(entry, &len);
8041600f82: 48 89 df                   	movq	%rbx, %rdi
8041600f85: 48 8d b5 78 ff ff ff       	leaq	-136(%rbp), %rsi
8041600f8c: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
8041600f96: ff d0                      	callq	*%rax
;     if (count == 0) {
8041600f98: 85 c0                      	testl	%eax, %eax
8041600f9a: 74 c4                      	je	-60 <info_by_address_debug_info+0x30>
;       entry += count;
8041600f9c: 4c 63 f0                   	movslq	%eax, %r14
8041600f9f: 4a 8d 34 33                	leaq	(%rbx,%r14), %rsi
8041600fa3: 48 8b 85 78 ff ff ff       	movq	-136(%rbp), %rax
;     const void *entry_end = entry + len;
8041600faa: 48 01 f0                   	addq	%rsi, %rax
8041600fad: 48 89 45 98                	movq	%rax, -104(%rbp)
;     Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
8041600fb1: ba 02 00 00 00             	movl	$2, %edx
8041600fb6: 48 8d 7d c8                	leaq	-56(%rbp), %rdi
8041600fba: 41 ff d5                   	callq	*%r13
8041600fbd: 0f b7 45 c8                	movzwl	-56(%rbp), %eax
;     assert(version == 4 || version == 2);
8041600fc1: 66 83 f8 02                	cmpw	$2, %ax
8041600fc5: 74 0a                      	je	10 <info_by_address_debug_info+0xa1>
8041600fc7: 66 83 f8 04                	cmpw	$4, %ax
8041600fcb: 0f 85 ea 01 00 00          	jne	490 <info_by_address_debug_info+0x28b>
8041600fd1: 48 89 5d 80                	movq	%rbx, -128(%rbp)
8041600fd5: 4e 8d 3c 33                	leaq	(%rbx,%r14), %r15
8041600fd9: 49 83 c7 02                	addq	$2, %r15
;     Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
8041600fdd: ba 04 00 00 00             	movl	$4, %edx
8041600fe2: 4c 8d 65 c8                	leaq	-56(%rbp), %r12
8041600fe6: 4c 89 e7                   	movq	%r12, %rdi
8041600fe9: 4c 89 fe                   	movq	%r15, %rsi
8041600fec: 41 ff d5                   	callq	*%r13
8041600fef: 8b 5d c8                   	movl	-56(%rbp), %ebx
;     entry += count;
8041600ff2: 4b 8d 34 37                	leaq	(%r15,%r14), %rsi
;     Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
8041600ff6: ba 01 00 00 00             	movl	$1, %edx
8041600ffb: 4c 89 e7                   	movq	%r12, %rdi
8041600ffe: 41 ff d5                   	callq	*%r13
;     assert(address_size == 8);
8041601001: 80 7d c8 08                	cmpb	$8, -56(%rbp)
8041601005: 0f 85 e1 01 00 00          	jne	481 <info_by_address_debug_info+0x2bc>
804160100b: 4f 8d 2c 37                	leaq	(%r15,%r14), %r13
804160100f: 49 83 c5 01                	addq	$1, %r13
;     unsigned abbrev_code = 0;
8041601013: c7 45 b4 00 00 00 00       	movl	$0, -76(%rbp)
;     count                = dwarf_read_uleb128(entry, &abbrev_code);
804160101a: 4c 89 ef                   	movq	%r13, %rdi
804160101d: 48 8d 75 b4                	leaq	-76(%rbp), %rsi
8041601021: 49 bc d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r12
804160102b: 41 ff d4                   	callq	*%r12
;     assert(abbrev_code != 0);
804160102e: 44 8b 75 b4                	movl	-76(%rbp), %r14d
8041601032: 45 85 f6                   	testl	%r14d, %r14d
8041601035: 0f 84 e2 01 00 00          	je	482 <info_by_address_debug_info+0x2ed>
804160103b: 49 89 c7                   	movq	%rax, %r15
804160103e: 48 8b 45 a8                	movq	-88(%rbp), %rax
;     const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
8041601042: 48 03 18                   	addq	(%rax), %rbx
;     unsigned table_abbrev_code = 0;
8041601045: c7 45 b8 00 00 00 00       	movl	$0, -72(%rbp)
;     count                      = dwarf_read_uleb128(abbrev_entry, &table_abbrev_code);
804160104c: 48 89 df                   	movq	%rbx, %rdi
804160104f: 48 8d 75 b8                	leaq	-72(%rbp), %rsi
8041601053: 41 ff d4                   	callq	*%r12
;     assert(table_abbrev_code == abbrev_code);
8041601056: 44 39 75 b8                	cmpl	%r14d, -72(%rbp)
804160105a: 0f 85 ee 01 00 00          	jne	494 <info_by_address_debug_info+0x31e>
8041601060: 48 98                      	cltq
8041601062: 48 01 c3                   	addq	%rax, %rbx
;     unsigned tag = 0;
8041601065: c7 45 bc 00 00 00 00       	movl	$0, -68(%rbp)
;     count        = dwarf_read_uleb128(abbrev_entry, &tag);
804160106c: 48 89 df                   	movq	%rbx, %rdi
804160106f: 48 8d 75 bc                	leaq	-68(%rbp), %rsi
8041601073: 41 ff d4                   	callq	*%r12
;     assert(tag == DW_TAG_compile_unit);
8041601076: 83 7d bc 11                	cmpl	$17, -68(%rbp)
804160107a: 0f 85 ff 01 00 00          	jne	511 <info_by_address_debug_info+0x34f>
8041601080: 49 63 cf                   	movslq	%r15d, %rcx
8041601083: 49 01 cd                   	addq	%rcx, %r13
;     abbrev_entry += count;
8041601086: 48 98                      	cltq
;     abbrev_entry++;
8041601088: 4c 8d 3c 03                	leaq	(%rbx,%rax), %r15
804160108c: 49 83 c7 01                	addq	$1, %r15
;     unsigned name = 0, form = 0;
8041601090: c7 45 c0 00 00 00 00       	movl	$0, -64(%rbp)
8041601097: c7 45 d4 00 00 00 00       	movl	$0, -44(%rbp)
;     uintptr_t low_pc = 0, high_pc = 0;
804160109e: 48 c7 45 c8 00 00 00 00    	movq	$0, -56(%rbp)
80416010a6: 48 c7 45 a0 00 00 00 00    	movq	$0, -96(%rbp)
80416010ae: eb 33                      	jmp	51 <info_by_address_debug_info+0x1b3>
;             entry, form, &low_pc, sizeof(low_pc),
80416010b0: 8b 75 d4                   	movl	-44(%rbp), %esi
;         count = dwarf_read_abbrev_entry(
80416010b3: 4c 89 ef                   	movq	%r13, %rdi
80416010b6: 48 8d 55 c8                	leaq	-56(%rbp), %rdx
80416010ba: b9 08 00 00 00             	movl	$8, %ecx
80416010bf: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
80416010c9: ff d0                      	callq	*%rax
80416010cb: 4d 01 f7                   	addq	%r14, %r15
;       entry += count;
80416010ce: 48 98                      	cltq
80416010d0: 49 01 c5                   	addq	%rax, %r13
;     } while (name != 0 || form != 0);
80416010d3: 44 0b 65 d4                	orl	-44(%rbp), %r12d
80416010d7: 49 bc d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r12
80416010e1: 74 6d                      	je	109 <info_by_address_debug_info+0x220>
80416010e3: 4c 89 fb                   	movq	%r15, %rbx
;       count = dwarf_read_uleb128(abbrev_entry, &name);
80416010e6: 4c 89 ff                   	movq	%r15, %rdi
80416010e9: 48 8d 75 c0                	leaq	-64(%rbp), %rsi
80416010ed: 41 ff d4                   	callq	*%r12
;       abbrev_entry += count;
80416010f0: 4c 63 f8                   	movslq	%eax, %r15
80416010f3: 49 01 df                   	addq	%rbx, %r15
;       count = dwarf_read_uleb128(abbrev_entry, &form);
80416010f6: 4c 89 ff                   	movq	%r15, %rdi
80416010f9: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
80416010fd: 41 ff d4                   	callq	*%r12
;       abbrev_entry += count;
8041601100: 4c 63 f0                   	movslq	%eax, %r14
;       if (name == DW_AT_low_pc) {
8041601103: 44 8b 65 c0                	movl	-64(%rbp), %r12d
8041601107: 41 83 fc 11                	cmpl	$17, %r12d
804160110b: 74 a3                      	je	-93 <info_by_address_debug_info+0x180>
804160110d: 8b 5d d4                   	movl	-44(%rbp), %ebx
;         count = dwarf_read_abbrev_entry(
8041601110: 4c 89 ef                   	movq	%r13, %rdi
;       } else if (name == DW_AT_high_pc) {
8041601113: 41 83 fc 12                	cmpl	$18, %r12d
8041601117: 75 27                      	jne	39 <info_by_address_debug_info+0x210>
;         count = dwarf_read_abbrev_entry(
8041601119: 89 de                      	movl	%ebx, %esi
804160111b: 48 8d 55 a0                	leaq	-96(%rbp), %rdx
804160111f: b9 08 00 00 00             	movl	$8, %ecx
8041601124: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
804160112e: ff d0                      	callq	*%rax
;         if (form != DW_FORM_addr) {
8041601130: 83 fb 01                   	cmpl	$1, %ebx
8041601133: 74 96                      	je	-106 <info_by_address_debug_info+0x19b>
;           high_pc += low_pc;
8041601135: 48 8b 4d c8                	movq	-56(%rbp), %rcx
8041601139: 48 01 4d a0                	addq	%rcx, -96(%rbp)
804160113d: eb 8c                      	jmp	-116 <info_by_address_debug_info+0x19b>
804160113f: 90                         	nop
;         count = dwarf_read_abbrev_entry(
8041601140: 89 de                      	movl	%ebx, %esi
8041601142: 31 d2                      	xorl	%edx, %edx
8041601144: 31 c9                      	xorl	%ecx, %ecx
8041601146: e9 74 ff ff ff             	jmp	-140 <info_by_address_debug_info+0x18f>
804160114b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
8041601150: 31 c0                      	xorl	%eax, %eax
8041601152: 4c 8b 75 88                	movq	-120(%rbp), %r14
;     if (p >= low_pc && p <= high_pc) {
8041601156: 4c 39 75 c8                	cmpq	%r14, -56(%rbp)
804160115a: 77 2e                      	ja	46 <info_by_address_debug_info+0x25a>
804160115c: 4c 39 75 a0                	cmpq	%r14, -96(%rbp)
8041601160: 48 8b 5d 98                	movq	-104(%rbp), %rbx
8041601164: 72 28                      	jb	40 <info_by_address_debug_info+0x25e>
8041601166: 48 8b 45 a8                	movq	-88(%rbp), %rax
804160116a: 48 8b 4d 80                	movq	-128(%rbp), %rcx
;           (const unsigned char *)header - addrs->info_begin;
804160116e: 48 2b 48 20                	subq	32(%rax), %rcx
8041601172: 48 8b 45 90                	movq	-112(%rbp), %rax
;       *store =
8041601176: 48 89 08                   	movq	%rcx, (%rax)
8041601179: c7 45 c4 00 00 00 00       	movl	$0, -60(%rbp)
8041601180: b8 01 00 00 00             	movl	$1, %eax
8041601185: 4c 89 eb                   	movq	%r13, %rbx
8041601188: eb 04                      	jmp	4 <info_by_address_debug_info+0x25e>
804160118a: 48 8b 5d 98                	movq	-104(%rbp), %rbx
804160118e: 49 bd 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r13
8041601198: 85 c0                      	testl	%eax, %eax
804160119a: 0f 84 d4 fd ff ff          	je	-556 <info_by_address_debug_info+0x44>
80416011a0: eb 07                      	jmp	7 <info_by_address_debug_info+0x279>
80416011a2: c7 45 c4 00 00 00 00       	movl	$0, -60(%rbp)
80416011a9: 8b 45 c4                   	movl	-60(%rbp), %eax
; }
80416011ac: 48 83 c4 68                	addq	$104, %rsp
80416011b0: 5b                         	popq	%rbx
80416011b1: 41 5c                      	popq	%r12
80416011b3: 41 5d                      	popq	%r13
80416011b5: 41 5e                      	popq	%r14
80416011b7: 41 5f                      	popq	%r15
80416011b9: 5d                         	popq	%rbp
80416011ba: c3                         	retq
;     assert(version == 4 || version == 2);
80416011bb: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
80416011c5: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
80416011cf: 48 b9 c3 59 60 41 80 00 00 00      	movabsq	$550852647363, %rcx
80416011d9: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416011e3: be 40 01 00 00             	movl	$320, %esi
80416011e8: 31 c0                      	xorl	%eax, %eax
80416011ea: ff d3                      	callq	*%rbx
;     assert(address_size == 8);
80416011ec: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
80416011f6: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041601200: 48 b9 8b 57 60 41 80 00 00 00      	movabsq	$550852646795, %rcx
804160120a: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041601214: be 44 01 00 00             	movl	$324, %esi
8041601219: 31 c0                      	xorl	%eax, %eax
804160121b: ff d3                      	callq	*%rbx
;     assert(abbrev_code != 0);
804160121d: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041601227: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041601231: 48 b9 bf 56 60 41 80 00 00 00      	movabsq	$550852646591, %rcx
804160123b: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041601245: be 49 01 00 00             	movl	$329, %esi
804160124a: 31 c0                      	xorl	%eax, %eax
804160124c: ff d3                      	callq	*%rbx
;     assert(table_abbrev_code == abbrev_code);
804160124e: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041601258: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041601262: 48 b9 ba 58 60 41 80 00 00 00      	movabsq	$550852647098, %rcx
804160126c: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041601276: be 51 01 00 00             	movl	$337, %esi
804160127b: 31 c0                      	xorl	%eax, %eax
804160127d: ff d3                      	callq	*%rbx
;     assert(tag == DW_TAG_compile_unit);
804160127f: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041601289: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041601293: 48 b9 ef 5a 60 41 80 00 00 00      	movabsq	$550852647663, %rcx
804160129d: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416012a7: be 55 01 00 00             	movl	$341, %esi
80416012ac: 31 c0                      	xorl	%eax, %eax
80416012ae: ff d3                      	callq	*%rbx

00000080416012b0 file_name_by_info:
;                   char *buf, int buflen, Dwarf_Off *line_off) {
80416012b0: 55                         	pushq	%rbp
80416012b1: 48 89 e5                   	movq	%rsp, %rbp
80416012b4: 41 57                      	pushq	%r15
80416012b6: 41 56                      	pushq	%r14
80416012b8: 41 55                      	pushq	%r13
80416012ba: 41 54                      	pushq	%r12
80416012bc: 53                         	pushq	%rbx
80416012bd: 48 83 ec 58                	subq	$88, %rsp
80416012c1: 4c 89 45 98                	movq	%r8, -104(%rbp)
80416012c5: 89 4d c4                   	movl	%ecx, -60(%rbp)
80416012c8: 48 89 55 a8                	movq	%rdx, -88(%rbp)
;   if (offset > addrs->info_end - addrs->info_begin) {
80416012cc: 48 8b 5f 20                	movq	32(%rdi), %rbx
80416012d0: 48 89 7d a0                	movq	%rdi, -96(%rbp)
80416012d4: 48 8b 4f 28                	movq	40(%rdi), %rcx
80416012d8: 48 29 d9                   	subq	%rbx, %rcx
80416012db: b8 fd ff ff ff             	movl	$4294967293, %eax
80416012e0: 48 39 f1                   	cmpq	%rsi, %rcx
80416012e3: 0f 82 3f 02 00 00          	jb	575 <file_name_by_info+0x278>
;   const void *entry = addrs->info_begin + offset;
80416012e9: 48 01 f3                   	addq	%rsi, %rbx
;   unsigned long len = 0;
80416012ec: 48 c7 45 88 00 00 00 00    	movq	$0, -120(%rbp)
;   count             = dwarf_entry_len(entry, &len);
80416012f4: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
80416012fe: 48 8d 75 88                	leaq	-120(%rbp), %rsi
8041601302: 48 89 df                   	movq	%rbx, %rdi
8041601305: ff d0                      	callq	*%rax
;   if (count == 0) {
8041601307: 85 c0                      	testl	%eax, %eax
8041601309: 0f 84 14 02 00 00          	je	532 <file_name_by_info+0x273>
;     entry += count;
804160130f: 4c 63 f8                   	movslq	%eax, %r15
8041601312: 4a 8d 34 3b                	leaq	(%rbx,%r15), %rsi
;   Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
8041601316: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041601320: 48 8d 7d c8                	leaq	-56(%rbp), %rdi
8041601324: ba 02 00 00 00             	movl	$2, %edx
8041601329: ff d0                      	callq	*%rax
804160132b: 0f b7 45 c8                	movzwl	-56(%rbp), %eax
;   assert(version == 4 || version == 2);
804160132f: 66 83 f8 02                	cmpw	$2, %ax
8041601333: 74 0a                      	je	10 <file_name_by_info+0x8f>
8041601335: 66 83 f8 04                	cmpw	$4, %ax
8041601339: 0f 85 f8 01 00 00          	jne	504 <file_name_by_info+0x287>
804160133f: 4e 8d 34 3b                	leaq	(%rbx,%r15), %r14
8041601343: 49 83 c6 02                	addq	$2, %r14
8041601347: 48 8d 7d c8                	leaq	-56(%rbp), %rdi
;   Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
804160134b: ba 04 00 00 00             	movl	$4, %edx
8041601350: 4c 89 f6                   	movq	%r14, %rsi
8041601353: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
804160135d: 41 ff d4                   	callq	*%r12
8041601360: 8b 5d c8                   	movl	-56(%rbp), %ebx
;   entry += count;
8041601363: 4b 8d 34 3e                	leaq	(%r14,%r15), %rsi
8041601367: 48 8d 7d c8                	leaq	-56(%rbp), %rdi
;   Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
804160136b: ba 01 00 00 00             	movl	$1, %edx
8041601370: 41 ff d4                   	callq	*%r12
;   assert(address_size == 8);
8041601373: 80 7d c8 08                	cmpb	$8, -56(%rbp)
8041601377: 0f 85 eb 01 00 00          	jne	491 <file_name_by_info+0x2b8>
804160137d: 4d 01 fe                   	addq	%r15, %r14
8041601380: 49 83 c6 01                	addq	$1, %r14
;   unsigned abbrev_code = 0;
8041601384: c7 45 b4 00 00 00 00       	movl	$0, -76(%rbp)
;   count                = dwarf_read_uleb128(entry, &abbrev_code);
804160138b: 49 bd d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r13
8041601395: 48 8d 75 b4                	leaq	-76(%rbp), %rsi
8041601399: 4c 89 f7                   	movq	%r14, %rdi
804160139c: 41 ff d5                   	callq	*%r13
;   assert(abbrev_code != 0);
804160139f: 44 8b 65 b4                	movl	-76(%rbp), %r12d
80416013a3: 45 85 e4                   	testl	%r12d, %r12d
80416013a6: 0f 84 ed 01 00 00          	je	493 <file_name_by_info+0x2e9>
80416013ac: 49 89 c7                   	movq	%rax, %r15
80416013af: 48 8b 45 a0                	movq	-96(%rbp), %rax
;   const void *abbrev_entry   = addrs->abbrev_begin + abbrev_offset;
80416013b3: 48 03 18                   	addq	(%rax), %rbx
;   unsigned table_abbrev_code = 0;
80416013b6: c7 45 b8 00 00 00 00       	movl	$0, -72(%rbp)
80416013bd: 48 8d 75 b8                	leaq	-72(%rbp), %rsi
;   count                      = dwarf_read_uleb128(abbrev_entry, &table_abbrev_code);
80416013c1: 48 89 df                   	movq	%rbx, %rdi
80416013c4: 41 ff d5                   	callq	*%r13
;   assert(table_abbrev_code == abbrev_code);
80416013c7: 44 39 65 b8                	cmpl	%r12d, -72(%rbp)
80416013cb: 0f 85 f9 01 00 00          	jne	505 <file_name_by_info+0x31a>
80416013d1: 48 98                      	cltq
80416013d3: 48 01 c3                   	addq	%rax, %rbx
;   unsigned tag = 0;
80416013d6: c7 45 bc 00 00 00 00       	movl	$0, -68(%rbp)
80416013dd: 48 8d 75 bc                	leaq	-68(%rbp), %rsi
;   count        = dwarf_read_uleb128(abbrev_entry, &tag);
80416013e1: 48 89 df                   	movq	%rbx, %rdi
80416013e4: 41 ff d5                   	callq	*%r13
;   assert(tag == DW_TAG_compile_unit);
80416013e7: 83 7d bc 11                	cmpl	$17, -68(%rbp)
80416013eb: 0f 85 0a 02 00 00          	jne	522 <file_name_by_info+0x34b>
80416013f1: 49 63 cf                   	movslq	%r15d, %rcx
80416013f4: 49 01 ce                   	addq	%rcx, %r14
;   abbrev_entry += count;
80416013f7: 48 98                      	cltq
;   abbrev_entry++;
80416013f9: 4c 8d 3c 03                	leaq	(%rbx,%rax), %r15
80416013fd: 49 83 c7 01                	addq	$1, %r15
;   unsigned name = 0, form = 0;
8041601401: c7 45 c0 00 00 00 00       	movl	$0, -64(%rbp)
8041601408: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
804160140f: 48 83 7d a8 00             	cmpq	$0, -88(%rbp)
8041601414: 0f 95 c0                   	setne	%al
8041601417: 83 7d c4 07                	cmpl	$7, -60(%rbp)
804160141b: 0f 97 c1                   	seta	%cl
804160141e: 20 c1                      	andb	%al, %cl
8041601420: 88 4d d7                   	movb	%cl, -41(%rbp)
8041601423: eb 3a                      	jmp	58 <file_name_by_info+0x1af>
8041601425: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160142f: 90                         	nop
;       count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
8041601430: 31 d2                      	xorl	%edx, %edx
8041601432: 31 c9                      	xorl	%ecx, %ecx
8041601434: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
804160143e: ff d0                      	callq	*%rax
8041601440: 41 89 c5                   	movl	%eax, %r13d
8041601443: 4d 01 e7                   	addq	%r12, %r15
;     entry += count;
8041601446: 49 63 c5                   	movslq	%r13d, %rax
8041601449: 49 01 c6                   	addq	%rax, %r14
;   } while (name != 0 || form != 0);
804160144c: 0b 5d d0                   	orl	-48(%rbp), %ebx
804160144f: 49 bd d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r13
8041601459: 0f 84 c0 00 00 00          	je	192 <file_name_by_info+0x26f>
804160145f: 4c 89 fb                   	movq	%r15, %rbx
;     count = dwarf_read_uleb128(abbrev_entry, &name);
8041601462: 4c 89 ff                   	movq	%r15, %rdi
8041601465: 48 8d 75 c0                	leaq	-64(%rbp), %rsi
8041601469: 41 ff d5                   	callq	*%r13
;     abbrev_entry += count;
804160146c: 4c 63 f8                   	movslq	%eax, %r15
804160146f: 49 01 df                   	addq	%rbx, %r15
;     count = dwarf_read_uleb128(abbrev_entry, &form);
8041601472: 4c 89 ff                   	movq	%r15, %rdi
8041601475: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
8041601479: 41 ff d5                   	callq	*%r13
;     abbrev_entry += count;
804160147c: 4c 63 e0                   	movslq	%eax, %r12
;     if (name == DW_AT_name) {
804160147f: 8b 5d c0                   	movl	-64(%rbp), %ebx
8041601482: 83 fb 03                   	cmpl	$3, %ebx
8041601485: 75 69                      	jne	105 <file_name_by_info+0x240>
;       if (form == DW_FORM_strp) {
8041601487: 8b 75 d0                   	movl	-48(%rbp), %esi
804160148a: 83 fe 0e                   	cmpl	$14, %esi
804160148d: 0f 85 7d 00 00 00          	jne	125 <file_name_by_info+0x260>
;         unsigned long offset = 0;
8041601493: 48 c7 45 c8 00 00 00 00    	movq	$0, -56(%rbp)
;         count                = dwarf_read_abbrev_entry(
804160149b: 4c 89 f7                   	movq	%r14, %rdi
804160149e: 48 8d 55 c8                	leaq	-56(%rbp), %rdx
80416014a2: b9 08 00 00 00             	movl	$8, %ecx
80416014a7: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
80416014b1: ff d0                      	callq	*%rax
80416014b3: 41 89 c5                   	movl	%eax, %r13d
;         if (buf && buflen >= sizeof(const char **)) {
80416014b6: 80 7d d7 00                	cmpb	$0, -41(%rbp)
80416014ba: 74 87                      	je	-121 <file_name_by_info+0x193>
80416014bc: 48 8b 45 a0                	movq	-96(%rbp), %rax
;           put_unaligned(
80416014c0: 48 8b 40 40                	movq	64(%rax), %rax
80416014c4: 48 03 45 c8                	addq	-56(%rbp), %rax
80416014c8: 48 89 45 90                	movq	%rax, -112(%rbp)
80416014cc: ba 08 00 00 00             	movl	$8, %edx
80416014d1: 48 8b 7d a8                	movq	-88(%rbp), %rdi
80416014d5: 48 8d 75 90                	leaq	-112(%rbp), %rsi
80416014d9: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416014e3: ff d0                      	callq	*%rax
80416014e5: e9 59 ff ff ff             	jmp	-167 <file_name_by_info+0x193>
80416014ea: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
80416014f0: 8b 75 d0                   	movl	-48(%rbp), %esi
;       count = dwarf_read_abbrev_entry(entry, form, NULL, 0,
80416014f3: 4c 89 f7                   	movq	%r14, %rdi
;     } else if (name == DW_AT_stmt_list) {
80416014f6: 83 fb 10                   	cmpl	$16, %ebx
80416014f9: 0f 85 31 ff ff ff          	jne	-207 <file_name_by_info+0x180>
80416014ff: 48 8b 55 98                	movq	-104(%rbp), %rdx
;       count = dwarf_read_abbrev_entry(entry, form, line_off,
8041601503: b9 08 00 00 00             	movl	$8, %ecx
8041601508: e9 27 ff ff ff             	jmp	-217 <file_name_by_info+0x184>
804160150d: 0f 1f 00                   	nopl	(%rax)
;         count = dwarf_read_abbrev_entry(
8041601510: 4c 89 f7                   	movq	%r14, %rdi
8041601513: 48 8b 55 a8                	movq	-88(%rbp), %rdx
8041601517: 8b 4d c4                   	movl	-60(%rbp), %ecx
804160151a: e9 15 ff ff ff             	jmp	-235 <file_name_by_info+0x184>
804160151f: 31 c0                      	xorl	%eax, %eax
8041601521: eb 05                      	jmp	5 <file_name_by_info+0x278>
8041601523: b8 fa ff ff ff             	movl	$4294967290, %eax
; }
8041601528: 48 83 c4 58                	addq	$88, %rsp
804160152c: 5b                         	popq	%rbx
804160152d: 41 5c                      	popq	%r12
804160152f: 41 5d                      	popq	%r13
8041601531: 41 5e                      	popq	%r14
8041601533: 41 5f                      	popq	%r15
8041601535: 5d                         	popq	%rbp
8041601536: c3                         	retq
;   assert(version == 4 || version == 2);
8041601537: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041601541: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
804160154b: 48 b9 c3 59 60 41 80 00 00 00      	movabsq	$550852647363, %rcx
8041601555: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
804160155f: be 98 01 00 00             	movl	$408, %esi
8041601564: 31 c0                      	xorl	%eax, %eax
8041601566: ff d3                      	callq	*%rbx
;   assert(address_size == 8);
8041601568: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041601572: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
804160157c: 48 b9 8b 57 60 41 80 00 00 00      	movabsq	$550852646795, %rcx
8041601586: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041601590: be 9c 01 00 00             	movl	$412, %esi
8041601595: 31 c0                      	xorl	%eax, %eax
8041601597: ff d3                      	callq	*%rbx
;   assert(abbrev_code != 0);
8041601599: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
80416015a3: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
80416015ad: 48 b9 bf 56 60 41 80 00 00 00      	movabsq	$550852646591, %rcx
80416015b7: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416015c1: be a1 01 00 00             	movl	$417, %esi
80416015c6: 31 c0                      	xorl	%eax, %eax
80416015c8: ff d3                      	callq	*%rbx
;   assert(table_abbrev_code == abbrev_code);
80416015ca: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
80416015d4: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
80416015de: 48 b9 ba 58 60 41 80 00 00 00      	movabsq	$550852647098, %rcx
80416015e8: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416015f2: be a9 01 00 00             	movl	$425, %esi
80416015f7: 31 c0                      	xorl	%eax, %eax
80416015f9: ff d3                      	callq	*%rbx
;   assert(tag == DW_TAG_compile_unit);
80416015fb: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041601605: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
804160160f: 48 b9 ef 5a 60 41 80 00 00 00      	movabsq	$550852647663, %rcx
8041601619: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041601623: be ad 01 00 00             	movl	$429, %esi
8041601628: 31 c0                      	xorl	%eax, %eax
804160162a: ff d3                      	callq	*%rbx
804160162c: 0f 1f 40 00                	nopl	(%rax)

0000008041601630 dwarf_entry_len:
; dwarf_entry_len(const char *addr, unsigned long *len) {
8041601630: 55                         	pushq	%rbp
8041601631: 48 89 e5                   	movq	%rsp, %rbp
8041601634: 41 57                      	pushq	%r15
8041601636: 41 56                      	pushq	%r14
8041601638: 53                         	pushq	%rbx
8041601639: 48 83 ec 18                	subq	$24, %rsp
804160163d: 49 89 f6                   	movq	%rsi, %r14
8041601640: 48 89 fb                   	movq	%rdi, %rbx
;   initial_len = get_unaligned(addr, uint32_t);
8041601643: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
804160164d: 48 8d 7d e4                	leaq	-28(%rbp), %rdi
8041601651: ba 04 00 00 00             	movl	$4, %edx
8041601656: 48 89 de                   	movq	%rbx, %rsi
8041601659: 41 ff d7                   	callq	*%r15
804160165c: 8b 45 e4                   	movl	-28(%rbp), %eax
804160165f: 48 89 c1                   	movq	%rax, %rcx
8041601662: 48 c1 e9 04                	shrq	$4, %rcx
8041601666: 81 f9 ff ff ff 0f          	cmpl	$268435455, %ecx
;   if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
804160166c: 72 21                      	jb	33 <dwarf_entry_len+0x5f>
;     if (initial_len == DW_EXT_DWARF64) {
804160166e: 83 f8 ff                   	cmpl	$-1, %eax
8041601671: 74 26                      	je	38 <dwarf_entry_len+0x69>
;       cprintf("Unknown DWARF extension\n");
8041601673: 48 bf e0 59 60 41 80 00 00 00      	movabsq	$550852647392, %rdi
804160167d: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041601687: 31 db                      	xorl	%ebx, %ebx
8041601689: 31 c0                      	xorl	%eax, %eax
804160168b: ff d1                      	callq	*%rcx
804160168d: eb 29                      	jmp	41 <dwarf_entry_len+0x88>
;     *len = initial_len;
804160168f: 49 89 06                   	movq	%rax, (%r14)
8041601692: bb 04 00 00 00             	movl	$4, %ebx
8041601697: eb 1f                      	jmp	31 <dwarf_entry_len+0x88>
;       *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
8041601699: 48 83 c3 20                	addq	$32, %rbx
804160169d: 48 8d 7d d8                	leaq	-40(%rbp), %rdi
80416016a1: ba 08 00 00 00             	movl	$8, %edx
80416016a6: 48 89 de                   	movq	%rbx, %rsi
80416016a9: 41 ff d7                   	callq	*%r15
80416016ac: 48 8b 45 d8                	movq	-40(%rbp), %rax
80416016b0: 49 89 06                   	movq	%rax, (%r14)
80416016b3: bb 0c 00 00 00             	movl	$12, %ebx
;   return count;
80416016b8: 89 d8                      	movl	%ebx, %eax
80416016ba: 48 83 c4 18                	addq	$24, %rsp
80416016be: 5b                         	popq	%rbx
80416016bf: 41 5e                      	popq	%r14
80416016c1: 41 5f                      	popq	%r15
80416016c3: 5d                         	popq	%rbp
80416016c4: c3                         	retq
80416016c5: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416016cf: 90                         	nop

00000080416016d0 dwarf_read_uleb128:
; dwarf_read_uleb128(const char *addr, unsigned int *ret) {
80416016d0: 55                         	pushq	%rbp
80416016d1: 48 89 e5                   	movq	%rsp, %rbp
80416016d4: 31 c0                      	xorl	%eax, %eax
80416016d6: 45 31 c9                   	xorl	%r9d, %r9d
80416016d9: 31 c9                      	xorl	%ecx, %ecx
80416016db: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     byte = *addr;
80416016e0: 44 0f b6 04 07             	movzbl	(%rdi,%rax), %r8d
;     result |= (byte & 0x7f) << shift;
80416016e5: 44 89 c2                   	movl	%r8d, %edx
80416016e8: 83 e2 7f                   	andl	$127, %edx
80416016eb: d3 e2                      	shll	%cl, %edx
80416016ed: 41 09 d1                   	orl	%edx, %r9d
;     shift += 7;
80416016f0: 83 c1 07                   	addl	$7, %ecx
;     if (!(byte & 0x80))
80416016f3: 48 83 c0 01                	addq	$1, %rax
80416016f7: 45 84 c0                   	testb	%r8b, %r8b
80416016fa: 78 e4                      	js	-28 <dwarf_read_uleb128+0x10>
;   *ret = result;
80416016fc: 44 89 0e                   	movl	%r9d, (%rsi)
;   return count;
80416016ff: 5d                         	popq	%rbp
8041601700: c3                         	retq
8041601701: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160170b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041601710 dwarf_read_abbrev_entry:
;                         int bufsize, unsigned address_size) {
8041601710: 55                         	pushq	%rbp
8041601711: 48 89 e5                   	movq	%rsp, %rbp
8041601714: 41 57                      	pushq	%r15
8041601716: 41 56                      	pushq	%r14
8041601718: 41 54                      	pushq	%r12
804160171a: 53                         	pushq	%rbx
804160171b: 48 83 ec 20                	subq	$32, %rsp
804160171f: 48 89 7d c8                	movq	%rdi, -56(%rbp)
8041601723: 31 db                      	xorl	%ebx, %ebx
;   switch (form) {
8041601725: 83 c6 ff                   	addl	$-1, %esi
8041601728: 83 fe 1f                   	cmpl	$31, %esi
804160172b: 0f 87 9d 04 00 00          	ja	1181 <dwarf_read_abbrev_entry+0x4be>
8041601731: 41 89 cf                   	movl	%ecx, %r15d
8041601734: 49 89 d6                   	movq	%rdx, %r14
8041601737: 48 89 f8                   	movq	%rdi, %rax
804160173a: 48 b9 a0 61 60 41 80 00 00 00      	movabsq	$550852649376, %rcx
8041601744: ff 24 f1                   	jmpq	*(%rcx,%rsi,8)
8041601747: 48 c7 45 d0 00 00 00 00    	movq	$0, -48(%rbp)
804160174f: 48 b9 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rcx
8041601759: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
804160175d: 48 89 c7                   	movq	%rax, %rdi
8041601760: ff d1                      	callq	*%rcx
8041601762: 89 c3                      	movl	%eax, %ebx
8041601764: 48 98                      	cltq
8041601766: 48 01 45 c8                	addq	%rax, -56(%rbp)
804160176a: 4d 85 f6                   	testq	%r14, %r14
804160176d: 0f 84 5b 04 00 00          	je	1115 <dwarf_read_abbrev_entry+0x4be>
8041601773: 41 83 ff 08                	cmpl	$8, %r15d
8041601777: 0f 82 51 04 00 00          	jb	1105 <dwarf_read_abbrev_entry+0x4be>
804160177d: 48 8b 45 d0                	movq	-48(%rbp), %rax
8041601781: 48 89 45 c0                	movq	%rax, -64(%rbp)
8041601785: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
804160178f: 48 8d 75 c0                	leaq	-64(%rbp), %rsi
8041601793: ba 08 00 00 00             	movl	$8, %edx
8041601798: e9 db 02 00 00             	jmp	731 <dwarf_read_abbrev_entry+0x368>
804160179d: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
80416017a7: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
80416017ab: ba 08 00 00 00             	movl	$8, %edx
80416017b0: 48 89 c6                   	movq	%rax, %rsi
80416017b3: 41 ff d4                   	callq	*%r12
80416017b6: 48 83 45 c8 08             	addq	$8, -56(%rbp)
80416017bb: 48 8b 45 d0                	movq	-48(%rbp), %rax
80416017bf: bb 08 00 00 00             	movl	$8, %ebx
80416017c4: 4d 85 f6                   	testq	%r14, %r14
80416017c7: 0f 84 01 04 00 00          	je	1025 <dwarf_read_abbrev_entry+0x4be>
80416017cd: 41 83 ff 08                	cmpl	$8, %r15d
80416017d1: 0f 82 f7 03 00 00          	jb	1015 <dwarf_read_abbrev_entry+0x4be>
80416017d7: 48 89 45 d0                	movq	%rax, -48(%rbp)
80416017db: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
80416017df: ba 08 00 00 00             	movl	$8, %edx
80416017e4: e9 8e 00 00 00             	jmp	142 <dwarf_read_abbrev_entry+0x167>
80416017e9: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
80416017f3: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
80416017f7: ba 02 00 00 00             	movl	$2, %edx
80416017fc: 48 89 c6                   	movq	%rax, %rsi
80416017ff: 41 ff d4                   	callq	*%r12
8041601802: 48 83 45 c8 02             	addq	$2, -56(%rbp)
8041601807: 0f b7 45 d0                	movzwl	-48(%rbp), %eax
804160180b: bb 02 00 00 00             	movl	$2, %ebx
8041601810: 4d 85 f6                   	testq	%r14, %r14
8041601813: 0f 84 b5 03 00 00          	je	949 <dwarf_read_abbrev_entry+0x4be>
8041601819: 41 83 ff 02                	cmpl	$2, %r15d
804160181d: 0f 82 ab 03 00 00          	jb	939 <dwarf_read_abbrev_entry+0x4be>
8041601823: 66 89 45 d0                	movw	%ax, -48(%rbp)
8041601827: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
804160182b: ba 02 00 00 00             	movl	$2, %edx
8041601830: eb 45                      	jmp	69 <dwarf_read_abbrev_entry+0x167>
8041601832: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
804160183c: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
8041601840: ba 04 00 00 00             	movl	$4, %edx
8041601845: 48 89 c6                   	movq	%rax, %rsi
8041601848: 41 ff d4                   	callq	*%r12
804160184b: 48 83 45 c8 04             	addq	$4, -56(%rbp)
8041601850: 8b 45 d0                   	movl	-48(%rbp), %eax
8041601853: bb 04 00 00 00             	movl	$4, %ebx
8041601858: 4d 85 f6                   	testq	%r14, %r14
804160185b: 0f 84 6d 03 00 00          	je	877 <dwarf_read_abbrev_entry+0x4be>
8041601861: 41 83 ff 04                	cmpl	$4, %r15d
8041601865: 0f 82 63 03 00 00          	jb	867 <dwarf_read_abbrev_entry+0x4be>
804160186b: 89 45 d0                   	movl	%eax, -48(%rbp)
804160186e: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
8041601872: ba 04 00 00 00             	movl	$4, %edx
8041601877: 4c 89 f7                   	movq	%r14, %rdi
804160187a: 41 ff d4                   	callq	*%r12
804160187d: e9 4c 03 00 00             	jmp	844 <dwarf_read_abbrev_entry+0x4be>
8041601882: 48 b9 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rcx
804160188c: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
8041601890: ba 01 00 00 00             	movl	$1, %edx
8041601895: 48 89 c6                   	movq	%rax, %rsi
8041601898: ff d1                      	callq	*%rcx
804160189a: 48 83 45 c8 01             	addq	$1, -56(%rbp)
804160189f: 8a 45 d0                   	movb	-48(%rbp), %al
80416018a2: bb 01 00 00 00             	movl	$1, %ebx
80416018a7: 4d 85 f6                   	testq	%r14, %r14
80416018aa: 0f 84 1e 03 00 00          	je	798 <dwarf_read_abbrev_entry+0x4be>
80416018b0: 45 85 ff                   	testl	%r15d, %r15d
80416018b3: 0f 84 15 03 00 00          	je	789 <dwarf_read_abbrev_entry+0x4be>
80416018b9: 41 88 06                   	movb	%al, (%r14)
80416018bc: e9 0d 03 00 00             	jmp	781 <dwarf_read_abbrev_entry+0x4be>
80416018c1: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
80416018c8: 48 b9 d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rcx
80416018d2: e9 62 01 00 00             	jmp	354 <dwarf_read_abbrev_entry+0x329>
;       if (buf && bufsize >= sizeof(uintptr_t)) {
80416018d7: 4d 85 f6                   	testq	%r14, %r14
80416018da: 74 1d                      	je	29 <dwarf_read_abbrev_entry+0x1e9>
80416018dc: 41 83 ff 08                	cmpl	$8, %r15d
80416018e0: 72 17                      	jb	23 <dwarf_read_abbrev_entry+0x1e9>
;         memcpy(buf, entry, sizeof(uintptr_t));
80416018e2: 48 b9 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rcx
80416018ec: ba 08 00 00 00             	movl	$8, %edx
80416018f1: 4c 89 f7                   	movq	%r14, %rdi
80416018f4: 48 89 c6                   	movq	%rax, %rsi
80416018f7: ff d1                      	callq	*%rcx
;       entry += address_size;
80416018f9: 48 83 45 c8 08             	addq	$8, -56(%rbp)
80416018fe: bb 08 00 00 00             	movl	$8, %ebx
8041601903: e9 c6 02 00 00             	jmp	710 <dwarf_read_abbrev_entry+0x4be>
;       unsigned length = get_unaligned(entry, Dwarf_Half);
8041601908: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
8041601912: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
8041601916: ba 02 00 00 00             	movl	$2, %edx
804160191b: 48 89 c6                   	movq	%rax, %rsi
804160191e: 41 ff d7                   	callq	*%r15
8041601921: 0f b7 5d d0                	movzwl	-48(%rbp), %ebx
;       entry += sizeof(Dwarf_Half);
8041601925: 48 8b 45 c8                	movq	-56(%rbp), %rax
8041601929: 48 83 c0 02                	addq	$2, %rax
804160192d: 48 89 45 c8                	movq	%rax, -56(%rbp)
;       struct Slice slice = {
8041601931: 48 89 45 d0                	movq	%rax, -48(%rbp)
8041601935: 89 5d d8                   	movl	%ebx, -40(%rbp)
;       if (buf) {
8041601938: 4d 85 f6                   	testq	%r14, %r14
804160193b: 74 0f                      	je	15 <dwarf_read_abbrev_entry+0x23c>
804160193d: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
;         memcpy(buf, &slice, sizeof(struct Slice));
8041601941: ba 10 00 00 00             	movl	$16, %edx
8041601946: 4c 89 f7                   	movq	%r14, %rdi
8041601949: 41 ff d7                   	callq	*%r15
;       entry += length;
804160194c: 89 d8                      	movl	%ebx, %eax
804160194e: 48 01 45 c8                	addq	%rax, -56(%rbp)
;       bytes = sizeof(Dwarf_Half) + length;
8041601952: 83 c3 02                   	addl	$2, %ebx
8041601955: e9 74 02 00 00             	jmp	628 <dwarf_read_abbrev_entry+0x4be>
;       unsigned length = get_unaligned(entry, uint32_t);
804160195a: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
8041601964: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
8041601968: ba 04 00 00 00             	movl	$4, %edx
804160196d: 48 89 c6                   	movq	%rax, %rsi
8041601970: 41 ff d7                   	callq	*%r15
8041601973: 8b 5d d0                   	movl	-48(%rbp), %ebx
;       entry += sizeof(uint32_t);
8041601976: 48 8b 45 c8                	movq	-56(%rbp), %rax
804160197a: 48 83 c0 04                	addq	$4, %rax
804160197e: 48 89 45 c8                	movq	%rax, -56(%rbp)
;       struct Slice slice = {
8041601982: 48 89 45 d0                	movq	%rax, -48(%rbp)
8041601986: 89 5d d8                   	movl	%ebx, -40(%rbp)
;       if (buf) {
8041601989: 4d 85 f6                   	testq	%r14, %r14
804160198c: 74 0f                      	je	15 <dwarf_read_abbrev_entry+0x28d>
804160198e: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
;         memcpy(buf, &slice, sizeof(struct Slice));
8041601992: ba 10 00 00 00             	movl	$16, %edx
8041601997: 4c 89 f7                   	movq	%r14, %rdi
804160199a: 41 ff d7                   	callq	*%r15
;       entry += length;
804160199d: 48 01 5d c8                	addq	%rbx, -56(%rbp)
;       bytes = sizeof(uint32_t) + length;
80416019a1: 83 c3 04                   	addl	$4, %ebx
80416019a4: e9 25 02 00 00             	jmp	549 <dwarf_read_abbrev_entry+0x4be>
;       if (buf && bufsize >= sizeof(char *)) {
80416019a9: 4d 85 f6                   	testq	%r14, %r14
80416019ac: 74 1e                      	je	30 <dwarf_read_abbrev_entry+0x2bc>
80416019ae: 41 83 ff 08                	cmpl	$8, %r15d
80416019b2: 72 18                      	jb	24 <dwarf_read_abbrev_entry+0x2bc>
;         memcpy(buf, &entry, sizeof(char *));
80416019b4: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416019be: 48 8d 75 c8                	leaq	-56(%rbp), %rsi
80416019c2: ba 08 00 00 00             	movl	$8, %edx
80416019c7: 4c 89 f7                   	movq	%r14, %rdi
80416019ca: ff d0                      	callq	*%rax
;       bytes = strlen(entry) + 1;
80416019cc: 48 8b 7d c8                	movq	-56(%rbp), %rdi
80416019d0: 48 b8 30 4f 60 41 80 00 00 00      	movabsq	$550852644656, %rax
80416019da: ff d0                      	callq	*%rax
80416019dc: 89 c3                      	movl	%eax, %ebx
80416019de: 83 c3 01                   	addl	$1, %ebx
80416019e1: e9 e8 01 00 00             	jmp	488 <dwarf_read_abbrev_entry+0x4be>
;       bool data = get_unaligned(entry, Dwarf_Small);
80416019e6: 48 b9 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rcx
80416019f0: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
80416019f4: ba 01 00 00 00             	movl	$1, %edx
80416019f9: 48 89 c6                   	movq	%rax, %rsi
80416019fc: ff d1                      	callq	*%rcx
;       entry += sizeof(Dwarf_Small);
80416019fe: 48 83 45 c8 01             	addq	$1, -56(%rbp)
;       bool data = get_unaligned(entry, Dwarf_Small);
8041601a03: 8a 45 d0                   	movb	-48(%rbp), %al
8041601a06: bb 01 00 00 00             	movl	$1, %ebx
;       if (buf && bufsize >= sizeof(bool)) {
8041601a0b: 4d 85 f6                   	testq	%r14, %r14
8041601a0e: 0f 84 ba 01 00 00          	je	442 <dwarf_read_abbrev_entry+0x4be>
8041601a14: 45 85 ff                   	testl	%r15d, %r15d
8041601a17: 0f 84 b1 01 00 00          	je	433 <dwarf_read_abbrev_entry+0x4be>
;       bool data = get_unaligned(entry, Dwarf_Small);
8041601a1d: 84 c0                      	testb	%al, %al
;         put_unaligned(data, (bool *)buf);
8041601a1f: 41 0f 95 06                	setne	(%r14)
8041601a23: e9 a6 01 00 00             	jmp	422 <dwarf_read_abbrev_entry+0x4be>
;       int data  = 0;
8041601a28: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
;       int count = dwarf_read_leb128(entry, &data);
8041601a2f: 48 b9 c0 2a 60 41 80 00 00 00      	movabsq	$550852635328, %rcx
8041601a39: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
8041601a3d: 48 89 c7                   	movq	%rax, %rdi
8041601a40: ff d1                      	callq	*%rcx
8041601a42: 48 89 c3                   	movq	%rax, %rbx
8041601a45: 48 63 c3                   	movslq	%ebx, %rax
8041601a48: 48 01 45 c8                	addq	%rax, -56(%rbp)
8041601a4c: 4d 85 f6                   	testq	%r14, %r14
8041601a4f: 0f 84 79 01 00 00          	je	377 <dwarf_read_abbrev_entry+0x4be>
8041601a55: 41 83 ff 04                	cmpl	$4, %r15d
8041601a59: 0f 82 6f 01 00 00          	jb	367 <dwarf_read_abbrev_entry+0x4be>
8041601a5f: 8b 45 d0                   	movl	-48(%rbp), %eax
8041601a62: 89 45 c0                   	movl	%eax, -64(%rbp)
8041601a65: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041601a6f: 48 8d 75 c0                	leaq	-64(%rbp), %rsi
8041601a73: ba 04 00 00 00             	movl	$4, %edx
8041601a78: 4c 89 f7                   	movq	%r14, %rdi
8041601a7b: ff d0                      	callq	*%rax
8041601a7d: e9 4c 01 00 00             	jmp	332 <dwarf_read_abbrev_entry+0x4be>
;       unsigned int form = 0;
8041601a82: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
;       int count         = dwarf_read_uleb128(entry, &form);
8041601a89: 48 b9 d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rcx
8041601a93: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
8041601a97: 48 89 c7                   	movq	%rax, %rdi
8041601a9a: ff d1                      	callq	*%rcx
;       entry += count;
8041601a9c: 48 63 d8                   	movslq	%eax, %rbx
8041601a9f: 48 8b 7d c8                	movq	-56(%rbp), %rdi
8041601aa3: 48 01 df                   	addq	%rbx, %rdi
8041601aa6: 48 89 7d c8                	movq	%rdi, -56(%rbp)
;       int read = dwarf_read_abbrev_entry(entry, form, buf, bufsize,
8041601aaa: 8b 75 d0                   	movl	-48(%rbp), %esi
8041601aad: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
8041601ab7: 4c 89 f2                   	movq	%r14, %rdx
8041601aba: 44 89 f9                   	movl	%r15d, %ecx
8041601abd: ff d0                      	callq	*%rax
;       bytes    = count + read;
8041601abf: 01 c3                      	addl	%eax, %ebx
8041601ac1: e9 08 01 00 00             	jmp	264 <dwarf_read_abbrev_entry+0x4be>
;       if (buf && sizeof(buf) >= sizeof(bool)) {
8041601ac6: 4d 85 f6                   	testq	%r14, %r14
8041601ac9: 0f 84 ff 00 00 00          	je	255 <dwarf_read_abbrev_entry+0x4be>
;         put_unaligned(true, (bool *)buf);
8041601acf: 41 c6 06 01                	movb	$1, (%r14)
8041601ad3: e9 f6 00 00 00             	jmp	246 <dwarf_read_abbrev_entry+0x4be>
;       unsigned length     = 0;
8041601ad8: c7 45 c0 00 00 00 00       	movl	$0, -64(%rbp)
;       unsigned long count = dwarf_read_uleb128(entry, &length);
8041601adf: 48 b9 d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rcx
8041601ae9: 48 8d 75 c0                	leaq	-64(%rbp), %rsi
8041601aed: 48 89 c7                   	movq	%rax, %rdi
8041601af0: ff d1                      	callq	*%rcx
8041601af2: 49 89 c7                   	movq	%rax, %r15
;       entry += count;
8041601af5: 48 03 45 c8                	addq	-56(%rbp), %rax
8041601af9: 48 89 45 c8                	movq	%rax, -56(%rbp)
;       struct Slice slice = {
8041601afd: 48 89 45 d0                	movq	%rax, -48(%rbp)
;           .len = length,
8041601b01: 8b 5d c0                   	movl	-64(%rbp), %ebx
;       struct Slice slice = {
8041601b04: 89 5d d8                   	movl	%ebx, -40(%rbp)
;       if (buf) {
8041601b07: 4d 85 f6                   	testq	%r14, %r14
8041601b0a: 74 18                      	je	24 <dwarf_read_abbrev_entry+0x414>
;         memcpy(buf, &slice, sizeof(struct Slice));
8041601b0c: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041601b16: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
8041601b1a: ba 10 00 00 00             	movl	$16, %edx
8041601b1f: 4c 89 f7                   	movq	%r14, %rdi
8041601b22: ff d0                      	callq	*%rax
;       entry += length;
8041601b24: 48 01 5d c8                	addq	%rbx, -56(%rbp)
;       bytes = count + length;
8041601b28: 44 01 fb                   	addl	%r15d, %ebx
8041601b2b: e9 9e 00 00 00             	jmp	158 <dwarf_read_abbrev_entry+0x4be>
;       unsigned length = get_unaligned(entry, Dwarf_Small);
8041601b30: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
8041601b3a: 48 8d 7d d0                	leaq	-48(%rbp), %rdi
8041601b3e: ba 01 00 00 00             	movl	$1, %edx
8041601b43: 48 89 c6                   	movq	%rax, %rsi
8041601b46: 41 ff d7                   	callq	*%r15
8041601b49: 0f b6 5d d0                	movzbl	-48(%rbp), %ebx
;       entry += sizeof(Dwarf_Small);
8041601b4d: 48 8b 45 c8                	movq	-56(%rbp), %rax
8041601b51: 48 83 c0 01                	addq	$1, %rax
8041601b55: 48 89 45 c8                	movq	%rax, -56(%rbp)
;       struct Slice slice = {
8041601b59: 48 89 45 d0                	movq	%rax, -48(%rbp)
8041601b5d: 89 5d d8                   	movl	%ebx, -40(%rbp)
;       if (buf) {
8041601b60: 4d 85 f6                   	testq	%r14, %r14
8041601b63: 74 0f                      	je	15 <dwarf_read_abbrev_entry+0x464>
8041601b65: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
;         memcpy(buf, &slice, sizeof(struct Slice));
8041601b69: ba 10 00 00 00             	movl	$16, %edx
8041601b6e: 4c 89 f7                   	movq	%r14, %rdi
8041601b71: 41 ff d7                   	callq	*%r15
;       entry += length;
8041601b74: 89 d8                      	movl	%ebx, %eax
8041601b76: 48 01 45 c8                	addq	%rax, -56(%rbp)
;       bytes = length + sizeof(Dwarf_Small);
8041601b7a: 83 c3 01                   	addl	$1, %ebx
8041601b7d: eb 4f                      	jmp	79 <dwarf_read_abbrev_entry+0x4be>
;       unsigned length     = 0;
8041601b7f: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
;       unsigned long count = dwarf_read_uleb128(entry, &length);
8041601b86: 48 b9 d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rcx
8041601b90: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
8041601b94: 48 89 c7                   	movq	%rax, %rdi
8041601b97: ff d1                      	callq	*%rcx
8041601b99: 48 89 c3                   	movq	%rax, %rbx
;       entry += count;
8041601b9c: 48 89 c6                   	movq	%rax, %rsi
8041601b9f: 48 03 75 c8                	addq	-56(%rbp), %rsi
8041601ba3: 48 89 75 c8                	movq	%rsi, -56(%rbp)
;       if (buf) {
8041601ba7: 4d 85 f6                   	testq	%r14, %r14
8041601baa: 74 19                      	je	25 <dwarf_read_abbrev_entry+0x4b5>
;         memcpy(buf, entry, MIN(length, bufsize));
8041601bac: 8b 55 d0                   	movl	-48(%rbp), %edx
8041601baf: 44 39 fa                   	cmpl	%r15d, %edx
8041601bb2: 41 0f 47 d7                	cmoval	%r15d, %edx
8041601bb6: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041601bc0: 4c 89 f7                   	movq	%r14, %rdi
8041601bc3: ff d0                      	callq	*%rax
;       entry += length;
8041601bc5: 8b 45 d0                   	movl	-48(%rbp), %eax
8041601bc8: 48 01 45 c8                	addq	%rax, -56(%rbp)
;       bytes = count + length;
8041601bcc: 01 c3                      	addl	%eax, %ebx
;   return bytes;
8041601bce: 89 d8                      	movl	%ebx, %eax
8041601bd0: 48 83 c4 20                	addq	$32, %rsp
8041601bd4: 5b                         	popq	%rbx
8041601bd5: 41 5c                      	popq	%r12
8041601bd7: 41 5e                      	popq	%r14
8041601bd9: 41 5f                      	popq	%r15
8041601bdb: 5d                         	popq	%rbp
8041601bdc: c3                         	retq
8041601bdd: 0f 1f 00                   	nopl	(%rax)

0000008041601be0 function_by_info:
;                  uintptr_t *offset) {
8041601be0: 55                         	pushq	%rbp
8041601be1: 48 89 e5                   	movq	%rsp, %rbp
8041601be4: 41 57                      	pushq	%r15
8041601be6: 41 56                      	pushq	%r14
8041601be8: 41 55                      	pushq	%r13
8041601bea: 41 54                      	pushq	%r12
8041601bec: 53                         	pushq	%rbx
8041601bed: 48 81 ec 98 00 00 00       	subq	$152, %rsp
8041601bf4: 4c 89 8d 58 ff ff ff       	movq	%r9, -168(%rbp)
8041601bfb: 44 89 45 ac                	movl	%r8d, -84(%rbp)
8041601bff: 48 89 4d 88                	movq	%rcx, -120(%rbp)
8041601c03: 48 89 d3                   	movq	%rdx, %rbx
8041601c06: 49 89 f7                   	movq	%rsi, %r15
8041601c09: 48 89 7d 90                	movq	%rdi, -112(%rbp)
;   const void *entry = addrs->info_begin + cu_offset;
8041601c0d: 48 03 5f 20                	addq	32(%rdi), %rbx
;   unsigned long len = 0;
8041601c11: 48 c7 85 60 ff ff ff 00 00 00 00   	movq	$0, -160(%rbp)
;   count             = dwarf_entry_len(entry, &len);
8041601c1c: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
8041601c26: 48 8d b5 60 ff ff ff       	leaq	-160(%rbp), %rsi
8041601c2d: 48 89 df                   	movq	%rbx, %rdi
8041601c30: ff d0                      	callq	*%rax
;   if (count == 0) {
8041601c32: 85 c0                      	testl	%eax, %eax
8041601c34: 0f 84 1d 04 00 00          	je	1053 <function_by_info+0x477>
;   entry += count;
8041601c3a: 4c 63 f0                   	movslq	%eax, %r14
8041601c3d: 4a 8d 34 33                	leaq	(%rbx,%r14), %rsi
8041601c41: 48 8b 85 60 ff ff ff       	movq	-160(%rbp), %rax
;   const void *entry_end = entry + len;
8041601c48: 48 01 f0                   	addq	%rsi, %rax
8041601c4b: 48 89 85 70 ff ff ff       	movq	%rax, -144(%rbp)
;   Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
8041601c52: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
8041601c5c: 48 8d 7d b8                	leaq	-72(%rbp), %rdi
8041601c60: ba 02 00 00 00             	movl	$2, %edx
8041601c65: 41 ff d4                   	callq	*%r12
8041601c68: 0f b7 45 b8                	movzwl	-72(%rbp), %eax
;   assert(version == 4 || version == 2);
8041601c6c: 66 83 f8 02                	cmpw	$2, %ax
8041601c70: 74 0a                      	je	10 <function_by_info+0x9c>
8041601c72: 66 83 f8 04                	cmpw	$4, %ax
8041601c76: 0f 85 f2 03 00 00          	jne	1010 <function_by_info+0x48e>
8041601c7c: 4c 89 bd 50 ff ff ff       	movq	%r15, -176(%rbp)
8041601c83: 4c 01 f3                   	addq	%r14, %rbx
8041601c86: 48 83 c3 02                	addq	$2, %rbx
8041601c8a: 48 8d 7d b8                	leaq	-72(%rbp), %rdi
;   Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
8041601c8e: ba 04 00 00 00             	movl	$4, %edx
8041601c93: 48 89 de                   	movq	%rbx, %rsi
8041601c96: 41 ff d4                   	callq	*%r12
8041601c99: 8b 45 b8                   	movl	-72(%rbp), %eax
8041601c9c: 48 89 45 80                	movq	%rax, -128(%rbp)
;   entry += count;
8041601ca0: 4c 01 f3                   	addq	%r14, %rbx
8041601ca3: 48 8d 7d b8                	leaq	-72(%rbp), %rdi
;   Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
8041601ca7: ba 01 00 00 00             	movl	$1, %edx
8041601cac: 48 89 de                   	movq	%rbx, %rsi
8041601caf: 41 ff d4                   	callq	*%r12
;   assert(address_size == 8);
8041601cb2: 80 7d b8 08                	cmpb	$8, -72(%rbp)
8041601cb6: 0f 85 e3 03 00 00          	jne	995 <function_by_info+0x4bf>
;   Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
8041601cbc: 48 83 c3 01                	addq	$1, %rbx
;   unsigned abbrev_code          = 0;
8041601cc0: c7 45 9c 00 00 00 00       	movl	$0, -100(%rbp)
;   unsigned table_abbrev_code    = 0;
8041601cc7: c7 45 a0 00 00 00 00       	movl	$0, -96(%rbp)
;   while (entry < entry_end) {
8041601cce: 48 3b 9d 70 ff ff ff       	cmpq	-144(%rbp), %rbx
8041601cd5: 0f 83 78 03 00 00          	jae	888 <function_by_info+0x473>
8041601cdb: 48 8b 45 90                	movq	-112(%rbp), %rax
8041601cdf: 48 8b 4d 80                	movq	-128(%rbp), %rcx
8041601ce3: 48 03 08                   	addq	(%rax), %rcx
8041601ce6: 48 89 4d 80                	movq	%rcx, -128(%rbp)
8041601cea: 48 83 7d 88 00             	cmpq	$0, -120(%rbp)
8041601cef: 0f 95 c0                   	setne	%al
8041601cf2: 83 7d ac 07                	cmpl	$7, -84(%rbp)
8041601cf6: 0f 97 c1                   	seta	%cl
8041601cf9: 20 c1                      	andb	%al, %cl
8041601cfb: 88 4d cf                   	movb	%cl, -49(%rbp)
8041601cfe: 49 be d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r14
8041601d08: eb 20                      	jmp	32 <function_by_info+0x14a>
8041601d0a: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
8041601d10: 31 c0                      	xorl	%eax, %eax
8041601d12: 85 c0                      	testl	%eax, %eax
8041601d14: 0f 85 39 03 00 00          	jne	825 <function_by_info+0x473>
8041601d1a: 4c 89 eb                   	movq	%r13, %rbx
8041601d1d: 4c 3b ad 70 ff ff ff       	cmpq	-144(%rbp), %r13
8041601d24: 0f 83 29 03 00 00          	jae	809 <function_by_info+0x473>
;     count = dwarf_read_uleb128(entry, &abbrev_code);
8041601d2a: 48 89 df                   	movq	%rbx, %rdi
8041601d2d: 48 8d 75 9c                	leaq	-100(%rbp), %rsi
8041601d31: 41 ff d6                   	callq	*%r14
;     entry += count;
8041601d34: 4c 63 e8                   	movslq	%eax, %r13
8041601d37: 49 01 dd                   	addq	%rbx, %r13
;     if (abbrev_code == 0) {
8041601d3a: 8b 45 9c                   	movl	-100(%rbp), %eax
8041601d3d: 89 45 b0                   	movl	%eax, -80(%rbp)
8041601d40: 85 c0                      	testl	%eax, %eax
8041601d42: 74 d6                      	je	-42 <function_by_info+0x13a>
8041601d44: 4c 89 6d c0                	movq	%r13, -64(%rbp)
;     unsigned name = 0, form = 0, tag = 0;
8041601d48: c7 45 d4 00 00 00 00       	movl	$0, -44(%rbp)
8041601d4f: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
8041601d56: c7 45 a4 00 00 00 00       	movl	$0, -92(%rbp)
8041601d5d: 48 8b 4d 80                	movq	-128(%rbp), %rcx
8041601d61: 49 89 cc                   	movq	%rcx, %r12
8041601d64: 48 8b 45 90                	movq	-112(%rbp), %rax
;     while ((const unsigned char *)curr_abbrev_entry <
8041601d68: 48 3b 48 08                	cmpq	8(%rax), %rcx
8041601d6c: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
8041601d70: 0f 83 7d 00 00 00          	jae	125 <function_by_info+0x213>
8041601d76: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
;       count = dwarf_read_uleb128(curr_abbrev_entry,
8041601d80: 4c 89 e7                   	movq	%r12, %rdi
8041601d83: 48 8d 75 a0                	leaq	-96(%rbp), %rsi
8041601d87: 41 ff d6                   	callq	*%r14
;       curr_abbrev_entry += count;
8041601d8a: 48 63 d8                   	movslq	%eax, %rbx
8041601d8d: 4c 01 e3                   	addq	%r12, %rbx
;       count = dwarf_read_uleb128(curr_abbrev_entry, &tag);
8041601d90: 48 89 df                   	movq	%rbx, %rdi
8041601d93: 48 8d 75 a4                	leaq	-92(%rbp), %rsi
8041601d97: 41 ff d6                   	callq	*%r14
;       curr_abbrev_entry += count;
8041601d9a: 48 98                      	cltq
;       curr_abbrev_entry++;
8041601d9c: 4c 8d 24 18                	leaq	(%rax,%rbx), %r12
8041601da0: 49 83 c4 01                	addq	$1, %r12
8041601da4: 8b 45 b0                   	movl	-80(%rbp), %eax
;       if (table_abbrev_code == abbrev_code) {
8041601da7: 39 45 a0                   	cmpl	%eax, -96(%rbp)
8041601daa: 74 47                      	je	71 <function_by_info+0x213>
8041601dac: 4d 89 ef                   	movq	%r13, %r15
8041601daf: 4c 8d 6d d4                	leaq	-44(%rbp), %r13
8041601db3: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041601dbd: 0f 1f 00                   	nopl	(%rax)
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041601dc0: 4c 89 e7                   	movq	%r12, %rdi
8041601dc3: 4c 89 ee                   	movq	%r13, %rsi
8041601dc6: 41 ff d6                   	callq	*%r14
;         curr_abbrev_entry += count;
8041601dc9: 48 63 d8                   	movslq	%eax, %rbx
8041601dcc: 4c 01 e3                   	addq	%r12, %rbx
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041601dcf: 48 89 df                   	movq	%rbx, %rdi
8041601dd2: 4c 89 fe                   	movq	%r15, %rsi
8041601dd5: 41 ff d6                   	callq	*%r14
;         curr_abbrev_entry += count;
8041601dd8: 4c 63 e0                   	movslq	%eax, %r12
8041601ddb: 49 01 dc                   	addq	%rbx, %r12
;       } while (name != 0 || form != 0);
8041601dde: 8b 45 d0                   	movl	-48(%rbp), %eax
8041601de1: 0b 45 d4                   	orl	-44(%rbp), %eax
8041601de4: 75 da                      	jne	-38 <function_by_info+0x1e0>
8041601de6: 48 8b 45 90                	movq	-112(%rbp), %rax
;     while ((const unsigned char *)curr_abbrev_entry <
8041601dea: 4c 3b 60 08                	cmpq	8(%rax), %r12
8041601dee: 4d 89 fd                   	movq	%r15, %r13
8041601df1: 72 8d                      	jb	-115 <function_by_info+0x1a0>
;     if (tag == DW_TAG_subprogram) {
8041601df3: 83 7d a4 2e                	cmpl	$46, -92(%rbp)
8041601df7: 0f 85 33 01 00 00          	jne	307 <function_by_info+0x350>
;       uintptr_t low_pc = 0, high_pc = 0;
8041601dfd: 48 c7 45 b8 00 00 00 00    	movq	$0, -72(%rbp)
8041601e05: 48 c7 85 78 ff ff ff 00 00 00 00   	movq	$0, -136(%rbp)
8041601e10: 31 c0                      	xorl	%eax, %eax
8041601e12: 48 89 45 b0                	movq	%rax, -80(%rbp)
;       unsigned name_form        = 0;
8041601e16: c7 45 a8 00 00 00 00       	movl	$0, -88(%rbp)
8041601e1d: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
8041601e21: eb 2f                      	jmp	47 <function_by_info+0x272>
8041601e23: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041601e2d: 0f 1f 00                   	nopl	(%rax)
8041601e30: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
8041601e34: 48 8b 5d c0                	movq	-64(%rbp), %rbx
8041601e38: 4d 01 fc                   	addq	%r15, %r12
;         entry += count;
8041601e3b: 48 98                      	cltq
8041601e3d: 48 01 c3                   	addq	%rax, %rbx
8041601e40: 48 89 5d c0                	movq	%rbx, -64(%rbp)
;       } while (name != 0 || form != 0);
8041601e44: 44 0b 6d d0                	orl	-48(%rbp), %r13d
8041601e48: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
8041601e4c: 0f 84 3e 01 00 00          	je	318 <function_by_info+0x3b0>
8041601e52: 4c 89 e3                   	movq	%r12, %rbx
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041601e55: 4c 89 e7                   	movq	%r12, %rdi
8041601e58: 41 ff d6                   	callq	*%r14
;         curr_abbrev_entry += count;
8041601e5b: 4c 63 e0                   	movslq	%eax, %r12
8041601e5e: 49 01 dc                   	addq	%rbx, %r12
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041601e61: 4c 89 e7                   	movq	%r12, %rdi
8041601e64: 4c 89 ee                   	movq	%r13, %rsi
8041601e67: 41 ff d6                   	callq	*%r14
;         curr_abbrev_entry += count;
8041601e6a: 4c 63 f8                   	movslq	%eax, %r15
;         if (name == DW_AT_low_pc) {
8041601e6d: 44 8b 6d d4                	movl	-44(%rbp), %r13d
8041601e71: 41 83 fd 03                	cmpl	$3, %r13d
8041601e75: 74 69                      	je	105 <function_by_info+0x300>
8041601e77: 41 83 fd 12                	cmpl	$18, %r13d
8041601e7b: 74 23                      	je	35 <function_by_info+0x2c0>
8041601e7d: 41 83 fd 11                	cmpl	$17, %r13d
8041601e81: 0f 85 79 00 00 00          	jne	121 <function_by_info+0x320>
;               entry, form, &low_pc,
8041601e87: 8b 75 d0                   	movl	-48(%rbp), %esi
8041601e8a: 48 8b 5d c0                	movq	-64(%rbp), %rbx
;           count = dwarf_read_abbrev_entry(
8041601e8e: 48 89 df                   	movq	%rbx, %rdi
8041601e91: 48 8d 55 b8                	leaq	-72(%rbp), %rdx
8041601e95: b9 08 00 00 00             	movl	$8, %ecx
8041601e9a: eb 72                      	jmp	114 <function_by_info+0x32e>
8041601e9c: 0f 1f 40 00                	nopl	(%rax)
;               entry, form, &high_pc,
8041601ea0: 8b 5d d0                   	movl	-48(%rbp), %ebx
8041601ea3: 48 8b 7d c0                	movq	-64(%rbp), %rdi
;           count = dwarf_read_abbrev_entry(
8041601ea7: 89 de                      	movl	%ebx, %esi
8041601ea9: 48 8d 95 78 ff ff ff       	leaq	-136(%rbp), %rdx
8041601eb0: b9 08 00 00 00             	movl	$8, %ecx
8041601eb5: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
8041601ebf: ff d0                      	callq	*%rax
;           if (form != DW_FORM_addr) {
8041601ec1: 83 fb 01                   	cmpl	$1, %ebx
8041601ec4: 0f 84 66 ff ff ff          	je	-154 <function_by_info+0x250>
;             high_pc += low_pc;
8041601eca: 48 8b 4d b8                	movq	-72(%rbp), %rcx
8041601ece: 48 01 8d 78 ff ff ff       	addq	%rcx, -136(%rbp)
8041601ed5: e9 56 ff ff ff             	jmp	-170 <function_by_info+0x250>
8041601eda: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
;             name_form     = form;
8041601ee0: 8b 45 d0                   	movl	-48(%rbp), %eax
8041601ee3: 89 45 a8                   	movl	%eax, -88(%rbp)
8041601ee6: 48 8b 5d c0                	movq	-64(%rbp), %rbx
8041601eea: 48 89 d8                   	movq	%rbx, %rax
8041601eed: 48 89 5d b0                	movq	%rbx, -80(%rbp)
8041601ef1: eb 11                      	jmp	17 <function_by_info+0x324>
8041601ef3: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041601efd: 0f 1f 00                   	nopl	(%rax)
8041601f00: 48 8b 5d c0                	movq	-64(%rbp), %rbx
;               entry, form, NULL, 0, address_size);
8041601f04: 8b 75 d0                   	movl	-48(%rbp), %esi
;           count = dwarf_read_abbrev_entry(
8041601f07: 48 89 df                   	movq	%rbx, %rdi
8041601f0a: 31 d2                      	xorl	%edx, %edx
8041601f0c: 31 c9                      	xorl	%ecx, %ecx
8041601f0e: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
8041601f18: ff d0                      	callq	*%rax
8041601f1a: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
8041601f1e: e9 15 ff ff ff             	jmp	-235 <function_by_info+0x258>
8041601f23: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041601f2d: 0f 1f 00                   	nopl	(%rax)
8041601f30: 4d 89 ef                   	movq	%r13, %r15
8041601f33: 4c 8b 6d c0                	movq	-64(%rbp), %r13
8041601f37: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041601f40: 4c 89 e7                   	movq	%r12, %rdi
8041601f43: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
8041601f47: 41 ff d6                   	callq	*%r14
;         curr_abbrev_entry += count;
8041601f4a: 48 63 d8                   	movslq	%eax, %rbx
8041601f4d: 4c 01 e3                   	addq	%r12, %rbx
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041601f50: 48 89 df                   	movq	%rbx, %rdi
8041601f53: 4c 89 fe                   	movq	%r15, %rsi
8041601f56: 41 ff d6                   	callq	*%r14
;         curr_abbrev_entry += count;
8041601f59: 4c 63 e0                   	movslq	%eax, %r12
8041601f5c: 49 01 dc                   	addq	%rbx, %r12
;             entry, form, NULL, 0, address_size);
8041601f5f: 8b 5d d0                   	movl	-48(%rbp), %ebx
;         count = dwarf_read_abbrev_entry(
8041601f62: 4c 89 ef                   	movq	%r13, %rdi
8041601f65: 89 de                      	movl	%ebx, %esi
8041601f67: 31 d2                      	xorl	%edx, %edx
8041601f69: 31 c9                      	xorl	%ecx, %ecx
8041601f6b: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
8041601f75: ff d0                      	callq	*%rax
;         entry += count;
8041601f77: 48 98                      	cltq
8041601f79: 49 01 c5                   	addq	%rax, %r13
;       } while (name != 0 || form != 0);
8041601f7c: 0b 5d d4                   	orl	-44(%rbp), %ebx
8041601f7f: 75 bf                      	jne	-65 <function_by_info+0x360>
8041601f81: e9 8a fd ff ff             	jmp	-630 <function_by_info+0x130>
8041601f86: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
;       if (p >= low_pc && p <= high_pc) {
8041601f90: 48 8b 4d b8                	movq	-72(%rbp), %rcx
8041601f94: 31 c0                      	xorl	%eax, %eax
8041601f96: 48 8b 95 50 ff ff ff       	movq	-176(%rbp), %rdx
8041601f9d: 48 39 d1                   	cmpq	%rdx, %rcx
8041601fa0: 0f 87 9c 00 00 00          	ja	156 <function_by_info+0x462>
8041601fa6: 48 39 95 78 ff ff ff       	cmpq	%rdx, -136(%rbp)
8041601fad: 0f 82 8f 00 00 00          	jb	143 <function_by_info+0x462>
8041601fb3: 48 8b 85 58 ff ff ff       	movq	-168(%rbp), %rax
;         *offset = low_pc;
8041601fba: 48 89 08                   	movq	%rcx, (%rax)
8041601fbd: 8b 75 a8                   	movl	-88(%rbp), %esi
;         if (name_form == DW_FORM_strp) {
8041601fc0: 83 fe 0e                   	cmpl	$14, %esi
8041601fc3: 75 61                      	jne	97 <function_by_info+0x446>
;           unsigned long str_offset = 0;
8041601fc5: 48 c7 85 68 ff ff ff 00 00 00 00   	movq	$0, -152(%rbp)
8041601fd0: 48 8b 7d b0                	movq	-80(%rbp), %rdi
;           count                    = dwarf_read_abbrev_entry(
8041601fd4: 48 8d 95 68 ff ff ff       	leaq	-152(%rbp), %rdx
8041601fdb: b9 08 00 00 00             	movl	$8, %ecx
8041601fe0: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
8041601fea: ff d0                      	callq	*%rax
;           if (buf &&
8041601fec: 80 7d cf 00                	cmpb	$0, -49(%rbp)
8041601ff0: 74 4b                      	je	75 <function_by_info+0x45d>
8041601ff2: 48 8b 45 90                	movq	-112(%rbp), %rax
;             put_unaligned(
8041601ff6: 48 8b 40 40                	movq	64(%rax), %rax
8041601ffa: 48 03 85 68 ff ff ff       	addq	-152(%rbp), %rax
8041602001: 48 89 85 48 ff ff ff       	movq	%rax, -184(%rbp)
8041602008: ba 08 00 00 00             	movl	$8, %edx
804160200d: 48 8b 7d 88                	movq	-120(%rbp), %rdi
8041602011: 48 8d b5 48 ff ff ff       	leaq	-184(%rbp), %rsi
8041602018: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041602022: ff d0                      	callq	*%rax
8041602024: eb 17                      	jmp	23 <function_by_info+0x45d>
8041602026: 48 8b 7d b0                	movq	-80(%rbp), %rdi
804160202a: 48 8b 55 88                	movq	-120(%rbp), %rdx
804160202e: 8b 4d ac                   	movl	-84(%rbp), %ecx
;           count = dwarf_read_abbrev_entry(
8041602031: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
804160203b: ff d0                      	callq	*%rax
804160203d: b8 01 00 00 00             	movl	$1, %eax
8041602042: 85 c0                      	testl	%eax, %eax
8041602044: 4c 8b 6d c0                	movq	-64(%rbp), %r13
8041602048: 0f 85 c4 fc ff ff          	jne	-828 <function_by_info+0x132>
804160204e: e9 bd fc ff ff             	jmp	-835 <function_by_info+0x130>
8041602053: 31 c0                      	xorl	%eax, %eax
8041602055: eb 05                      	jmp	5 <function_by_info+0x47c>
8041602057: b8 fa ff ff ff             	movl	$4294967290, %eax
; }
804160205c: 48 81 c4 98 00 00 00       	addq	$152, %rsp
8041602063: 5b                         	popq	%rbx
8041602064: 41 5c                      	popq	%r12
8041602066: 41 5d                      	popq	%r13
8041602068: 41 5e                      	popq	%r14
804160206a: 41 5f                      	popq	%r15
804160206c: 5d                         	popq	%rbp
804160206d: c3                         	retq
;   assert(version == 4 || version == 2);
804160206e: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041602078: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041602082: 48 b9 c3 59 60 41 80 00 00 00      	movabsq	$550852647363, %rcx
804160208c: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602096: be e6 01 00 00             	movl	$486, %esi
804160209b: 31 c0                      	xorl	%eax, %eax
804160209d: ff d3                      	callq	*%rbx
;   assert(address_size == 8);
804160209f: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
80416020a9: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
80416020b3: 48 b9 8b 57 60 41 80 00 00 00      	movabsq	$550852646795, %rcx
80416020bd: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416020c7: be ea 01 00 00             	movl	$490, %esi
80416020cc: 31 c0                      	xorl	%eax, %eax
80416020ce: ff d3                      	callq	*%rbx

00000080416020d0 address_by_fname:
;                  uintptr_t *offset) {
80416020d0: 55                         	pushq	%rbp
80416020d1: 48 89 e5                   	movq	%rsp, %rbp
80416020d4: 41 57                      	pushq	%r15
80416020d6: 41 56                      	pushq	%r14
80416020d8: 41 55                      	pushq	%r13
80416020da: 41 54                      	pushq	%r12
80416020dc: 53                         	pushq	%rbx
80416020dd: 48 83 ec 68                	subq	$104, %rsp
80416020e1: 48 89 d3                   	movq	%rdx, %rbx
80416020e4: 49 89 ff                   	movq	%rdi, %r15
;   const int flen = strlen(fname);
80416020e7: 48 b8 30 4f 60 41 80 00 00 00      	movabsq	$550852644656, %rax
80416020f1: 48 89 b5 70 ff ff ff       	movq	%rsi, -144(%rbp)
80416020f8: 48 89 f7                   	movq	%rsi, %rdi
80416020fb: ff d0                      	callq	*%rax
;   if (flen == 0)
80416020fd: 85 c0                      	testl	%eax, %eax
80416020ff: 0f 84 1d 04 00 00          	je	1053 <address_by_fname+0x452>
8041602105: 48 89 5d 88                	movq	%rbx, -120(%rbp)
;   const void *pubnames_entry = addrs->pubnames_begin;
8041602109: 49 8b 5f 50                	movq	80(%r15), %rbx
;   unsigned long len          = 0;
804160210d: 48 c7 45 90 00 00 00 00    	movq	$0, -112(%rbp)
8041602115: 49 bd 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r13
804160211f: 4c 8d 65 c8                	leaq	-56(%rbp), %r12
8041602123: 4c 89 7d b8                	movq	%r15, -72(%rbp)
8041602127: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
;   while ((const unsigned char *)pubnames_entry < addrs->pubnames_end) {
8041602130: 49 3b 5f 58                	cmpq	88(%r15), %rbx
8041602134: 0f 83 ec 03 00 00          	jae	1004 <address_by_fname+0x456>
;     count = dwarf_entry_len(pubnames_entry, &len);
804160213a: 48 89 df                   	movq	%rbx, %rdi
804160213d: 48 8d 75 90                	leaq	-112(%rbp), %rsi
8041602141: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
804160214b: ff d0                      	callq	*%rax
;     if (count == 0) {
804160214d: 85 c0                      	testl	%eax, %eax
804160214f: 0f 84 da 03 00 00          	je	986 <address_by_fname+0x45f>
;     pubnames_entry += count;
8041602155: 4c 63 f0                   	movslq	%eax, %r14
8041602158: 4a 8d 34 33                	leaq	(%rbx,%r14), %rsi
804160215c: 4c 8b 7d 90                	movq	-112(%rbp), %r15
;     const void *pubnames_entry_end = pubnames_entry + len;
8041602160: 49 01 f7                   	addq	%rsi, %r15
;     Dwarf_Half version             = get_unaligned(pubnames_entry, Dwarf_Half);
8041602163: ba 02 00 00 00             	movl	$2, %edx
8041602168: 4c 89 e7                   	movq	%r12, %rdi
804160216b: 41 ff d5                   	callq	*%r13
;     assert(version == 2);
804160216e: 66 83 7d c8 02             	cmpw	$2, -56(%rbp)
8041602173: 0f 85 cf 03 00 00          	jne	975 <address_by_fname+0x478>
8041602179: 4c 01 f3                   	addq	%r14, %rbx
804160217c: 48 83 c3 02                	addq	$2, %rbx
;     cu_offset = get_unaligned(pubnames_entry, uint32_t);
8041602180: ba 04 00 00 00             	movl	$4, %edx
8041602185: 4c 89 e7                   	movq	%r12, %rdi
8041602188: 48 89 de                   	movq	%rbx, %rsi
804160218b: 41 ff d5                   	callq	*%r13
804160218e: 44 8b 65 c8                	movl	-56(%rbp), %r12d
;     pubnames_entry += sizeof(uint32_t);
8041602192: 48 8d 7b 04                	leaq	4(%rbx), %rdi
;     count = dwarf_entry_len(pubnames_entry, &len);
8041602196: 48 8d 75 90                	leaq	-112(%rbp), %rsi
804160219a: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
80416021a4: ff d0                      	callq	*%rax
;     pubnames_entry += count;
80416021a6: 48 98                      	cltq
80416021a8: 48 01 c3                   	addq	%rax, %rbx
80416021ab: 48 83 c3 04                	addq	$4, %rbx
80416021af: 41 b6 01                   	movb	$1, %r14b
;     while (pubnames_entry < pubnames_entry_end) {
80416021b2: 4c 39 fb                   	cmpq	%r15, %rbx
80416021b5: 0f 83 c5 02 00 00          	jae	709 <address_by_fname+0x3b0>
80416021bb: 4c 89 65 b0                	movq	%r12, -80(%rbp)
80416021bf: 90                         	nop
;       func_offset = get_unaligned(pubnames_entry, uint32_t);
80416021c0: ba 04 00 00 00             	movl	$4, %edx
80416021c5: 48 8d 7d c8                	leaq	-56(%rbp), %rdi
80416021c9: 48 89 de                   	movq	%rbx, %rsi
80416021cc: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416021d6: ff d0                      	callq	*%rax
80416021d8: 44 8b 65 c8                	movl	-56(%rbp), %r12d
;       pubnames_entry += sizeof(uint32_t);
80416021dc: 48 83 c3 04                	addq	$4, %rbx
;       func_offset = get_unaligned(pubnames_entry, uint32_t);
80416021e0: 4d 85 e4                   	testq	%r12, %r12
;       if (func_offset == 0) {
80416021e3: 0f 84 97 02 00 00          	je	663 <address_by_fname+0x3b0>
80416021e9: 48 8b bd 70 ff ff ff       	movq	-144(%rbp), %rdi
;       if (!strcmp(fname, pubnames_entry)) {
80416021f0: 48 89 de                   	movq	%rbx, %rsi
80416021f3: 48 b8 40 51 60 41 80 00 00 00      	movabsq	$550852645184, %rax
80416021fd: ff d0                      	callq	*%rax
80416021ff: 85 c0                      	testl	%eax, %eax
8041602201: 74 22                      	je	34 <address_by_fname+0x155>
;       pubnames_entry += strlen(pubnames_entry) + 1;
8041602203: 48 89 df                   	movq	%rbx, %rdi
8041602206: 48 b8 30 4f 60 41 80 00 00 00      	movabsq	$550852644656, %rax
8041602210: ff d0                      	callq	*%rax
8041602212: 48 98                      	cltq
8041602214: 48 01 c3                   	addq	%rax, %rbx
8041602217: 48 83 c3 01                	addq	$1, %rbx
;     while (pubnames_entry < pubnames_entry_end) {
804160221b: 4c 39 fb                   	cmpq	%r15, %rbx
804160221e: 72 a0                      	jb	-96 <address_by_fname+0xf0>
8041602220: e9 5b 02 00 00             	jmp	603 <address_by_fname+0x3b0>
8041602225: 48 8b 45 b8                	movq	-72(%rbp), %rax
8041602229: 4c 8b 75 b0                	movq	-80(%rbp), %r14
;         const void *entry      = addrs->info_begin + cu_offset;
804160222d: 4c 03 70 20                	addq	32(%rax), %r14
;         count                  = dwarf_entry_len(entry, &len);
8041602231: 4c 89 f7                   	movq	%r14, %rdi
8041602234: 48 8d 75 90                	leaq	-112(%rbp), %rsi
8041602238: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
8041602242: ff d0                      	callq	*%rax
;         if (count == 0) {
8041602244: 85 c0                      	testl	%eax, %eax
8041602246: 0f 84 27 02 00 00          	je	551 <address_by_fname+0x3a3>
;         entry += count;
804160224c: 4c 63 e8                   	movslq	%eax, %r13
804160224f: 4d 89 f7                   	movq	%r14, %r15
8041602252: 4b 8d 34 2e                	leaq	(%r14,%r13), %rsi
;         Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
8041602256: ba 02 00 00 00             	movl	$2, %edx
804160225b: 4c 8d 75 c8                	leaq	-56(%rbp), %r14
804160225f: 4c 89 f7                   	movq	%r14, %rdi
8041602262: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
804160226c: ff d0                      	callq	*%rax
804160226e: 0f b7 45 c8                	movzwl	-56(%rbp), %eax
;         assert(version == 4 || version == 2);
8041602272: 66 83 f8 02                	cmpw	$2, %ax
8041602276: 74 0a                      	je	10 <address_by_fname+0x1b2>
8041602278: 66 83 f8 04                	cmpw	$4, %ax
804160227c: 0f 85 f7 02 00 00          	jne	759 <address_by_fname+0x4a9>
8041602282: 4d 01 fd                   	addq	%r15, %r13
8041602285: 49 83 c5 02                	addq	$2, %r13
;         Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
8041602289: ba 04 00 00 00             	movl	$4, %edx
804160228e: 4c 89 f7                   	movq	%r14, %rdi
8041602291: 4c 89 ee                   	movq	%r13, %rsi
8041602294: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
804160229e: ff d0                      	callq	*%rax
80416022a0: 8b 45 c8                   	movl	-56(%rbp), %eax
80416022a3: 48 89 45 b0                	movq	%rax, -80(%rbp)
;         entry += sizeof(uint32_t);
80416022a7: 49 83 c5 04                	addq	$4, %r13
80416022ab: 4c 89 f7                   	movq	%r14, %rdi
80416022ae: 48 8b 45 b8                	movq	-72(%rbp), %rax
;         const void *abbrev_entry = addrs->abbrev_begin + abbrev_offset;
80416022b2: 4c 8b 30                   	movq	(%rax), %r14
;         Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
80416022b5: ba 01 00 00 00             	movl	$1, %edx
80416022ba: 4c 89 ee                   	movq	%r13, %rsi
80416022bd: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416022c7: ff d0                      	callq	*%rax
;         assert(address_size == 8);
80416022c9: 80 7d c8 08                	cmpb	$8, -56(%rbp)
80416022cd: 0f 85 d7 02 00 00          	jne	727 <address_by_fname+0x4da>
80416022d3: 4d 01 e7                   	addq	%r12, %r15
;         const void *abbrev_entry = addrs->abbrev_begin + abbrev_offset;
80416022d6: 4c 03 75 b0                	addq	-80(%rbp), %r14
;         unsigned abbrev_code       = 0;
80416022da: c7 45 9c 00 00 00 00       	movl	$0, -100(%rbp)
;         unsigned table_abbrev_code = 0;
80416022e1: c7 45 a0 00 00 00 00       	movl	$0, -96(%rbp)
80416022e8: 4c 89 7d b0                	movq	%r15, -80(%rbp)
;         count                      = dwarf_read_uleb128(entry, &abbrev_code);
80416022ec: 4c 89 ff                   	movq	%r15, %rdi
80416022ef: 48 8d 75 9c                	leaq	-100(%rbp), %rsi
80416022f3: 48 b8 d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rax
80416022fd: ff d0                      	callq	*%rax
;         entry += count;
80416022ff: 48 98                      	cltq
8041602301: 48 89 45 80                	movq	%rax, -128(%rbp)
;         unsigned name = 0, form = 0, tag = 0;
8041602305: c7 45 d4 00 00 00 00       	movl	$0, -44(%rbp)
804160230c: c7 45 c4 00 00 00 00       	movl	$0, -60(%rbp)
8041602313: c7 45 a4 00 00 00 00       	movl	$0, -92(%rbp)
804160231a: 48 8b 45 b8                	movq	-72(%rbp), %rax
;         while ((const unsigned char *)abbrev_entry < addrs->abbrev_end) { // unsafe needs
804160231e: 4c 3b 70 08                	cmpq	8(%rax), %r14
8041602322: 48 89 9d 78 ff ff ff       	movq	%rbx, -136(%rbp)
8041602329: 4c 8d 6d c4                	leaq	-60(%rbp), %r13
804160232d: 0f 83 94 00 00 00          	jae	148 <address_by_fname+0x2f7>
8041602333: 8b 45 9c                   	movl	-100(%rbp), %eax
8041602336: 89 45 a8                   	movl	%eax, -88(%rbp)
8041602339: 0f 1f 80 00 00 00 00       	nopl	(%rax)
;           count = dwarf_read_uleb128(
8041602340: 4c 89 f7                   	movq	%r14, %rdi
8041602343: 48 8d 75 a0                	leaq	-96(%rbp), %rsi
8041602347: 49 bc d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r12
8041602351: 41 ff d4                   	callq	*%r12
;           abbrev_entry += count;
8041602354: 48 63 d8                   	movslq	%eax, %rbx
8041602357: 4c 01 f3                   	addq	%r14, %rbx
;           count = dwarf_read_uleb128(
804160235a: 48 89 df                   	movq	%rbx, %rdi
804160235d: 48 8d 75 a4                	leaq	-92(%rbp), %rsi
8041602361: 41 ff d4                   	callq	*%r12
;           abbrev_entry += count;
8041602364: 48 98                      	cltq
;           abbrev_entry++;
8041602366: 4c 8d 34 18                	leaq	(%rax,%rbx), %r14
804160236a: 49 83 c6 01                	addq	$1, %r14
804160236e: 8b 45 a8                   	movl	-88(%rbp), %eax
;           if (table_abbrev_code == abbrev_code) {
8041602371: 39 45 a0                   	cmpl	%eax, -96(%rbp)
8041602374: 74 51                      	je	81 <address_by_fname+0x2f7>
8041602376: 49 bc d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r12
8041602380: 4d 89 ef                   	movq	%r13, %r15
8041602383: 4c 8d 6d d4                	leaq	-44(%rbp), %r13
8041602387: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
;             count = dwarf_read_uleb128(
8041602390: 4c 89 f7                   	movq	%r14, %rdi
8041602393: 4c 89 ee                   	movq	%r13, %rsi
8041602396: 41 ff d4                   	callq	*%r12
;             abbrev_entry += count;
8041602399: 48 63 d8                   	movslq	%eax, %rbx
804160239c: 4c 01 f3                   	addq	%r14, %rbx
;             count = dwarf_read_uleb128(
804160239f: 48 89 df                   	movq	%rbx, %rdi
80416023a2: 4c 89 fe                   	movq	%r15, %rsi
80416023a5: 41 ff d4                   	callq	*%r12
;             abbrev_entry += count;
80416023a8: 4c 63 f0                   	movslq	%eax, %r14
80416023ab: 49 01 de                   	addq	%rbx, %r14
;           } while (name != 0 || form != 0);
80416023ae: 8b 45 c4                   	movl	-60(%rbp), %eax
80416023b1: 0b 45 d4                   	orl	-44(%rbp), %eax
80416023b4: 75 da                      	jne	-38 <address_by_fname+0x2c0>
80416023b6: 48 8b 45 b8                	movq	-72(%rbp), %rax
;         while ((const unsigned char *)abbrev_entry < addrs->abbrev_end) { // unsafe needs
80416023ba: 4c 3b 70 08                	cmpq	8(%rax), %r14
80416023be: 4d 89 fd                   	movq	%r15, %r13
80416023c1: 0f 82 79 ff ff ff          	jb	-135 <address_by_fname+0x270>
80416023c7: 48 8b 45 80                	movq	-128(%rbp), %rax
80416023cb: 48 01 45 b0                	addq	%rax, -80(%rbp)
;         if (tag == DW_TAG_subprogram) {
80416023cf: 83 7d a4 2e                	cmpl	$46, -92(%rbp)
80416023d3: 0f 85 c7 00 00 00          	jne	199 <address_by_fname+0x3d0>
;           uintptr_t low_pc = 0;
80416023d9: 48 c7 45 c8 00 00 00 00    	movq	$0, -56(%rbp)
80416023e1: 48 bb d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rbx
80416023eb: eb 43                      	jmp	67 <address_by_fname+0x360>
80416023ed: 0f 1f 00                   	nopl	(%rax)
80416023f0: 48 8b 5d b0                	movq	-80(%rbp), %rbx
;               count = dwarf_read_abbrev_entry(entry, form, NULL, 0, address_size);
80416023f4: 48 89 df                   	movq	%rbx, %rdi
80416023f7: 44 89 ee                   	movl	%r13d, %esi
80416023fa: 31 d2                      	xorl	%edx, %edx
80416023fc: 31 c9                      	xorl	%ecx, %ecx
80416023fe: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
8041602408: ff d0                      	callq	*%rax
804160240a: 4c 03 65 a8                	addq	-88(%rbp), %r12
;             entry += count;
804160240e: 48 98                      	cltq
8041602410: 48 01 c3                   	addq	%rax, %rbx
8041602413: 48 89 5d b0                	movq	%rbx, -80(%rbp)
;           } while (name || form);
8041602417: 45 09 f5                   	orl	%r14d, %r13d
804160241a: 4d 89 e6                   	movq	%r12, %r14
804160241d: 48 bb d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %rbx
8041602427: 4d 89 fd                   	movq	%r15, %r13
804160242a: 0f 84 cd 00 00 00          	je	205 <address_by_fname+0x42d>
;             count = dwarf_read_uleb128(abbrev_entry, &name);
8041602430: 4c 89 f7                   	movq	%r14, %rdi
8041602433: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
8041602437: ff d3                      	callq	*%rbx
;             abbrev_entry += count;
8041602439: 4c 63 e0                   	movslq	%eax, %r12
804160243c: 4d 01 f4                   	addq	%r14, %r12
;             count = dwarf_read_uleb128(abbrev_entry, &form);
804160243f: 4c 89 e7                   	movq	%r12, %rdi
8041602442: 4d 89 ef                   	movq	%r13, %r15
8041602445: 4c 89 ee                   	movq	%r13, %rsi
8041602448: ff d3                      	callq	*%rbx
;             abbrev_entry += count;
804160244a: 48 98                      	cltq
804160244c: 48 89 45 a8                	movq	%rax, -88(%rbp)
;             if (name == DW_AT_low_pc) {
8041602450: 44 8b 75 d4                	movl	-44(%rbp), %r14d
8041602454: 44 8b 6d c4                	movl	-60(%rbp), %r13d
8041602458: 41 83 fe 11                	cmpl	$17, %r14d
804160245c: 75 92                      	jne	-110 <address_by_fname+0x320>
804160245e: 48 8b 5d b0                	movq	-80(%rbp), %rbx
;               count = dwarf_read_abbrev_entry(entry, form, &low_pc, sizeof(low_pc), address_size);
8041602462: 48 89 df                   	movq	%rbx, %rdi
8041602465: 44 89 ee                   	movl	%r13d, %esi
8041602468: 48 8d 55 c8                	leaq	-56(%rbp), %rdx
804160246c: b9 08 00 00 00             	movl	$8, %ecx
8041602471: eb 8b                      	jmp	-117 <address_by_fname+0x32e>
8041602473: c7 45 a8 fa ff ff ff       	movl	$4294967290, -88(%rbp)
804160247a: 45 31 f6                   	xorl	%r14d, %r14d
804160247d: 0f 1f 00                   	nopl	(%rax)
8041602480: 4c 8b 7d b8                	movq	-72(%rbp), %r15
8041602484: 45 84 f6                   	testb	%r14b, %r14b
8041602487: 49 bd 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r13
8041602491: 4c 8d 65 c8                	leaq	-56(%rbp), %r12
8041602495: 0f 85 95 fc ff ff          	jne	-875 <address_by_fname+0x60>
804160249b: e9 96 00 00 00             	jmp	150 <address_by_fname+0x466>
80416024a0: 4c 8d 65 d4                	leaq	-44(%rbp), %r12
80416024a4: 4c 8b 6d b0                	movq	-80(%rbp), %r13
80416024a8: 0f 1f 84 00 00 00 00 00    	nopl	(%rax,%rax)
;             count = dwarf_read_uleb128(
80416024b0: 4c 89 f7                   	movq	%r14, %rdi
80416024b3: 4c 89 e6                   	movq	%r12, %rsi
80416024b6: 49 bf d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r15
80416024c0: 41 ff d7                   	callq	*%r15
;             abbrev_entry += count;
80416024c3: 48 63 d8                   	movslq	%eax, %rbx
80416024c6: 4c 01 f3                   	addq	%r14, %rbx
;             count = dwarf_read_uleb128(
80416024c9: 48 89 df                   	movq	%rbx, %rdi
80416024cc: 48 8d 75 c4                	leaq	-60(%rbp), %rsi
80416024d0: 41 ff d7                   	callq	*%r15
;             abbrev_entry += count;
80416024d3: 4c 63 f0                   	movslq	%eax, %r14
80416024d6: 49 01 de                   	addq	%rbx, %r14
;                 entry, form, NULL, 0,
80416024d9: 8b 5d c4                   	movl	-60(%rbp), %ebx
;             count = dwarf_read_abbrev_entry(
80416024dc: 4c 89 ef                   	movq	%r13, %rdi
80416024df: 89 de                      	movl	%ebx, %esi
80416024e1: 31 d2                      	xorl	%edx, %edx
80416024e3: 31 c9                      	xorl	%ecx, %ecx
80416024e5: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
80416024ef: ff d0                      	callq	*%rax
;             entry += count;
80416024f1: 48 98                      	cltq
80416024f3: 49 01 c5                   	addq	%rax, %r13
;           } while (name != 0 || form != 0);
80416024f6: 0b 5d d4                   	orl	-44(%rbp), %ebx
80416024f9: 75 b5                      	jne	-75 <address_by_fname+0x3e0>
80416024fb: eb 0b                      	jmp	11 <address_by_fname+0x438>
;           *offset = low_pc;
80416024fd: 48 8b 45 c8                	movq	-56(%rbp), %rax
8041602501: 48 8b 4d 88                	movq	-120(%rbp), %rcx
8041602505: 48 89 01                   	movq	%rax, (%rcx)
8041602508: 45 31 f6                   	xorl	%r14d, %r14d
804160250b: c7 45 a8 00 00 00 00       	movl	$0, -88(%rbp)
8041602512: 4c 8b 7d b8                	movq	-72(%rbp), %r15
8041602516: 48 8b 9d 78 ff ff ff       	movq	-136(%rbp), %rbx
804160251d: e9 62 ff ff ff             	jmp	-158 <address_by_fname+0x3b4>
8041602522: 31 c0                      	xorl	%eax, %eax
8041602524: eb 13                      	jmp	19 <address_by_fname+0x469>
8041602526: c7 45 a8 00 00 00 00       	movl	$0, -88(%rbp)
804160252d: eb 07                      	jmp	7 <address_by_fname+0x466>
804160252f: c7 45 a8 fa ff ff ff       	movl	$4294967290, -88(%rbp)
8041602536: 8b 45 a8                   	movl	-88(%rbp), %eax
; }
8041602539: 48 83 c4 68                	addq	$104, %rsp
804160253d: 5b                         	popq	%rbx
804160253e: 41 5c                      	popq	%r12
8041602540: 41 5d                      	popq	%r13
8041602542: 41 5e                      	popq	%r14
8041602544: 41 5f                      	popq	%r15
8041602546: 5d                         	popq	%rbp
8041602547: c3                         	retq
;     assert(version == 2);
8041602548: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041602552: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
804160255c: 48 b9 e7 54 60 41 80 00 00 00      	movabsq	$550852646119, %rcx
8041602566: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602570: be 73 02 00 00             	movl	$627, %esi
8041602575: 31 c0                      	xorl	%eax, %eax
8041602577: ff d3                      	callq	*%rbx
;         assert(version == 4 || version == 2);
8041602579: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041602583: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
804160258d: 48 b9 c3 59 60 41 80 00 00 00      	movabsq	$550852647363, %rcx
8041602597: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416025a1: be 89 02 00 00             	movl	$649, %esi
80416025a6: 31 c0                      	xorl	%eax, %eax
80416025a8: ff d3                      	callq	*%rbx
;         assert(address_size == 8);
80416025aa: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
80416025b4: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
80416025be: 48 b9 8b 57 60 41 80 00 00 00      	movabsq	$550852646795, %rcx
80416025c8: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416025d2: be 8e 02 00 00             	movl	$654, %esi
80416025d7: 31 c0                      	xorl	%eax, %eax
80416025d9: ff d3                      	callq	*%rbx
80416025db: 0f 1f 44 00 00             	nopl	(%rax,%rax)

00000080416025e0 naive_address_by_fname:
;                        uintptr_t *offset) {
80416025e0: 55                         	pushq	%rbp
80416025e1: 48 89 e5                   	movq	%rsp, %rbp
80416025e4: 41 57                      	pushq	%r15
80416025e6: 41 56                      	pushq	%r14
80416025e8: 41 55                      	pushq	%r13
80416025ea: 41 54                      	pushq	%r12
80416025ec: 53                         	pushq	%rbx
80416025ed: 48 83 ec 78                	subq	$120, %rsp
80416025f1: 48 89 95 70 ff ff ff       	movq	%rdx, -144(%rbp)
80416025f8: 48 89 fb                   	movq	%rdi, %rbx
;   const int flen = strlen(fname);
80416025fb: 48 b8 30 4f 60 41 80 00 00 00      	movabsq	$550852644656, %rax
8041602605: 48 89 75 88                	movq	%rsi, -120(%rbp)
8041602609: 48 89 f7                   	movq	%rsi, %rdi
804160260c: ff d0                      	callq	*%rax
;   if (flen == 0)
804160260e: 85 c0                      	testl	%eax, %eax
8041602610: 0f 84 2a 04 00 00          	je	1066 <naive_address_by_fname+0x460>
;   const void *entry = addrs->info_begin;
8041602616: 4c 8b 7b 20                	movq	32(%rbx), %r15
804160261a: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
8041602624: 48 89 5d a8                	movq	%rbx, -88(%rbp)
8041602628: eb 1a                      	jmp	26 <naive_address_by_fname+0x64>
804160262a: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
8041602630: c7 45 c4 fa ff ff ff       	movl	$4294967290, -60(%rbp)
8041602637: b8 01 00 00 00             	movl	$1, %eax
804160263c: 85 c0                      	testl	%eax, %eax
804160263e: 0f 85 03 04 00 00          	jne	1027 <naive_address_by_fname+0x467>
;   while ((const unsigned char *)entry < addrs->info_end) {
8041602644: 4c 3b 7b 28                	cmpq	40(%rbx), %r15
8041602648: 0f 83 f2 03 00 00          	jae	1010 <naive_address_by_fname+0x460>
;     unsigned long len = 0;
804160264e: 48 c7 85 78 ff ff ff 00 00 00 00   	movq	$0, -136(%rbp)
;     count             = dwarf_entry_len(entry, &len);
8041602659: 4c 89 ff                   	movq	%r15, %rdi
804160265c: 48 8d b5 78 ff ff ff       	leaq	-136(%rbp), %rsi
8041602663: 48 b8 30 16 60 41 80 00 00 00      	movabsq	$550852630064, %rax
804160266d: ff d0                      	callq	*%rax
;     if (count == 0) {
804160266f: 85 c0                      	testl	%eax, %eax
8041602671: 74 bd                      	je	-67 <naive_address_by_fname+0x50>
;     entry += count;
8041602673: 48 63 d8                   	movslq	%eax, %rbx
8041602676: 49 8d 34 1f                	leaq	(%r15,%rbx), %rsi
804160267a: 4c 8b ad 78 ff ff ff       	movq	-136(%rbp), %r13
;     const void *entry_end = entry + len;
8041602681: 49 01 f5                   	addq	%rsi, %r13
;     Dwarf_Half version = get_unaligned(entry, Dwarf_Half);
8041602684: ba 02 00 00 00             	movl	$2, %edx
8041602689: 48 8d 7d b0                	leaq	-80(%rbp), %rdi
804160268d: 41 ff d4                   	callq	*%r12
8041602690: 0f b7 45 b0                	movzwl	-80(%rbp), %eax
;     assert(version == 4 || version == 2);
8041602694: 66 83 f8 02                	cmpw	$2, %ax
8041602698: 74 0a                      	je	10 <naive_address_by_fname+0xc4>
804160269a: 66 83 f8 04                	cmpw	$4, %ax
804160269e: 0f 85 b5 03 00 00          	jne	949 <naive_address_by_fname+0x479>
80416026a4: 49 01 df                   	addq	%rbx, %r15
80416026a7: 49 83 c7 02                	addq	$2, %r15
;     Dwarf_Off abbrev_offset = get_unaligned(entry, uint32_t);
80416026ab: ba 04 00 00 00             	movl	$4, %edx
80416026b0: 4c 8d 75 b0                	leaq	-80(%rbp), %r14
80416026b4: 4c 89 f7                   	movq	%r14, %rdi
80416026b7: 4c 89 fe                   	movq	%r15, %rsi
80416026ba: 41 ff d4                   	callq	*%r12
80416026bd: 4c 89 e0                   	movq	%r12, %rax
80416026c0: 44 8b 65 b0                	movl	-80(%rbp), %r12d
;     entry += count;
80416026c4: 49 01 df                   	addq	%rbx, %r15
;     Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
80416026c7: ba 01 00 00 00             	movl	$1, %edx
80416026cc: 4c 89 f7                   	movq	%r14, %rdi
80416026cf: 4c 89 fe                   	movq	%r15, %rsi
80416026d2: ff d0                      	callq	*%rax
;     assert(address_size == 8);
80416026d4: 80 7d b0 08                	cmpb	$8, -80(%rbp)
80416026d8: 0f 85 ac 03 00 00          	jne	940 <naive_address_by_fname+0x4aa>
;     Dwarf_Small address_size = get_unaligned(entry++, Dwarf_Small);
80416026de: 49 83 c7 01                	addq	$1, %r15
;     unsigned abbrev_code          = 0;
80416026e2: c7 45 c8 00 00 00 00       	movl	$0, -56(%rbp)
;     unsigned table_abbrev_code    = 0;
80416026e9: c7 45 a0 00 00 00 00       	movl	$0, -96(%rbp)
80416026f0: 48 8b 45 a8                	movq	-88(%rbp), %rax
;     const void *abbrev_entry      = addrs->abbrev_begin + abbrev_offset;
80416026f4: 4c 03 20                   	addq	(%rax), %r12
80416026f7: 4c 89 a5 68 ff ff ff       	movq	%r12, -152(%rbp)
80416026fe: 49 be d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r14
8041602708: 48 8d 5d c8                	leaq	-56(%rbp), %rbx
804160270c: 4c 89 6d 98                	movq	%r13, -104(%rbp)
8041602710: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
804160271a: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
;     while (entry < entry_end) {
8041602720: 4d 39 ef                   	cmpq	%r13, %r15
8041602723: 0f 83 07 03 00 00          	jae	775 <naive_address_by_fname+0x450>
;       count = dwarf_read_uleb128(entry, &abbrev_code);
8041602729: 4c 89 ff                   	movq	%r15, %rdi
804160272c: 48 89 de                   	movq	%rbx, %rsi
804160272f: 41 ff d6                   	callq	*%r14
;       entry += count;
8041602732: 48 98                      	cltq
8041602734: 49 01 c7                   	addq	%rax, %r15
;       if (abbrev_code == 0) {
8041602737: 8b 45 c8                   	movl	-56(%rbp), %eax
804160273a: 85 c0                      	testl	%eax, %eax
804160273c: 74 e2                      	je	-30 <naive_address_by_fname+0x140>
804160273e: 89 45 90                   	movl	%eax, -112(%rbp)
;       unsigned name = 0, form = 0, tag = 0;
8041602741: c7 45 d0 00 00 00 00       	movl	$0, -48(%rbp)
8041602748: c7 45 d4 00 00 00 00       	movl	$0, -44(%rbp)
804160274f: c7 45 a4 00 00 00 00       	movl	$0, -92(%rbp)
8041602756: 48 8b 85 68 ff ff ff       	movq	-152(%rbp), %rax
804160275d: 49 89 c4                   	movq	%rax, %r12
8041602760: 48 8b 4d a8                	movq	-88(%rbp), %rcx
;       while ((const unsigned char *)curr_abbrev_entry < addrs->abbrev_end) { // unsafe needs to be
8041602764: 48 3b 41 08                	cmpq	8(%rcx), %rax
8041602768: 49 be d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r14
8041602772: 4c 89 7d b8                	movq	%r15, -72(%rbp)
8041602776: 0f 83 80 00 00 00          	jae	128 <naive_address_by_fname+0x21c>
804160277c: 0f 1f 40 00                	nopl	(%rax)
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041602780: 4c 89 e7                   	movq	%r12, %rdi
8041602783: 48 8d 75 a0                	leaq	-96(%rbp), %rsi
8041602787: 41 ff d6                   	callq	*%r14
804160278a: 4c 89 f1                   	movq	%r14, %rcx
;         curr_abbrev_entry += count;
804160278d: 4c 63 f0                   	movslq	%eax, %r14
8041602790: 4d 01 e6                   	addq	%r12, %r14
;         count = dwarf_read_uleb128(curr_abbrev_entry,
8041602793: 4c 89 f7                   	movq	%r14, %rdi
8041602796: 48 8d 75 a4                	leaq	-92(%rbp), %rsi
804160279a: ff d1                      	callq	*%rcx
;         curr_abbrev_entry += count;
804160279c: 48 98                      	cltq
;         curr_abbrev_entry++;
804160279e: 4e 8d 24 30                	leaq	(%rax,%r14), %r12
80416027a2: 49 83 c4 01                	addq	$1, %r12
80416027a6: 8b 45 90                   	movl	-112(%rbp), %eax
;         if (table_abbrev_code == abbrev_code) {
80416027a9: 39 45 a0                   	cmpl	%eax, -96(%rbp)
80416027ac: 74 44                      	je	68 <naive_address_by_fname+0x212>
80416027ae: 49 be d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r14
80416027b8: 4c 8d 7d d0                	leaq	-48(%rbp), %r15
80416027bc: 4c 8d 6d d4                	leaq	-44(%rbp), %r13
;           count = dwarf_read_uleb128(
80416027c0: 4c 89 e7                   	movq	%r12, %rdi
80416027c3: 4c 89 fe                   	movq	%r15, %rsi
80416027c6: 41 ff d6                   	callq	*%r14
;           curr_abbrev_entry += count;
80416027c9: 48 63 d8                   	movslq	%eax, %rbx
80416027cc: 4c 01 e3                   	addq	%r12, %rbx
;           count = dwarf_read_uleb128(
80416027cf: 48 89 df                   	movq	%rbx, %rdi
80416027d2: 4c 89 ee                   	movq	%r13, %rsi
80416027d5: 41 ff d6                   	callq	*%r14
;           curr_abbrev_entry += count;
80416027d8: 4c 63 e0                   	movslq	%eax, %r12
80416027db: 49 01 dc                   	addq	%rbx, %r12
;         } while (name != 0 || form != 0);
80416027de: 8b 45 d4                   	movl	-44(%rbp), %eax
80416027e1: 0b 45 d0                   	orl	-48(%rbp), %eax
80416027e4: 75 da                      	jne	-38 <naive_address_by_fname+0x1e0>
80416027e6: 48 8b 45 a8                	movq	-88(%rbp), %rax
;       while ((const unsigned char *)curr_abbrev_entry < addrs->abbrev_end) { // unsafe needs to be
80416027ea: 4c 3b 60 08                	cmpq	8(%rax), %r12
80416027ee: 72 90                      	jb	-112 <naive_address_by_fname+0x1a0>
80416027f0: eb 0a                      	jmp	10 <naive_address_by_fname+0x21c>
80416027f2: 49 be d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r14
;       if (tag == DW_TAG_subprogram || tag == DW_TAG_label) {
80416027fc: 8b 45 a4                   	movl	-92(%rbp), %eax
80416027ff: 83 f8 0a                   	cmpl	$10, %eax
8041602802: 74 09                      	je	9 <naive_address_by_fname+0x22d>
8041602804: 83 f8 2e                   	cmpl	$46, %eax
8041602807: 0f 85 74 01 00 00          	jne	372 <naive_address_by_fname+0x3a1>
;         uintptr_t low_pc = 0;
804160280d: 48 c7 45 b0 00 00 00 00    	movq	$0, -80(%rbp)
8041602815: c7 45 cc 00 00 00 00       	movl	$0, -52(%rbp)
804160281c: 4c 8d 6d d4                	leaq	-44(%rbp), %r13
8041602820: eb 52                      	jmp	82 <naive_address_by_fname+0x294>
8041602822: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160282c: 0f 1f 40 00                	nopl	(%rax)
;                 entry, form, &low_pc,
8041602830: 8b 75 d4                   	movl	-44(%rbp), %esi
8041602833: 48 8b 5d b8                	movq	-72(%rbp), %rbx
;             count = dwarf_read_abbrev_entry(
8041602837: 48 89 df                   	movq	%rbx, %rdi
804160283a: 48 8d 55 b0                	leaq	-80(%rbp), %rdx
804160283e: b9 08 00 00 00             	movl	$8, %ecx
8041602843: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
804160284d: ff d0                      	callq	*%rax
804160284f: 41 89 c6                   	movl	%eax, %r14d
8041602852: 4c 03 65 90                	addq	-112(%rbp), %r12
;           entry += count;
8041602856: 49 63 c6                   	movslq	%r14d, %rax
8041602859: 48 01 c3                   	addq	%rax, %rbx
804160285c: 48 89 5d b8                	movq	%rbx, -72(%rbp)
;         } while (name != 0 || form != 0);
8041602860: 44 0b 7d d4                	orl	-44(%rbp), %r15d
8041602864: 49 be d0 16 60 41 80 00 00 00      	movabsq	$550852630224, %r14
804160286e: 0f 84 e7 00 00 00          	je	231 <naive_address_by_fname+0x37b>
8041602874: 4c 89 e3                   	movq	%r12, %rbx
;           count = dwarf_read_uleb128(
8041602877: 4c 89 e7                   	movq	%r12, %rdi
804160287a: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
804160287e: 41 ff d6                   	callq	*%r14
;           curr_abbrev_entry += count;
8041602881: 4c 63 e0                   	movslq	%eax, %r12
8041602884: 49 01 dc                   	addq	%rbx, %r12
;           count = dwarf_read_uleb128(
8041602887: 4c 89 e7                   	movq	%r12, %rdi
804160288a: 4c 89 ee                   	movq	%r13, %rsi
804160288d: 41 ff d6                   	callq	*%r14
;           curr_abbrev_entry += count;
8041602890: 48 98                      	cltq
8041602892: 48 89 45 90                	movq	%rax, -112(%rbp)
;           if (name == DW_AT_low_pc) {
8041602896: 44 8b 7d d0                	movl	-48(%rbp), %r15d
804160289a: 41 83 ff 03                	cmpl	$3, %r15d
804160289e: 74 20                      	je	32 <naive_address_by_fname+0x2e0>
80416028a0: 41 83 ff 11                	cmpl	$17, %r15d
80416028a4: 74 8a                      	je	-118 <naive_address_by_fname+0x250>
;                 entry, form, NULL, 0,
80416028a6: 8b 75 d4                   	movl	-44(%rbp), %esi
80416028a9: 48 8b 5d b8                	movq	-72(%rbp), %rbx
;             count = dwarf_read_abbrev_entry(
80416028ad: 48 89 df                   	movq	%rbx, %rdi
80416028b0: e9 9d 00 00 00             	jmp	157 <naive_address_by_fname+0x372>
80416028b5: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416028bf: 90                         	nop
;             if (form == DW_FORM_strp) {
80416028c0: 44 8b 75 d4                	movl	-44(%rbp), %r14d
80416028c4: 41 83 fe 0e                	cmpl	$14, %r14d
80416028c8: 75 5b                      	jne	91 <naive_address_by_fname+0x345>
;                   str_offset = 0;
80416028ca: 48 c7 45 80 00 00 00 00    	movq	$0, -128(%rbp)
80416028d2: 48 8b 5d b8                	movq	-72(%rbp), %rbx
;               count          = dwarf_read_abbrev_entry(
80416028d6: 48 89 df                   	movq	%rbx, %rdi
80416028d9: 44 89 f6                   	movl	%r14d, %esi
80416028dc: 48 8d 55 80                	leaq	-128(%rbp), %rdx
80416028e0: b9 08 00 00 00             	movl	$8, %ecx
80416028e5: 48 b8 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %rax
80416028ef: ff d0                      	callq	*%rax
80416028f1: 41 89 c6                   	movl	%eax, %r14d
80416028f4: 48 8b 45 a8                	movq	-88(%rbp), %rax
;                               ->str_begin +
80416028f8: 48 8b 70 40                	movq	64(%rax), %rsi
80416028fc: 48 03 75 80                	addq	-128(%rbp), %rsi
8041602900: 48 8b 7d 88                	movq	-120(%rbp), %rdi
;               if (!strcmp(
8041602904: 48 b8 40 51 60 41 80 00 00 00      	movabsq	$550852645184, %rax
804160290e: ff d0                      	callq	*%rax
8041602910: 85 c0                      	testl	%eax, %eax
8041602912: b8 01 00 00 00             	movl	$1, %eax
8041602917: 8b 4d cc                   	movl	-52(%rbp), %ecx
804160291a: 0f 44 c8                   	cmovel	%eax, %ecx
804160291d: 89 4d cc                   	movl	%ecx, -52(%rbp)
8041602920: e9 2d ff ff ff             	jmp	-211 <naive_address_by_fname+0x272>
8041602925: 48 8b 7d 88                	movq	-120(%rbp), %rdi
8041602929: 48 8b 5d b8                	movq	-72(%rbp), %rbx
;               if (!strcmp(fname, entry)) {
804160292d: 48 89 de                   	movq	%rbx, %rsi
8041602930: 48 b8 40 51 60 41 80 00 00 00      	movabsq	$550852645184, %rax
804160293a: ff d0                      	callq	*%rax
804160293c: 85 c0                      	testl	%eax, %eax
804160293e: b8 01 00 00 00             	movl	$1, %eax
8041602943: 8b 4d cc                   	movl	-52(%rbp), %ecx
8041602946: 0f 44 c8                   	cmovel	%eax, %ecx
8041602949: 89 4d cc                   	movl	%ecx, -52(%rbp)
;               count = dwarf_read_abbrev_entry(
804160294c: 48 89 df                   	movq	%rbx, %rdi
804160294f: 44 89 f6                   	movl	%r14d, %esi
8041602952: 31 d2                      	xorl	%edx, %edx
8041602954: 31 c9                      	xorl	%ecx, %ecx
8041602956: e9 e8 fe ff ff             	jmp	-280 <naive_address_by_fname+0x263>
;         if (found) {
804160295b: 83 7d cc 00                	cmpl	$0, -52(%rbp)
804160295f: 0f 84 91 00 00 00          	je	145 <naive_address_by_fname+0x416>
;           *offset = low_pc;
8041602965: 48 8b 45 b0                	movq	-80(%rbp), %rax
8041602969: 48 8b 8d 70 ff ff ff       	movq	-144(%rbp), %rcx
8041602970: 48 89 01                   	movq	%rax, (%rcx)
8041602973: c7 45 c4 00 00 00 00       	movl	$0, -60(%rbp)
804160297a: b8 01 00 00 00             	movl	$1, %eax
804160297f: eb 77                      	jmp	119 <naive_address_by_fname+0x418>
8041602981: 4d 89 f5                   	movq	%r14, %r13
8041602984: 49 bf 10 17 60 41 80 00 00 00      	movabsq	$550852630288, %r15
804160298e: 48 8b 45 b8                	movq	-72(%rbp), %rax
8041602992: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160299c: 0f 1f 40 00                	nopl	(%rax)
80416029a0: 49 89 c6                   	movq	%rax, %r14
;           count = dwarf_read_uleb128(
80416029a3: 4c 89 e7                   	movq	%r12, %rdi
80416029a6: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
80416029aa: 41 ff d5                   	callq	*%r13
;           curr_abbrev_entry += count;
80416029ad: 48 63 d8                   	movslq	%eax, %rbx
80416029b0: 4c 01 e3                   	addq	%r12, %rbx
;           count = dwarf_read_uleb128(
80416029b3: 48 89 df                   	movq	%rbx, %rdi
80416029b6: 48 8d 75 d4                	leaq	-44(%rbp), %rsi
80416029ba: 41 ff d5                   	callq	*%r13
;           curr_abbrev_entry += count;
80416029bd: 4c 63 e0                   	movslq	%eax, %r12
80416029c0: 49 01 dc                   	addq	%rbx, %r12
;               entry, form, NULL, 0,
80416029c3: 8b 5d d4                   	movl	-44(%rbp), %ebx
;           count = dwarf_read_abbrev_entry(
80416029c6: 4c 89 f7                   	movq	%r14, %rdi
80416029c9: 89 de                      	movl	%ebx, %esi
80416029cb: 31 d2                      	xorl	%edx, %edx
80416029cd: 31 c9                      	xorl	%ecx, %ecx
80416029cf: 41 ff d7                   	callq	*%r15
;           entry += count;
80416029d2: 48 98                      	cltq
80416029d4: 4c 01 f0                   	addq	%r14, %rax
;         } while (name != 0 || form != 0);
80416029d7: 0b 5d d0                   	orl	-48(%rbp), %ebx
80416029da: 75 c4                      	jne	-60 <naive_address_by_fname+0x3c0>
80416029dc: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
80416029e6: 4d 89 ee                   	movq	%r13, %r14
80416029e9: 48 8d 5d c8                	leaq	-56(%rbp), %rbx
80416029ed: 49 89 c7                   	movq	%rax, %r15
80416029f0: 4c 8b 6d 98                	movq	-104(%rbp), %r13
80416029f4: eb 26                      	jmp	38 <naive_address_by_fname+0x43c>
80416029f6: 31 c0                      	xorl	%eax, %eax
80416029f8: 49 bc 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r12
8041602a02: 48 8d 5d c8                	leaq	-56(%rbp), %rbx
8041602a06: 4c 8b 7d b8                	movq	-72(%rbp), %r15
8041602a0a: 4c 8b 6d 98                	movq	-104(%rbp), %r13
8041602a0e: 85 c0                      	testl	%eax, %eax
8041602a10: 74 0a                      	je	10 <naive_address_by_fname+0x43c>
8041602a12: 85 c0                      	testl	%eax, %eax
8041602a14: 0f 84 06 fd ff ff          	je	-762 <naive_address_by_fname+0x140>
8041602a1a: eb 16                      	jmp	22 <naive_address_by_fname+0x452>
8041602a1c: 31 c0                      	xorl	%eax, %eax
8041602a1e: 85 c0                      	testl	%eax, %eax
8041602a20: 0f 84 fa fc ff ff          	je	-774 <naive_address_by_fname+0x140>
8041602a26: eb 0a                      	jmp	10 <naive_address_by_fname+0x452>
8041602a28: 0f 1f 84 00 00 00 00 00    	nopl	(%rax,%rax)
8041602a30: 31 c0                      	xorl	%eax, %eax
8041602a32: 48 8b 5d a8                	movq	-88(%rbp), %rbx
8041602a36: 85 c0                      	testl	%eax, %eax
8041602a38: 0f 84 06 fc ff ff          	je	-1018 <naive_address_by_fname+0x64>
8041602a3e: eb 07                      	jmp	7 <naive_address_by_fname+0x467>
8041602a40: c7 45 c4 00 00 00 00       	movl	$0, -60(%rbp)
8041602a47: 8b 45 c4                   	movl	-60(%rbp), %eax
; }
8041602a4a: 48 83 c4 78                	addq	$120, %rsp
8041602a4e: 5b                         	popq	%rbx
8041602a4f: 41 5c                      	popq	%r12
8041602a51: 41 5d                      	popq	%r13
8041602a53: 41 5e                      	popq	%r14
8041602a55: 41 5f                      	popq	%r15
8041602a57: 5d                         	popq	%rbp
8041602a58: c3                         	retq
;     assert(version == 4 || version == 2);
8041602a59: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041602a63: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041602a6d: 48 b9 c3 59 60 41 80 00 00 00      	movabsq	$550852647363, %rcx
8041602a77: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602a81: be f0 02 00 00             	movl	$752, %esi
8041602a86: 31 c0                      	xorl	%eax, %eax
8041602a88: ff d3                      	callq	*%rbx
;     assert(address_size == 8);
8041602a8a: 48 bf b6 59 60 41 80 00 00 00      	movabsq	$550852647350, %rdi
8041602a94: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041602a9e: 48 b9 8b 57 60 41 80 00 00 00      	movabsq	$550852646795, %rcx
8041602aa8: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602ab2: be f4 02 00 00             	movl	$756, %esi
8041602ab7: 31 c0                      	xorl	%eax, %eax
8041602ab9: ff d3                      	callq	*%rbx
8041602abb: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041602ac0 dwarf_read_leb128:
; dwarf_read_leb128(const char *addr, int *ret) {
8041602ac0: 55                         	pushq	%rbp
8041602ac1: 48 89 e5                   	movq	%rsp, %rbp
8041602ac4: 31 c0                      	xorl	%eax, %eax
8041602ac6: b9 f9 ff ff ff             	movl	$4294967289, %ecx
8041602acb: 45 31 c0                   	xorl	%r8d, %r8d
8041602ace: 66 90                      	nop
;     byte = *addr;
8041602ad0: 83 c1 07                   	addl	$7, %ecx
8041602ad3: 44 0f b6 0c 07             	movzbl	(%rdi,%rax), %r9d
;     result |= (byte & 0x7f) << shift;
8041602ad8: 44 89 ca                   	movl	%r9d, %edx
8041602adb: 83 e2 7f                   	andl	$127, %edx
8041602ade: d3 e2                      	shll	%cl, %edx
8041602ae0: 41 09 d0                   	orl	%edx, %r8d
;     if (!(byte & 0x80))
8041602ae3: 48 83 c0 01                	addq	$1, %rax
8041602ae7: 45 84 c9                   	testb	%r9b, %r9b
8041602aea: 78 e4                      	js	-28 <dwarf_read_leb128+0x10>
8041602aec: ba 80 ff ff ff             	movl	$4294967168, %edx
;   if ((shift < num_bits) && (byte & 0x40))
8041602af1: d3 e2                      	shll	%cl, %edx
8041602af3: 31 ff                      	xorl	%edi, %edi
8041602af5: 41 f6 c1 40                	testb	$64, %r9b
8041602af9: 0f 44 d7                   	cmovel	%edi, %edx
8041602afc: 83 f9 18                   	cmpl	$24, %ecx
8041602aff: 0f 47 d7                   	cmoval	%edi, %edx
8041602b02: 44 09 c2                   	orl	%r8d, %edx
;   *ret = result;
8041602b05: 89 16                      	movl	%edx, (%rsi)
;   return count;
8041602b07: 5d                         	popq	%rbp
8041602b08: c3                         	retq
8041602b09: cc                         	int3
8041602b0a: cc                         	int3
8041602b0b: cc                         	int3
8041602b0c: cc                         	int3
8041602b0d: cc                         	int3
8041602b0e: cc                         	int3
8041602b0f: cc                         	int3

0000008041602b10 line_for_address:
;                  Dwarf_Off line_offset, int *lineno_store) {
8041602b10: 55                         	pushq	%rbp
8041602b11: 48 89 e5                   	movq	%rsp, %rbp
8041602b14: 41 57                      	pushq	%r15
8041602b16: 41 56                      	pushq	%r14
8041602b18: 41 55                      	pushq	%r13
8041602b1a: 41 54                      	pushq	%r12
8041602b1c: 53                         	pushq	%rbx
8041602b1d: 48 83 ec 58                	subq	$88, %rsp
8041602b21: b8 fd ff ff ff             	movl	$4294967293, %eax
;   if (lineno_store == NULL) {
8041602b26: 48 85 c9                   	testq	%rcx, %rcx
;   if (line_offset > addrs->line_end - addrs->line_begin) {
8041602b29: 0f 84 ae 01 00 00          	je	430 <line_for_address+0x1cd>
8041602b2f: 49 89 cc                   	movq	%rcx, %r12
8041602b32: 48 8b 5f 30                	movq	48(%rdi), %rbx
8041602b36: 48 8b 4f 38                	movq	56(%rdi), %rcx
8041602b3a: 48 29 d9                   	subq	%rbx, %rcx
8041602b3d: 48 39 d1                   	cmpq	%rdx, %rcx
8041602b40: 0f 82 97 01 00 00          	jb	407 <line_for_address+0x1cd>
8041602b46: 49 89 f7                   	movq	%rsi, %r15
;   const void *curr_addr                  = addrs->line_begin + line_offset;
8041602b49: 48 01 d3                   	addq	%rdx, %rbx
8041602b4c: 48 b8 20 63 60 41 80 00 00 00      	movabsq	$550852649760, %rax
;   struct Line_Number_State current_state = {
8041602b56: 48 8b 48 10                	movq	16(%rax), %rcx
8041602b5a: 48 89 4d 90                	movq	%rcx, -112(%rbp)
8041602b5e: 0f 10 00                   	movups	(%rax), %xmm0
8041602b61: 0f 29 45 80                	movaps	%xmm0, -128(%rbp)
;   int count = dwarf_entry_len(curr_addr, &unit_length);
8041602b65: 49 be 80 2d 60 41 80 00 00 00      	movabsq	$550852636032, %r14
8041602b6f: 48 8d 75 98                	leaq	-104(%rbp), %rsi
8041602b73: 48 89 df                   	movq	%rbx, %rdi
8041602b76: 41 ff d6                   	callq	*%r14
;   if (count == 0) {
8041602b79: 85 c0                      	testl	%eax, %eax
8041602b7b: 0f 84 57 01 00 00          	je	343 <line_for_address+0x1c8>
8041602b81: 4c 89 7d a8                	movq	%r15, -88(%rbp)
;     curr_addr += count;
8041602b85: 4c 63 f8                   	movslq	%eax, %r15
8041602b88: 4a 8d 34 3b                	leaq	(%rbx,%r15), %rsi
8041602b8c: 48 8b 45 98                	movq	-104(%rbp), %rax
;   const void *unit_end = curr_addr + unit_length;
8041602b90: 48 01 f0                   	addq	%rsi, %rax
8041602b93: 48 89 45 b0                	movq	%rax, -80(%rbp)
;   Dwarf_Half version   = get_unaligned(curr_addr, Dwarf_Half);
8041602b97: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041602ba1: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
8041602ba5: ba 02 00 00 00             	movl	$2, %edx
8041602baa: ff d0                      	callq	*%rax
8041602bac: 44 0f b7 6d c0             	movzwl	-64(%rbp), %r13d
;   assert(version == 4 || version == 3 || version == 2);
8041602bb1: 41 8d 45 fe                	leal	-2(%r13), %eax
8041602bb5: 66 83 f8 03                	cmpw	$3, %ax
8041602bb9: 0f 83 2d 01 00 00          	jae	301 <line_for_address+0x1dc>
8041602bbf: 4c 01 fb                   	addq	%r15, %rbx
8041602bc2: 48 83 c3 02                	addq	$2, %rbx
8041602bc6: 48 8d 75 a0                	leaq	-96(%rbp), %rsi
;   count = dwarf_entry_len(curr_addr, &header_length);
8041602bca: 48 89 df                   	movq	%rbx, %rdi
8041602bcd: 41 ff d6                   	callq	*%r14
;   if (count == 0) {
8041602bd0: 85 c0                      	testl	%eax, %eax
8041602bd2: 0f 84 00 01 00 00          	je	256 <line_for_address+0x1c8>
;     curr_addr += count;
8041602bd8: 48 98                      	cltq
8041602bda: 48 01 c3                   	addq	%rax, %rbx
8041602bdd: 48 8b 45 a0                	movq	-96(%rbp), %rax
;   const void *program_addr = curr_addr + header_length;
8041602be1: 48 01 d8                   	addq	%rbx, %rax
8041602be4: 48 89 45 b8                	movq	%rax, -72(%rbp)
8041602be8: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
;       get_unaligned(curr_addr, Dwarf_Small);
8041602bec: ba 01 00 00 00             	movl	$1, %edx
8041602bf1: 48 89 de                   	movq	%rbx, %rsi
8041602bf4: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
8041602bfe: 41 ff d7                   	callq	*%r15
8041602c01: 8a 45 c0                   	movb	-64(%rbp), %al
;   assert(minimum_instruction_length == 1);
8041602c04: 3c 01                      	cmpb	$1, %al
8041602c06: 0f 85 11 01 00 00          	jne	273 <line_for_address+0x20d>
8041602c0c: 41 b6 01                   	movb	$1, %r14b
;   assert(version == 4 || version == 3 || version == 2);
8041602c0f: 66 41 83 fd 04             	cmpw	$4, %r13w
8041602c14: 88 45 d6                   	movb	%al, -42(%rbp)
;   if (version == 4) {
8041602c17: 75 17                      	jne	23 <line_for_address+0x120>
8041602c19: 48 83 c3 01                	addq	$1, %rbx
8041602c1d: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
;         get_unaligned(curr_addr, Dwarf_Small);
8041602c21: ba 01 00 00 00             	movl	$1, %edx
8041602c26: 48 89 de                   	movq	%rbx, %rsi
8041602c29: 41 ff d7                   	callq	*%r15
8041602c2c: 44 8a 75 c0                	movb	-64(%rbp), %r14b
;   assert(maximum_operations_per_instruction == 1);
8041602c30: 41 80 fe 01                	cmpb	$1, %r14b
8041602c34: 0f 85 14 01 00 00          	jne	276 <line_for_address+0x23e>
;   curr_addr += sizeof(Dwarf_Small);
8041602c3a: 48 8d 73 02                	leaq	2(%rbx), %rsi
8041602c3e: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
;   signed char line_base = get_unaligned(curr_addr, signed char);
8041602c42: ba 01 00 00 00             	movl	$1, %edx
8041602c47: 41 ff d7                   	callq	*%r15
8041602c4a: 8a 45 c0                   	movb	-64(%rbp), %al
8041602c4d: 88 45 d7                   	movb	%al, -41(%rbp)
;   curr_addr += sizeof(signed char);
8041602c50: 48 8d 73 03                	leaq	3(%rbx), %rsi
8041602c54: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
;   Dwarf_Small line_range = get_unaligned(curr_addr, Dwarf_Small);
8041602c58: ba 01 00 00 00             	movl	$1, %edx
8041602c5d: 41 ff d7                   	callq	*%r15
8041602c60: 44 8a 6d c0                	movb	-64(%rbp), %r13b
;   curr_addr += sizeof(Dwarf_Small);
8041602c64: 48 8d 73 04                	leaq	4(%rbx), %rsi
8041602c68: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
;   Dwarf_Small opcode_base = get_unaligned(curr_addr, Dwarf_Small);
8041602c6c: ba 01 00 00 00             	movl	$1, %edx
8041602c71: 41 ff d7                   	callq	*%r15
8041602c74: 4c 89 f8                   	movq	%r15, %rax
8041602c77: 44 8a 7d c0                	movb	-64(%rbp), %r15b
;   curr_addr += sizeof(Dwarf_Small);
8041602c7b: 48 83 c3 05                	addq	$5, %rbx
8041602c7f: 48 8d 7d c0                	leaq	-64(%rbp), %rdi
;       (Dwarf_Small *)get_unaligned(curr_addr, Dwarf_Small *);
8041602c83: ba 08 00 00 00             	movl	$8, %edx
8041602c88: 48 89 de                   	movq	%rbx, %rsi
8041602c8b: ff d0                      	callq	*%rax
8041602c8d: 48 8b 45 c0                	movq	-64(%rbp), %rax
8041602c91: 8a 4d d6                   	movb	-42(%rbp), %cl
;   struct Line_Number_Info info = {
8041602c94: 88 4d c0                   	movb	%cl, -64(%rbp)
8041602c97: 44 88 75 c1                	movb	%r14b, -63(%rbp)
8041602c9b: 8a 4d d7                   	movb	-41(%rbp), %cl
8041602c9e: 88 4d c2                   	movb	%cl, -62(%rbp)
8041602ca1: 44 88 6d c3                	movb	%r13b, -61(%rbp)
8041602ca5: 44 88 7d c4                	movb	%r15b, -60(%rbp)
8041602ca9: 48 89 45 c8                	movq	%rax, -56(%rbp)
;   run_line_number_program(program_addr, unit_end, &info, &current_state,
8041602cad: 48 b8 20 2e 60 41 80 00 00 00      	movabsq	$550852636192, %rax
8041602cb7: 48 8d 55 c0                	leaq	-64(%rbp), %rdx
8041602cbb: 48 8d 4d 80                	leaq	-128(%rbp), %rcx
8041602cbf: 48 8b 7d b8                	movq	-72(%rbp), %rdi
8041602cc3: 48 8b 75 b0                	movq	-80(%rbp), %rsi
8041602cc7: 4c 8b 45 a8                	movq	-88(%rbp), %r8
8041602ccb: ff d0                      	callq	*%rax
;   *lineno_store = current_state.line;
8041602ccd: 8b 45 88                   	movl	-120(%rbp), %eax
8041602cd0: 41 89 04 24                	movl	%eax, (%r12)
8041602cd4: 31 c0                      	xorl	%eax, %eax
8041602cd6: eb 05                      	jmp	5 <line_for_address+0x1cd>
8041602cd8: b8 fa ff ff ff             	movl	$4294967290, %eax
; }
8041602cdd: 48 83 c4 58                	addq	$88, %rsp
8041602ce1: 5b                         	popq	%rbx
8041602ce2: 41 5c                      	popq	%r12
8041602ce4: 41 5d                      	popq	%r13
8041602ce6: 41 5e                      	popq	%r14
8041602ce8: 41 5f                      	popq	%r15
8041602cea: 5d                         	popq	%rbp
8041602ceb: c3                         	retq
;   assert(version == 4 || version == 3 || version == 2);
8041602cec: 48 bf 7e 59 60 41 80 00 00 00      	movabsq	$550852647294, %rdi
8041602cf6: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041602d00: 48 b9 83 58 60 41 80 00 00 00      	movabsq	$550852647043, %rcx
8041602d0a: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602d14: be fc 00 00 00             	movl	$252, %esi
8041602d19: 31 c0                      	xorl	%eax, %eax
8041602d1b: ff d3                      	callq	*%rbx
;   assert(minimum_instruction_length == 1);
8041602d1d: 48 bf 7e 59 60 41 80 00 00 00      	movabsq	$550852647294, %rdi
8041602d27: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041602d31: 48 b9 06 55 60 41 80 00 00 00      	movabsq	$550852646150, %rcx
8041602d3b: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602d45: be 07 01 00 00             	movl	$263, %esi
8041602d4a: 31 c0                      	xorl	%eax, %eax
8041602d4c: ff d3                      	callq	*%rbx
;   assert(maximum_operations_per_instruction == 1);
8041602d4e: 48 bf 7e 59 60 41 80 00 00 00      	movabsq	$550852647294, %rdi
8041602d58: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
8041602d62: 48 b9 1a 5a 60 41 80 00 00 00      	movabsq	$550852647450, %rcx
8041602d6c: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
8041602d76: be 11 01 00 00             	movl	$273, %esi
8041602d7b: 31 c0                      	xorl	%eax, %eax
8041602d7d: ff d3                      	callq	*%rbx
8041602d7f: 90                         	nop

0000008041602d80 dwarf_entry_len:
; dwarf_entry_len(const char *addr, unsigned long *len) {
8041602d80: 55                         	pushq	%rbp
8041602d81: 48 89 e5                   	movq	%rsp, %rbp
8041602d84: 41 57                      	pushq	%r15
8041602d86: 41 56                      	pushq	%r14
8041602d88: 53                         	pushq	%rbx
8041602d89: 48 83 ec 18                	subq	$24, %rsp
8041602d8d: 49 89 f6                   	movq	%rsi, %r14
8041602d90: 48 89 fb                   	movq	%rdi, %rbx
;   initial_len = get_unaligned(addr, uint32_t);
8041602d93: 49 bf 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %r15
8041602d9d: 48 8d 7d e4                	leaq	-28(%rbp), %rdi
8041602da1: ba 04 00 00 00             	movl	$4, %edx
8041602da6: 48 89 de                   	movq	%rbx, %rsi
8041602da9: 41 ff d7                   	callq	*%r15
8041602dac: 8b 45 e4                   	movl	-28(%rbp), %eax
8041602daf: 48 89 c1                   	movq	%rax, %rcx
8041602db2: 48 c1 e9 04                	shrq	$4, %rcx
8041602db6: 81 f9 ff ff ff 0f          	cmpl	$268435455, %ecx
;   if (initial_len >= DW_EXT_LO && initial_len <= DW_EXT_HI) {
8041602dbc: 72 21                      	jb	33 <dwarf_entry_len+0x5f>
;     if (initial_len == DW_EXT_DWARF64) {
8041602dbe: 83 f8 ff                   	cmpl	$-1, %eax
8041602dc1: 74 26                      	je	38 <dwarf_entry_len+0x69>
;       cprintf("Unknown DWARF extension\n");
8041602dc3: 48 bf e0 59 60 41 80 00 00 00      	movabsq	$550852647392, %rdi
8041602dcd: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041602dd7: 31 db                      	xorl	%ebx, %ebx
8041602dd9: 31 c0                      	xorl	%eax, %eax
8041602ddb: ff d1                      	callq	*%rcx
8041602ddd: eb 29                      	jmp	41 <dwarf_entry_len+0x88>
;     *len = initial_len;
8041602ddf: 49 89 06                   	movq	%rax, (%r14)
8041602de2: bb 04 00 00 00             	movl	$4, %ebx
8041602de7: eb 1f                      	jmp	31 <dwarf_entry_len+0x88>
;       *len  = get_unaligned((uint64_t *)addr + 4, uint64_t);
8041602de9: 48 83 c3 20                	addq	$32, %rbx
8041602ded: 48 8d 7d d8                	leaq	-40(%rbp), %rdi
8041602df1: ba 08 00 00 00             	movl	$8, %edx
8041602df6: 48 89 de                   	movq	%rbx, %rsi
8041602df9: 41 ff d7                   	callq	*%r15
8041602dfc: 48 8b 45 d8                	movq	-40(%rbp), %rax
8041602e00: 49 89 06                   	movq	%rax, (%r14)
8041602e03: bb 0c 00 00 00             	movl	$12, %ebx
;   return count;
8041602e08: 89 d8                      	movl	%ebx, %eax
8041602e0a: 48 83 c4 18                	addq	$24, %rsp
8041602e0e: 5b                         	popq	%rbx
8041602e0f: 41 5e                      	popq	%r14
8041602e11: 41 5f                      	popq	%r15
8041602e13: 5d                         	popq	%rbp
8041602e14: c3                         	retq
8041602e15: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041602e1f: 90                         	nop

0000008041602e20 run_line_number_program:
;                         uintptr_t destination_addr) {
8041602e20: 55                         	pushq	%rbp
8041602e21: 48 89 e5                   	movq	%rsp, %rbp
8041602e24: 41 57                      	pushq	%r15
8041602e26: 41 56                      	pushq	%r14
8041602e28: 41 55                      	pushq	%r13
8041602e2a: 41 54                      	pushq	%r12
8041602e2c: 53                         	pushq	%rbx
8041602e2d: 48 83 ec 68                	subq	$104, %rsp
8041602e31: 4c 89 45 b0                	movq	%r8, -80(%rbp)
8041602e35: 49 89 d4                   	movq	%rdx, %r12
8041602e38: 48 89 b5 78 ff ff ff       	movq	%rsi, -136(%rbp)
8041602e3f: 48 89 fb                   	movq	%rdi, %rbx
8041602e42: 48 89 4d c8                	movq	%rcx, -56(%rbp)
8041602e46: 48 8d 41 08                	leaq	8(%rcx), %rax
8041602e4a: 48 89 45 c0                	movq	%rax, -64(%rbp)
8041602e4e: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041602e58: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
8041602e5c: 48 89 55 88                	movq	%rdx, -120(%rbp)
8041602e60: eb 45                      	jmp	69 <run_line_number_program+0x87>
;               get_unaligned(program_addr, Dwarf_Half);
8041602e62: ba 02 00 00 00             	movl	$2, %edx
8041602e67: 4c 89 ef                   	movq	%r13, %rdi
8041602e6a: 4c 89 f6                   	movq	%r14, %rsi
8041602e6d: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041602e77: ff d0                      	callq	*%rax
8041602e79: 0f b7 45 d0                	movzwl	-48(%rbp), %eax
8041602e7d: 48 8b 4d c8                	movq	-56(%rbp), %rcx
;           state->address += pc_inc;
8041602e81: 48 01 01                   	addq	%rax, (%rcx)
;           program_addr += sizeof(Dwarf_Half);
8041602e84: 48 83 c3 03                	addq	$3, %rbx
8041602e88: 49 89 de                   	movq	%rbx, %r14
8041602e8b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
8041602e90: 31 c9                      	xorl	%ecx, %ecx
8041602e92: 4c 89 f3                   	movq	%r14, %rbx
8041602e95: 85 c9                      	testl	%ecx, %ecx
8041602e97: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041602ea1: 0f 85 a8 03 00 00          	jne	936 <run_line_number_program+0x42f>
;   while (program_addr < end_addr) {
8041602ea7: 48 3b 9d 78 ff ff ff       	cmpq	-136(%rbp), %rbx
8041602eae: 0f 83 9b 03 00 00          	jae	923 <run_line_number_program+0x42f>
;     Dwarf_Small opcode = get_unaligned(program_addr, Dwarf_Small);
8041602eb4: ba 01 00 00 00             	movl	$1, %edx
8041602eb9: 4c 89 ef                   	movq	%r13, %rdi
8041602ebc: 48 89 de                   	movq	%rbx, %rsi
8041602ebf: 49 89 c7                   	movq	%rax, %r15
8041602ec2: ff d0                      	callq	*%rax
8041602ec4: 0f b6 4d d0                	movzbl	-48(%rbp), %ecx
;     program_addr += sizeof(Dwarf_Small);
8041602ec8: 4c 8d 73 01                	leaq	1(%rbx), %r14
;     Dwarf_Small opcode = get_unaligned(program_addr, Dwarf_Small);
8041602ecc: 85 c9                      	testl	%ecx, %ecx
;     if (opcode == 0) {
8041602ece: 74 50                      	je	80 <run_line_number_program+0x100>
;     } else if (opcode < info->opcode_base) {
8041602ed0: 41 8a 44 24 04             	movb	4(%r12), %al
8041602ed5: 38 c1                      	cmpb	%al, %cl
8041602ed7: 0f 83 e3 00 00 00          	jae	227 <run_line_number_program+0x1a0>
;       switch (opcode) {
8041602edd: 8d 51 ff                   	leal	-1(%rcx), %edx
8041602ee0: 80 fa 0b                   	cmpb	$11, %dl
8041602ee3: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
8041602ee7: 0f 87 96 03 00 00          	ja	918 <run_line_number_program+0x463>
8041602eed: 0f b6 ca                   	movzbl	%dl, %ecx
8041602ef0: 48 ba a0 62 60 41 80 00 00 00      	movabsq	$550852649632, %rdx
8041602efa: ff 24 ca                   	jmpq	*(%rdx,%rcx,8)
8041602efd: 4c 89 f7                   	movq	%r14, %rdi
8041602f00: 4c 89 ee                   	movq	%r13, %rsi
8041602f03: 48 b8 e0 32 60 41 80 00 00 00      	movabsq	$550852637408, %rax
8041602f0d: ff d0                      	callq	*%rax
8041602f0f: 49 01 c6                   	addq	%rax, %r14
8041602f12: e9 79 ff ff ff             	jmp	-135 <run_line_number_program+0x70>
8041602f17: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
;           dwarf_read_uleb128(program_addr, &length);
8041602f20: 4c 89 f7                   	movq	%r14, %rdi
8041602f23: 48 8d 75 ac                	leaq	-84(%rbp), %rsi
8041602f27: 48 b8 e0 32 60 41 80 00 00 00      	movabsq	$550852637408, %rax
8041602f31: ff d0                      	callq	*%rax
8041602f33: 48 89 c3                   	movq	%rax, %rbx
;       program_addr += count;
8041602f36: 4d 8d 24 06                	leaq	(%r14,%rax), %r12
;       const void *opcode_end = program_addr + length;
8041602f3a: 8b 45 ac                   	movl	-84(%rbp), %eax
8041602f3d: 48 89 45 80                	movq	%rax, -128(%rbp)
;       opcode                 = get_unaligned(program_addr, Dwarf_Small);
8041602f41: ba 01 00 00 00             	movl	$1, %edx
8041602f46: 4c 89 ef                   	movq	%r13, %rdi
8041602f49: 4c 89 e6                   	movq	%r12, %rsi
8041602f4c: 41 ff d7                   	callq	*%r15
8041602f4f: 0f b6 4d d0                	movzbl	-48(%rbp), %ecx
;       switch (opcode) {
8041602f53: 8d 41 ff                   	leal	-1(%rcx), %eax
8041602f56: 3c 03                      	cmpb	$3, %al
8041602f58: 0f 87 00 03 00 00          	ja	768 <run_line_number_program+0x43e>
8041602f5e: 49 01 de                   	addq	%rbx, %r14
8041602f61: 49 83 c6 01                	addq	$1, %r14
8041602f65: 0f b6 c0                   	movzbl	%al, %eax
8041602f68: 48 b9 00 63 60 41 80 00 00 00      	movabsq	$550852649728, %rcx
8041602f72: ff 24 c1                   	jmpq	*(%rcx,%rax,8)
8041602f75: 48 8b 45 c8                	movq	-56(%rbp), %rax
;           state->end_sequence = true;
8041602f79: c6 40 10 01                	movb	$1, 16(%rax)
8041602f7d: 48 8b 4d b8                	movq	-72(%rbp), %rcx
8041602f81: 48 8b 55 b0                	movq	-80(%rbp), %rdx
;           if (last_state.address <= destination_addr &&
8041602f85: 48 39 d1                   	cmpq	%rdx, %rcx
8041602f88: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
8041602f8c: 0f 87 6d 01 00 00          	ja	365 <run_line_number_program+0x2df>
;               destination_addr < state->address) {
8041602f92: 48 39 10                   	cmpq	%rdx, (%rax)
;           if (last_state.address <= destination_addr &&
8041602f95: 0f 86 64 01 00 00          	jbe	356 <run_line_number_program+0x2df>
;             *state = last_state;
8041602f9b: 48 89 08                   	movq	%rcx, (%rax)
8041602f9e: 0f 28 45 90                	movaps	-112(%rbp), %xmm0
8041602fa2: 48 8b 4d c0                	movq	-64(%rbp), %rcx
8041602fa6: 0f 11 01                   	movups	%xmm0, (%rcx)
8041602fa9: b9 01 00 00 00             	movl	$1, %ecx
8041602fae: e9 8c 01 00 00             	jmp	396 <run_line_number_program+0x31f>
8041602fb3: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041602fbd: 0f 1f 00                   	nopl	(%rax)
;           opcode - info->opcode_base;
8041602fc0: 28 c1                      	subb	%al, %cl
;       int op_advance = adjusted_opcode / info->line_range;
8041602fc2: 0f b6 c1                   	movzbl	%cl, %eax
8041602fc5: 41 0f b6 4c 24 03          	movzbl	3(%r12), %ecx
;       state->line += (info->line_base +
8041602fcb: 41 0f be 74 24 02          	movsbl	2(%r12), %esi
;                       (adjusted_opcode % info->line_range));
8041602fd1: 31 d2                      	xorl	%edx, %edx
8041602fd3: f7 f1                      	divl	%ecx
;       state->line += (info->line_base +
8041602fd5: 01 f2                      	addl	%esi, %edx
8041602fd7: 48 8b 7d c8                	movq	-56(%rbp), %rdi
8041602fdb: 01 57 08                   	addl	%edx, 8(%rdi)
;           info->minimum_instruction_length *
8041602fde: 41 0f b6 0c 24             	movzbl	(%r12), %ecx
;            info->maximum_operations_per_instruction);
8041602fe3: 41 0f b6 74 24 01          	movzbl	1(%r12), %esi
;           (op_advance /
8041602fe9: 31 d2                      	xorl	%edx, %edx
8041602feb: f7 f6                      	divl	%esi
;           info->minimum_instruction_length *
8041602fed: 48 0f af c1                	imulq	%rcx, %rax
;       state->address +=
8041602ff1: 48 03 07                   	addq	(%rdi), %rax
8041602ff4: 48 89 07                   	movq	%rax, (%rdi)
;       state->discriminator = 0;
8041602ff7: c7 47 14 00 00 00 00       	movl	$0, 20(%rdi)
8041602ffe: 48 8b 4d b8                	movq	-72(%rbp), %rcx
8041603002: 48 8b 55 b0                	movq	-80(%rbp), %rdx
;       if (last_state.address <= destination_addr &&
8041603006: 48 39 d1                   	cmpq	%rdx, %rcx
8041603009: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
804160300d: 77 29                      	ja	41 <run_line_number_program+0x218>
804160300f: 48 39 d0                   	cmpq	%rdx, %rax
8041603012: 76 24                      	jbe	36 <run_line_number_program+0x218>
8041603014: 48 8b 45 c8                	movq	-56(%rbp), %rax
;         *state = last_state;
8041603018: 48 89 08                   	movq	%rcx, (%rax)
804160301b: 0f 28 45 90                	movaps	-112(%rbp), %xmm0
804160301f: 48 8b 45 c0                	movq	-64(%rbp), %rax
8041603023: 0f 11 00                   	movups	%xmm0, (%rax)
8041603026: b9 01 00 00 00             	movl	$1, %ecx
804160302b: 85 c9                      	testl	%ecx, %ecx
804160302d: 0f 85 5f fe ff ff          	jne	-417 <run_line_number_program+0x72>
8041603033: e9 58 fe ff ff             	jmp	-424 <run_line_number_program+0x70>
8041603038: 48 8b 4d c0                	movq	-64(%rbp), %rcx
;       last_state = *state;
804160303c: 0f 10 01                   	movups	(%rcx), %xmm0
804160303f: 0f 29 45 90                	movaps	%xmm0, -112(%rbp)
8041603043: 31 c9                      	xorl	%ecx, %ecx
8041603045: 48 89 45 b8                	movq	%rax, -72(%rbp)
8041603049: 85 c9                      	testl	%ecx, %ecx
804160304b: 0f 85 41 fe ff ff          	jne	-447 <run_line_number_program+0x72>
8041603051: e9 3a fe ff ff             	jmp	-454 <run_line_number_program+0x70>
8041603056: 48 8d 75 d0                	leaq	-48(%rbp), %rsi
804160305a: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
;           while (*(char *)program_addr) {
8041603060: 41 80 3e 00                	cmpb	$0, (%r14)
8041603064: 4d 8d 76 01                	leaq	1(%r14), %r14
8041603068: 75 f6                      	jne	-10 <run_line_number_program+0x240>
;           unsigned long count = dwarf_read_uleb128(
804160306a: 4c 89 f7                   	movq	%r14, %rdi
804160306d: 49 bd e0 32 60 41 80 00 00 00      	movabsq	$550852637408, %r13
8041603077: 41 ff d5                   	callq	*%r13
804160307a: 48 89 c3                   	movq	%rax, %rbx
;           unsigned last_mod;
804160307d: 49 8d 3c 06                	leaq	(%r14,%rax), %rdi
;               dwarf_read_uleb128(program_addr, &last_mod);
8041603081: 48 8d b5 70 ff ff ff       	leaq	-144(%rbp), %rsi
8041603088: 41 ff d5                   	callq	*%r13
804160308b: 49 89 c7                   	movq	%rax, %r15
;           unsigned length;
804160308e: 49 01 df                   	addq	%rbx, %r15
8041603091: 4b 8d 3c 3e                	leaq	(%r14,%r15), %rdi
;               dwarf_read_uleb128(program_addr, &length);
8041603095: 48 8d b5 74 ff ff ff       	leaq	-140(%rbp), %rsi
804160309c: 41 ff d5                   	callq	*%r13
;         } break;
804160309f: 4c 01 f8                   	addq	%r15, %rax
80416030a2: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
80416030a6: 49 01 c6                   	addq	%rax, %r14
80416030a9: e9 82 00 00 00             	jmp	130 <run_line_number_program+0x310>
;           unsigned long count = dwarf_read_uleb128(
80416030ae: 4c 89 f7                   	movq	%r14, %rdi
80416030b1: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
80416030b5: 4c 89 ee                   	movq	%r13, %rsi
80416030b8: 48 b8 e0 32 60 41 80 00 00 00      	movabsq	$550852637408, %rax
80416030c2: ff d0                      	callq	*%rax
;           state->discriminator = discriminator;
80416030c4: 8b 4d d0                   	movl	-48(%rbp), %ecx
80416030c7: 48 8b 55 c8                	movq	-56(%rbp), %rdx
80416030cb: 89 4a 14                   	movl	%ecx, 20(%rdx)
;           program_addr += count;
80416030ce: 49 01 c6                   	addq	%rax, %r14
80416030d1: eb 5d                      	jmp	93 <run_line_number_program+0x310>
;               get_unaligned(program_addr, uintptr_t);
80416030d3: ba 08 00 00 00             	movl	$8, %edx
80416030d8: 4c 8d 6d d0                	leaq	-48(%rbp), %r13
80416030dc: 4c 89 ef                   	movq	%r13, %rdi
80416030df: 4c 89 f6                   	movq	%r14, %rsi
80416030e2: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416030ec: ff d0                      	callq	*%rax
80416030ee: 48 8b 45 d0                	movq	-48(%rbp), %rax
80416030f2: 48 8b 4d c8                	movq	-56(%rbp), %rcx
;           state->address = addr;
80416030f6: 48 89 01                   	movq	%rax, (%rcx)
;           program_addr += sizeof(uintptr_t);
80416030f9: 49 83 c6 08                	addq	$8, %r14
80416030fd: eb 31                      	jmp	49 <run_line_number_program+0x310>
;           last_state           = *state;
80416030ff: 48 8b 08                   	movq	(%rax), %rcx
8041603102: 48 89 4d b8                	movq	%rcx, -72(%rbp)
8041603106: 48 8b 4d c0                	movq	-64(%rbp), %rcx
804160310a: 0f 10 01                   	movups	(%rcx), %xmm0
804160310d: 0f 29 45 90                	movaps	%xmm0, -112(%rbp)
;           state->address       = 0;
8041603111: 48 c7 00 00 00 00 00       	movq	$0, (%rax)
;           state->line          = 1;
8041603118: 48 c7 40 08 01 00 00 00    	movq	$1, 8(%rax)
;           state->end_sequence  = false;
8041603120: c6 40 10 00                	movb	$0, 16(%rax)
;           state->discriminator = 0;
8041603124: c7 40 14 00 00 00 00       	movl	$0, 20(%rax)
804160312b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
8041603130: 4c 03 65 80                	addq	-128(%rbp), %r12
8041603134: 31 c9                      	xorl	%ecx, %ecx
;       assert(program_addr == opcode_end);
8041603136: 4d 39 e6                   	cmpq	%r12, %r14
8041603139: 0f 85 6b 01 00 00          	jne	363 <run_line_number_program+0x48a>
804160313f: 85 c9                      	testl	%ecx, %ecx
8041603141: 4c 8b 65 88                	movq	-120(%rbp), %r12
8041603145: 0f 85 47 fd ff ff          	jne	-697 <run_line_number_program+0x72>
804160314b: e9 40 fd ff ff             	jmp	-704 <run_line_number_program+0x70>
;               dwarf_read_leb128(program_addr, &line_incr);
8041603150: 4c 89 f7                   	movq	%r14, %rdi
8041603153: 4c 89 ee                   	movq	%r13, %rsi
8041603156: 48 b8 20 33 60 41 80 00 00 00      	movabsq	$550852637472, %rax
8041603160: ff d0                      	callq	*%rax
;           state->line += line_incr;
8041603162: 8b 4d d0                   	movl	-48(%rbp), %ecx
8041603165: 48 8b 55 c8                	movq	-56(%rbp), %rdx
8041603169: 01 4a 08                   	addl	%ecx, 8(%rdx)
;           program_addr += count;
804160316c: 49 01 c6                   	addq	%rax, %r14
804160316f: e9 1c fd ff ff             	jmp	-740 <run_line_number_program+0x70>
;           unsigned long count = dwarf_read_uleb128(
8041603174: 4c 89 f7                   	movq	%r14, %rdi
8041603177: 4c 89 ee                   	movq	%r13, %rsi
804160317a: 48 b8 e0 32 60 41 80 00 00 00      	movabsq	$550852637408, %rax
8041603184: ff d0                      	callq	*%rax
8041603186: 48 89 c1                   	movq	%rax, %rcx
;               info->minimum_instruction_length *
8041603189: 41 0f b6 34 24             	movzbl	(%r12), %esi
;               (op_advance /
804160318e: 8b 45 d0                   	movl	-48(%rbp), %eax
;                info->maximum_operations_per_instruction);
8041603191: 41 0f b6 7c 24 01          	movzbl	1(%r12), %edi
;               (op_advance /
8041603197: 31 d2                      	xorl	%edx, %edx
8041603199: f7 f7                      	divl	%edi
;               info->minimum_instruction_length *
804160319b: 0f af c6                   	imull	%esi, %eax
804160319e: 48 8b 55 c8                	movq	-56(%rbp), %rdx
;           state->address +=
80416031a2: 48 01 02                   	addq	%rax, (%rdx)
;           program_addr += count;
80416031a5: 49 01 ce                   	addq	%rcx, %r14
80416031a8: e9 e3 fc ff ff             	jmp	-797 <run_line_number_program+0x70>
;               dwarf_read_uleb128(program_addr, &column);
80416031ad: 4c 89 f7                   	movq	%r14, %rdi
80416031b0: 4c 89 ee                   	movq	%r13, %rsi
80416031b3: 48 b8 e0 32 60 41 80 00 00 00      	movabsq	$550852637408, %rax
80416031bd: ff d0                      	callq	*%rax
;           state->column = column;
80416031bf: 8b 4d d0                   	movl	-48(%rbp), %ecx
80416031c2: 48 8b 55 c8                	movq	-56(%rbp), %rdx
80416031c6: 89 4a 0c                   	movl	%ecx, 12(%rdx)
;           program_addr += count;
80416031c9: 49 01 c6                   	addq	%rax, %r14
80416031cc: e9 bf fc ff ff             	jmp	-833 <run_line_number_program+0x70>
80416031d1: 48 8b 45 b8                	movq	-72(%rbp), %rax
80416031d5: 48 8b 4d b0                	movq	-80(%rbp), %rcx
;           if (last_state.address <= destination_addr &&
80416031d9: 48 39 c8                   	cmpq	%rcx, %rax
80416031dc: 77 4f                      	ja	79 <run_line_number_program+0x40d>
80416031de: 48 8b 55 c8                	movq	-56(%rbp), %rdx
;               destination_addr < state->address) {
80416031e2: 48 39 0a                   	cmpq	%rcx, (%rdx)
;           if (last_state.address <= destination_addr &&
80416031e5: 76 46                      	jbe	70 <run_line_number_program+0x40d>
80416031e7: 48 8b 4d c8                	movq	-56(%rbp), %rcx
;             *state = last_state;
80416031eb: 48 89 01                   	movq	%rax, (%rcx)
80416031ee: 0f 28 45 90                	movaps	-112(%rbp), %xmm0
80416031f2: 48 8b 45 c0                	movq	-64(%rbp), %rax
80416031f6: 0f 11 00                   	movups	%xmm0, (%rax)
80416031f9: b9 01 00 00 00             	movl	$1, %ecx
80416031fe: e9 8f fc ff ff             	jmp	-881 <run_line_number_program+0x72>
;               opcode - info->opcode_base;
8041603203: f6 d0                      	notb	%al
;               adjusted_opcode / info->line_range;
8041603205: 0f b6 c0                   	movzbl	%al, %eax
8041603208: 41 f6 74 24 03             	divb	3(%r12)
;               info->minimum_instruction_length *
804160320d: 41 0f b6 0c 24             	movzbl	(%r12), %ecx
;               (op_advance /
8041603212: 0f b6 c0                   	movzbl	%al, %eax
8041603215: 41 f6 74 24 01             	divb	1(%r12)
804160321a: 0f b6 c0                   	movzbl	%al, %eax
;               info->minimum_instruction_length *
804160321d: 48 0f af c1                	imulq	%rcx, %rax
8041603221: 48 8b 4d c8                	movq	-56(%rbp), %rcx
;           state->address +=
8041603225: 48 01 01                   	addq	%rax, (%rcx)
8041603228: e9 63 fc ff ff             	jmp	-925 <run_line_number_program+0x70>
804160322d: 48 8b 4d c8                	movq	-56(%rbp), %rcx
;           last_state           = *state;
8041603231: 48 8b 01                   	movq	(%rcx), %rax
8041603234: 48 89 45 b8                	movq	%rax, -72(%rbp)
8041603238: 48 8b 45 c0                	movq	-64(%rbp), %rax
804160323c: 0f 10 00                   	movups	(%rax), %xmm0
804160323f: 0f 29 45 90                	movaps	%xmm0, -112(%rbp)
;           state->discriminator = 0;
8041603243: c7 41 14 00 00 00 00       	movl	$0, 20(%rcx)
804160324a: e9 41 fc ff ff             	jmp	-959 <run_line_number_program+0x70>
; }
804160324f: 48 83 c4 68                	addq	$104, %rsp
8041603253: 5b                         	popq	%rbx
8041603254: 41 5c                      	popq	%r12
8041603256: 41 5d                      	popq	%r13
8041603258: 41 5e                      	popq	%r14
804160325a: 41 5f                      	popq	%r15
804160325c: 5d                         	popq	%rbp
804160325d: c3                         	retq
;           panic("Unknown opcode: %x", opcode);
804160325e: 48 bf 7e 59 60 41 80 00 00 00      	movabsq	$550852647294, %rdi
8041603268: 48 ba 3b 56 60 41 80 00 00 00      	movabsq	$550852646459, %rdx
8041603272: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
804160327c: be 6b 00 00 00             	movl	$107, %esi
8041603281: eb 23                      	jmp	35 <run_line_number_program+0x486>
;           panic("Unknown opcode: %x", opcode);
8041603283: 48 bf 7e 59 60 41 80 00 00 00      	movabsq	$550852647294, %rdi
804160328d: 48 ba 3b 56 60 41 80 00 00 00      	movabsq	$550852646459, %rdx
8041603297: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416032a1: be c1 00 00 00             	movl	$193, %esi
80416032a6: 31 c0                      	xorl	%eax, %eax
80416032a8: ff d3                      	callq	*%rbx
;       assert(program_addr == opcode_end);
80416032aa: 48 bf 7e 59 60 41 80 00 00 00      	movabsq	$550852647294, %rdi
80416032b4: 48 ba a2 56 60 41 80 00 00 00      	movabsq	$550852646562, %rdx
80416032be: 48 b9 b7 5a 60 41 80 00 00 00      	movabsq	$550852647607, %rcx
80416032c8: 48 bb 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rbx
80416032d2: be 6e 00 00 00             	movl	$110, %esi
80416032d7: 31 c0                      	xorl	%eax, %eax
80416032d9: ff d3                      	callq	*%rbx
80416032db: 0f 1f 44 00 00             	nopl	(%rax,%rax)

00000080416032e0 dwarf_read_uleb128:
; dwarf_read_uleb128(const char *addr, unsigned int *ret) {
80416032e0: 55                         	pushq	%rbp
80416032e1: 48 89 e5                   	movq	%rsp, %rbp
80416032e4: 31 c0                      	xorl	%eax, %eax
80416032e6: 45 31 c9                   	xorl	%r9d, %r9d
80416032e9: 31 c9                      	xorl	%ecx, %ecx
80416032eb: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     byte = *addr;
80416032f0: 44 0f b6 04 07             	movzbl	(%rdi,%rax), %r8d
;     result |= (byte & 0x7f) << shift;
80416032f5: 44 89 c2                   	movl	%r8d, %edx
80416032f8: 83 e2 7f                   	andl	$127, %edx
80416032fb: d3 e2                      	shll	%cl, %edx
80416032fd: 41 09 d1                   	orl	%edx, %r9d
;     shift += 7;
8041603300: 83 c1 07                   	addl	$7, %ecx
;     if (!(byte & 0x80))
8041603303: 48 83 c0 01                	addq	$1, %rax
8041603307: 45 84 c0                   	testb	%r8b, %r8b
804160330a: 78 e4                      	js	-28 <dwarf_read_uleb128+0x10>
;   *ret = result;
804160330c: 44 89 0e                   	movl	%r9d, (%rsi)
;   return count;
804160330f: 5d                         	popq	%rbp
8041603310: c3                         	retq
8041603311: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160331b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041603320 dwarf_read_leb128:
; dwarf_read_leb128(const char *addr, int *ret) {
8041603320: 55                         	pushq	%rbp
8041603321: 48 89 e5                   	movq	%rsp, %rbp
8041603324: 31 c0                      	xorl	%eax, %eax
8041603326: b9 f9 ff ff ff             	movl	$4294967289, %ecx
804160332b: 45 31 c0                   	xorl	%r8d, %r8d
804160332e: 66 90                      	nop
;     byte = *addr;
8041603330: 83 c1 07                   	addl	$7, %ecx
8041603333: 44 0f b6 0c 07             	movzbl	(%rdi,%rax), %r9d
;     result |= (byte & 0x7f) << shift;
8041603338: 44 89 ca                   	movl	%r9d, %edx
804160333b: 83 e2 7f                   	andl	$127, %edx
804160333e: d3 e2                      	shll	%cl, %edx
8041603340: 41 09 d0                   	orl	%edx, %r8d
;     if (!(byte & 0x80))
8041603343: 48 83 c0 01                	addq	$1, %rax
8041603347: 45 84 c9                   	testb	%r9b, %r9b
804160334a: 78 e4                      	js	-28 <dwarf_read_leb128+0x10>
804160334c: ba 80 ff ff ff             	movl	$4294967168, %edx
;   if ((shift < num_bits) && (byte & 0x40))
8041603351: d3 e2                      	shll	%cl, %edx
8041603353: 31 ff                      	xorl	%edi, %edi
8041603355: 41 f6 c1 40                	testb	$64, %r9b
8041603359: 0f 44 d7                   	cmovel	%edi, %edx
804160335c: 83 f9 18                   	cmpl	$24, %ecx
804160335f: 0f 47 d7                   	cmoval	%edi, %edx
8041603362: 44 09 c2                   	orl	%r8d, %edx
;   *ret = result;
8041603365: 89 16                      	movl	%edx, (%rsi)
;   return count;
8041603367: 5d                         	popq	%rbp
8041603368: c3                         	retq
8041603369: cc                         	int3
804160336a: cc                         	int3
804160336b: cc                         	int3
804160336c: cc                         	int3
804160336d: cc                         	int3
804160336e: cc                         	int3
804160336f: cc                         	int3

0000008041603370 mon_help:
; mon_help(int argc, char **argv, struct Trapframe *tf) {
8041603370: 55                         	pushq	%rbp
8041603371: 48 89 e5                   	movq	%rsp, %rbp
8041603374: 41 57                      	pushq	%r15
8041603376: 41 56                      	pushq	%r14
8041603378: 41 54                      	pushq	%r12
804160337a: 53                         	pushq	%rbx
804160337b: bb 08 00 00 00             	movl	$8, %ebx
8041603380: 49 bf 40 63 60 41 80 00 00 00      	movabsq	$550852649792, %r15
804160338a: 49 be 51 59 60 41 80 00 00 00      	movabsq	$550852647249, %r14
8041603394: 49 bc 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %r12
804160339e: 66 90                      	nop
;     cprintf("%s - %s\n", commands[i].name, commands[i].desc);
80416033a0: 4a 8b 74 3b f8             	movq	-8(%rbx,%r15), %rsi
80416033a5: 4a 8b 14 3b                	movq	(%rbx,%r15), %rdx
80416033a9: 4c 89 f7                   	movq	%r14, %rdi
80416033ac: 31 c0                      	xorl	%eax, %eax
80416033ae: 41 ff d4                   	callq	*%r12
;   for (i = 0; i < NCOMMANDS; i++)
80416033b1: 48 83 c3 18                	addq	$24, %rbx
80416033b5: 48 81 fb 80 00 00 00       	cmpq	$128, %rbx
80416033bc: 75 e2                      	jne	-30 <mon_help+0x30>
;   return 0;
80416033be: 31 c0                      	xorl	%eax, %eax
80416033c0: 5b                         	popq	%rbx
80416033c1: 41 5c                      	popq	%r12
80416033c3: 41 5e                      	popq	%r14
80416033c5: 41 5f                      	popq	%r15
80416033c7: 5d                         	popq	%rbp
80416033c8: c3                         	retq
80416033c9: 0f 1f 80 00 00 00 00       	nopl	(%rax)

00000080416033d0 mon_hello:
; mon_hello(int argc, char **argv, struct Trapframe *tf) {
80416033d0: 55                         	pushq	%rbp
80416033d1: 48 89 e5                   	movq	%rsp, %rbp
;   cprintf("Hello!\n");
80416033d4: 48 bf b7 56 60 41 80 00 00 00      	movabsq	$550852646583, %rdi
80416033de: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
80416033e8: 31 c0                      	xorl	%eax, %eax
80416033ea: ff d1                      	callq	*%rcx
;   return 0;
80416033ec: 31 c0                      	xorl	%eax, %eax
80416033ee: 5d                         	popq	%rbp
80416033ef: c3                         	retq

00000080416033f0 mon_user_name:
; mon_user_name(int argc, char **argv, struct Trapframe *tf) {
80416033f0: 55                         	pushq	%rbp
80416033f1: 48 89 e5                   	movq	%rsp, %rbp
;   cprintf("User name: Andrew\n");
80416033f4: 48 bf 4e 56 60 41 80 00 00 00      	movabsq	$550852646478, %rdi
80416033fe: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603408: 31 c0                      	xorl	%eax, %eax
804160340a: ff d1                      	callq	*%rcx
;   return 0;
804160340c: 31 c0                      	xorl	%eax, %eax
804160340e: 5d                         	popq	%rbp
804160340f: c3                         	retq

0000008041603410 mon_kerninfo:
; mon_kerninfo(int argc, char **argv, struct Trapframe *tf) {
8041603410: 55                         	pushq	%rbp
8041603411: 48 89 e5                   	movq	%rsp, %rbp
8041603414: 41 57                      	pushq	%r15
8041603416: 41 56                      	pushq	%r14
8041603418: 41 54                      	pushq	%r12
804160341a: 53                         	pushq	%rbx
;   cprintf("Special kernel symbols:\n");
804160341b: 48 bf f1 56 60 41 80 00 00 00      	movabsq	$550852646641, %rdi
8041603425: 49 bc 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %r12
804160342f: 31 c0                      	xorl	%eax, %eax
8041603431: 41 ff d4                   	callq	*%r12
;   cprintf("  _head64                  %08lx (phys)\n",
8041603434: 48 bf 15 58 60 41 80 00 00 00      	movabsq	$550852646933, %rdi
804160343e: 48 be 00 00 50 01 00 00 00 00      	movabsq	$22020096, %rsi
8041603448: 31 c0                      	xorl	%eax, %eax
804160344a: 41 ff d4                   	callq	*%r12
;   cprintf("  entry  %08lx (virt)  %08lx (phys)\n",
804160344d: 48 bf db 58 60 41 80 00 00 00      	movabsq	$550852647131, %rdi
8041603457: 49 bf 00 00 00 c0 7f ff ff ff      	movabsq	$-550829555712, %r15
8041603461: 49 be 00 00 60 41 80 00 00 00      	movabsq	$550852624384, %r14
804160346b: 4b 8d 14 3e                	leaq	(%r14,%r15), %rdx
804160346f: 4c 89 f6                   	movq	%r14, %rsi
8041603472: 31 c0                      	xorl	%eax, %eax
8041603474: 41 ff d4                   	callq	*%r12
;   cprintf("  etext  %08lx (virt)  %08lx (phys)\n",
8041603477: 48 bf 00 59 60 41 80 00 00 00      	movabsq	$550852647168, %rdi
8041603481: 48 be a0 54 60 41 80 00 00 00      	movabsq	$550852646048, %rsi
804160348b: 4a 8d 14 3e                	leaq	(%rsi,%r15), %rdx
804160348f: 31 c0                      	xorl	%eax, %eax
8041603491: 41 ff d4                   	callq	*%r12
;   cprintf("  edata  %08lx (virt)  %08lx (phys)\n",
8041603494: 48 bf 26 55 60 41 80 00 00 00      	movabsq	$550852646182, %rdi
804160349e: 48 be 90 13 62 41 80 00 00 00      	movabsq	$550852760464, %rsi
80416034a8: 4a 8d 14 3e                	leaq	(%rsi,%r15), %rdx
80416034ac: 31 c0                      	xorl	%eax, %eax
80416034ae: 41 ff d4                   	callq	*%r12
;   cprintf("  end    %08lx (virt)  %08lx (phys)\n",
80416034b1: 48 bf a6 57 60 41 80 00 00 00      	movabsq	$550852646822, %rdi
80416034bb: 48 bb 00 40 62 41 80 00 00 00      	movabsq	$550852771840, %rbx
80416034c5: 49 01 df                   	addq	%rbx, %r15
80416034c8: 48 89 de                   	movq	%rbx, %rsi
80416034cb: 4c 89 fa                   	movq	%r15, %rdx
80416034ce: 31 c0                      	xorl	%eax, %eax
80416034d0: 41 ff d4                   	callq	*%r12
;   cprintf("Kernel executable memory footprint: %luKB\n",
80416034d3: 4c 29 f3                   	subq	%r14, %rbx
80416034d6: 48 81 c3 ff 03 00 00       	addq	$1023, %rbx
80416034dd: 48 c1 eb 0a                	shrq	$10, %rbx
80416034e1: 48 bf 0a 57 60 41 80 00 00 00      	movabsq	$550852646666, %rdi
80416034eb: 48 89 de                   	movq	%rbx, %rsi
80416034ee: 31 c0                      	xorl	%eax, %eax
80416034f0: 41 ff d4                   	callq	*%r12
;   return 0;
80416034f3: 31 c0                      	xorl	%eax, %eax
80416034f5: 5b                         	popq	%rbx
80416034f6: 41 5c                      	popq	%r12
80416034f8: 41 5e                      	popq	%r14
80416034fa: 41 5f                      	popq	%r15
80416034fc: 5d                         	popq	%rbp
80416034fd: c3                         	retq
80416034fe: 66 90                      	nop

0000008041603500 mon_backtrace:
; mon_backtrace(int argc, char **argv, struct Trapframe *tf) {
8041603500: 55                         	pushq	%rbp
8041603501: 48 89 e5                   	movq	%rsp, %rbp
8041603504: 41 57                      	pushq	%r15
8041603506: 41 56                      	pushq	%r14
8041603508: 41 55                      	pushq	%r13
804160350a: 41 54                      	pushq	%r12
804160350c: 53                         	pushq	%rbx
804160350d: 48 81 ec 18 02 00 00       	subq	$536, %rsp
;   cprintf("Stack backtrace:\n");
8041603514: 48 bf a0 54 60 41 80 00 00 00      	movabsq	$550852646048, %rdi
804160351e: 49 bc 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %r12
8041603528: 31 c0                      	xorl	%eax, %eax
804160352a: 41 ff d4                   	callq	*%r12
;   __asm __volatile("movq %%rbp,%0"
804160352d: 48 89 eb                   	movq	%rbp, %rbx
8041603530: 4c 8d bd c0 fd ff ff       	leaq	-576(%rbp), %r15
8041603537: 49 bd f9 59 60 41 80 00 00 00      	movabsq	$550852647417, %r13
8041603541: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160354b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     rip = rbp[1]; 
8041603550: 4c 8b 73 08                	movq	8(%rbx), %r14
;     debuginfo_rip(rip, &info);
8041603554: 4c 89 f7                   	movq	%r14, %rdi
8041603557: 4c 89 fe                   	movq	%r15, %rsi
804160355a: 48 b8 e0 42 60 41 80 00 00 00      	movabsq	$550852641504, %rax
8041603564: ff d0                      	callq	*%rax
;     cprintf("  rbp %016lx  rip %016lx\n", (long unsigned int)rbp, (long unsigned int)rip);
8041603566: 48 bf 61 56 60 41 80 00 00 00      	movabsq	$550852646497, %rdi
8041603570: 48 89 de                   	movq	%rbx, %rsi
8041603573: 4c 89 f2                   	movq	%r14, %rdx
8041603576: 31 c0                      	xorl	%eax, %eax
8041603578: 41 ff d4                   	callq	*%r12
;     cprintf("            %.256s:%d: %.*s+%ld\n", info.rip_file, info.rip_line, info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
804160357b: 8b 95 c0 fe ff ff          	movl	-320(%rbp), %edx
8041603581: 8b 4d c4                   	movl	-60(%rbp), %ecx
8041603584: 4c 2b 75 c8                	subq	-56(%rbp), %r14
8041603588: 4c 89 ef                   	movq	%r13, %rdi
804160358b: 4c 89 fe                   	movq	%r15, %rsi
804160358e: 4c 8d 85 c4 fe ff ff       	leaq	-316(%rbp), %r8
8041603595: 4d 89 f1                   	movq	%r14, %r9
8041603598: 31 c0                      	xorl	%eax, %eax
804160359a: 41 ff d4                   	callq	*%r12
;     rbp = (uint64_t *)rbp[0];
804160359d: 48 8b 1b                   	movq	(%rbx), %rbx
;   } while (rbp);
80416035a0: 48 85 db                   	testq	%rbx, %rbx
80416035a3: 75 ab                      	jne	-85 <mon_backtrace+0x50>
;   return 0;
80416035a5: 31 c0                      	xorl	%eax, %eax
80416035a7: 48 81 c4 18 02 00 00       	addq	$536, %rsp
80416035ae: 5b                         	popq	%rbx
80416035af: 41 5c                      	popq	%r12
80416035b1: 41 5d                      	popq	%r13
80416035b3: 41 5e                      	popq	%r14
80416035b5: 41 5f                      	popq	%r15
80416035b7: 5d                         	popq	%rbp
80416035b8: c3                         	retq
80416035b9: 0f 1f 80 00 00 00 00       	nopl	(%rax)

00000080416035c0 monitor:
; monitor(struct Trapframe *tf) {
80416035c0: 55                         	pushq	%rbp
80416035c1: 48 89 e5                   	movq	%rsp, %rbp
80416035c4: 41 57                      	pushq	%r15
80416035c6: 41 56                      	pushq	%r14
80416035c8: 41 54                      	pushq	%r12
80416035ca: 53                         	pushq	%rbx
80416035cb: 49 89 fe                   	movq	%rdi, %r14
;   cprintf("Welcome to the JOS kernel monitor!\n");
80416035ce: 48 bf 86 5a 60 41 80 00 00 00      	movabsq	$550852647558, %rdi
80416035d8: 48 bb 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rbx
80416035e2: 31 c0                      	xorl	%eax, %eax
80416035e4: ff d3                      	callq	*%rbx
;   cprintf("Type 'help' for a list of commands.\n");
80416035e6: 48 bf cd 55 60 41 80 00 00 00      	movabsq	$550852646349, %rdi
80416035f0: 31 c0                      	xorl	%eax, %eax
80416035f2: ff d3                      	callq	*%rbx
80416035f4: 49 bf 35 57 60 41 80 00 00 00      	movabsq	$550852646709, %r15
80416035fe: 48 bb f0 4d 60 41 80 00 00 00      	movabsq	$550852644336, %rbx
8041603608: 49 bc 40 36 60 41 80 00 00 00      	movabsq	$550852638272, %r12
8041603612: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160361c: 0f 1f 40 00                	nopl	(%rax)
;     buf = readline("K> ");
8041603620: 4c 89 ff                   	movq	%r15, %rdi
8041603623: ff d3                      	callq	*%rbx
;     if (buf != NULL)
8041603625: 48 85 c0                   	testq	%rax, %rax
8041603628: 74 f6                      	je	-10 <monitor+0x60>
;       if (runcmd(buf, tf) < 0)
804160362a: 48 89 c7                   	movq	%rax, %rdi
804160362d: 4c 89 f6                   	movq	%r14, %rsi
8041603630: 41 ff d4                   	callq	*%r12
8041603633: 85 c0                      	testl	%eax, %eax
8041603635: 79 e9                      	jns	-23 <monitor+0x60>
; }
8041603637: 5b                         	popq	%rbx
8041603638: 41 5c                      	popq	%r12
804160363a: 41 5e                      	popq	%r14
804160363c: 41 5f                      	popq	%r15
804160363e: 5d                         	popq	%rbp
804160363f: c3                         	retq

0000008041603640 runcmd:
; runcmd(char *buf, struct Trapframe *tf) {
8041603640: 55                         	pushq	%rbp
8041603641: 48 89 e5                   	movq	%rsp, %rbp
8041603644: 41 57                      	pushq	%r15
8041603646: 41 56                      	pushq	%r14
8041603648: 41 55                      	pushq	%r13
804160364a: 41 54                      	pushq	%r12
804160364c: 53                         	pushq	%rbx
804160364d: 48 81 ec 88 00 00 00       	subq	$136, %rsp
8041603654: 49 89 f6                   	movq	%rsi, %r14
8041603657: 48 89 fb                   	movq	%rdi, %rbx
;   argv[argc] = 0;
804160365a: 48 c7 85 50 ff ff ff 00 00 00 00   	movq	$0, -176(%rbp)
8041603665: 45 31 ff                   	xorl	%r15d, %r15d
8041603668: 49 bc aa 5a 60 41 80 00 00 00      	movabsq	$550852647594, %r12
8041603672: 49 bd b0 51 60 41 80 00 00 00      	movabsq	$550852645296, %r13
804160367c: 0f 1f 40 00                	nopl	(%rax)
;     while (*buf && strchr(WHITESPACE, *buf))
8041603680: 8a 03                      	movb	(%rbx), %al
8041603682: 84 c0                      	testb	%al, %al
8041603684: 74 27                      	je	39 <runcmd+0x6d>
8041603686: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041603690: 0f be f0                   	movsbl	%al, %esi
8041603693: 4c 89 e7                   	movq	%r12, %rdi
8041603696: 41 ff d5                   	callq	*%r13
8041603699: 48 85 c0                   	testq	%rax, %rax
804160369c: 74 0f                      	je	15 <runcmd+0x6d>
;       *buf++ = 0;
804160369e: c6 03 00                   	movb	$0, (%rbx)
;     while (*buf && strchr(WHITESPACE, *buf))
80416036a1: 0f b6 43 01                	movzbl	1(%rbx), %eax
;       *buf++ = 0;
80416036a5: 48 83 c3 01                	addq	$1, %rbx
;     while (*buf && strchr(WHITESPACE, *buf))
80416036a9: 84 c0                      	testb	%al, %al
80416036ab: 75 e3                      	jne	-29 <runcmd+0x50>
;     if (*buf == 0)
80416036ad: 80 3b 00                   	cmpb	$0, (%rbx)
80416036b0: 74 3a                      	je	58 <runcmd+0xac>
;     if (argc == MAXARGS - 1) {
80416036b2: 49 83 ff 0f                	cmpq	$15, %r15
80416036b6: 0f 84 a2 00 00 00          	je	162 <runcmd+0x11e>
;     argv[argc++] = buf;
80416036bc: 4a 89 9c fd 50 ff ff ff    	movq	%rbx, -176(%rbp,%r15,8)
80416036c4: 49 83 c7 01                	addq	$1, %r15
;     while (*buf && !strchr(WHITESPACE, *buf))
80416036c8: 8a 03                      	movb	(%rbx), %al
80416036ca: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
80416036d0: 84 c0                      	testb	%al, %al
80416036d2: 74 ac                      	je	-84 <runcmd+0x40>
80416036d4: 0f be f0                   	movsbl	%al, %esi
80416036d7: 4c 89 e7                   	movq	%r12, %rdi
80416036da: 41 ff d5                   	callq	*%r13
80416036dd: 48 85 c0                   	testq	%rax, %rax
80416036e0: 75 9e                      	jne	-98 <runcmd+0x40>
80416036e2: 0f b6 43 01                	movzbl	1(%rbx), %eax
;       buf++;
80416036e6: 48 83 c3 01                	addq	$1, %rbx
80416036ea: eb e4                      	jmp	-28 <runcmd+0x90>
;   argv[argc] = 0;
80416036ec: 44 89 f8                   	movl	%r15d, %eax
80416036ef: 48 c7 84 c5 50 ff ff ff 00 00 00 00	movq	$0, -176(%rbp,%rax,8)
;   if (argc == 0)
80416036fb: 45 85 ff                   	testl	%r15d, %r15d
80416036fe: 74 7f                      	je	127 <runcmd+0x13f>
8041603700: 48 8b 85 50 ff ff ff       	movq	-176(%rbp), %rax
8041603707: 31 db                      	xorl	%ebx, %ebx
8041603709: 49 bc 40 63 60 41 80 00 00 00      	movabsq	$550852649792, %r12
8041603713: 49 bd 40 51 60 41 80 00 00 00      	movabsq	$550852645184, %r13
804160371d: 0f 1f 00                   	nopl	(%rax)
;     if (strcmp(argv[0], commands[i].name) == 0)
8041603720: 4a 8b 34 23                	movq	(%rbx,%r12), %rsi
8041603724: 48 89 c7                   	movq	%rax, %rdi
8041603727: 41 ff d5                   	callq	*%r13
804160372a: 85 c0                      	testl	%eax, %eax
804160372c: 74 55                      	je	85 <runcmd+0x143>
804160372e: 48 8b 85 50 ff ff ff       	movq	-176(%rbp), %rax
;   for (i = 0; i < NCOMMANDS; i++) {
8041603735: 48 83 c3 18                	addq	$24, %rbx
8041603739: 48 83 fb 78                	cmpq	$120, %rbx
804160373d: 75 e1                      	jne	-31 <runcmd+0xe0>
;   cprintf("Unknown command '%s'\n", argv[0]);
804160373f: 48 bf b2 54 60 41 80 00 00 00      	movabsq	$550852646066, %rdi
8041603749: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603753: 31 db                      	xorl	%ebx, %ebx
8041603755: 48 89 c6                   	movq	%rax, %rsi
8041603758: 31 c0                      	xorl	%eax, %eax
804160375a: ff d1                      	callq	*%rcx
804160375c: eb 39                      	jmp	57 <runcmd+0x157>
;       cprintf("Too many arguments (max %d)\n", MAXARGS);
804160375e: 48 bf 7b 56 60 41 80 00 00 00      	movabsq	$550852646523, %rdi
8041603768: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603772: 31 db                      	xorl	%ebx, %ebx
8041603774: be 10 00 00 00             	movl	$16, %esi
8041603779: 31 c0                      	xorl	%eax, %eax
804160377b: ff d1                      	callq	*%rcx
804160377d: eb 18                      	jmp	24 <runcmd+0x157>
804160377f: 31 db                      	xorl	%ebx, %ebx
8041603781: eb 14                      	jmp	20 <runcmd+0x157>
8041603783: 48 8d b5 50 ff ff ff       	leaq	-176(%rbp), %rsi
;       return commands[i].func(argc, argv, tf);
804160378a: 44 89 ff                   	movl	%r15d, %edi
804160378d: 4c 89 f2                   	movq	%r14, %rdx
8041603790: 41 ff 54 1c 10             	callq	*16(%r12,%rbx)
8041603795: 89 c3                      	movl	%eax, %ebx
; }
8041603797: 89 d8                      	movl	%ebx, %eax
8041603799: 48 81 c4 88 00 00 00       	addq	$136, %rsp
80416037a0: 5b                         	popq	%rbx
80416037a1: 41 5c                      	popq	%r12
80416037a3: 41 5d                      	popq	%r13
80416037a5: 41 5e                      	popq	%r14
80416037a7: 41 5f                      	popq	%r15
80416037a9: 5d                         	popq	%rbp
80416037aa: c3                         	retq
80416037ab: cc                         	int3
80416037ac: cc                         	int3
80416037ad: cc                         	int3
80416037ae: cc                         	int3
80416037af: cc                         	int3

00000080416037b0 envid2env:
; envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
80416037b0: 55                         	pushq	%rbp
80416037b1: 48 89 e5                   	movq	%rsp, %rbp
;   if (envid == 0) {
80416037b4: 85 ff                      	testl	%edi, %edi
80416037b6: 74 68                      	je	104 <envid2env+0x70>
;   e = &envs[ENVX(envid)];
80416037b8: 48 b8 10 73 61 41 80 00 00 00      	movabsq	$550852719376, %rax
80416037c2: 48 8b 00                   	movq	(%rax), %rax
80416037c5: 89 f9                      	movl	%edi, %ecx
80416037c7: 83 e1 1f                   	andl	$31, %ecx
80416037ca: 48 69 c9 e0 00 00 00       	imulq	$224, %rcx, %rcx
;   if (e->env_status == ENV_FREE || e->env_id != envid) {
80416037d1: 83 bc 08 d4 00 00 00 00    	cmpl	$0, 212(%rax,%rcx)
80416037d9: 74 37                      	je	55 <envid2env+0x62>
80416037db: 39 bc 08 c8 00 00 00       	cmpl	%edi, 200(%rax,%rcx)
80416037e2: 75 2e                      	jne	46 <envid2env+0x62>
80416037e4: 48 8d 3c 08                	leaq	(%rax,%rcx), %rdi
;   if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
80416037e8: 84 d2                      	testb	%dl, %dl
80416037ea: 74 21                      	je	33 <envid2env+0x5d>
80416037ec: 48 ba c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rdx
80416037f6: 48 8b 12                   	movq	(%rdx), %rdx
80416037f9: 48 39 d7                   	cmpq	%rdx, %rdi
80416037fc: 74 0f                      	je	15 <envid2env+0x5d>
80416037fe: 8b 84 08 cc 00 00 00       	movl	204(%rax,%rcx), %eax
8041603805: 3b 82 c8 00 00 00          	cmpl	200(%rdx), %eax
804160380b: 75 05                      	jne	5 <envid2env+0x62>
;   *env_store = e;
804160380d: 48 89 3e                   	movq	%rdi, (%rsi)
8041603810: eb 1e                      	jmp	30 <envid2env+0x80>
8041603812: 48 c7 06 00 00 00 00       	movq	$0, (%rsi)
8041603819: b8 fe ff ff ff             	movl	$4294967294, %eax
; }
804160381e: 5d                         	popq	%rbp
804160381f: c3                         	retq
;     *env_store = curenv;
8041603820: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
804160382a: 48 8b 00                   	movq	(%rax), %rax
804160382d: 48 89 06                   	movq	%rax, (%rsi)
8041603830: 31 c0                      	xorl	%eax, %eax
; }
8041603832: 5d                         	popq	%rbp
8041603833: c3                         	retq
8041603834: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160383e: 66 90                      	nop

0000008041603840 env_init:
; env_init(void) {
8041603840: 55                         	pushq	%rbp
8041603841: 48 89 e5                   	movq	%rsp, %rbp
;   env_free_list = NULL;
8041603844: 48 b8 c8 15 62 41 80 00 00 00      	movabsq	$550852761032, %rax
804160384e: 48 c7 00 00 00 00 00       	movq	$0, (%rax)
8041603855: b9 20 1b 00 00             	movl	$6944, %ecx
804160385a: 48 ba 10 73 61 41 80 00 00 00      	movabsq	$550852719376, %rdx
8041603864: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160386e: 66 90                      	nop
;     envs[i].env_link = env_free_list;
8041603870: 48 8b 30                   	movq	(%rax), %rsi
8041603873: 48 8b 3a                   	movq	(%rdx), %rdi
8041603876: 48 89 b4 0f c0 00 00 00    	movq	%rsi, 192(%rdi,%rcx)
;     envs[i].env_id   = 0;
804160387e: 48 8b 32                   	movq	(%rdx), %rsi
8041603881: c7 84 0e c8 00 00 00 00 00 00 00   	movl	$0, 200(%rsi,%rcx)
804160388c: 48 01 ce                   	addq	%rcx, %rsi
;     env_free_list    = &envs[i];
804160388f: 48 89 30                   	movq	%rsi, (%rax)
;   for (int i = NENV - 1; i >= 0; i--) { 
8041603892: 48 81 c1 20 ff ff ff       	addq	$-224, %rcx
8041603899: 48 81 f9 20 ff ff ff       	cmpq	$-224, %rcx
80416038a0: 75 ce                      	jne	-50 <env_init+0x30>
;   env_init_percpu();
80416038a2: 48 b8 b0 38 60 41 80 00 00 00      	movabsq	$550852638896, %rax
80416038ac: ff d0                      	callq	*%rax
; }
80416038ae: 5d                         	popq	%rbp
80416038af: c3                         	retq

00000080416038b0 env_init_percpu:
; env_init_percpu(void) {
80416038b0: 55                         	pushq	%rbp
80416038b1: 48 89 e5                   	movq	%rsp, %rbp
80416038b4: 53                         	pushq	%rbx
;   __asm __volatile("lgdt (%0)"
80416038b5: 48 b8 68 73 61 41 80 00 00 00      	movabsq	$550852719464, %rax
80416038bf: 0f 01 10                   	lgdtq	(%rax)
;   asm volatile("movw %%ax,%%gs" ::"a"(GD_UD | 3));
80416038c2: b8 33 00 00 00             	movl	$51, %eax
80416038c7: 8e e8                      	movl	%eax, %gs
;   asm volatile("movw %%ax,%%fs" ::"a"(GD_UD | 3));
80416038c9: b8 33 00 00 00             	movl	$51, %eax
80416038ce: 8e e0                      	movl	%eax, %fs
;   asm volatile("movw %%ax,%%es" ::"a"(GD_KD));
80416038d0: b8 10 00 00 00             	movl	$16, %eax
80416038d5: 8e c0                      	movl	%eax, %es
;   asm volatile("movw %%ax,%%ds" ::"a"(GD_KD));
80416038d7: b8 10 00 00 00             	movl	$16, %eax
80416038dc: 8e d8                      	movl	%eax, %ds
;   asm volatile("movw %%ax,%%ss" ::"a"(GD_KD));
80416038de: b8 10 00 00 00             	movl	$16, %eax
80416038e3: 8e d0                      	movl	%eax, %ss
;   asm volatile("pushq %%rbx \n \t movabs $1f,%%rax \n \t pushq %%rax \n\t lretq \n 1:\n" ::"b"(GD_KT)
80416038e5: bb 08 00 00 00             	movl	$8, %ebx
80416038ea: 53                         	pushq	%rbx
80416038eb: 48 b8 f8 38 60 41 80 00 00 00      	movabsq	$550852638968, %rax
80416038f5: 50                         	pushq	%rax
80416038f6: 48 cb                      	lretq
;   asm volatile("movw $0,%%ax \n lldt %%ax\n"
80416038f8: 66 b8 00 00                	movw	$0, %ax
80416038fc: 0f 00 d0                   	lldtw	%ax
; }
80416038ff: 5b                         	popq	%rbx
8041603900: 5d                         	popq	%rbp
8041603901: c3                         	retq
8041603902: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160390c: 0f 1f 40 00                	nopl	(%rax)

0000008041603910 env_alloc:
; env_alloc(struct Env **newenv_store, envid_t parent_id) {
8041603910: 55                         	pushq	%rbp
8041603911: 48 89 e5                   	movq	%rsp, %rbp
8041603914: 41 57                      	pushq	%r15
8041603916: 41 56                      	pushq	%r14
8041603918: 41 54                      	pushq	%r12
804160391a: 53                         	pushq	%rbx
;   if (!(e = env_free_list)) {
804160391b: 49 bc c8 15 62 41 80 00 00 00      	movabsq	$550852761032, %r12
8041603925: 49 8b 1c 24                	movq	(%r12), %rbx
8041603929: 48 85 db                   	testq	%rbx, %rbx
804160392c: 0f 84 07 01 00 00          	je	263 <env_alloc+0x129>
8041603932: 49 89 fe                   	movq	%rdi, %r14
8041603935: b8 00 10 00 00             	movl	$4096, %eax
804160393a: 8b 8b c8 00 00 00          	movl	200(%rbx), %ecx
;   generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
8041603940: 01 c1                      	addl	%eax, %ecx
8041603942: 83 e1 e0                   	andl	$-32, %ecx
;   if (generation <= 0) // Don't create a negative env_id.
8041603945: 85 c9                      	testl	%ecx, %ecx
8041603947: 0f 4e c8                   	cmovlel	%eax, %ecx
;   e->env_id = generation | (e - envs);
804160394a: 48 b8 10 73 61 41 80 00 00 00      	movabsq	$550852719376, %rax
8041603954: 48 89 da                   	movq	%rbx, %rdx
8041603957: 48 2b 10                   	subq	(%rax), %rdx
804160395a: 48 c1 ea 05                	shrq	$5, %rdx
804160395e: 69 c2 b7 6d db b6          	imull	$3067833783, %edx, %eax
8041603964: 09 c8                      	orl	%ecx, %eax
8041603966: 89 83 c8 00 00 00          	movl	%eax, 200(%rbx)
;   e->env_parent_id = parent_id;
804160396c: 89 b3 cc 00 00 00          	movl	%esi, 204(%rbx)
8041603972: 48 b8 01 00 00 00 02 00 00 00      	movabsq	$8589934593, %rax
;   e->env_type = ENV_TYPE_KERNEL;
804160397c: 48 89 83 d0 00 00 00       	movq	%rax, 208(%rbx)
;   e->env_runs   = 0;
8041603983: c7 83 d8 00 00 00 00 00 00 00      	movl	$0, 216(%rbx)
;   memset(&e->env_tf, 0, sizeof(e->env_tf));
804160398d: 48 b8 10 52 60 41 80 00 00 00      	movabsq	$550852645392, %rax
8041603997: 45 31 ff                   	xorl	%r15d, %r15d
804160399a: ba c0 00 00 00             	movl	$192, %edx
804160399f: 48 89 df                   	movq	%rbx, %rdi
80416039a2: 31 f6                      	xorl	%esi, %esi
80416039a4: ff d0                      	callq	*%rax
;   e->env_tf.tf_ds = GD_KD | 0;
80416039a6: 66 c7 83 80 00 00 00 10 00 	movw	$16, 128(%rbx)
;   e->env_tf.tf_es = GD_KD | 0;
80416039af: 66 c7 43 78 10 00          	movw	$16, 120(%rbx)
;   e->env_tf.tf_ss = GD_KD | 0;
80416039b5: 66 c7 83 b8 00 00 00 10 00 	movw	$16, 184(%rbx)
;   e->env_tf.tf_cs = GD_KT | 0;
80416039be: 66 c7 83 a0 00 00 00 08 00 	movw	$8, 160(%rbx)
;   e->env_tf.tf_rsp = STACK_TOP;
80416039c7: 48 b8 78 73 61 41 80 00 00 00      	movabsq	$550852719480, %rax
80416039d1: 48 8b 08                   	movq	(%rax), %rcx
80416039d4: 48 89 8b b0 00 00 00       	movq	%rcx, 176(%rbx)
;   STACK_TOP -= 2 * PGSIZE;
80416039db: 48 81 c1 00 e0 ff ff       	addq	$-8192, %rcx
80416039e2: 48 89 08                   	movq	%rcx, (%rax)
;   __asm __volatile("pushfq; popq %0"
80416039e5: 9c                         	pushfq
80416039e6: 58                         	popq	%rax
;   e->env_tf.tf_rflags = read_rflags();
80416039e7: 48 89 83 a8 00 00 00       	movq	%rax, 168(%rbx)
;   env_free_list = e->env_link;
80416039ee: 48 8b 83 c0 00 00 00       	movq	192(%rbx), %rax
80416039f5: 49 89 04 24                	movq	%rax, (%r12)
;   *newenv_store = e;
80416039f9: 49 89 1e                   	movq	%rbx, (%r14)
;   cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
80416039fc: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
8041603a06: 48 8b 00                   	movq	(%rax), %rax
8041603a09: be 00 00 00 00             	movl	$0, %esi
8041603a0e: 48 85 c0                   	testq	%rax, %rax
8041603a11: 74 06                      	je	6 <env_alloc+0x109>
8041603a13: 8b b0 c8 00 00 00          	movl	200(%rax), %esi
8041603a19: 8b 93 c8 00 00 00          	movl	200(%rbx), %edx
8041603a1f: 48 bf 72 55 60 41 80 00 00 00      	movabsq	$550852646258, %rdi
8041603a29: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603a33: 31 c0                      	xorl	%eax, %eax
8041603a35: ff d1                      	callq	*%rcx
8041603a37: eb 06                      	jmp	6 <env_alloc+0x12f>
8041603a39: 41 bf fb ff ff ff          	movl	$4294967291, %r15d
; }
8041603a3f: 44 89 f8                   	movl	%r15d, %eax
8041603a42: 5b                         	popq	%rbx
8041603a43: 41 5c                      	popq	%r12
8041603a45: 41 5e                      	popq	%r14
8041603a47: 41 5f                      	popq	%r15
8041603a49: 5d                         	popq	%rbp
8041603a4a: c3                         	retq
8041603a4b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041603a50 env_create:
; env_create(uint8_t *binary, enum EnvType type){
8041603a50: 55                         	pushq	%rbp
8041603a51: 48 89 e5                   	movq	%rsp, %rbp
8041603a54: 41 56                      	pushq	%r14
8041603a56: 53                         	pushq	%rbx
8041603a57: 48 83 ec 10                	subq	$16, %rsp
8041603a5b: 89 f3                      	movl	%esi, %ebx
8041603a5d: 49 89 fe                   	movq	%rdi, %r14
;   if (env_alloc(&newenv, 0) < 0) {
8041603a60: 48 b8 10 39 60 41 80 00 00 00      	movabsq	$550852638992, %rax
8041603a6a: 48 8d 7d e8                	leaq	-24(%rbp), %rdi
8041603a6e: 31 f6                      	xorl	%esi, %esi
8041603a70: ff d0                      	callq	*%rax
8041603a72: 85 c0                      	testl	%eax, %eax
8041603a74: 78 22                      	js	34 <env_create+0x48>
;   newenv->env_type = type;
8041603a76: 48 8b 7d e8                	movq	-24(%rbp), %rdi
8041603a7a: 89 9f d0 00 00 00          	movl	%ebx, 208(%rdi)
;   load_icode(newenv, binary); // load instruction code
8041603a80: 48 b8 c0 3a 60 41 80 00 00 00      	movabsq	$550852639424, %rax
8041603a8a: 4c 89 f6                   	movq	%r14, %rsi
8041603a8d: ff d0                      	callq	*%rax
; }
8041603a8f: 48 83 c4 10                	addq	$16, %rsp
8041603a93: 5b                         	popq	%rbx
8041603a94: 41 5e                      	popq	%r14
8041603a96: 5d                         	popq	%rbp
8041603a97: c3                         	retq
;     panic("Can't allocate new environment");  // попытка выделить среду
8041603a98: 48 bf 57 57 60 41 80 00 00 00      	movabsq	$550852646743, %rdi
8041603aa2: 48 ba 67 5a 60 41 80 00 00 00      	movabsq	$550852647527, %rdx
8041603aac: 48 b9 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rcx
8041603ab6: be 6d 01 00 00             	movl	$365, %esi
8041603abb: 31 c0                      	xorl	%eax, %eax
8041603abd: ff d1                      	callq	*%rcx
8041603abf: 90                         	nop

0000008041603ac0 load_icode:
; load_icode(struct Env *e, uint8_t *binary) {
8041603ac0: 55                         	pushq	%rbp
8041603ac1: 48 89 e5                   	movq	%rsp, %rbp
8041603ac4: 41 57                      	pushq	%r15
8041603ac6: 41 56                      	pushq	%r14
8041603ac8: 41 55                      	pushq	%r13
8041603aca: 41 54                      	pushq	%r12
8041603acc: 53                         	pushq	%rbx
8041603acd: 48 83 ec 18                	subq	$24, %rsp
;   if (elf->e_magic != ELF_MAGIC) {
8041603ad1: 81 3e 7f 45 4c 46          	cmpl	$1179403647, (%rsi)
8041603ad7: 0f 85 c9 00 00 00          	jne	201 <load_icode+0xe6>
8041603add: 48 89 f3                   	movq	%rsi, %rbx
;   for (size_t i = 0; i < elf->e_phnum; i++) {        //elf->e_phnum - Число заголовков программы. Если у файла нет таблицы заголовков программы, это поле содержит 0.
8041603ae0: 66 83 7e 38 00             	cmpw	$0, 56(%rsi)
8041603ae5: 0f 84 d3 00 00 00          	je	211 <load_icode+0xfe>
8041603aeb: 49 89 fc                   	movq	%rdi, %r12
8041603aee: 48 8b 43 20                	movq	32(%rbx), %rax
8041603af2: 4c 8d 34 18                	leaq	(%rax,%rbx), %r14
8041603af6: 49 83 c6 28                	addq	$40, %r14
8041603afa: 45 31 ff                   	xorl	%r15d, %r15d
8041603afd: 49 bd 40 3e 60 41 80 00 00 00      	movabsq	$550852640320, %r13
8041603b07: 48 89 5d c8                	movq	%rbx, -56(%rbp)
8041603b0b: 48 89 7d d0                	movq	%rdi, -48(%rbp)
8041603b0f: eb 32                      	jmp	50 <load_icode+0x83>
8041603b11: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041603b1b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     e->env_tf.tf_rip = elf->e_entry; //Виртуальный адрес точки входа, которому система передает управление при запуске процесса. в регистр rip записываем адрес точки входа для выполнения процесса
8041603b20: 48 8b 43 18                	movq	24(%rbx), %rax
8041603b24: 49 89 84 24 98 00 00 00    	movq	%rax, 152(%r12)
;     bind_functions(e, binary); // Вызывается bind_functions, который связывает все что мы сделали выше (инициализация среды) с "кодом" самого процесса
8041603b2c: 48 89 df                   	movq	%rbx, %rdi
8041603b2f: 41 ff d5                   	callq	*%r13
;   for (size_t i = 0; i < elf->e_phnum; i++) {        //elf->e_phnum - Число заголовков программы. Если у файла нет таблицы заголовков программы, это поле содержит 0.
8041603b32: 49 83 c7 01                	addq	$1, %r15
8041603b36: 0f b7 43 38                	movzwl	56(%rbx), %eax
8041603b3a: 49 83 c6 38                	addq	$56, %r14
8041603b3e: 49 39 c7                   	cmpq	%rax, %r15
8041603b41: 73 7b                      	jae	123 <load_icode+0xfe>
;     if (ph[i].p_type == ELF_PROG_LOAD) {
8041603b43: 41 83 7e d8 01             	cmpl	$1, -40(%r14)
8041603b48: 75 d6                      	jne	-42 <load_icode+0x60>
8041603b4a: 49 8b 76 e0                	movq	-32(%r14), %rsi
;       void *src = binary + ph[i].p_offset;
8041603b4e: 48 01 de                   	addq	%rbx, %rsi
;       size_t memsz  = ph[i].p_memsz;
8041603b51: 4d 8b 2e                   	movq	(%r14), %r13
;       void *dst = (void *)ph[i].p_va;
8041603b54: 4d 8b 66 e8                	movq	-24(%r14), %r12
;       size_t filesz = MIN(ph[i].p_filesz, memsz);
8041603b58: 49 8b 5e f8                	movq	-8(%r14), %rbx
8041603b5c: 4c 39 eb                   	cmpq	%r13, %rbx
8041603b5f: 49 0f 47 dd                	cmovaq	%r13, %rbx
;       memcpy(dst, src, filesz);                // копируем в dst (дистинейшн) src (код) размера filesz
8041603b63: 4c 89 e7                   	movq	%r12, %rdi
8041603b66: 48 89 da                   	movq	%rbx, %rdx
8041603b69: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041603b73: ff d0                      	callq	*%rax
;       memset(dst + filesz, 0, memsz - filesz); // обнуление памяти по адресу dst + filesz, где количество нулей = memsz - filesz. Т.е. зануляем всю выделенную память сегмента кода, оставшуюяся после копирования src. Возможно, эта строка не нужна
8041603b75: 49 01 dc                   	addq	%rbx, %r12
8041603b78: 49 29 dd                   	subq	%rbx, %r13
8041603b7b: 48 8b 5d c8                	movq	-56(%rbp), %rbx
8041603b7f: 4c 89 e7                   	movq	%r12, %rdi
8041603b82: 4c 8b 65 d0                	movq	-48(%rbp), %r12
8041603b86: 31 f6                      	xorl	%esi, %esi
8041603b88: 4c 89 ea                   	movq	%r13, %rdx
8041603b8b: 49 bd 40 3e 60 41 80 00 00 00      	movabsq	$550852640320, %r13
8041603b95: 48 b8 10 52 60 41 80 00 00 00      	movabsq	$550852645392, %rax
8041603b9f: ff d0                      	callq	*%rax
8041603ba1: e9 7a ff ff ff             	jmp	-134 <load_icode+0x60>
;     cprintf("Unexpected ELF format\n");
8041603ba6: 48 bf 4b 55 60 41 80 00 00 00      	movabsq	$550852646219, %rdi
8041603bb0: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603bba: 31 c0                      	xorl	%eax, %eax
8041603bbc: ff d1                      	callq	*%rcx
; }
8041603bbe: 48 83 c4 18                	addq	$24, %rsp
8041603bc2: 5b                         	popq	%rbx
8041603bc3: 41 5c                      	popq	%r12
8041603bc5: 41 5d                      	popq	%r13
8041603bc7: 41 5e                      	popq	%r14
8041603bc9: 41 5f                      	popq	%r15
8041603bcb: 5d                         	popq	%rbp
8041603bcc: c3                         	retq
8041603bcd: 0f 1f 00                   	nopl	(%rax)

0000008041603bd0 env_free:
; env_free(struct Env *e) {
8041603bd0: 55                         	pushq	%rbp
8041603bd1: 48 89 e5                   	movq	%rsp, %rbp
8041603bd4: 53                         	pushq	%rbx
8041603bd5: 50                         	pushq	%rax
8041603bd6: 48 89 fb                   	movq	%rdi, %rbx
;   cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
8041603bd9: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
8041603be3: 48 8b 00                   	movq	(%rax), %rax
8041603be6: 48 85 c0                   	testq	%rax, %rax
8041603be9: 74 08                      	je	8 <env_free+0x23>
8041603beb: 8b b0 c8 00 00 00          	movl	200(%rax), %esi
8041603bf1: eb 02                      	jmp	2 <env_free+0x25>
8041603bf3: 31 f6                      	xorl	%esi, %esi
8041603bf5: 8b 93 c8 00 00 00          	movl	200(%rbx), %edx
8041603bfb: 48 bf 48 58 60 41 80 00 00 00      	movabsq	$550852646984, %rdi
8041603c05: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603c0f: 31 c0                      	xorl	%eax, %eax
8041603c11: ff d1                      	callq	*%rcx
;   e->env_status = ENV_FREE;
8041603c13: c7 83 d4 00 00 00 00 00 00 00      	movl	$0, 212(%rbx)
;   e->env_link   = env_free_list;
8041603c1d: 48 b8 c8 15 62 41 80 00 00 00      	movabsq	$550852761032, %rax
8041603c27: 48 8b 08                   	movq	(%rax), %rcx
8041603c2a: 48 89 8b c0 00 00 00       	movq	%rcx, 192(%rbx)
;   env_free_list = e;
8041603c31: 48 89 18                   	movq	%rbx, (%rax)
; }
8041603c34: 48 83 c4 08                	addq	$8, %rsp
8041603c38: 5b                         	popq	%rbx
8041603c39: 5d                         	popq	%rbp
8041603c3a: c3                         	retq
8041603c3b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041603c40 env_destroy:
; env_destroy(struct Env *e) {
8041603c40: 55                         	pushq	%rbp
8041603c41: 48 89 e5                   	movq	%rsp, %rbp
;   e->env_status = ENV_DYING; // environment died, long live new environment (not here)!
8041603c44: c7 87 d4 00 00 00 01 00 00 00      	movl	$1, 212(%rdi)
;   if (e == curenv) {
8041603c4e: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
8041603c58: 48 39 38                   	cmpq	%rdi, (%rax)
8041603c5b: 74 02                      	je	2 <env_destroy+0x1f>
; }
8041603c5d: 5d                         	popq	%rbp
8041603c5e: c3                         	retq
;     env_free(e); // очистка среды
8041603c5f: 48 b8 d0 3b 60 41 80 00 00 00      	movabsq	$550852639696, %rax
8041603c69: ff d0                      	callq	*%rax
;     sched_yield(); // вызывается функция, обрабатывающая смену/удаление среды
8041603c6b: 48 b8 d0 40 60 41 80 00 00 00      	movabsq	$550852640976, %rax
8041603c75: ff d0                      	callq	*%rax
8041603c77: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)

0000008041603c80 csys_exit:
; csys_exit(void) {
8041603c80: 55                         	pushq	%rbp
8041603c81: 48 89 e5                   	movq	%rsp, %rbp
;   env_destroy(curenv);
8041603c84: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
8041603c8e: 48 8b 38                   	movq	(%rax), %rdi
8041603c91: 48 b8 40 3c 60 41 80 00 00 00      	movabsq	$550852639808, %rax
8041603c9b: ff d0                      	callq	*%rax
; }
8041603c9d: 5d                         	popq	%rbp
8041603c9e: c3                         	retq
8041603c9f: 90                         	nop

0000008041603ca0 csys_yield:
; csys_yield(struct Trapframe *tf) {
8041603ca0: 55                         	pushq	%rbp
8041603ca1: 48 89 e5                   	movq	%rsp, %rbp
8041603ca4: 48 89 fe                   	movq	%rdi, %rsi
;   memcpy(&curenv->env_tf, tf, sizeof(struct Trapframe));
8041603ca7: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
8041603cb1: 48 8b 38                   	movq	(%rax), %rdi
8041603cb4: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041603cbe: ba c0 00 00 00             	movl	$192, %edx
8041603cc3: ff d0                      	callq	*%rax
;   sched_yield();
8041603cc5: 48 b8 d0 40 60 41 80 00 00 00      	movabsq	$550852640976, %rax
8041603ccf: ff d0                      	callq	*%rax
8041603cd1: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041603cdb: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041603ce0 env_pop_tf:
; env_pop_tf(struct Trapframe *tf) {
8041603ce0: 55                         	pushq	%rbp
8041603ce1: 48 89 e5                   	movq	%rsp, %rbp
8041603ce4: 53                         	pushq	%rbx
8041603ce5: 50                         	pushq	%rax
8041603ce6: 48 89 f8                   	movq	%rdi, %rax
;   asm volatile(
8041603ce9: 48 8b 58 68                	movq	104(%rax), %rbx
8041603ced: 48 8b 48 60                	movq	96(%rax), %rcx
8041603cf1: 48 8b 50 58                	movq	88(%rax), %rdx
8041603cf5: 48 8b 70 40                	movq	64(%rax), %rsi
8041603cf9: 48 8b 78 48                	movq	72(%rax), %rdi
8041603cfd: 48 8b 68 50                	movq	80(%rax), %rbp
8041603d01: 48 8b a0 b0 00 00 00       	movq	176(%rax), %rsp
8041603d08: 4c 8b 40 38                	movq	56(%rax), %r8
8041603d0c: 4c 8b 48 30                	movq	48(%rax), %r9
8041603d10: 4c 8b 50 28                	movq	40(%rax), %r10
8041603d14: 4c 8b 58 20                	movq	32(%rax), %r11
8041603d18: 4c 8b 60 18                	movq	24(%rax), %r12
8041603d1c: 4c 8b 68 10                	movq	16(%rax), %r13
8041603d20: 4c 8b 70 08                	movq	8(%rax), %r14
8041603d24: 4c 8b 38                   	movq	(%rax), %r15
8041603d27: ff b0 98 00 00 00          	pushq	152(%rax)
8041603d2d: ff b0 a8 00 00 00          	pushq	168(%rax)
8041603d33: 48 8b 40 70                	movq	112(%rax), %rax
8041603d37: 9d                         	popfq
8041603d38: c3                         	retq
;   panic("BUG"); /* mostly to placate the compiler */
8041603d39: 48 bf 57 57 60 41 80 00 00 00      	movabsq	$550852646743, %rdi
8041603d43: 48 ba 1a 5b 60 41 80 00 00 00      	movabsq	$550852647706, %rdx
8041603d4d: 48 b9 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rcx
8041603d57: be db 01 00 00             	movl	$475, %esi
8041603d5c: 31 c0                      	xorl	%eax, %eax
8041603d5e: ff d1                      	callq	*%rcx

0000008041603d60 env_run:
; env_run(struct Env *e) {
8041603d60: 55                         	pushq	%rbp
8041603d61: 48 89 e5                   	movq	%rsp, %rbp
8041603d64: 41 57                      	pushq	%r15
8041603d66: 41 56                      	pushq	%r14
8041603d68: 53                         	pushq	%rbx
8041603d69: 50                         	pushq	%rax
8041603d6a: 48 89 fb                   	movq	%rdi, %rbx
;           ENVX(e->env_id));
8041603d6d: 8b 97 c8 00 00 00          	movl	200(%rdi), %edx
;           e->env_status == ENV_RUNNING ? "RUNNING" :
8041603d73: 8b 87 d4 00 00 00          	movl	212(%rdi), %eax
8041603d79: 83 f8 02                   	cmpl	$2, %eax
8041603d7c: 48 b9 5e 58 60 41 80 00 00 00      	movabsq	$550852647006, %rcx
8041603d86: 48 bf 98 56 60 41 80 00 00 00      	movabsq	$550852646552, %rdi
8041603d90: 48 0f 44 f9                	cmoveq	%rcx, %rdi
8041603d94: 83 f8 03                   	cmpl	$3, %eax
8041603d97: 48 be af 5a 60 41 80 00 00 00      	movabsq	$550852647599, %rsi
8041603da1: 48 0f 45 f7                	cmovneq	%rdi, %rsi
;           ENVX(e->env_id));
8041603da5: 83 e2 1f                   	andl	$31, %edx
;   cprintf("envrun %s: %d\n",
8041603da8: 48 bf a3 55 60 41 80 00 00 00      	movabsq	$550852646307, %rdi
8041603db2: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041603dbc: 31 c0                      	xorl	%eax, %eax
8041603dbe: ff d1                      	callq	*%rcx
;   if (curenv) {     // if curenv == False, значит, какого-нибудь исполняемого процесса нет
8041603dc0: 49 bf c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %r15
8041603dca: 4d 8b 37                   	movq	(%r15), %r14
8041603dcd: 4d 85 f6                   	testq	%r14, %r14
8041603dd0: 74 3c                      	je	60 <env_run+0xae>
;     if (curenv->env_status == ENV_DYING) { // если процесс стал зомби
8041603dd2: 41 8b 86 d4 00 00 00       	movl	212(%r14), %eax
8041603dd9: 83 f8 03                   	cmpl	$3, %eax
8041603ddc: 74 25                      	je	37 <env_run+0xa3>
8041603dde: 83 f8 01                   	cmpl	$1, %eax
8041603de1: 75 2b                      	jne	43 <env_run+0xae>
;       env_free(curenv);  
8041603de3: 48 b8 d0 3b 60 41 80 00 00 00      	movabsq	$550852639696, %rax
8041603ded: 4c 89 f7                   	movq	%r14, %rdi
8041603df0: ff d0                      	callq	*%rax
;       if (old == e) { // e - аргумент функции, который к нам пришел
8041603df2: 49 39 de                   	cmpq	%rbx, %r14
8041603df5: 75 17                      	jne	23 <env_run+0xae>
;         sched_yield();  // переключение системными вызовами 
8041603df7: 48 b8 d0 40 60 41 80 00 00 00      	movabsq	$550852640976, %rax
8041603e01: ff d0                      	callq	*%rax
;       curenv->env_status = ENV_RUNNABLE;  // запускаем процесс
8041603e03: 41 c7 86 d4 00 00 00 02 00 00 00   	movl	$2, 212(%r14)
;   curenv = e;  // текущая среда – е
8041603e0e: 49 89 1f                   	movq	%rbx, (%r15)
;   curenv->env_status = ENV_RUNNING; // устанавливаем статус среды на "выполняется"
8041603e11: c7 83 d4 00 00 00 03 00 00 00      	movl	$3, 212(%rbx)
;   curenv->env_runs++; // обновляем количество запусков контекста процесса
8041603e1b: 83 83 d8 00 00 00 01       	addl	$1, 216(%rbx)
;   env_pop_tf(&curenv->env_tf); // восстанавливаем из curen все переменные окружения
8041603e22: 48 b8 e0 3c 60 41 80 00 00 00      	movabsq	$550852639968, %rax
8041603e2c: 48 89 df                   	movq	%rbx, %rdi
8041603e2f: ff d0                      	callq	*%rax
8041603e31: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041603e3b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041603e40 bind_functions:
; bind_functions(struct Env *e, uint8_t *binary) {
8041603e40: 55                         	pushq	%rbp
8041603e41: 48 89 e5                   	movq	%rsp, %rbp
8041603e44: 41 57                      	pushq	%r15
8041603e46: 41 56                      	pushq	%r14
8041603e48: 41 55                      	pushq	%r13
8041603e4a: 41 54                      	pushq	%r12
8041603e4c: 53                         	pushq	%rbx
8041603e4d: 48 83 ec 28                	subq	$40, %rsp
;   struct Secthdr *sh = (struct Secthdr *)(binary + elf->e_shoff);
8041603e51: 48 8b 47 28                	movq	40(%rdi), %rax
8041603e55: 48 8d 14 07                	leaq	(%rdi,%rax), %rdx
8041603e59: 49 c7 c5 ff ff ff ff       	movq	$-1, %r13
;   for (size_t i = 0; i < elf->e_shnum; i++) {
8041603e60: 66 83 7f 3c 00             	cmpw	$0, 60(%rdi)
8041603e65: 48 89 7d c8                	movq	%rdi, -56(%rbp)
8041603e69: 48 89 55 d0                	movq	%rdx, -48(%rbp)
8041603e6d: 74 6c                      	je	108 <bind_functions+0x9b>
8041603e6f: 0f b7 4f 3e                	movzwl	62(%rdi), %ecx
8041603e73: 48 c1 e1 06                	shlq	$6, %rcx
8041603e77: 4c 8b 64 11 18             	movq	24(%rcx,%rdx), %r12
8041603e7c: 49 01 fc                   	addq	%rdi, %r12
8041603e7f: 48 8d 1c 38                	leaq	(%rax,%rdi), %rbx
8041603e83: 48 83 c3 04                	addq	$4, %rbx
8041603e87: 45 31 ed                   	xorl	%r13d, %r13d
8041603e8a: 49 bf 67 58 60 41 80 00 00 00      	movabsq	$550852647015, %r15
8041603e94: 49 be 40 51 60 41 80 00 00 00      	movabsq	$550852645184, %r14
8041603e9e: eb 11                      	jmp	17 <bind_functions+0x71>
8041603ea0: 49 83 c5 01                	addq	$1, %r13
8041603ea4: 0f b7 47 3c                	movzwl	60(%rdi), %eax
8041603ea8: 48 83 c3 40                	addq	$64, %rbx
8041603eac: 49 39 c5                   	cmpq	%rax, %r13
8041603eaf: 73 1f                      	jae	31 <bind_functions+0x90>
;     if (sh[i].sh_type == ELF_SHT_STRTAB && !strcmp(".strtab", shstr + sh[i].sh_name)) {
8041603eb1: 83 3b 03                   	cmpl	$3, (%rbx)
8041603eb4: 75 ea                      	jne	-22 <bind_functions+0x60>
8041603eb6: 8b 73 fc                   	movl	-4(%rbx), %esi
8041603eb9: 4c 01 e6                   	addq	%r12, %rsi
8041603ebc: 4c 89 ff                   	movq	%r15, %rdi
8041603ebf: 41 ff d6                   	callq	*%r14
8041603ec2: 48 8b 7d c8                	movq	-56(%rbp), %rdi
8041603ec6: 85 c0                      	testl	%eax, %eax
8041603ec8: 75 d6                      	jne	-42 <bind_functions+0x60>
8041603eca: 48 8b 55 d0                	movq	-48(%rbp), %rdx
8041603ece: eb 0b                      	jmp	11 <bind_functions+0x9b>
8041603ed0: 48 8b 55 d0                	movq	-48(%rbp), %rdx
8041603ed4: 49 c7 c5 ff ff ff ff       	movq	$-1, %r13
;   for (size_t i = 0; i < elf->e_shnum; i++) {
8041603edb: 66 83 7f 3c 00             	cmpw	$0, 60(%rdi)
8041603ee0: 0f 84 cf 00 00 00          	je	207 <bind_functions+0x175>
8041603ee6: 49 c1 e5 06                	shlq	$6, %r13
8041603eea: 4e 8b 6c 2a 18             	movq	24(%rdx,%r13), %r13
8041603eef: 49 01 fd                   	addq	%rdi, %r13
8041603ef2: 48 8d 47 10                	leaq	16(%rdi), %rax
8041603ef6: 48 89 45 c0                	movq	%rax, -64(%rbp)
8041603efa: 45 31 f6                   	xorl	%r14d, %r14d
8041603efd: eb 1a                      	jmp	26 <bind_functions+0xd9>
8041603eff: 90                         	nop
8041603f00: 49 83 c6 01                	addq	$1, %r14
8041603f04: 48 8b 45 c8                	movq	-56(%rbp), %rax
8041603f08: 0f b7 40 3c                	movzwl	60(%rax), %eax
8041603f0c: 49 39 c6                   	cmpq	%rax, %r14
8041603f0f: 48 8b 55 d0                	movq	-48(%rbp), %rdx
8041603f13: 0f 83 9c 00 00 00          	jae	156 <bind_functions+0x175>
;     if (sh[i].sh_type == ELF_SHT_SYMTAB) {
8041603f19: 4c 89 f6                   	movq	%r14, %rsi
8041603f1c: 48 c1 e6 06                	shlq	$6, %rsi
8041603f20: 83 7c 32 04 02             	cmpl	$2, 4(%rdx,%rsi)
8041603f25: 75 d9                      	jne	-39 <bind_functions+0xc0>
8041603f27: 48 8b 45 d0                	movq	-48(%rbp), %rax
;       size_t nsyms = sh[i].sh_size / sizeof(*syms);
8041603f2b: 48 8b 4c 30 20             	movq	32(%rax,%rsi), %rcx
8041603f30: 48 89 c8                   	movq	%rcx, %rax
8041603f33: 48 ba ab aa aa aa aa aa aa aa      	movabsq	$-6148914691236517205, %rdx
8041603f3d: 48 f7 e2                   	mulq	%rdx
;       for (size_t j = 0; j < nsyms; j++) {
8041603f40: 48 83 f9 18                	cmpq	$24, %rcx
8041603f44: 72 ba                      	jb	-70 <bind_functions+0xc0>
8041603f46: 48 89 d3                   	movq	%rdx, %rbx
8041603f49: 48 c1 eb 04                	shrq	$4, %rbx
8041603f4d: 48 8b 45 d0                	movq	-48(%rbp), %rax
8041603f51: 4c 8b 64 30 18             	movq	24(%rax,%rsi), %r12
8041603f56: 4c 03 65 c0                	addq	-64(%rbp), %r12
8041603f5a: 45 31 ff                   	xorl	%r15d, %r15d
8041603f5d: eb 0e                      	jmp	14 <bind_functions+0x12d>
8041603f5f: 90                         	nop
8041603f60: 49 83 c7 01                	addq	$1, %r15
8041603f64: 49 83 c4 18                	addq	$24, %r12
8041603f68: 49 39 df                   	cmpq	%rbx, %r15
8041603f6b: 73 93                      	jae	-109 <bind_functions+0xc0>
;         if (ELF64_ST_BIND(syms[j].st_info) == STB_GLOBAL &&
8041603f6d: 41 80 7c 24 f4 11          	cmpb	$17, -12(%r12)
8041603f73: 75 eb                      	jne	-21 <bind_functions+0x120>
;             syms[j].st_size == sizeof(void *)) {
8041603f75: 49 83 3c 24 08             	cmpq	$8, (%r12)
;         if (ELF64_ST_BIND(syms[j].st_info) == STB_GLOBAL &&
8041603f7a: 75 e4                      	jne	-28 <bind_functions+0x120>
;           const char *name = strings + syms[j].st_name;
8041603f7c: 41 8b 7c 24 f0             	movl	-16(%r12), %edi
8041603f81: 4c 01 ef                   	addq	%r13, %rdi
;           uintptr_t addr = find_function(name);
8041603f84: 48 b8 d0 44 60 41 80 00 00 00      	movabsq	$550852642000, %rax
8041603f8e: ff d0                      	callq	*%rax
8041603f90: 48 89 45 b8                	movq	%rax, -72(%rbp)
;           if (addr) {
8041603f94: 48 85 c0                   	testq	%rax, %rax
8041603f97: 74 c7                      	je	-57 <bind_functions+0x120>
;             memcpy((void *)syms[j].st_value, &addr, sizeof(void *));
8041603f99: 49 8b 7c 24 f8             	movq	-8(%r12), %rdi
8041603f9e: ba 08 00 00 00             	movl	$8, %edx
8041603fa3: 48 8d 75 b8                	leaq	-72(%rbp), %rsi
8041603fa7: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
8041603fb1: ff d0                      	callq	*%rax
8041603fb3: eb ab                      	jmp	-85 <bind_functions+0x120>
; }
8041603fb5: 48 83 c4 28                	addq	$40, %rsp
8041603fb9: 5b                         	popq	%rbx
8041603fba: 41 5c                      	popq	%r12
8041603fbc: 41 5d                      	popq	%r13
8041603fbe: 41 5e                      	popq	%r14
8041603fc0: 41 5f                      	popq	%r15
8041603fc2: 5d                         	popq	%rbp
8041603fc3: c3                         	retq
8041603fc4: cc                         	int3
8041603fc5: cc                         	int3
8041603fc6: cc                         	int3
8041603fc7: cc                         	int3
8041603fc8: cc                         	int3
8041603fc9: cc                         	int3
8041603fca: cc                         	int3
8041603fcb: cc                         	int3
8041603fcc: cc                         	int3
8041603fcd: cc                         	int3
8041603fce: cc                         	int3
8041603fcf: cc                         	int3

0000008041603fd0 vcprintf:
; vcprintf(const char *fmt, va_list ap) {
8041603fd0: 55                         	pushq	%rbp
8041603fd1: 48 89 e5                   	movq	%rsp, %rbp
8041603fd4: 48 83 ec 10                	subq	$16, %rsp
8041603fd8: 48 89 f1                   	movq	%rsi, %rcx
8041603fdb: 48 89 fa                   	movq	%rdi, %rdx
;   int cnt = 0;
8041603fde: c7 45 fc 00 00 00 00       	movl	$0, -4(%rbp)
;   vprintfmt((void *)putch, &cnt, fmt, ap);
8041603fe5: 48 bf 10 40 60 41 80 00 00 00      	movabsq	$550852640784, %rdi
8041603fef: 48 b8 b0 45 60 41 80 00 00 00      	movabsq	$550852642224, %rax
8041603ff9: 48 8d 75 fc                	leaq	-4(%rbp), %rsi
8041603ffd: ff d0                      	callq	*%rax
;   return cnt;
8041603fff: 8b 45 fc                   	movl	-4(%rbp), %eax
8041604002: 48 83 c4 10                	addq	$16, %rsp
8041604006: 5d                         	popq	%rbp
8041604007: c3                         	retq
8041604008: 0f 1f 84 00 00 00 00 00    	nopl	(%rax,%rax)

0000008041604010 putch:
; putch(int ch, int *cnt) {
8041604010: 55                         	pushq	%rbp
8041604011: 48 89 e5                   	movq	%rsp, %rbp
8041604014: 53                         	pushq	%rbx
8041604015: 50                         	pushq	%rax
8041604016: 48 89 f3                   	movq	%rsi, %rbx
;   cputchar(ch);
8041604019: 48 b8 e0 08 60 41 80 00 00 00      	movabsq	$550852626656, %rax
8041604023: ff d0                      	callq	*%rax
;   (*cnt)++;
8041604025: 83 03 01                   	addl	$1, (%rbx)
; }
8041604028: 48 83 c4 08                	addq	$8, %rsp
804160402c: 5b                         	popq	%rbx
804160402d: 5d                         	popq	%rbp
804160402e: c3                         	retq
804160402f: 90                         	nop

0000008041604030 cprintf:
; cprintf(const char *fmt, ...) {
8041604030: 55                         	pushq	%rbp
8041604031: 48 89 e5                   	movq	%rsp, %rbp
8041604034: 48 81 ec d0 00 00 00       	subq	$208, %rsp
804160403b: 84 c0                      	testb	%al, %al
804160403d: 74 26                      	je	38 <cprintf+0x35>
804160403f: 0f 29 85 60 ff ff ff       	movaps	%xmm0, -160(%rbp)
8041604046: 0f 29 8d 70 ff ff ff       	movaps	%xmm1, -144(%rbp)
804160404d: 0f 29 55 80                	movaps	%xmm2, -128(%rbp)
8041604051: 0f 29 5d 90                	movaps	%xmm3, -112(%rbp)
8041604055: 0f 29 65 a0                	movaps	%xmm4, -96(%rbp)
8041604059: 0f 29 6d b0                	movaps	%xmm5, -80(%rbp)
804160405d: 0f 29 75 c0                	movaps	%xmm6, -64(%rbp)
8041604061: 0f 29 7d d0                	movaps	%xmm7, -48(%rbp)
8041604065: 48 89 b5 38 ff ff ff       	movq	%rsi, -200(%rbp)
804160406c: 48 89 95 40 ff ff ff       	movq	%rdx, -192(%rbp)
8041604073: 48 89 8d 48 ff ff ff       	movq	%rcx, -184(%rbp)
804160407a: 4c 89 85 50 ff ff ff       	movq	%r8, -176(%rbp)
8041604081: 4c 89 8d 58 ff ff ff       	movq	%r9, -168(%rbp)
8041604088: 48 8d 85 30 ff ff ff       	leaq	-208(%rbp), %rax
;   va_start(ap, fmt);
804160408f: 48 89 45 f0                	movq	%rax, -16(%rbp)
8041604093: 48 8d 45 10                	leaq	16(%rbp), %rax
8041604097: 48 89 45 e8                	movq	%rax, -24(%rbp)
804160409b: 48 b8 08 00 00 00 30 00 00 00      	movabsq	$206158430216, %rax
80416040a5: 48 89 45 e0                	movq	%rax, -32(%rbp)
;   cnt = vcprintf(fmt, ap);
80416040a9: 48 b8 d0 3f 60 41 80 00 00 00      	movabsq	$550852640720, %rax
80416040b3: 48 8d 75 e0                	leaq	-32(%rbp), %rsi
80416040b7: ff d0                      	callq	*%rax
;   return cnt;
80416040b9: 48 81 c4 d0 00 00 00       	addq	$208, %rsp
80416040c0: 5d                         	popq	%rbp
80416040c1: c3                         	retq
80416040c2: cc                         	int3
80416040c3: cc                         	int3
80416040c4: cc                         	int3
80416040c5: cc                         	int3
80416040c6: cc                         	int3
80416040c7: cc                         	int3
80416040c8: cc                         	int3
80416040c9: cc                         	int3
80416040ca: cc                         	int3
80416040cb: cc                         	int3
80416040cc: cc                         	int3
80416040cd: cc                         	int3
80416040ce: cc                         	int3
80416040cf: cc                         	int3

00000080416040d0 sched_yield:
; sched_yield(void) {
80416040d0: 55                         	pushq	%rbp
80416040d1: 48 89 e5                   	movq	%rsp, %rbp
;   if (curenv) {
80416040d4: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
80416040de: 48 83 38 00                	cmpq	$0, (%rax)
80416040e2: 74 11                      	je	17 <sched_yield+0x25>
;     id = ENVX(curenv_getid());
80416040e4: 48 b8 70 41 60 41 80 00 00 00      	movabsq	$550852641136, %rax
80416040ee: ff d0                      	callq	*%rax
80416040f0: 83 e0 1f                   	andl	$31, %eax
80416040f3: eb 05                      	jmp	5 <sched_yield+0x2a>
80416040f5: b8 ff ff ff ff             	movl	$4294967295, %eax
80416040fa: 48 b9 10 73 61 41 80 00 00 00      	movabsq	$550852719376, %rcx
8041604104: 48 8b 39                   	movq	(%rcx), %rdi
8041604107: 89 c1                      	movl	%eax, %ecx
8041604109: eb 09                      	jmp	9 <sched_yield+0x44>
804160410b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     if (envs[id].env_status == ENV_RUNNABLE || (id == orig && envs[id].env_status == ENV_RUNNING)) {
8041604110: 39 c1                      	cmpl	%eax, %ecx
;   } while (id != orig);
8041604112: 74 43                      	je	67 <sched_yield+0x87>
;     id = (id + 1) % NENV;    //id от 0 до NENV - количества процессов
8041604114: 8d 51 01                   	leal	1(%rcx), %edx
8041604117: 8d 71 20                   	leal	32(%rcx), %esi
804160411a: 85 d2                      	testl	%edx, %edx
804160411c: 0f 49 f2                   	cmovnsl	%edx, %esi
804160411f: 83 e6 e0                   	andl	$-32, %esi
8041604122: f7 de                      	negl	%esi
8041604124: 01 f1                      	addl	%esi, %ecx
8041604126: 83 c1 01                   	addl	$1, %ecx
;     if (envs[id].env_status == ENV_RUNNABLE || (id == orig && envs[id].env_status == ENV_RUNNING)) {
8041604129: 48 63 d1                   	movslq	%ecx, %rdx
804160412c: 48 69 d2 e0 00 00 00       	imulq	$224, %rdx, %rdx
8041604133: 8b b4 17 d4 00 00 00       	movl	212(%rdi,%rdx), %esi
804160413a: 83 fe 02                   	cmpl	$2, %esi
804160413d: 74 09                      	je	9 <sched_yield+0x78>
804160413f: 39 c1                      	cmpl	%eax, %ecx
8041604141: 75 cd                      	jne	-51 <sched_yield+0x40>
8041604143: 83 fe 03                   	cmpl	$3, %esi
8041604146: 75 c8                      	jne	-56 <sched_yield+0x40>
;       env_run(envs + id); 
8041604148: 48 01 d7                   	addq	%rdx, %rdi
804160414b: 48 b8 60 3d 60 41 80 00 00 00      	movabsq	$550852640096, %rax
8041604155: ff d0                      	callq	*%rax
;   sched_halt(); //остановка процессора если нет подходящих сред
8041604157: 48 b8 90 41 60 41 80 00 00 00      	movabsq	$550852641168, %rax
8041604161: ff d0                      	callq	*%rax
; }
8041604163: 5d                         	popq	%rbp
8041604164: c3                         	retq
8041604165: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160416f: 90                         	nop

0000008041604170 curenv_getid:
; curenv_getid(void) {
8041604170: 55                         	pushq	%rbp
8041604171: 48 89 e5                   	movq	%rsp, %rbp
;   return curenv->env_id;
8041604174: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
804160417e: 48 8b 00                   	movq	(%rax), %rax
8041604181: 8b 80 c8 00 00 00          	movl	200(%rax), %eax
8041604187: 5d                         	popq	%rbp
8041604188: c3                         	retq
8041604189: 0f 1f 80 00 00 00 00       	nopl	(%rax)

0000008041604190 sched_halt:
; sched_halt(void) {
8041604190: 55                         	pushq	%rbp
8041604191: 48 89 e5                   	movq	%rsp, %rbp
8041604194: 53                         	pushq	%rbx
8041604195: 50                         	pushq	%rax
8041604196: 48 b8 10 73 61 41 80 00 00 00      	movabsq	$550852719376, %rax
80416041a0: b9 d4 00 00 00             	movl	$212, %ecx
;   for (i = 0; i < NENV; i++) {
80416041a5: 48 03 08                   	addq	(%rax), %rcx
80416041a8: 31 c0                      	xorl	%eax, %eax
80416041aa: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
;     if ((envs[i].env_status == ENV_RUNNABLE ||
80416041b0: 8b 11                      	movl	(%rcx), %edx
80416041b2: 83 c2 ff                   	addl	$-1, %edx
80416041b5: 83 fa 03                   	cmpl	$3, %edx
80416041b8: 72 16                      	jb	22 <sched_halt+0x40>
;   for (i = 0; i < NENV; i++) {
80416041ba: 48 83 c0 01                	addq	$1, %rax
80416041be: 48 81 c1 e0 00 00 00       	addq	$224, %rcx
80416041c5: 48 83 f8 20                	cmpq	$32, %rax
80416041c9: 75 e5                      	jne	-27 <sched_halt+0x20>
80416041cb: b8 20 00 00 00             	movl	$32, %eax
;   if (i == NENV) {
80416041d0: 83 f8 20                   	cmpl	$32, %eax
80416041d3: 75 31                      	jne	49 <sched_halt+0x76>
;     cprintf("No runnable environments in the system!\n");
80416041d5: 48 bf 62 57 60 41 80 00 00 00      	movabsq	$550852646754, %rdi
80416041df: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
80416041e9: 31 c0                      	xorl	%eax, %eax
80416041eb: ff d1                      	callq	*%rcx
80416041ed: 48 bb c0 35 60 41 80 00 00 00      	movabsq	$550852638144, %rbx
80416041f7: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
;       monitor(NULL);
8041604200: 31 ff                      	xorl	%edi, %edi
8041604202: ff d3                      	callq	*%rbx
;     while (1)
8041604204: eb fa                      	jmp	-6 <sched_halt+0x70>
;   curenv = NULL;
8041604206: 48 b8 c0 15 62 41 80 00 00 00      	movabsq	$550852761024, %rax
8041604210: 48 c7 00 00 00 00 00       	movq	$0, (%rax)
8041604217: 48 b8 f0 35 62 41 80 00 00 00      	movabsq	$550852769264, %rax
;       : "a"(cpu_ts.ts_esp0));
8041604221: 48 8b 40 04                	movq	4(%rax), %rax
;   asm volatile(
8041604225: 48 c7 c5 00 00 00 00       	movq	$0, %rbp
804160422c: 48 89 c4                   	movq	%rax, %rsp
804160422f: 6a 00                      	pushq	$0
8041604231: 6a 00                      	pushq	$0
8041604233: fb                         	sti
8041604234: f4                         	hlt
; }
8041604235: 48 83 c4 08                	addq	$8, %rsp
8041604239: 5b                         	popq	%rbx
804160423a: 5d                         	popq	%rbp
804160423b: c3                         	retq
804160423c: cc                         	int3
804160423d: cc                         	int3
804160423e: cc                         	int3
804160423f: cc                         	int3

0000008041604240 load_kernel_dwarf_info:
; load_kernel_dwarf_info(struct Dwarf_Addrs *addrs) {
8041604240: 55                         	pushq	%rbp
8041604241: 48 89 e5                   	movq	%rsp, %rbp
;   addrs->aranges_begin  = (unsigned char *)(uefi_lp->DebugArangesStart);
8041604244: 48 b8 00 70 61 41 80 00 00 00      	movabsq	$550852718592, %rax
804160424e: 48 8b 08                   	movq	(%rax), %rcx
8041604251: 48 8b 51 58                	movq	88(%rcx), %rdx
8041604255: 48 89 57 10                	movq	%rdx, 16(%rdi)
;   addrs->aranges_end    = (unsigned char *)(uefi_lp->DebugArangesEnd);
8041604259: 48 8b 51 60                	movq	96(%rcx), %rdx
804160425d: 48 89 57 18                	movq	%rdx, 24(%rdi)
;   addrs->abbrev_begin   = (unsigned char *)(uefi_lp->DebugAbbrevStart);
8041604261: 48 8b 49 68                	movq	104(%rcx), %rcx
8041604265: 48 89 0f                   	movq	%rcx, (%rdi)
;   addrs->abbrev_end     = (unsigned char *)(uefi_lp->DebugAbbrevEnd);
8041604268: 48 8b 00                   	movq	(%rax), %rax
804160426b: 48 8b 48 70                	movq	112(%rax), %rcx
804160426f: 48 89 4f 08                	movq	%rcx, 8(%rdi)
;   addrs->info_begin     = (unsigned char *)(uefi_lp->DebugInfoStart);
8041604273: 48 8b 48 78                	movq	120(%rax), %rcx
8041604277: 48 89 4f 20                	movq	%rcx, 32(%rdi)
;   addrs->info_end       = (unsigned char *)(uefi_lp->DebugInfoEnd);
804160427b: 48 8b 88 80 00 00 00       	movq	128(%rax), %rcx
8041604282: 48 89 4f 28                	movq	%rcx, 40(%rdi)
;   addrs->line_begin     = (unsigned char *)(uefi_lp->DebugLineStart);
8041604286: 48 8b 88 88 00 00 00       	movq	136(%rax), %rcx
804160428d: 48 89 4f 30                	movq	%rcx, 48(%rdi)
;   addrs->line_end       = (unsigned char *)(uefi_lp->DebugLineEnd);
8041604291: 48 8b 88 90 00 00 00       	movq	144(%rax), %rcx
8041604298: 48 89 4f 38                	movq	%rcx, 56(%rdi)
;   addrs->str_begin      = (unsigned char *)(uefi_lp->DebugStrStart);
804160429c: 48 8b 88 98 00 00 00       	movq	152(%rax), %rcx
80416042a3: 48 89 4f 40                	movq	%rcx, 64(%rdi)
;   addrs->str_end        = (unsigned char *)(uefi_lp->DebugStrEnd);
80416042a7: 48 8b 88 a0 00 00 00       	movq	160(%rax), %rcx
80416042ae: 48 89 4f 48                	movq	%rcx, 72(%rdi)
;   addrs->pubnames_begin = (unsigned char *)(uefi_lp->DebugPubnamesStart);
80416042b2: 48 8b 88 a8 00 00 00       	movq	168(%rax), %rcx
80416042b9: 48 89 4f 50                	movq	%rcx, 80(%rdi)
;   addrs->pubnames_end   = (unsigned char *)(uefi_lp->DebugPubnamesEnd);
80416042bd: 48 8b 88 b0 00 00 00       	movq	176(%rax), %rcx
80416042c4: 48 89 4f 58                	movq	%rcx, 88(%rdi)
;   addrs->pubtypes_begin = (unsigned char *)(uefi_lp->DebugPubtypesStart);
80416042c8: 48 8b 88 b8 00 00 00       	movq	184(%rax), %rcx
80416042cf: 48 89 4f 60                	movq	%rcx, 96(%rdi)
;   addrs->pubtypes_end   = (unsigned char *)(uefi_lp->DebugPubtypesEnd);
80416042d3: 48 8b 80 c0 00 00 00       	movq	192(%rax), %rax
80416042da: 48 89 47 68                	movq	%rax, 104(%rdi)
; }
80416042de: 5d                         	popq	%rbp
80416042df: c3                         	retq

00000080416042e0 debuginfo_rip:
; debuginfo_rip(uintptr_t addr, struct Ripdebuginfo *info) {
80416042e0: 55                         	pushq	%rbp
80416042e1: 48 89 e5                   	movq	%rsp, %rbp
80416042e4: 41 57                      	pushq	%r15
80416042e6: 41 56                      	pushq	%r14
80416042e8: 41 55                      	pushq	%r13
80416042ea: 41 54                      	pushq	%r12
80416042ec: 53                         	pushq	%rbx
80416042ed: 48 81 ec 88 00 00 00       	subq	$136, %rsp
80416042f4: 49 89 f4                   	movq	%rsi, %r12
80416042f7: 49 89 ff                   	movq	%rdi, %r15
;   strcpy(info->rip_file, "<unknown>");
80416042fa: 48 bb c8 54 60 41 80 00 00 00      	movabsq	$550852646088, %rbx
8041604304: 49 bd 90 4f 60 41 80 00 00 00      	movabsq	$550852644752, %r13
804160430e: 48 89 f7                   	movq	%rsi, %rdi
8041604311: 48 89 de                   	movq	%rbx, %rsi
8041604314: 41 ff d5                   	callq	*%r13
;   info->rip_line = 0;
8041604317: 41 c7 84 24 00 01 00 00 00 00 00 00	movl	$0, 256(%r12)
;   strcpy(info->rip_fn_name, "<unknown>");
8041604323: 4d 8d b4 24 04 01 00 00    	leaq	260(%r12), %r14
804160432b: 4c 89 f7                   	movq	%r14, %rdi
804160432e: 48 89 de                   	movq	%rbx, %rsi
8041604331: 41 ff d5                   	callq	*%r13
;   info->rip_fn_namelen = 9;
8041604334: 41 c7 84 24 04 02 00 00 09 00 00 00	movl	$9, 516(%r12)
;   info->rip_fn_addr    = addr;
8041604340: 4d 89 bc 24 08 02 00 00    	movq	%r15, 520(%r12)
;   info->rip_fn_narg    = 0;
8041604348: 41 c7 84 24 10 02 00 00 00 00 00 00	movl	$0, 528(%r12)
;   if (!addr) {
8041604354: 4d 85 ff                   	testq	%r15, %r15
8041604357: 0f 84 2d 01 00 00          	je	301 <debuginfo_rip+0x1aa>
804160435d: 48 b8 00 00 c0 3e 80 00 00 00      	movabsq	$550808584192, %rax
;   if (addr <= ULIM) {
8041604367: 49 39 c7                   	cmpq	%rax, %r15
804160436a: 0f 86 34 01 00 00          	jbe	308 <debuginfo_rip+0x1c4>
;     load_kernel_dwarf_info(&addrs);
8041604370: 48 b8 40 42 60 41 80 00 00 00      	movabsq	$550852641344, %rax
804160437a: 48 8d 9d 50 ff ff ff       	leaq	-176(%rbp), %rbx
8041604381: 48 89 df                   	movq	%rbx, %rdi
8041604384: ff d0                      	callq	*%rax
;   Dwarf_Off offset = 0, line_offset = 0;
8041604386: 48 c7 45 c8 00 00 00 00    	movq	$0, -56(%rbp)
804160438e: 48 c7 45 c0 00 00 00 00    	movq	$0, -64(%rbp)
;   code = info_by_address(&addrs, addr, &offset);
8041604396: 48 b8 40 0c 60 41 80 00 00 00      	movabsq	$550852627520, %rax
80416043a0: 48 8d 55 c8                	leaq	-56(%rbp), %rdx
80416043a4: 48 89 df                   	movq	%rbx, %rdi
80416043a7: 4c 89 fe                   	movq	%r15, %rsi
80416043aa: ff d0                      	callq	*%rax
;   if (code < 0) {
80416043ac: 85 c0                      	testl	%eax, %eax
80416043ae: 0f 88 da 00 00 00          	js	218 <debuginfo_rip+0x1ae>
;   code = file_name_by_info(&addrs, offset, buf, sizeof(char *), &line_offset);
80416043b4: 48 8b 75 c8                	movq	-56(%rbp), %rsi
80416043b8: 48 b8 b0 12 60 41 80 00 00 00      	movabsq	$550852629168, %rax
80416043c2: 48 8d bd 50 ff ff ff       	leaq	-176(%rbp), %rdi
80416043c9: 48 8d 55 d0                	leaq	-48(%rbp), %rdx
80416043cd: 4c 8d 45 c0                	leaq	-64(%rbp), %r8
80416043d1: b9 08 00 00 00             	movl	$8, %ecx
80416043d6: ff d0                      	callq	*%rax
80416043d8: 89 c3                      	movl	%eax, %ebx
;   strncpy(info->rip_file, tmp_buf, 256);
80416043da: 48 8b 75 d0                	movq	-48(%rbp), %rsi
80416043de: 49 bd 00 50 60 41 80 00 00 00      	movabsq	$550852644864, %r13
80416043e8: ba 00 01 00 00             	movl	$256, %edx
80416043ed: 4c 89 e7                   	movq	%r12, %rdi
80416043f0: 41 ff d5                   	callq	*%r13
;   if (code < 0) {
80416043f3: 85 db                      	testl	%ebx, %ebx
80416043f5: 0f 88 95 00 00 00          	js	149 <debuginfo_rip+0x1b0>
80416043fb: 49 8d 8c 24 00 01 00 00    	leaq	256(%r12), %rcx
;   addr = addr - 5;
8041604403: 49 83 c7 fb                	addq	$-5, %r15
;   code = line_for_address(&addrs, addr, line_offset, buf);
8041604407: 48 8b 55 c0                	movq	-64(%rbp), %rdx
804160440b: 48 b8 10 2b 60 41 80 00 00 00      	movabsq	$550852635408, %rax
8041604415: 48 8d bd 50 ff ff ff       	leaq	-176(%rbp), %rdi
804160441c: 4c 89 fe                   	movq	%r15, %rsi
804160441f: ff d0                      	callq	*%rax
;   if (code < 0) {
8041604421: 85 c0                      	testl	%eax, %eax
8041604423: 78 69                      	js	105 <debuginfo_rip+0x1ae>
8041604425: 4d 8d 8c 24 08 02 00 00    	leaq	520(%r12), %r9
;   code = function_by_info(&addrs, addr, offset, buf, sizeof(char *), &info->rip_fn_addr);
804160442d: 48 8b 55 c8                	movq	-56(%rbp), %rdx
8041604431: 48 b8 e0 1b 60 41 80 00 00 00      	movabsq	$550852631520, %rax
804160443b: 48 8d bd 50 ff ff ff       	leaq	-176(%rbp), %rdi
8041604442: 48 8d 4d d0                	leaq	-48(%rbp), %rcx
8041604446: 4c 89 fe                   	movq	%r15, %rsi
8041604449: 41 b8 08 00 00 00          	movl	$8, %r8d
804160444f: ff d0                      	callq	*%rax
8041604451: 41 89 c7                   	movl	%eax, %r15d
;   strncpy(info->rip_fn_name, tmp_buf, 256);
8041604454: 48 8b 75 d0                	movq	-48(%rbp), %rsi
8041604458: ba 00 01 00 00             	movl	$256, %edx
804160445d: 4c 89 f7                   	movq	%r14, %rdi
8041604460: 41 ff d5                   	callq	*%r13
;   info->rip_fn_namelen = strnlen(info->rip_fn_name, 256);
8041604463: 48 b8 60 4f 60 41 80 00 00 00      	movabsq	$550852644704, %rax
804160446d: be 00 01 00 00             	movl	$256, %esi
8041604472: 4c 89 f7                   	movq	%r14, %rdi
8041604475: ff d0                      	callq	*%rax
8041604477: 41 89 84 24 04 02 00 00    	movl	%eax, 516(%r12)
804160447f: 44 89 fb                   	movl	%r15d, %ebx
8041604482: c1 fb 1f                   	sarl	$31, %ebx
8041604485: 44 21 fb                   	andl	%r15d, %ebx
8041604488: eb 06                      	jmp	6 <debuginfo_rip+0x1b0>
804160448a: 31 db                      	xorl	%ebx, %ebx
804160448c: eb 02                      	jmp	2 <debuginfo_rip+0x1b0>
804160448e: 89 c3                      	movl	%eax, %ebx
; }
8041604490: 89 d8                      	movl	%ebx, %eax
8041604492: 48 81 c4 88 00 00 00       	addq	$136, %rsp
8041604499: 5b                         	popq	%rbx
804160449a: 41 5c                      	popq	%r12
804160449c: 41 5d                      	popq	%r13
804160449e: 41 5e                      	popq	%r14
80416044a0: 41 5f                      	popq	%r15
80416044a2: 5d                         	popq	%rbp
80416044a3: c3                         	retq
;     panic("Can't search for user-level addresses yet!");
80416044a4: 48 bf a8 59 60 41 80 00 00 00      	movabsq	$550852647336, %rdi
80416044ae: 48 ba 1e 5b 60 41 80 00 00 00      	movabsq	$550852647710, %rdx
80416044b8: 48 b9 30 03 60 41 80 00 00 00      	movabsq	$550852625200, %rcx
80416044c2: be 36 00 00 00             	movl	$54, %esi
80416044c7: 31 c0                      	xorl	%eax, %eax
80416044c9: ff d1                      	callq	*%rcx
80416044cb: 0f 1f 44 00 00             	nopl	(%rax,%rax)

00000080416044d0 find_function:
; find_function(const char *const fname) {
80416044d0: 55                         	pushq	%rbp
80416044d1: 48 89 e5                   	movq	%rsp, %rbp
80416044d4: 41 57                      	pushq	%r15
80416044d6: 41 56                      	pushq	%r14
80416044d8: 41 54                      	pushq	%r12
80416044da: 53                         	pushq	%rbx
80416044db: 48 81 ec 80 00 00 00       	subq	$128, %rsp
80416044e2: 49 89 ff                   	movq	%rdi, %r15
80416044e5: 31 db                      	xorl	%ebx, %ebx
80416044e7: 49 be c0 63 60 41 80 00 00 00      	movabsq	$550852649920, %r14
80416044f1: 49 bc 40 51 60 41 80 00 00 00      	movabsq	$550852645184, %r12
80416044fb: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     if (!strcmp(scentry[i].name, fname)) {
8041604500: 4a 8b 3c 33                	movq	(%rbx,%r14), %rdi
8041604504: 4c 89 fe                   	movq	%r15, %rsi
8041604507: 41 ff d4                   	callq	*%r12
804160450a: 85 c0                      	testl	%eax, %eax
804160450c: 74 12                      	je	18 <find_function+0x50>
;   for (size_t i = 0; i < sizeof(scentry)/sizeof(*scentry); i++) {
804160450e: 48 83 c3 10                	addq	$16, %rbx
8041604512: 48 83 fb 20                	cmpq	$32, %rbx
8041604516: 75 e8                      	jne	-24 <find_function+0x30>
8041604518: b1 01                      	movb	$1, %cl
804160451a: 84 c9                      	testb	%cl, %cl
804160451c: 75 0d                      	jne	13 <find_function+0x5b>
804160451e: eb 72                      	jmp	114 <find_function+0xc2>
;       return scentry[i].addr;
8041604520: 49 8b 44 1e 08             	movq	8(%r14,%rbx), %rax
8041604525: 31 c9                      	xorl	%ecx, %ecx
8041604527: 84 c9                      	testb	%cl, %cl
8041604529: 74 67                      	je	103 <find_function+0xc2>
;   load_kernel_dwarf_info(&addrs);
804160452b: 48 b8 40 42 60 41 80 00 00 00      	movabsq	$550852641344, %rax
8041604535: 4c 8d b5 68 ff ff ff       	leaq	-152(%rbp), %r14
804160453c: 4c 89 f7                   	movq	%r14, %rdi
804160453f: ff d0                      	callq	*%rax
;   uintptr_t offset = 0;
8041604541: 48 c7 45 d8 00 00 00 00    	movq	$0, -40(%rbp)
;   if (!address_by_fname(&addrs, fname, &offset) && offset) {
8041604549: 48 b8 d0 20 60 41 80 00 00 00      	movabsq	$550852632784, %rax
8041604553: 48 8d 55 d8                	leaq	-40(%rbp), %rdx
8041604557: 4c 89 f7                   	movq	%r14, %rdi
804160455a: 4c 89 fe                   	movq	%r15, %rsi
804160455d: ff d0                      	callq	*%rax
804160455f: 85 c0                      	testl	%eax, %eax
8041604561: 75 09                      	jne	9 <find_function+0x9c>
8041604563: 48 8b 45 d8                	movq	-40(%rbp), %rax
8041604567: 48 85 c0                   	testq	%rax, %rax
804160456a: 75 26                      	jne	38 <find_function+0xc2>
;   if (!naive_address_by_fname(&addrs, fname, &offset)) {
804160456c: 48 b8 e0 25 60 41 80 00 00 00      	movabsq	$550852634080, %rax
8041604576: 48 8d bd 68 ff ff ff       	leaq	-152(%rbp), %rdi
804160457d: 48 8d 55 d8                	leaq	-40(%rbp), %rdx
8041604581: 4c 89 fe                   	movq	%r15, %rsi
8041604584: ff d0                      	callq	*%rax
8041604586: 85 c0                      	testl	%eax, %eax
8041604588: 75 06                      	jne	6 <find_function+0xc0>
804160458a: 48 8b 45 d8                	movq	-40(%rbp), %rax
804160458e: eb 02                      	jmp	2 <find_function+0xc2>
8041604590: 31 c0                      	xorl	%eax, %eax
; }
8041604592: 48 81 c4 80 00 00 00       	addq	$128, %rsp
8041604599: 5b                         	popq	%rbx
804160459a: 41 5c                      	popq	%r12
804160459c: 41 5e                      	popq	%r14
804160459e: 41 5f                      	popq	%r15
80416045a0: 5d                         	popq	%rbp
80416045a1: c3                         	retq
80416045a2: cc                         	int3
80416045a3: cc                         	int3
80416045a4: cc                         	int3
80416045a5: cc                         	int3
80416045a6: cc                         	int3
80416045a7: cc                         	int3
80416045a8: cc                         	int3
80416045a9: cc                         	int3
80416045aa: cc                         	int3
80416045ab: cc                         	int3
80416045ac: cc                         	int3
80416045ad: cc                         	int3
80416045ae: cc                         	int3
80416045af: cc                         	int3

00000080416045b0 vprintfmt:
; vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap) {
80416045b0: 55                         	pushq	%rbp
80416045b1: 48 89 e5                   	movq	%rsp, %rbp
80416045b4: 41 57                      	pushq	%r15
80416045b6: 41 56                      	pushq	%r14
80416045b8: 41 55                      	pushq	%r13
80416045ba: 41 54                      	pushq	%r12
80416045bc: 53                         	pushq	%rbx
80416045bd: 48 83 ec 38                	subq	$56, %rsp
80416045c1: 49 89 d7                   	movq	%rdx, %r15
80416045c4: 48 89 f3                   	movq	%rsi, %rbx
80416045c7: 49 89 fd                   	movq	%rdi, %r13
;   va_copy(aq, ap);
80416045ca: 48 8b 41 10                	movq	16(%rcx), %rax
80416045ce: 48 89 45 c0                	movq	%rax, -64(%rbp)
80416045d2: 0f 10 01                   	movups	(%rcx), %xmm0
80416045d5: 0f 29 45 b0                	movaps	%xmm0, -80(%rbp)
80416045d9: 49 bc e0 63 60 41 80 00 00 00      	movabsq	$550852649952, %r12
80416045e3: 48 89 75 d0                	movq	%rsi, -48(%rbp)
80416045e7: 48 89 7d c8                	movq	%rdi, -56(%rbp)
80416045eb: eb 4d                      	jmp	77 <vprintfmt+0x8a>
;         num  = getuint(&aq, lflag);
80416045ed: 48 8d 7d b0                	leaq	-80(%rbp), %rdi
80416045f1: 48 b8 d0 4b 60 41 80 00 00 00      	movabsq	$550852643792, %rax
80416045fb: 4c 89 c3                   	movq	%r8, %rbx
80416045fe: ff d0                      	callq	*%rax
8041604600: 49 89 d8                   	movq	%rbx, %r8
8041604603: 49 89 c4                   	movq	%rax, %r12
8041604606: b9 10 00 00 00             	movl	$16, %ecx
804160460b: 48 8b 5d d0                	movq	-48(%rbp), %rbx
804160460f: 4c 8b 6d c8                	movq	-56(%rbp), %r13
;         printnum(putch, putdat, num, base, width, padc);
8041604613: 45 0f b6 ce                	movzbl	%r14b, %r9d
8041604617: 4c 89 ef                   	movq	%r13, %rdi
804160461a: 48 89 de                   	movq	%rbx, %rsi
804160461d: 4c 89 e2                   	movq	%r12, %rdx
8041604620: 48 b8 40 4c 60 41 80 00 00 00      	movabsq	$550852643904, %rax
804160462a: ff d0                      	callq	*%rax
;         break;
804160462c: 49 83 c7 01                	addq	$1, %r15
8041604630: 49 bc e0 63 60 41 80 00 00 00      	movabsq	$550852649952, %r12
;     while ((ch = *(unsigned char *)fmt++) != '%') {
804160463a: 41 0f b6 3f                	movzbl	(%r15), %edi
804160463e: 49 83 c7 01                	addq	$1, %r15
8041604642: 83 ff 25                   	cmpl	$37, %edi
8041604645: 74 19                      	je	25 <vprintfmt+0xb0>
8041604647: 40 84 ff                   	testb	%dil, %dil
804160464a: 0f 84 6a 04 00 00          	je	1130 <vprintfmt+0x50a>
8041604650: 48 89 de                   	movq	%rbx, %rsi
8041604653: 41 ff d5                   	callq	*%r13
8041604656: eb e2                      	jmp	-30 <vprintfmt+0x8a>
8041604658: 0f 1f 84 00 00 00 00 00    	nopl	(%rax,%rax)
8041604660: 41 b6 20                   	movb	$32, %r14b
8041604663: 41 b8 ff ff ff ff          	movl	$4294967295, %r8d
8041604669: 31 f6                      	xorl	%esi, %esi
804160466b: 48 8b 45 c0                	movq	-64(%rbp), %rax
804160466f: 41 bd ff ff ff ff          	movl	$4294967295, %r13d
8041604675: c7 45 a8 00 00 00 00       	movl	$0, -88(%rbp)
;     switch (ch = *(unsigned char *)fmt++) {
804160467c: 49 8d 5f 01                	leaq	1(%r15), %rbx
8041604680: eb 1b                      	jmp	27 <vprintfmt+0xed>
8041604682: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160468c: 0f 1f 40 00                	nopl	(%rax)
8041604690: b1 30                      	movb	$48, %cl
8041604692: 49 83 c7 01                	addq	$1, %r15
8041604696: 48 83 c3 01                	addq	$1, %rbx
804160469a: 41 89 ce                   	movl	%ecx, %r14d
804160469d: 41 0f b6 0f                	movzbl	(%r15), %ecx
80416046a1: 8d 51 dd                   	leal	-35(%rcx), %edx
80416046a4: 80 fa 55                   	cmpb	$85, %dl
80416046a7: 0f 87 9d 00 00 00          	ja	157 <vprintfmt+0x19a>
80416046ad: 0f b6 f9                   	movzbl	%cl, %edi
80416046b0: 0f b6 d2                   	movzbl	%dl, %edx
80416046b3: 41 ff 24 d4                	jmpq	*(%r12,%rdx,8)
80416046b7: 45 31 ed                   	xorl	%r13d, %r13d
80416046ba: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
;           precision = precision * 10 + ch - '0';
80416046c0: 43 8d 4c ad 00             	leal	(%r13,%r13,4), %ecx
80416046c5: 44 8d 2c 4f                	leal	(%rdi,%rcx,2), %r13d
80416046c9: 41 83 c5 d0                	addl	$-48, %r13d
;           ch        = *fmt;
80416046cd: 41 0f be 7f 01             	movsbl	1(%r15), %edi
;           precision = precision * 10 + ch - '0';
80416046d2: 49 83 c7 01                	addq	$1, %r15
;           if (ch < '0' || ch > '9')
80416046d6: 8d 4f d0                   	leal	-48(%rdi), %ecx
80416046d9: 80 f9 09                   	cmpb	$9, %cl
80416046dc: 76 e2                      	jbe	-30 <vprintfmt+0x110>
;         if (width < 0)
80416046de: 45 85 c0                   	testl	%r8d, %r8d
80416046e1: 45 0f 48 c5                	cmovsl	%r13d, %r8d
80416046e5: b9 ff ff ff ff             	movl	$4294967295, %ecx
80416046ea: 44 0f 48 e9                	cmovsl	%ecx, %r13d
80416046ee: eb 8c                      	jmp	-116 <vprintfmt+0xcc>
;     switch (ch = *(unsigned char *)fmt++) {
80416046f0: 49 83 c7 01                	addq	$1, %r15
80416046f4: c7 45 a8 01 00 00 00       	movl	$1, -88(%rbp)
80416046fb: e9 7c ff ff ff             	jmp	-132 <vprintfmt+0xcc>
;         precision = va_arg(aq, int);
8041604700: 48 63 4d b0                	movslq	-80(%rbp), %rcx
8041604704: 49 83 c7 01                	addq	$1, %r15
8041604708: 48 83 f9 28                	cmpq	$40, %rcx
804160470c: 77 2b                      	ja	43 <vprintfmt+0x189>
804160470e: 48 89 ca                   	movq	%rcx, %rdx
8041604711: 48 01 c2                   	addq	%rax, %rdx
8041604714: 83 c1 08                   	addl	$8, %ecx
8041604717: 89 4d b0                   	movl	%ecx, -80(%rbp)
804160471a: 44 8b 2a                   	movl	(%rdx), %r13d
804160471d: eb bf                      	jmp	-65 <vprintfmt+0x12e>
;         if (width < 0)
804160471f: 45 85 c0                   	testl	%r8d, %r8d
8041604722: b9 00 00 00 00             	movl	$0, %ecx
8041604727: 44 0f 48 c1                	cmovsl	%ecx, %r8d
804160472b: eb 03                      	jmp	3 <vprintfmt+0x180>
;         lflag++;
804160472d: 83 c6 01                   	addl	$1, %esi
8041604730: 49 83 c7 01                	addq	$1, %r15
8041604734: e9 43 ff ff ff             	jmp	-189 <vprintfmt+0xcc>
;         precision = va_arg(aq, int);
8041604739: 48 8b 4d b8                	movq	-72(%rbp), %rcx
804160473d: 48 8d 51 08                	leaq	8(%rcx), %rdx
8041604741: 48 89 55 b8                	movq	%rdx, -72(%rbp)
8041604745: 44 8b 29                   	movl	(%rcx), %r13d
8041604748: eb 94                      	jmp	-108 <vprintfmt+0x12e>
;         putch('%', putdat);
804160474a: bf 25 00 00 00             	movl	$37, %edi
804160474f: 4c 8b 75 d0                	movq	-48(%rbp), %r14
8041604753: 4c 89 f6                   	movq	%r14, %rsi
8041604756: 4c 8b 6d c8                	movq	-56(%rbp), %r13
804160475a: 41 ff d5                   	callq	*%r13
804160475d: 49 89 df                   	movq	%rbx, %r15
8041604760: 4c 89 f3                   	movq	%r14, %rbx
8041604763: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160476d: 0f 1f 00                   	nopl	(%rax)
;         for (fmt--; fmt[-1] != '%'; fmt--)
8041604770: 41 80 7f fe 25             	cmpb	$37, -2(%r15)
8041604775: 4d 8d 7f ff                	leaq	-1(%r15), %r15
8041604779: 75 f5                      	jne	-11 <vprintfmt+0x1c0>
804160477b: e9 ba fe ff ff             	jmp	-326 <vprintfmt+0x8a>
8041604780: 48 8b 5d d0                	movq	-48(%rbp), %rbx
;         putch(ch, putdat);
8041604784: 48 89 de                   	movq	%rbx, %rsi
8041604787: 4c 8b 6d c8                	movq	-56(%rbp), %r13
804160478b: 41 ff d5                   	callq	*%r13
;         break;
804160478e: 49 83 c7 01                	addq	$1, %r15
8041604792: e9 a3 fe ff ff             	jmp	-349 <vprintfmt+0x8a>
;         putch(va_arg(aq, int), putdat);
8041604797: 48 63 4d b0                	movslq	-80(%rbp), %rcx
804160479b: 48 83 f9 28                	cmpq	$40, %rcx
804160479f: 0f 87 11 01 00 00          	ja	273 <vprintfmt+0x306>
80416047a5: 48 89 c8                   	movq	%rcx, %rax
80416047a8: 48 03 45 c0                	addq	-64(%rbp), %rax
80416047ac: 83 c1 08                   	addl	$8, %ecx
80416047af: 89 4d b0                   	movl	%ecx, -80(%rbp)
80416047b2: e9 0b 01 00 00             	jmp	267 <vprintfmt+0x312>
80416047b7: 4c 89 c3                   	movq	%r8, %rbx
;         num = getint(&aq, lflag);
80416047ba: 48 8d 7d b0                	leaq	-80(%rbp), %rdi
80416047be: 48 b8 60 4b 60 41 80 00 00 00      	movabsq	$550852643680, %rax
80416047c8: ff d0                      	callq	*%rax
80416047ca: 49 89 c4                   	movq	%rax, %r12
80416047cd: b9 0a 00 00 00             	movl	$10, %ecx
;         if ((long long)num < 0) {
80416047d2: 48 85 c0                   	testq	%rax, %rax
80416047d5: 0f 88 d8 01 00 00          	js	472 <vprintfmt+0x403>
80416047db: 48 8b 45 d0                	movq	-48(%rbp), %rax
80416047df: 4c 8b 6d c8                	movq	-56(%rbp), %r13
80416047e3: 49 89 d8                   	movq	%rbx, %r8
80416047e6: 48 89 c3                   	movq	%rax, %rbx
80416047e9: e9 25 fe ff ff             	jmp	-475 <vprintfmt+0x63>
;         err = va_arg(aq, int);
80416047ee: 48 63 4d b0                	movslq	-80(%rbp), %rcx
80416047f2: 48 83 f9 28                	cmpq	$40, %rcx
80416047f6: 0f 87 d9 00 00 00          	ja	217 <vprintfmt+0x325>
80416047fc: 48 89 c8                   	movq	%rcx, %rax
80416047ff: 48 03 45 c0                	addq	-64(%rbp), %rax
8041604803: 83 c1 08                   	addl	$8, %ecx
8041604806: 89 4d b0                   	movl	%ecx, -80(%rbp)
8041604809: e9 d3 00 00 00             	jmp	211 <vprintfmt+0x331>
;         num = getuint(&aq, lflag);
804160480e: 48 8d 7d b0                	leaq	-80(%rbp), %rdi
8041604812: 48 b8 d0 4b 60 41 80 00 00 00      	movabsq	$550852643792, %rax
804160481c: 4c 89 c3                   	movq	%r8, %rbx
804160481f: ff d0                      	callq	*%rax
8041604821: 49 89 d8                   	movq	%rbx, %r8
8041604824: 49 89 c4                   	movq	%rax, %r12
8041604827: b9 08 00 00 00             	movl	$8, %ecx
804160482c: e9 da fd ff ff             	jmp	-550 <vprintfmt+0x5b>
8041604831: 4c 89 45 a8                	movq	%r8, -88(%rbp)
;         putch('0', putdat);
8041604835: bf 30 00 00 00             	movl	$48, %edi
804160483a: 48 8b 5d d0                	movq	-48(%rbp), %rbx
804160483e: 48 89 de                   	movq	%rbx, %rsi
8041604841: 4c 8b 6d c8                	movq	-56(%rbp), %r13
8041604845: 41 ff d5                   	callq	*%r13
;         putch('x', putdat);
8041604848: bf 78 00 00 00             	movl	$120, %edi
804160484d: 48 89 de                   	movq	%rbx, %rsi
8041604850: 41 ff d5                   	callq	*%r13
;         num  = (unsigned long long)(uintptr_t)va_arg(aq, void *);
8041604853: 48 63 4d b0                	movslq	-80(%rbp), %rcx
8041604857: 48 83 f9 28                	cmpq	$40, %rcx
804160485b: 0f 87 fd 00 00 00          	ja	253 <vprintfmt+0x3ae>
8041604861: 48 89 c8                   	movq	%rcx, %rax
8041604864: 48 03 45 c0                	addq	-64(%rbp), %rax
8041604868: 83 c1 08                   	addl	$8, %ecx
804160486b: 89 4d b0                   	movl	%ecx, -80(%rbp)
804160486e: e9 f7 00 00 00             	jmp	247 <vprintfmt+0x3ba>
;         if ((p = va_arg(aq, char *)) == NULL)
8041604873: 48 63 4d b0                	movslq	-80(%rbp), %rcx
8041604877: 48 83 f9 28                	cmpq	$40, %rcx
804160487b: 0f 87 fe 00 00 00          	ja	254 <vprintfmt+0x3cf>
8041604881: 48 89 c8                   	movq	%rcx, %rax
8041604884: 48 03 45 c0                	addq	-64(%rbp), %rax
8041604888: 83 c1 08                   	addl	$8, %ecx
804160488b: 89 4d b0                   	movl	%ecx, -80(%rbp)
804160488e: e9 f8 00 00 00             	jmp	248 <vprintfmt+0x3db>
;         num  = getuint(&aq, lflag);
8041604893: 48 8d 7d b0                	leaq	-80(%rbp), %rdi
8041604897: 48 b8 d0 4b 60 41 80 00 00 00      	movabsq	$550852643792, %rax
80416048a1: 4c 89 c3                   	movq	%r8, %rbx
80416048a4: ff d0                      	callq	*%rax
80416048a6: 49 89 d8                   	movq	%rbx, %r8
80416048a9: 49 89 c4                   	movq	%rax, %r12
80416048ac: b9 0a 00 00 00             	movl	$10, %ecx
80416048b1: e9 55 fd ff ff             	jmp	-683 <vprintfmt+0x5b>
;         putch(va_arg(aq, int), putdat);
80416048b6: 48 8b 45 b8                	movq	-72(%rbp), %rax
80416048ba: 48 8d 48 08                	leaq	8(%rax), %rcx
80416048be: 48 89 4d b8                	movq	%rcx, -72(%rbp)
80416048c2: 48 8b 5d d0                	movq	-48(%rbp), %rbx
80416048c6: 4c 8b 6d c8                	movq	-56(%rbp), %r13
80416048ca: 49 83 c7 01                	addq	$1, %r15
80416048ce: 8b 38                      	movl	(%rax), %edi
80416048d0: e9 7b fd ff ff             	jmp	-645 <vprintfmt+0xa0>
;         err = va_arg(aq, int);
80416048d5: 48 8b 45 b8                	movq	-72(%rbp), %rax
80416048d9: 48 8d 48 08                	leaq	8(%rax), %rcx
80416048dd: 48 89 4d b8                	movq	%rcx, -72(%rbp)
80416048e1: 48 8b 75 d0                	movq	-48(%rbp), %rsi
80416048e5: 49 83 c7 01                	addq	$1, %r15
80416048e9: 8b 00                      	movl	(%rax), %eax
;         if (err < 0)
80416048eb: 89 c1                      	movl	%eax, %ecx
80416048ed: f7 d9                      	negl	%ecx
80416048ef: 0f 4c c8                   	cmovll	%eax, %ecx
;         if (err >= MAXERROR || (p = error_string[err]) == NULL)
80416048f2: 83 f9 08                   	cmpl	$8, %ecx
80416048f5: 4c 8b 6d c8                	movq	-56(%rbp), %r13
80416048f9: 7f 3d                      	jg	61 <vprintfmt+0x388>
80416048fb: 89 c8                      	movl	%ecx, %eax
80416048fd: a9 f7 ff ff 7f             	testl	$2147483639, %eax
8041604902: 74 34                      	je	52 <vprintfmt+0x388>
8041604904: 48 b9 90 66 60 41 80 00 00 00      	movabsq	$550852650640, %rcx
804160490e: 48 8b 0c c1                	movq	(%rcx,%rax,8), %rcx
;           printfmt(putch, putdat, "%s", p);
8041604912: 4c 89 ef                   	movq	%r13, %rdi
8041604915: 48 ba b2 55 60 41 80 00 00 00      	movabsq	$550852646322, %rdx
804160491f: 31 c0                      	xorl	%eax, %eax
8041604921: 49 89 f6                   	movq	%rsi, %r14
8041604924: 48 bb d0 4a 60 41 80 00 00 00      	movabsq	$550852643536, %rbx
804160492e: ff d3                      	callq	*%rbx
8041604930: 4c 89 f3                   	movq	%r14, %rbx
8041604933: e9 02 fd ff ff             	jmp	-766 <vprintfmt+0x8a>
;           printfmt(putch, putdat, "error %d", err);
8041604938: 4c 89 ef                   	movq	%r13, %rdi
804160493b: 48 ba ed 57 60 41 80 00 00 00      	movabsq	$550852646893, %rdx
8041604945: 31 c0                      	xorl	%eax, %eax
8041604947: 49 89 f6                   	movq	%rsi, %r14
804160494a: 48 bb d0 4a 60 41 80 00 00 00      	movabsq	$550852643536, %rbx
8041604954: ff d3                      	callq	*%rbx
8041604956: 4c 89 f3                   	movq	%r14, %rbx
8041604959: e9 dc fc ff ff             	jmp	-804 <vprintfmt+0x8a>
;         num  = (unsigned long long)(uintptr_t)va_arg(aq, void *);
804160495e: 48 8b 45 b8                	movq	-72(%rbp), %rax
8041604962: 48 8d 48 08                	leaq	8(%rax), %rcx
8041604966: 48 89 4d b8                	movq	%rcx, -72(%rbp)
804160496a: 4c 8b 20                   	movq	(%rax), %r12
804160496d: b9 10 00 00 00             	movl	$16, %ecx
8041604972: 4c 8b 45 a8                	movq	-88(%rbp), %r8
8041604976: 48 8b 5d d0                	movq	-48(%rbp), %rbx
804160497a: e9 94 fc ff ff             	jmp	-876 <vprintfmt+0x63>
;         if ((p = va_arg(aq, char *)) == NULL)
804160497f: 48 8b 45 b8                	movq	-72(%rbp), %rax
8041604983: 48 8d 48 08                	leaq	8(%rax), %rcx
8041604987: 48 89 4d b8                	movq	%rcx, -72(%rbp)
804160498b: 48 8b 5d d0                	movq	-48(%rbp), %rbx
804160498f: 4c 8b 20                   	movq	(%rax), %r12
8041604992: 4d 85 e4                   	testq	%r12, %r12
8041604995: 48 b8 77 59 60 41 80 00 00 00      	movabsq	$550852647287, %rax
804160499f: 4c 0f 44 e0                	cmoveq	%rax, %r12
;         if (width > 0 && padc != '-')
80416049a3: 45 85 c0                   	testl	%r8d, %r8d
80416049a6: 7e 06                      	jle	6 <vprintfmt+0x3fe>
80416049a8: 41 80 fe 2d                	cmpb	$45, %r14b
80416049ac: 75 29                      	jne	41 <vprintfmt+0x427>
80416049ae: 45 89 c6                   	movl	%r8d, %r14d
80416049b1: eb 72                      	jmp	114 <vprintfmt+0x475>
;           putch('-', putdat);
80416049b3: bf 2d 00 00 00             	movl	$45, %edi
80416049b8: 48 8b 75 d0                	movq	-48(%rbp), %rsi
80416049bc: 4c 8b 6d c8                	movq	-56(%rbp), %r13
80416049c0: 41 ff d5                   	callq	*%r13
80416049c3: b9 0a 00 00 00             	movl	$10, %ecx
;           num = -(long long)num;
80416049c8: 49 f7 dc                   	negq	%r12
80416049cb: 49 89 d8                   	movq	%rbx, %r8
80416049ce: 48 8b 5d d0                	movq	-48(%rbp), %rbx
80416049d2: e9 3c fc ff ff             	jmp	-964 <vprintfmt+0x63>
;           for (width -= strnlen(p, precision); width > 0; width--)
80416049d7: 49 63 f5                   	movslq	%r13d, %rsi
80416049da: 4c 89 e7                   	movq	%r12, %rdi
80416049dd: 48 b8 60 4f 60 41 80 00 00 00      	movabsq	$550852644704, %rax
80416049e7: 4c 89 c3                   	movq	%r8, %rbx
80416049ea: ff d0                      	callq	*%rax
80416049ec: 48 89 d9                   	movq	%rbx, %rcx
80416049ef: 29 c1                      	subl	%eax, %ecx
80416049f1: 7e 2b                      	jle	43 <vprintfmt+0x46e>
80416049f3: 41 0f b6 c6                	movzbl	%r14b, %eax
80416049f7: 89 45 a4                   	movl	%eax, -92(%rbp)
80416049fa: 48 8b 5d d0                	movq	-48(%rbp), %rbx
80416049fe: 66 90                      	nop
8041604a00: 8b 7d a4                   	movl	-92(%rbp), %edi
;             putch(padc, putdat);
8041604a03: 48 89 de                   	movq	%rbx, %rsi
8041604a06: 48 89 cb                   	movq	%rcx, %rbx
8041604a09: ff 55 c8                   	callq	*-56(%rbp)
;           for (width -= strnlen(p, precision); width > 0; width--)
8041604a0c: 44 8d 73 ff                	leal	-1(%rbx), %r14d
8041604a10: 83 fb 01                   	cmpl	$1, %ebx
8041604a13: 48 8b 5d d0                	movq	-48(%rbp), %rbx
8041604a17: 44 89 f1                   	movl	%r14d, %ecx
8041604a1a: 7f e4                      	jg	-28 <vprintfmt+0x450>
8041604a1c: eb 07                      	jmp	7 <vprintfmt+0x475>
8041604a1e: 41 89 ce                   	movl	%ecx, %r14d
8041604a21: 48 8b 5d d0                	movq	-48(%rbp), %rbx
;         for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
8041604a25: 41 8a 04 24                	movb	(%r12), %al
8041604a29: 84 c0                      	testb	%al, %al
8041604a2b: 74 4f                      	je	79 <vprintfmt+0x4cc>
8041604a2d: 49 83 c4 01                	addq	$1, %r12
8041604a31: eb 3e                      	jmp	62 <vprintfmt+0x4c1>
8041604a33: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041604a3d: 0f 1f 00                   	nopl	(%rax)
8041604a40: 0f be c0                   	movsbl	%al, %eax
;           if (altflag && (ch < ' ' || ch > '~'))
8041604a43: 8d 48 e0                   	leal	-32(%rax), %ecx
8041604a46: 80 f9 5e                   	cmpb	$94, %cl
8041604a49: 89 c7                      	movl	%eax, %edi
8041604a4b: b9 3f 00 00 00             	movl	$63, %ecx
8041604a50: 0f 47 f9                   	cmoval	%ecx, %edi
8041604a53: 83 7d a8 00                	cmpl	$0, -88(%rbp)
8041604a57: 0f 44 f8                   	cmovel	%eax, %edi
8041604a5a: 48 89 de                   	movq	%rbx, %rsi
8041604a5d: ff 55 c8                   	callq	*-56(%rbp)
;         for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
8041604a60: 41 83 c6 ff                	addl	$-1, %r14d
8041604a64: 41 0f b6 04 24             	movzbl	(%r12), %eax
8041604a69: 49 83 c4 01                	addq	$1, %r12
8041604a6d: 84 c0                      	testb	%al, %al
8041604a6f: 74 0b                      	je	11 <vprintfmt+0x4cc>
8041604a71: 45 85 ed                   	testl	%r13d, %r13d
8041604a74: 78 ca                      	js	-54 <vprintfmt+0x490>
8041604a76: 41 83 ed 01                	subl	$1, %r13d
8041604a7a: 73 c4                      	jae	-60 <vprintfmt+0x490>
8041604a7c: 49 83 c7 01                	addq	$1, %r15
;         for (; width > 0; width--)
8041604a80: 45 85 f6                   	testl	%r14d, %r14d
8041604a83: 4c 8b 6d c8                	movq	-56(%rbp), %r13
8041604a87: 49 bc e0 63 60 41 80 00 00 00      	movabsq	$550852649952, %r12
8041604a91: 0f 8e a3 fb ff ff          	jle	-1117 <vprintfmt+0x8a>
;   while (1) {
8041604a97: 41 83 c6 01                	addl	$1, %r14d
8041604a9b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;           putch(' ', putdat);
8041604aa0: bf 20 00 00 00             	movl	$32, %edi
8041604aa5: 48 89 de                   	movq	%rbx, %rsi
8041604aa8: 41 ff d5                   	callq	*%r13
;         for (; width > 0; width--)
8041604aab: 41 83 c6 ff                	addl	$-1, %r14d
8041604aaf: 41 83 fe 01                	cmpl	$1, %r14d
8041604ab3: 7f eb                      	jg	-21 <vprintfmt+0x4f0>
8041604ab5: e9 80 fb ff ff             	jmp	-1152 <vprintfmt+0x8a>
; }
8041604aba: 48 83 c4 38                	addq	$56, %rsp
8041604abe: 5b                         	popq	%rbx
8041604abf: 41 5c                      	popq	%r12
8041604ac1: 41 5d                      	popq	%r13
8041604ac3: 41 5e                      	popq	%r14
8041604ac5: 41 5f                      	popq	%r15
8041604ac7: 5d                         	popq	%rbp
8041604ac8: c3                         	retq
8041604ac9: 0f 1f 80 00 00 00 00       	nopl	(%rax)

0000008041604ad0 printfmt:
; printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
8041604ad0: 55                         	pushq	%rbp
8041604ad1: 48 89 e5                   	movq	%rsp, %rbp
8041604ad4: 48 81 ec d0 00 00 00       	subq	$208, %rsp
8041604adb: 84 c0                      	testb	%al, %al
8041604add: 74 26                      	je	38 <printfmt+0x35>
8041604adf: 0f 29 85 60 ff ff ff       	movaps	%xmm0, -160(%rbp)
8041604ae6: 0f 29 8d 70 ff ff ff       	movaps	%xmm1, -144(%rbp)
8041604aed: 0f 29 55 80                	movaps	%xmm2, -128(%rbp)
8041604af1: 0f 29 5d 90                	movaps	%xmm3, -112(%rbp)
8041604af5: 0f 29 65 a0                	movaps	%xmm4, -96(%rbp)
8041604af9: 0f 29 6d b0                	movaps	%xmm5, -80(%rbp)
8041604afd: 0f 29 75 c0                	movaps	%xmm6, -64(%rbp)
8041604b01: 0f 29 7d d0                	movaps	%xmm7, -48(%rbp)
8041604b05: 48 89 8d 48 ff ff ff       	movq	%rcx, -184(%rbp)
8041604b0c: 4c 89 85 50 ff ff ff       	movq	%r8, -176(%rbp)
8041604b13: 4c 89 8d 58 ff ff ff       	movq	%r9, -168(%rbp)
8041604b1a: 48 8d 85 30 ff ff ff       	leaq	-208(%rbp), %rax
;   va_start(ap, fmt);
8041604b21: 48 89 45 f0                	movq	%rax, -16(%rbp)
8041604b25: 48 8d 45 10                	leaq	16(%rbp), %rax
8041604b29: 48 89 45 e8                	movq	%rax, -24(%rbp)
8041604b2d: 48 b8 18 00 00 00 30 00 00 00      	movabsq	$206158430232, %rax
8041604b37: 48 89 45 e0                	movq	%rax, -32(%rbp)
;   vprintfmt(putch, putdat, fmt, ap);
8041604b3b: 48 b8 b0 45 60 41 80 00 00 00      	movabsq	$550852642224, %rax
8041604b45: 48 8d 4d e0                	leaq	-32(%rbp), %rcx
8041604b49: ff d0                      	callq	*%rax
; }
8041604b4b: 48 81 c4 d0 00 00 00       	addq	$208, %rsp
8041604b52: 5d                         	popq	%rbp
8041604b53: c3                         	retq
8041604b54: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041604b5e: 66 90                      	nop

0000008041604b60 getint:
; getint(va_list *ap, int lflag) {
8041604b60: 55                         	pushq	%rbp
8041604b61: 48 89 e5                   	movq	%rsp, %rbp
;   if (lflag >= 2)
8041604b64: 83 fe 02                   	cmpl	$2, %esi
8041604b67: 7c 12                      	jl	18 <getint+0x1b>
;     return va_arg(*ap, long long);
8041604b69: 48 63 07                   	movslq	(%rdi), %rax
8041604b6c: 48 83 f8 28                	cmpq	$40, %rax
8041604b70: 77 26                      	ja	38 <getint+0x38>
8041604b72: 48 89 c1                   	movq	%rax, %rcx
8041604b75: 48 03 4f 10                	addq	16(%rdi), %rcx
8041604b79: eb 13                      	jmp	19 <getint+0x2e>
8041604b7b: 48 63 07                   	movslq	(%rdi), %rax
;   else if (lflag)
8041604b7e: 85 f6                      	testl	%esi, %esi
8041604b80: 74 27                      	je	39 <getint+0x49>
8041604b82: 83 f8 28                   	cmpl	$40, %eax
;     return va_arg(*ap, long);
8041604b85: 77 11                      	ja	17 <getint+0x38>
8041604b87: 48 8b 4f 10                	movq	16(%rdi), %rcx
8041604b8b: 48 01 c1                   	addq	%rax, %rcx
8041604b8e: 83 c0 08                   	addl	$8, %eax
8041604b91: 89 07                      	movl	%eax, (%rdi)
8041604b93: 48 8b 01                   	movq	(%rcx), %rax
; }
8041604b96: 5d                         	popq	%rbp
8041604b97: c3                         	retq
8041604b98: 48 8b 47 08                	movq	8(%rdi), %rax
8041604b9c: 48 8d 48 08                	leaq	8(%rax), %rcx
8041604ba0: 48 89 4f 08                	movq	%rcx, 8(%rdi)
8041604ba4: 48 8b 00                   	movq	(%rax), %rax
8041604ba7: 5d                         	popq	%rbp
8041604ba8: c3                         	retq
8041604ba9: 83 f8 28                   	cmpl	$40, %eax
;     return va_arg(*ap, int);
8041604bac: 77 0e                      	ja	14 <getint+0x5c>
8041604bae: 48 89 c1                   	movq	%rax, %rcx
8041604bb1: 48 03 4f 10                	addq	16(%rdi), %rcx
8041604bb5: 83 c0 08                   	addl	$8, %eax
8041604bb8: 89 07                      	movl	%eax, (%rdi)
8041604bba: eb 0c                      	jmp	12 <getint+0x68>
8041604bbc: 48 8b 4f 08                	movq	8(%rdi), %rcx
8041604bc0: 48 8d 41 08                	leaq	8(%rcx), %rax
8041604bc4: 48 89 47 08                	movq	%rax, 8(%rdi)
8041604bc8: 48 63 01                   	movslq	(%rcx), %rax
; }
8041604bcb: 5d                         	popq	%rbp
8041604bcc: c3                         	retq
8041604bcd: 0f 1f 00                   	nopl	(%rax)

0000008041604bd0 getuint:
; getuint(va_list *ap, int lflag) {
8041604bd0: 55                         	pushq	%rbp
8041604bd1: 48 89 e5                   	movq	%rsp, %rbp
;   if (lflag >= 2)
8041604bd4: 83 fe 02                   	cmpl	$2, %esi
8041604bd7: 7c 12                      	jl	18 <getuint+0x1b>
;     return va_arg(*ap, unsigned long long);
8041604bd9: 48 63 07                   	movslq	(%rdi), %rax
8041604bdc: 48 83 f8 28                	cmpq	$40, %rax
8041604be0: 77 26                      	ja	38 <getuint+0x38>
8041604be2: 48 89 c1                   	movq	%rax, %rcx
8041604be5: 48 03 4f 10                	addq	16(%rdi), %rcx
8041604be9: eb 13                      	jmp	19 <getuint+0x2e>
8041604beb: 48 63 07                   	movslq	(%rdi), %rax
;   else if (lflag)
8041604bee: 85 f6                      	testl	%esi, %esi
8041604bf0: 74 27                      	je	39 <getuint+0x49>
8041604bf2: 83 f8 28                   	cmpl	$40, %eax
;     return va_arg(*ap, unsigned long);
8041604bf5: 77 11                      	ja	17 <getuint+0x38>
8041604bf7: 48 8b 4f 10                	movq	16(%rdi), %rcx
8041604bfb: 48 01 c1                   	addq	%rax, %rcx
8041604bfe: 83 c0 08                   	addl	$8, %eax
8041604c01: 89 07                      	movl	%eax, (%rdi)
8041604c03: 48 8b 01                   	movq	(%rcx), %rax
; }
8041604c06: 5d                         	popq	%rbp
8041604c07: c3                         	retq
8041604c08: 48 8b 47 08                	movq	8(%rdi), %rax
8041604c0c: 48 8d 48 08                	leaq	8(%rax), %rcx
8041604c10: 48 89 4f 08                	movq	%rcx, 8(%rdi)
8041604c14: 48 8b 00                   	movq	(%rax), %rax
8041604c17: 5d                         	popq	%rbp
8041604c18: c3                         	retq
8041604c19: 83 f8 28                   	cmpl	$40, %eax
;     return va_arg(*ap, unsigned int);
8041604c1c: 77 0e                      	ja	14 <getuint+0x5c>
8041604c1e: 48 89 c1                   	movq	%rax, %rcx
8041604c21: 48 03 4f 10                	addq	16(%rdi), %rcx
8041604c25: 83 c0 08                   	addl	$8, %eax
8041604c28: 89 07                      	movl	%eax, (%rdi)
8041604c2a: eb 0c                      	jmp	12 <getuint+0x68>
8041604c2c: 48 8b 4f 08                	movq	8(%rdi), %rcx
8041604c30: 48 8d 41 08                	leaq	8(%rcx), %rax
8041604c34: 48 89 47 08                	movq	%rax, 8(%rdi)
8041604c38: 8b 01                      	movl	(%rcx), %eax
; }
8041604c3a: 5d                         	popq	%rbp
8041604c3b: c3                         	retq
8041604c3c: 0f 1f 40 00                	nopl	(%rax)

0000008041604c40 printnum:
;          unsigned long long num, unsigned base, int width, int padc) {
8041604c40: 55                         	pushq	%rbp
8041604c41: 48 89 e5                   	movq	%rsp, %rbp
8041604c44: 41 57                      	pushq	%r15
8041604c46: 41 56                      	pushq	%r14
8041604c48: 41 55                      	pushq	%r13
8041604c4a: 41 54                      	pushq	%r12
8041604c4c: 53                         	pushq	%rbx
8041604c4d: 50                         	pushq	%rax
8041604c4e: 45 89 cd                   	movl	%r9d, %r13d
8041604c51: 44 89 c3                   	movl	%r8d, %ebx
8041604c54: 49 89 f6                   	movq	%rsi, %r14
8041604c57: 49 89 fc                   	movq	%rdi, %r12
;   if (num >= base) {
8041604c5a: 41 89 cf                   	movl	%ecx, %r15d
8041604c5d: 49 39 d7                   	cmpq	%rdx, %r15
8041604c60: 48 89 55 d0                	movq	%rdx, -48(%rbp)
8041604c64: 76 1d                      	jbe	29 <printnum+0x43>
;     while (--width > 0)
8041604c66: 83 fb 02                   	cmpl	$2, %ebx
8041604c69: 7c 3f                      	jl	63 <printnum+0x6a>
8041604c6b: 83 c3 01                   	addl	$1, %ebx
8041604c6e: 66 90                      	nop
;       putch(padc, putdat);
8041604c70: 44 89 ef                   	movl	%r13d, %edi
8041604c73: 4c 89 f6                   	movq	%r14, %rsi
8041604c76: 41 ff d4                   	callq	*%r12
;     while (--width > 0)
8041604c79: 83 c3 ff                   	addl	$-1, %ebx
8041604c7c: 83 fb 02                   	cmpl	$2, %ebx
8041604c7f: 7f ef                      	jg	-17 <printnum+0x30>
8041604c81: eb 27                      	jmp	39 <printnum+0x6a>
8041604c83: 48 89 d0                   	movq	%rdx, %rax
;     printnum(putch, putdat, num / base, base, width - 1, padc);
8041604c86: 31 d2                      	xorl	%edx, %edx
8041604c88: 49 f7 f7                   	divq	%r15
8041604c8b: 83 c3 ff                   	addl	$-1, %ebx
8041604c8e: 49 ba 40 4c 60 41 80 00 00 00      	movabsq	$550852643904, %r10
8041604c98: 4c 89 e7                   	movq	%r12, %rdi
8041604c9b: 4c 89 f6                   	movq	%r14, %rsi
8041604c9e: 48 89 c2                   	movq	%rax, %rdx
8041604ca1: 41 89 d8                   	movl	%ebx, %r8d
8041604ca4: 45 89 e9                   	movl	%r13d, %r9d
8041604ca7: 41 ff d2                   	callq	*%r10
8041604caa: 48 8b 45 d0                	movq	-48(%rbp), %rax
;   putch("0123456789abcdef"[num % base], putdat);
8041604cae: 31 d2                      	xorl	%edx, %edx
8041604cb0: 49 f7 f7                   	divq	%r15
8041604cb3: 48 b8 04 58 60 41 80 00 00 00      	movabsq	$550852646916, %rax
8041604cbd: 0f be 3c 02                	movsbl	(%rdx,%rax), %edi
8041604cc1: 4c 89 f6                   	movq	%r14, %rsi
8041604cc4: 41 ff d4                   	callq	*%r12
; }
8041604cc7: 48 83 c4 08                	addq	$8, %rsp
8041604ccb: 5b                         	popq	%rbx
8041604ccc: 41 5c                      	popq	%r12
8041604cce: 41 5d                      	popq	%r13
8041604cd0: 41 5e                      	popq	%r14
8041604cd2: 41 5f                      	popq	%r15
8041604cd4: 5d                         	popq	%rbp
8041604cd5: c3                         	retq
8041604cd6: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)

0000008041604ce0 vsnprintf:
; vsnprintf(char *buf, int n, const char *fmt, va_list ap) {
8041604ce0: 55                         	pushq	%rbp
8041604ce1: 48 89 e5                   	movq	%rsp, %rbp
8041604ce4: 48 83 ec 20                	subq	$32, %rsp
;   struct sprintbuf b = {buf, buf + n - 1, 0};
8041604ce8: 48 89 7d e8                	movq	%rdi, -24(%rbp)
8041604cec: 48 63 c6                   	movslq	%esi, %rax
8041604cef: 48 01 f8                   	addq	%rdi, %rax
8041604cf2: 48 83 c0 ff                	addq	$-1, %rax
8041604cf6: 48 89 45 f0                	movq	%rax, -16(%rbp)
8041604cfa: c7 45 f8 00 00 00 00       	movl	$0, -8(%rbp)
8041604d01: b8 fd ff ff ff             	movl	$4294967293, %eax
;   if (buf == NULL || n < 1)
8041604d06: 48 85 ff                   	testq	%rdi, %rdi
8041604d09: 74 28                      	je	40 <vsnprintf+0x53>
8041604d0b: 85 f6                      	testl	%esi, %esi
8041604d0d: 7e 24                      	jle	36 <vsnprintf+0x53>
;   vprintfmt((void *)sprintputch, &b, fmt, ap);
8041604d0f: 48 bf 40 4d 60 41 80 00 00 00      	movabsq	$550852644160, %rdi
8041604d19: 48 b8 b0 45 60 41 80 00 00 00      	movabsq	$550852642224, %rax
8041604d23: 48 8d 75 e8                	leaq	-24(%rbp), %rsi
8041604d27: ff d0                      	callq	*%rax
;   *b.buf = '\0';
8041604d29: 48 8b 45 e8                	movq	-24(%rbp), %rax
8041604d2d: c6 00 00                   	movb	$0, (%rax)
;   return b.cnt;
8041604d30: 8b 45 f8                   	movl	-8(%rbp), %eax
; }
8041604d33: 48 83 c4 20                	addq	$32, %rsp
8041604d37: 5d                         	popq	%rbp
8041604d38: c3                         	retq
8041604d39: 0f 1f 80 00 00 00 00       	nopl	(%rax)

0000008041604d40 sprintputch:
; sprintputch(int ch, struct sprintbuf *b) {
8041604d40: 55                         	pushq	%rbp
8041604d41: 48 89 e5                   	movq	%rsp, %rbp
;   b->cnt++;
8041604d44: 83 46 10 01                	addl	$1, 16(%rsi)
;   if (b->buf < b->ebuf)
8041604d48: 48 8b 06                   	movq	(%rsi), %rax
8041604d4b: 48 3b 46 08                	cmpq	8(%rsi), %rax
8041604d4f: 73 0a                      	jae	10 <sprintputch+0x1b>
;     *b->buf++ = ch;
8041604d51: 48 8d 48 01                	leaq	1(%rax), %rcx
8041604d55: 48 89 0e                   	movq	%rcx, (%rsi)
8041604d58: 40 88 38                   	movb	%dil, (%rax)
; }
8041604d5b: 5d                         	popq	%rbp
8041604d5c: c3                         	retq
8041604d5d: 0f 1f 00                   	nopl	(%rax)

0000008041604d60 snprintf:
; snprintf(char *buf, int n, const char *fmt, ...) {
8041604d60: 55                         	pushq	%rbp
8041604d61: 48 89 e5                   	movq	%rsp, %rbp
8041604d64: 48 81 ec d0 00 00 00       	subq	$208, %rsp
8041604d6b: 84 c0                      	testb	%al, %al
8041604d6d: 74 26                      	je	38 <snprintf+0x35>
8041604d6f: 0f 29 85 60 ff ff ff       	movaps	%xmm0, -160(%rbp)
8041604d76: 0f 29 8d 70 ff ff ff       	movaps	%xmm1, -144(%rbp)
8041604d7d: 0f 29 55 80                	movaps	%xmm2, -128(%rbp)
8041604d81: 0f 29 5d 90                	movaps	%xmm3, -112(%rbp)
8041604d85: 0f 29 65 a0                	movaps	%xmm4, -96(%rbp)
8041604d89: 0f 29 6d b0                	movaps	%xmm5, -80(%rbp)
8041604d8d: 0f 29 75 c0                	movaps	%xmm6, -64(%rbp)
8041604d91: 0f 29 7d d0                	movaps	%xmm7, -48(%rbp)
8041604d95: 48 89 8d 48 ff ff ff       	movq	%rcx, -184(%rbp)
8041604d9c: 4c 89 85 50 ff ff ff       	movq	%r8, -176(%rbp)
8041604da3: 4c 89 8d 58 ff ff ff       	movq	%r9, -168(%rbp)
8041604daa: 48 8d 85 30 ff ff ff       	leaq	-208(%rbp), %rax
;   va_start(ap, fmt);
8041604db1: 48 89 45 f0                	movq	%rax, -16(%rbp)
8041604db5: 48 8d 45 10                	leaq	16(%rbp), %rax
8041604db9: 48 89 45 e8                	movq	%rax, -24(%rbp)
8041604dbd: 48 b8 18 00 00 00 30 00 00 00      	movabsq	$206158430232, %rax
8041604dc7: 48 89 45 e0                	movq	%rax, -32(%rbp)
;   rc = vsnprintf(buf, n, fmt, ap);
8041604dcb: 48 b8 e0 4c 60 41 80 00 00 00      	movabsq	$550852644064, %rax
8041604dd5: 48 8d 4d e0                	leaq	-32(%rbp), %rcx
8041604dd9: ff d0                      	callq	*%rax
;   return rc;
8041604ddb: 48 81 c4 d0 00 00 00       	addq	$208, %rsp
8041604de2: 5d                         	popq	%rbp
8041604de3: c3                         	retq
8041604de4: cc                         	int3
8041604de5: cc                         	int3
8041604de6: cc                         	int3
8041604de7: cc                         	int3
8041604de8: cc                         	int3
8041604de9: cc                         	int3
8041604dea: cc                         	int3
8041604deb: cc                         	int3
8041604dec: cc                         	int3
8041604ded: cc                         	int3
8041604dee: cc                         	int3
8041604def: cc                         	int3

0000008041604df0 readline:
; readline(const char *prompt) {
8041604df0: 55                         	pushq	%rbp
8041604df1: 48 89 e5                   	movq	%rsp, %rbp
8041604df4: 41 57                      	pushq	%r15
8041604df6: 41 56                      	pushq	%r14
8041604df8: 41 55                      	pushq	%r13
8041604dfa: 41 54                      	pushq	%r12
8041604dfc: 53                         	pushq	%rbx
8041604dfd: 50                         	pushq	%rax
;       cprintf("read error: %i\n", c);
8041604dfe: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
;   if (prompt != NULL)
8041604e08: 48 85 ff                   	testq	%rdi, %rdi
8041604e0b: 74 11                      	je	17 <readline+0x2e>
8041604e0d: 48 89 fe                   	movq	%rdi, %rsi
;     cprintf("%s", prompt);
8041604e10: 48 bf b2 55 60 41 80 00 00 00      	movabsq	$550852646322, %rdi
8041604e1a: 31 c0                      	xorl	%eax, %eax
8041604e1c: ff d1                      	callq	*%rcx
;   echoing = iscons(0);
8041604e1e: 48 b8 60 09 60 41 80 00 00 00      	movabsq	$550852626784, %rax
8041604e28: 45 31 ed                   	xorl	%r13d, %r13d
8041604e2b: 31 ff                      	xorl	%edi, %edi
8041604e2d: ff d0                      	callq	*%rax
8041604e2f: 41 89 c7                   	movl	%eax, %r15d
;     c = getchar();
8041604e32: 49 be 40 09 60 41 80 00 00 00      	movabsq	$550852626752, %r14
8041604e3c: 41 ff d6                   	callq	*%r14
8041604e3f: 89 c3                      	movl	%eax, %ebx
;     if (c < 0) {
8041604e41: 85 c0                      	testl	%eax, %eax
8041604e43: 0f 88 b0 00 00 00          	js	176 <readline+0x109>
8041604e49: 49 bc e0 08 60 41 80 00 00 00      	movabsq	$550852626656, %r12
8041604e53: eb 1c                      	jmp	28 <readline+0x81>
8041604e55: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041604e5f: 90                         	nop
;         i--;
8041604e60: 41 83 c5 ff                	addl	$-1, %r13d
;     c = getchar();
8041604e64: 41 ff d6                   	callq	*%r14
8041604e67: 89 c3                      	movl	%eax, %ebx
;     if (c < 0) {
8041604e69: 85 c0                      	testl	%eax, %eax
8041604e6b: 0f 88 88 00 00 00          	js	136 <readline+0x109>
;     } else if ((c == '\b' || c == '\x7f')) {
8041604e71: 83 fb 7f                   	cmpl	$127, %ebx
8041604e74: 74 05                      	je	5 <readline+0x8b>
8041604e76: 83 fb 08                   	cmpl	$8, %ebx
8041604e79: 75 25                      	jne	37 <readline+0xb0>
;       if (i > 0) {
8041604e7b: 45 85 ed                   	testl	%r13d, %r13d
8041604e7e: 7e e4                      	jle	-28 <readline+0x74>
8041604e80: 45 85 ff                   	testl	%r15d, %r15d
;         if (echoing) {
8041604e83: 74 db                      	je	-37 <readline+0x70>
;           cputchar('\b');
8041604e85: bf 08 00 00 00             	movl	$8, %edi
8041604e8a: 41 ff d4                   	callq	*%r12
;           cputchar(' ');
8041604e8d: bf 20 00 00 00             	movl	$32, %edi
8041604e92: 41 ff d4                   	callq	*%r12
;           cputchar('\b');
8041604e95: bf 08 00 00 00             	movl	$8, %edi
8041604e9a: 41 ff d4                   	callq	*%r12
8041604e9d: eb c1                      	jmp	-63 <readline+0x70>
8041604e9f: 90                         	nop
;     } else if (c >= ' ' && i < BUFLEN - 1) {
8041604ea0: 41 81 fd fe 03 00 00       	cmpl	$1022, %r13d
8041604ea7: 7f 25                      	jg	37 <readline+0xde>
8041604ea9: 83 fb 20                   	cmpl	$32, %ebx
8041604eac: 7c 20                      	jl	32 <readline+0xde>
8041604eae: 45 85 ff                   	testl	%r15d, %r15d
;       if (echoing)
8041604eb1: 74 05                      	je	5 <readline+0xc8>
;         cputchar(c);
8041604eb3: 89 df                      	movl	%ebx, %edi
8041604eb5: 41 ff d4                   	callq	*%r12
;       buf[i++] = c;
8041604eb8: 49 63 c5                   	movslq	%r13d, %rax
8041604ebb: 41 83 c5 01                	addl	$1, %r13d
8041604ebf: 48 b9 d0 15 62 41 80 00 00 00      	movabsq	$550852761040, %rcx
8041604ec9: 88 1c 08                   	movb	%bl, (%rax,%rcx)
8041604ecc: eb 96                      	jmp	-106 <readline+0x74>
;     } else if (c == '\n' || c == '\r') {
8041604ece: 83 fb 0d                   	cmpl	$13, %ebx
8041604ed1: 74 05                      	je	5 <readline+0xe8>
8041604ed3: 83 fb 0a                   	cmpl	$10, %ebx
8041604ed6: 75 8c                      	jne	-116 <readline+0x74>
;       if (echoing)
8041604ed8: 45 85 ff                   	testl	%r15d, %r15d
8041604edb: 74 08                      	je	8 <readline+0xf5>
;         cputchar('\n');
8041604edd: bf 0a 00 00 00             	movl	$10, %edi
8041604ee2: 41 ff d4                   	callq	*%r12
;       buf[i] = 0;
8041604ee5: 49 63 c5                   	movslq	%r13d, %rax
8041604ee8: 49 be d0 15 62 41 80 00 00 00      	movabsq	$550852761040, %r14
8041604ef2: 42 c6 04 30 00             	movb	$0, (%rax,%r14)
8041604ef7: eb 1d                      	jmp	29 <readline+0x126>
;       cprintf("read error: %i\n", c);
8041604ef9: 48 bf 41 59 60 41 80 00 00 00      	movabsq	$550852647233, %rdi
8041604f03: 45 31 f6                   	xorl	%r14d, %r14d
8041604f06: 89 de                      	movl	%ebx, %esi
8041604f08: 31 c0                      	xorl	%eax, %eax
8041604f0a: 48 b9 30 40 60 41 80 00 00 00      	movabsq	$550852640816, %rcx
8041604f14: ff d1                      	callq	*%rcx
; }
8041604f16: 4c 89 f0                   	movq	%r14, %rax
8041604f19: 48 83 c4 08                	addq	$8, %rsp
8041604f1d: 5b                         	popq	%rbx
8041604f1e: 41 5c                      	popq	%r12
8041604f20: 41 5d                      	popq	%r13
8041604f22: 41 5e                      	popq	%r14
8041604f24: 41 5f                      	popq	%r15
8041604f26: 5d                         	popq	%rbp
8041604f27: c3                         	retq
8041604f28: cc                         	int3
8041604f29: cc                         	int3
8041604f2a: cc                         	int3
8041604f2b: cc                         	int3
8041604f2c: cc                         	int3
8041604f2d: cc                         	int3
8041604f2e: cc                         	int3
8041604f2f: cc                         	int3

0000008041604f30 strlen:
; strlen(const char *s) {
8041604f30: 55                         	pushq	%rbp
8041604f31: 48 89 e5                   	movq	%rsp, %rbp
;   for (n = 0; *s != '\0'; s++)
8041604f34: 80 3f 00                   	cmpb	$0, (%rdi)
8041604f37: 74 14                      	je	20 <strlen+0x1d>
8041604f39: 31 c0                      	xorl	%eax, %eax
8041604f3b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
8041604f40: 80 7c 07 01 00             	cmpb	$0, 1(%rdi,%rax)
8041604f45: 48 8d 40 01                	leaq	1(%rax), %rax
8041604f49: 75 f5                      	jne	-11 <strlen+0x10>
;   return n;
8041604f4b: 5d                         	popq	%rbp
8041604f4c: c3                         	retq
8041604f4d: 31 c0                      	xorl	%eax, %eax
8041604f4f: 5d                         	popq	%rbp
8041604f50: c3                         	retq
8041604f51: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041604f5b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041604f60 strnlen:
; strnlen(const char *s, size_t size) {
8041604f60: 55                         	pushq	%rbp
8041604f61: 48 89 e5                   	movq	%rsp, %rbp
;   for (n = 0; size > 0 && *s != '\0'; s++, size--)
8041604f64: 48 85 f6                   	testq	%rsi, %rsi
8041604f67: 74 18                      	je	24 <strnlen+0x21>
8041604f69: 48 89 f0                   	movq	%rsi, %rax
8041604f6c: 31 c9                      	xorl	%ecx, %ecx
8041604f6e: 66 90                      	nop
8041604f70: 80 3c 0f 00                	cmpb	$0, (%rdi,%rcx)
8041604f74: 74 0f                      	je	15 <strnlen+0x25>
8041604f76: 48 83 c1 01                	addq	$1, %rcx
8041604f7a: 48 39 c8                   	cmpq	%rcx, %rax
8041604f7d: 75 f1                      	jne	-15 <strnlen+0x10>
;   return n;
8041604f7f: 5d                         	popq	%rbp
8041604f80: c3                         	retq
8041604f81: 31 c0                      	xorl	%eax, %eax
8041604f83: 5d                         	popq	%rbp
8041604f84: c3                         	retq
8041604f85: 89 c8                      	movl	%ecx, %eax
8041604f87: 5d                         	popq	%rbp
8041604f88: c3                         	retq
8041604f89: 0f 1f 80 00 00 00 00       	nopl	(%rax)

0000008041604f90 strcpy:
; strcpy(char *dst, const char *src) {
8041604f90: 55                         	pushq	%rbp
8041604f91: 48 89 e5                   	movq	%rsp, %rbp
8041604f94: 48 89 f8                   	movq	%rdi, %rax
8041604f97: 31 c9                      	xorl	%ecx, %ecx
8041604f99: 0f 1f 80 00 00 00 00       	nopl	(%rax)
;   while ((*dst++ = *src++) != '\0')
8041604fa0: 0f b6 14 0e                	movzbl	(%rsi,%rcx), %edx
8041604fa4: 88 14 08                   	movb	%dl, (%rax,%rcx)
8041604fa7: 48 83 c1 01                	addq	$1, %rcx
8041604fab: 84 d2                      	testb	%dl, %dl
8041604fad: 75 f1                      	jne	-15 <strcpy+0x10>
;   return ret;
8041604faf: 5d                         	popq	%rbp
8041604fb0: c3                         	retq
8041604fb1: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
8041604fbb: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041604fc0 strcat:
; strcat(char *dst, const char *src) {
8041604fc0: 55                         	pushq	%rbp
8041604fc1: 48 89 e5                   	movq	%rsp, %rbp
8041604fc4: 41 56                      	pushq	%r14
8041604fc6: 53                         	pushq	%rbx
8041604fc7: 49 89 f6                   	movq	%rsi, %r14
8041604fca: 48 89 fb                   	movq	%rdi, %rbx
;   int len = strlen(dst);
8041604fcd: 48 b8 30 4f 60 41 80 00 00 00      	movabsq	$550852644656, %rax
8041604fd7: ff d0                      	callq	*%rax
;   strcpy(dst + len, src);
8041604fd9: 48 63 f8                   	movslq	%eax, %rdi
8041604fdc: 48 01 df                   	addq	%rbx, %rdi
8041604fdf: 48 b8 90 4f 60 41 80 00 00 00      	movabsq	$550852644752, %rax
8041604fe9: 4c 89 f6                   	movq	%r14, %rsi
8041604fec: ff d0                      	callq	*%rax
;   return dst;
8041604fee: 48 89 d8                   	movq	%rbx, %rax
8041604ff1: 5b                         	popq	%rbx
8041604ff2: 41 5e                      	popq	%r14
8041604ff4: 5d                         	popq	%rbp
8041604ff5: c3                         	retq
8041604ff6: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)

0000008041605000 strncpy:
; strncpy(char *dst, const char *src, size_t size) {
8041605000: 55                         	pushq	%rbp
8041605001: 48 89 e5                   	movq	%rsp, %rbp
8041605004: 48 89 f8                   	movq	%rdi, %rax
;   for (i = 0; i < size; i++) {
8041605007: 48 85 d2                   	testq	%rdx, %rdx
804160500a: 74 1e                      	je	30 <strncpy+0x2a>
804160500c: 31 ff                      	xorl	%edi, %edi
804160500e: eb 09                      	jmp	9 <strncpy+0x19>
8041605010: 48 83 c7 01                	addq	$1, %rdi
8041605014: 48 39 fa                   	cmpq	%rdi, %rdx
8041605017: 74 11                      	je	17 <strncpy+0x2a>
;     *dst++ = *src;
8041605019: 0f b6 0e                   	movzbl	(%rsi), %ecx
804160501c: 88 0c 38                   	movb	%cl, (%rax,%rdi)
;     if (*src != '\0')
804160501f: 80 3e 00                   	cmpb	$0, (%rsi)
8041605022: 74 ec                      	je	-20 <strncpy+0x10>
8041605024: 48 83 c6 01                	addq	$1, %rsi
8041605028: eb e6                      	jmp	-26 <strncpy+0x10>
;   return ret;
804160502a: 5d                         	popq	%rbp
804160502b: c3                         	retq
804160502c: 0f 1f 40 00                	nopl	(%rax)

0000008041605030 strlcpy:
; strlcpy(char *dst, const char *src, size_t size) {
8041605030: 55                         	pushq	%rbp
8041605031: 48 89 e5                   	movq	%rsp, %rbp
8041605034: 48 89 f8                   	movq	%rdi, %rax
;   if (size > 0) {
8041605037: 48 85 d2                   	testq	%rdx, %rdx
804160503a: 74 2e                      	je	46 <strlcpy+0x3a>
804160503c: 48 89 f8                   	movq	%rdi, %rax
;     while (--size > 0 && *src != '\0')
804160503f: 48 83 c2 ff                	addq	$-1, %rdx
8041605043: 74 22                      	je	34 <strlcpy+0x37>
8041605045: 31 c0                      	xorl	%eax, %eax
8041605047: 66 0f 1f 84 00 00 00 00 00 	nopw	(%rax,%rax)
8041605050: 0f b6 0c 06                	movzbl	(%rsi,%rax), %ecx
8041605054: 84 c9                      	testb	%cl, %cl
8041605056: 74 0c                      	je	12 <strlcpy+0x34>
;       *dst++ = *src++;
8041605058: 88 0c 07                   	movb	%cl, (%rdi,%rax)
;     while (--size > 0 && *src != '\0')
804160505b: 48 83 c0 01                	addq	$1, %rax
804160505f: 48 39 c2                   	cmpq	%rax, %rdx
8041605062: 75 ec                      	jne	-20 <strlcpy+0x20>
8041605064: 48 01 f8                   	addq	%rdi, %rax
;     *dst = '\0';
8041605067: c6 00 00                   	movb	$0, (%rax)
;   return dst - dst_in;
804160506a: 48 29 f8                   	subq	%rdi, %rax
804160506d: 5d                         	popq	%rbp
804160506e: c3                         	retq
804160506f: 90                         	nop

0000008041605070 strlcat:
; strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
8041605070: 55                         	pushq	%rbp
8041605071: 48 89 e5                   	movq	%rsp, %rbp
8041605074: 41 57                      	pushq	%r15
8041605076: 41 56                      	pushq	%r14
8041605078: 41 55                      	pushq	%r13
804160507a: 41 54                      	pushq	%r12
804160507c: 53                         	pushq	%rbx
804160507d: 50                         	pushq	%rax
804160507e: 49 89 d6                   	movq	%rdx, %r14
8041605081: 49 89 f7                   	movq	%rsi, %r15
8041605084: 49 89 fc                   	movq	%rdi, %r12
;   const size_t srclen = strlen(src);
8041605087: 48 b8 30 4f 60 41 80 00 00 00      	movabsq	$550852644656, %rax
8041605091: 48 89 f7                   	movq	%rsi, %rdi
8041605094: ff d0                      	callq	*%rax
8041605096: 4c 63 e8                   	movslq	%eax, %r13
;   const size_t dstlen = strnlen(dst, maxlen);
8041605099: 48 b8 60 4f 60 41 80 00 00 00      	movabsq	$550852644704, %rax
80416050a3: 4c 89 e7                   	movq	%r12, %rdi
80416050a6: 4c 89 f6                   	movq	%r14, %rsi
80416050a9: ff d0                      	callq	*%rax
80416050ab: 48 63 d8                   	movslq	%eax, %rbx
;   if (dstlen == maxlen)
80416050ae: 4c 39 f3                   	cmpq	%r14, %rbx
80416050b1: 75 05                      	jne	5 <strlcat+0x48>
80416050b3: 4c 89 f3                   	movq	%r14, %rbx
80416050b6: eb 44                      	jmp	68 <strlcat+0x8c>
;   if (srclen < maxlen - dstlen) {
80416050b8: 4c 89 f0                   	movq	%r14, %rax
80416050bb: 48 29 d8                   	subq	%rbx, %rax
80416050be: 49 8d 3c 1c                	leaq	(%r12,%rbx), %rdi
80416050c2: 4c 39 e8                   	cmpq	%r13, %rax
80416050c5: 76 15                      	jbe	21 <strlcat+0x6c>
;     memcpy(dst + dstlen, src, srclen + 1);
80416050c7: 49 8d 55 01                	leaq	1(%r13), %rdx
80416050cb: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416050d5: 4c 89 fe                   	movq	%r15, %rsi
80416050d8: ff d0                      	callq	*%rax
80416050da: eb 20                      	jmp	32 <strlcat+0x8c>
;     memcpy(dst + dstlen, src, maxlen - 1);
80416050dc: 49 8d 56 ff                	leaq	-1(%r14), %rdx
80416050e0: 48 b8 20 51 60 41 80 00 00 00      	movabsq	$550852645152, %rax
80416050ea: 4c 89 fe                   	movq	%r15, %rsi
80416050ed: ff d0                      	callq	*%rax
;     dst[dstlen + maxlen - 1] = '\0';
80416050ef: 49 8d 04 1e                	leaq	(%r14,%rbx), %rax
80416050f3: 48 83 c0 ff                	addq	$-1, %rax
80416050f7: 41 c6 04 04 00             	movb	$0, (%r12,%rax)
80416050fc: 4c 01 eb                   	addq	%r13, %rbx
; }
80416050ff: 48 89 d8                   	movq	%rbx, %rax
8041605102: 48 83 c4 08                	addq	$8, %rsp
8041605106: 5b                         	popq	%rbx
8041605107: 41 5c                      	popq	%r12
8041605109: 41 5d                      	popq	%r13
804160510b: 41 5e                      	popq	%r14
804160510d: 41 5f                      	popq	%r15
804160510f: 5d                         	popq	%rbp
8041605110: c3                         	retq
8041605111: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160511b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041605120 memcpy:
; memcpy(void *dst, const void *src, size_t n) {
8041605120: 55                         	pushq	%rbp
8041605121: 48 89 e5                   	movq	%rsp, %rbp
;   return memmove(dst, src, n);
8041605124: 48 b8 60 52 60 41 80 00 00 00      	movabsq	$550852645472, %rax
804160512e: ff d0                      	callq	*%rax
8041605130: 5d                         	popq	%rbp
8041605131: c3                         	retq
8041605132: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160513c: 0f 1f 40 00                	nopl	(%rax)

0000008041605140 strcmp:
; strcmp(const char *p, const char *q) {
8041605140: 55                         	pushq	%rbp
8041605141: 48 89 e5                   	movq	%rsp, %rbp
;   while (*p && *p == *q)
8041605144: 8a 07                      	movb	(%rdi), %al
8041605146: 84 c0                      	testb	%al, %al
8041605148: 74 19                      	je	25 <strcmp+0x23>
804160514a: 48 83 c7 01                	addq	$1, %rdi
804160514e: 66 90                      	nop
8041605150: 3a 06                      	cmpb	(%rsi), %al
8041605152: 75 0f                      	jne	15 <strcmp+0x23>
;     p++, q++;
8041605154: 48 83 c6 01                	addq	$1, %rsi
;   while (*p && *p == *q)
8041605158: 0f b6 07                   	movzbl	(%rdi), %eax
804160515b: 48 83 c7 01                	addq	$1, %rdi
804160515f: 84 c0                      	testb	%al, %al
8041605161: 75 ed                      	jne	-19 <strcmp+0x10>
;   return (int)((unsigned char)*p - (unsigned char)*q);
8041605163: 0f b6 c0                   	movzbl	%al, %eax
8041605166: 0f b6 0e                   	movzbl	(%rsi), %ecx
8041605169: 29 c8                      	subl	%ecx, %eax
804160516b: 5d                         	popq	%rbp
804160516c: c3                         	retq
804160516d: 0f 1f 00                   	nopl	(%rax)

0000008041605170 strncmp:
; strncmp(const char *p, const char *q, size_t n) {
8041605170: 55                         	pushq	%rbp
8041605171: 48 89 e5                   	movq	%rsp, %rbp
;   while (n > 0 && *p && *p == *q)
8041605174: 48 85 d2                   	testq	%rdx, %rdx
8041605177: 74 1d                      	je	29 <strncmp+0x26>
8041605179: 31 c9                      	xorl	%ecx, %ecx
804160517b: 0f 1f 44 00 00             	nopl	(%rax,%rax)
8041605180: 0f b6 04 0f                	movzbl	(%rdi,%rcx), %eax
8041605184: 85 c0                      	testl	%eax, %eax
8041605186: 74 12                      	je	18 <strncmp+0x2a>
8041605188: 3a 04 0e                   	cmpb	(%rsi,%rcx), %al
804160518b: 75 0d                      	jne	13 <strncmp+0x2a>
804160518d: 48 83 c1 01                	addq	$1, %rcx
8041605191: 48 39 ca                   	cmpq	%rcx, %rdx
8041605194: 75 ea                      	jne	-22 <strncmp+0x10>
8041605196: 31 c0                      	xorl	%eax, %eax
; }
8041605198: 5d                         	popq	%rbp
8041605199: c3                         	retq
;     return (int)((unsigned char)*p - (unsigned char)*q);
804160519a: 0f b6 0c 0e                	movzbl	(%rsi,%rcx), %ecx
804160519e: 29 c8                      	subl	%ecx, %eax
; }
80416051a0: 5d                         	popq	%rbp
80416051a1: c3                         	retq
80416051a2: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416051ac: 0f 1f 40 00                	nopl	(%rax)

00000080416051b0 strchr:
; strchr(const char *s, char c) {
80416051b0: 55                         	pushq	%rbp
80416051b1: 48 89 e5                   	movq	%rsp, %rbp
;   for (; *s; s++)
80416051b4: 8a 0f                      	movb	(%rdi), %cl
80416051b6: 84 c9                      	testb	%cl, %cl
80416051b8: 74 17                      	je	23 <strchr+0x21>
80416051ba: 48 89 f8                   	movq	%rdi, %rax
80416051bd: 0f 1f 00                   	nopl	(%rax)
;     if (*s == c)
80416051c0: 40 38 f1                   	cmpb	%sil, %cl
80416051c3: 74 0e                      	je	14 <strchr+0x23>
;   for (; *s; s++)
80416051c5: 0f b6 48 01                	movzbl	1(%rax), %ecx
80416051c9: 48 83 c0 01                	addq	$1, %rax
80416051cd: 84 c9                      	testb	%cl, %cl
80416051cf: 75 ef                      	jne	-17 <strchr+0x10>
80416051d1: 31 c0                      	xorl	%eax, %eax
; }
80416051d3: 5d                         	popq	%rbp
80416051d4: c3                         	retq
80416051d5: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
80416051df: 90                         	nop

00000080416051e0 strfind:
; strfind(const char *s, char c) {
80416051e0: 55                         	pushq	%rbp
80416051e1: 48 89 e5                   	movq	%rsp, %rbp
80416051e4: 48 89 f8                   	movq	%rdi, %rax
;   for (; *s; s++)
80416051e7: 48 83 c0 ff                	addq	$-1, %rax
80416051eb: 0f 1f 44 00 00             	nopl	(%rax,%rax)
80416051f0: 0f b6 48 01                	movzbl	1(%rax), %ecx
80416051f4: 48 83 c0 01                	addq	$1, %rax
80416051f8: 84 c9                      	testb	%cl, %cl
80416051fa: 74 05                      	je	5 <strfind+0x21>
80416051fc: 40 38 f1                   	cmpb	%sil, %cl
80416051ff: 75 ef                      	jne	-17 <strfind+0x10>
;   return (char *)s;
8041605201: 5d                         	popq	%rbp
8041605202: c3                         	retq
8041605203: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160520d: 0f 1f 00                   	nopl	(%rax)

0000008041605210 memset:
; memset(void *v, int c, size_t n) {
8041605210: 55                         	pushq	%rbp
8041605211: 48 89 e5                   	movq	%rsp, %rbp
;   if (n == 0)
8041605214: 48 85 d2                   	testq	%rdx, %rdx
8041605217: 74 33                      	je	51 <memset+0x3c>
;   if ((int64_t)v % 4 == 0 && n % 4 == 0) {
8041605219: 89 f8                      	movl	%edi, %eax
804160521b: 09 d0                      	orl	%edx, %eax
804160521d: a8 03                      	testb	$3, %al
804160521f: 74 0a                      	je	10 <memset+0x1b>
;     asm volatile("cld; rep stosb\n" ::"D"(v), "a"(c), "c"(n)
8041605221: 89 f0                      	movl	%esi, %eax
8041605223: 48 89 d1                   	movq	%rdx, %rcx
8041605226: fc                         	cld
8041605227: f3 aa                      	rep		stosb	%al, %es:(%rdi)
8041605229: eb 21                      	jmp	33 <memset+0x3c>
;     uint32_t k = c & 0xFFU;
804160522b: 40 0f b6 c6                	movzbl	%sil, %eax
;     k          = (k << 24U) | (k << 16U) | (k << 8U) | k;
804160522f: c1 e6 18                   	shll	$24, %esi
8041605232: 89 c1                      	movl	%eax, %ecx
8041605234: 09 c6                      	orl	%eax, %esi
8041605236: c1 e0 10                   	shll	$16, %eax
8041605239: c1 e1 08                   	shll	$8, %ecx
804160523c: 09 c6                      	orl	%eax, %esi
804160523e: 09 ce                      	orl	%ecx, %esi
;     asm volatile("cld; rep stosl\n" ::"D"(v), "a"(k), "c"(n / 4)
8041605240: 48 c1 ea 02                	shrq	$2, %rdx
8041605244: 89 f0                      	movl	%esi, %eax
8041605246: 48 89 d1                   	movq	%rdx, %rcx
8041605249: fc                         	cld
804160524a: f3 ab                      	rep		stosl	%eax, %es:(%rdi)
; }
804160524c: 48 89 f8                   	movq	%rdi, %rax
804160524f: 5d                         	popq	%rbp
8041605250: c3                         	retq
8041605251: 66 2e 0f 1f 84 00 00 00 00 00      	nopw	%cs:(%rax,%rax)
804160525b: 0f 1f 44 00 00             	nopl	(%rax,%rax)

0000008041605260 memmove:
; memmove(void *dst, const void *src, size_t n) {
8041605260: 55                         	pushq	%rbp
8041605261: 48 89 e5                   	movq	%rsp, %rbp
8041605264: 48 89 f1                   	movq	%rsi, %rcx
8041605267: 48 89 f8                   	movq	%rdi, %rax
;   if (s < d && s + n > d) {
804160526a: 48 39 fe                   	cmpq	%rdi, %rsi
804160526d: 73 2d                      	jae	45 <memmove+0x3c>
804160526f: 48 8d 34 11                	leaq	(%rcx,%rdx), %rsi
8041605273: 48 39 c6                   	cmpq	%rax, %rsi
8041605276: 76 24                      	jbe	36 <memmove+0x3c>
;     d += n;
8041605278: 48 8d 3c 10                	leaq	(%rax,%rdx), %rdi
;     if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
804160527c: 40 f6 c6 03                	testb	$3, %sil
8041605280: 75 09                      	jne	9 <memmove+0x2b>
8041605282: 89 f9                      	movl	%edi, %ecx
8041605284: 09 d1                      	orl	%edx, %ecx
8041605286: f6 c1 03                   	testb	$3, %cl
8041605289: 74 40                      	je	64 <memmove+0x6b>
;       asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
804160528b: 48 83 c7 ff                	addq	$-1, %rdi
804160528f: 48 83 c6 ff                	addq	$-1, %rsi
8041605293: 48 89 d1                   	movq	%rdx, %rcx
8041605296: fd                         	std
8041605297: f3 a4                      	rep		movsb	(%rsi), %es:(%rdi)
;     asm volatile("cld" ::
8041605299: fc                         	cld
;   return dst;
804160529a: 5d                         	popq	%rbp
804160529b: c3                         	retq
;     if ((int64_t)s % 4 == 0 && (int64_t)d % 4 == 0 && n % 4 == 0)
804160529c: f6 c1 03                   	testb	$3, %cl
804160529f: 75 0a                      	jne	10 <memmove+0x4b>
80416052a1: 89 c6                      	movl	%eax, %esi
80416052a3: 09 d6                      	orl	%edx, %esi
80416052a5: 40 f6 c6 03                	testb	$3, %sil
80416052a9: 74 0e                      	je	14 <memmove+0x59>
;       asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
80416052ab: 48 89 c7                   	movq	%rax, %rdi
80416052ae: 48 89 ce                   	movq	%rcx, %rsi
80416052b1: 48 89 d1                   	movq	%rdx, %rcx
80416052b4: fc                         	cld
80416052b5: f3 a4                      	rep		movsb	(%rsi), %es:(%rdi)
;   return dst;
80416052b7: 5d                         	popq	%rbp
80416052b8: c3                         	retq
;       asm volatile("cld; rep movsl\n" ::"D"(d), "S"(s), "c"(n / 4)
80416052b9: 48 c1 ea 02                	shrq	$2, %rdx
80416052bd: 48 89 c7                   	movq	%rax, %rdi
80416052c0: 48 89 ce                   	movq	%rcx, %rsi
80416052c3: 48 89 d1                   	movq	%rdx, %rcx
80416052c6: fc                         	cld
80416052c7: f3 a5                      	rep		movsl	(%rsi), %es:(%rdi)
;   return dst;
80416052c9: 5d                         	popq	%rbp
80416052ca: c3                         	retq
;       asm volatile("std; rep movsl\n" ::"D"(d - 4), "S"(s - 4), "c"(n / 4)
80416052cb: 48 83 c7 fc                	addq	$-4, %rdi
80416052cf: 48 83 c6 fc                	addq	$-4, %rsi
80416052d3: 48 c1 ea 02                	shrq	$2, %rdx
80416052d7: 48 89 d1                   	movq	%rdx, %rcx
80416052da: fd                         	std
80416052db: f3 a5                      	rep		movsl	(%rsi), %es:(%rdi)
;     asm volatile("cld" ::
80416052dd: fc                         	cld
;   return dst;
80416052de: 5d                         	popq	%rbp
80416052df: c3                         	retq

00000080416052e0 memcmp:
; memcmp(const void *v1, const void *v2, size_t n) {
80416052e0: 55                         	pushq	%rbp
80416052e1: 48 89 e5                   	movq	%rsp, %rbp
;   while (n-- > 0) {
80416052e4: 48 85 d2                   	testq	%rdx, %rdx
80416052e7: 74 1e                      	je	30 <memcmp+0x27>
80416052e9: 31 c9                      	xorl	%ecx, %ecx
80416052eb: 0f 1f 44 00 00             	nopl	(%rax,%rax)
;     if (*s1 != *s2)
80416052f0: 0f b6 04 0f                	movzbl	(%rdi,%rcx), %eax
80416052f4: 44 0f b6 04 0e             	movzbl	(%rsi,%rcx), %r8d
80416052f9: 44 38 c0                   	cmpb	%r8b, %al
80416052fc: 75 0d                      	jne	13 <memcmp+0x2b>
;   while (n-- > 0) {
80416052fe: 48 83 c1 01                	addq	$1, %rcx
8041605302: 48 39 ca                   	cmpq	%rcx, %rdx
8041605305: 75 e9                      	jne	-23 <memcmp+0x10>
8041605307: 31 c0                      	xorl	%eax, %eax
; }
8041605309: 5d                         	popq	%rbp
804160530a: c3                         	retq
;       return (int)*s1 - (int)*s2;
804160530b: 44 29 c0                   	subl	%r8d, %eax
; }
804160530e: 5d                         	popq	%rbp
804160530f: c3                         	retq

0000008041605310 memfind:
; memfind(const void *s, int c, size_t n) {
8041605310: 55                         	pushq	%rbp
8041605311: 48 89 e5                   	movq	%rsp, %rbp
8041605314: 48 89 f8                   	movq	%rdi, %rax
;   for (; s < ends; s++)
8041605317: 48 85 d2                   	testq	%rdx, %rdx
804160531a: 7e 12                      	jle	18 <memfind+0x1e>
804160531c: 48 01 c2                   	addq	%rax, %rdx
804160531f: 90                         	nop
;     if (*(const unsigned char *)s == (unsigned char)c)
8041605320: 40 38 30                   	cmpb	%sil, (%rax)
8041605323: 74 09                      	je	9 <memfind+0x1e>
;   for (; s < ends; s++)
8041605325: 48 83 c0 01                	addq	$1, %rax
8041605329: 48 39 d0                   	cmpq	%rdx, %rax
804160532c: 72 f2                      	jb	-14 <memfind+0x10>
;   return (void *)s;
804160532e: 5d                         	popq	%rbp
804160532f: c3                         	retq

0000008041605330 strtol:
; strtol(const char *s, char **endptr, int base) {
8041605330: 55                         	pushq	%rbp
8041605331: 48 89 e5                   	movq	%rsp, %rbp
8041605334: 48 b8 d8 66 60 41 80 00 00 00      	movabsq	$550852650712, %rax
804160533e: 66 90                      	nop
;   while (*s == ' ' || *s == '\t')
8041605340: 0f b6 0f                   	movzbl	(%rdi), %ecx
8041605343: 80 c1 f7                   	addb	$-9, %cl
8041605346: 80 f9 24                   	cmpb	$36, %cl
8041605349: 77 10                      	ja	16 <strtol+0x2b>
804160534b: 0f b6 c9                   	movzbl	%cl, %ecx
804160534e: ff 24 c8                   	jmpq	*(%rax,%rcx,8)
;     s++;
8041605351: 48 83 c7 01                	addq	$1, %rdi
8041605355: eb e9                      	jmp	-23 <strtol+0x10>
;     s++;
8041605357: 48 83 c7 01                	addq	$1, %rdi
804160535b: 45 31 c0                   	xorl	%r8d, %r8d
;   if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
804160535e: f7 c2 ef ff ff ff          	testl	$4294967279, %edx
8041605364: 75 2b                      	jne	43 <strtol+0x61>
8041605366: eb 12                      	jmp	18 <strtol+0x4a>
;     s++, neg = 1;
8041605368: 48 83 c7 01                	addq	$1, %rdi
804160536c: 41 b8 01 00 00 00          	movl	$1, %r8d
;   if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
8041605372: f7 c2 ef ff ff ff          	testl	$4294967279, %edx
8041605378: 75 17                      	jne	23 <strtol+0x61>
804160537a: 80 3f 30                   	cmpb	$48, (%rdi)
804160537d: 75 12                      	jne	18 <strtol+0x61>
804160537f: 80 7f 01 78                	cmpb	$120, 1(%rdi)
8041605383: 75 0c                      	jne	12 <strtol+0x61>
;     s += 2, base = 16;
8041605385: 48 83 c7 02                	addq	$2, %rdi
8041605389: 41 ba 10 00 00 00          	movl	$16, %r10d
804160538f: eb 21                      	jmp	33 <strtol+0x82>
;   if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
8041605391: 85 d2                      	testl	%edx, %edx
;   else if (base == 0 && s[0] == '0')
8041605393: 75 11                      	jne	17 <strtol+0x76>
8041605395: 80 3f 30                   	cmpb	$48, (%rdi)
8041605398: 75 0c                      	jne	12 <strtol+0x76>
;     s++, base = 8;
804160539a: 48 83 c7 01                	addq	$1, %rdi
804160539e: 41 ba 08 00 00 00          	movl	$8, %r10d
80416053a4: eb 0c                      	jmp	12 <strtol+0x82>
;   if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
80416053a6: 85 d2                      	testl	%edx, %edx
80416053a8: 41 ba 0a 00 00 00          	movl	$10, %r10d
;   else if (base == 0)
80416053ae: 44 0f 45 d2                	cmovnel	%edx, %r10d
80416053b2: 4d 63 ca                   	movslq	%r10d, %r9
80416053b5: 45 31 db                   	xorl	%r11d, %r11d
80416053b8: eb 29                      	jmp	41 <strtol+0xb3>
80416053ba: 66 0f 1f 44 00 00          	nopw	(%rax,%rax)
80416053c0: 31 c0                      	xorl	%eax, %eax
80416053c2: 84 c0                      	testb	%al, %al
80416053c4: 75 1d                      	jne	29 <strtol+0xb3>
80416053c6: eb 51                      	jmp	81 <strtol+0xe9>
80416053c8: 0f 1f 84 00 00 00 00 00    	nopl	(%rax,%rax)
;     s++, val = (val * base) + dig;
80416053d0: 48 83 c7 01                	addq	$1, %rdi
80416053d4: 4d 0f af d9                	imulq	%r9, %r11
80416053d8: 48 98                      	cltq
80416053da: 49 01 c3                   	addq	%rax, %r11
80416053dd: b0 01                      	movb	$1, %al
80416053df: 84 c0                      	testb	%al, %al
80416053e1: 74 36                      	je	54 <strtol+0xe9>
;     if (*s >= '0' && *s <= '9')
80416053e3: 0f be 0f                   	movsbl	(%rdi), %ecx
80416053e6: 8d 51 d0                   	leal	-48(%rcx), %edx
80416053e9: b8 d0 ff ff ff             	movl	$4294967248, %eax
80416053ee: 80 fa 0a                   	cmpb	$10, %dl
80416053f1: 72 1d                      	jb	29 <strtol+0xe0>
;     else if (*s >= 'a' && *s <= 'z')
80416053f3: 8d 51 9f                   	leal	-97(%rcx), %edx
80416053f6: b8 a9 ff ff ff             	movl	$4294967209, %eax
80416053fb: 80 fa 1a                   	cmpb	$26, %dl
80416053fe: 72 10                      	jb	16 <strtol+0xe0>
;     else if (*s >= 'A' && *s <= 'Z')
8041605400: 8d 51 bf                   	leal	-65(%rcx), %edx
8041605403: b8 c9 ff ff ff             	movl	$4294967241, %eax
8041605408: 80 fa 19                   	cmpb	$25, %dl
804160540b: 77 b3                      	ja	-77 <strtol+0x90>
804160540d: 0f 1f 00                   	nopl	(%rax)
8041605410: 01 c8                      	addl	%ecx, %eax
;     if (dig >= base)
8041605412: 44 39 d0                   	cmpl	%r10d, %eax
8041605415: 7c b9                      	jl	-71 <strtol+0xa0>
8041605417: eb a7                      	jmp	-89 <strtol+0x90>
;   if (endptr)
8041605419: 48 85 f6                   	testq	%rsi, %rsi
804160541c: 74 03                      	je	3 <strtol+0xf1>
;     *endptr = (char *)s;
804160541e: 48 89 3e                   	movq	%rdi, (%rsi)
;   return (neg ? -val : val);
8041605421: 4c 89 d8                   	movq	%r11, %rax
8041605424: 48 f7 d8                   	negq	%rax
8041605427: 45 85 c0                   	testl	%r8d, %r8d
804160542a: 49 0f 44 c3                	cmoveq	%r11, %rax
804160542e: 5d                         	popq	%rbp
804160542f: c3                         	retq

0000008041605430 _efi_call_in_32bit_mode_asm:
;     pushq %rbp
8041605430: 55                         	pushq	%rbp
;     movq %rsp, %rbp
8041605431: 48 89 e5                   	movq	%rsp, %rbp
; 	push	%rbx
8041605434: 53                         	pushq	%rbx
; 	push	%r12
8041605435: 41 54                      	pushq	%r12
; 	push	%r13
8041605437: 41 55                      	pushq	%r13
; 	push	%r14
8041605439: 41 56                      	pushq	%r14
; 	push	%r15
804160543b: 41 57                      	pushq	%r15
; 	push	%rsi
804160543d: 56                         	pushq	%rsi
; 	push	%rcx
804160543e: 51                         	pushq	%rcx
; 	push	%rbp	/* save %rbp and align to 16-byte boundary */
804160543f: 55                         	pushq	%rbp
; 	sub	%rcx, %rsp	/* make room for stack contents */
8041605440: 48 29 cc                   	subq	%rcx, %rsp
; 	COPY_STACK(%rdx, %rcx, %r8)
8041605443: 49 c7 c0 00 00 00 00       	movq	$0, %r8

000000804160544a copyloop:
804160544a: 4a 8b 04 02                	movq	(%rdx,%r8), %rax
804160544e: 4a 89 04 04                	movq	%rax, (%rsp,%r8)
8041605452: 49 83 c0 08                	addq	$8, %r8
8041605456: 49 39 c8                   	cmpq	%rcx, %r8
8041605459: 75 ef                      	jne	-17 <copyloop>
; 	ENTER_COMPAT_MODE()
804160545b: e8 00 00 00 00             	callq	0 <copyloop+0x16>
8041605460: 48 83 04 24 0e             	addq	$14, (%rsp)
8041605465: c7 44 24 04 18 00 00 00    	movl	$24, 4(%rsp)
804160546d: cb                         	lretl
; 	call	*%edi			/* call EFI runtime */
804160546e: ff d7                      	callq	*%rdi
; 	ENTER_64BIT_MODE()
8041605470: 6a 08                      	pushq	$8
8041605472: e8 00 00 00 00             	callq	0 <copyloop+0x2d>
8041605477: 83 04 24 05                	addl	$5, (%rsp)
804160547b: cb                         	lretl
; 	mov	-48(%rbp), %rsi		/* load efi_reg into %esi */
804160547c: 48 8b 75 d0                	movq	-48(%rbp), %rsi
; 	mov	%rax, 32(%rsi)		/* save RAX back */
8041605480: 48 89 46 20                	movq	%rax, 32(%rsi)
; 	mov	-56(%rbp), %rcx	/* load s_c_s into %rcx */
8041605484: 48 8b 4d c8                	movq	-56(%rbp), %rcx
; 	add	%rcx, %rsp	/* discard stack contents */
8041605488: 48 01 cc                   	addq	%rcx, %rsp
; 	pop	%rbp		/* restore full 64-bit frame pointer */
804160548b: 5d                         	popq	%rbp
; 	pop	%rcx
804160548c: 59                         	popq	%rcx
; 	pop	%rsi
804160548d: 5e                         	popq	%rsi
; 	pop	%r15
804160548e: 41 5f                      	popq	%r15
; 	pop	%r14
8041605490: 41 5e                      	popq	%r14
; 	pop	%r13
8041605492: 41 5d                      	popq	%r13
; 	pop	%r12
8041605494: 41 5c                      	popq	%r12
; 	pop	%rbx
8041605496: 5b                         	popq	%rbx
; 	leave
8041605497: c9                         	leave
; 	ret
8041605498: c3                         	retq
8041605499: cc                         	int3
804160549a: cc                         	int3
804160549b: cc                         	int3
804160549c: cc                         	int3
804160549d: cc                         	int3
804160549e: cc                         	int3
804160549f: cc                         	int3
