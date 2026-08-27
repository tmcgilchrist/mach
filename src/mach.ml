open Ctypes
open PosixTypes

(** Types defined in `mach/i386/vm_types.h` *)

type natural_t = Unsigned.uint32
(** [natural_t] and [integer_t] are Mach's legacy types for machine-independent
    integer types, unsigned and signed respectively. *)

let natural_t = uint32_t

type integer_t = int32

let integer_t = Ctypes_static.Primitive Ctypes_primitive_types.Int32_t

type uintptr_t = Unsigned.uint64

let uintptr_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

type uint64_t = Unsigned.uint64

let uint64_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

type vm_offset_t = uintptr_t
(** A vm_offset_t is a type-neutral pointer, e.g. an offset into a virtual
    memory space. *)

let vm_offset_t = uintptr_t

type vm_size_t = Unsigned.uint64
(** A vm_size_t is the proper type for e.g. expressing the difference between
    two vm_offset_t entities. *)

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

type mach_port_t = Unsigned.uint32
(** A port name, [natural_t] wide. *)

let mach_port_t = uint32_t

type task_t = mach_port_t

let task_t = mach_port_t

type task_name_t = mach_port_t

let task_name_t = mach_port_t

type vm_map_t = mach_port_t

let vm_map_t = mach_port_t

type vm_task_entry_t = mach_port_t

let vm_task_entry_t = mach_port_t

(** Types and functions corresponding to `mach/port.h` *)

type mach_msg_type_name_t = natural_t
(** Names a port right being transferred in a message. *)

let mach_msg_type_name_t = natural_t

type mach_port_name_t = natural_t
(** [mach_port_name_t] - the local identity for a Mach port

    The name is Mach port namespace specific. It is used to identify the rights
    held for that port by the task whose namespace is implied
    [or specifically provided].

    Use of this type usually implies just a name - no rights. See [mach_port_t]
    for a type that implies a "named right." *)

let mach_port_name_t = natural_t

(** Types corresponding to `mach/kern_return.h` *)

(* This type corresponds to `mach/arm/kern_return.h` or
   `mach/i386/kern_return.h` as it is the same for
   both architectures *)
type kern_return_t = integer_t
(** A signed C [int], despite the Mach naming. *)

let kern_return_t = integer_t
let kern_success : kern_return_t = C.Types.kern_success
let kern_invalid_address : kern_return_t = C.Types.kern_invalid_address
let kern_protection_failure : kern_return_t = C.Types.kern_protection_failure
let kern_no_space : kern_return_t = C.Types.kern_no_space
let kern_invalid_argument : kern_return_t = C.Types.kern_invalid_argument
let kern_failure : kern_return_t = C.Types.kern_failure
let kern_resource_shortage : kern_return_t = C.Types.kern_resource_shortage
let kern_not_receiver : kern_return_t = C.Types.kern_not_receiver
let kern_no_access : kern_return_t = C.Types.kern_no_access
let kern_memory_failure : kern_return_t = C.Types.kern_memory_failure
let kern_memory_error : kern_return_t = C.Types.kern_memory_error
let kern_already_in_set : kern_return_t = C.Types.kern_already_in_set
let kern_not_in_set : kern_return_t = C.Types.kern_not_in_set
let kern_name_exists : kern_return_t = C.Types.kern_name_exists
let kern_aborted : kern_return_t = C.Types.kern_aborted
let kern_invalid_name : kern_return_t = C.Types.kern_invalid_name
let kern_invalid_task : kern_return_t = C.Types.kern_invalid_task
let kern_invalid_right : kern_return_t = C.Types.kern_invalid_right
let kern_invalid_value : kern_return_t = C.Types.kern_invalid_value
let kern_urefs_overflow : kern_return_t = C.Types.kern_urefs_overflow
let kern_invalid_capability : kern_return_t = C.Types.kern_invalid_capability
let kern_right_exists : kern_return_t = C.Types.kern_right_exists
let kern_invalid_host : kern_return_t = C.Types.kern_invalid_host
let kern_memory_present : kern_return_t = C.Types.kern_memory_present
let kern_memory_data_moved : kern_return_t = C.Types.kern_memory_data_moved
let kern_memory_restart_copy : kern_return_t = C.Types.kern_memory_restart_copy

let kern_invalid_processor_set : kern_return_t =
  C.Types.kern_invalid_processor_set

