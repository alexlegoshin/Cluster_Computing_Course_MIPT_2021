BEGIN{
sum_press=0
count=0
read_flag=0 
}

{if (($6=="Press")&&($1=="Step"))
{
    read_flag=1
}

if ($1==(count+1)*1000)
{
    read_flag=1
}

if (read_flag==1)
{
    sum_press=$6+sum_press 
    count=1+count
    read_flag=0     
}}

END{
print sum_press/count
}

