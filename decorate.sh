#!/bin/bash
#
# NAME
#
#   decorate.sh
#
# DESC
#   Contains utility functions for the 'docker-make-chris_dev.sh' script.
#

   ESC(){ echo -en "\033";}                             # escape character
 CLEAR(){ echo -en "\033c";}                            # the same as 'tput clear'
 CIVIS(){ echo -en "\033[?25l";}                        # the same as 'tput civis'
 CNORM(){ echo -en "\033[?12l\033[?25h";}               # the same as 'tput cnorm'
  TPUT(){ echo -en "\033[${1};${2}H";}                  # the same as 'tput cup'
COLPUT(){ echo -en "\033[${1}G";}                       # put text in the same line as the specified column
  MARK(){ echo -en "\033[7m";}                          # the same as 'tput smso'
UNMARK(){ echo -en "\033[27m";}                         # the same as 'tput rmso'
  DRAW(){ echo -en "\033%@";echo -en "\033(0";}         # switch to 'garbage' mode
#  DRAW(){ echo -en "\033%";echo -en "\033(0";}          # switch to 'garbage' mode
 WRITE(){ echo -en "\033(B";}                           # return to normal mode from 'garbage' on the screen
  BLUE(){ echo -en "\033c\033[0;1m\033[37;44m\033[J";}  # reset screen, set background to blue and font to white

# Set
bold='\033[1m'
dim='\033[2m'
underline='\033[4m'
blink='\033[5m'
reverse='\033[7m'
hidden='\033[8m'

# Foreground
RED='\033[0;31m'
NC='\033[m' # No Color
Black='\033[0;30m'
DarkGray='\033[1;30m'
Red='\033[0;31m'
LightRed='\033[1;31m'
Green='\033[0;32m'
LightGreen='\033[1;32m'
Brown='\033[0;33m'
Yellow='\033[1;33m'
Blue='\033[0;34m'
LightBlue='\033[1;34m'
Purple='\033[0;35m'
LightPurple='\033[1;35m'
Cyan='\033[0;36m'
LightCyan='\033[1;36m'
LightGray='\033[0;37m'
White='\033[1;37m'

# Background
NC='\033[m' # No Color
BlackBG='\033[0;40m'
DarkGrayBG='\033[1;40m'
RedBG='\033[0;41m'
LightRedBG='\033[1;41m'
GreenBG='\033[0;42m'
LightGreenBG='\033[1;42m'
BrownBG='\033[0;43m'
YellowBG='\033[1;43m'
BlueBG='\033[0;44m'
LightBlueBG='\033[1;44m'
PurpleBG='\033[0;45m'
LightPurpleBG='\033[1;45m'
CyanBG='\033[0;46m'
LightCyanBG='\033[1;46m'
LightGrayBG='\033[0;47m'
WhiteBG='\033[1;47m'

function boxcenter {
    color=$2
    flag=$3
    termwidth=80
    padding="$(printf '%0.1s' ' '{1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))"  \
              "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))"  \
              "$padding"                                      | ./boxes.sh "$3" $color
}

