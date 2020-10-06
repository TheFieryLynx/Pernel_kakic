
obj/prog/test1:	file format ELF64-x86-64


Disassembly of section .text:

0000000001000000 _start:
;   pushq $0
 1000000: 6a 00                        	pushq	$0
;   pushq $0
 1000002: 6a 00                        	pushq	$0

0000000001000004 args_exist:
;   movq 8(%rsp), %rsi
 1000004: 48 8b 74 24 08               	movq	8(%rsp), %rsi
;   movq (%rsp), %rdi
 1000009: 48 8b 3c 24                  	movq	(%rsp), %rdi
;   movq $0, %rbp
 100000d: 48 c7 c5 00 00 00 00         	movq	$0, %rbp
;   call libmain
 1000014: e8 37 00 00 00               	callq	55 <libmain>
;   jmp 1b
 1000019: eb fe                        	jmp	-2 <args_exist+0x15>
 100001b: cc                           	int3
 100001c: cc                           	int3
 100001d: cc                           	int3
 100001e: cc                           	int3
 100001f: cc                           	int3

0000000001000020 umain:
; umain(int argc, char **argv) {
 1000020: 55                           	pushq	%rbp
 1000021: 48 89 e5                     	movq	%rsp, %rbp
 1000024: 41 56                        	pushq	%r14
 1000026: 53                           	pushq	%rbx
 1000027: bb 03 00 00 00               	movl	$3, %ebx
 100002c: 49 be 08 10 00 01 00 00 00 00	movabsq	$16781320, %r14
 1000036: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
;     sys_yield();
 1000040: 49 8b 06                     	movq	(%r14), %rax
 1000043: ff d0                        	callq	*%rax
;   for (j = 0; j < 3; ++j) {
 1000045: 83 c3 ff                     	addl	$-1, %ebx
 1000048: 75 f6                        	jne	-10 <umain+0x20>
; }
 100004a: 5b                           	popq	%rbx
 100004b: 41 5e                        	popq	%r14
 100004d: 5d                           	popq	%rbp
 100004e: c3                           	retq
 100004f: cc                           	int3

0000000001000050 libmain:
; libmain(int argc, char **argv) {
 1000050: 55                           	pushq	%rbp
 1000051: 48 89 e5                     	movq	%rsp, %rbp
;   thisenv = 0;
 1000054: 48 b8 18 10 00 01 00 00 00 00	movabsq	$16781336, %rax
 100005e: 48 c7 00 00 00 00 00         	movq	$0, (%rax)
;   if (argc > 0)
 1000065: 85 ff                        	testl	%edi, %edi
 1000067: 7e 10                        	jle	16 <libmain+0x29>
;     binaryname = argv[0];
 1000069: 48 8b 06                     	movq	(%rsi), %rax
 100006c: 48 b9 00 10 00 01 00 00 00 00	movabsq	$16781312, %rcx
 1000076: 48 89 01                     	movq	%rax, (%rcx)
;   umain(argc, argv);
 1000079: 48 b8 20 00 00 01 00 00 00 00	movabsq	$16777248, %rax
 1000083: ff d0                        	callq	*%rax
;   sys_exit();
 1000085: 48 b8 10 10 00 01 00 00 00 00	movabsq	$16781328, %rax
 100008f: 48 8b 00                     	movq	(%rax), %rax
 1000092: ff d0                        	callq	*%rax
; }
 1000094: 5d                           	popq	%rbp
 1000095: c3                           	retq
