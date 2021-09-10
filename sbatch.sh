#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=8
#SBATCH --partition=RT
#SBATCH --job-name=lammps_Legoshin
#SBATCH --comment="TSCM_Legoshin_lammps_obstacle_computing"

module load gcc/9.2.0
module load mpi/openmpi4-x86_64

rm -r -f dir_rad
rm radius.csv
rm Graph_Pressure_fr_Radius.png
rm data.pickle

mkdir dir_rad

for Radius in 2.00 2.20 2.40 2.60 2.80 3.00 3.20 3.40 3.60 3.80 3.90 3.95 4.00 4.05 4.10 4.15 4.20;
do
         mkdir dir_rad/rad_${Radius}
         cd dir_rad/rad_${Radius}
         cp ../../../in.obstacle ./
         mv in.obstacle in.obstacle_rad
         sed "s/RADIUS/$Radius/g" in.obstacle_rad > in.obstacle
         rm in.obstacle_rad
         srun ~/bin/lmp_mpi -in in.obstacle
         cd ../../
done

echo "#Radius Press_average" >> radius.csv

for Radius in 2.00 2.20 2.40 2.60 2.80 3.00 3.20 3.40 3.60 3.80 3.90 3.95 4.00 4.05 4.10 4.15 4.20;
do
         Press=$(awk -f ../awk.sh dir_rad/rad_${Radius}/log.lammps)
         echo "${Radius} ${Press}" >> radius.csv
done

curl -s -X POST https://api.telegram.org/bot1631575054:AAEXj4GLGSFEUcGJMmjimPmjnT45YLjbMOc/sendMessage -d chat_id=471817866 -d text="COMPUTATION DONE. RESULT."

echo "DONE"
