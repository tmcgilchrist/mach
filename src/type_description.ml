(** C constants and layouts, resolved by the C compiler against the system Mach
    headers. *)

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
     crash reporter. *)
  let exc_mask_all = constant "EXC_MASK_ALL" int32_t

  (* EXC_SOFTWARE code marking a Unix signal *)
  let exc_soft_signal = constant "EXC_SOFT_SIGNAL" int32_t

  (* mach/exception_types.h - behaviours *)
  let exception_default = constant "EXCEPTION_DEFAULT" int32_t
  let exception_state = constant "EXCEPTION_STATE" int32_t
  let exception_state_identity = constant "EXCEPTION_STATE_IDENTITY" int32_t

  (* 0x80000000, carried as the int32 with that bit pattern. *)
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

  (* mach_thread_state.h. Declared locally because <mach/arm/_structs.h> is
     guarded on __arm64__ and so is invisible to an x86_64 build; that header
     static_asserts this layout against the system one wherever it exists. *)
  type arm_thread_state64

  let arm_thread_state64 : arm_thread_state64 Ctypes.structure typ =
    structure "mach_arm_thread_state64"

  let arm_x = field arm_thread_state64 "__x" (array 29 uint64_t)
  let arm_fp = field arm_thread_state64 "__fp" uint64_t
  let arm_lr = field arm_thread_state64 "__lr" uint64_t
  let arm_sp = field arm_thread_state64 "__sp" uint64_t
  let arm_pc = field arm_thread_state64 "__pc" uint64_t
  let arm_cpsr = field arm_thread_state64 "__cpsr" uint32_t
  let arm_pad = field arm_thread_state64 "__pad" uint32_t
  let () = seal arm_thread_state64
  let arm_thread_state64_flavor = constant "MACH_ARM_THREAD_STATE64" int32_t
  let arm_thread_state64_count = constant "MACH_ARM_THREAD_STATE64_COUNT" int

  (* mach_thread_state.h. Declared locally because <mach/i386/_structs.h> is
     guarded on __x86_64__ and so is invisible to an arm64 build; that header
     static_asserts this layout against the system one wherever it exists, so
     an arm64 tdb can still read x86_64 targets. *)
  type x86_thread_state64

  let x86_thread_state64 : x86_thread_state64 Ctypes.structure typ =
    structure "mach_x86_thread_state64"

  let x86_rax = field x86_thread_state64 "__rax" uint64_t
  let x86_rbx = field x86_thread_state64 "__rbx" uint64_t
  let x86_rcx = field x86_thread_state64 "__rcx" uint64_t
  let x86_rdx = field x86_thread_state64 "__rdx" uint64_t
  let x86_rdi = field x86_thread_state64 "__rdi" uint64_t
  let x86_rsi = field x86_thread_state64 "__rsi" uint64_t
  let x86_rbp = field x86_thread_state64 "__rbp" uint64_t
  let x86_rsp = field x86_thread_state64 "__rsp" uint64_t
  let x86_r8 = field x86_thread_state64 "__r8" uint64_t
  let x86_r9 = field x86_thread_state64 "__r9" uint64_t
  let x86_r10 = field x86_thread_state64 "__r10" uint64_t
  let x86_r11 = field x86_thread_state64 "__r11" uint64_t
  let x86_r12 = field x86_thread_state64 "__r12" uint64_t
  let x86_r13 = field x86_thread_state64 "__r13" uint64_t
  let x86_r14 = field x86_thread_state64 "__r14" uint64_t
  let x86_r15 = field x86_thread_state64 "__r15" uint64_t
  let x86_rip = field x86_thread_state64 "__rip" uint64_t
  let x86_rflags = field x86_thread_state64 "__rflags" uint64_t
  let x86_cs = field x86_thread_state64 "__cs" uint64_t
  let x86_fs = field x86_thread_state64 "__fs" uint64_t
  let x86_gs = field x86_thread_state64 "__gs" uint64_t
  let () = seal x86_thread_state64
  let x86_thread_state64_flavor = constant "MACH_X86_THREAD_STATE64" int32_t
  let x86_thread_state64_count = constant "MACH_X86_THREAD_STATE64_COUNT" int

  (* mach/thread_info.h. user_time and system_time are time_value_t, a pair of
     integer_t. *)
  type thread_basic_info

  let thread_basic_info : thread_basic_info Ctypes.structure typ =
    structure "thread_basic_info"

  let tbi_user_time = field thread_basic_info "user_time" (array 2 int32_t)
  let tbi_system_time = field thread_basic_info "system_time" (array 2 int32_t)
  let tbi_cpu_usage = field thread_basic_info "cpu_usage" int32_t
  let tbi_policy = field thread_basic_info "policy" int32_t
  let tbi_run_state = field thread_basic_info "run_state" int32_t
  let tbi_flags = field thread_basic_info "flags" int32_t
  let tbi_suspend_count = field thread_basic_info "suspend_count" int32_t
  let tbi_sleep_time = field thread_basic_info "sleep_time" int32_t
  let () = seal thread_basic_info

  type thread_identifier_info

  let thread_identifier_info : thread_identifier_info Ctypes.structure typ =
    structure "thread_identifier_info"

  let tii_thread_id = field thread_identifier_info "thread_id" uint64_t
  let tii_thread_handle = field thread_identifier_info "thread_handle" uint64_t

  let tii_dispatch_qaddr =
    field thread_identifier_info "dispatch_qaddr" uint64_t

  let () = seal thread_identifier_info
  let thread_basic_info_flavor = constant "THREAD_BASIC_INFO" int32_t
  let thread_basic_info_count = constant "THREAD_BASIC_INFO_COUNT" int
  let thread_identifier_info_flavor = constant "THREAD_IDENTIFIER_INFO" int32_t
  let thread_identifier_info_count = constant "THREAD_IDENTIFIER_INFO_COUNT" int

  (* mach/vm_region.h. offset is a memory_object_offset_t, which is 64 bits. *)
  type vm_region_basic_info_64

  let vm_region_basic_info_64 : vm_region_basic_info_64 Ctypes.structure typ =
    structure "vm_region_basic_info_64"

  let vmr_protection = field vm_region_basic_info_64 "protection" int32_t

  let vmr_max_protection =
    field vm_region_basic_info_64 "max_protection" int32_t

  let vmr_inheritance = field vm_region_basic_info_64 "inheritance" int32_t
  let vmr_shared = field vm_region_basic_info_64 "shared" uint32_t
  let vmr_reserved = field vm_region_basic_info_64 "reserved" uint32_t
  let vmr_offset = field vm_region_basic_info_64 "offset" uint64_t
  let vmr_behavior = field vm_region_basic_info_64 "behavior" int32_t

  let vmr_user_wired_count =
    field vm_region_basic_info_64 "user_wired_count" ushort

  let () = seal vm_region_basic_info_64

  type vm_region_submap_info_64

  let vm_region_submap_info_64 : vm_region_submap_info_64 Ctypes.structure typ =
    structure "vm_region_submap_info_64"

  let vms_protection = field vm_region_submap_info_64 "protection" int32_t

  let vms_max_protection =
    field vm_region_submap_info_64 "max_protection" int32_t

  let vms_inheritance = field vm_region_submap_info_64 "inheritance" int32_t
  let vms_offset = field vm_region_submap_info_64 "offset" uint64_t
  let vms_user_tag = field vm_region_submap_info_64 "user_tag" uint32_t

  let vms_pages_resident =
    field vm_region_submap_info_64 "pages_resident" uint32_t

  let vms_pages_shared_now_private =
    field vm_region_submap_info_64 "pages_shared_now_private" uint32_t

  let vms_pages_swapped_out =
    field vm_region_submap_info_64 "pages_swapped_out" uint32_t

  let vms_pages_dirtied =
    field vm_region_submap_info_64 "pages_dirtied" uint32_t

  let vms_ref_count = field vm_region_submap_info_64 "ref_count" uint32_t
  let vms_shadow_depth = field vm_region_submap_info_64 "shadow_depth" ushort
  let vms_external_pager = field vm_region_submap_info_64 "external_pager" uchar
  let vms_share_mode = field vm_region_submap_info_64 "share_mode" uchar
  let vms_is_submap = field vm_region_submap_info_64 "is_submap" uint32_t
  let vms_behavior = field vm_region_submap_info_64 "behavior" int32_t
  let vms_object_id = field vm_region_submap_info_64 "object_id" uint32_t

  let vms_user_wired_count =
    field vm_region_submap_info_64 "user_wired_count" ushort

  let vms_flags = field vm_region_submap_info_64 "flags" ushort

  let vms_pages_reusable =
    field vm_region_submap_info_64 "pages_reusable" uint32_t

  let vms_object_id_full =
    field vm_region_submap_info_64 "object_id_full" uint64_t

  let () = seal vm_region_submap_info_64

  (* sys/proc_info.h *)
  type proc_bsdshortinfo

  let proc_bsdshortinfo : proc_bsdshortinfo Ctypes.structure typ =
    structure "proc_bsdshortinfo"

  let pbsi_pid = field proc_bsdshortinfo "pbsi_pid" uint32_t
  let pbsi_ppid = field proc_bsdshortinfo "pbsi_ppid" uint32_t
  let pbsi_pgid = field proc_bsdshortinfo "pbsi_pgid" uint32_t
  let pbsi_status = field proc_bsdshortinfo "pbsi_status" uint32_t
  let pbsi_comm = field proc_bsdshortinfo "pbsi_comm" (array 16 char)
  let pbsi_flags = field proc_bsdshortinfo "pbsi_flags" uint32_t
  let pbsi_uid = field proc_bsdshortinfo "pbsi_uid" uint32_t
  let pbsi_gid = field proc_bsdshortinfo "pbsi_gid" uint32_t
  let pbsi_ruid = field proc_bsdshortinfo "pbsi_ruid" uint32_t
  let pbsi_rgid = field proc_bsdshortinfo "pbsi_rgid" uint32_t
  let pbsi_svuid = field proc_bsdshortinfo "pbsi_svuid" uint32_t
  let pbsi_svgid = field proc_bsdshortinfo "pbsi_svgid" uint32_t
  let pbsi_rfu = field proc_bsdshortinfo "pbsi_rfu" uint32_t
  let () = seal proc_bsdshortinfo
end
