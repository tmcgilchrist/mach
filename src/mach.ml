open Ctypes
open PosixTypes
open Foreign

(** Types defined in `mach/i386/vm_types.h` *)

(** [natural_t] and [integer_t] are Mach's legacy types for machine-
    independent integer types (unsigned, and signed, respectively). *)
type natural_t = int32
let natural_t = Ctypes_static.Primitive Ctypes_primitive_types.Int32_t
type integer_t = int32
let integer_t = Ctypes_static.Primitive Ctypes_primitive_types.Int32_t

type uintptr_t = Unsigned.uint64
let uintptr_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

type uint64_t = Unsigned.uint64
let uint64_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

(**  A vm_offset_t is a type-neutral pointer,
    e.g. an offset into a virtual memory space.
*)
type vm_offset_t = uintptr_t
let vm_offset_t = uintptr_t

(** A vm_size_t is the proper type for e.g.
    expressing the difference between two
    vm_offset_t entities.
 *)
type vm_size_t = Unsigned.uint64
let vm_size_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

type mach_vm_address_t = uint64_t
let mach_vm_address_t = uint64_t

type mach_vm_offset_t = uint64_t
let mach_vm_offset_t = uint64_t

type mach_vm_size_t = uint64_t
let mach_vm_size_t = uint64_t

type vm_map_offset_t = uint64_t
let vm_map_offset_t = uint64_t

type vm_map_address_t = uint64_t
let vm_map_address_t = uint64_t

type vm_map_size_t = uint64_t
let vm_map_size_t = uint64_t

type mach_port_context_t = mach_vm_address_t
let mach_port_context_t = mach_vm_address_t

type mach_port_t = uint64_t
let mach_port_t = uint64_t

type task_t = mach_port_t
let task_t = mach_port_t

type task_name_t = mach_port_t
let task_name_t = mach_port_t

type vm_map_t = mach_port_t
let vm_map_t = mach_port_t

type vm_task_entry_t = mach_port_t
let vm_task_entry_t = mach_port_t

(** Types and functions corresponding to `mach/port.h`  *)


(**  [mach_port_name_t] - the local identity for a Mach port

     The name is Mach port namespace specific.  It is used to
     identify the rights held for that port by the task whose
     namespace is implied [or specifically provided].

     Use of this type usually implies just a name - no rights.
     See [mach_port_t] for a type that implies a "named right."
 *)
type mach_port_name_t = natural_t
let mach_port_name_t = natural_t

(** Types corresponding to `mach/kern_return.h` *)

(* This type corresponds to `mach/arm/kern_return.h` or
   `mach/i386/kern_return.h` as it is the same for
   both architectures *)
type kern_return_t = natural_t
let kern_return_t = natural_t

