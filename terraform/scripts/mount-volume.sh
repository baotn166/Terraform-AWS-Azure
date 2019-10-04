sudo mkdir -p /data
volumes=($5)
for i in "${volumes[@]}"
do
        echo "This is volume $i"
        sudo mkdir -p /data$i | true
        yes | sudo mkfs.ext4 $i
        echo "mount $i /data$i"
        sudo mount $i /data$i
done

echo "Syncing files..."
sudo AWS_ACCESS_KEY_ID="$2" AWS_SECRET_ACCESS_KEY="$3" AWS_DEFAULT_REGION="$4" aws s3 sync /data s3://$1/data
echo "Done"