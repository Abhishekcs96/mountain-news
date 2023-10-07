#!/usr/bin/env bash

set -eu -o pipefail

URL_FOR_NEWS="https://explorersweb.com/category/mountaineering/"
PATTERN="${URL_FOR_NEWS%*/*/*/}"
COMMAND="$(2>/dev/null curl "${URL_FOR_NEWS}" \
    | pandoc -t markdown | grep -A1 -i -e '<div class="news-card">' \
    | grep -v -e'<div class="news-card">' | grep -e "${PATTERN}" \
    | awk -F\" '{print $2}')" 
RANDOM_NUMBER="${RANDOM}" 

pick_news(){
    NUMBER_PATTERN_1="^[0-9]$"
    NUMBER_PATTERN_2="^[0-9]{2}$"
    read -p "Pick a number, dummy " -n 2 -r
    echo
    # Check if it matches pattern , then continue next else just exit out
    [[ $REPLY =~ ${NUMBER_PATTERN_1} ]] || [[ $REPLY =~ ${NUMBER_PATTERN_2} ]] || echo "Pattern not matched..."
    cat "/tmp/news-${RANDOM_NUMBER}" | head -n "$REPLY" | tail -n 1 | awk -F'\t' '{print $NF}' | xargs -I{} -- 2>/dev/null curl {} | \
        grep --only-matching -e '<p>.*</p>' | ghead -n -3 | pandoc -f html -t markdown | less || \
        echo "Cannot find number entered idiot...hahaha"

    rm "/tmp/news-${RANDOM_NUMBER}"
}

display_news(){
    declare -i COUNT
    COUNT=1
    while read -r LINE; do
        echo -e ""${COUNT}"\t"${LINE}"" | tee -a "/tmp/news-${RANDOM_NUMBER}"
        COUNT=$COUNT+1
    done < <(echo "${COMMAND}")
    pick_news
}

main(){
    display_news
}

main
