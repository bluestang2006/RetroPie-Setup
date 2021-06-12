#!/usr/bin/env bash

rp_module_id="vkquake2"
rp_module_desc="vkQuake 2"
rp_module_help="This requires yquake2 to be installed first, ref_vk.so is copied to existing folder"
rp_module_licence="GPL2 https://github.com/yquake2/ref_vk/blob/master/LICENSE"
rp_module_repo="git https://github.com/yquake2/ref_vk.git master"
rp_module_section="exp"
rp_module_flags="!all vk"

function depends_vkquake2() {
    getDepends libvulkan-dev
}

function sources_vkquake2() {
    gitPullOrClone
    applyPatch "$md_data/vkQ2.diff"
}

function build_vkquake2() {
    cmake .
    make clean
    make
    md_ret_require="$md_build/release/ref_vk.so"
}

function install_vkquake2() {
    md_ret_files=(
        'release/ref_vk.so'
    )
}

function configure_vkquake2() {
    addPort "$md_id" "vkquake2" "vkQuake 2" "$md_inst/quake2 +set vid_renderer vk +set r_mode -1 +set r_customwidth %XRES% +set r_customheight %YRES%"
    
        [[ "$md_mode" == "remove" ]] && return

    chown -R $user:$user "$romdir/ports/quake2"
    chown -R $user:$user "$md_inst"

    moveConfigDir "$md_inst/baseq2" "$romdir/ports/quake2"
}