let kern_success : kern_return_t = 0l
let kern_invalid_address: kern_return_t = 1l
let kern_protection_failure: kern_return_t = 2l
let kern_no_space: kern_return_t = 3l
let kern_invalid_argument: kern_return_t = 4l
let kern_failure: kern_return_t = 5l
let kern_resource_shortage: kern_return_t = 6l
let kern_not_receiver: kern_return_t = 7l
let kern_no_access: kern_return_t = 8l
let kern_memory_failure: kern_return_t = 9l
let kern_memory_error: kern_return_t = 10l
let kern_already_in_set: kern_return_t = 11l
let kern_not_in_set: kern_return_t = 12l
let kern_name_exists: kern_return_t = 13l
let kern_aborted: kern_return_t = 14l
let kern_invalid_name: kern_return_t = 15l
let kern_invalid_task: kern_return_t = 16l
let kern_invalid_right: kern_return_t = 17l
let kern_invalid_value: kern_return_t = 18l
let kern_urefs_overflow: kern_return_t = 19l
let kern_invalid_capability: kern_return_t = 20l
let kern_right_exists: kern_return_t = 21l
let kern_invalid_host: kern_return_t = 22l
let kern_memory_present: kern_return_t = 23l
let kern_memory_data_moved: kern_return_t = 24l
let kern_memory_restart_copy: kern_return_t = 25l
let kern_invalid_processor_set: kern_return_t = 26l
let kern_policy_limit: kern_return_t = 27l
let kern_invalid_policy: kern_return_t = 28l
let kern_invalid_object: kern_return_t = 29l
let kern_already_waiting: kern_return_t = 30l
let kern_default_set: kern_return_t = 31l
let kern_exception_protected: kern_return_t = 32l
let kern_invalid_ledger: kern_return_t = 33l
let kern_invalid_memory_control: kern_return_t = 34l
let kern_invalid_security: kern_return_t = 35l
let kern_not_depressed: kern_return_t = 36l
let kern_terminated: kern_return_t = 37l
let kern_lock_set_destroyed: kern_return_t = 38l
let kern_lock_unstable: kern_return_t = 39l
let kern_lock_owned: kern_return_t = 40l
let kern_lock_owned_self: kern_return_t = 41l
let kern_semaphore_destroyed: kern_return_t = 42l
let kern_rpc_server_terminated: kern_return_t = 43l
let kern_rpc_terminate_orphan: kern_return_t = 44l
let kern_rpc_continue_orphan: kern_return_t = 45l
let kern_not_supported: kern_return_t = 46l
let kern_node_down: kern_return_t = 47l
let kern_not_waiting: kern_return_t = 48l
let kern_operation_timed_out: kern_return_t = 49l
let kern_codesign_error: kern_return_t = 50l
let kern_policy_static: kern_return_t = 51l
let kern_return_max: kern_return_t = 0x100l

(** Types corresponds to `mach/i386/boolean.h` *)

type boolean_t = Unsigned.uint32
let boolean_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint32_t

(** Types corresponds to `mach/message.h` *)
type mach_msg_type_number_t = natural_t
let mach_msg_type_number_t = natural_t

(** Types corresponding to `mach/vm_prot.h` *)
type vm_prot_t = integer_t
let vm_prot_t = integer_t

(** Protection values, defined as bits within the [vm_prot_t] type. *)

(** Read permissions *)
let vm_prot_read = Int32.of_int 0x01

(** Write permissions *)
let vm_prot_write = Int32.of_int 0x02

(** Execute permissions *)
let vm_prot_execute = Int32.of_int 0x04

(** The default protection for newly-created virtual memory *)
let vm_prot_default =  Int32.logor vm_prot_read vm_prot_write

(** Types corresponding to `mach/vm_region.h` *)

type vm_inherit_t = integer_t
let vm_inherit_t = integer_t

type memory_object_offset_t = natural_t
let memory_object_offset_t = natural_t

type vm_region_info_t = natural_t
type vm_region_info_64_t = natural_t
type vm_region_recurse_info_t = natural_t
let vm_region_recurse_info_t = natural_t
type vm_region_recurse_info_64_t = natural_t

type vm_behavior_t = natural_t
let vm_behavior_t = natural_t

type vm32_object_id_t = Unsigned.uint32
let vm32_object_id_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint32_t

type vm_object_id_t = Unsigned.uint64
let vm_object_id_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

type vm_region_basic_info_64
let vm_region_basic_info_64 : vm_region_basic_info_64 structure typ = structure "vm_region_basic_info_64"
let protection = field vm_region_basic_info_64 "protection" vm_prot_t (* present access protection *)
let max_protection = field vm_region_basic_info_64 "max_protection" vm_prot_t (* max avail through vm_prot *)
let inheritance = field vm_region_basic_info_64 "inheritance" vm_inherit_t (* behavior of map/obj on fork *)
let shared = field vm_region_basic_info_64 "shared" boolean_t
let reserved = field vm_region_basic_info_64 "reserved" boolean_t
let offset = field vm_region_basic_info_64 "offset" memory_object_offset_t
let behavior = field vm_region_basic_info_64 "behavior" vm_behavior_t
let user_wired_count = field vm_region_basic_info_64 "user_wired_count" ushort
let () = seal vm_region_basic_info_64

type vm_region_basic_info_64_t = vm_region_basic_info_64
let vm_region_basic_info_64_t = vm_region_basic_info_64

