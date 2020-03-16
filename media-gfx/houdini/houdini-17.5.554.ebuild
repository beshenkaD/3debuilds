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
		install_houdini_file ${S}/${HDIRNAME}/mime/application-x-${i}.xml
	done

# Installing engines for maya and unity if needed

# Maya
	if use maya ; then
		houdini_engine_maya
	fi
# Unity
	if use unity ; then
		houdini_engine_unity
	fi
# Installing license
	insinto /usr/share/licenses/${PN}
	doins ${FILESDIR}/LICENSE

# Install systemd crap if use is enabled
	if use systemd ; then
		insinto /usr/lib/systemd/system/
		doins ${FILESDIR}/sesinetd.service
	fi
# Or OpenRC license service
	doinitd ${FILESDIR}/sesinetd
}

houdini_engine_maya() {

	dodir /opt/hfs${PV}/engine/maya
	tar xzf ${S}/${HDIRNAME}/engine_maya.tar.gz -C ${D}/opt/hfs${PV}/engine/maya

	sed -i -e 's,REPLACE_WITH_HFS,'/opt/hfs${PV}',' \
	$(find "/opt/hfs${PV}/engine/maya" -mindepth 2 -maxdepth 2 -type f -name "houdiniEngine-*")


	for maya_version in 2014 2015 2016 2016.5 2017 2018 2019 2020
	do
			# Copy module files to standard Maya module folder
			if [[ $maya_version == "2014" || $maya_version == "2015" ]]
		then
			maya_dir="/usr/autodesk/maya${maya_version}-x64"
		else
			maya_dir="/usr/autodesk/maya${maya_version}"
		fi

		module_dir="${maya_dir}/modules"
		dodir ${module_dir}	
		mv ${D}/opt/hfs${PV}/engine/maya/maya${maya_version}/houdiniEngine-maya${maya_version} ${ED}/${module_dir}
		done
	echo "now you can manually remove unused versions of houdini engine"
}

houdini_engine_unity() {

	dodir /opt/hfs${PV}/engine/unity
	tar xzf ${S}/${HDIRNAME}/engine_unity.tar.gz -C ${D}/opt/hfs${PV}/engine/unity
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
# Useful for installing houdini engine for unreal
	cd /opt/hfs${PV}
	source houdini_setup
}










