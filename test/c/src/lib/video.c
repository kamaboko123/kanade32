#include "video.h"

void video_point(uint8_t *vram, uint32_t x, uint32_t y, uint8_t col) {
    uint32_t v_addr = (y * VIDEO_MAX_X) + x;
    *(vram + v_addr) = col;
}

void vide_clear(uint8_t *vram) {
    uint32_t *_vram = (uint32_t *)vram;
    for (int i = 0; i < VIDEO_MAX_X * VIDEO_MAX_Y / 4; i++) {
        _vram[i] = 0;
    }
}