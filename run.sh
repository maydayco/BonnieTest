#./Bonnie -s 50M -d /tmp -m T1 | awk '$1=="T1" {print $5,$11,$13}' >> res

# Using one file, each time compare the current data to all the data in previous.
awk '{
  for(i = 1; i <= NF; i++)
  { 
  	min[i] || min[i] = $i;
	max[i] || max[i] = $i;
  	mins[i] || mins[i] = NR;
  	maxs[i] || maxs[i] = NR;
  	if ($i < min[i]) {min[i] = $i; mins[i] = NR} 
  	if ($i > max[i]) {max[i] = $i; maxs[i] = NR} 
  }
}
END {	
print "Test",NR,"(Current Test): Block Write:",$1,"m/s, Block Read:",$2,"m/s, Random Seek:",$3,"k/s";
print "Min Block Read:",min[1],"m/s in test",mins[1], "\nMax Block Read:",max[1],"m/s in test",maxs[1];
print "Min Block Write:",min[2],"m/s in test",mins[2], "\nMax Block Write:",max[2],"m/s in test",maxs[2];
print "Min Random Seek:",min[3],"k/s in test",mins[3], "\nMax Random Seek:",max[3],"k/s in test",maxs[3]}
' res 

# Using two files, one file for result, another for maximum and minimum value in previous. Just need to compare 3 lines of data. 
[ -f history ] && tail -q -n2 res history || tail -n2 res | awk ' {
  if (NR == 2) {print "Current Test: Block Write:",$1,"m/s, Block Read:",$2,"m/s, Random Seek:",$3,"k/s"}
  for(i = 1; i <= NF; i++)
  {	 
        min[i] || min[i] = $i;
        max[i] || max[i] = $i;
        if ($i < min[i]) {min[i] = $i} 
        if ($i > max[i]) {max[i] = $i} 
  }
}
END {
print "Min Block Read:",min[1],"m/s\nMax Block Read:",max[1],"m/s";
print "Min Block Write:",min[2],"m/s\nMax Block Write:",max[2],"m/s";
print "Min Random Seek:",min[3],"k/s\nMax Random Seek:",max[3],"k/s";
print min[1],min[2],min[3] > "history";
print max[1],max[2],max[3] >> "history";
}
'



