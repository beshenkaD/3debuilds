# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

DESCRIPTION="Powerful software to create films and games"
HOMEPAGE="https://www.sidefx.com/"
SRC_URI="${P}-linux_x86_64_gcc6.3.tar.gz"


LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE="unity maya systemd"

DEPEND="media-libs/fontconfig
		media-libs/glu
		dev-libs/icu
		x11-libs/libX11
		dev-libs/ocl-icd"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}"
HDIRNAME="houdini-17.5.554-linux_x86_64_gcc6.3"

pkgver_major="17"
pkgver_minor="5"
pkgver_build="554"


pkg_nofetch() {
	einfo "please download ${P}-linux_x86_64_gcc6.3.tar.gz from https://www.sidefx.com/download/download-houdini/64349/"
	einfo "and put it into your DISTDIR directory"
}

src_unpack() {
	unpack ${A}
}

install_houdini_file() {
	src="$1"
	dest="$2"
	sed -i '
	s|${HFS}|/opt/hfs17.5.554|g
	s|${VER_MAJOR}|'${pkgver_major}'|g
	s|${VER_MINOR}|'${pkgver_minor}'|g
	s|${VER_BUILD}|'${pkgver_build}'|g
	' "$src"
	doins "${src}"
}


src_install() {
# Installing base files

	dodir /opt/hfs17.5.554/python
	tar xzf ${S}/${HDIRNAME}/houdini.tar.gz -C ${D}/opt/hfs${PV}
	tar xzf ${S}/${HDIRNAME}/pythonlibdeps.tar.gz -C ${D}/opt/hfs${PV}/python
	tar xzf ${S}/${HDIRNAME}/python2.7.tar.gz -C ${D}/opt/hfs${PV}/python
# Installing .desktop files

	insinto /usr/share/applications

	for i in gplay hkey houdini houdinifx houdinicore hindie mplay hview happrentice orbolt_url
	do
		install_houdini_file ${S}/${HDIRNAME}/desktop/sesi_${i}.desktop
	done
# Installing .menu files

	insinto /etc/xdg/menus/applications-merged/

	install_houdini_file ${S}/${HDIRNAME}/desktop/sesi_houdini.menu

# Installing something.... idk what is this ^_^
	insinto usr/share/mime/packages/

	for i in hip hiplc hipnc otl otllc otlnc hda hdalc hdanc pic piclc picnc geo bgeo orbolt
	do
		_install_houdini_file ${S}/${HDIRNAME}/mime/application-x-${i}.xml
	done
# Installing license
	insinto /usr/share/licenses/${PN}/LICENSE
	doins ${FILESDIR}/LICENSE


	if use systemd ; then
		insinto /usr/lib/systemd/system/
		doins ${FILESDIR}/sesinetd.service
	fi

	doinitd ${FILESDIR}/sesinetd
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
# Useful for installing houdini engine for unreal
	cd /opt/hfs${PV}
	source houdini_setup
	echo "houdini_setup initialized"
}










