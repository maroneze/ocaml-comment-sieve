(** Prints comments in an OCaml file, replacing non-comments with whitespace
    (preserves the overall file structure).
    Option -v inverts the result (removes comments).
 *)
{
  open Printf
  let level = ref 0 (* comment level (> 0 inside comments, = 0 otherwise) *)
  let hide = ref true
             (* controls printing of strings when inside/outside comments *)
  exception End_of_file

  let opt_invert = ref false

  let print_non_comment s =
    if !opt_invert then
      print_string s
    else
      printf "%*s" (String.length s) ""

  let print_comment s =
    if not (!opt_invert) then
      print_string s
    else
      printf "%*s" (String.length s) ""
}

let ws = [' ' '\t']
let quoted_char = '\'' ([^ '\\' '\''] | '\\' (['\\' '\''])) '\''

rule outside = parse
  | "(*" { level := 1; print_comment "(*"; inside lexbuf }
  | '\n' { printf "\n"; outside lexbuf }
  | '"'  { hide := true; print_non_comment "\""; str lexbuf; outside lexbuf }
  | ws+ as s { print_string s; outside lexbuf; }
  | quoted_char as s { print_non_comment s; outside lexbuf }
  | _ as c { print_non_comment (String.make 1 c); outside lexbuf }
  | eof  { raise End_of_file }

and inside = parse
  | "(*" { incr level; print_comment "(*";
           inside lexbuf
         }
  | "*)" { decr level; print_comment "*)";
           if !level > 0 then inside lexbuf else outside lexbuf
         }
  | '"'  { hide := false;
           print_comment "\"";
           str lexbuf;
           inside lexbuf
         }
  | '\n' { printf "\n"; inside lexbuf }
  | quoted_char as s { print_comment s;
                       inside lexbuf
                     }
  | _ as c { print_comment (String.make 1 c);
             inside lexbuf
           }
  | eof    { raise End_of_file }

and str = parse
  | '"'  { if !hide then print_non_comment "\"" else print_comment "\""; }
  | '\\' ('\\' | 'n' | '"') as s {
      if !hide then print_non_comment s else print_comment s;
      str lexbuf
    }
  | _ as c {
      if !hide
      then print_non_comment (String.make 1 c)
      else print_comment (String.make 1 c);
      str lexbuf
    }
  | eof  { raise End_of_file }

{
  let _ =
    if Array.length Sys.argv > 1 && Sys.argv.(1) = "-v" then
      opt_invert := true;
    try outside (Lexing.from_channel stdin)
    with End_of_file -> flush stdout
}
