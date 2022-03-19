#!/bin/bash

# Directory where buildroot project is stored:
BUILDROOT_DIR=$(dirname $0)/..

# Directory where buildroot will be build:
BUILD_DIR=$(pwd)

# ---------------------------------------------------------------------
# Wrapper for 'make' to support 'out-of-tree' builds:
make_wrapper( )
{
    local TARGET=$1

    make O=$BUILD_DIR -C $BUILDROOT_DIR $TARGET
}

# Support function to configure the 'buildroot' project:
configure_buildroot( )
{
    echo "Configure buildroot..."

    local DEF=$1

    # Subsequent 'make' fails if this file is missing:
    touch $BUILD_DIR/.br-external.mk

    make_wrapper $DEF
}

# Support function to download required source files:
download_source( )
{
    echo "Download required source files..."
    make_wrapper source
}

# ---------------------------------------------------------------------
# Execute the build process:
execute( )
{
    local DEF=$1

    # 1.) Configure buildroot project:
    configure_buildroot $DEF

    # 2.) Download all required sources:
    download_source

    # 3.) Now finalize the build process by calling 'make':
    make_wrapper
}

# To display help information:
usage( )
{
    echo "Usage: $(basename $0) -b DEFCONFIG"
    echo "For 'out of tree' builds call script within build directory."
    echo "Example:"
    echo "mkdir output && cd output && ../buildroot/scripts/build.sh -b parrot_mambo_defconfig"
}

# ---------------------------------------------------------------------
if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

while getopts ":hb" option; do
    case $option in
        h) usage
           ;;
        b) execute $2
           ;;
        *) echo "Option not supported"
           ;;
    esac
done
