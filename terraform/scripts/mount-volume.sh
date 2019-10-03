sudo mkdir -p /dev
# volume=`lsblk | sort | awk 'NR > 3 {print $1}'`
volume="$5"
read -a volumes <<< $volume
for i in "${volumes[@]}"
do
        echo This is volume $i
        sudo mkdir -p $i | true
        yes | sudo mkfs.ext4 $i
        echo mount $i $i
        sudo mount $i $i
done
AWS_ACCESS_KEY_ID="$2" AWS_SECRET_ACCESS_KEY="$3" AWS_DEFAULT_REGION="$4" aws s3 sync /dev s3://$1/
