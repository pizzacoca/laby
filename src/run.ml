
(*
 * Copyright (C) 2007-2009 The laby team
 * You have permission to copy, modify, and redistribute under the
 * terms of the GPL-3.0. For full license terms, see gpl-3.0.txt.
 *)

exception Signal of int
let signal i = raise (Signal i)

exception Exit
exception Fail

let catch = ref None

type 'a result =
    | Done of 'a
    | Exited
    | Failed
    | Exn of exn

let may_set_signal s h =
  begin try Sys.set_signal s h with
  | Invalid_argument _ -> ()
  end

let _ =
  Sys.catch_break false;
  may_set_signal Sys.sigpipe (Sys.Signal_handle signal);
  may_set_signal Sys.sigterm (Sys.Signal_handle signal);
  may_set_signal Sys.sigquit (Sys.Signal_handle signal);
  may_set_signal Sys.sigalrm (Sys.Signal_handle signal);
  may_set_signal Sys.sighup Sys.Signal_ignore

let exec f =
  begin try f () with
  | Sys.Break as exn ->
      begin match !catch with
      | None -> exit 1
      | Some _ ->
	  Printf.printf "---\n%!";
	  raise exn
      end
  | Signal i when i = Sys.sigterm || i = Sys.sigquit -> exit 0
  | exn ->
      Printf.printf "---\n%!";
      raise exn
  end

let run f =
  begin try Done (f ())
    with
    | (Sys.Break | Signal _) as exn -> raise exn
    | Exit -> Exited
    | Fail -> Failed
    | exn ->
	begin match !catch with
	| None -> Exn exn
	| Some f -> f exn; raise exn
	end
  end

let hook f a h =
  begin try let r = f a in h (); r with
  | exn -> h (); raise exn
  end

let timeout ?(seconds=2) f a h =
  ignore (Unix.alarm seconds);
  Sys.set_signal Sys.sigalrm (Sys.Signal_handle signal);
  let start () = (try f a with Signal i when i = Sys.sigalrm -> h ()) in
  hook start () (fun () ->
    Sys.set_signal Sys.sigalrm Sys.Signal_ignore
  )

let exit () = raise Exit
let fail () = raise Fail
