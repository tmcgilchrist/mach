open PosixTypes
open Ctypes
open Mach

let vmmap task start end_ depth =
  let pid = allocate pid_t Pid.zero in
  let _ = Mach.pid_for_task (!@task) pid in
  let first = ref true in
  while (!first != false) do
    _
  done

let () =
  if Array.length Sys.argv <> 2 then
    Printf.fprintf stderr "Usage: %s <pid>\n" Sys.executable_name
    else begin
      let depth = 2048 in
      let self = Mach.mach_task_self() in
      let pid = (PosixTypes.Pid.of_string Sys.argv.(1)) in
      let task = allocate uint64_t Unsigned.UInt64.zero in
      let kr = Mach.task_for_pid self pid task in
      if (kr != 0) then (
        Printf.printf "task_for_pid(%d) failed: %s\n" (Pid.to_int pid)
          (Mach.mach_error_string kr);
        exit 1)
      else (
        Printf.printf "Virtal Memory Map (depth=%u) for PID %d\n" depth (Pid.to_int pid);
        vmmap task 0 (-1) depth)
    end

