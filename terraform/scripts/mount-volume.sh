volume=`lsblk | awk 'NR > 3 {print $1}'`
read -a volumes <<< $volume
for i in "${volumes[@]}"
do
        echo This is volume $i
        mkdir /data/$i | true
        sudo mkfs.ext4 /dev/$i
        echo mount /dev/$i /data/$i
        sudo mount /dev/$i /data/$i
done
aws s3 sync /data s3://$1/
