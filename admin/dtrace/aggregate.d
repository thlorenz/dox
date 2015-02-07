#!/usr/sbin/dtrace -s

#pragma D option quiet

syscall::write:return 
  /pid == $1/ {
   @minw = min(arg0);
   @maxw = max(arg0);
   @avgw = avg(arg0);
}

END {
   printa("Writes: min: %@d max: %@d avg: %@d\n", @minw, @maxw, @avgw);
}
