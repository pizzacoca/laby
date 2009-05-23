
(*
 * Copyright (C) 2007-2009 The laby team
 * You have permission to copy, modify, and redistribute under the
 * terms of the GPL-3.0. For full license terms, see gpl-3.0.txt.
 *)

type t

val basic : t
val load : string -> t
val size : t -> int * int
val comment : t -> string
val generate : t -> State.t