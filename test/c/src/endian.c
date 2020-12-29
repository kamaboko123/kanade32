int mips_main() {
    int *mem = (int *)0x00002000;
    *mem = 0x11223344;
    unsigned short *a = (unsigned short *)mem;

    return (*(a + 1));
}