#include <stdint.h>

#define VRAM_BASE 0x00010000
#define VIDEO_MAX_X 320
#define VIDEO_MAX_Y 240

void video_point(uint8_t *vram, uint32_t x, uint32_t y, uint8_t col);
void vide_clear(uint8_t *vram);