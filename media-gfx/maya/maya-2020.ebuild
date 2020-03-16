# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2


EAPI=7
MY_PN="Autodesk_Maya"
DESCRIPTION="high end 3d software from autodesk"
HOMEPAGE="https://www.autodesk.com/products/maya/overview"
SRC_URI="${MY_PN}_${PV}_ML_Linux_64bit.tgz"


LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

inherit rpm desktop xdg-utils

DEPEND="x11-libs/libGLw
		media-libs/glu
		app-admin/gamin
		media-libs/audiofile
		sys-fs/e2fsprogs
		media-libs/libjpeg-turbo
		media-libs/libpng-compat
		media-libs/tiff
		dev-libs/openssl
		app-shells/tcsh
		media-fonts/font-adobe-100dpi
		media-fonts/font-adobe-75dpi
		media-fonts/font-misc-misc"
RDEPEND="${DEPEND}"
BDEPEND=""

src_nofetch() {
	einfo "please download ${MY_PN}_${PV}_ML_Linux_64bit.tgz from:"
	einfo "https://www.autodesk.com/education/free-software/maya# or:"
	einfo "https://www.autodesk.com/products/maya/free-trial-dts if you wouldn't use education license"
	einfo "then put it into your DISTDIR directory"
}

src_unpack() {
	unpack ${A}
}
S="${WORKDIR}"
src_prepare() {
	default
	rm -Rf ${S}/Setup
	mkdir -p ${S}/maya-setup
	mv ${S}/* ${S}/maya-setup
}

src_install() {
	for i in ${S}/maya-setup/*.rpm
	do  
		echo "moving ${i}"
		mv ${i} $
	done

	ln -s /usr/lib/libssl.so.1.0.0 "$pkgdir"/usr/autodesk/maya2017/lib/libssl.so.10
	ln -s /usr/lib/libcrypto.so.1.0.0 "$pkgdir"/usr/autodesk/maya2017/lib/libcrypto.so.10
	ln -s /usr/lib/libjpeg.so.62 "$pkgdir"/usr/autodesk/maya2017/lib/libjpeg.so.62
	ln -s /usr/lib/libtiff.so "$pkgdir"/usr/autodesk/maya2017/lib/libtiff.so.3
}


