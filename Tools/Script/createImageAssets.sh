#!/bin/bash


Cyan='\033[0;36m'
Default='\033[0;m'

imageFilePath="$1"
jsonFilePath=""
imageNameArray=""
prefix=""

checkPrefix() {
    if test -n "$prefix"; then
        prefix=""$prefix"_"
    fi
    echo "Folder prefix is \"${prefix}\""
}

getImageFilePath() {
    if test -z "$imageFilePath"; then
        echo "Image File Path Invalid!"
        exit
    fi
}

getJsonFilePath() {
    cd "../Files"
    jsonFilePath="$(pwd)/Contents.json"
}

getImageNameArray() {
    imageNameArray=$(ls $imageFilePath)

    echo -e "\n${Default}================================================"
    for fileName in $imageNameArray
    do
    echo -e "  Image File Name  :  ${Cyan}${fileName}${Default}"
    done
    echo -e "${Default}================================================\n"
}

createAssets() {
    # echo -e "\n${Default}================================================"
    for fileName in $imageNameArray
    do
    folderName="${prefix}${fileName%@*}"
    # echo -e "  Folder Name  :  ${Cyan}${folderName}${Default}"
    folderPath="${targetFilePath}/${folderName}.imageset"
    imagePath="${imageFilePath}/${fileName}"
    mkdir -p $folderPath
    cp -f -r $jsonFilePath $folderPath
    cp -f -r $imagePath $folderPath
    done
    # echo -e "${Default}================================================\n"
}

configAssets() {
    assetsFolderArray=$(ls $targetFilePath)
    x2Image="2xfilename"
    x3Image="3xfilename"
    # echo -e "\n${Default}================================================"
    # echo -e "  2x Image Flag  :  ${Cyan}${x2Image}${Default}"
    # echo -e "  3x Image Flag  :  ${Cyan}${x3Image}${Default}"
    # echo -e "${Default}================================================\n"
    for assetsFolder in $assetsFolderArray
    do
    x2fileName="${assetsFolder%.*}@2x.png"
    x3fileName="${assetsFolder%.*}@3x.png"
    # echo -e "  2x Image File Name  :  ${Cyan}${x2fileName}${Default}"
    # echo -e "  3x Image File Name  :  ${Cyan}${x3fileName}${Default}"
    # echo -e "  target File Path  :  ${Cyan}"${targetFilePath}/${assetsFolder}/Contents.json"${Default}"
    sed -i '' s/${x2Image}/${x2fileName}/ ${targetFilePath}/${assetsFolder}/Contents.json
    sed -i '' s/${x3Image}/${x3fileName}/ ${targetFilePath}/${assetsFolder}/Contents.json
    if test -n "$prefix"; then
        sed -i '' s/${prefix}// ${targetFilePath}/${assetsFolder}/Contents.json
    fi
    done
}

echo '请输入文件夹前缀，可不填'
read prefix

checkPrefix

getImageFilePath

getJsonFilePath

cd $imageFilePath

getImageNameArray

targetFilePath="${imageFilePath}/assets"
mkdir -p $targetFilePath

echo "creating assets..."
createAssets
configAssets

echo -e "\n${Default}================================================"
echo -e "  Target Assets File Path  :  ${Cyan}${targetFilePath}${Default}"
echo -e "${Default}================================================\n"

open $targetFilePath
