#!/bin/bash
set -x
# use package steamcmd.sh
# STEAMCMDDIR="/usr/lib/games/steam"
STEAMCMDDIR="/root/.steam/steamcmd"
mkdir -p "${STEAMAPPDIR}" || true
# printf "%s\n" ${STEAMUSERNAME}
# printf "%s\n" ${STEAMPASSWORD}
# printf "%s\n" ${PORT}
# printf "%s\n" ${PROFILEDIR}

# bash "${STEAMCMDDIR}/steamcmd.sh" +runscript "${STEAMAPP}"_update.txt
# bash "${STEAMCMDDIR}/steamcmd.sh" +help +quit

"${STEAMCMDDIR}/steamcmd.sh" +@sSteamCmdForcePlatformType Linux \
 		+login "${STEAMUSERNAME}" \
  		+force_install_dir "${STEAMAPPDIR}" \
  		+app_update "${STEAMAPPID}" validate \
  		+quit

# this is an example on how to deal with config files
# We assume that if the config is missing, that this is a fresh container

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

#cp ${PROFILEDIR}/serverDZ.cfg ${STEAMAPPDIR}/serverDZ.cfg
if [[ -f ${PROFILEDIR}/serverDZ.cfg ]]; then
	install -o ${USER} -g ${USER} -m 755 ${PROFILEDIR}/serverDZ.cfg ${STEAMAPPDIR}/serverDZ.cfg
fi

# WARNING: with the next line you add a dependency between `entry.sh` and `serverDZ.cfg`
# pending on the configured mission
if [[ -f ${PROFILEDIR}/messages.xml ]]; then
	install -o ${USER} -g ${USER} -m 755 -p ${PROFILEDIR}/messages.xml ${STEAMAPPDIR}/mpmissions/dayzOffline.chernarusplus/db/messages.xml
fi

# # Install {ban,priority,whitelist}.txt files for production server
# # install ban.txt from profile dir
# if [[ -f ${PROFILEDIR}/ban.txt ]]; then
# 	install -o ${USER} -g ${USER} -m 644 -p ${PROFILEDIR}/ban.txt ${STEAMAPPDIR}/ban.txt
# fi
#
# # install priority.txt from profile dir
# if [[ -f ${PROFILEDIR}/priority.txt ]]; then
# 	install -o ${USER} -g ${USER} -m 644 -p ${PROFILEDIR}/priority.txt ${STEAMAPPDIR}/priority.txt
# fi
#
# # install whitelist.txt from profile dir
# if [[ -f ${PROFILEDIR}/whitelist.txt ]]; then
# 	install -o ${USER} -g ${USER} -m 644 -p ${PROFILEDIR}/whitelist.txt ${STEAMAPPDIR}/whitelist.txt
# fi

# server daemon start
cd "${STEAMAPPDIR}"

bash -c "./DayZServer -config=serverDZ.cfg \
                     -port=2302 \
                     -profile="${PROFILEDIR}" \
                     -dologs \
                     -adminlog \
                     -netlog \
                     -freezecheck"

