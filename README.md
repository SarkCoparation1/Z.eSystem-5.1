# Z.eSystem Official Guide

## About

Z.eSystem is an experimental x86 operating system written entirely in Assembly language.

The project was created to explore low-level system programming and operating system architecture from scratch. Every core component is implemented manually without relying on external kernels or high-level languages.

Z.eSystem focuses on full hardware control, simplicity, and educational value.

---

## Core Goals

* Build a custom bootloader
* Create a fully custom kernel
* Work directly with x86 hardware
* Understand memory and interrupts
* Develop a native application system
* Provide tools for developers

---

## Architecture

Z.eSystem currently runs on:

* x86 processors
* 32-bit Protected Mode
* MBR boot systems
* VGA text mode display

The operating system boots directly from disk and initializes its own runtime environment.

---

## Main Components

### Bootloader

Responsible for starting the operating system.

Tasks include:

* Loading from MBR
* Preparing memory
* Enabling A20
* Switching to Protected Mode
* Loading the kernel

---

### Kernel

The core of Z.eSystem.

Responsibilities:

* Screen output
* Keyboard input
* Application launching
* System routines
* Memory usage control

---

### Interrupt System

Manages hardware and processor events.

Examples:

* Keyboard interrupts
* CPU exceptions
* Runtime event handling

---

## Application System

Z.eSystem includes its own application format.

Applications can be launched directly by the operating system and interact with kernel services.

This allows external software to run inside the Z.eSystem environment.

---

## Devkit

Z.eSystem Devkit is the official development toolkit.

Features:

* Application development support
* Runtime utilities
* Terminal tools
* Built-in commands
* Testing environment

Current Devkit version:
1.4

---

## Built-in Commands

Available commands include:

* YARDIM
  Displays help information.

* YAZ
  Prints text to the screen.

* TEMIZLE
  Clears the display.

* CIKIS / EXIT
  Exits the Devkit.

---

## Display System

Z.eSystem currently uses VGA text mode.

Features:

* Character-based rendering
* Color attributes
* Direct video memory access
* Lightweight interface

This provides fast rendering with minimal overhead.

---

## Keyboard Support

Current keyboard support includes:

* Alphabet keys
* Number keys
* Space
* Enter
* Backspace
* Escape

Current limitations:

* No Shift support
* No lowercase support
* No Turkish keyboard layout yet

---

## Current Status

Implemented:

* Bootable system image
* Protected Mode
* Kernel runtime
* Interrupt system
* Launchable applications
* Devkit

Planned:

* File system
* Mouse support
* Graphical interface
* Improved memory management
* Networking

---

## Version

Current release:
Z.eSystem 5.1

Latest update:
Devkit is now available.

---

## Project Status

Active Development
Experimental
100% Assembly
