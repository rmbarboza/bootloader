Basic bootloader with welcome message.
Pressing any key reboots the system.

Bootloader now loads second stage from disk to memory.
The BIOS only loads 1 sector to memory at location 0x7C00 so we need to load the other phase.

This version checks if EDD BIOS is enabled and use this resource to load data from disk.

Now we need to enter protected mode to load kernel from disk to memory.

We need to create a Global Descriptor Table and Interrupt Descriptor Table in order to make things work.
