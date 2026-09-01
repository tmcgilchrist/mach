# macOS Mach API Debugging Examples

This directory contains practical C examples demonstrating how to replicate Linux `ptrace()` functionality using macOS's Mach kernel API.

## Quick Start

```bash
# Build all examples
make

# Sign with debugger entitlements
make sign

# Run an example
./simple_attach <pid>
```

## Examples

| Example | Purpose | Key APIs Demonstrated |
|---------|---------|----------------------|
| `simple_attach.c` | Attach to a process | `task_for_pid()`, `task_suspend()`, `task_resume()` |
| `memory_access.c` | Read/write memory | `mach_vm_read()`, `mach_vm_write()` |
| `register_access.c` | Read/write registers | `thread_get_state()`, `thread_set_state()` |
| `examine_threads.c` | List and inspect threads | `task_threads()`, `thread_info()` |
| `mach_exception.c` | Exception handling | `mach_port_allocate()`, `task_set_exception_ports()` |

## Requirements

- **macOS** (Darwin kernel)
- **Debugger entitlements** OR **root access**
- **Xcode Command Line Tools** (for `clang`)

## Entitlements

All examples require the `com.apple.security.cs.debugger` entitlement to call `task_for_pid()`. The entitlements file (`debugserver-macos-entitlements.plist`) is included in this directory.

### Option 1: Code Signing with Entitlements (Recommended)

```bash
make sign
./simple_attach <pid>
```

This uses ad-hoc signing (`codesign -s -`) which doesn't require a developer certificate.

### Option 2: Run as Root

```bash
make
sudo ./simple_attach <pid>
```

Running as root bypasses the entitlement requirement but is less secure.

### Verify Signature

```bash
codesign -d --entitlements - ./simple_attach
```

## Usage Examples

### Attach to a Process

```bash
./simple_attach 1234
```

Demonstrates the two-step process: `task_for_pid()` then `task_suspend()`.

### Read Memory

```bash
./memory_access 1234 0x100000000 64
```

Reads 64 bytes from address `0x100000000` in process 1234, displaying a hex dump.

### Inspect Registers

```bash
./register_access 1234
```

Displays all general-purpose registers for all threads in process 1234.

### Examine All Threads

```bash
./examine_threads_c 1234
```

Shows detailed information about each thread: state, PC, suspend count, thread names, etc.

### Test Exception Handling

```bash
./mach_exception
```

Demonstrates setting up Mach exception ports for receiving exceptions from a traced process.

## Common Issues

### "Error: task_for_pid() failed"

**Cause**: Missing entitlements or insufficient permissions.

**Solution**:
- Run `make sign` to add entitlements, OR
- Run as root: `sudo ./simple_attach <pid>`

### "Target process is restricted (SIP protected)"

**Cause**: System Integrity Protection (SIP) prevents debugging system processes.

**Solution**: Only debug your own processes or disable SIP (not recommended).

### Binaries lose entitlements after rebuild

**Cause**: Code signing is not automatic in the build process.

**Solution**: Run `make sign` after each rebuild.

## Implementation Notes

### Why Mach API Instead of ptrace?

macOS's `ptrace()` implementation is minimal:
- Only `PT_TRACE_ME` (0) and `PT_SIGEXC` (12) are supported
- Everything else requires Mach API calls

### Key Differences from Linux

| Feature         | Linux                              | macOS                                   |
|-----------------|------------------------------------|-----------------------------------------|
| Attach          | `PTRACE_ATTACH`                    | `task_for_pid()` + `task_suspend()`     |
| Read Memory     | `PTRACE_PEEKDATA` (word-at-a-time) | `mach_vm_read()` (arbitrary size)       |
| Write Memory    | `PTRACE_POKEDATA` (word-at-a-time) | `mach_vm_write()` (arbitrary size)      |
| Read Registers  | `PTRACE_GETREGS`                   | `thread_get_state()`                    |
| Write Registers | `PTRACE_SETREGS`                   | `thread_set_state()`                    |
| Threads         | Process-centric                    | Thread-centric (each thread has a port) |
| Exceptions      | `waitpid()` signals                | Mach exception ports + `mach_msg()`     |

## License

These examples are part of the tdb debugger project.
