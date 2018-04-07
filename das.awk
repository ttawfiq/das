
BEGIN {

  if (ARGC < 2) { print "Usage: das program.das"; exit 0; }

  src = ARGV[1]; sub(/\..*/,"",ARGV[1]); 
  exe = ARGV[1]; obj = exe ".o"; ARGV[1] = "";

  n = split("const get put ld st add sub jp jz j halt", x);
  for (i = 1; i <= n; ++i) op[x[i]] = i - 1;

  FS = "[ \t]+"; # first pass
  while (getline < src > 0) {
    if ($0 ~ /^[ \t]*#/ || $0 ~ /^[ \t]*$/) continue;
    human[c++] = $0; sub(/\#.*/, ""); sym[$1] = nextmem;
    if ($2 != "") { print $2 "\t" $3 > obj; ++nextmem; }
  }

  close(obj);

  nextmem = c = 0; # second pass
  while (getline < obj > 0) {
    if ($2 !~ /^[0-9]*$/) { $2 = sym[$2]; }
    mem[nextmem++] = 1000 * op[$1] + $2; 
    printf "%4d:  %05d  %s\n", c, mem[c], human[c]; ++c;
  }

  e = --c;

  for (c = 0; c <= e; ++c) print mem[c] > exe
  system("chmod 0755 " exe);
}

