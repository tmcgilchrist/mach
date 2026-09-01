# Makefile for macOS Mach API debugging examples
#
# These examples demonstrate how to replicate Linux ptrace functionality
# using macOS's Mach kernel API.
#
# Requirements:
#   - macOS (Darwin kernel)
#   - Debugger entitlements or root access
#
# Usage:
#   make              # Build all examples
#   make sign         # Sign all examples with debugger entitlements
#   make clean        # Remove all built examples
#   make help         # Show this help

CC = clang
CFLAGS = -Wall -Wextra -O2 -g
FRAMEWORKS = -framework CoreFoundation

# All C examples
EXAMPLES = simple_attach memory_access register_access \
           examine_threads_c mach_exception

# Entitlements file (already exists in this directory)
ENTITLEMENTS = debugserver-macos-entitlements.plist

.PHONY: all clean sign help

all: $(EXAMPLES)
	@echo ""
	@echo "✓ Built all examples successfully!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Sign with entitlements: make sign"
	@echo "  2. Or run as root: sudo ./simple_attach <pid>"
	@echo ""
	@echo "Examples:"
	@echo "  ./simple_attach <pid>              # Attach to a process"
	@echo "  ./memory_access <pid> <addr> <sz>  # Read/write memory"
	@echo "  ./register_access <pid>             # Read/write registers"
	@echo "  ./examine_threads_c <pid>           # Examine all threads"
	@echo "  ./mach_exception                    # Exception handling demo"

# Simple attach example
simple_attach: simple_attach.c
	$(CC) $(CFLAGS) $(FRAMEWORKS) -o $@ $<

# Memory access example
memory_access: memory_access.c
	$(CC) $(CFLAGS) $(FRAMEWORKS) -o $@ $<

# Register access example
register_access: register_access.c
	$(CC) $(CFLAGS) $(FRAMEWORKS) -o $@ $<

# Examine threads example
examine_threads_c: examine_threads.c
	$(CC) $(CFLAGS) $(FRAMEWORKS) -o $@ $<

# Mach exception handling example
mach_exception: mach_exception.c
	$(CC) $(CFLAGS) $(FRAMEWORKS) -o $@ $<

# Sign all examples with debugger entitlements
sign: $(EXAMPLES)
	@echo "Signing examples with debugger entitlements..."
	@for example in $(EXAMPLES); do \
		echo "  Signing $$example..."; \
		codesign -s - --entitlements $(ENTITLEMENTS) --force $$example 2>/dev/null || \
		echo "    Warning: Failed to sign $$example"; \
	done
	@echo "✓ Done signing!"
	@echo ""
	@echo "Verify signatures with:"
	@echo "  codesign -d --entitlements - ./simple_attach"

clean:
	rm -f $(EXAMPLES)
	@echo "✓ Cleaned up all examples"

help:
	@echo "macOS Mach API Debugging Examples"
	@echo ""
	@echo "These examples demonstrate how Linux ptrace features map to macOS Mach API:"
	@echo ""
	@echo "  simple_attach     - Attach to a process (task_for_pid + task_suspend)"
	@echo "  memory_access     - Read/write memory (mach_vm_read/write)"
	@echo "  register_access   - Read/write registers (thread_get_state/thread_set_state)"
	@echo "  examine_threads_c - List and examine all threads in a process"
	@echo "  mach_exception    - Exception handling with Mach exception ports"
	@echo ""
	@echo "Build commands:"
	@echo "  make              Build all examples"
	@echo "  make sign         Sign with debugger entitlements"
	@echo "  make clean        Remove built examples"
	@echo ""
	@echo "Running examples:"
	@echo "  Option 1: With entitlements (recommended)"
	@echo "    make && make sign"
	@echo "    ./simple_attach <pid>"
	@echo ""
	@echo "  Option 2: As root"
	@echo "    make"
	@echo "    sudo ./simple_attach <pid>"
	@echo ""
	@echo "Related blog post:"
	@echo "  docs/ptracing-the-hard-way-macos.md"
