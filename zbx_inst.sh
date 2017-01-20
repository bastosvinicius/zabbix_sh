#!/usr/bin/sh
# Desc.: Script para instalacao em massa de pacotes do Zabbix Agent
# Autor: Vinicius Bastos
# Versao 0.2
# Exec.: inst_zbx.sh

# DEFININDO VARIAVEIS

ZBXHOME="/binarios/AUTOMACAO/ZABBIX"
DEFAULT="$ZBXHOME/DEFAULT"
ZBXAIX53="$ZBXHOME/PCKS/2.2/ZBX2.2_AIX5300"
ZBXAIX6e7="$ZBXHOME/PCKS/2.2/ZBX2.2_AIX6100"
ZBXLNX64="$ZBXHOME/PCKS/3.0/ZBX_LNX_2_6.amd64"
ZBXLNX32="$ZBXHOME/PCKS/3.0/ZBX_LNX_2_6.i386"
ZBXSOL="$ZBXHOME/PCKS/3.0/ZBX_SOL"

# INICIA SCRIPT

# MENU

menu () {

echo "*********************************************************************"
echo "*                     ESCOLHA A OPCAO DESEJADA                      *"
echo "*********************************************************************"
echo
echo "1) Instalar Zabbix Agent em servidor local"
echo "2) Instalar Zabbix Agent em servidor remoto"
echo "3) Sair"
echo
read -r opcao
case "$opcao" in

1)

$ZBXHOME/scripts/zbx_inst_local.sh

;;

2)

ZBX_AIX53 () {
	sed "s/^Hostname=.*/Hostname=$host/g" "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.default >> "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf
	if [ $? -eq "0" ]
		then
		echo "Parametro Hostname= do arquivo zabbix_agentd.conf ajustado no servidor $host com sucesso"
		else
		echo "Falha ao ajustar parametro Hostname= do arquivo zabbix_agentd.conf no servidor $host"
	fi

	scp -rp "$ZBXAIX53"/zabbix_sender "$ZBXAIX53"/zabbix_get "$ZBXAIX53"/zabbix_agentd "$ZBXHOME"/LIBS/libiconv.a "$DEFAULT"/AIX/zabbix "$DEFAULT"/AIX/zabbix_agentd.pid "$DEFAULT"/AIX/zabbix_agentd.log "$DEFAULT"/AIX/rc.zabbix "$user"@"$host":/tmp
	
	if [ $? -eq "0" ]
		then
		echo "Arquivos zabbix_sender, zabbix_get, zabbix_agentd, libiconv.a, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix copiados com sucesso para o diretorio /tmp no servidor $host"
		else
		echo "Falha ao copiar arquivos zabbix_sender, zabbix_get, zabbix_agentd, libiconv.a, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix para o diretorio /tmp no servidor $host"
	fi

	rm -rf "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf

	ssh -t "$user@$host" 'ksh -s' < "$ZBXHOME"/scripts/zabbix_inst_aix.sh
}

ZBX_AIX6e7 () {
	sed "s/^Hostname=.*/Hostname=$host/g" "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.default >> "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf
	if [ $? -eq "0" ]
		then
		echo "Parametro Hostname= do arquivo zabbix_agentd.conf ajustado no servidor $host com sucesso"
		else
		echo "Falha ao ajustar parametro Hostname= do arquivo zabbix_agentd.conf no servidor $host"
	fi

	scp -rp "$ZBXAIX6e7"/zabbix_sender "$ZBXAIX6e7"/zabbix_get "$ZBXAIX6e7"/zabbix_agentd "$ZBXHOME"/LIBS/libiconv.a "$DEFAULT"/AIX/zabbix "$DEFAULT"/AIX/zabbix_agentd.pid "$DEFAULT"/AIX/zabbix_agentd.log "$DEFAULT"/AIX/rc.zabbix "$user"@"$host":/tmp
	
	if [ $? -eq "0" ]
		then
		echo "Arquivos zabbix_sender, zabbix_get, zabbix_agentd, libiconv.a, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix copiados com sucesso para o diretorio /tmp no servidor $host"
		else
		echo "Falha ao copiar arquivos zabbix_sender, zabbix_get, zabbix_agentd, libiconv.a, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix para o diretorio /tmp no servidor $host"
	fi

	rm -rf "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf

	ssh -t "$user@$host" 'ksh -s' < "$ZBXHOME"/scripts/zabbix_inst_aix.sh
}

