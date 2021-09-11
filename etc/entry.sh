#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true

bash "${STEAMCMDDIR}/steamcmd.sh" +@sSteamCmdForcePlatformType Linux \
        +login "${STEAMUSERNAME} ${STEAMPASSWORD}" \
		+force_install_dir "${STEAMAPPDIR}" \
		+app_update "${STEAMAPPID}" \
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

# server daemon start
cd "${STEAMAPPDIR}"

bash "${STEAMAPPDIR}/DayZServer" -config=serverDZ.cfg \
                                  -port="${PORT}" \
                                  -profile="${PROFILEDIR}" \
                                  -dologs \
                                  -adminlog \
                                  -netlog \
                                  -freezecheck
