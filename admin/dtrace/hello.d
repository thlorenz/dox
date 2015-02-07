#!/usr/sbin/dtrace -s

#pragma D option quiet

dtrace:::BEGIN {
    printf("Hell of a world!\n");
    exit(0);
}
