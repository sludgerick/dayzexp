#!/bin/bash
set -x
# use package steamcmd.sh
# STEAMCMDDIR="/usr/lib/games/steam"
STEAMCMDDIR="/root/.steam/steamcmd"
mkdir -p "${STEAMAPPDIR}" || true
printf "%s\n" ${STEAMUSERNAME}
printf "%s\n" ${STEAMPASSWORD}
printf "%s\n" ${PORT}
printf "%s\n" ${PROFILEDIR}

# bash "${STEAMCMDDIR}/steamcmd.sh" +runscript "${STEAMAPP}"_update.txt
# bash "${STEAMCMDDIR}/steamcmd.sh" +help +quit

"${STEAMCMDDIR}/steamcmd.sh" +@sSteamCmdForcePlatformType Linux \
 		+login "${STEAMUSERNAME}" \
  		+force_install_dir "${STEAMAPPDIR}" \
  		+app_update "${STEAMAPPID}" validate \
  		+quit

## this is an example on how to deal with config files
# # We assume that if the config is missing, that this is a fresh container
# if [ ! -f "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" ]; then
# 	# Download & extract the config
# 	wget -qO- "${DLURL}/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
#
# 	# Are we in a metamod container?
# 	if [ ! -z "$METAMOD_VERSION" ]; then
# 		LATESTMM=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux)
# 		wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATESTMM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
# 	fi
# fi

# config installation
cp ${PROFILEDIR}/serverDZ.cfg ${STEAMAPPDIR}/serverDZ.cfg
chown ${USER}: ${STEAMAPPDIR}/serverDZ.cfg

# server daemon start
cd "${STEAMAPPDIR}"

bash -c "./DayZServer -config=serverDZ.cfg \
                     -port=2302 \
                     -profile="${PROFILEDIR}" \
                     -dologs \
                     -adminlog \
                     -netlog \
                     -freezecheck"

