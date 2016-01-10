reset
set title 'Distribution of Book Heights & Lengths (Widths)'
set xlabel 'Height [in]'
set ylabel 'Length (Width) [in]'
set timestamp # turn on a date/time indicator
set datafile separator ","
set term postscript
set pm3d map
set dgrid3d n, n
set palette color
set palette model RGB
set palette defined
set output DIR."/plots/book_heights_lengths.ps"
splot DIR."/working/book_heights_lengths.csv" every ::1 using 1:2:3 with pm3d notitle
