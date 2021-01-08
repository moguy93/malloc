# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: moguy <marvin@42.fr>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/08 19:25:39 by moguy             #+#    #+#              #
#    Updated: 2021/01/08 19:25:39 by moguy            ###   ########.fr        #
#                                                                             #
# **************************************************************************** #

############################## HOST ############################################

ifeq ($(HOSTTYPE),)
	HOSTTYPE := $(shell uname -m)_$(shell uname -s)
endif

############################## VAR #############################################

CC = gcc

CFLAGS = -g -Wall -Wextra -Werror

LDFLAGS = -shared

NAME = libft_malloc.so

HOSTLIB = libft_malloc_$(HOSTTYPE).so

SRC =	malloc.c \
		free.c \
		realloc.c 

SRCDIR = srcs/

OBJDIR = objs

INCLUDES = libft/libft.h includes/malloc.h

OBJ = $(addprefix $(OBJDIR)/, $(SRC:.c=.o))

LIB = -Llibft -lft

INCL = -I libft -I includes

############################## COLORS ##########################################

BY = "\033[33;1m"
BR = "\033[31;1m"
BG = "\033[32;1m"
BB = "\033[34;1m"
BM = "\033[35;1m"
BC = "\033[36;1m"
BW = "\033[37;1m"
Y = "\033[33m"
R = "\033[31m"
G = "\033[32m"
B = "\033[34m"
C = "\033[36m"
M = "\033[35m"
KW = "\033[37;5m"
KR = "\033[31;5m"
KG = "\033[32;5m"
KB = "\033[34;5m"
X = "\033[0m"
UP = "\033[A"
CUT = "\033[K"

############################## RULES ###########################################

all: ${NAME}
	@echo ${G}Success"   "[${NAME}]${X}

libft/%:
	@make -C libft

${NAME}: ${HOSTLIB}
	@echo ${C}Linking"   "[${HOSTLIB}]...${X}
	@ln -fs ${HOSTLIB} ${NAME}

${HOSTLIB}: ${OBJ} ${INCLUDES} libft/libft.a
	@echo ${B}Compiling [${HOSTLIB}]...${X}
	@${CC} ${LDFLAGS} ${LIB} ${INCL} -o $@ ${OBJ}

${OBJDIR}/%.o: ${SRCDIR}%.c ${INCLUDES} libft/libft.a
	@echo ${Y}Compiling [$@]...${X}
	@/bin/mkdir -p ${OBJDIR}
	@${CC} ${CFLAGS} ${INCL} -c -o $@ $<
	@printf ${UP}${CUT}

clean:
	@echo ${R}Cleaning"  "[libft objs]...${X}
	@make -C libft/ clean
	@echo ${R}Cleaning"  "[objs]...${X}
	@/bin/rm -Rf ${OBJDIR}

fclean: clean
	@make -C libft/ fclean
	@echo ${R}Cleaning"  "[${NAME}]...${X}
	@/bin/rm -f ${NAME}
	@/bin/rm -f ${HOSTLIB}

test: libft/libft.a ${NAME}
	@${CC} ${INCL} ${LIB} test.c -o test
	@./run.sh ./test

bench: libft/libft.a ${NAME}
	@${CC} ${INCL} ${LIB} test.c -o test
	@./run.sh /usr/bin/time -l ./test

re: fclean all

.PHONY: all clean fclean re test test
