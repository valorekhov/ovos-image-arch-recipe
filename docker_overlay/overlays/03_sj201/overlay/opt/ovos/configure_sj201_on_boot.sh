#!/bin/bash
# NEON AI (TM) SOFTWARE, Software Development Kit & Application Framework
# All trademark and other rights reserved by their respective owners
# Copyright 2008-2022 Neongecko.com Inc.
# Contributors: Daniel McKnight, Guy Daniels, Elon Gasper, Richard Leeds,
# Regina Bloomstine, Casimiro Ferreira, Andrii Pernatii, Kirill Hrymailo
# BSD-3 License
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE,  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This needs to run as root

# Enable Driver Overlay
# dtoverlay xvf3510

# Flash xmos firmware
xvf3510-flash --direct /usr/lib/firmware/xvf3510/app_xvf3510_int_spi_boot_v4_1_0.bin
# Init TI Amp
sj201 init-ti-amp
# Reset LEDs
sj201 reset-led red

revision=$(sj201 get-revision)
echo "Current SJ201 Revision: $revision"
# Reset fan speed
if [ "${revision}" != "10" ]; then
    sj201 set-fan-speed 30
fi
## In Rev10, `sj201 set-fan-speed` is replaced with Kernel control of the fan using PWM-Fan device-tree overlay. 
if [ "${revision}" == "10" ]; then
    ## Registering the R10 overlay in boot config if not present.
    ## However, it will only be loaded on the next reboot
    grep -qF 'dtoverlay=sj201-rev10-pwm-fan' /boot/config.txt || echo -e "\ndtoverlay=sj201-rev10-pwm-fan" >> /boot/config.txt
fi
