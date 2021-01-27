#include <stdint.h>

uint8_t numbers1[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
const uint8_t numbers2[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

uint8_t get_numbers1(uint8_t index) {
    return numbers1[index];
}
uint8_t get_numbers2(uint8_t index) {
    return numbers2[index];
}

uint32_t mips_main() {
    return 0;
}
