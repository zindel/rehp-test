#!/bin/sh
set -e
rm -rf out
mkdir -p out

STDLIB="$(find `ocamlfind query stdlib` -name stdlib.cma | grep -v threads)"
TEST=$(find . -name 'Test.cmo')
MAIN=$(find . -name 'rehp_test.cmo')
js_of_ocaml --custom-header="$(cat js-template.js)" -o out $STDLIB
js_of_ocaml --custom-header="$(cat js-template.js)" -o out/Test.js $TEST
js_of_ocaml --custom-header="$(cat js-template.js)" -o out/index.js $MAIN

# Test.js requires List_.js (not List.js as one would expect)
rm -rf out/List_.js
ln -s "$(pwd)/out/List.js" "$(pwd)/out/List_.js"

# this is needed to make Pervasives.js happy
echo "module.exports={};" > out/End_of_file.js
echo "module.exports={};" > out/Assert_failure.js
echo "module.exports={};" > out/Sys_error.js
echo "module.exports={};" > out/Failure.js
echo "module.exports={};" > out/Invalid_argument.js
echo "module.exports={};" > out/Not_found.js

# required Node.js libs are mocked to an empty module
fpack --dev \
    --no-cache \
    --mock=child_process: \
    --mock=constants: \
    --mock=fs: out/index.js
