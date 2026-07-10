#!/bin/bash
# 通用仿真脚本（带 GTKWave 自动打开）
# 用法：在模块目录下执行 bash ../../scripts/run_sim.sh <顶层模块名>
# 例如：在 spi_master 目录下：bash ../../scripts/run_sim.sh spi_master

TOP_MODULE=$1
if [ -z "$TOP_MODULE" ]; then
    echo "错误：缺少顶层模块名"
    echo "用法：$0 <top_module_name>"
    exit 1
fi

RTL_DIR="rtl"
TB_DIR="tb"
SIM_DIR="sim/bin"
WAVE_DIR="sim/wave"

mkdir -p ${SIM_DIR} ${WAVE_DIR}

# 编译
iverilog -g2012 -o ${SIM_DIR}/${TOP_MODULE}_sim \
    ${RTL_DIR}/*.v \
    ${TB_DIR}/*_tb.v

# 如果编译成功，运行仿真
if [ $? -eq 0 ]; then
    vvp ${SIM_DIR}/${TOP_MODULE}_sim
    echo "仿真完成"

    # 自动打开波形
    WAVE_FILE="${WAVE_DIR}/${TOP_MODULE}_tb.vcd"
    if [ -f "$WAVE_FILE" ]; then
        gtkwave "$WAVE_FILE" &
    else
        echo "警告：波形文件 $WAVE_FILE 未生成，请检查 testbench 中的 \$dumpfile"
    fi
else
    echo "编译失败，请检查错误信息"
fi
