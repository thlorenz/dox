#!/usr/sbin/dtrace -s

#pragma D option quiet

BEGIN {
   beginsec = timestamp / 1000000000;
   i = 0;
}

syscall::write:entry /pid == $1/ {
  nowsec = timestamp / 1000000000;
  @TimeDistWrite = lquantize(nowsec - beginsec, 1, 60, 1);
}

profile:::tick-1sec /i++ >= 59/ {
  exit(0);
}

