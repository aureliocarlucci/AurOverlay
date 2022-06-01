# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_8 )

inherit autotools elisp-common flag-o-matic git-r3 python-single-r1 toolchain-funcs

# The packages below are not provided by other Gentoo ebuilds
COHOMCALG="cohomCalg-0.32"
FACTORY="factory-4.2.1"
FACTORY_GFTABLES="factory.4.0.1-gftables"
GTEST="gtest-1.10.0"
MPSOLVE="mpsolve-3.2.1"

DESCRIPTION="Research tool for commutative algebra and algebraic geometry"
HOMEPAGE="https://faculty.math.illinois.edu/Macaulay2"
BASE_URI="https://faculty.math.illinois.edu/Macaulay2/Downloads/OtherSourceCode/"

SRC_URI="
	${BASE_URI}/${COHOMCALG}.tar.gz
	${BASE_URI}/${FACTORY_GFTABLES}.tar.gz
	${BASE_URI}/${FACTORY}.tar.gz
	${BASE_URI}/${GTEST}.tar.gz
	${BASE_URI}/${MPSOLVE}.tar.gz"

EGIT_REPO_URI="https://github.com/Macaulay2/M2.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="debug emacs +optimization"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	app-arch/unzip
	app-text/dos2unix
	dev-lang/yasm
	dev-libs/boehm-gc[cxx]
	dev-libs/boost
	sys-devel/gcc
	sys-process/time
	virtual/pkgconfig"
# Unzip and dos2unix just for normaliz


#Dependencies taken from the official guide
# https://github.com/Macaulay2/M2/blob/master/M2/INSTALL


RDEPEND="${PYTHON_DEPS}
	dev-cpp/gtest
	dev-cpp/tbb
	dev-libs/gmp
	dev-libs/libatomic_ops
	dev-libs/libxml2
	dev-libs/mpc
	dev-libs/mpfr
	dev-libs/ntl
	dev-util/ctags
	sci-libs/cdd+
	sci-libs/cddlib
	sci-libs/coinor-csdp
	sci-libs/fplll
	sci-libs/lrslib[gmp]
	sci-libs/mpir[cxx]
	sci-mathematics/4ti2
	sci-mathematics/flint
	sci-mathematics/frobby
	sci-mathematics/gfan
	sci-mathematics/glpk
	sci-mathematics/nauty
	sci-mathematics/normaliz
	sci-mathematics/pari[gmp]
	sci-mathematics/singular
	sci-mathematics/topcom
	sys-libs/gdbm
	sys-libs/ncurses
	sys-libs/readline
	virtual/blas
	virtual/lapack
	emacs? ( app-editors/emacs )"

#SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/${PN}-${PV}/M2"

RESTRICT="mirror"

src_unpack (){
	git-r3_src_unpack
}

pkg_setup () {
	tc-export CC CPP CXX PKG_CONFIG
	append-cppflags "-I/usr/include/frobby"
	# gtest needs python:2
	python-single-r1_pkg_setup
}

src_prepare() {

	eapply_user

	# Factory is a statically linked library which (in this flavor) are not used by any
	# other program. We build it internally and don't install it.

	cp "${DISTDIR}/${FACTORY}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/${FACTORY_GFTABLES}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"

	# Macaulay2 developers want that gtest is built internally because
	# the documentation says it may fail if build with options not the
	# same as the tested program.
	cp "${DISTDIR}/${GTEST}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"


	cp "${DISTDIR}/${MPSOLVE}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"


	cp "${DISTDIR}/${COHOMCALG}.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"

	eautoreconf
}

src_configure (){

	# configure instead of econf to enable install with --prefix
	./configure LIBS="$($(tc-getPKG_CONFIG) --libs lapack)" \
				--prefix="${D}/usr" \
				--disable-encap \
				--disable-strip \
				--with-issue=Gentoo \
				$(use_enable optimization optimize) \
				$(use_enable debug) \
				--enable-build-libraries="factory" \
				--with-unbuilt-programs="4ti2 gfan normaliz nauty cddplus lrslib" \
				|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build not supported yet
	# emake -j1

	# For trunk builds we may wish to ignore example errors
	emake IgnoreExampleErrors=true -j1

	if use emacs; then
		cd "${S}/Macaulay2/editors/emacs" || die
		elisp-compile *.el
	fi
}

src_test() {
	# No parallel tests yet & Need to increase the time
	# limit for long running tests in Schubert2 to pass
	emake TLIMIT=550 -j1 check
}

src_install () {
	# Parallel install not supported yet
	# NumericalAlgebraicGeometry fails (during install too?)
	emake IgnoreExampleErrors=true -j1 install


	# It seems the default location for elisp files is fine.
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "If you want to set a hot key for Macaulay2 in Emacs add a line similar to"
		elog "(global-set-key [ f12 ] 'M2)"
		elog "in order to set it to F12 (or choose a different one)."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	}
