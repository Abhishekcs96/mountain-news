#!/usr/bin/env bash


# Hardcode it all the first time

MOUNTAIN_NEWS="https://explorersweb.com/category/mountaineering/"

command="2>/dev/null curl https://explorersweb.com/category/mountaineering/ | pandoc -t markdown | grep -A1 -i -e '<div class="news-card">' | grep -v -e'<div class="news-card">' | grep -e "https://explorersweb.com/" | awk -F\" '{print $2}' | head -1 | xargs -I_ curl _ 2>/dev/null | grep --only-matching -e'<p>.*</p>' | ghead -n -3 | pandoc -f html -t markdown"
