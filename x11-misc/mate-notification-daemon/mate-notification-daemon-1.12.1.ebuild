# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GNOME2_LA_PUNT="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE Notification daemon"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk3"

RDEPEND="
	dev-libs/atk:0
	>=dev-libs/dbus-glib-0.78:0
	>=dev-libs/glib-2.36:2
	>=sys-apps/dbus-1:0
	x11-libs/cairo:0
	>=x11-libs/gdk-pixbuf-2.22:2
	!gtk3? ( >=x11-libs/gtk+-2.24:2
			>=media-libs/libcanberra-0.4:0[gtk]
			>=x11-libs/libwnck-1:1 )
	gtk3? ( >=x11-libs/gtk+-3.0:3
			>=media-libs/libcanberra-0.4:0[gtk3]
			>=x11-libs/libwnck-3:3 )
	>=x11-libs/libnotify-0.7:0
	x11-libs/libX11:0
	virtual/libintl:0
	!x11-misc/notify-osd:*
	!x11-misc/qtnotifydaemon:*
	!x11-misc/notification-daemon:*"

DEPEND="${RDEPEND}
	app-arch/xz-utils:0
	>=dev-util/intltool-0.40:*
	sys-devel/gettext:*
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig:*"

DOCS=( AUTHORS ChangeLog NEWS )

src_configure() {
	local use_gtk3
	use gtk3 && use_gtk3="${use_gtk3} --with-gtk=3.0"
	use !gtk3 && use_gtk3="${use_gtk3} --with-gtk=2.0"
	gnome2_src_configure ${use_gtk3}
}

src_install() {
	gnome2_src_install

	cat <<-EOF > "${T}/org.freedesktop.Notifications.service"
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/mate-notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}/org.freedesktop.Notifications.service"
}