let kern_policy_limit : kern_return_t = C.Types.kern_policy_limit
let kern_invalid_policy : kern_return_t = C.Types.kern_invalid_policy
let kern_invalid_object : kern_return_t = C.Types.kern_invalid_object
let kern_already_waiting : kern_return_t = C.Types.kern_already_waiting
let kern_default_set : kern_return_t = C.Types.kern_default_set
let kern_exception_protected : kern_return_t = C.Types.kern_exception_protected
let kern_invalid_ledger : kern_return_t = C.Types.kern_invalid_ledger

let kern_invalid_memory_control : kern_return_t =
  C.Types.kern_invalid_memory_control

let kern_invalid_security : kern_return_t = C.Types.kern_invalid_security
let kern_not_depressed : kern_return_t = C.Types.kern_not_depressed
let kern_terminated : kern_return_t = C.Types.kern_terminated
let kern_lock_set_destroyed : kern_return_t = C.Types.kern_lock_set_destroyed
let kern_lock_unstable : kern_return_t = C.Types.kern_lock_unstable
let kern_lock_owned : kern_return_t = C.Types.kern_lock_owned
let kern_lock_owned_self : kern_return_t = C.Types.kern_lock_owned_self
let kern_semaphore_destroyed : kern_return_t = C.Types.kern_semaphore_destroyed

let kern_rpc_server_terminated : kern_return_t =
  C.Types.kern_rpc_server_terminated

let kern_rpc_terminate_orphan : kern_return_t =
  C.Types.kern_rpc_terminate_orphan

let kern_rpc_continue_orphan : kern_return_t = C.Types.kern_rpc_continue_orphan
let kern_not_supported : kern_return_t = C.Types.kern_not_supported
let kern_node_down : kern_return_t = C.Types.kern_node_down
let kern_not_waiting : kern_return_t = C.Types.kern_not_waiting
let kern_operation_timed_out : kern_return_t = C.Types.kern_operation_timed_out
let kern_codesign_error : kern_return_t = C.Types.kern_codesign_error
let kern_policy_static : kern_return_t = C.Types.kern_policy_static
let kern_return_max : kern_return_t = C.Types.kern_return_max

(** Types corresponds to `mach/i386/boolean.h` *)

type boolean_t = int32
(** A C [int]. *)

let boolean_t = int32_t

type mach_msg_type_number_t = natural_t
(** Types corresponds to `mach/message.h` *)

let mach_msg_type_number_t = natural_t

type vm_prot_t = integer_t
(** Types corresponding to `mach/vm_prot.h` *)

let vm_prot_t = integer_t

(** Protection values, defined as bits within the [vm_prot_t] type. *)

(** Read permissions *)
let vm_prot_read = C.Types.vm_prot_read

(** Write permissions *)
let vm_prot_write = C.Types.vm_prot_write

(** Execute permissions *)
let vm_prot_execute = C.Types.vm_prot_execute

(** The default protection for newly-created virtual memory *)
let vm_prot_default = Int32.logor vm_prot_read vm_prot_write

(** Types corresponding to `mach/vm_region.h` *)

type vm_inherit_t = natural_t

let vm_inherit_t = natural_t

type memory_object_offset_t = uint64_t
(** A 64-bit offset into a memory object. *)

let memory_object_offset_t = uint64_t

type vm_region_info_t = integer_t ptr
(** A caller-supplied buffer for the info structure selected by the flavor. *)

let vm_region_info_t = ptr integer_t

type vm_region_info_64_t = vm_region_info_t

let vm_region_info_64_t = vm_region_info_t

type vm_region_recurse_info_t = integer_t ptr
(** A pointer to a caller-supplied info buffer, not a scalar. *)

let vm_region_recurse_info_t = ptr integer_t

type vm_region_recurse_info_64_t = natural_t
type vm_behavior_t = integer_t

let vm_behavior_t = integer_t

type vm32_object_id_t = Unsigned.uint32

let vm32_object_id_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint32_t

type vm_object_id_t = Unsigned.uint64

let vm_object_id_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

type vm_region_basic_info_64 = C.Types.vm_region_basic_info_64

let vm_region_basic_info_64 : vm_region_basic_info_64 structure typ =
  C.Types.vm_region_basic_info_64

