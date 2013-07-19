# google blogger post script
# CHHY
# 2013.07.13
if [ $# -eq 0 ];then
    echo "google blogger post helper"
    echo "Usage:  "
    echo "       -f normal filename"
    echo "       -of org-mode filename"
    exit 1
else
    if [  "$1" != "-f" ] && \
       [  "$1" != "-of" ] ;then
	echo "Usage:  "
	echo "       -f normal filename"
	echo "       -of org-mode filename"
	exit 1
    fi
fi

option=$1

# normal file
if [ "$option" == "-f" ] && [ $# -eq 2 ];then
    file=$2
    if [ ! -f "$file" ];then
	echo " no such file : $file"
	exit 1
    fi
    Blogger=$(cat "$file")
    read -p "Title: " Title
    read -p "Tags: " Tags
fi # end of option -f

# org-mode file
if [ "$option" == "-of" ] && [ $# -eq 2 ];then
    file=$2
    if [ ! -f "$file" ];then
	echo " no such file : $file"
	exit 1
    fi
    Blogger=$(cat "$file")
    FirstLine=$(echo "$Blogger" | sed -n 1p)
    if [ $(echo "$FirstLine" | grep -c ":") -eq 0 ];then
	echo "should have tags"
	exit 1
    fi

    # 消除tags 部分的 ":" 符号
    temp=$(echo "$FirstLine" | sed -e 's/*//' | sed -e 's/:/,/')
    FirstLine=$temp
    Title=$(echo "$FirstLine" | awk -F awk -F ',' '{print $1}')
    Tags=$(echo "$FirstLine" | awk -F ',' '{print $2}' | sed -e 's/:/,/g')
fi # end of option -of

line=$(echo "$Blogger" | wc -l)
if [ "$option" == "-of" ];then
    Contents=$(echo "$Blogger" | sed -n 2,"$line"p)
	tmp=$(echo ${Tags%,*})
	Tags="$tmp"
else
    Contents=$(echo "$Blogger" | sed -n 1,"$line"p)
fi

echo "Title == $Title"
echo "Tags == $Tags"

google blogger post -u rex.yecheng@gmail.com --title "$Title" --tags "$Tags" --src "$Contents"
echo "post $Title with $Tags successful"
echo "$Contents" > /tmp/blogger
mv /tmp/blogger ~/Documents/blogger/"$Title"
echo "cp $Title to ~//Documents//blogger"