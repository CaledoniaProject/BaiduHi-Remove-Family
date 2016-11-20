#!/bin/bash

set -e

source=/Applications/百度Hi.app/Contents/MacOS/BaiduHi

if [[ ! -f $source ]]; then 
    echo 没有安装百度Hi~ 
    exit
fi

echo '[+] 备份中 ..'
if [[ ! -f "${source}.old" ]]; then
    cp $source{,.old}
fi

file="${source}.old"
out="${source}"

# Retrieve file offset
offset=$(nm "$file" | grep 'UIManager checkUpdate' | awk '{print $1}' | head -1)
offset=${offset##0000000100}

if [[ -z "$offset" ]]; then
    echo Crap, unable to locate function address
    exit 1
else
    offset="0x${offset}"
    echo "[+] Found FO $offset" 
fi

echo "[+] Modify byte"
dd if="$file" of="$out"
printf '\xc3' | dd of="$out" conv=notrunc bs=1 seek=$(($offset))

echo "[+] Done"