let protection = C.Types.vmr_protection
let max_protection = C.Types.vmr_max_protection
let inheritance = C.Types.vmr_inheritance
let shared = C.Types.vmr_shared
let reserved = C.Types.vmr_reserved
let offset = C.Types.vmr_offset
let behavior = C.Types.vmr_behavior
let user_wired_count = C.Types.vmr_user_wired_count

type vm_region_basic_info_64_t = vm_region_basic_info_64

let vm_region_basic_info_64_t = vm_region_basic_info_64

type vm_region_submap_info_64 = C.Types.vm_region_submap_info_64

let vm_region_submap_info_64 : vm_region_submap_info_64 structure typ =
  C.Types.vm_region_submap_info_64

let submap_protection = C.Types.vms_protection
let submap_max_protection = C.Types.vms_max_protection
let submap_inheritance = C.Types.vms_inheritance
let submap_offset = C.Types.vms_offset
let user_tag = C.Types.vms_user_tag
let pages_resident = C.Types.vms_pages_resident
let pages_shared_now_private = C.Types.vms_pages_shared_now_private
let pages_swapped_out = C.Types.vms_pages_swapped_out
let pages_dirtied = C.Types.vms_pages_dirtied
let ref_count = C.Types.vms_ref_count
let shadow_depth = C.Types.vms_shadow_depth
let external_pager = C.Types.vms_external_pager
let share_mode = C.Types.vms_share_mode
let is_submap = C.Types.vms_is_submap
let submap_behavior = C.Types.vms_behavior
let object_id = C.Types.vms_object_id
let submap_user_wired_count = C.Types.vms_user_wired_count
(* TODO How to handle flags that appear in a newer SDK version? *)
(* let submap_flags = C.Types.vms_flags *)
(* let pages_reusable = C.Types.vms_pages_reusable *)
(* let object_id_full = C.Types.vms_object_id_full *)

type vm_region_submap_info_data_64_t = vm_region_submap_info_64

let vm_region_submap_info_data_64_t = vm_region_submap_info_64

(** Types and functions from `mach/mach_vm.h` *)

let mach_vm_region_recurse = C.Functions.mach_vm_region_recurse

(** Routine mach_vm_read *)
let mach_vm_read = C.Functions.mach_vm_read

(** Routine mach_vm_write *)
let mach_vm_write = C.Functions.mach_vm_write

(** Routine mach_vm_protect *)
let mach_vm_protect = C.Functions.mach_vm_protect

(** Routine mach_vm_allocate *)
let mach_vm_allocate = C.Functions.mach_vm_allocate

(** Routine mach_vm_deallocate *)
let mach_vm_deallocate = C.Functions.mach_vm_deallocate

(** Routine vm_deallocate for cleanup *)
let vm_deallocate = C.Functions.vm_deallocate

(** Types and functions from `mach/mach_port.h` *)

type ipc_space_t = mach_port_t

let ipc_space_t = mach_port_t

type mach_port_right_t = natural_t

let mach_port_right_t = natural_t
let mach_port_allocate = C.Functions.mach_port_allocate
let mach_port_deallocate = C.Functions.mach_port_deallocate
let mach_port_mod_refs = C.Functions.mach_port_mod_refs

type mach_port_delta_t = integer_t

let mach_port_delta_t = integer_t

(** MACH_PORT_RIGHT_SEND *)
let mach_port_right_send : mach_port_right_t = C.Types.mach_port_right_send

(** mach_msg_type_name_t constants for port rights *)
let mach_msg_type_make_send : mach_msg_type_name_t =
  C.Types.mach_msg_type_make_send

(** MACH_PORT_RIGHT_RECEIVE *)
let mach_port_right_receive : mach_port_right_t =
  C.Types.mach_port_right_receive

let mach_port_insert_right = C.Functions.mach_port_insert_right

(* let mach_port_names = *)
(*   foreign "mach_port_names" (ipc_space_t @-> ptr mach_port_name_array_t @-> ptr mach_msg_type_number_t *)
(*     @-> ptr mach_port_type_array_t @-> ptr mach_msg_type_number_t @-> returning kern_return_t) *)

(** Types and functions from `mach/mach_traps.h` *)

(* extern kern_return_t task_for_pid(
        mach_port_name_t target_tport,
        int pid,
        mach_port_name_t *t);
 *)
let task_for_pid = C.Functions.task_for_pid
let task_name_for_pid = C.Functions.task_name_for_pid
let pid_for_task = C.Functions.pid_for_task

