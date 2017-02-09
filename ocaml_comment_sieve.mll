(** Prints comments in an OCaml file, replacing non-comments with whitespace
    (preserves the overall file structure). *)
{
  open Printf
  let level = ref 0 (* comment level (> 0 inside comments, = 0 otherwise) *)
  let hide = ref true
             (* controls printing of strings when inside/outside comments *)
  exception End_of_file
}

let ws = [' ' '\t']
let quoted_char = '\'' ([^ '\\' '\''] | '\\' (['\\' '\''])) '\''

rule outside = parse
  | "(*" { level := 1; printf "(*"; inside lexbuf }
  | '\n' { printf "\n"; outside lexbuf }
  | '"'  { hide := true; printf " "; str lexbuf; outside lexbuf }
  | ws+ as s { print_string s; outside lexbuf; }
  | quoted_char as s { printf "%*s" (String.length s) ""; outside lexbuf }
  | _    { printf " "; outside lexbuf }
  | eof  { raise End_of_file }

and inside = parse
  | "(*" { incr level; printf "(*"; inside lexbuf }
  | "*)" { decr level; printf "*)"; if !level > 0 then inside lexbuf else outside lexbuf }
  | '"'  { hide := false; printf "\""; str lexbuf; inside lexbuf }
  | quoted_char as s { print_string s; inside lexbuf }
  | _ as c { print_char c; inside lexbuf }
  | eof    { raise End_of_file }

and str = parse
  | '"'  { if !hide then printf " " else printf "\""; }
  | '\\' ('\\' | 'n' | '"') as s { if !hide then printf "  " else printf "%s" s; str lexbuf }
  | _ as c { if !hide then printf " " else printf "%c" c; str lexbuf }
  | eof  { raise End_of_file }

{
  let _ =
    try outside (Lexing.from_channel stdin)
  with End_of_file -> flush stdout
}
