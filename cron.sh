#!/bin/sh

telegram_chat_id="471817866"
telegram_bot_token="1631575054:AAEXj4GLGSFEUcGJMmjimPmjnT45YLjbMOc"
touch list_slurm.txt
id_list_old=$(awk '{print $1}' list_slurm.txt)
id_list_new=$(squeue -o "%.18i %.9P %j %u %.2t %.10M %.6D %R" |
grep studtscm06 | awk '{print $1}')
# Finished
for ids in ${id_list_old}
do
if [ $( echo ${id_list_new} | grep -c $ids) = 0 ]; then
echo "Finished: $ids"
task_info=$(awk -v id=$ids '{if ($1==id){print}}' list_slurm.txt)
partition=$(echo $task_info | awk '{print $2}')
name=$(echo $task_info | awk '{print $3}')

node=$(echo $task_info | awk '{print $8}')
curl \
-d parse_mode=HTML \
-d chat_id=${telegram_chat_id} \
-d disable_notification=True \
-d text="<b> FINISHED </b>: %0A \
<b><i>Name:</i> $name </b> %0A \
<b><i>Partition:</i></b> $partition %0A \
<b><i>Node:</i></b> $node %0A" \
-s -X POST \
https://api.telegram.org/bot${telegram_bot_token}/sendMessage

gnuplot ../gnuplot.sh

curl -s -X POST \
https://api.telegram.org/bot1631575054:AAEXj4GLGSFEUcGJMmjimPmjnT45YLjbMOc/sendPhoto \
-F chat_id=471817866 -F photo="@Graph_Pressure_fr_Radius.png"

fi
done
# Started
for ids in ${id_list_new}
do
if [ $( echo ${id_list_old} | grep -c $ids) = 0 ]; then
echo "Started: $ids"
task_info=$(squeue -o "%.18i %.9P %j %u %.2t %.10M %.6D %R" |
grep studtscm06 | awk -v id=$ids '{if ($1==id){print}}')
partition=$(echo $task_info | awk '{print $2}')
name=$(echo $task_info | awk '{print $3}')
node=$(echo $task_info | awk '{print $8}')
curl \
-d parse_mode=HTML \
-d chat_id=${telegram_chat_id} \
-d disable_notification=True \
-d text="<b> STARTED </b>: %0A \
<b><i>Name:</i> $name </b> %0A \
<b><i>Partition:</i></b> $partition %0A \
<b><i>Node:</i></b> $node %0A" \
-s -X POST \
https://api.telegram.org/bot${telegram_bot_token}/sendMessage
fi
done
squeue -o "%.18i %.9P %j %u %.2t %.10M %.6D %R" |
grep studtscm06 > list_slurm.txt
