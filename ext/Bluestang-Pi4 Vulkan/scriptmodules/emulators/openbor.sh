#!/usr/bin/env bash

rp_module_id="openbor-dev"
rp_module_desc="OpenBOR - Beat 'em Up Game Engine"
rp_module_help="Place your .pak files in $romdir/openbor."
rp_module_licence="BSD https://raw.githubusercontent.com/DCurrent/openbor/master/LICENSE"
rp_module_repo="git https://github.com/DCurrent/openbor.git master"
rp_module_section="exp"
rp_module_flags="!mali !x11"

function depends_openbor-dev() {
    getDepends libsdl2-gfx-dev libvorbisidec-dev libvpx-dev libogg-dev libsdl2-gfx-1.0-0 libvorbisidec1 libvorbis-dev
}

function sources_openbor-dev() {
    gitPullOrClone 
	applyPatch "$md_data/openbor_rpi4.diff"
}

function build_openbor-dev() {
	cd "$md_build/engine"
    local params=()
    isPlatform "aarch64" && isPlatform "rpi4" && params+=(BUILD_LINUX_arm=1)
    make clean-all BUILD_LINUX_arm=1
    make "${params[@]}"
    md_ret_require="$md_build/engine/OpenBOR"
}

function install_openbor-dev() {
    md_ret_files=(
       'engine/OpenBOR'
       'engine/OpenBOR.elf'
    )
}

function configure_openbor-dev() {
    mkRomDir "ports/$md_id"

    local dir
    for dir in ScreenShots Saves; do
        mkUserDir "$md_conf_root/$md_id/$dir"
        ln -snf "$md_conf_root/$md_id/$dir" "$md_inst/$dir"
    done

    ln -snf "$romdir/$md_id" "$md_inst/Paks"
    ln -snf "/dev/shm" "$md_inst/Logs"
    addEmulator 0 "$md_id" "openbor" "$md_inst/OpenBOR %ROM%"
    addSystem "openbor"
}
