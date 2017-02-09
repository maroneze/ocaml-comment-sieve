# 1 "test-input.ml"

(*** three asterisks *)
let f () =
  Format.printf "inside f@."

let scan_escape char =
  match char with
  | 'e' | 'E' -> '\027'  (* ASCII code 27. This is a GCC extension *)
  | '\'' -> '\''  (* just a single quote *)
  | '"' -> '"'    (* '"' this causes mayhem on the following lines *)
  | '\027' -> '\027' (* "\027" '\027' *)
  | '\\' -> '\\' (* \\'\\ *)
  | '\x47' -> '\047' (* \\x47 '\\x47' *)
  | other -> (* "\x0f" '\129' *)
    Printf.printf "Unrecognized escape sequence: \\%c" other; (* \\%c *)
    invalid_arg "bla"

let () =
  (* one asterisk (* nested comment *)
                  (** nested comment with two closing asterisks, multilines and "quotes" **) *)
  Format.printf "hello world@.";
  (** two asterisks *)
  f(); (** f is to the left *)
  Format.printf "string with unbalanced (* and escaped double quote (\")@."; (* comment with unbalanced "" inside string and double quotes *)
  Format.printf "escaped backslash inside string: \\@."; (* escaped backslash inside string: "\\" *)
  Format.printf "escaped quote inside string: \"@."; (* escaped quote inside string: "\"" *)
  (* quoted backslash '\\' *)
  (* quoted single quote '\'' *)
  Format.printf "quote chars: %c %c %c@." '"' '\\' '\''; (* several quoted chars *)
  (* lone backslash: \\ *)
  (* lone escaped character: \n *)
  ()
