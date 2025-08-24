(*
On the application to be debugged run this codesign command:

$ codesign -s - -v -f --entitlements =(echo -n '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd"\>
<plist version="1.0">
  <dict>
    <key>com.apple.security.get-task-allow</key>
    <true/>
  </dict>
</plist>') ./signal_demo

Then give this program debug entitlements:

$codesign -f -s - --entitlements lib/mach/examples/debugserver-macos-entitlements.plist _build/default/lib/mach/examples/simple_vmmap.exe
*)

open PosixTypes
open Ctypes
open Mach

(* TODO Add these constants into mach.ml *)

let vm_region_submap_info_count_64 =
  sizeof vm_region_submap_info_data_64_t / sizeof natural_t

(** From `mach/kern_return.h` *)

let kern_success : integer_t = 0l

let format_display_size (size : uint64_t) =
  let scale = [| 'B'; 'K'; 'M'; 'G'; 'T'; 'P'; 'E' |] in
  let display_size = ref (Unsigned.UInt64.to_int size |> Float.of_int) in
  let scale_index = ref 0 in
  while !display_size >= 999.5 do
    display_size := !display_size /. 1024.0;
    scale_index := !scale_index + 1
  done;
  let precision =
    if !display_size < 9.95 && !display_size -. !display_size > 0.0 then 1
    else 0
  in

  Printf.sprintf "%.*f%c" precision !display_size (Array.get scale !scale_index)

type memory_map = {
  address_start : uint64_t;
  address_end : uint64_t;
  perm_read : bool;
  perm_write : bool;
  perm_execute : bool;
  perm_shared : bool;
  offset : uint64_t;
  device_major : int;
  device_minor : int;
  inode : uint64_t;
  pathname : string;
}

let mk_entry address_start address_end pr pw px ps offset device_major
    device_minor inode pathname =
  {
    address_start;
    address_end;
    offset;
    device_major;
    device_minor;
    inode;
    pathname = String.trim pathname;
    perm_read = pr = 'r';
    perm_write = pw = 'w';
    perm_execute = px = 'x';
    perm_shared = ps = 's';
  }

let get_memory_protection (prot : int32) =
  let open Mach in
  let r =
    if not (Int32.equal (Int32.logand prot vm_prot_read) 0l) then 'r' else '-'
  in
  let w =
    if not (Int32.equal (Int32.logand prot vm_prot_write) 0l) then 'w' else '-'
  in
  let x =
    if not (Int32.equal (Int32.logand prot vm_prot_execute) 0l) then 'x'
    else '-'
  in
  (r, w, x)

let vmmap task start_ end_ (depth : int) =
  let pid = allocate pid_t (PosixTypes.Pid.of_int 0) in
  let _ = Mach.pid_for_task !@task pid in
  let result = ref [] in
  let start_ = ref start_ in
  let break = ref false in
  while !break == false do
    let address = allocate mach_vm_address_t !start_ in
    let size = allocate mach_vm_size_t Unsigned.UInt64.zero in
    let depth0 = allocate vm_region_recurse_info_t (Int32.of_int depth) in
    let info =
      allocate vm_region_submap_info_data_64_t
        (make vm_region_submap_info_data_64_t)
    in
    let count =
      allocate mach_msg_type_number_t
        (Int32.of_int vm_region_submap_info_count_64)
    in
    let kr =
      Mach.mach_vm_region_recurse !@task address size depth0
        (to_voidp info |> from_voidp vm_region_recurse_info_t)
        count
    in

    if (not (Int32.equal kr kern_success)) || !@address > end_ then
      (* TODO no break statement in OCaml we need to restructure this as tailrec recursion *)
      break := true
    else
      let address_start = !@address in
      let address_end = Unsigned.UInt64.add address_start !@size in
      (* macOS has current permissions and max permissions as
         info.protection and info.max_protection.
         Here we simplify that to current permissions.
       *)
      let pr, pw, px = get_memory_protection (getf !@info protection) in
      let ps = '-' in
      let pathname = CArray.make char (4 + 4096) in
      let _kr =
        Mach.proc_regionfilename !@pid !@address
          (to_voidp (CArray.start pathname))
          (Unsigned.UInt32.of_int (4 + 4096))
      in
      let pathname_str =
        CArray.to_list pathname |> List.to_seq |> String.of_seq
      in
      let offset = Unsigned.UInt64.zero in
      let device_major = 0 in
      let device_minor = 0 in
      let inode = Unsigned.UInt64.zero in
      let entry =
        mk_entry address_start address_end pr pw px ps offset device_major
          device_minor inode pathname_str
      in
      result := entry :: !result;
      start_ := Unsigned.UInt64.add !@address !@size
  done;
  !result

let () =
  if Array.length Sys.argv <> 2 then
    Printf.fprintf stderr "Usage: %s <pid>\n" Sys.executable_name
  else
    let depth = 2048 in
    let self = Mach.mach_task_self () in
    let pid = PosixTypes.Pid.of_string Sys.argv.(1) in
    let task = allocate uint64_t Unsigned.UInt64.zero in
    let kr = Mach.task_for_pid self pid task in
    if not (Int32.equal kr kern_success) then (
      Printf.printf "task_for_pid(%d) failed: %s\n" (Pid.to_int pid)
        (Mach.mach_error_string kr);
      exit 1)
    else (
      Printf.printf "Virtal Memory Map (depth=%u) for PID %d\n" depth
        (Pid.to_int pid);
      Printf.printf "          START - END             [ VSIZE ] PRT FILE\n";
      let maps =
        vmmap task Unsigned.UInt64.zero Unsigned.UInt64.max_int depth
      in

      List.iter
        (fun map ->
          Printf.printf "%016u-%016u [ %s ] %c%c%c%c %6s\n"
            (Unsigned.UInt64.to_int map.address_start)
            (Unsigned.UInt64.to_int map.address_end)
            (Unsigned.UInt64.sub map.address_end map.address_start
            |> format_display_size)
            (if map.perm_read then 'r' else '-')
            (if map.perm_write then 'w' else '-')
            (if map.perm_execute then 'x' else '-')
            (if map.perm_shared then 's' else '-')
            map.pathname)
        (List.rev maps))
