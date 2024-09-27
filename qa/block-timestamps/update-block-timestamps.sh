#!/usr/bin/env bash
#
# A script to extract block height and header timestamp for all blocks
# from a Bitcoin Core node via the REST interface.

HOST="http://127.0.0.1:48332"

GENESIS="00000000da84f2bafbbc53dee25a72ae507ff4914b867c565be350b0da8bf043"
NEXT_HASH=$GENESIS

while true ; do
  while read height time next;
  do
    echo "$height,$time"
    NEXT_HASH=$next
  done <<<$(curl --silent "$HOST/rest/headers/$NEXT_HASH.json?count=2000" | jq -rc '.[] |  ( (.height | tostring) + " " + (.time | tostring) + " " + .nextblockhash )')
  if [ -z $NEXT_HASH ]; then
	  break;
  fi
done