type vm_region_submap_info_64
let vm_region_submap_info_64 : vm_region_submap_info_64 structure typ = structure "vm_region_submap_info_64"
let protection = field vm_region_submap_info_64 "protection" vm_prot_t (* present access protection *)
let max_protection = field vm_region_submap_info_64 "max_protection" vm_prot_t (* max avail through vm_prot *)
let inheritance = field vm_region_submap_info_64 "inheritance" vm_inherit_t (* behavior of map/obj on fork *)
let offset = field vm_region_submap_info_64 "offset" memory_object_offset_t (* offset into object/map *)
let user_tag = field vm_region_submap_info_64 "user_tag" uint32_t (* user tag on map entry *)
let pages_resident = field vm_region_submap_info_64 "pages_resident" uint32_t (* only valid for objects *)
let pages_shared_now_private = field vm_region_submap_info_64 "pages_shared_now_private" uint32_t (* only for objects *)
let pages_swapped_out = field vm_region_submap_info_64 "pages_swapped_out" uint32_t (* only for objects *)
let pages_dirtied = field vm_region_submap_info_64 "pages_dirtied" uint32_t (* only for objects *)
let ref_count = field vm_region_submap_info_64 "ref_count" uint32_t (* obj/map mappers, etc *)
let shadow_depth = field vm_region_submap_info_64 "shadow_depth" uint16_t (* only for obj *)
let external_pager = field vm_region_submap_info_64 "external_pager" uchar (* only for obj *)
let share_mode = field vm_region_submap_info_64 "share_mode" uchar (* see enumeration *)
let is_submap = field vm_region_submap_info_64 "is_submap" int32_t (* submap vs obj *)
let behavior = field vm_region_submap_info_64 "behavior" vm_behavior_t (* access behavior hint *)
let object_id = field vm_region_submap_info_64 "object_id" vm32_object_id_t (* obj/map name, not a handle *)
let user_wired_count = field vm_region_submap_info_64 "user_wired_count" uint16_t
let pages_reusable = field vm_region_submap_info_64 "pages_reusable" uint32_t
let object_id_full = field vm_region_submap_info_64 "object_id_full" vm_object_id_t
let () = seal vm_region_submap_info_64

type vm_region_submap_info_data_64_t = vm_region_submap_info_64
let vm_region_submap_info_data_64_t = vm_region_submap_info_64

(** Types and functions from `mach/mach_vm.h` *)

let mach_vm_region_recurse =
  foreign "mach_vm_region_recurse" (
    vm_task_entry_t @-> ptr mach_vm_address_t @-> ptr mach_vm_size_t
    @-> ptr natural_t @-> ptr vm_region_recurse_info_t
    @-> ptr mach_msg_type_number_t @-> returning kern_return_t)

(** Types and functions from `mach/mach_port.h` *)

type ipc_space_t = mach_port_t
let ipc_space_t = mach_port_t

type mach_port_right_t = natural_t
let mach_port_right_t = natural_t

let mach_port_allocate =
  foreign "mach_port_allocate" (ipc_space_t @-> mach_port_right_t @-> ptr mach_port_name_t @-> returning kern_return_t)

let mach_port_deallocate =
  foreign "mach_port_deallocate" (ipc_space_t @-> mach_port_name_t @-> returning kern_return_t)

(* let mach_port_names = *)
(*   foreign "mach_port_names" (ipc_space_t @-> ptr mach_port_name_array_t @-> ptr mach_msg_type_number_t *)
(*     @-> ptr mach_port_type_array_t @-> ptr mach_msg_type_number_t @-> returning kern_return_t) *)

(** Types and functions from `mach/mach_traps.h` *)

(* extern kern_return_t task_for_pid(
        mach_port_name_t target_tport,
        int pid,
        mach_port_name_t *t);

   TODO These uint64_t values should be natural_t according to the C headers.
        Making them ints is convenient for now but should be changed later.
 *)
let task_for_pid =
  foreign "task_for_pid" (uint64_t @-> pid_t @-> ptr uint64_t @-> returning kern_return_t)
  (* foreign "task_for_pid" (mach_port_name_t @-> pid_t @-> ptr mach_port_name_t @-> returning kern_return_t) *)

