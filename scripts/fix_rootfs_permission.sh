#!/bin/bash

# Executed by 'buildroot' as a 'POST_BUILD_SCRIPT' to fix dedicated file permissions.

# Root directory of rootfs:
ROOT_DIR=$1

# ---------------------------------------------------------------------
# Fix ssh file permissions:
chmod 400 $ROOT_DIR/etc/ssh/*
