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
type task_name_t = mach_port_t
type user_addr_t = Unsigned.uint64
type vm_map_t = mach_port_t

type vm_task_entry_t = mach_port_t
let vm_task_entry_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint64_t

(** Types and functions corresponding to `mach/port.h`  *)

type mach_port_name_t = natural_t
let mach_port_name_t = natural_t

type kern_return_t = int32
let kern_return_t = natural_t

(** Types corresponds to `mach/i386/boolean.h` *)

type boolean_t = Unsigned.uint32
let boolean_t = Ctypes_static.Primitive Ctypes_primitive_types.Uint32_t

(** Types corresponds to `mach/message.h` *)
type mach_msg_type_number_t = natural_t
let mach_msg_type_number_t = natural_t

(** Types corresponding to `mach/vm_region.h` *)
type vm_prot_t = integer_t
let vm_prot_t = integer_t

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

(** Types and functions from `mach/mach_vm.h` *)

let mach_vm_region_recurse =
  foreign "mach_vm_region_recurse" (
    vm_task_entry_t @-> ptr mach_vm_address_t @-> ptr mach_vm_size_t
    @-> ptr natural_t @-> ptr vm_region_recurse_info_t @-> ptr mach_msg_type_number_t @-> returning kern_return_t)

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

let task_for_pid =
  foreign "task_for_pid" (mach_port_name_t @-> pid_t @-> ptr mach_port_name_t @-> returning kern_return_t)

let task_name_for_pid =
  foreign "task_name_for_pid" (mach_port_name_t @-> pid_t @-> ptr mach_port_name_t @-> returning kern_return_t)

let pid_for_task =
  foreign "pid_for_task" (mach_port_name_t @-> ptr pid_t @-> returning kern_return_t)

(** Types defined in `mach/mach_error.h` *)
type mach_error_t = natural_t
let mach_error_t = natural_t

(** Returns a string appropriate to the error argument given.  *)
let mach_error_string =
  foreign "mach_error_string" (mach_error_t @-> returning string)

(** Returns a string with the error system, subsystem and code.  *)
let mach_error_type =
  foreign "mach_error_type"  (mach_error_t @-> returning string)

(** Types and functions defined in `mach/mach_init.h` *)

let mach_thread_self =
  foreign "mach_thread_self" (void @-> returning mach_port_t)

let mach_task_self =
  foreign "mach_task_self" (void @-> returning uint64_t)

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

