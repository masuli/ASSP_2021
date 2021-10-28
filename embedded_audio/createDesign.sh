#!/bin/sh
PARENT_DIR="AUDIO_CODEC"
C_FILE="program/program.c"
ADF_FILE="processors/aud.adf"
IDF_FILE="processors/aud.idf"
TPEF_FILE="audio.tpef"
OUT_DIR1="output"
IMAGE_DIR="mem_images"
PROCESSOR1NAME="p1_aud"


tcecc -O3 $C_FILE -a $ADF_FILE -o $TPEF_FILE
#ttasim -a $ADF_FILE -p $TPEF_FILE -e 'run; puts [info proc cycles];quit;'
rm -r $OUT_DIR1
generateprocessor -i $IDF_FILE -o $OUT_DIR1 -e $PROCESSOR1NAME $ADF_FILE
generatebits -f mif -d -w 4 -o mif -p $TPEF_FILE -x $OUT_DIR1 -e $PROCESSOR1NAME $ADF_FILE

rm -r $IMAGE_DIR
mkdir $IMAGE_DIR


mv audio_data.mif $IMAGE_DIR/
mv audio.mif $IMAGE_DIR/

