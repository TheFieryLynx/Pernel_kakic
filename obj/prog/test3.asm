
obj/prog/test3:	file format ELF64-x86-64


Disassembly of section .text:

0000000001020000 _start:
;   pushq $0
 1020000: 6a 00                        	pushq	$0
;   pushq $0
 1020002: 6a 00                        	pushq	$0

0000000001020004 args_exist:
;   movq 8(%rsp), %rsi
 1020004: 48 8b 74 24 08               	movq	8(%rsp), %rsi
;   movq (%rsp), %rdi
 1020009: 48 8b 3c 24                  	movq	(%rsp), %rdi
;   movq $0, %rbp
 102000d: 48 c7 c5 00 00 00 00         	movq	$0, %rbp
;   call libmain
 1020014: e8 37 00 00 00               	callq	55 <libmain>
;   jmp 1b
 1020019: eb fe                        	jmp	-2 <args_exist+0x15>
 102001b: cc                           	int3
 102001c: cc                           	int3
 102001d: cc                           	int3
 102001e: cc                           	int3
 102001f: cc                           	int3

0000000001020020 umain:
; umain(int argc, char **argv) {
 1020020: 55                           	pushq	%rbp
 1020021: 48 89 e5                     	movq	%rsp, %rbp
 1020024: 41 56                        	pushq	%r14
 1020026: 53                           	pushq	%rbx
 1020027: bb 03 00 00 00               	movl	$3, %ebx
 102002c: 49 be 08 10 02 01 00 00 00 00	movabsq	$16912392, %r14
 1020036: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
;     sys_yield();
 1020040: 49 8b 06                     	movq	(%r14), %rax
 1020043: ff d0                        	callq	*%rax
;   for (j = 0; j < 3; ++j) {
 1020045: 83 c3 ff                     	addl	$-1, %ebx
 1020048: 75 f6                        	jne	-10 <umain+0x20>
; }
 102004a: 5b                           	popq	%rbx
 102004b: 41 5e                        	popq	%r14
 102004d: 5d                           	popq	%rbp
 102004e: c3                           	retq
 102004f: cc                           	int3

0000000001020050 libmain:
; libmain(int argc, char **argv) {
 1020050: 55                           	pushq	%rbp
 1020051: 48 89 e5                     	movq	%rsp, %rbp
;   thisenv = 0;
 1020054: 48 b8 18 10 02 01 00 00 00 00	movabsq	$16912408, %rax
 102005e: 48 c7 00 00 00 00 00         	movq	$0, (%rax)
;   if (argc > 0)
 1020065: 85 ff                        	testl	%edi, %edi
 1020067: 7e 10                        	jle	16 <libmain+0x29>
;     binaryname = argv[0];
 1020069: 48 8b 06                     	movq	(%rsi), %rax
 102006c: 48 b9 00 10 02 01 00 00 00 00	movabsq	$16912384, %rcx
 1020076: 48 89 01                     	movq	%rax, (%rcx)
;   umain(argc, argv);
 1020079: 48 b8 20 00 02 01 00 00 00 00	movabsq	$16908320, %rax
 1020083: ff d0                        	callq	*%rax
;   sys_exit();
 1020085: 48 b8 10 10 02 01 00 00 00 00	movabsq	$16912400, %rax
 102008f: 48 8b 00                     	movq	(%rax), %rax
 1020092: ff d0                        	callq	*%rax
; }
 1020094: 5d                           	popq	%rbp
 1020095: c3                           	retq
