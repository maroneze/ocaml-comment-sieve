# ocaml-comment-sieve
Lexer-based filter to extract comments from OCaml code

Code based on [ocamlwc](https://www.lri.fr/~filliatr/software.fr.html).

## Usage

Reads files from standard input.

Outputs the comments from the file, replacing other characters with spaces
(to preserve the file structure).

    ocamlc ocaml-comment-sieve.mll
    ./ocaml-comment-sieve < file.ml

#### Example

Input file `input.ml`:

```ocaml
(** Example input for ocaml-comment-sieve *)
let _ = (* this is a comment *)
  Format.printf "this is a string (* and not a comment *)@." (* comment *)
  (* nested (* comments (* are also *) printed *) *); (* end *) ()
```

Result of `./ocaml-comment-sieve < input.ml`:

```ocaml
(** Example input for ocaml-comment-sieve *)
        (* this is a comment *)
                                                             (* comment *)
  (* nested (* comments (* are also *) printed *) *)  (* end *)
```

### Authors

`ocaml-comment-sieve` by Jean-Christophe Léchenet and André Maroneze

Based on `ocamlwc` by Jean-Christophe Filliâtre
