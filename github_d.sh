#!/bin/bash


get_tags() {
    echo "$1"| awk -F '[/:]' '/"browser_download_url":/ {print $(NF-1)}' | uniq -c
}

get_download_links() {
    echo "$1" | awk -F '[/:]' '/"browser_download_url":/ {print $(NF-1)}' | uniq -c | head -n "$2" | awk '{print $2}'
}


echo 'Type the GitHub link, link from any page is accepted :'
echo 'eg: https://github.com/MatsuriDayo/plugins/releases'
read -r -p ':  ' link
link=$(echo $link |sed 's#https://##'|cut -d '/' -f 2,3)
echo "Author/Project is $link"
full_link="https://api.github.com/repos/$link/releases"
echo "Full link is $full_link"

# Save the API response to a variable
api_response=$(curl -s "$full_link")
all_tags_with_count=$(get_tags "$api_response")


# Save the original IFS
OIFS="$IFS"
# Change IFS to newline
IFS=$'\n'

echo "!!!if no tags are shown, please check api limit, use your own token or proxy!!!"
echo "------------tags --------------------"
# append index to each tag
count=1
for tag in $all_tags_with_count
do
    echo  "$count $tag"
    count=$((count+1))
done
IFS="$OIFS"
count=$((count-1))



echo "How many tags you want to download???"
read -r -p ':  ' num
while ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -gt "$count" ] || [ "$num" -lt 1 ]
do
    echo "Please input a number between 1 and $count"
    read -r -p ':  ' num
done
echo "You want to download $num tags"
echo "Tags are:"
get_download_links "$api_response" "$num"

echo "-----wget download links ------"
echo ""
for tag in $(get_download_links "$api_response" "$num")
do
    d_link=$(curl -s https://api.github.com/repos/$link/releases/tags/$tag | cut -d : -f 2,3 | tr -d \"|grep release|grep -v '//api.'|grep -v 'repos'|grep -v '/tag/')
    #eg link shoud be  https://github.com/ginuerzh/gost/releases/download/v2.10.1/gost-darwin-amd64-2.10.1.gz

    mkdir_cmd="mkdir -p github_d/$link/$tag"
    echo "$mkdir_cmd"
    # append wget -c to download the file, specify the output directory
    for file in $d_link
        do
            echo "wget -c -P github_d/$link/$tag $file"
        done
        #echo "wget -c -P $link/$tag $file"
    #echo "$d_link"
    echo ""
done
echo "-----------"
