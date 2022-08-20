# Copyright (C) 2020 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Automated
$(call inherit-product, vendor/google/pixel/pixel-vendor.mk)

# Bootanimation
include vendor/google/pixel/bootanimation/bootanimation.mk

# Fonts
include vendor/google/pixel/fonts/fonts.mk

# Gboard
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.bs_theme=true \
    ro.com.google.ime.theme_id=5 \
    ro.com.google.ime.system_lm_dir=/product/usr/share/ime/google/d3_lms

PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Gestural navbar
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

# Overlays
PRODUCT_PACKAGES += \
    PixelDocumentsUIGoogleOverlay \
    PixelDocumentsUIOverlay \
    PixelFrameworksOverlay \
    PixelLauncherFontOverlay \
    PixelSettingsOverlay \
    PixelSystemUIOverlay

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/google/pixel/overlay/static
PRODUCT_PACKAGE_OVERLAYS += vendor/google/pixel/overlay/static

# Prebuilts
PRODUCT_PACKAGES += \
    DeviceIntelligenceNetworkPrebuilt \
    DevicePersonalizationPrebuiltPixel2020 \
    TurboAdapter \
    com.google.android.apps.dialer.call_recording_audio.features \
    product_charger_res_images

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.enterprise_mode=1 \
    ro.setupwizard.esim_cid_ignore=00000001 \
    ro.setupwizard.rotation_locked=true \
    setupwizard.feature.baseline_setupwizard_enabled=true \
    setupwizard.feature.day_night_mode_enabled=true \
    setupwizard.feature.portal_notification=true \
    setupwizard.feature.show_pai_screen_in_main_flow.carrier1839=false \
    setupwizard.feature.show_pixel_tos=true \
    setupwizard.feature.show_support_link_in_deferred_setup=false \
    setupwizard.feature.skip_button_use_mobile_data.carrier1839=true

# Set default ringtone, notification and alarm
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.alarm_alert=Fresh_start.ogg \
    ro.config.notification_sound=Eureka.ogg \
    ro.config.ringtone=Your_new_adventure.ogg

# Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    vendor/google/pixel/sepolicy
