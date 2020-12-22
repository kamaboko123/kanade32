
#define VRAM_BASE 0x00010000
#define VIDEO_MAX_X 320
#define VIDEO_MAX_Y 240

void point(unsigned int x, unsigned int y, unsigned char col) {
    unsigned int v_addr = ((y * 320) + x) >> 2;
    unsigned char mask = (0x0F << (x & 0x0f));

    unsigned int data = *((unsigned int *)VRAM_BASE + v_addr);
    data |= ((col << (x & 0x0f)) & mask);
}

int mips_main() {
}
