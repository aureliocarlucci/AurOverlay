# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_8 )

DESCRIPTION="Command line utlities for programming PCsensor and Scythe foot switches. Developed by Radoslav Gerganov"
HOMEPAGE="https://github.com/rgerganov/footswitch"
# SRC_URI=""7

inherit git-r3
#distutils-r1

#EGIT_REPO_URI="https://github.com/rgerganov/footswitch.git"
EGIT_REPO_URI="https://github.com/aureliocarlucci/footswitch.git"

PATCHES=(
	"${FILESDIR}/${P}-Makefile-dir.patch"
)

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/hidapi"
RDEPEND="${DEPEND}"
BDEPEND=""
