#!/usr/bin/env bash
set -x

sha=`git rev-parse --short HEAD`
chips=${1:-1}
microbatch=${2:-128}
layers=${3:-24}
microbatch_count=${4:-1}
config=${5:-"large"}
backend_opt=4

# PYARGS="PYBUDA_MODULAR_BERT=1 PYBUDA_SKIP_EMBEDDINGS=1 "

# Enable backend multi-threaded push
export LOGGER_LEVEL=Info
export TT_BACKEND_PUSH_TIMEOUT=100
export TT_BACKEND_GET_TIMEOUT=100
export TT_BACKEND_MULTI_THREADED_PUSH_MAX_THREADS=16
export TT_BACKEND_MULTI_THREADED_PUSH=1

# Enable microbatch looping (default disabled due to pybuda CI running sequential tests)
# Disable dynamic queues (default enabled but is incompatible with inner looping)
if [ $microbatch_count -gt 1 ]; then
PYARGS+="PYBUDA_MICROBATCH_LOOPING=1 "
PYARGS+="PYBUDA_DISABLE_DYNAMIC_DRAM=1 "
fi

echo "Running BERT $config Training on $chips chips, layers=$layers, microbatch=$microbatch, microbatch_count=$microbatch_count, O $backend_opt, SHA $sha"

if [ "$config" == "large" ]; then
    PYARGS+="PYBUDA_EXP_APPROX=1 PYBUDA_FUSE_OPS=1 PYBUDA_NLP_MANUAL_TARGET=85000 PYBUDA_FORCE_INTERMED_TO_OUTPUT_DF=1 PYBUDA_FORK_JOIN_BUF_MULTIPLE=4"
elif [ "$config" == "base" ]; then
    PYARGS+="PYBUDA_EXP_APPROX=1 PYBUDA_FUSE_OPS=1 PYBUDA_FUSED_OP_MULTIPLIER=2 PYBUDA_FORCE_INTERMED_TO_OUTPUT_DF=1"
else
    echo "Unknown config $config" && exit 1
fi

pybuda/test/benchmark/benchmark.py -m bert -c $config -opt $backend_opt -o perf.json --env "$PYARGS" --training --auto_transpose --chips ${chips} --microbatch ${microbatch} --layers ${layers} --microbatch_count ${microbatch_count} |& tee bert_${config}_train_c${chips}_l${layers}_ub${microbatch}_ubc${microbatch_count}_o${backend_opt}_${sha}.log
