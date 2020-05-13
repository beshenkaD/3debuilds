# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="High-resolution digital 3D painting and texturing."
HOMEPAGE="https://www.foundry.com/products/mari"
SRC_URI="Mari4.6v1-linux-x86-release-64.run"

LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="media-libs/glu
		net-dns/libidn
		=media-gfx/flt-7.1.1"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

pkg_nofetch(){
	einfo "please download .run file from:"
	einfo "https://www.foundry.com/products/mari/try-mari"
	einfo "and put it into your DISTDIR directory."
	einfo "if you are want to install 4.6v1/v2 so it is possible. Just rename your .run file to Mari4.6v3-etc..."
}

src_unpack(){
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die "cp failed"
}

src_prepare(){
	default
	chmod +x ${A} || die "chmod failed"
	yes | ./${A} || die "unpack failed"
}

src_install() {
	dodir /opt/foundry
	mv ${S}/Mari4.6v1 ${ED}/opt/foundry
	domenu ${FILESDIR}/mari.desktop
}

pkg_postinst(){
	ln -s /usr/lib64/libidn.so.12 /usr/lib64/libidn.so.11
}

pkg_postrm(){
	rm -rf /opt/foundry/Mari*
}
