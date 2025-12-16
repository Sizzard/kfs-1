#include "kernel.h"

void putnbr(uint32_t nb, const char *base, uint8_t base_len) {
    char result[16] = {0};

    int8_t i = 0;
    
    while(nb > 0) {
        result[i] = base[nb % base_len];
        nb /= base_len;
        i++;
    }
    i--;
    while(i != -1) {
        terminal_putchar(result[i]);
        i--;
    }
}

void printk_loop(const char *data, va_list args) {
    for(size_t i = 0; data[i]; i++) {
        if (data[i] == '%') {
            if (data[i + 1] == 'd' || data[i + 1] == 'i') {
                putnbr(va_arg(args, uint32_t),"0123456789", 10);
            }
            else if (data[i + 1] == 'x') {
                putnbr(va_arg(args, uint32_t),"0123456789abcdef", 16);
            }
            else if (data[i + 1] == 'X') {
                putnbr(va_arg(args, uint32_t),"0123456789ABCDEF", 16);
            }
            else if (data[i + 1] == 's') {
                terminal_writestring(va_arg(args, char *));
            }
            else if (data[i + 1] == 0) {
                return;
            }
            else {
                terminal_putchar(data[i + 1]);
            }
            i++;
        }
        else {
            terminal_putchar(data[i]);
        } 
    }
}

void printk(const char *data, ...) {
    va_list args;

    va_start(args, data);
    printk_loop(data, args);
    va_end(args);
    return;
}