
obj/prog/test2:     file format elf64-x86-64


Disassembly of section .text:

0000000001010000 <_start>:

  // If not, push dummy argc/argv arguments.
  // This happens when we are loaded by the kernel,
  // because the kernel does not know about passing arguments.
  // Marking argc and argv as zero.
  pushq $0
 1010000:	6a 00                	pushq  $0x0
  pushq $0
 1010002:	6a 00                	pushq  $0x0

0000000001010004 <args_exist>:

args_exist:
  movq 8(%rsp), %rsi
 1010004:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  movq (%rsp), %rdi
 1010009:	48 8b 3c 24          	mov    (%rsp),%rdi
  movq $0, %rbp
 101000d:	48 c7 c5 00 00 00 00 	mov    $0x0,%rbp
  call libmain
 1010014:	e8 5e 00 00 00       	callq  1010077 <libmain>
1:
  jmp 1b
 1010019:	eb fe                	jmp    1010019 <args_exist+0x15>

000000000101001b <umain>:
void (*volatile GRADE3_FUNC)(unsigned);
void (*volatile xc(GRADE3_FAIL, GRADE3_PFX1))(void);
#endif

void
umain(int argc, char **argv) {
 101001b:	55                   	push   %rbp
 101001c:	48 89 e5             	mov    %rsp,%rbp
 101001f:	41 54                	push   %r12
 1010021:	53                   	push   %rbx
  int test2_j;

#if !defined(GRADE3_TEST)
  cprintf("TEST2 LOADED.\n");
#else
  GRADE3_FUNC(xstr(GRADE3_FUNC)[0]);
 1010022:	48 a1 20 10 01 01 00 	movabs 0x1011020,%rax
 1010029:	00 00 00 
 101002c:	bf 78 00 00 00       	mov    $0x78,%edi
 1010031:	ff d0                	callq  *%rax
  if (xc(GRADE3_FAIL, GRADE3_PFX1)) {
 1010033:	48 a1 18 10 01 01 00 	movabs 0x1011018,%rax
 101003a:	00 00 00 
 101003d:	48 85 c0             	test   %rax,%rax
 1010040:	74 0c                	je     101004e <umain+0x33>
    xc(GRADE3_FAIL, GRADE3_PFX1)();
 1010042:	48 a1 18 10 01 01 00 	movabs 0x1011018,%rax
 1010049:	00 00 00 
 101004c:	ff d0                	callq  *%rax
umain(int argc, char **argv) {
 101004e:	bb 05 00 00 00       	mov    $0x5,%ebx
#endif

  for (test2_j = 0; test2_j < 5; ++test2_j) {
    for (test2_i = 0; test2_i < 10000; ++test2_i) {
    }
    sys_yield();
 1010053:	49 bc 08 10 01 01 00 	movabs $0x1011008,%r12
 101005a:	00 00 00 
umain(int argc, char **argv) {
 101005d:	b8 10 27 00 00       	mov    $0x2710,%eax
    for (test2_i = 0; test2_i < 10000; ++test2_i) {
 1010062:	83 e8 01             	sub    $0x1,%eax
 1010065:	75 fb                	jne    1010062 <umain+0x47>
    sys_yield();
 1010067:	49 8b 04 24          	mov    (%r12),%rax
 101006b:	ff d0                	callq  *%rax
  for (test2_j = 0; test2_j < 5; ++test2_j) {
 101006d:	83 eb 01             	sub    $0x1,%ebx
 1010070:	75 eb                	jne    101005d <umain+0x42>
  }
}
 1010072:	5b                   	pop    %rbx
 1010073:	41 5c                	pop    %r12
 1010075:	5d                   	pop    %rbp
 1010076:	c3                   	retq   

0000000001010077 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
 1010077:	55                   	push   %rbp
 1010078:	48 89 e5             	mov    %rsp,%rbp
  thisenv = 0;
 101007b:	48 b8 28 10 01 01 00 	movabs $0x1011028,%rax
 1010082:	00 00 00 
 1010085:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  // save the name of the program so that panic() can use it
  if (argc > 0)
 101008c:	85 ff                	test   %edi,%edi
 101008e:	7e 0d                	jle    101009d <libmain+0x26>
    binaryname = argv[0];
 1010090:	48 8b 06             	mov    (%rsi),%rax
 1010093:	48 a3 00 10 01 01 00 	movabs %rax,0x1011000
 101009a:	00 00 00 

  // call user main routine
  umain(argc, argv);
 101009d:	48 b8 1b 00 01 01 00 	movabs $0x101001b,%rax
 10100a4:	00 00 00 
 10100a7:	ff d0                	callq  *%rax

  // exit
#ifdef JOS_PROG
  sys_exit();
 10100a9:	48 a1 30 10 01 01 00 	movabs 0x1011030,%rax
 10100b0:	00 00 00 
 10100b3:	ff d0                	callq  *%rax
#endif
}
 10100b5:	5d                   	pop    %rbp
 10100b6:	c3                   	retq   
