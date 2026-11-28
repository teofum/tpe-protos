#!/bin/bash

for t in ./build/test/*; do
  echo "-> $t"
  $t || exit 1
done
