#!/bin/bash

## adkill
## version 2.4
## by penthium for Viperr
## Fork
## inspired by this script http://vsido.org/index.php?topic=757.0
############################################################ 
############################################################

############################################################
# Method for animation while script is working:
# to call it, use : spinner & ; pidspin=$(jobs -p) ; disown
f_spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1 ; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}
# Method to kill the animation :
f_killspinner() {
	kill $pidspin 
	printf "\n"
}

f_download() {
	
	echo -e "$1 \e[34m"
	
	f_spinner &
	pidspin=$(jobs -p)
	disown
	
	wget -nv -O - "$2" >> "$temphosts1"
	if [[ $? = 0 ]] ; then
		echo -e "\e[32mDownload completed \e[0m"
	else
		echo -e "\e[31mDownload Error \e[0m"
	fi
	
	f_killspinner
}

f_show_help() {
	echo "run adkill.sh <option>"
	echo "run adkill.sh <option>"
	echo "--ats : activate blacklist of ad/tracking servers listed in the hpHosts database."
	echo "--emd : activate blacklist of malware sites listed in the hpHosts database."
	echo "--exp : activate blacklist of exploit sites listed in the hpHosts database."
	echo "--fsa : activate blacklist of fraud sites listed in the hpHosts database."
	echo "--grm : activate blacklist of sites involved in spam (that do not otherwise meet any other classification criteria) listed in the hpHosts database."
	echo "--hfs : activate blacklist of sites spamming the hpHosts forums (and not meeting any other classification criteria) listed in the hpHosts database."
	echo "--hjk : activate blacklist of hijack sites listed in the hpHosts database."
	echo "--mmt : activate blacklist of sites involved in misleading marketing (e.g. fake Flash update adverts) listed in the hpHosts database."
	echo "--pha : activate blacklist of illegal pharmacy sites listed in the hpHosts database."
	echo "--psh : activate blacklist of phishing sites listed in the hpHosts database."
	echo "--wrz : activate blacklist of warez/piracy sites listed in the hpHosts database."
	echo "--all : activate blacklist of all sites listed in the hpHosts database."
	echo "--restore : restore the default /etc/hosts."
	echo "--apply : apply the Adkill filter in /etc/hosts."
	exit 1

}

f_load_config_file () {
	if [[ ! -f "$config_file" ]] ; then
		f_make_config_file
	fi
	cat "$config_file" | while read line ; do
		if [[ $(echo "$line" | grep "^\[") ]] ; then
			section=$(echo "$line" | sed 's/^\[//g;s/\]$//g')
		elif [[ $(echo "$line" | grep "^msg=") ]] ; then
			msg=$(echo "$line" | sed 's/^msg=//g')
		elif [[ $(echo "$line" | grep "^url=") ]] ; then
			url=$(echo "$line" | sed 's/^url=//g')
		elif [[ $(echo "$line" | grep "^enabled=") ]] ; then
			enabled=$(echo "$line" | sed 's/^enabled=//g')
		fi
					
		if [[ -n "$section" && -n "$enabled" && -n "$url" && -n "$msg" ]] ; then
			if [[ "$ats" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$emd" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$exp" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$fsa" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$grm" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$hfs" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$hjk" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$mnt" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$pha" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$psh" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$wrz" = 1 ]] ; then
				"$enabled"=1
			fi
			if [[ "$all" = 1 ]] ; then
				"$enabled"=1
			fi

			if [[ "$enabled" = 1 ]] ; then
			 f_download "$msg" "$url"
			fi
			unset section
			unset url
			unset msg
			unset enabled
		fi
	done	
}

f_make_config_file() {
	cat << EOF > "$config_file"
[winhelp2002.mvps.org]
msg=Downloading from : winhelp2002.mvps.org : 
url=http://winhelp2002.mvps.org/hosts.txt
enabled=1

[someonewhocares.org]
msg=Downloading from someonewhocares.org :
url=http://someonewhocares.org/hosts/hosts
enabled=1

[pgl.yoyo.org]
msg=Downloading from pgl.yoyo.org :"
url=http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
enabled=1

[sourceforge.net/project/adzhosts]
msg=Downloading from downloads.sourceforge.net/project/adzhosts :
url=http://downloads.sourceforge.net/project/adzhosts/FORADAWAY.txt
enabled=1

[ats]
msg=Downloading from hosts-file.net : ad/tracking servers
url=http://hosts-file.net/ad_servers.txt
enabled=0

[emd]
msg=Downloading from hosts-file.net : malware sites
url=http://hosts-file.net/emd.txt
enabled=0

[exp]
msg=Downloading from hosts-file.net : exploit sites
url=http://hosts-file.net/exp.txt
enabled=0

[fsa]
msg=Downloading from hosts-file.net : fraud sites
url=http://hosts-file.net/fsa.txt
enabled=0

[grm]
msg=Downloading from hosts-file.net : sites involved in spam
url=http://hosts-file.net/grm.txt
enabled=0

[hfs]
msg=Downloading from hosts-file.net : sites spamming the hpHosts forums
url=http://hosts-file.net/hfs.txt
enabled=0

[hjk]
msg=Downloading from hosts-file.net : hijack sites
url=http://hosts-file.net/hjk.txt
enabled=0

[mmt]
msg=Downloading from hosts-file.net : sites involved in misleading marketing
url=http://hosts-file.net/mmt.txt
enabled=0

[pha] 
msg=Downloading from hosts-file.net : illegal pharmacy sites
url=http://hosts-file.net/pha.txt
enabled=0

[psh] 
msg=Downloading from hosts-file.net : phishing sites
url=http://hosts-file.net/psh.txt
enabled=0

[wrz] 
msg=Downloading from hosts-file.net : warez/piracy
url=http://hosts-file.net/wrz.txt
enabled=0
EOF
}

