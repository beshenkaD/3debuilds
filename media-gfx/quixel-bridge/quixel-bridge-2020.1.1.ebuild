# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN="quixel-bridge"

DESCRIPTION="Quixel bridge"
HOMEPAGE="https://quixel.com/bridge"
SRC_URI="https://d2shgxa8i058x8.cloudfront.net/bridge/linux/Bridge.AppImage"

LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-fs/fuse
		net-print/cups"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	dobin ${DISTDIR}/Bridge.AppImage
	insinto /usr/share/applications
	insopts -m775
	doins ${FILESDIR}/${MY_PN}.desktop
	insinto /usr/share/icons/hicolor/256x256/apps/
	doins ${FILESDIR}/${MY_PN}-icon.png
}
