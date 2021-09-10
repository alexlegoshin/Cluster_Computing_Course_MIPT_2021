set terminal png
set output "Graph_Pressure_fr_Radius.png"

plot "radius.csv" u 2
set xlabel "Radius"
set ylabel "Average Pressure"
set title "Obstacle"
plot "Radius.txt" u 2 w l