function center {
    if (( ${#2} )) ; then
        termwidth=$2
    else
        termwidth=80
    fi
    padding="$(printf '%0.1s' ' '{1..500})"
    if (( ${#1} < termwidth-2 )) ; then
        printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))"  \
                "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))"  \
                "$padding"
    else
        printf "$1"
    fi
}

function colorSpec_parse {
    #
    # Accept an input color spec, for example:
    #
    #       blink;Yellow
    #
    # and return the appropriate ESC sequence.
    #
    # Note that in testing it seems as though not all
    # attributes (blink, underline, etc) work on all
    # colors.
    #

    colorSpec=$1
    IFS=';' read -ra a_color <<< $colorSpec
    if (( ${#a_color[@]} > 1 )) ; then
        colorSet=${a_color[0]}
        colorVal=${a_color[1]}
    else
        colorSet=NC
        colorVal=${a_color[0]}
    fi
    escColor=\$${colorSet}\$${colorVal}
    echo $escColor
}

function tcprint {
    # Print two (colorized) arguments with left/right box
    # decorations and optional column width specifiers
    #
    #        leftColor   leftMsg     rightColor    rightMsg     leftColW rightColW
    # tcprint Yellow  "left Message" LightGreen "right Message"   "20"     "60"
    #
    # column width specifiers left/right as optional 3rd and 4th args

    colorLeft="$1"
    leftMsg="$2"
    colorRight="$3"
    rightMsg="$4"
    declare -i  leftCol="$5"
    declare -i rightCol="$6"

    eval  leftColor=$(colorSpec_parse $colorLeft)
    eval rightColor=$(colorSpec_parse $colorRight)

    printf "${NC}%q%*s${NC}%q%*s${NC}\n"                           \
            "$leftColor"  "$leftCol"  "$leftMsg"    \
            "$rightColor" "$rightCol" "$rightMsg"   | ./boxes.sh

}

function title {
    declare -i b_date=0
    local OPTIND
    while getopts "d:" opt; do
        case $opt in
            d) b_date=$OPTARG ;;
        esac
    done
    shift $(($OPTIND - 1))

    STEP=$(expr $STEP + 1 )
    MSG="$1"
    MSG2="$2"
    TITLE=$(echo " $STEP: $MSG ")
    LEN=$(echo "$TITLE" | awk -F\| {'printf("%s", length($1));'})
    if ! (( LEN % 2 )) ; then
        TITLE="$TITLE "
    fi
    MSG=$(echo -e "$TITLE" | awk -F\|\
             {'printf("%*s%*s\n", 40+length($1)/2, $1, 41-length($1)/2, "");'})
    if (( ${#MSG2} )) ; then
        TITLE2=$(echo " $MSG2 ")
        LEN2=$(echo "$TITLE2" | awk -F\| {'printf("%s", length($1));'})
        if ! (( LEN2 % 2 )) ; then
            TITLE2="$TITLE2 "
        fi
        MSG2=$(echo -e "$TITLE2" | awk -F\|\
             {'printf("%*s%*s\n", 40+length($1)/2, $1, 41-length($1)/2, "");'})
    fi
    printf "\n"
    DATE=" $(date -R) [$(hostname)] "
    lDATE=${#DATE}
    if (( b_date )) ; then
        printf "${NC}${White}"
        printf "${White}┌" ;  for c in $(seq 1 $lDATE); do printf "─" ; done ;
        printf "┐\n│"
        printf "${NC}${LightBlue}"
        printf "%-30s" "$DATE"
        printf "${White}│${NC}\n"
        printf "${Yellow}├" ; for c in $(seq 1 $lDATE); do printf "─";  done ; printf "┴"
        REM=$(expr 79 - $lDATE)
        for c in $(seq 1 $REM); do printf "─" ; done ; printf "┐\n"
    else
        printf "${Yellow}┌"
        for c in $(seq 1 80); do printf "─" ; done
        printf "┐\n"
    fi
    printf "│"
    printf "${LightPurple}$MSG${Yellow}"
    if (( ${#MSG2} )) ; then
        printf "│${Brown}▒\n${Yellow}│"
        printf "${LightPurple}$MSG2${Yellow}"
    fi
    printf "│${Brown}▒\n"
    printf "${Yellow}├" ;  for c in $(seq 1 80); do printf "─" ; done ; printf "┤${Brown}▒\n"
    printf "${NC}"
}

function windowTop {
    if ((  ! ${#1} )) ; then
        printf "${Yellow}┌─" ;  for c in $(seq 1 79); do printf "─" ; done ; printf "┐${Brown}\n"
        printf "${NC}"
    else
        printf "┌─" ;  for c in $(seq 1 79); do printf "─" ; done ; printf "┐\n"
        printf "${NC}"
    fi
}

function windowLine {
    if ((  ! ${#1} )) ; then
        printf "${Yellow}├─" ;  for c in $(seq 1 79); do printf "─" ; done ; printf "┤${Brown}▒\n"
        printf "${NC}"
    else
        printf "├─" ;  for c in $(seq 1 79); do printf "─" ; done ; printf "┤▒\n"
        printf "${NC}"
    fi
}

function windowBottom {
    if ((  ! ${#1} )) ; then
        printf "${Yellow}└─" ;  for c in $(seq 1 79); do printf "─" ; done ; printf "┘${Brown}▒\n"
        printf "${Brown} ▒" ; for c in $(seq 1 81); do printf "▒" ; done ; printf "\n"
        printf "${NC}"
    else
        printf "└─" ;  for c in $(seq 1 79); do printf "─" ; done ; printf "┘▒\n"
        printf " ▒" ; for c in $(seq 1 81); do printf "▒" ; done ; printf "\n"
        printf "${NC}"
    fi
}

