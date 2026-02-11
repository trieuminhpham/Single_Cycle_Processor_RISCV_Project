## Single Cycle RISC-V RV32I Processor

A 32-bit Single Cycle Processor implementation based on the RISC-V (RV32I) Instruction Set Architecture (ISA). This project is designed for educational purposes, focusing on understanding the fundamental stages of computer architecture: Fetch, Decode, Execute, Memory, and Writeback.
## Features

    Architecture: RISC-V 32-bit (RV32I).

    Type: Single Cycle (Every instruction completes in one clock cycle).

    Language: Verilog/SystemVerilog.

    Supported Instructions:

        R-type: add, sub, and, or, sll, slt, xor, srl.

        I-type: addi, lw, jalr, andi, ori, xori.

        S-type: sw.

        B-type: beq, bne, blt, bge.

        U-type: lui, auipc.

        J-type: jal.

## Block Diagram

<img width="2078" height="1208" alt="image" src="https://github.com/user-attachments/assets/d2a525ca-e13d-410c-95b7-53b042f75b8a" />


## Limitations & Assumptions

    Note: Please consider the following points when evaluating or testing this implementation.

    No Pipelining: This is a single-cycle implementation. The clock period is determined by the slowest path (Load instruction), so it is not optimized for high frequency.

    Memory Constraints: The current design assumes a unified or ideal single-cycle memory. It does not handle cache misses or memory stalls.

    Exception Handling: Not implemented. The processor does not support interrupts or CSR (Control and Status Registers) for exception handling.

