# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm eutils


DESCRIPTION="3d painting software for pbr texturing"
HOMEPAGE="https://www.substance3d.com/"
SRC_URI="https://download.substance3d.com/substance-painter/6.x/Substance_Painter-6.1.1-256-linux-x64-standard.rpm"

LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
MY_PN="substance-painter"


DEPEND="!=media-gfx/substance-painter-2019.3.3
		media-libs/fontconfig
        sys-devel/gcc
        media-libs/glu
        x11-themes/hicolor-icon-theme
        media-libs/tiff"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
        rpm_unpack ${A}
}

##################
S="${WORKDIR}"
##################

src_install() {

        dodir /opt/Allegorithmic
        mv ${S}/opt/Allegorithmic/Substance_Painter ${ED}/opt/Allegorithmic

#Make icon
        insinto /usr/share/icons/hicolor/256x256/apps/
        doins ${FILESDIR}/${MY_PN}-icon.png
#Make .desktop
        insinto /usr/share/applications/
        doins ${FILESDIR}/${MY_PN}.desktop
#Install executable script
        dobin ${FILESDIR}/${MY_PN}
}

