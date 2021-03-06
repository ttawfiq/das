
BEGIN { 

  if (ARGC < 2) { print "Usage: vm program"; exit 0; }

  exe = ARGV[1]; ARGV[1] = "";

  do { 
    r = getline < exe;

    if ($0 !~ /^[0-9]+$/) {
      print "fatal: illegal instruction:", $0; exit 1;
    }

    mem[i++] = $0;
  } while (r > 0);

  n = split("const get put ld st add sub jp jz j halt", x);
  for (i = 1; i <= n; ++i) op[x[i]] = i - 1;

  for (ip = 0; ip >= 0;) { # execution
    addr = mem[ip] % 1000; code = int(mem[ip++] / 1000);

    if (code == op["get"]) { getline r; }
    else if (code == op["put"]) { print r; }
    else if (code == op["st"]) { mem[addr] = r; }
    else if (code == op["ld"]) { r = mem[addr]; }
    else if (code == op["add"]) { r += mem[addr]; }
    else if (code == op["sub"]) { r -= mem[addr]; }
    else if (code == op["jp"]) { if (r > 0) ip = addr; }
    else if (code == op["jz"]) { if (r == 0) ip = addr; }
    else if (code == op["j"]) { ip = addr; }
    else if (code == op["halt"]) { ip = -1; }
    else { ip = -1; }
  }

  exit 0;
}