(** Types defined in `mach/task_info.h` *)

(** varying array of int *)

let task_info_t = ptr integer_t

type task_flavor_t = natural_t

let task_flavor_t = natural_t

type mach_error_t = natural_t
(** Types defined in `mach/mach_error.h` *)

let mach_error_t = natural_t

(** Returns a string appropriate to the error argument given. *)
let mach_error_string = C.Functions.mach_error_string

(** Returns a string with the error system, subsystem and code. *)
let mach_error_type = C.Functions.mach_error_type

(** Types defined in `mach/types.h` *)

type task_special_port_t = integer_t

let task_special_port_t = integer_t

type thread_act_t = mach_port_t

let thread_act_t = mach_port_t

type thread_act_array_t = thread_act_t ptr
(** An array of thread port names, as returned by [task_threads]. *)

let thread_act_array_t = ptr thread_act_t

(** Types defined in `mach/mach_types.h` *)

(*@ capability strictly _DECREASING_.
 * not ordered the other way around because we want TASK_FLAVOR_CONTROL
 * to be closest to the itk_lock. see task.h.
 *)
type mach_task_flavor_t = Unsigned.uint32

(** a task_t *)
let task_flavor_control : mach_task_flavor_t = Unsigned.UInt32.of_int 0

(** a task_read_t *)
let task_flavor_read : mach_task_flavor_t = Unsigned.UInt32.of_int 1

(** a task_inspect_t *)
let task_flavor_inspect : mach_task_flavor_t = Unsigned.UInt32.of_int 2

(** a task_name_t *)
let task_flavor_name : mach_task_flavor_t = Unsigned.UInt32.of_int 3

let task_flavor_max = task_flavor_name

(** Types defined in `mach/thread_status.h` *)

type thread_state_t = natural_t
(** Variable-length array *)

let thread_state_t = natural_t

type thread_state_flavor_t = integer_t

let thread_state_flavor_t = integer_t

(** Thread state flavors for x86_64 from `mach/i386/thread_status.h` *)

let x86_thread_state32 : thread_state_flavor_t = 1l
let x86_float_state32 : thread_state_flavor_t = 2l
let x86_exception_state32 : thread_state_flavor_t = 3l

let x86_thread_state64 : thread_state_flavor_t =
  C.Types.x86_thread_state64_flavor

let x86_float_state64 : thread_state_flavor_t = 5l
let x86_exception_state64 : thread_state_flavor_t = 6l
let x86_thread_state : thread_state_flavor_t = 7l
let x86_float_state : thread_state_flavor_t = 8l
let x86_exception_state : thread_state_flavor_t = 9l
let x86_debug_state32 : thread_state_flavor_t = 10l
let x86_debug_state64 : thread_state_flavor_t = 11l
let x86_debug_state : thread_state_flavor_t = 12l
let x86_thread_state_count = C.Types.x86_thread_state64_count
let x86_float_state_count = 64

(** Thread state flavors for ARM64 from `mach/arm/thread_status.h` *)

let arm_thread_state64 : thread_state_flavor_t =
  C.Types.arm_thread_state64_flavor

let arm_exception_state64 : thread_state_flavor_t = 7l
let arm_neon_state64 : thread_state_flavor_t = 17l
let arm_thread_state64_count = C.Types.arm_thread_state64_count
let arm_neon_state64_count = 256

(** x86_64 thread state structure *)

type x86_thread_state64_t = C.Types.x86_thread_state64

let x86_thread_state64_t : x86_thread_state64_t structure typ =
  C.Types.x86_thread_state64

let rax = C.Types.x86_rax
let rbx = C.Types.x86_rbx
let rcx = C.Types.x86_rcx
let rdx = C.Types.x86_rdx
let rdi = C.Types.x86_rdi
let rsi = C.Types.x86_rsi
let rbp = C.Types.x86_rbp
let rsp = C.Types.x86_rsp
let r8 = C.Types.x86_r8
let r9 = C.Types.x86_r9
let r10 = C.Types.x86_r10
let r11 = C.Types.x86_r11
let r12 = C.Types.x86_r12
let r13 = C.Types.x86_r13
let r14 = C.Types.x86_r14
let r15 = C.Types.x86_r15
let rip = C.Types.x86_rip
let rflags = C.Types.x86_rflags
let cs = C.Types.x86_cs
let fs = C.Types.x86_fs
let gs = C.Types.x86_gs

