# Mach 5

An OCaml interface to the **user-space** API of the Mach 3.0 kernel that underlies macOS. This library targets the API defined in `usr/include/mach` under the specific MacOSX sdk. eg `/Library/Developer/CommandLineTools/SDKs/MacOSX15.2.sdk/usr/include/`

This library does not target the **kernel-space** API of Mach 3.0 kernel exposed in `/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/mach` eg `/Library/Developer/CommandLineTools/SDKs/MacOSX15.2.sdk/System/Library/Frameworks/Kernel.framework/Versions/A/Headers/mach`

This library is __Under Development__ and should be considered unstable.

## Motivation

My motivations for writing this are to:
 1. Implement equivalent functionality to ptrace on Linux for macOS e.g. Reading/writing memory or registers.
 2. Write utilities to get process virtual memory mappings
 3. Finally learning ctypes under pressure.

## Examples

OCaml examples can be found in the [examples](./examples) directory of this repository. The C versions have been sourced from various locations and have attribution where possible.

## Platform support

The following table describes the current CI set-up:
| Target                 | XCode  | build | ctest | run |
|------------------------|--------|-------|-------|-----|
| `x86_64-apple-darwin`  | 15.2.* | ✓     | ✓     | ✓   |
| `aarch64-apple-darwin` | 16.4.* | ✓     | ✓     | ✓   |