ZBX_SOL () {
	sed "s/^Hostname=.*/Hostname=$host/g" "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.default >> "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf
	if [ $? -eq "0" ]
		then
		echo "Parametro Hostname= do arquivo zabbix_agentd.conf ajustado no servidor $host com sucesso"
		else
		echo "Falha ao ajustar parametro Hostname= do arquivo zabbix_agentd.conf no servidor $host"
	fi

	scp -rp "$ZBXSOL"/zabbix_sender "$ZBXSOL"/zabbix_get "$ZBXSOL"/zabbix_agentd "$DEFAULT"/SOL/zabbix "$DEFAULT"/SOL/zabbix_agentd.pid "$DEFAULT"/SOL/zabbix_agentd.log "$DEFAULT"/SOL/rc.zabbix "$user"@"$host":/tmp
	
	if [ $? -eq "0" ]
		then
		echo "Arquivos zabbix_sender, zabbix_get, zabbix_agentd, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix copiados com sucesso para o diretorio /tmp no servidor $host"
		else
		echo "Falha ao copiar arquivos zabbix_sender, zabbix_get, zabbix_agentd, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix para o diretorio /tmp no servidor $host"
	fi

	rm -rf "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf

	ssh -t "$user@$host" 'ksh -s' < "$ZBXHOME"/scripts/zabbix_inst_sol.sh
}

ZBX_LNX_64 () {
	sed "s/^Hostname=.*/Hostname=$host/g" "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.default >> "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf
	if [ $? -eq "0" ]
		then
		echo "Parametro Hostname= do arquivo zabbix_agentd.conf ajustado no servidor $host com sucesso"
		else
		echo "Falha ao ajustar parametro Hostname= do arquivo zabbix_agentd.conf no servidor $host"
	fi

	scp -rp "$ZBXLNX64"/zabbix_sender "$ZBXLNX64"/zabbix_get "$ZBXLNX64"/zabbix_agentd "$DEFAULT"/LNX/zabbix "$DEFAULT"/LNX/zabbix_agentd.pid "$DEFAULT"/LNX/zabbix_agentd.log "$DEFAULT"/LNX/rc.zabbix "$user"@"$host":/tmp
	
	if [ $? -eq "0" ]
		then
		echo "Arquivos zabbix_sender, zabbix_get, zabbix_agentd, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix copiados com sucesso para o diretorio /tmp no servidor $host"
		else
		echo "Falha ao copiar arquivos zabbix_sender, zabbix_get, zabbix_agentd, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix para o diretorio /tmp no servidor $host"
	fi

	rm -rf "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf

	ssh -t "$user@$host" 'sh -s' < "$ZBXHOME"/scripts/zabbix_inst_lnx.sh
}

ZBX_LNX_32 () {
	sed "s/^Hostname=.*/Hostname=$host/g" "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.default >> "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf
	if [ $? -eq "0" ]
		then
		echo "Parametro Hostname= do arquivo zabbix_agentd.conf ajustado no servidor $host com sucesso"
		else
		echo "Falha ao ajustar parametro Hostname= do arquivo zabbix_agentd.conf no servidor $host"
	fi

	scp -rp "$ZBXLNX32"/zabbix_sender "$ZBXLNX32"/zabbix_get "$ZBXLNX32"/zabbix_agentd "$DEFAULT"/LNX/zabbix "$DEFAULT"/LNX/zabbix_agentd.pid "$DEFAULT"/LNX/zabbix_agentd.log "$DEFAULT"/LNX/rc.zabbix "$user"@"$host":/tmp
	
	if [ $? -eq "0" ]
		then
		echo "Arquivos zabbix_sender, zabbix_get, zabbix_agentd, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix copiados com sucesso para o diretorio /tmp no servidor $host"
		else
		echo "Falha ao copiar arquivos zabbix_sender, zabbix_get, zabbix_agentd, zabbix, zabbix_agentd.pid, zabbix_agentd.log e rc.zabbix para o diretorio /tmp no servidor $host"
	fi

	rm -rf "$ZBXHOME"/DEFAULT/FILES/zabbix/zabbix_agentd.conf

	ssh -t "$user@$host" 'sh -s' < "$ZBXHOME"/scripts/zabbix_inst_lnx.sh
}

echo "Digite o nome do usuario"
read -r user

while read -r host
do
echo "============================================================================================"
echo "Executando instalacao do Zabbix Agent com o usuario $user no servidor $host"
echo "============================================================================================"
echo

# VERIFICACAO DE SISTEMA OPERACIONAL E INSTALANDO DOS PACOTES

CHK=$(ssh -n "$user@$host" uname)
OS=$CHK
if [ "$OS" = "AIX" ]
	then
	CHKAIX=$(ssh -n "$user@$host" oslevel)
	OSAIX=$CHKAIX
	case "$OSAIX" in
		"7.1.0.0")

			ZBX_AIX6e7 ;;

		"6.1.0.0")

			ZBX_AIX6e7 ;;		

		"5.3.0.0")

			ZBX_AIX53 ;;
	esac

	elif [ "$OS" = "Linux" ]
	then
	CHKLNX=$(ssh -n "$user@$host" uname -m)
	OSLNX=$("echo $CHKLNX")
	case "$OSLNX" in
		"x86_64")

			ZBX_LNX_64 ;;

		"i686")

			ZBX_LNX_32 ;;
	esac

	elif [ "$OS" = "SunOS" ]
	then
	ZBX_SOL
fi

done < list

;;

esac
}
menu