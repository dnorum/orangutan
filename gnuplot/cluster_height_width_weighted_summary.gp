reset
set title 'Distribution of Overall Book Heights & Widths'
set xlabel 'Height [in]'
set ylabel 'Width [in]'
set timestamp # turn on a date/time indicator
set datafile separator ","
set term postscript
set pm3d map
set dgrid3d n, n
set palette color
set palette model RGB
set palette defined
set output DIR."/plots/cluster_".cluster."/plots/book_heights_widths_weighted_summary.ps"
splot DIR."/working/cluster_".cluster."/book_heights_widths_weighted_summary.csv" every ::1 using 1:2:3 with pm3d notitle