let task_name_for_pid =
  foreign "task_name_for_pid" (mach_port_name_t @-> pid_t @-> ptr mach_port_name_t @-> returning kern_return_t)

let pid_for_task =
  foreign "pid_for_task" (uint64_t @-> ptr pid_t @-> returning kern_return_t)
  (* foreign "pid_for_task" (mach_port_name_t @-> ptr pid_t @-> returning kern_return_t) *)

(** Types defined in `mach/task_info.h` *)

(** varying array of int *)

let task_info_t = ptr integer_t

type task_flavor_t = natural_t
let task_flavor_t = natural_t

(** Types defined in `mach/mach_error.h` *)
type mach_error_t = natural_t
let mach_error_t = natural_t

(** Returns a string appropriate to the error argument given.  *)
let mach_error_string =
  foreign "mach_error_string" (mach_error_t @-> returning string)

(** Returns a string with the error system, subsystem and code.  *)
let mach_error_type =
  foreign "mach_error_type"  (mach_error_t @-> returning string)

(** Types defined in `mach/types.h` *)

type task_special_port_t = integer_t
let task_special_port_t = integer_t

type thread_act_t = mach_port_t
let thread_act_t = mach_port_t

type thread_act_array_t = thread_act_t
let thread_act_array_t = thread_act_t

(** Types defined in `mach/mach_types.h` *)

(*@ capability strictly _DECREASING_.
 * not ordered the other way around because we want TASK_FLAVOR_CONTROL
 * to be closest to the itk_lock. see task.h.
 *)
type mach_task_flavor_t = Unsigned.uint32

(** a task_t *)
let task_flavor_control : mach_task_flavor_t  = Unsigned.UInt32.of_int 0

(** a task_read_t *)
let task_flavor_read : mach_task_flavor_t = Unsigned.UInt32.of_int 1

(** a task_inspect_t *)
let task_flavor_inspect : mach_task_flavor_t = Unsigned.UInt32.of_int 2

(** a task_name_t *)
let task_flavor_name : mach_task_flavor_t = Unsigned.UInt32.of_int 3
let task_flavor_max = task_flavor_name

(** Types defined in `mach/thread_status.h` *)

(** Variable-length array *)
type thread_state_t = natural_t
let thread_state_t = natural_t

type thread_state_flavor_t = integer_t
let thread_state_flavor_t = integer_t

(** Types defined in `mach/exception_types.h` *)

(** Machine-independent exception definitions. *)

(** Could not access memory.

    Code contains kern_return_t describing error.
    Subcode contains bad memory address *)
let exc_bad_access : integer_t = 1l

(** Instruction failed.

    Illegal or undefined instruction or operand *)
let exc_bad_instruction: integer_t = 2l

(** Arithmetic exception.

    Exact nature of exception is in code field *)
let exc_arithmetic: integer_t = 3l

(** Emulation instruction.

    Emulation support instruction encountered.
    Details in code and subcode fields *)
let exc_emulation: integer_t = 4l

(** Software generated exception.

    Exact exception is in code field.
    Codes 0 - 0xFFFF reserved to hardware
    Codes 0x10000 - 0x1FFFF reserved for OS emulation (Unix)
 *)
let exc_software: integer_t = 5l

(** Trace, breakpoint, etc.
    Details in code field. *)
let exc_breakpoint: integer_t = 6l

(** System calls. *)
let exc_syscall: integer_t = 7l

(** Mach system calls. *)
let exc_mach_syscall: integer_t = 8l

(** RPC alert. *)
let exc_rpc_alert: integer_t = 9l

(** Abnormal process exit. *)
let exc_crash: integer_t = 10l

(** Hit resource consumption limit. *)
let exc_resource: integer_t = 11l

(** Violated guarded resource protections. *)
let exc_guard: integer_t = 12l

(** Abnormal process exited to corpse state. *)
let exc_corpse_notify: integer_t = 13l

(** Machine-independent exception behaviors *)

(** Send a catch_exception_raise message including the identity.  *)
let exception_default: integer_t = 1l

