# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2


EAPI=7
MY_PN="Autodesk_Maya"
DESCRIPTION="high end 3d software from autodesk"
HOMEPAGE="https://www.autodesk.com/products/maya/overview"
SRC_URI="${MY_PN}_${PV}_ML_Linux_64bit.tgz"


LICENSE="custom"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

inherit rpm desktop xdg-utils

DEPEND="x11-libs/libGLw
		media-libs/glu
		>=dev-cpp/tbb-2019.8
		app-admin/gamin
		media-libs/audiofile
		sys-fs/e2fsprogs
		media-libs/libjpeg-turbo
		media-libs/libpng-compat
		media-libs/tiff
		x11-libs/libxp
		dev-libs/openssl-compat
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
	for i in ${S}/maya-setup/Packages/*.rpm
	do
		einfo "unpacking ${i}"
		rpm_unpack ${i}
	done

	for i in /opt /usr /var
	do
		einfo "installing ${i}"
		mv ${S}/${i} ${D}/
	done

	dobin ${D}/opt/Autodesk/AdskLicensing/9.2.1.2399/AdskLicensingService/AdskLicensingService
	doinitd ${FILESDIR}/adsklicensing.el7



	domenu ${FILESDIR}/maya.desktop
}

pkg_postinst() {
	einfo "making symlinks"
	ln -s /usr/lib64/libssl.so.1.0.0 /usr/autodesk/maya2020/lib/libssl.so.10
	ln -s /usr/lib64/libcrypto.so.1.0.0 /usr/autodesk/maya2020/lib/libcrypto.so.10
	ln -s /usr/lib64/libjpeg.so.62 /usr/autodesk/maya2020/lib/libjpeg.so.62
	ln -s /usr/lib64/libtiff.so.5.5.0 /usr/autodesk/maya2020/lib/libtiff.so.3
	ln -s /usr/lib64/libXp.so.6 /usr/autodesk/maya2020/lib/libXp.so.6
	ln -s /usr/lib64/libtbb.so /usr/lib/libtbb_preview.so.2
	einfo "registring maya"
	/opt/Autodesk/AdskLicensing/9.2.1.2399/helper/AdskLicensingInstHelper register -pk 657L1 -pv 2020.0.0.F -el EN_US -cf /var/opt/Autodesk/Adlm/maya2020/MayaConfig.pit

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	einfo "please manually delete the unusable dirs such as:"
	einfo "/usr/autodesk"
}
