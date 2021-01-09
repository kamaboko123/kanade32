#include <stdint.h>

#include "vram.h"

uint8_t *vram = (uint8_t *)VRAM_BASE;

void point(uint32_t x, uint32_t y, uint8_t col) {
    uint32_t v_addr = (((y * VIDEO_MAX_X) + x) >> 1);
    uint32_t byte_selector = x & 0x01;
    uint32_t mask = 0x0F << (byte_selector * 4);
    uint32_t _col = col & 0x0F;

    *(vram + v_addr) &= ~(0x0F << (byte_selector * 4));
    *(vram + v_addr) |= (_col << (byte_selector * 4));
}

void clear_vram() {
    for (int i = 0; i < VIDEO_MAX_X * VIDEO_MAX_Y / 2; i++) {
        vram[i] = 0;
    }
}

int mips_main() {
    point(2, 0, 0x01);
    return (vram[1]);
    /*
    clear_vram();
    for (int x = 0; x < VIDEO_MAX_X; x++) {
        for (int y = 0; y < VIDEO_MAX_Y; y++) {
            uint8_t col = (x % 2) ? 0x00 : 0x01;
            point(x, y, col);
        }
    }
    return (vram[0]);
    */
}
