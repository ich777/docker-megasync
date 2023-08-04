FROM ich777/novnc-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-megasync"

ARG MEGASYNC_CLIENT_VERSION="4.9.5-1.1"
ARG DEBIAN_V="12"

RUN export TZ=Europe/Rome && \
	apt-get update && \
	apt-get -y install gpg fontconfig libc-ares2 libcrypto++ libcurl3-gnutls libdouble-conversion3 libegl-mesa0 libegl1 libevdev2 libgbm1 libgomp1 libgraphite2-3 libgssapi-krb5-2 libgudev-1.0-0 libharfbuzz0b libicu72 libinput-bin libinput10 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 libldap-common libmediainfo0v5 libmms0 libmtdev1 libnghttp2-14 libpcre2-16-0 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libraw20 librtmp1 libsasl2-2 libsasl2-modules-db libssh2-1 libtinyxml2-9 libwacom-common libwacom9 libwayland-client0 libwayland-server0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-render0 libxcb-shape0 libxcb-util1 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxkbcommon-x11-0 libxkbcommon0 libzen0v5 libqt5x11extras5 libssl3 && \
	wget -q -nc --show-progress --progress=bar:force:noscroll -O MegaSync.deb https://mega.nz/linux/repo/Debian_${DEBIAN_V}/amd64/megasync_${MEGASYNC_CLIENT_VERSION}_amd64.deb && \
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
ENV CUSTOM_DEPTH=16
ENV NOVNC_PORT=8080
ENV RFB_PORT=5900
ENV TURBOVNC_PARAMS="-securitytypes none"
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
COPY /icons/* /usr/share/novnc/app/images/icons/
COPY /conf/ /etc/.fluxbox/
RUN chmod -R 770 /opt/scripts/

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]