#!/usr/bin/env bash

rp_module_id="vkquake"
rp_module_desc="vkQuake"
rp_module_help="Copy .pak files to ~/RetroPie/roms/ports/quake/id1 folder"
rp_module_licence="GPL2 https://github.com/Novum/vkQuake/blob/master/LICENSE.txt"
rp_module_repo="git https://github.com/Novum/vkQuake.git master"
rp_module_section="exp"
rp_module_flags="!all vk"

function depends_vkquake() {
    getDepends libsdl2-dev libvulkan-dev libvorbis-dev libmad0-dev libx11-xcb-dev
}

function sources_vkquake() {
    gitPullOrClone
}

function build_vkquake() {
    cd Quake
    make clean
    make "USE_SDL2=1"
    md_ret_require="$md_build/Quake/vkquake"
}

function install_vkquake() {
    md_ret_files=("Quake/vkquake")
}

function configure_vkquake() {
    mkRomDir "ports/quake"
    addPort "$md_id" "vkquake" "vkQuake" "$md_inst/vkquake -basedir $md_inst -fitz -width %XRES% -height %YRES%"
    
    chown -R $user:$user "$romdir/ports/quake"
    chown -R $user:$user "$md_inst"

    [[ "$md_mode" == "remove" ]] && return

    moveConfigDir "$md_inst/id1" "$romdir/ports/quake"
}
