# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2


EAPI=7
MY_PN="Autodesk_Maya"
DESCRIPTION="high end 3d software from autodesk"
HOMEPAGE="https://www.autodesk.com/products/maya/overview"
SRC_URI="https://trial2.autodesk.com/NetSWDLD/2019/MAYA/EC2C6A7B-1F1B-4522-0054-4FF79B4B73B5/ESD/Autodesk_Maya_2019_Linux_64bit.tgz"


LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
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

#src_nofetch() {
#	einfo "please download ${MY_PN}_${PV}_ML_Linux_64bit.tgz from:"
#	einfo "https://www.autodesk.com/education/free-software/maya# or:"
#	einfo "https://www.autodesk.com/products/maya/free-trial-dts if you wouldn't use education license"
#	einfo "then put it into your DISTDIR directory"
#}

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
		einfo "unpacking ${i}"
		rpm_unpack ${i}
	done

	for i in /opt /usr /var
	do
		einfo "installing ${i}"
		mv ${S}/${i} ${D}/
	done

# Adlmflexnet
	chmod 777 ${D}/var/opt/Autodesk/Adlm/
	chmod 777 ${D}/usr/local/share/macrovision/storage/FLEXnet/
	touch ${D}var/flexlm/maya.lic



	domenu ${FILESDIR}/maya.desktop
}

pkg_postinst() {
	einfo "making symlinks"
	ln -s /usr/lib64/libssl.so.1.0.0 /usr/lib64/libssl.so.10
	ln -s /usr/lib64/libcrypto.so.1.0.0 /usr/autodesk/maya2019/lib/libcrypto.so.10
	ln -s /usr/lib64/libjpeg.so.62 /usr/autodesk/maya2019/lib/libjpeg.so.62
	ln -s /usr/lib64/libtiff.so.5.5.0 /usr/autodesk/maya2019/lib/libtiff.so.3
	ln -s /usr/lib64/libXp.so.6 /usr/autodesk/maya2019/lib/libXp.so.6
	ln -s /usr/lib64/libtbb.so /usr/lib64/libtbb_preview.so.2
	ln -s /opt/Autodesk/Adlm/R14/lib64/libadlmPIT.so /usr/lib64/libadlmPIT.so
	ln -s /opt/Autodesk/Adlm/R14/lib64/libadlmutil.so /usr/lib64/libadlmutil.so

	xdg_desktop_database_update
	xdg_icon_cache_update

	einfo "To register your maya run: /usr/autodesk/maya2019/bin/adlmreg -i N 657K1 657K1 2019.0.0.F 123-12345678 /var/opt/Autodesk/Adlm/Maya2019/MayaConfig.pit as root."
	einfo "but instead of 123-12345678 put your key"
	einfo "if you have standalone license change N to S."
}

pkg_postrm() {
#	einfo "please manually delete the unusable dirs such as:"
#	einfo "/usr/autodesk"
	rm -r /usr/autodesk
	rm /usr/lib64/libadlmPIT.so
	rm /usr/lib64/libadlmutil.so
	rm /usr/lib64/libtbb_preview.so.2
	rm /usr/lib64/libssl.so.10
	rm -r /var/opt/Autodesk
	einfo "symlinks deleted"
}