(** Send a catch_exception_raise_state message including
    the thread state. *)
let exception_state: integer_t = 2l

(** Send a catch_exception_raise_state_identity message including
    the thread identity and state. *)
let exception_state_identity: integer_t = 3l

(** Send a catch_exception_raise_identity_protected message including protected task
    and thread identity. *)
let exception_identity_protected: integer_t = 4l

(** Send a catch_exception_raise_state_identity_protected message including protected task
    and thread identity plus the thread state. *)
let exception_state_identity_protected: integer_t = 5l

(** Send 64-bit code and subcode in the exception header *)
let mach_exception_codes: integer_t = 0x80000000l

type c_int = Unsigned.uint32
let c_int = Ctypes_static.Primitive Ctypes_primitive_types.Uint32_t

type exception_type_t = c_int
let exception_type_t = c_int

type exception_data_type_t = integer_t
let exception_data_type_t = integer_t

type mach_exception_data_type_t = int64
type exception_behavior_t = c_int
let exception_behavior_t = c_int

type exception_mask_t = integer_t
let exception_mask_t = integer_t
let exception_mask_array_t = ptr exception_mask_t
let exception_behavior_array_t = ptr exception_behavior_t
type mach_exception_code_t = mach_exception_data_type_t
type mach_exception_subcode_t = mach_exception_data_type_t

let exception_flavor_array_t = ptr thread_state_flavor_t

(** Types and functions defined in `mach/task.h` *)

let mach_port_array_t = ptr mach_port_t

(** Routine task_terminate *)
let task_terminate =
  foreign "task_terminate" (task_t @-> returning kern_return_t)

(** Routine task_threads *)
let task_threads =
  foreign "task_threads" (task_t @-> ptr thread_act_array_t @-> ptr mach_msg_type_number_t @-> returning kern_return_t)

(** Routine mach_ports_register *)
let mach_ports_register =
  foreign "mach_ports_register" (task_t @-> mach_port_array_t @-> mach_msg_type_number_t @-> returning kern_return_t)

(** Routine mach_ports_lookup *)
let mach_ports_lookup =
  foreign "mach_ports_lookup" (task_t @-> ptr mach_port_array_t @-> mach_msg_type_number_t @-> returning kern_return_t)

(** Routine task_info *)
let task_info =
  foreign "task_info" (task_name_t @-> task_flavor_t @-> task_info_t @-> ptr mach_msg_type_number_t @-> returning kern_return_t)

(** Routine task_set_info *)
let task_set_info =
  foreign "task_set_info" (task_name_t @-> task_flavor_t @-> task_info_t @-> mach_msg_type_number_t @-> returning kern_return_t)

(** Routine task_suspend *)
let task_suspend =
  foreign "task_suspend" (task_t @-> returning kern_return_t)

(** Routine task_resume *)
let task_resume =
  foreign "task_resume" (task_t @-> returning kern_return_t)

(** Routine task_get_special_port *)
let task_get_special_port =
  foreign "task_get_special_port" (task_t @-> task_special_port_t @-> ptr mach_port_t @-> returning kern_return_t)

(** Routine task_set_special_port  *)
let task_set_specical_port =
  foreign "task_set_special_port" (task_t @-> int @-> mach_port_t @-> returning kern_return_t)

(** Routine thread_create *)
let thread_create =
  foreign "thread_create" (task_t @-> ptr thread_act_t @-> returning kern_return_t)

(** Routine thread_create_running *)
let thread_create_running =
  foreign "thread_create_running" (task_t @-> ptr thread_state_flavor_t @-> ptr thread_state_t @-> mach_msg_type_number_t @-> ptr thread_act_t @-> returning kern_return_t)

(** Routine task_set_exception_ports *)
let task_set_exception_ports =
  foreign "task_set_exception_ports" (task_t @-> exception_mask_t @-> mach_port_t @-> exception_behavior_t @-> thread_state_flavor_t @-> returning kern_return_t)

(* typedef mach_port_t             exception_handler_t;  *)
type exception_handler_t = mach_port_t
let exception_handler_t = mach_port_t

