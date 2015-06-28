#!/bin/bash

for fmt in html singlehtml; do
    sphinx-build -b $fmt ./source ./build/$fmt
done

