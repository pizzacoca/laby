
(*
 * Copyright (C) 2007-2009 The laby team
 * You have permission to copy, modify, and redistribute under the
 * terms of the GPL-3.0. For full license terms, see gpl-3.0.txt.
 *)

exception Signal of int

val catch : (exn -> unit) option ref

type 'a result =
    | Done of 'a
    | Exited
    | Failed
    | Exn of exn

val exec : (unit -> 'a) -> 'a
val run : (unit -> 'a) -> 'a result

val hook : ('a -> 'b) -> 'a -> (unit -> unit) -> 'b

val timeout : ?seconds:int -> ('a -> 'b) -> 'a -> (unit -> 'b) -> 'b

val exit : unit -> 'a
val fail : unit -> 'a
