(** Mach function bindings.

    dune generates a C stub that calls each function directly, so the compiler
    checks every signature against the system headers. *)

open Ctypes
open PosixTypes
module Types = Types_generated

module Functions (F : Ctypes.FOREIGN) = struct
  open F

  let mach_vm_region_recurse =
    foreign "mach_vm_region_recurse"
      (Types.vm_task_entry_t
      @-> ptr Types.mach_vm_address_t
      @-> ptr Types.mach_vm_size_t @-> ptr Types.natural_t
      @-> Types.vm_region_recurse_info_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let mach_vm_read =
    foreign "mach_vm_read"
      (Types.vm_map_t @-> Types.mach_vm_address_t @-> Types.mach_vm_size_t
     @-> ptr Types.vm_offset_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let mach_vm_write =
    foreign "mach_vm_write"
      (Types.vm_map_t @-> Types.mach_vm_address_t @-> Types.vm_offset_t
     @-> Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let mach_vm_protect =
    foreign "mach_vm_protect"
      (Types.vm_map_t @-> Types.mach_vm_address_t @-> Types.mach_vm_size_t
     @-> Types.boolean_t @-> Types.vm_prot_t
      @-> returning Types.kern_return_t)

  let mach_vm_allocate =
    foreign "mach_vm_allocate"
      (Types.vm_map_t
      @-> ptr Types.mach_vm_address_t
      @-> Types.mach_vm_size_t @-> int
      @-> returning Types.kern_return_t)

  let mach_vm_deallocate =
    foreign "mach_vm_deallocate"
      (Types.vm_map_t @-> Types.mach_vm_address_t @-> Types.mach_vm_size_t
      @-> returning Types.kern_return_t)

  let vm_deallocate =
    foreign "vm_deallocate"
      (Types.vm_map_t @-> Types.vm_offset_t @-> Types.vm_size_t
      @-> returning Types.kern_return_t)

  let mach_port_allocate =
    foreign "mach_port_allocate"
      (Types.ipc_space_t @-> Types.mach_port_right_t
     @-> ptr Types.mach_port_name_t
      @-> returning Types.kern_return_t)

  let mach_port_deallocate =
    foreign "mach_port_deallocate"
      (Types.ipc_space_t @-> Types.mach_port_name_t
      @-> returning Types.kern_return_t)

  let mach_port_insert_right =
    foreign "mach_port_insert_right"
      (Types.ipc_space_t @-> Types.mach_port_name_t @-> Types.mach_port_t
     @-> Types.mach_msg_type_name_t
      @-> returning Types.kern_return_t)

  let task_for_pid =
    foreign "task_for_pid"
      (Types.mach_port_t @-> pid_t @-> ptr Types.mach_port_t
      @-> returning Types.kern_return_t)

  let task_name_for_pid =
    foreign "task_name_for_pid"
      (Types.mach_port_t @-> pid_t @-> ptr Types.mach_port_t
      @-> returning Types.kern_return_t)

  let pid_for_task =
    foreign "pid_for_task"
      (Types.mach_port_t @-> ptr pid_t @-> returning Types.kern_return_t)

  let mach_error_string =
    foreign "mach_error_string" (Types.mach_error_t @-> returning string)

  let mach_error_type =
    foreign "mach_error_type" (Types.mach_error_t @-> returning string)

  let task_terminate =
    foreign "task_terminate" (Types.task_t @-> returning Types.kern_return_t)

  let task_threads =
    foreign "task_threads"
      (Types.task_t
      @-> ptr Types.thread_act_array_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let mach_ports_register =
    foreign "mach_ports_register"
      (Types.task_t @-> Types.mach_port_array_t @-> Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let mach_ports_lookup =
    foreign "mach_ports_lookup"
      (Types.task_t
      @-> ptr Types.mach_port_array_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let task_info =
    foreign "task_info"
      (Types.task_name_t @-> Types.task_flavor_t @-> Types.task_info_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let task_set_info =
    foreign "task_set_info"
      (Types.task_name_t @-> Types.task_flavor_t @-> Types.task_info_t
     @-> Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let task_suspend =
    foreign "task_suspend" (Types.task_t @-> returning Types.kern_return_t)

  let task_resume =
    foreign "task_resume" (Types.task_t @-> returning Types.kern_return_t)

  let task_get_special_port =
    foreign "task_get_special_port"
      (Types.task_t @-> Types.task_special_port_t @-> ptr Types.mach_port_t
      @-> returning Types.kern_return_t)

  let task_set_special_port =
    foreign "task_set_special_port"
      (Types.task_t @-> int @-> Types.mach_port_t
      @-> returning Types.kern_return_t)

  let thread_create =
    foreign "thread_create"
      (Types.task_t @-> ptr Types.thread_act_t @-> returning Types.kern_return_t)

  let thread_create_running =
    foreign "thread_create_running"
      (Types.task_t @-> Types.thread_state_flavor_t @-> Types.thread_state_t
     @-> Types.mach_msg_type_number_t @-> ptr Types.thread_act_t
      @-> returning Types.kern_return_t)

  let thread_get_state =
    foreign "thread_get_state"
      (Types.thread_act_t @-> Types.thread_state_flavor_t
     @-> Types.thread_state_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let thread_set_state =
    foreign "thread_set_state"
      (Types.thread_act_t @-> Types.thread_state_flavor_t
     @-> Types.thread_state_t @-> Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let thread_info =
    foreign "thread_info"
      (Types.thread_act_t @-> Types.thread_flavor_t @-> Types.thread_info_t
      @-> ptr Types.mach_msg_type_number_t
      @-> returning Types.kern_return_t)

  let thread_suspend =
    foreign "thread_suspend"
      (Types.thread_act_t @-> returning Types.kern_return_t)

  let thread_resume =
    foreign "thread_resume"
      (Types.thread_act_t @-> returning Types.kern_return_t)

  let task_set_exception_ports =
    foreign "task_set_exception_ports"
      (Types.task_t @-> Types.exception_mask_t @-> Types.mach_port_t
     @-> Types.exception_behavior_t @-> Types.thread_state_flavor_t
      @-> returning Types.kern_return_t)

  let task_get_exception_ports =
    foreign "task_get_exception_ports"
      (Types.task_t @-> Types.exception_mask_t @-> Types.exception_mask_array_t
      @-> ptr Types.mach_msg_type_number_t
      @-> Types.exception_handler_array_t @-> Types.exception_behavior_array_t
      @-> Types.exception_flavor_array_t
      @-> returning Types.kern_return_t)

  let mach_thread_self =
    foreign "mach_thread_self" (void @-> returning Types.mach_port_t)

  let mach_task_self =
    foreign "mach_task_self" (void @-> returning Types.mach_port_t)

  let proc_pidinfo =
    foreign "proc_pidinfo"
      (pid_t @-> int @-> uint64_t @-> ptr void @-> int @-> returning int)

  let proc_regionfilename =
    foreign "proc_regionfilename"
      (pid_t @-> uint64_t @-> ptr void @-> uint32_t @-> returning int)
end
