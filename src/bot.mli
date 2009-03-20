
(*
 * Copyright (C) 2007-2009 The laby team
 * You have permission to copy, modify, and redistribute under the
 * terms of the GPL-3.0. For full license terms, see gpl-3.0.txt.
 *)

type query = string * (string -> unit)

type t =
    <
      set_name: string -> unit;
      get_name: string;
      errto: (string -> unit) -> unit;
      set_buf: string -> unit;
      get_buf: string;
      start: bool;
      probe: query option;
      close: unit;
    >

val make : unit -> t

