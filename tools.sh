#!/bin/bash
# Default variables
function="install"

# Options
. <(wget -qO- https://raw.githubusercontent.com/Secord0/utils/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script performs many actions related to a Zeitgeist node"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help    show the help page"
		echo -e "  -u,  --update  update the node"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/letsnode/Zeitgeist/tools.sh — script URL"
		echo -e "https://t.me/letskynode — node Community"
		echo -e "https://teletype.in/@letskynode — guides and articles"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-u|--update)
		function="update"
		shift
		;;
	*|--)
		break
		;;
	esac
done

# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
install() {
	printf_n "${C_R}I don't want.${RES}"
}
update() {
	printf_n "${C_LGn}Checking for update...${RES}"
	status=`docker pull mantanetwork/calamari:latest`
	if ! grep -q "Image is up to date for" <<< "$status"; then
		printf_n "${C_LGn}Updating...${RES}"
		docker stop calamari_node
		docker rm calamari_node
		docker run -dit --network host -v $HOME/.calamari:/data --name calamari_node mantanetwork/calamari:latest   --base-path /data   --keystore-path /keystore   --name "$calamari_moniker"   --rpc-cors all   --collator   --prometheus-external   --   --prometheus-external   --telemetry-url "wss://api.telemetry.manta.systems/submit/ 0"
	else
		printf_n "${C_LGn}Node version is current!${RES}"
	fi
}

# Actions
sudo apt install wget -y &>/dev/null
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
cd
$function
