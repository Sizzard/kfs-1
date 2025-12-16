NAME 		:= myos.bin

ISO 		:= myos.iso

SRC_DIR 	:= src/
OBJ_DIR		:= obj/

SRC 		:= 	kernel.c 	\
				tty.c 		\
				printk.c
				
OBJ 		:= $(SRC:%.c=$(OBJ_DIR)%.o)

BOOTER 		:= boot.s
BOOTER_OBJ 	:= boot.o

LINK 		:= linker.ld

CC 			:= i386-elf-gcc
CFLAGS		:= -std=gnu99 -ffreestanding -O2 -Wall -Wextra -fno-stack-protector -fno-pic -fno-pie


# export PREFIX="$HOME/opt/cross"
# export TARGET=i386-elf
# export PATH="$PREFIX/bin:$PATH"

all: $(NAME)

$(NAME) : $(OBJ_DIR)$(BOOTER_OBJ) $(OBJ)
	$(CC) -T linker.ld -o $(NAME) -ffreestanding -O2 -nostdlib \
	$(OBJ_DIR)$(BOOTER_OBJ) $(OBJ) -lgcc
	cp $(NAME) isodir/boot/$(NAME)
	grub-mkrescue -o $(ISO) isodir

$(OBJ_DIR)%.o:$(SRC_DIR)%.c kernel.h
	$(CC) $(CFLAGS) -I. -c -o $@ $< 

$(OBJ_DIR)$(BOOTER_OBJ):
	mkdir -p $(OBJ_DIR)
	nasm -felf32 $(SRC_DIR)$(BOOTER) -o $(OBJ_DIR)$(BOOTER_OBJ)


clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -rf $(NAME) $(ISO) isodir/boot/$(NAME)

re: fclean all

.PHONY: assemble link all clean fclean re