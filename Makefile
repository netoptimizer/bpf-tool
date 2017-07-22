#
# Copyright (C) 2014 Jakub Kicinski <kubakici@wp.pl>
# Copyright (C) 2017 Netoronome Systems, Inc.
#
# This software is dual licensed under the GNU General License Version 2,
# June 1991 as shown in the file COPYING in the top-level directory of this
# source tree or the BSD 2-Clause License provided below.  You have the
# option to license this software under the complete terms of either license.
#
# The BSD 2-Clause License:
#
#     Redistribution and use in source and binary forms, with or
#     without modification, are permitted provided that the following
#     conditions are met:
#
#      1. Redistributions of source code must retain the above
#         copyright notice, this list of conditions and the following
#         disclaimer.
#
#      2. Redistributions in binary form must reproduce the above
#         copyright notice, this list of conditions and the following
#         disclaimer in the documentation and/or other materials
#         provided with the distribution.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

CC := gcc
CFLAGS = -std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow
LIBS = -lelf -lbpf -lelf

include $(wildcard *.d)

all: bpf

bpf: bpf.o bpf-map.o bpf-prog.o
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -rf *.o *.d *~

%.o: %.c
	$(COMPILE.c) -MMD -o $@ $<

.PHONY = all clean
.DEFAULT_GOAL = all