(* typedef exception_handler_t     *exception_handler_array_t *)
let exception_handler_array_t = ptr exception_handler_t

(** Routine task_get_exception_ports *)
let task_get_exception_ports =
  foreign "task_get_exception_ports" (task_t @-> exception_mask_t @-> exception_mask_array_t @-> ptr mach_msg_type_number_t @-> exception_handler_array_t @-> exception_behavior_array_t @-> exception_flavor_array_t @-> returning kern_return_t)

(** Types and functions defined in `mach/mach_init.h` *)

let mach_thread_self : unit -> mach_port_t =
  foreign "mach_thread_self" (void @-> returning mach_port_t)

let mach_task_self : unit -> mach_port_t =
  foreign "mach_task_self" (void @-> returning mach_port_t)

(** Types from `sys/_types.h` *)
let uid_t = uint32_t
let gid_t = uint32_t

(** Types and functions from `sys/proc_info.h` *)

(* pbi_flags values *)
type pbi_flags =
  | PROC_FLAG_SYSTEM
  (**  System process *)
  | PROC_FLAG_TRACED
  (** process currently being traced, possibly by gdb *)
  | PROC_FLAG_INEXIT
  (** process is working its way in exit() *)
  | PROC_FLAG_PPWAIT
  | PROC_FLAG_LP64
  (** 64bit process *)
  | PROC_FLAG_SLEADER
  (** The process is the session leader *)
  | PROC_FLAG_CTTY
  (** process has a control tty *)
  | PROC_FLAG_CONTROLT
  (** Has a controlling terminal *)
  | PROC_FLAG_THCWD
  (** process has a thread with cwd *)
(* process control bits for resource starvation *)
  | PROC_FLAG_PC_THROTTLE (** In resource starvation situations, this process is to be throttled *)
  | PROC_FLAG_PC_SUSP (** In resource starvation situations, this process is to be suspended *)
  | PROC_FLAG_PC_KILL (** In resource starvation situations, this process is to be terminated *)
  (* | PROC_FLAG_PC_MASK       0x600 *) (* This appears to be a C convenience defintion *)
(* process action bits for resource starvation *)
  | PROC_FLAG_PA_THROTTLE (** The process is currently throttled due to resource starvation *)
  | PROC_FLAG_PA_SUSP (** The process is currently suspended due to resource starvation *)
  | PROC_FLAG_PSUGID (** process has set privileges since last exec *)
  | PROC_FLAG_EXEC (** process has called exec  *)

let pbi_flags_to_int = function
  | PROC_FLAG_SYSTEM -> 1
  | PROC_FLAG_TRACED -> 2
  | PROC_FLAG_INEXIT -> 4
  | PROC_FLAG_PPWAIT -> 8
  | PROC_FLAG_LP64 -> 0x10
  | PROC_FLAG_SLEADER -> 0x20
  | PROC_FLAG_CTTY -> 0x40
  | PROC_FLAG_CONTROLT -> 0x80
  | PROC_FLAG_THCWD -> 0x100
  | PROC_FLAG_PC_THROTTLE -> 0x200
  | PROC_FLAG_PC_SUSP -> 0x400
  | PROC_FLAG_PC_KILL -> 0x600
  | PROC_FLAG_PA_THROTTLE -> 0x800
  | PROC_FLAG_PA_SUSP -> 0x1000
  | PROC_FLAG_PSUGID -> 0x2000
  | PROC_FLAG_EXEC -> 0x4000

let pbi_flags_of_int = function
  | 1 -> Some PROC_FLAG_SYSTEM
  | 2 -> Some PROC_FLAG_TRACED
  | 4 -> Some PROC_FLAG_INEXIT
  | 8 -> Some PROC_FLAG_PPWAIT
  | 0x10 -> Some PROC_FLAG_LP64
  | 0x20 -> Some PROC_FLAG_SLEADER
  | 0x40 -> Some PROC_FLAG_CTTY
  | 0x80 -> Some PROC_FLAG_CONTROLT
  | 0x100 -> Some PROC_FLAG_THCWD
  | 0x200 -> Some PROC_FLAG_PC_THROTTLE
  | 0x400 -> Some PROC_FLAG_PC_SUSP
  | 0x600 -> Some PROC_FLAG_PC_KILL
  | 0x800 -> Some PROC_FLAG_PA_THROTTLE
  | 0x1000 -> Some PROC_FLAG_PA_SUSP
  | 0x2000 -> Some PROC_FLAG_PSUGID
  | 0x4000 -> Some PROC_FLAG_EXEC
  | _ -> None

