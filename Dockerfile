###########################################################
# Dockerfile that builds a DayZ Experimental Server
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="sludgerick@ycore.net"

ENV STEAMAPPID 1042420
ENV STEAMAPP dayzserver
ENV STEAMUSERNAME "${STEAMUSERNAME}"
ENV STEAMPASSWORD "${STEAMPASSWORD}"
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-exp"
ENV DLURL https://raw.githubusercontent.com/sludgerick/dayzexp

# Create autoupdate config
# Add entry script & ESL config
# Remove packages and tidy up
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget \
		ca-certificates \
		lib32z1=1:1.2.11.dfsg-1 \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& wget --max-redirect=30 "${DLURL}/main/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'login ${STEAMUSERNAME} ${STEAMPASSWORD}'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& rm -rf /var/lib/apt/lists/*

# ENV SRCDS_FPSMAX=300 \
# 	SRCDS_TICKRATE=128 \
# 	SRCDS_PORT=27015 \
# 	SRCDS_TV_PORT=27020 \
# 	SRCDS_CLIENT_PORT=27005 \
# 	SRCDS_NET_PUBLIC_ADDRESS="0" \
# 	SRCDS_IP="0" \
# 	SRCDS_MAXPLAYERS=14 \
# 	SRCDS_TOKEN=0 \
# 	SRCDS_RCONPW="changeme" \
# 	SRCDS_PW="changeme" \
# 	SRCDS_STARTMAP="de_dust2" \
# 	SRCDS_REGION=3 \
# 	SRCDS_MAPGROUP="mg_active" \
# 	SRCDS_GAMETYPE=0 \
# 	SRCDS_GAMEMODE=1 \
# 	SRCDS_HOSTNAME="New \"${STEAMAPP}\" Server" \
# 	SRCDS_WORKSHOP_START_MAP=0 \
# 	SRCDS_HOST_WORKSHOP_COLLECTION=0 \
# 	SRCDS_WORKSHOP_AUTHKEY="" \
# 	ADDITIONAL_ARGS=""

ENV PORT=2302 \
  PROFILEDIR="profile"

USER ${USER}

VOLUME ${STEAMAPPDIR}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 2302:2302/udp \
	2303:2303/udp \
	2304:2304/udp \
    36533:36533/tcp

