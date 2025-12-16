#include "kernel.h"

void kernel_main(void) {
    terminal_initialize();
    printk("Salut", 0x42);
}