(* Status values from sys/proc.h *)
type pbi_status =
  | SIDL              (* Process being created by fork. *)
  | SRUN              (* Currently runnable. *)
  | SSLEEP            (* Sleeping on an address. *)
  | SSTOP             (* Process debugging or suspension. *)
  | SZOMB             (* Awaiting collection by parent. *)

let pbi_status_to_int = function
  | SIDL -> Unsigned.UInt32.of_int 1
  | SRUN -> Unsigned.UInt32.of_int 2
  | SSLEEP -> Unsigned.UInt32.of_int 3
  | SSTOP -> Unsigned.UInt32.of_int 4
  | SZOMB -> Unsigned.UInt32.of_int 5

let pbi_status_of_int i =
  match Unsigned.UInt32.to_int i with
  | 1 -> Some SIDL
  | 2 -> Some SRUN
  | 3 -> Some SSLEEP
  | 4 -> Some SSTOP
  | 5 -> Some SZOMB
  | _ -> None

let pbi_status_to_string = function
 | SIDL -> "IDLE"
 | SRUN -> "RUN"
 | SSLEEP -> "SLEEP"
 | SSTOP -> "STOP"
 | SZOMB -> "ZOMB"

(* TODO define Flavors for proc_pidinfo() *)
(* type proc_pidinfo_flavors = *)
(*  | PROC_PIDT_SHORTBSDINFO -> 13 *)

type proc_bsdshortinfo
let proc_bsdshortinfo : proc_bsdshortinfo structure typ = structure "proc_bsdshortinfo"
let pbsi_pid = field proc_bsdshortinfo "pbi_pid" uint32_t (* process id  *)
let pbsi_ppid = field proc_bsdshortinfo "pbi_ppid" uint32_t (* process parent id *)
let pbsi_pgid = field proc_bsdshortinfo "pbi_pgid" uint32_t (* process perp id  *)
let pbsi_status = field proc_bsdshortinfo "pbsi_status" uint32_t (*  p_stat value, SZOMB, SRUN, etc *)
let pbsi_comm = field proc_bsdshortinfo "pbsi_comm" (array 16 char) (* upto 16 characters of process name *)
let pbsi_flags = field proc_bsdshortinfo "bpsi_flags" uint32_t (* 64bit; emulated etc *)
let pbsi_uid = field proc_bsdshortinfo "bpsi_uid" uid_t (* current uid on process *)
let pbsi_gid = field proc_bsdshortinfo "bpsi_gid" gid_t (* current gid on process *)
let pbsi_ruid = field proc_bsdshortinfo "bpsi_ruid" uid_t (* current ruid on process *)
let pbsi_rgid = field proc_bsdshortinfo "bpsi_rgid" gid_t (* current rgid on process *)
let pbsi_svuid = field proc_bsdshortinfo "bpsi_svuid" uid_t (* current svuid on process *)
let pbsi_svgid = field proc_bsdshortinfo "bpsi_svgid" gid_t (* current svgid on process *)
let pbsi_rfu = field proc_bsdshortinfo "bpsi_rfu" uint32_t (* reserved for future use *)
let () = seal proc_bsdshortinfo

(* int proc_pidinfo(int pid, int flavor, uint64_t arg, void *buffer, int buffersize); *)
let proc_pidinfo =
  foreign "proc_pidinfo" (pid_t @-> int @-> uint64_t @-> ptr void @-> int @-> returning int)

(* int proc_regionfilename(int pid, uint64_t address, void * buffer, uint32_t buffersize) *)
let proc_regionfilename =
  foreign "proc_regionfilename" (pid_t @-> uint64_t @-> ptr void @-> uint32_t @-> returning int)