FROM ich777/novnc-baseimage

LABEL maintainer="admin@minenet.at"

RUN export TZ=Europe/Rome && \
	apt-get update && \
	apt-get -y install fontconfig libc-ares2 libcrypto++6 libcurl3-gnutls libdouble-conversion1 libegl-mesa0 libegl1 libevdev2 libgbm1 libgomp1 libgraphite2-3 libgssapi-krb5-2 libgudev-1.0-0 libharfbuzz0b libicu63 libinput-bin libinput10 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libldap-common libmediainfo0v5 libmms0 libmtdev1 libnghttp2-14 libpcre2-16-0 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libraw19 librtmp1 libsasl2-2 libsasl2-modules-db libssh2-1 libtinyxml2-6a libwacom-common libwacom2 libwayland-client0 libwayland-server0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-render0 libxcb-shape0 libxcb-util0 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxkbcommon-x11-0 libxkbcommon0 libzen0v5 trayer libqt5x11extras5 && \
	wget -q -nc --show-progress --progress=bar:force:noscroll -O MegaSync.deb https://mega.nz/linux/MEGAsync/Debian_10.0/amd64/megasync-Debian_10.0_amd64.deb && \
	dpkg -i MegaSync.deb && \
	apt-get -y --no-install-recommends -f install && \
	rm MegaSync.deb && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "Mega.nz - noVNC";' /usr/share/novnc/app/ui.js && \
	rm /usr/share/novnc/app/images/icons/*

ENV DATA_DIR="/megasync"
ENV CUSTOM_RES_W=750
ENV CUSTOM_RES_H=550
ENV NOVNC_PORT=8080
ENV RFB_PORT=5900
ENV X11VNC_PARAMS=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="megasync"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]