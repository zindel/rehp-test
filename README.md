```bash
$ esy i
$ esy b
$ esy ./run.sh
$ open index.html
```

Few notes:
1. Had to copy & patch the `runtime.js` from the jsoo-compiler. Specifically in
   the end of file:
    ```JavaScript
    // module.exports = global.jsoo_runtime;
    module.exports = global;
    ```
2. `Test.js` is emitted with `require("List_.js")` while I would expect it to
   be `require("List.js")` (no trailing underscore).
3. `Pervasives.js` requires some of OCaml's builtins as js files. Had to hack
   it with empty modules