############################################################
#
#set variable to default setting for diferrents categories :

directory_config="$HOME/.config/adkill"
config_file="${directory_config}/config"
hosts_system="${directory_config}/hosts-system"
hosts_block="${directory_config}/hosts-block"

section=""
msg=""
url=""
enabled=""


ats=0
emd=0
exp=0
fsa=0
grm=0
hfs=0
hjk=0
mmt=0
pha=0
psh=0
wrz=0

if [[ ! -d "$directory_config" ]] ; then
	mkdir -p "$directory_config"
	if [[ ! -f "$config_file" ]] ; then
		f_make_config_file
	fi
fi

# If this is our first run, saves a copy of the system's original hosts file and sets it to read-only for safety
if [[ ! -f "$hosts_system" ]] ; then
	echo "Saving copy of system's original hosts file..."
	cp /etc/hosts "$hosts_system"
	chmod 444 "$hosts_system"
fi

	while [[ -n "$1" ]] ; do
		case $1 in 
			--ats)
				ats=1
				;;
			--emd)
				emd=1
				;;
			--exp)
				exp=1
				;;
			--fsa)
				fsa=1
				;;
			--grm)
				grm=1
				;;
			--hfs)
				hfs=1
				;;
			--hjk)
				hjk=1
				;;
			--mmt)
				mmt=1
				;;
			--pha)
				pha=1
				;;
			--psh)
				psh=1
				;;
			--wrz)
				wrz=1
				;;
			--all)
				ats=1
				emd=1
				exp=1
				fsa=1
				grm=1
				hfs=1
				hjk=1
				mmt=1
				pha=1
				psh=1
				wrz=1
				;;
			--restore)
				restore=1
				;;
			--apply)
				apply=1
				;;
			--help)
				f_show_help
				;;
			*)
				echo "syntax error"
				f_show_help
			;;
		esac
		shift
	done

###########################################################

# Perform work in temporary files
temphosts1=$(mktemp)
temphosts2=$(mktemp)

f_load_config_file

#read -p "STOP HERE"
# Do some work on the file:
printf "Parsing, cleaning, de-duplicating, sorting..."
#sed -e 's/\r//' -e '/localhost/d' -e 's/127.0.0.1/0.0.0.0/' -e 's/#.*$//' -e 's/[ \s]*$//' -e '/^$/d' -e 's/\s/ /g' -e '/^[^0]/d' "$temphosts1" | sort -u > "$temphosts2"
#sed -e 's/\r//;/localhost/d;s/127.0.0.1/0.0.0.0/;s/#.*$//;s/[ \s]*$//;/^$/d;s/\s/ /g;/^[^0]/d' "$temphosts1" | sort -u > "$temphosts2"
f_spinner &
pidspin=$(jobs -p)
disown

sed  -e "
{:remove_DOS_carriage;\
s/\r//};\
{:delete_localhost_lines;\
/localhost/d};\
{:delete_commented_line;\
s/#.*$//};\
{:delete_space_at_the_end_of_line;\
s/[ \s\t]*$//};\
{:delete_empty-line;\
/^$/d};\
{:replace_muti_space_by_only_one;\
s/[[:blank:]]\+/ /g};\
{:replace_127.0.0.1_by_0.0.0.;\
s/127\.0\.0\.1/0.0.0.0/};\
s/[ \s\t]$//;\
{:delete_line_who_not_start_by_zero;\
/^[^0]/d}" "$temphosts1" | sort -u > "$temphosts2"
f_killspinner 

## work : 
printf "Merging with original system hosts..."
f_spinner &
pidspin=$(jobs -p)
disown
# setting up progress status :
####

## work : 
head=$(mktemp)
unban=$(mktemp)

## extract head
#generation de l'entete :
sed -n '0,/# Ad blocking hosts generated/p' /etc/hosts | sed '$d' > $head
#generation du fichier des hosts commentés:
sed -n '/#\(0\.\)\{3\}0/p' /etc/hosts > $unban
#working :

while read line ;  do
      sed  -i "/${line#\#}/d" $temphosts2
done < <(cat $unban)
f_killspinner

echo -e "# Ad blocking hosts generated: $(date +%d-%m-%Y)" | cat $head $unban - "$temphosts2" > "$hosts_block"
# Clean up temp files and remind user to copy new file
echo "Cleaning up..."
rm "$temphosts1" "$temphosts2" "$head" "$unban"
echo "Done."

#test if it's root user who launch the script :

if [[ root = "$USER" ]] ; then
	if [[ -z "$apply" || "$apply"=1 ]] ; then  
		cp -f "$hosts_block" /etc/hosts 
	fi
	if [[ "$restore"=1 ]] ; then  
		cp -f "$hosts_system" /etc/hosts 
	fi
else
	echo
	echo "Copy ad-blocking hosts file with this command:"
	echo "cd ; su -c 'cp ""$hosts_block"" /etc/hosts'"
	echo
	echo "You can always restore your original hosts file with this command:"
	echo "cd ; su -c 'cp ""$hosts_system"" /etc/hosts'"
	echo "so don't delete that file! (It's saved read-only for your protection.)"
fi

