#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="emulationstation-test"
rp_module_desc="EmulationStation (latest development version) - Frontend used by RetroPie for launching emulators"
rp_module_licence="MIT https://raw.githubusercontent.com/RetroPie/EmulationStation/master/LICENSE.md"
rp_module_repo="git https://github.com/bluestang2006/EmulationStation.git WIP"
rp_module_section="exp"
rp_module_flags="frontend"

function _update_hook_emulationstation-test() {
    _update_hook_emulationstation
}

function depends_emulationstation-test() {
    depends_emulationstation
    local depends=(libsdl2-mixer-dev)
    getDepends "${depends[@]}"
}

function sources_emulationstation-test() {
    gitPullOrClone
}

function build_emulationstation-test() {
    local params=(-DFREETYPE_INCLUDE_DIRS=/usr/include/freetype2/)
    if isPlatform "rpi"; then
        if ! isPlatform "aarch64"; then
            params+=(-DRPI=On)
        fi
        # Use MESA for RPi4 
        isPlatform "rpi4" && params+=(-DUSE_MESA_GLES=On)
        # force GLESv1 on videocore due to performance issue with GLESv2
        isPlatform "videocore" && params+=(-DUSE_GLES1=On)
    elif isPlatform "x11"; then
        local gl_ver=$(sudo -u $user glxinfo | grep -oP "OpenGL version string: \K(\d+)")
        [[ "$gl_ver" -gt 1 ]] && params+=(-DUSE_OPENGL_21=On)
    fi
    rpSwap on 1000
    cmake . "${params[@]}"
    make clean
    make VERBOSE=1
    rpSwap off
    md_ret_require="$md_build/emulationstation"
}

function install_emulationstation-test() {
    install_emulationstation
}

function configure_emulationstation-test() {
    rp_callModule "emulationstation" remove
    configure_emulationstation
}

function remove_emulationstation-test() {
    remove_emulationstation
}

function gui_emulationstation-test() {
    gui_emulationstation
}
