#!/usr/bin/env bash

set -eu -o pipefail

show_help(){
    echo  "USAGE: $0 [-c value] [--help]"
    echo  "OPTIONS:"
    echo -e " -c       catergory of news (default is mountaineering), choose from:\n"
    echo -e "\t\tmountaineering\n\t\texpeditions\n\t\tpolar-exploration\n\t\tlong-distance-trekking\n\t\t8000ers"
    echo -e "\n--help   Display this help message"
    exit 1
}

DEFAULT_CATEGORY="mountaineering"

while getopts ":c:h" opt; do
    case $opt in
        c)
            DEFAULT_CATEGORY="${OPTARG}"
            ;;
        h)
            show_help 
            ;;
        \?)
            echo "Invalid option: ${OPTARG}" >&2 
            exit 1
            ;;
        :)
            echo "Option -${OPTARG} requires an argument" >&2 
            ;;
    esac
done   

LOWER_DEFAULT_CATEGORY="${DEFAULT_CATEGORY,,}"

case $LOWER_DEFAULT_CATEGORY in
    mountaineering)
        :
        ;;
    expeditions)
        :
        ;;
    polar-exploration)
        :
        ;;
    long-distance-trekking)
        :
        ;;
    8000ers)
        :
        ;;
    *)
        echo "Invalide choice...Exiting"
        exit 1
        ;;
esac

echo "Checking for news in category: ${LOWER_DEFAULT_CATEGORY}..."
echo

RANDOM_NUMBER="${RANDOM}" 
URL_FOR_NEWS="https://explorersweb.com/category/${LOWER_DEFAULT_CATEGORY}/"
PATTERN="${URL_FOR_NEWS%*/*/*/}"
COMMAND="$(2>/dev/null curl "${URL_FOR_NEWS}" \
    | pandoc -t markdown | grep -A1 -i -e '<div class="news-card">' \
    | grep -v -e'<div class="news-card">' | grep -e "${PATTERN}" \
    | awk -F\" '{print $2}')" 

pick_news(){
    NUMBER_PATTERN_1="^[0-9]$"
    NUMBER_PATTERN_2="^[0-9]{2}$"
    read -p "Enter the number for the article you would like to read " -n 2 -r
    echo
    # Check if it matches pattern , then continue next else just exit out
    [[ $REPLY =~ ${NUMBER_PATTERN_1} ]] || [[ $REPLY =~ ${NUMBER_PATTERN_2} ]] || echo "Pattern not matched..."
    cat "/tmp/news-${RANDOM_NUMBER}" | head -n "$REPLY" | tail -n 1 | awk -F'\t' '{print $NF}' | xargs -I{} -- 2>/dev/null curl {} | \
        grep --only-matching -e '<p>.*</p>' | ghead -n -3 | pandoc -f html -t markdown | less || \
        echo "Cannot find entered number..."

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
