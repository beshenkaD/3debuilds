 # Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

Ver="v1"

DESCRIPTION="The Foundry Licensing Tools "
HOMEPAGE="https://www.foundry.com/"
SRC_URI="https://s3.amazonaws.com/thefoundry/tools/FLT/7.1${Ver}/FLT7.1${Ver}-linux-x86-release-64.tgz"

LICENSE="custom"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="net-dns/libidn"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_unpack(){
	unpack ${A}
}

src_install() {
	TOOL_DIR=/usr/local/foundry/LicensingTools7.1
	FnRLMLicDir=/usr/local/foundry/RLM
	FnFLEXLicDir=/usr/local/foundry/FLEXlm

	dirname="FLT_7.1v1_linux-x86-release-64RH"
	mv ${S}/${dirname}/* ${S}

	RLM_LIC_DIR=${FnRLMLicDir}
	FLEX_LIC_DIR=${FnFLEXLicDir}
	BIN_DIR=${TOOL_DIR}/bin
	RLM_BIN_DIR=${TOOL_DIR}/bin/RLM
	FLEX_BIN_DIR=${TOOL_DIR}/bin/FLEXlm
	DOC_DIR=${TOOL_DIR}/docs
	RLM_LOG_DIR=${FnRLMLicDir}/log
	FLEX_LOG_DIR=${FnFLEXLicDir}/log

	for i in rlm.foundry rlmutil foundry.set
	do
		insinto ${RLM_BIN_DIR}
		doins ${i}
	done

	for i in lmgrd.foundry lmutil foundry
	do
		insinto ${FLEX_BIN_DIR}
		doins ${i}
	done

	for i in FoundryLicenseUtility
	do
		insinto ${TOOL_DIR}
		doins ${i}
	done

	for i in foundry.log
	do
		insinto ${RLM_LOG_DIR}
		doins ${i}

		dodir ${FLEX_LOG_DIR}
		cp ${S}/foundry.log ${FLEX_LOG_DIR}
	done

	for i in foundryrlmserver foundryflexlmserver
	do
		doinitd ${i}
	done

	dodir ${DOC_DIR}
	mv ${S}/docs/* ${DOC_DIR}

	dodir ${RLM_LIC_DIR}
	dodir ${FLEX_LIC_DIR}
}

pkg_postinst(){
	for i in "${RLM_BIN_DIR}" "${FLEX_BIN_DIR}" "${TOOL_DIR}"
	do
		chmod 755 ${i}
	done

	for i in "${RLM_LOG_DIR}" "${FLEX_LOG_DIR}" "${DOC_DIR}"
	do
		chmod -R 666 ${i}
	done

	for i in "${RLM_LIC_DIR}" "${FLEX_LIC_DIR}"
	do
		chmod -R 777 ${i}
	done

	ln -s /usr/lib64/libidn.so.12 /usr/lib64/libidn.so.11
}
