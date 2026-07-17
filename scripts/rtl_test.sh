#!/bin/bash

COMMAND=$1
TOP_MODULE=$2

RTL_DIR="rtl"
TB_DIR="tb"
SIM_DIR="sim/bin"
WAVE_DIR="sim/wave"

run_check() {
    iverilog -g2012 -Wall -t null ${RTL_DIR}/*.v \
        ${TB_DIR}/*_tb.v
    if [ $? -ne 0 ]; then
        echo "检测失败"
        exit 1
    fi
}

run_sim() {

    mkdir -p ${SIM_DIR} ${WAVE_DIR}

    iverilog -g2012 -o ${SIM_DIR}/${TOP_MODULE}_sim \
        ${RTL_DIR}/*.v \
        ${TB_DIR}/*_tb.v

    if [ $? -eq 0 ]; then
        vvp ${SIM_DIR}/${TOP_MODULE}_sim
        echo "成功编译"
    else
        echo "编译失败"
        exit 1
    fi
}

run_wave() {
    run_sim
    WAVE_FILE="${WAVE_DIR}/${TOP_MODULE}_wave.vcd"
    if [ -f "$WAVE_FILE" ]; then
        gtkwave "$WAVE_FILE" &
    else
        echo "仿真失败"
    fi
}

if [ -z "$TOP_MODULE" ]; then
    echo "没有模块名"
    exit 1
fi

if [ -z "$COMMAND" ]; then
    echo "没有指令"
    exit 1
fi

case "$COMMAND" in
    sim)
        run_sim
        ;;
    check)
        run_check
        ;;
    wave)
        run_wave
        ;;
    *)
        echo "未知指令"
        exit 1
        ;;
esac
