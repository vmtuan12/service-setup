node_ips=("192.168.56.65" "192.168.56.66" "192.168.56.67")
port="5432"
username="postgres"
password="postgres"
database="postgres"

master_id_down=1

available_nodes=()

while true; do
    for i in "${node_ips[@]}"
    do
        pg_isready -h $i -p $port -U $username -d $database > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            current_time=$(date +"%Y-%m-%d %H:%M:%S")
            echo "$current_time - $i IS DOWN" > node_down.txt
            continue
        fi

        available_nodes=("${available_nodes[@]}" "$i")
        check=$(ssh vagrant@"$i" "/home/vagrant/test.sh")

        if [ "$check" == "True" ]; then
            echo "$i is a slave"
        else
            echo "$i is master"
            master_id_down=0
        fi

    done

    if [[ $master_id_down -ne 0 ]]; then
        echo "Master is down. Start election..."
        master_ip="${available_nodes[0]}"
        slaves=""

        for ((i = 1; i < ${#available_nodes[@]}; i++)); do
            slaves="${slaves} ${available_nodes[$i]}"
        done

        ssh vagrant@"$master_ip" "/home/vagrant/slave_to_master.sh $slaves"

        for ((i = 1; i < ${#available_nodes[@]}; i++)); do
            ssh vagrant@"${available_nodes[$i]}" "/home/vagrant/slave_new_master.sh $master_ip ${available_nodes[$i]}"
        done
    fi

    sleep 60
done