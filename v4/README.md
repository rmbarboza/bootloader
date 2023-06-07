Basic bootloader with welcome message.
Pressing any key reboots the system.

Bootloader now loads second stage from disk to memory.
The BIOS only loads 1 sector to memory at location 0x7C00 so we need to load the other phase.

This version checks if EDD BIOS is enabled and use this resource to load data from disk.
