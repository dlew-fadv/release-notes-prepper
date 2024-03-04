#!/bin/sh

if [[ ! $# -eq 3 ]] ; then
    echo Usage $0 REPO_DIR TAG_FROM TAG_TO
    exit 1
fi

TAG_FROM=$2
TAG_TO=$3
REPO_DIR=$1

git --git-dir=$REPO_DIR/.git log --pretty=format:'%h§%d§%s§%cr§%an' --abbrev-commit  $TAG_FROM..$TAG_TO | while IFS= read -r line ; do
    cmt_msg=$(echo $line | cut -f3 -d "§")
    # echo $cmt_msg
    
    [[ $cmt_msg =~ ^.*\[AB#([0-9]{6})\].*$ ]]
    if [[ ${BASH_REMATCH[1]} ]]; then
        echo "#${BASH_REMATCH[1]}";
    else
        author=$(echo $line | cut -f5 -d "§")
        echo "!! commit msg [$cmt_msg] by [$author]"
    fi
done