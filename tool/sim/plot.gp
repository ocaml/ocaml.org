# Timeline of one sim run. Usage: gnuplot -e "dir='tool/sim/out/<run>'" plot.gp
# (`sim plot DIR` does this after recomputing the summaries.)

if (!exists("dir")) dir = "."
set terminal svg size 1400,1300 dynamic font "sans,11" background "white"
set output dir."/timeline.svg"
set datafile separator ","
set key top left horizontal font ",9"
set grid
set lmargin 12
set rmargin 4
# One x range for every panel: the run length, from the 1 Hz samples.
stats dir."/resources.csv" using 1 skip 1 nooutput
set xrange [0:STATS_max]

# Update windows (update -> saved) as shaded bands on every panel; windows.gp
# is written by `sim summary`.
load dir."/windows.gp"

set multiplot layout 5,1 title "ocaml.org server simulation — shaded: package-state update (update → saved)"

set ylabel "memory (MB)"
set format x ""
plot dir."/resources.csv" using 1:2 skip 1 with lines lw 2 lc rgb "#1f77b4" title "cgroup memory.current", \
     ""                   using 1:4 skip 1 with lines lc rgb "#2ca02c" title "anon", \
     ""                   using 1:6 skip 1 with lines lc rgb "#d62728" title "server RSS", \
     dir."/gc.csv"        using 1:8 skip 1 with lines dt 2 lc rgb "#9467bd" title "OCaml major heap"

set ylabel "CPU (% of a core)"
plot dir."/resources.csv" using 1:8 skip 1 with lines lc rgb "#ff7f0e" title "container CPU"

set ylabel "GC pause (ms)"
set logscale y
plot dir."/gc-events.csv" using 1:(strcol(2) eq "minor" ? $3 : 1/0) skip 1 with points pt 7 ps 0.2 lc rgb "#8c564b" title "minor GC", \
     ""                   using 1:(strcol(2) eq "major" ? $3 : 1/0) skip 1 with points pt 7 ps 0.3 lc rgb "#e377c2" title "major slice"

set ylabel "latency (ms)"
plot for [s in "human bot"] dir."/latency-".s.".csv" using 1:8 skip 1 with lines lw 2 title s." p99", \
     for [s in "human bot"] dir."/latency-".s.".csv" using 1:5 skip 1 with lines dt 2 title s." p50"
unset logscale y

set ylabel "requests / 5 s"
set xlabel "time since start (s)"
set format x "%g"
plot for [s in "human bot"] dir."/latency-".s.".csv" using 1:2 skip 1 with steps title s." sent", \
     for [s in "human bot"] dir."/latency-".s.".csv" using 1:($3+$4) skip 1 with impulses lw 3 title s." errors+drops", \
     dir."/feed.csv" using 1:(0) skip 1 with points pt 9 ps 0.8 lc rgb "black" title "upstream advanced"

unset multiplot
