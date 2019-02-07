#!/bin/sh
set -e
rm -rf out
mkdir -p out

JSLIB="$(esy ocamlfind query js_of_ocaml)/js_of_ocaml.cma"
STDLIB="$(find `ocamlfind query stdlib` -name stdlib.cma | grep -v threads)"
TEST=$(find . -name 'Test.cmo')
MAIN=$(find . -name 'rehp_test.cmo')
js_of_ocaml --custom-header="$(cat js-template.js)" -o out $STDLIB
js_of_ocaml --custom-header="$(cat js-template.js)" -o out/Test.js $TEST
js_of_ocaml --custom-header="$(cat js-template.js)" -o out/index.js $MAIN

# Copy rehack runtime
if [ ! -d ./rehp ]; then
    git clone git@github.com:zindel/rehp.git
fi
cp ./rehp/runtime/rehack/js/* out


# required Node.js libs are mocked to an empty module
fpack --dev \
    --no-cache \
    --mock=child_process: \
    --mock=constants: \
    --mock=fs: out/runtime.js out/index.js
