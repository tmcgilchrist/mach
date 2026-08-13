(** C constants and layouts read from the system headers.

    Everything here is resolved by the C compiler against the real Mach headers
    rather than transcribed by hand. That matters: the hand-written exc_mask_*
    values were all defined one bit too low, which made task_set_exception_ports
    reject every call with KERN_INVALID_ARGUMENT, and nothing in OCaml could
    have caught it. *)

module Types (F : Ctypes.TYPE) = struct
  open F

  (* mach/exception_types.h - exception types *)
  let exc_bad_access = constant "EXC_BAD_ACCESS" int32_t
  let exc_bad_instruction = constant "EXC_BAD_INSTRUCTION" int32_t
  let exc_arithmetic = constant "EXC_ARITHMETIC" int32_t
  let exc_emulation = constant "EXC_EMULATION" int32_t
  let exc_software = constant "EXC_SOFTWARE" int32_t
  let exc_breakpoint = constant "EXC_BREAKPOINT" int32_t
  let exc_syscall = constant "EXC_SYSCALL" int32_t
  let exc_mach_syscall = constant "EXC_MACH_SYSCALL" int32_t
  let exc_rpc_alert = constant "EXC_RPC_ALERT" int32_t
  let exc_crash = constant "EXC_CRASH" int32_t
  let exc_resource = constant "EXC_RESOURCE" int32_t
  let exc_guard = constant "EXC_GUARD" int32_t
  let exc_corpse_notify = constant "EXC_CORPSE_NOTIFY" int32_t

  (* mach/exception_types.h - masks, which are (1 lsl exception_type) *)
  let exc_mask_bad_access = constant "EXC_MASK_BAD_ACCESS" int32_t
  let exc_mask_bad_instruction = constant "EXC_MASK_BAD_INSTRUCTION" int32_t
  let exc_mask_arithmetic = constant "EXC_MASK_ARITHMETIC" int32_t
  let exc_mask_emulation = constant "EXC_MASK_EMULATION" int32_t
  let exc_mask_software = constant "EXC_MASK_SOFTWARE" int32_t
  let exc_mask_breakpoint = constant "EXC_MASK_BREAKPOINT" int32_t
  let exc_mask_syscall = constant "EXC_MASK_SYSCALL" int32_t
  let exc_mask_mach_syscall = constant "EXC_MASK_MACH_SYSCALL" int32_t
  let exc_mask_rpc_alert = constant "EXC_MASK_RPC_ALERT" int32_t
  let exc_mask_crash = constant "EXC_MASK_CRASH" int32_t
  let exc_mask_resource = constant "EXC_MASK_RESOURCE" int32_t
  let exc_mask_guard = constant "EXC_MASK_GUARD" int32_t
  let exc_mask_corpse_notify = constant "EXC_MASK_CORPSE_NOTIFY" int32_t

  (* Excludes EXC_MASK_CRASH and EXC_MASK_CORPSE_NOTIFY, which belong to the
     crash reporter rather than to a debugger. *)
  let exc_mask_all = constant "EXC_MASK_ALL" int32_t

  (* EXC_SOFTWARE code marking a Unix signal *)
  let exc_soft_signal = constant "EXC_SOFT_SIGNAL" int32_t

  (* mach/exception_types.h - behaviours *)
  let exception_default = constant "EXCEPTION_DEFAULT" int32_t
  let exception_state = constant "EXCEPTION_STATE" int32_t
  let exception_state_identity = constant "EXCEPTION_STATE_IDENTITY" int32_t

  (* 0x80000000: a flag, so it is carried as the negative int32 with that bit
     pattern to match the rest of the behaviour constants. *)
  let mach_exception_codes = constant "MACH_EXCEPTION_CODES" int32_t

  (* mach/thread_status.h. The flavor to pass alongside EXCEPTION_DEFAULT,
     which carries no thread state. *)
  let thread_state_none = constant "THREAD_STATE_NONE" int32_t

  (* mach/vm_prot.h *)
  let vm_prot_read = constant "VM_PROT_READ" int32_t
  let vm_prot_write = constant "VM_PROT_WRITE" int32_t
  let vm_prot_execute = constant "VM_PROT_EXECUTE" int32_t

  (* mach/port.h and mach/message.h *)
  let mach_port_right_receive = constant "MACH_PORT_RIGHT_RECEIVE" int32_t
  let mach_msg_type_make_send = constant "MACH_MSG_TYPE_MAKE_SEND" int32_t
end
