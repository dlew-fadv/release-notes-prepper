#!/bin/sh

if [[ ! $# -eq 3 ]] ; then
    echo Usage $0 REPO_DIR TAG_FROM TAG_TO
    exit 1
fi

TAG_FROM=$2
TAG_TO=$3
REPO_DIR=$1

# git --git-dir=$REPO_DIR/.git co main
# git --git-dir=$REPO_DIR/.git pull
array=()

# git log using § as separator
git --git-dir=$REPO_DIR/.git log --pretty=format:'%h§%d§%s§%cr§%an' --abbrev-commit  $TAG_FROM..$TAG_TO | while IFS= read -r line ; do
    #third field is the commit message
    cmt_msg=$(echo $line | cut -f3 -d "§")

    #check if the commit message contains a ticket number
    [[ $cmt_msg =~ ^.*\[AB#([0-9]{6})\].*$ ]]
    if [[ ${BASH_REMATCH[1]} ]]; then
        ticketNum="#${BASH_REMATCH[1]}"
        if [[ ${array[@]} =~ $ticketNum ]]; then # find duplicated tickets
            a=1 # do nothing
        else
            array[${#array[@]}]=$ticketNum
            echo $ticketNum
        fi
    else
        # no ticket number found, print commit message and author - Shame on you $author!
        author=$(echo $line | cut -f5 -d "§")
        echo "!! commit msg [$cmt_msg] by [$author]"
    fi
done