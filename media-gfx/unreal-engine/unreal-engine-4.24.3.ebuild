EAPI=7


DESCRIPTION="A 3D game engine by Epic Games which can be used non-commercially for free."
HOMEPAGE="https://www.unrealengine.com/"

RELEASE="UnrealEngine-${PV}-release"
SRC_URI="${RELEASE}.tar.gz"
MY_PN="unreal-engine"

LICENSE="UnrealEngine"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-devel/clang
	>=dev-lang/mono-5.20.1.19
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

#PATCHES=(
#	"${FILESDIR}/use-system-mono.patch"
#)

S="${WORKDIR}/${RELEASE}"

pkg_nofetch() {
	einfo "Please download ${A} from https://github.com/EpicGames"
	einfo "The archive should then be placed into your DISTDIR directory."
}

src_unpack() {
	unpack ${RELEASE}.tar.gz
}

src_prepare() {
	default

	export TERM=xterm
	./Setup.sh
	./GenerateProjectFiles.sh -makefile
}

src_compile() {

	emake CrashReportClient-Linux-Shipping
	emake CrashReportClientEditor-Linux-Shipping
	emake ShaderCompileWorker
	emake UnrealLightmass
	emake UnrealFrontend
	emake UE4Editor
	emake UnrealInsights

}
src_install() {
	dodir /opt/${PN}
	local dir=/opt/${PN}
	# Install .desktop file.
	insinto /usr/share/applications/
	doins ${FILESDIR}/${MY_PN}.desktop
	# Install icon.
	insinto /usr/share/pixmaps/ue4editor.png
	doins ${S}/Engine/Source/Programs/UnrealVS/Resources/Preview.png
	# Install license.
	insinto /usr/share/licenses/UnrealEngine
	doins LICENSE.md

	# Install engine.
	dodir ${dir}/Engine
	dodir ${dir}/Engine/DerivedDataCache
	dodir ${dir}/Engine/Intermediate
	dodir ${dir}/Engine/Source

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

	# Install content
	insinto ${dir}
	doins -r FeaturePacks
	doins -r Samples
	doins -r Templates
}



















