#!/usr/bin/env bash

rp_module_id="duckstation"
rp_module_desc="PlayStation emulator - Duckstation"
rp_module_help="ROM Extensions: .exe .cue .bin .chd .psf .m3u\n\nCopy your PlayStation roms to $romdir/psx\n\nCopy the required BIOS files\n\nscph5500.bin and\nscph5501.bin and\nscph5502.bin to\n\n$biosdir"
rp_module_licence="GPL3 https://raw.githubusercontent.com/stenzek/duckstation/master/LICENSE"
rp_module_repo="git https://github.com/stenzek/duckstation.git master"
rp_module_section="exp"

function depends_duckstation() {
    local depends=(cmake libsdl2-dev pkg-config libevdev-dev git ninja-build libgbm-dev libdrm-dev extra-cmake-modules)
    if isPlatform "wayld"; then
    	depends+=(libwayland-dev wayland-protocols)
    fi
    getDepends "${depends[@]}"
}

function sources_duckstation() {
    gitPullOrClone
}

function build_duckstation() {
    local params=(-DCMAKE_BUILD_TYPE=Release -DBUILD_NOGUI_FRONTEND=ON -DBUILD_QT_FRONTEND=OFF -DUSE_DRMKMS=ON)
    if isPlatform "wayld"; then
    	params+=(-DUSE_WAYLAND=ON)
    fi
    cmake "${params[@]}" -GNinja .
    ninja -j"$(nproc)"
    md_ret_require=(
        "$md_build/bin/duckstation-nogui"
    )
}

function install_duckstation() {
    md_ret_files=(
        'bin/database'
        'bin/inputprofiles'
        'bin/resources'
        'bin/shaders'
        'bin/common-tests'
        'bin/duckstation-nogui'
    )
}

function configure_duckstation() {
    mkRomDir "psx"
    mkRomDir "psx/saves"
    ensureSystemretroconfig "psx"

    addEmulator 0 "$md_id" "psx" "$md_inst/duckstation-nogui -- %ROM%"
    addEmulator 0 "$md_id-setup" "psx" "$md_inst/duckstation-nogui"
    addSystem "psx"

    [[ "$md_mode" == "remove" ]] && return

    ln -sfv "$md_inst" "$home/.local/share"

    moveConfigDir "$md_inst/bios" "$biosdir"
    moveConfigDir "$md_inst/memcards" "$romdir/psx/saves"

    cat >"$md_inst/portable.txt" <<_EOF_

_EOF_

    chown -R $user:$user "$md_inst"
}