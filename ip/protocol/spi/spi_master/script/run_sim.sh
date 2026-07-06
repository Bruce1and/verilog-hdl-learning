#!/bin/bash
# 在 spi_master 目录下执行：bash run_sim.sh

TOP_MODULE="spi_master"
RTL_DIR="rtl"
TB_DIR="tb"
SIM_DIR="sim/bin"
WAVE_DIR="sim/wave"

mkdir -p ${SIM_DIR} ${WAVE_DIR}

# 编译
iverilog -g2012 -o ${SIM_DIR}/${TOP_MODULE}_sim \
    ${RTL_DIR}/${TOP_MODULE}.v \
    ${TB_DIR}/${TOP_MODULE}_tb.v

# 如果编译成功，运行仿真并生成波形
if [ $? -eq 0 ]; then
    vvp ${SIM_DIR}/${TOP_MODULE}_sim
    # 如果波形文件在仿真里已经指定路径，这里不需要额外操作
    echo "仿真完成，波形文件在 ${WAVE_DIR}/"

    gtkwave ${WAVE_DIR}/${TOP_MODULE}_wave.vcd &
else
    echo "编译失败，请检查错误信息"
fi

