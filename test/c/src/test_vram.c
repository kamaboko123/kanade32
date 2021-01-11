#include <stdint.h>

#include "vram.h"

void point(uint8_t *vram, uint32_t x, uint32_t y, uint8_t col) {
    uint32_t v_addr = (y * VIDEO_MAX_X) + x;
    *(vram + v_addr) = col;
}

void clear_vram(uint8_t *vram) {
    for (int i = 0; i < VIDEO_MAX_X * VIDEO_MAX_Y; i++) {
        vram[i] = 0;
    }
}

uint32_t mips_main() {
    uint8_t *vram = (uint8_t *)VRAM_BASE;

    //clear_vram(vram);
    for (int y = 0; y < VIDEO_MAX_Y; y++) {
        for (int x = 0; x < VIDEO_MAX_X; x++) {
            uint8_t col = 0x00;

            if (y % 2 == 0) {
                if (x % 2 == 0) {
                    col = 0x01;
                }
            }

            point(vram, x, y, col);
        }
    }
}
