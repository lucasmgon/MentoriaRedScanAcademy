#!/bin/bash

trap "echo -e '\n\n Obrigado por usar!'; exit" SIGINT
red='\033[0;31m' #Definindo a cor do Menu de Ajuda

if [ -z "$1" ]; #Verificando se a String está vazia
then
	echo -e "${red}===========================AJUDA============================"
	echo -e "${red}\tÉ necessário passar um arquivo como argumento!"
	echo -e "${red}\tEx.: ./analysis.sh arquivo.log"
	echo ""
	echo ""
	echo -e "${red}\tAttack Analysis - Versão 1.0."
	echo -e "${red}\tDesenvolvido por Lucas M. Gonçalves."
	echo -e "${red}============================================================"
	exit 1
else
	setterm -foreground black -store
	setterm -background white -store

	menu(){ #Listar as opções do menu
		clear

		#Nome gerado com o pacote figlet
		echo "    _   _   _             _         _                _           _      "
		echo "   / \ | |_| |_ __ _  ___| | __    / \   _ __   __ _| |_   _ ___(_)___  "
		echo "  / _ \| __| __/ _. |/ __| |/ /   / _ \ | ._ \ / _. | | | | / __| / __| "
		echo " / ___ \ |_| || (_| | (__|   <   / ___ \| | | | (_| | | |_| \__ \ \__ \ "
		echo "/_/   \_\__|\__\__._|\___|_|\_\ /_/   \_\_| |_|\__,_|_|\__, |___/_|___/ "
		echo "                                                       |___/            "
		echo -e "\n\n"
		echo "============================MENU============================"
		echo " 1 - Detectar ataques de XSS"
		echo " 2 - Detectar ataques de SQL Injection"
		echo " 3 - Detectar Varredura de Diretórios"
		echo " 4 - Detectar ataques por Scanners"
		echo " 5 - Identificar acessos a arquivos sensíveis"
		echo " 6 - Detectar ataques de força bruta"
		echo " 7 - Primeiro e último acesso de um IP suspeito"
		echo " 8 - Localizar o user-agent utilizado por um IP suspeito"
		echo " 9 - Listar os IPs e verificar o número de requisições"
		echo " 10 - Localizar acesso a um determinado arquivo sensível"
		echo ""
		echo " [ctrl + c] - Sair"
		echo "============================================================="
		read -p " Escolha uma opção: " escolha
	}

	while true; do #Repete o menu

		menu #Chamando a função menu

		case "$escolha" in
			1)
				echo ""
				echo " Detectar possíveis ataques XSS (Cross-Site Scripting)"
				grep -iE "<script>|%3Cscript" "${1}"
				;;

			2)	echo ""
				echo " Detectar tentativas de SQL Injection"
				grep -iE "union|select|insert|drop|%27|%22" "${1}"
				;;

			3)
				echo ""
				echo " Detectar varredura de diretórios (Directory Traversal)"
				grep -E "\.\./|\.\.%2f" "${1}"
				;;

			4)
				echo ""
				echo " Detectar possíveis ataques por scanners (User-Agent suspeito)"
				grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python" "${1}"
				;;

			5)
				echo ""
				echo " Identificar tentativas de acesso a arquivos sensíveis (.env, .git, etc.)"
				grep -iE "\.env|\.git|\.htaccess|\.bak" "${1}"
				;;

			6)
				echo ""
				echo " Detectar possíveis ataques de força bruta a arquivos/pastas"
				grep " 404 " "${1}" | cut -d " " -f 1 | sort | uniq -c | sort -nr | head
				;;

			7)
				echo ""
				echo " Primeiro e último acesso de um IP suspeito"
				read -p " Digite o IP suspeito: " ip_suspeito
				grep "${ip_suspeito}" "${1}" | head -n1
				grep "${ip_suspeito}" "${1}" | tail -n1
				;;

			8)
				echo ""
				echo " Localizar o user-agent utilizado por um IP suspeito"
				read -p "Digite o IP suspeito: " ip_suspeito
				grep "${ip_suspeito}" "${1}" | cut -d '"' -f 6 | sort | uniq
				;;

			9)
				echo ""
				echo " Listar os IPs e verificar o número de requisições"
				cat "${1}" | cut -d " " -f 1 | sort | uniq -c
				;;

			10)
				echo ""
				echo " Localizar acesso a um determinado arquivo sensível"
				read -p " Digite o nome do arquivo sensível: " arquivo_sensivel
				grep "${arquivo_sensivel}" "${1}"
				;;

			*)
				echo "Opção inválida!"
				;;
		esac

		echo ""
		read -p "Pressione Enter para continuar..."
	done

	setterm -foreground default -store
	setterm -background default -store
fi
