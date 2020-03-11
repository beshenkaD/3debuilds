# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="free game engine from epic games"
HOMEPAGE="www.epicgames.com"
SRC_URI="${RELEASE}.tar.gz"

RELEASE="UnrealEngine-${PV}-release"

LICENSE="UnrealEngine"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-devel/clang
		>=dev-lang/mono-6.4.0.198
		app-text/dos2unix
		dev-util/cmake
		dev-vcs/git"
RDEPEND="${DEPEND}
		dev-libs/icu
		media-libs/libsdl2
		dev-lang/python
		sys-devel/lld
		x11-misc/xdg-user-dirs
		x11-terms/xterm"
PATCHES=("${FILESDIR}/use-system-mono.patch")



pkg_nofetch() {
	einfo "Please download ${A} from https://github.com/EpicGames/UnrealEngine/releases"
	einfo "The archive should then be placed into your DISTDIR directory"
}

src_unpack() {
	unpack ${RELEASE}.tar.gz
}

src_prepare() {

	default
	export TERM=xterm

	echo "running setup"
	./Setup.sh
	echo "generating project files"
	./GenerateProjectFiles.sh -makefile
}

src_compile() {
	cd ${P}

	emake CrashReportClient-Linux-Shipping
	emake CrashReportClientEditor-Linux-Shipping
	emake ShaderCompileWorker
	emake UnrealLightmass
	emake UnrealFrontend
	emake UE4Editor
	emake UnrealInsights

}

src_install() {
	local dir =/opt/${PN}
	insinto /usr/share/applications/
	doins ${FILESDIR}/UE4Editor.desktop
#	insinto /usr/share/licenses/UnrealEngine
#	doins LICENSE.md
	insinto /usr/share/pixmaps
	doins UE4Editor.png
	dodir ${dir}/Engine
	dodir ${dir}/Engine/DerivedDataCache # editor needs this
	dodir ${dir}/Engine/Intermediate # editor needs this, but not the contents
	dodir ${dir}/Engine/Source # the source cannot be redistributed, but seems to be needed to compile c++ projects
	insinto ${dir}/Engine
	doins -r Engine/Binaries
	doins -r Engine/Build
	doins -r Engine/Config
	doins -r Engine/Content
	doins -r Engine/Documentation
	doins -r Engine/Extras
	doins -r Engine/Plugins
	doins -r Engine/Programs
	doins -r Engine/Saved
	doins -r Engine/Shaders
	insinto ${dir}

	doins -r FeaturePacks
	doins -r Samples
	doins -r Templates

	doins GenerateProjectFiles.sh Setup.sh
	doins .ue4dependencies
}


