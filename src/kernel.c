#include "kernel.h"

void kernel_main(void) {
    terminal_initialize();
    printk("%x", 0x42);
}