#/bin/bash
# echo  require sed  cut  curl awk 
echo 'type the github link, link  from specific release <copy the url of the release title > , url ends with **tag/v2.9.0 :'
echo 'eg: >>>>>>>> https://github.com/siyuan-note/siyuan/releases/tag/v2.9.0 <<<<<<<<<<<'
read -r -p ':  ' link
#echo test data link="https://github.com/siyuan-note/siyuan/releases/tag/v2.9.0"
tag=$(echo $link |sed 's#https://##'|cut -d '/' -f 6)
link=$(echo $link |sed 's#https://##'|cut -d '/' -f 2,3)
echo "author/proj is $link   and tag is $tag"  


echo "-----wget download links ------"
echo ""
    d_link=$(curl -s https://api.github.com/repos/$link/releases/tags/$tag | cut -d : -f 2,3 | tr -d \"|grep release|grep -v '//api.'|grep -v 'repos'|grep -v '/tag/')
    #eg link shoud be  https://github.com/ginuerzh/gost/releases/download/v2.10.1/gost-darwin-amd64-2.10.1.gz

    mkdir_cmd="mkdir -p github_d/$link/$tag"
    echo "$mkdir_cmd"
    # append wget -c to download the file, specify the output directory
    for file in $d_link
        do
            echo "wget -c -P github_d/$link/$tag $file"
        done
    echo ""

echo "---done---"
