# **Sync FIFO Design Specification**

**1. Project Overview**

Synchronous FIFO (First In First Out) is a common buffer structure used to temporarily store data between modules operating under the same clock domain.

Features:

- Single clock domain
- First-In First-Out data order
- Configurable data width
- Configurable FIFO depth
- Full / Empty status indication
- Support simultaneous read and write

**2. Interface Definition**

**Parameters**

| **Parameter** | **Description** |
| --- | --- |
| DATA_WIDTH | FIFO data width |
| FIFO_DEPTH | FIFO storage depth |
| ADDR_WIDTH | Address width, usually $clog2(FIFO_DEPTH) |

**Ports**

| **Signal** | **Direction** | **Description** |
| --- | --- | --- |
| clk_i | Input | System clock |
| rst_n | Input | Active-low reset |
| wr_en_i | Input | Write enable |
| rd_en_i | Input | Read enable |
| wr_data_i | Input | Write data |
| rd_data_o | Output | Read data |
| full_o | Output | FIFO full flag |
| empty_o | Output | FIFO empty flag |

**3. Internal Architecture**

FIFO consists of:

**Memory Array**

Used to store data.

fifo_mem[0]

fifo_mem[1]

...

fifo_mem[N-1]

**Write Pointer**

Tracks the next write location.

wr_ptr

**Read Pointer**

Tracks the next read location.

rd_ptr

**Data Counter**

Tracks the number of valid data entries currently stored.

data_cnt

**4. Working Principle**

**Write Operation**

Condition:

wr_en_i && !full_o

Actions:

1. Store data into current write address
2. Increment write pointer
3. Increment data count

Example:

wr_ptr = 3

write data

fifo_mem[3] <= wr_data_i

wr_ptr = 4

**Read Operation**

Condition:

rd_en_i && !empty_o

Actions:

1. Read data from current read address
2. Increment read pointer
3. Decrement data count

Example:

rd_ptr = 2

rd_data_o <= fifo_mem[2]

rd_ptr = 3

**Simultaneous Read and Write**

Condition:

wr_en_i && rd_en_i

Actions:

- Write pointer increments
- Read pointer increments
- Data count remains unchanged

data_cnt = data_cnt

FIFO occupancy does not change.

**5. Pointer Wraparound**

When reaching the last address:

FIFO_DEPTH = 16

0 -> 1 -> 2 -> ... -> 15 -> 0

Pointers return to zero.

Example:

if (wr_ptr == FIFO_DEPTH - 1)

wr_ptr <= 0;

else

wr_ptr <= wr_ptr + 1'b1;

**6. Full and Empty Logic**

**Empty**

FIFO contains no valid data.

data_cnt == 0

Verilog:

assign empty_o = (data_cnt == 0);

**Full**

FIFO reaches maximum capacity.

data_cnt == FIFO_DEPTH

Verilog:

assign full_o = (data_cnt == FIFO_DEPTH);

**7. Reset Behavior**

After reset:

wr_ptr = 0

rd_ptr = 0

data_cnt = 0

full_o  = 0

empty_o = 1

FIFO starts in an empty state.

**8. Design Considerations**

**Read Empty FIFO**

Prevent:

rd_en_i && empty_o

Otherwise invalid data may be read.

**Write Full FIFO**

Prevent:

wr_en_i && full_o

Otherwise stored data may be overwritten.

**Simultaneous Read and Write**

Handle explicitly.

Recommended priority:

write only

read only

read + write

idle

or

case ({wr_en_i, rd_en_i})

implementation.

**9. Verification Checklist**

**Basic Function**

- Single write
- Single read
- Multiple writes
- Multiple reads

**Boundary Tests**

- Empty FIFO read
- Full FIFO write
- Pointer wraparound

**Concurrent Operation**

- Read and write simultaneously
- Long continuous transfer

**Status Flags**

- full_o correctness
- empty_o correctness

**10. Future Extensions**

After completing Sync FIFO, continue with:

1. Parameterized FIFO
2. FWFT FIFO (First Word Fall Through)
3. Dual-Port RAM FIFO
4. Asynchronous FIFO
5. AXI-Stream FIFO
6. DMA Buffer Design

These modules form the foundation of many FPGA communication and data-processing systems.
