#!/usr/sbin/dtrace -s

#pragma D option quiet

io:::done {
   printf("%d bytes : %s\n",
          args[0]->b_bcount,
          (args[2]->fi_pathname == "<none>")
           ? args[1]->dev_pathname
           : args[2]->fi_pathname);
}

