#!/usr/bin/env bash

rp_module_id="rbdoom3bfg"
rp_module_desc="RBDoom 3 BFG Edition"
rp_module_help="Copy game files to ~/RetroPie/roms/ports/rbdoom3bfg/base folder"
rp_module_licence="GPL3 https://github.com/RobertBeckebans/RBDOOM-3-BFG/blob/master/LICENSE.md"
rp_module_repo="git https://github.com/RobertBeckebans/RBDOOM-3-BFG.git master"
rp_module_section="exp"
rp_module_flags="!all vk"

function depends_rbdoom3bfg() {
    getDepends cmake libopenal-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev
}

function sources_rbdoom3bfg() {
    gitPullOrClone
    applyPatch "$md_data/rbdoom3bfg.diff"
}

function build_rbdoom3bfg() {
    cd neo
    sh cmake-rpi4-linux-vulkan-release.sh
    cd ../build
    make clean
    make
    md_ret_require="$md_build/build/RBDoom3BFG"
}

function install_rbdoom3bfg() {
    md_ret_files=(
        'build/RBDoom3BFG'
    )
}

function configure_rbdoom3bfg() {
    mkRomDir "ports/rbdoom3bfg"
    mkRomDir "ports/rbdoom3bfg/base"
    addPort "$md_id" "rbdoom3bfg" "RBDoom 3 BFG" "$md_inst/RBDoom3BFG"
    
    ln -sfv "$md_inst" "$home/.local/share"
    moveConfigDir "$md_inst/base" "$romdir/ports/rbdoom3bfg/base"
    
    chown -R $user:$user "$md_inst"
    chown -R $user:$user "$romdir/ports/rbdoom3bfg"
    chown -R $user:$user "$romdir/ports/rbdoom3bfg/base"
    
    [[ "$md_mode" == "remove" ]] && return

    cat >"$romdir/ports/rbdoom3bfg/base/autoexec.cfg" <<_EOF_
seta sys_lang "english"
seta preLoad_Images "0"
seta r_vkStagingMaxCommands "1000"
_EOF_

    chown -R $user:$user "$romdir/ports/rbdoom3bfg/base/autoexec.cfg"
}
