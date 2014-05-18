#!/bin/bash

if [ "${android}" = "" ]; then
	android=~/MOKEE_KK
fi

cd ${android}/packages/apps/MoKeeLauncher
# Workspace: Quad interpolator
git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Trebuchet refs/changes/36/63036/1 && git cherry-pick FETCH_HEAD

cd ${android}/external/wpa_supplicant_8
# Revert "wpa_supplicant_8 - Hostapd: Android related changes for sockets"
git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_wpa_supplicant_8 refs/changes/03/63203/1 && git cherry-pick FETCH_HEAD

cd ${android}/external/bluetooth/bluedroid
# bluedroid: increase uhid report buffer size for wiimote
git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_bluetooth_bluedroid refs/changes/89/63389/2 && git cherry-pick FETCH_HEAD

cd ${android}/frameworks/av
# audio: Add A2DP notification support
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/31/63131/2 && git cherry-pick FETCH_HEAD
# framework/av: Add Usb AoA v2.0 support
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/10/63410/1 && git cherry-pick FETCH_HEAD
# libstagefright: Convert mono to stereo for LPA clips
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/11/63411/1 && git cherry-pick FETCH_HEAD
# libstagefright: Stability issue with LPA play back.
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/12/63412/1 && git cherry-pick FETCH_HEAD
# libstagefright: LPA playback fails when non-LPA clip is next clip
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/13/63413/1 && git cherry-pick FETCH_HEAD

cd ${android}

