function logpid 
  printf " CPU  MEM\n"
  while true
    sleep 1;
    ps -p $argv -o pcpu= -o pmem=
  end
end
