#!/bin/bash
#
# Copyright (C) 2021-2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEBUG=0
if [[ ${DEBUG} != 0 ]]; then
    log="/dev/tty"
else
    log="/dev/null"
fi

if [[ -z "${SRC}" ]] && [[ -z "${1}" ]]; then
    echo "Missing source"
    exit
elif [[ -z "${SRC}" ]]; then
    echo "Using '${1}' as source"
    SRC="${1}"
fi

if [[ -z "${ANDROID_ROOT}" ]] || [[ -z "${OUTDIR}" ]] && [[ -z "${2}" ]]; then
    echo "Missing outdir, assuming: './'"
    out="./"
elif [[ -z "${ANDROID_ROOT}" ]] || [[ -z "${OUTDIR}" ]]; then
    echo "Using '${2}' as outdir"
    out="${2}"
else
    out="${ANDROID_ROOT}/${OUTDIR}"
fi

if [[ -z "${MY_DIR}" ]]; then
    echo "Missing MY_DIR, assuming: './'"
    MY_DIR="./"
fi

if [[ -z $(which binwalk) ]]; then
    echo "Missing binwalk. Skip extracting GoogleExtServices"
    exit
fi

if [[ ! -f "${SRC}"/system/system/apex/com.google.android.extservices.apex ]]; then
    echo "Missing the extservices apex at: '${SRC}/system/system/apex/com.google.android.extservices.apex'"
    exit
fi

# Create a temporary working directory
TMPDIR=$(mktemp -d)

# Unpack the apex
binwalk --extract --directory="${TMPDIR}" "${SRC}"/system/system/apex/com.google.android.extservices.apex > "${log}"
binwalk --extract --directory="${TMPDIR}" "${TMPDIR}"/_com.google.android.extservices.apex.extracted/original_apex > "${log}"

# Unpack the resulting apex_payload.img
7z e "${TMPDIR}"/_com.google.android.extservices.apex.extracted/_original_apex.extracted/apex_payload.img -o"${TMPDIR}" > "${log}"
# Save the GoogleExtServices.apk
#if [[ ! -d "${out}"/proprietary/system/priv-app/GoogleExtServices ]]; then
#    mkdir -p "${out}"/proprietary/system/priv-app/GoogleExtServices
#fi
cp "${TMPDIR}"/GoogleExtServices.apk proprietary/system/priv-app/GoogleExtServices/GoogleExtServices.apk

# Clear the temporary working directory
rm -rf "${TMPDIR}"

# Pin the updated file in proprietary-files.txt
if [[ -f "${MY_DIR}/proprietary-files.txt" ]]; then
    name=$(cat "${SRC}"/product/etc/build.prop | grep ro.product.product.name | sed 's|=| |' | awk '{print $2}')
    id=$(cat "${SRC}"/product/etc/build.prop | grep ro.product.build.id | sed 's|=| |' | awk '{print $2}')
    sha1sum=$(sha1sum proprietary/system/priv-app/GoogleExtServices/GoogleExtServices.apk | awk '{print $1}')

    sed -i "s|# Google extension services.*|# Google extension services (extracted from com.google.android.extservices.apex) - from ${name} ${id}|" "${MY_DIR}/proprietary-files.txt"
    sed -i "s|-system/priv-app/GoogleExtServices/GoogleExtServices.apk.*|-system/priv-app/GoogleExtServices/GoogleExtServices.apk;OVERRIDES=ExtServices;PRESIGNED\|${sha1sum}|" "${MY_DIR}/proprietary-files.txt"
fi

echo "Updated GoogleExtServices.apk!"
