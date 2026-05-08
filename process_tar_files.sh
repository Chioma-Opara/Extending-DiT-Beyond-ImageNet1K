# --------------------------------------------------------
# ImageNet-21K Pretraining for The Masses
# Copyright 2021 Alibaba MIIL (c)
# Licensed under MIT License [see the LICENSE file for details]
# Written by Tal Ridnik
# Edited by Chioma Opara (4/26/2026)
# --------------------------------------------------------

export ROOT=/Users/copara/imagenet_tars

# replace with cd into the tar files 
cd $ROOT

find . -type f -print | wc -l # should be 163 for your files    

# extracting all tar's 
for f in *.tar; do
    target_folder="${f%.*}"
    mkdir -p "$target_folder"
    tar -xf "$f" -C "$target_folder"
done

# counting the nubmer of classes
find ./ -mindepth 1 -type d | wc -l # should be 163

# delete all tar's
rm *.tar

# Remove uncommon classes for transfer learning
BACKUP=/Users/copara/imagenet_tars_small_classes
mkdir -p ${BACKUP}
for c in ${ROOT}/n*; do
    count=`ls $c/*.JPEG | wc -l`
    if [ "$count" -gt "600" ]; then
        echo "keep $c, count = $count"
    else
        echo "remove $c, $count"
        mv $c ${BACKUP}/
    fi
done

# counting the number of valid classes
find ./ -mindepth 1 -type d | wc -l  # TODO: what number do you have here; if you have less than 100 files, you need to download new classes

# create validation set, 60 images in each folder
VAL_ROOT=/Users/copara/imagenet102_val
mkdir -p ${VAL_ROOT}
export ROOT=/Users/copara/imagenet102_train
for i in ${ROOT}/n*; do
    c=`basename $i`
    echo $c
    mkdir -p ${VAL_ROOT}/$c
    for j in `ls $i/*.JPEG | shuf | head -n 60`; do
    # for j in `ls $i/*.JPEG | head -n 50`; do # no shuf for reproducibility
        mv $j ${VAL_ROOT}/$c/
    done
done

# TODO: create test data as well