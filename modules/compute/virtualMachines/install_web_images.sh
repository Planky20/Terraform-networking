apt-get update -y && apt-get upgrade -y
apt-get install -y nginx
mkdir /var/www/html/images
echo "<h1> This is the images server $(hostname)</h1>" > /var/www/html/images/Default.html