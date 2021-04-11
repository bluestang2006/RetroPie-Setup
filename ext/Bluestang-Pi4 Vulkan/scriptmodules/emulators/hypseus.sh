#!/usr/bin/env bash

rp_module_id="hypseus"
rp_module_desc="Hypseus - Laserdisc Emulator"
rp_module_help="ROM Extension: .daphne\n\nCopy your Daphne roms to $romdir/daphne"
rp_module_licence="GPL3 https://github.com/btolab/hypseus/blob/master/LICENSE"
rp_module_repo="git https://github.com/btolab/hypseus.git master"
rp_module_section="exp"
rp_module_flags="kms !x86 !mali"

function depends_hypseus() {
    getDepends cmake libsdl2-image-dev libsdl2-ttf-dev libvorbis-dev libogg-dev libmpeg2-4-dev
}

function sources_hypseus() {
    gitPullOrClone
    applyPatch "$md_data/hypseus.diff"
}

function build_hypseus() {
    cd "$md_build"
    cmake src/ -DCMAKE_BUILD_TYPE=Release
    make
    md_ret_require="$md_build/hypseus"
}

function install_hypseus() {
    md_ret_files=(
        'doc/hypinput.ini'
        'fonts'
        'pics'
        'sound/sound/'
        'hypseus'
    )
}

function configure_hypseus() {
    mkRomDir "daphne"
    mkRomDir "daphne/roms"

    addEmulator 1 "$md_id" "daphne" "$md_inst/hypseus.sh %ROM%"
    addSystem "daphne"

    [[ "$md_mode" == "remove" ]] && return

    mkUserDir "$md_conf_root/daphne"

    ln -snf "$romdir/daphne/roms" "$md_inst/roms"

    cat >"$md_inst/hypseus.sh" <<_EOF_
#!/bin/bash
dir="\$1"
name="\${dir##*/}"
name="\${name%.*}"

"$md_inst/hypseus" "\$name" vldp  -framefile "$romdir/daphne/\$name.daphne/\$name.txt" -homedir "$md_inst" -useoverlaysb 1  -x 1920 -y 1080
_EOF_
    chmod +x "$md_inst/hypseus.sh"

    chown -R $user:$user "$md_inst"

}