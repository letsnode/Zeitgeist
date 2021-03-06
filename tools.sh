#!/bin/bash
# Default variables
function="install"

# Options
. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/logo.sh)
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
		echo -e "https://raw.githubusercontent.com/letsnode/Zeitgeist/main/tools.sh — script URL"
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
	status=`docker pull zeitgeistpm/zeitgeist-node-parachain:latest`
	if ! grep -q "Image is up to date for" <<< "$status"; then
		printf_n "${C_LGn}Updating...${RES}"
		docker stop zeitgeist_node
		docker rm zeitgeist_node
		docker run -dit --name zeitgeist_node --restart always --network host -v $HOME/.zeitgeist:/zeitgeist/data -u $(id -u ${USER}):$(id -g ${USER}) \
			  zeitgeistpm/zeitgeist-node-parachain \
			  -d /zeitgeist/data \
			  --name "$zeitgeist_moniker" \
			  --validator \
			  --pruning archive \
			  --state-cache-size 1 \
			  --db-cache `bc <<< "$(cat /proc/meminfo | awk 'NR == 1 {print $2}')/2024"` \
			  --in-peers 100 \
			  --out-peers 100 \
			  -- \
			  --pruning 1000 \
			  --name "$zeitgeist_moniker (Embedded Relay)"
	else
		printf_n "${C_LGn}Node version is current!${RES}"
	fi
}

# Actions
sudo apt install wget -y &>/dev/null
. /root/.bash_profile
. <(wget -qO- https://raw.githubusercontent.com/letsnode/Utils/main/bashbuilder/logo.sh)
cd
$function
