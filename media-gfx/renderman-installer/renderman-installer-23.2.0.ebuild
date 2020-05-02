# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit rpm desktop

build="2046858"
DESCRIPTION="renderman installer"
HOMEPAGE="https://renderman.pixar.com/"
SRC_URI="RenderMan-InstallerNCR-${PV}_${build}-linuxRHEL7_gcc63icc190.x86_64.rpm"

LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_nofetch() {
	einfo "please download RenderMan-InstallerNCR-${PV}_${build}-linuxRHEL7_gcc63icc190.x86_64.rpm file from:"
	einfo "https://renderman.pixar.com/install"
	einfo "and put it into your DISTDIR directory"
	einfo "P.S you need to register on pixar website to download renderman"
}

src_unpack() {
	rpm_unpack ${A}
}

S="${WORKDIR}"

src_install() {
	dodir /opt/pixar
	mv ${S}/opt/pixar/RenderMan-Installer-ncr-23.2 ${ED}/opt/pixar

	insinto /usr/share/icons/hicolor/192x192/apps/
	doins ${FILESDIR}/renderman-icon.png

	domenu ${FILESDIR}/renderman-installer.desktop
	dobin ${FILESDIR}/renderman-installer.sh
}

pkg_postinst() {
	ln -s /usr/lib64/libcrypto.so.1.0.0 /opt/pixar/RenderMan-Installer-ncr-23.2/lib/3rdparty/Qt-5.6.1/lib/libcrypto.so
	ln -s /usr/lib64/libssl.so.1.0.0 /opt/pixar/RenderMan-Installer-ncr-23.2/lib/3rdparty/Qt-5.6.1/lib/libssl.so
}

pkg_postrm() {
	rm -r /opt/pixar
}
