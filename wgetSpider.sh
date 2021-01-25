#!/bin/bash
HOME="https://${1}"
DOMAINS="${1}"
DEPTH=2
OUTPUT="./urls.txt"
SECONDS=0

wget -r --spider --delete-after --force-html -D "$DOMAINS" -l $DEPTH "$HOME" 2>&1 \
   | grep '^--' | awk '{ print $3 }' | grep '\.html$' | sort | uniq > $OUTPUT
cat $OUTPUT
AMOUNT=$(cat $OUTPUT | wc -l)
vim -c '%s/^\(.*\)$/"\1",/ | execute "normal! G$x" | execute "normal! gg" | execute "insert! \n[" | execute "normal! Go]" | write | quit' $OUTPUT
jq -c . < urls.txt > urls.min.json

PAYLOAD=$(<urls.min.json)
# do something with  ${PAYLOAD}

duration=$SECONDS
echo "took $(($duration / 60)) minutes and $(($duration % 60)) seconds to find ${AMOUNT} urls"
rm ${OUTPUT}
rm urls.min.json
