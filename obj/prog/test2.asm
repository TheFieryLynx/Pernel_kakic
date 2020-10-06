
obj/prog/test2:	file format ELF64-x86-64


Disassembly of section .text:

0000000001010000 _start:
;   pushq $0
 1010000: 6a 00                        	pushq	$0
;   pushq $0
 1010002: 6a 00                        	pushq	$0

0000000001010004 args_exist:
;   movq 8(%rsp), %rsi
 1010004: 48 8b 74 24 08               	movq	8(%rsp), %rsi
;   movq (%rsp), %rdi
 1010009: 48 8b 3c 24                  	movq	(%rsp), %rdi
;   movq $0, %rbp
 101000d: 48 c7 c5 00 00 00 00         	movq	$0, %rbp
;   call libmain
 1010014: e8 57 00 00 00               	callq	87 <libmain>
;   jmp 1b
 1010019: eb fe                        	jmp	-2 <args_exist+0x15>
 101001b: cc                           	int3
 101001c: cc                           	int3
 101001d: cc                           	int3
 101001e: cc                           	int3
 101001f: cc                           	int3

0000000001010020 umain:
; umain(int argc, char **argv) {
 1010020: 55                           	pushq	%rbp
 1010021: 48 89 e5                     	movq	%rsp, %rbp
 1010024: 41 56                        	pushq	%r14
 1010026: 53                           	pushq	%rbx
;   cprintf("TEST2 LOADED.\n");
 1010027: 48 b8 08 10 01 01 00 00 00 00	movabsq	$16846856, %rax
 1010031: 48 8b 08                     	movq	(%rax), %rcx
 1010034: 48 bf c0 00 01 01 00 00 00 00	movabsq	$16842944, %rdi
 101003e: 31 c0                        	xorl	%eax, %eax
 1010040: ff d1                        	callq	*%rcx
 1010042: bb 05 00 00 00               	movl	$5, %ebx
 1010047: 49 be 10 10 01 01 00 00 00 00	movabsq	$16846864, %r14
 1010051: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
 101005b: 0f 1f 44 00 00               	nopl	(%rax,%rax)
;     sys_yield();
 1010060: 49 8b 06                     	movq	(%r14), %rax
 1010063: ff d0                        	callq	*%rax
;   for (test2_j = 0; test2_j < 5; ++test2_j) {
 1010065: 83 c3 ff                     	addl	$-1, %ebx
 1010068: 75 f6                        	jne	-10 <umain+0x40>
; }
 101006a: 5b                           	popq	%rbx
 101006b: 41 5e                        	popq	%r14
 101006d: 5d                           	popq	%rbp
 101006e: c3                           	retq
 101006f: cc                           	int3

0000000001010070 libmain:
; libmain(int argc, char **argv) {
 1010070: 55                           	pushq	%rbp
 1010071: 48 89 e5                     	movq	%rsp, %rbp
;   thisenv = 0;
 1010074: 48 b8 20 10 01 01 00 00 00 00	movabsq	$16846880, %rax
 101007e: 48 c7 00 00 00 00 00         	movq	$0, (%rax)
;   if (argc > 0)
 1010085: 85 ff                        	testl	%edi, %edi
 1010087: 7e 10                        	jle	16 <libmain+0x29>
;     binaryname = argv[0];
 1010089: 48 8b 06                     	movq	(%rsi), %rax
 101008c: 48 b9 00 10 01 01 00 00 00 00	movabsq	$16846848, %rcx
 1010096: 48 89 01                     	movq	%rax, (%rcx)
;   umain(argc, argv);
 1010099: 48 b8 20 00 01 01 00 00 00 00	movabsq	$16842784, %rax
 10100a3: ff d0                        	callq	*%rax
;   sys_exit();
 10100a5: 48 b8 18 10 01 01 00 00 00 00	movabsq	$16846872, %rax
 10100af: 48 8b 00                     	movq	(%rax), %rax
 10100b2: ff d0                        	callq	*%rax
; }
 10100b4: 5d                           	popq	%rbp
 10100b5: c3                           	retq
