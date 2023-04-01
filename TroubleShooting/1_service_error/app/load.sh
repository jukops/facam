#!/bin/bash

DNS=$1
EPOCH=180

if [[ "${DNS}x" == "x" ]]; then
  echo "Please execute with argument"
  exit 1
fi

i=1
while [[ $i -le $EPOCH ]]; do
  echo "running $i/$EPOCH"
  for j in {1..2}; do
    # Foo
    curl -o /dev/null --silent -X GET "http://${DNS}/foo/profile?guid=abcd0001" &
    curl -o /dev/null --silent -X GET "http://${DNS}/foo/profile?guid=abcd0002" &
    curl -o /dev/null --silent -X PUT "http://${DNS}/foo/profile?guid=abcd0003" &
    curl -o /dev/null --silent -X POST "http://${DNS}/foo/profile" &
    curl -o /dev/null --silent -X PUT "http://${DNS}/foo/profile" &
    curl -o /dev/null --silent -X POST "http://${DNS}/foo/profile" &
  
    # Bar
    curl -o /dev/null --silent -X GET "http://${DNS}/bar/product?guid=az1asdf42xcas12a1" & 
    curl -o /dev/null --silent -X GET "http://${DNS}/bar/product?guid=9q122a2d3x31x3xa13" &
    curl -o /dev/null --silent -X POST "http://${DNS}/bar/product" &
    curl -o /dev/null --silent -X GET "http://${DNS}/bar/purchase?guid=axxs" &
    curl -o /dev/null --silent -X POST "http://${DNS}/bar/purchase" &
    curl -o /dev/null --silent -X PUT "http://${DNS}/bar/purchase" &
  done
  sleep 1
  ((i = i + 1))
done

echo "done"
