ocaml_comment_sieve: ocaml_comment_sieve.ml
	ocamlopt ocaml_comment_sieve.ml -o ocaml_comment_sieve

ocaml_comment_sieve.ml: ocaml_comment_sieve.mll
	ocamllex ocaml_comment_sieve.mll

test: ocaml_comment_sieve
	./ocaml_comment_sieve < test-input.ml > test-input.out
	diff test-input.expected test-input.out
	./ocaml_comment_sieve -v < test-input.ml > test-input-inverted.out
	diff test-input-inverted.expected test-input-inverted.out

# run test-input.ml, just to ensure it is valid OCaml code
test-input:
	ocaml test-input.ml

clean:
	$(RM) ocaml_comment_sieve *.cm* ocaml_comment_sieve.ml *.o *.out *~

.PHONY: clean
