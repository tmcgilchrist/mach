(* Equivalent code to pidinfo.c this will print out the process status
   by calling libproc.h functions.

   dune exec -- pidinfo <PID>
 *)

let handle_call pid =
  let open Mach in
  let open Ctypes in

  (* Using ctypes allocate a bsd_shortinfo structure to pass into proc_pidinfo *)
  let bsd_shortinfo = allocate proc_bsdshortinfo (make proc_bsdshortinfo) in
  let i = proc_pidinfo pid 13 (* PROC_PIDT_SHORTBSDINFO *)
    (Unsigned.UInt64.zero)
    (to_voidp bsd_shortinfo)
    (sizeof proc_bsdshortinfo) in

  (* Check return size as this might have failed *)
  if i != (sizeof proc_bsdshortinfo) then
    failwith (Printf.sprintf "Unable to get SHORTBSDINFO returned: %d" i)
  else
    let status = getf (!@bsd_shortinfo) pbsi_status in
    Printf.printf "  pid: %u\n ppid: %d\n  uid: %d\n  gid: %d\n status: %s\n"
      (getf (!@bsd_shortinfo) pbsi_pid |> Unsigned.UInt32.to_int)
      (getf (!@bsd_shortinfo) pbsi_ppid |> Unsigned.UInt32.to_int)
      (getf (!@bsd_shortinfo) pbsi_uid |> Unsigned.UInt32.to_int)
      (getf (!@bsd_shortinfo) pbsi_gid |> Unsigned.UInt32.to_int)
      (pbi_status_of_int status |> Option.get |> pbi_status_to_string)

let () =
  if Array.length Sys.argv <> 2 then
    Printf.fprintf stderr "Usage: %s <pid>\n" Sys.executable_name
    else
      ignore (handle_call (PosixTypes.Pid.of_string Sys.argv.(1)))

