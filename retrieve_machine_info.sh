#!/bash/bin

server_make=$(dmidecode -t 1 | grep 'Manufacturer' | awk 'BEGIN { FS = ":" } ; {print $2}')
server_model=$(dmidecode -t 1 | grep 'Product Name' | awk 'BEGIN { FS = ":" } ; {print $2}')
serial_number=$(dmidecode -t 1 | grep 'Serial Number' | awk 'BEGIN { FS = ":" } ; {print $2}')
os_info=$(lsb_release -a | grep 'Description' | awk 'BEGIN { FS = ":" } ; {print $2}')
cpu_model=$(dmidecode -t 4 | grep 'Version' | awk 'BEGIN {FS = ":"}; !visited[$2]++')
number_of_cores=$(dmidecode -t 4 | grep 'Core Count' | awk 'BEGIN { FS = ":" } !visited[$2]++')
memory=$(dmidecode -t 17 | grep "Size.*GB" | awk '{s+=$2} END {print s " GB"}')
disk_sda=$(lshw -class disk | grep 'logical name' | awk 'BEGIN { FS = ":"} ; {print $2}')
disk_model=$(lshw -class disk | grep 'product' | awk 'BEGIN { FS = ":"} ; {print $2}')
disk_capacity=$(lshw -class disk | grep 'capacity' | awk 'BEGIN { FS = ":"} ; {print $2}')

echo "Server Make: $server_make" | xargs
echo "Server Model: $server_model" | xargs
echo "Serial Number: $serial_number" | xargs
echo "OS: $os_info" | xargs
echo "$cpu_model" | xargs 
echo "$number_of_cores" | xargs
echo "Memory: $memory" | xargs
echo "Disk1: $disk_sda" | xargs
echo "Disk1: $disk_model" | xargs
echo "Disk1: $disk_capacity" | xargs
