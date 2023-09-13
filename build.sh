#!/bin/bash

echo "Please enter image build-arg:"
read -p 'ap_user: ' AP_USER
read -p 'ap_group: ' AP_GROUP
read -s -p 'root_passwd: ' ROOT_PASSOWRD
echo
read -s -p 'ap_user_password: ' AP_USER_PASSWORD
echo
read -p 'version:' IMG_VER
read -p 'Save image tar?(y/n):' IS_SAVE_TAR
echo "---------------------------------------"

if [ -z "$IMG_VER" ]; then
    echo "---------------------------------------"
    echo ">> ERROR: Please enter version!"
    echo "---------------------------------------"
    exit 1
fi

echo "---------------------------------------"
if [ -n "$AP_USER" ]; then echo "ap_user: $AP_USER"; else echo "ap_user: nanshanuser"; fi
if [ -n "$AP_GROUP" ]; then echo "ap_group: $AP_GROUP"; else echo "ap_group: nanshangrp"; fi
if [ -n "$ROOT_PASSOWRD" ]; then echo "root_passwd: $ROOT_PASSOWRD"; else echo "root_passwd: 1qaz@WSX"; fi
if [ -n "$AP_USER_PASSWORD" ]; then echo "ap_user_password: $AP_USER_PASSWORD"; else echo "ap_user_password: 1qaz@WSX"; fi
echo "version: " $IMG_VER
echo "Save image tar?(y/n):" $IS_SAVE_TAR
echo "---------------------------------------"

docker build -f ./Dockerfile \
    --no-cache \
    --build-arg ap_user=$AP_USER \
    --build-arg ap_group=$AP_GROUP \
    --build-arg root_passwd=$ROOT_PASSOWRD \
    --build-arg ap_user_password=$AP_USER_PASSWORD \
    -t ubuntu:$IMG_VER .

if [[ "$(echo "$IS_SAVE_TAR" | tr '[:upper:]' '[:lower:]')" == "y" ]]; then
    echo "---------------------------------------"
    echo "... Execute docker save tar ..."
    echo "---------------------------------------"
    FILE=ubuntu-$IMG_VER.tar
    if [[ -f "$FILE" ]]; then
        echo ">> $FILE exists, rm $FILE..."
        rm ./$FILE
    fi
    docker save -o ubuntu-$IMG_VER.tar ubuntu:$IMG_VER
else
    if [[ -z "$IS_SAVE_TAR" ]]; then
        echo "---------------------------------------"
        echo ">> ERROR: Please enter IS_SAVE_TAR!"
        echo "---------------------------------------"
        exit 1
    fi
fi