(** ARM64 thread state structure *)

(* arm_thread_state64_t comes from the system header; see
   type_description.ml. __x is a 29 element array. *)
type arm_thread_state64_t = C.Types.arm_thread_state64

let arm_thread_state64_t : arm_thread_state64_t structure typ =
  C.Types.arm_thread_state64

let x = C.Types.arm_x
let fp = C.Types.arm_fp
let lr = C.Types.arm_lr
let sp = C.Types.arm_sp
let pc = C.Types.arm_pc
let cpsr = C.Types.arm_cpsr
let pad = C.Types.arm_pad

(** Types defined in `mach/exception_types.h` *)

(** Machine-independent exception definitions. *)

(** Could not access memory.

    Code contains kern_return_t describing error. Subcode contains bad memory
    address *)
(* Exception constants come from the system headers; see type_description.ml.
   A mask is (1 lsl exc), and exception types start at 1. *)

(** Machine-independent exception types. *)

type exception_mask_t = natural_t
(** Unsigned, unlike most of the exception scalars. *)

let exception_mask_t = natural_t
let exc_bad_access : integer_t = C.Types.exc_bad_access
let exc_bad_instruction : integer_t = C.Types.exc_bad_instruction
let exc_arithmetic : integer_t = C.Types.exc_arithmetic
let exc_emulation : integer_t = C.Types.exc_emulation
let exc_software : integer_t = C.Types.exc_software
let exc_breakpoint : integer_t = C.Types.exc_breakpoint
let exc_syscall : integer_t = C.Types.exc_syscall
let exc_mach_syscall : integer_t = C.Types.exc_mach_syscall
let exc_rpc_alert : integer_t = C.Types.exc_rpc_alert
let exc_crash : integer_t = C.Types.exc_crash
let exc_resource : integer_t = C.Types.exc_resource
let exc_guard : integer_t = C.Types.exc_guard
let exc_corpse_notify : integer_t = C.Types.exc_corpse_notify

(** EXC_SOFT_SIGNAL is used with EXC_SOFTWARE to indicate a Unix signal *)
let exc_soft_signal : integer_t = C.Types.exc_soft_signal

(** Exception masks for use with task_set_exception_ports *)

let exc_mask_bad_access : exception_mask_t = C.Types.exc_mask_bad_access

let exc_mask_bad_instruction : exception_mask_t =
  C.Types.exc_mask_bad_instruction

let exc_mask_arithmetic : exception_mask_t = C.Types.exc_mask_arithmetic
let exc_mask_emulation : exception_mask_t = C.Types.exc_mask_emulation
let exc_mask_software : exception_mask_t = C.Types.exc_mask_software
let exc_mask_breakpoint : exception_mask_t = C.Types.exc_mask_breakpoint
let exc_mask_syscall : exception_mask_t = C.Types.exc_mask_syscall
let exc_mask_mach_syscall : exception_mask_t = C.Types.exc_mask_mach_syscall
let exc_mask_rpc_alert : exception_mask_t = C.Types.exc_mask_rpc_alert
let exc_mask_crash : exception_mask_t = C.Types.exc_mask_crash
let exc_mask_resource : exception_mask_t = C.Types.exc_mask_resource
let exc_mask_guard : exception_mask_t = C.Types.exc_mask_guard
let exc_mask_corpse_notify : exception_mask_t = C.Types.exc_mask_corpse_notify

(** EXC_MASK_ALL. Excludes EXC_MASK_CRASH and EXC_MASK_CORPSE_NOTIFY, which
    belong to the crash reporter rather than to a debugger. *)
let exc_mask_all : exception_mask_t = C.Types.exc_mask_all

(** EXC_TYPES_COUNT: the number of exception types, and so the largest number of
    handlers a task can have registered. *)
let exc_types_count = C.Types.exc_types_count

(** Machine-independent exception behaviors *)

let exception_default : integer_t = C.Types.exception_default
let exception_state : integer_t = C.Types.exception_state
let exception_state_identity : integer_t = C.Types.exception_state_identity

(** Send 64-bit code and subcode in the exception header *)
let mach_exception_codes : integer_t = C.Types.mach_exception_codes

