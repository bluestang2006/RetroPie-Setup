#!/usr/bin/env bash

rp_module_id="vkquake3"
rp_module_desc="vkQuake 3"
rp_module_help="Copy .pak files to ~/RetroPie/roms/ports/quake3/baseq3 folder"
rp_module_licence="GPL2 https://raw.githubusercontent.com/raspberrypi/quake3/master/COPYING.txt"
rp_module_repo="git https://github.com/suijingfeng/vkQuake3.git master"
rp_module_section="exp"
rp_module_flags="!all vk"

function get_arch_vkquake3() {
    echo "$(uname -m)"
}

function depends_vkquake3() {
    getDepends libcurl4-openssl-dev libopenal-dev
}

function sources_vkquake3() {
    gitPullOrClone
    applyPatch "$md_data/vkQ3.diff"
}

function build_vkquake3() {
    make clean
    make "USE_LOCAL_HEADERS=0"
    md_ret_require="$md_build/build/release-linux-$(get_arch_vkquake3)/ioquake3.$(get_arch_vkquake3)"
}

function install_vkquake3() {
    md_ret_files=(
        "build/release-linux-$(get_arch_vkquake3)/ioq3ded.$(get_arch_vkquake3)"
        "build/release-linux-$(get_arch_vkquake3)/ioquake3.$(get_arch_vkquake3)"
        "build/release-linux-$(get_arch_vkquake3)/renderer_opengl1_$(get_arch_vkquake3).so"
        "build/release-linux-$(get_arch_vkquake3)/renderer_opengl2_$(get_arch_vkquake3).so"
        "build/release-linux-$(get_arch_vkquake3)/renderer_vulkan_$(get_arch_vkquake3).so"
        "build/release-linux-$(get_arch_vkquake3)/missionpack/cgame$(get_arch_vkquake3).so"
        "build/release-linux-$(get_arch_vkquake3)/missionpack/qagame$(get_arch_vkquake3).so"
        "build/release-linux-$(get_arch_vkquake3)/missionpack/ui$(get_arch_vkquake3).so"
    )
}

function game_data_vkquake3() {
    if [[ ! -f "$romdir/ports/quake3/pak0.pk3" ]]; then
        downloadAndExtract "$__archive_url/Q3DemoPaks.zip" "$romdir/ports/quake3" -j
    fi
    # always chown as moveConfigDir in the configure_ script would move the root owned demo files
    chown -R $user:$user "$romdir/ports/quake3"
    chown -R $user:$user "$md_inst"
}

function configure_vkquake3() {
    mkRomDir "ports/quake3"
    addPort "$md_id" "vkquake3" "vkQuake 3: Arena" "$md_inst/ioquake3.$(get_arch_vkquake3) +set cl_renderer vulkan"

    [[ "$md_mode" == "remove" ]] && return

    game_data_vkquake3

    moveConfigDir "$md_inst/baseq3" "$romdir/ports/quake3"
}
