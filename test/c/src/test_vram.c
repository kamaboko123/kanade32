#include <stdint.h>

#include "video.h"

uint32_t mips_main() {
    uint8_t *vram = (uint8_t *)VRAM_BASE;

    for (int y = 0; y < VIDEO_MAX_Y; y++) {
        for (int x = 0; x < VIDEO_MAX_X; x++) {
            uint8_t col = 0x00;

            if (y % 2 == 0) {
                if (x % 2 == 0) {
                    col = 0x01;
                }
            }

            video_point(vram, x, y, col);
        }
    }
}