(** THREAD_STATE_NONE: the flavor to pass to task_set_exception_ports when the
    behavior is EXCEPTION_DEFAULT, i.e. when no thread state is wanted. *)
let thread_state_none : thread_state_flavor_t = C.Types.thread_state_none

type c_int = int32

let c_int = int32_t

type exception_type_t = c_int

let exception_type_t = c_int

type exception_data_type_t = integer_t

let exception_data_type_t = integer_t

type mach_exception_data_type_t = int64
type exception_behavior_t = c_int

let exception_behavior_t = c_int
let exception_mask_array_t = ptr exception_mask_t
let exception_behavior_array_t = ptr exception_behavior_t

type mach_exception_code_t = mach_exception_data_type_t
type mach_exception_subcode_t = mach_exception_data_type_t

let exception_flavor_array_t = ptr thread_state_flavor_t

(** Types and functions defined in `mach/task.h` *)

let mach_port_array_t = ptr mach_port_t

(** Routine task_terminate *)
let task_terminate = C.Functions.task_terminate

(** Routine task_threads *)
let task_threads = C.Functions.task_threads

(** Routine mach_ports_register *)
let mach_ports_register = C.Functions.mach_ports_register

(** Routine mach_ports_lookup *)
let mach_ports_lookup = C.Functions.mach_ports_lookup

(** Routine task_info *)
let task_info = C.Functions.task_info

(** Routine task_set_info *)
let task_set_info = C.Functions.task_set_info

(** Routine task_suspend *)
let task_suspend = C.Functions.task_suspend

(** Routine task_resume *)
let task_resume = C.Functions.task_resume

(** Routine task_get_special_port *)
let task_get_special_port = C.Functions.task_get_special_port

(** Routine task_set_special_port *)
let task_set_special_port = C.Functions.task_set_special_port

(** Routine thread_create *)
let thread_create = C.Functions.thread_create

(** Routine thread_create_running *)
let thread_create_running = C.Functions.thread_create_running

(** Routine thread_get_state *)
let thread_get_state = C.Functions.thread_get_state

(** Routine thread_set_state *)
let thread_set_state = C.Functions.thread_set_state

(** Types and functions from `mach/thread_info.h` *)

let thread_info_t = ptr integer_t

type thread_flavor_t = natural_t

let thread_flavor_t = natural_t

(** Routine thread_info *)
let thread_info = C.Functions.thread_info

(** Thread info flavors from mach/thread_info.h *)
let thread_basic_info : thread_flavor_t = C.Types.thread_basic_info_flavor

let thread_identifier_info : thread_flavor_t =
  C.Types.thread_identifier_info_flavor

let thread_basic_info_count = C.Types.thread_basic_info_count
let thread_identifier_info_count = C.Types.thread_identifier_info_count

type thread_basic_info_t = C.Types.thread_basic_info

let thread_basic_info_t : thread_basic_info_t structure typ =
  C.Types.thread_basic_info

let user_time = C.Types.tbi_user_time
let system_time = C.Types.tbi_system_time
let cpu_usage = C.Types.tbi_cpu_usage
let policy = C.Types.tbi_policy
let run_state = C.Types.tbi_run_state
let flags = C.Types.tbi_flags
let suspend_count = C.Types.tbi_suspend_count
let sleep_time = C.Types.tbi_sleep_time

type thread_identifier_info_t = C.Types.thread_identifier_info

let thread_identifier_info_t : thread_identifier_info_t structure typ =
  C.Types.thread_identifier_info

let thread_id = C.Types.tii_thread_id
let thread_handle = C.Types.tii_thread_handle
let dispatch_qaddr = C.Types.tii_dispatch_qaddr

(** Routine thread_suspend *)
let thread_suspend = C.Functions.thread_suspend

(** Routine mach_vm_region *)
let mach_vm_region = C.Functions.mach_vm_region

type vm_region_flavor_t = integer_t
(** Selects which vm_region info structure is returned. *)

let vm_region_flavor_t = integer_t

(** VM_REGION_BASIC_INFO_64 and its count, for use with [mach_vm_region] *)
let vm_region_basic_info_64_flavor : vm_region_flavor_t =
  C.Types.vm_region_basic_info_64_flavor

let vm_region_basic_info_count_64 = C.Types.vm_region_basic_info_count_64

(** Routine thread_abort *)
let thread_abort = C.Functions.thread_abort

