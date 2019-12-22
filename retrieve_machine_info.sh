#!/bin/bash

server_make=$(dmidecode -t 1 | grep 'Manufacturer' | awk 'BEGIN { FS = ":" } ; {print $2}')
server_model=$(dmidecode -t 1 | grep 'Product Name' | awk 'BEGIN { FS = ":" } ; {print $2}')
serial_number=$(dmidecode -t 1 | grep 'Serial Number' | awk 'BEGIN { FS = ":" } ; {print $2}')
os_info=$(lsb_release -a | grep 'Description' | awk 'BEGIN { FS = ":" } ; {print $2}')
cpu_model=$(dmidecode -t 4 | grep 'Version' | awk '!visited[$2]++' | awk 'BEGIN {FS = ":"}; {print $2}')
number_of_cores=$(dmidecode -t 4 | grep 'Core Count' | awk '!visited[$2]++' | awk 'BEGIN {FS = ":"}; {print $2}')
memory=$(dmidecode -t 17 | grep "Size.*GB" | awk '{s+=$2*1024} END {print s " MB"}')

echo "Server Make: $server_make" | xargs
echo "Server Model: $server_model" | xargs
echo "Serial Number: $serial_number" | xargs
echo "OS: $os_info" | xargs
echo "CPU Model: $cpu_model" | xargs 
echo "Number of Cores: $number_of_cores" | xargs
echo "Memory: $memory" | xargs

number_of_disks=$(lshw | grep -c disk)
echo "Number of Disks: $number_of_disks" | xargs

disk_info=$(lshw -class disk | grep 'logical name\|product\|capacity' | awk 'BEGIN {FS = ":"} ; {print $2}')
#echo $disk_info

counter=0
disk_number=1
disk1=""

for i in $disk_info
    do
	counter=$((counter+1))

	if [ $counter -eq 1 ]; then
		disk1=$i

	elif [ $counter -eq 2 ]; then
		echo "Disk $disk_number: $disk1 $i" | xargs
		disk1=""

	elif [ $counter -eq 3 ]; then
		IFS='/'
	       	read -ra ADDR <<< "$i"
		
		for j in "${ADDR[@]}"; do
			counter1=$((counter1+1))

			if [ $counter1 -eq 3 ]; then
				echo "Disk $disk_number Model: $j" | xargs
			fi
		done

		counter1=0
		
	elif [ $counter -eq 5 ]; then	
		result=$(echo $i | cut -d "(" -f2 | cut -d ")" -f1)
		echo "Disk $disk_number Capacity: $result" | xargs

		counter=0
		disk_number=$((disk_number+1))
        fi	 
done

#echo $counter

#disk_sda=$(lshw -class disk | grep 'logical name' | awk 'BEGIN {FS = "/"} ; {print $3}')
#disk_model=$(lshw -class disk | grep 'product' | awk 'BEGIN { FS = ":"} ; {print $2}')
#disk_capacity=$(lshw -class disk | grep 'capacity' | awk 'BEGIN { FS = ":"} ; {print $2}')

#echo "Disk1: $disk_sda" | xargs
#echo "Disk1 Model: $disk_model" | xargs
#echo "Disk1 Capacity: $disk_capacity" | xargs
