#!/bin/sh

# Don't forget to adjust this to your Android NDK path !!!
if [ -z "$ANDROID_NDK" ]; then
    export ANDROID_NDK=/opt/android-ndk
fi

# Your workspaces
export DEV_PREFIX=$HOME/blocks-openocd

# host
export CROSS_COMPILE=arm-linux-androideabi

# toolchain
export ANDROID_PREFIX=${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

# sysroot
export SYSROOT=${ANDROID_NDK}/platforms/android-19/arch-arm

# full path of cross compiler and related tools
export CROSS_PATH=${ANDROID_PREFIX}/bin/${CROSS_COMPILE}

# Non-exhaustive lists of compiler + binutils
# Depending on what you compile, you might need more binutils than that
export CPP=${CROSS_PATH}-cpp
export AR=${CROSS_PATH}-ar
export AS=${CROSS_PATH}-as
export NM=${CROSS_PATH}-nm
export CC=${CROSS_PATH}-gcc
export CXX=${CROSS_PATH}-g++
export LD=${CROSS_PATH}-ld
export RANLIB=${CROSS_PATH}-ranlib

# the built objects to be installed
export PREFIX=${DEV_PREFIX}/android/prefix

# Don't mix up .pc files from your host and build target
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig

export CFLAGS="${CFLAGS} --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${ANDROID_PREFIX}/include -I${DEV_PREFIX}/android/bionic -fPIE"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS} -L${SYSROOT}/usr/lib -L${ANDROID_PREFIX}/lib -fPIE -pie"

export ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull=yes

# Invoke original configure
./configure --host=${CROSS_COMPILE} --with-sysroot=${SYSROOT} --prefix=${PREFIX} "$@"