(** Routine thread_abort_safely *)
let thread_abort_safely = C.Functions.thread_abort_safely

(** Routine thread_set_exception_ports *)
let thread_set_exception_ports = C.Functions.thread_set_exception_ports

(** Routine thread_get_exception_ports *)
let thread_get_exception_ports = C.Functions.thread_get_exception_ports

(** Routine thread_resume *)
let thread_resume = C.Functions.thread_resume

(** Routine task_set_exception_ports *)
let task_set_exception_ports = C.Functions.task_set_exception_ports

(* typedef mach_port_t             exception_handler_t;  *)
type exception_handler_t = mach_port_t

let exception_handler_t = mach_port_t

(* typedef exception_handler_t     *exception_handler_array_t *)
let exception_handler_array_t = ptr exception_handler_t

(** Routine task_get_exception_ports *)
let task_get_exception_ports = C.Functions.task_get_exception_ports

(** Types and functions defined in `mach/mach_init.h` *)

let mach_thread_self = C.Functions.mach_thread_self
let mach_task_self = C.Functions.mach_task_self

(** Types from `sys/_types.h` *)
let uid_t = uint32_t

let gid_t = uint32_t

(** Types and functions from `sys/proc_info.h` *)

(* pbi_flags values *)
type pbi_flags =
  | PROC_FLAG_SYSTEM  (** System process *)
  | PROC_FLAG_TRACED  (** process currently being traced, possibly by gdb *)
  | PROC_FLAG_INEXIT  (** process is working its way in exit() *)
  | PROC_FLAG_PPWAIT
  | PROC_FLAG_LP64  (** 64bit process *)
  | PROC_FLAG_SLEADER  (** The process is the session leader *)
  | PROC_FLAG_CTTY  (** process has a control tty *)
  | PROC_FLAG_CONTROLT  (** Has a controlling terminal *)
  | PROC_FLAG_THCWD  (** process has a thread with cwd *)
  (* process control bits for resource starvation *)
  | PROC_FLAG_PC_THROTTLE
      (** In resource starvation situations, this process is to be throttled *)
  | PROC_FLAG_PC_SUSP
      (** In resource starvation situations, this process is to be suspended *)
  | PROC_FLAG_PC_KILL
      (** In resource starvation situations, this process is to be terminated *)
  (* | PROC_FLAG_PC_MASK       0x600 *)
  (* This appears to be a C convenience defintion *)
  (* process action bits for resource starvation *)
  | PROC_FLAG_PA_THROTTLE
      (** The process is currently throttled due to resource starvation *)
  | PROC_FLAG_PA_SUSP
      (** The process is currently suspended due to resource starvation *)
  | PROC_FLAG_PSUGID  (** process has set privileges since last exec *)
  | PROC_FLAG_EXEC  (** process has called exec *)

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
  | SIDL (* Process being created by fork. *)
  | SRUN (* Currently runnable. *)
  | SSLEEP (* Sleeping on an address. *)
  | SSTOP (* Process debugging or suspension. *)
  | SZOMB (* Awaiting collection by parent. *)

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

type proc_bsdshortinfo = C.Types.proc_bsdshortinfo

let proc_bsdshortinfo : proc_bsdshortinfo structure typ =
  C.Types.proc_bsdshortinfo

let pbsi_pid = C.Types.pbsi_pid
let pbsi_ppid = C.Types.pbsi_ppid
let pbsi_pgid = C.Types.pbsi_pgid
let pbsi_status = C.Types.pbsi_status
let pbsi_comm = C.Types.pbsi_comm
let pbsi_flags = C.Types.pbsi_flags
let pbsi_uid = C.Types.pbsi_uid
let pbsi_gid = C.Types.pbsi_gid
let pbsi_ruid = C.Types.pbsi_ruid
let pbsi_rgid = C.Types.pbsi_rgid
let pbsi_svuid = C.Types.pbsi_svuid
let pbsi_svgid = C.Types.pbsi_svgid
let pbsi_rfu = C.Types.pbsi_rfu

(* int proc_pidinfo(int pid, int flavor, uint64_t arg, void *buffer, int buffersize); *)
let proc_pidinfo = C.Functions.proc_pidinfo

(* int proc_regionfilename(int pid, uint64_t address, void * buffer, uint32_t buffersize) *)
let proc_regionfilename = C.Functions.proc_regionfilename
