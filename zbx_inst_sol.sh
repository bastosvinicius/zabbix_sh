#!/usr/bin/sh
# Desc.: Instalacao local Zabbix Agent
# Autor: Vinicius Bastos
# Versao 0.2
# Exec.: zbx_inst_sol.sh

sudo su -

# DEFININDO VARIAVEIS

DATA=$(date +%d"/"%m"/"%y"_"%T)
ZBXVER="3.0 - Solaris $(uname -r)"

# INICIA SCRIPT


# FUNCOES DE VERIFICAO DE USUARIO E GRUPO

check_user () {
  if [ "$(grep -c monitor /etc/passwd)" -eq "1" ]
    then
    echo "Usuario monitor existente no servidor $(hostname), continuando instalacao do Zabbix Agent $ZBXVER"
    else
    echo "Usuario monitor nao existe no servidor $(hostname), solicitar ao time de UNIX criacao"
    echo "Saindo da instalacao"
    exit
  fi
}

check_group () {
  if [ "$(grep -c monitor /etc/group)" -eq "1" ]
    then
    echo "Grupo monitor existente no servidor $(hostname), continuando instalacao do Zabbix Agent $ZBXVER"
    else
    echo "Grupo monitor nao existe no servidor $(hostname), solicitar ao time de UNIX criacao"
    echo "Saindo da instalacao"
    exit
  fi
}

# FUNCAO DE VERIFICACAO DE USERPARAMETERS

check_userparameter () {
  if [ -e /opt/zabbix/zabbix_agentd.conf ]
    then
    if [ "$(grep -c ^UserParameter /opt/zabbix/zabbix_agentd.conf)" -ge "1" ]
      then
      grep ^UserParameter /opt/zabbix/zabbix_agentd.conf >> /tmp/zabbix/zabbix_agentd.conf
      if [ $? -eq "0" ]
        then
        echo "Parametros UserParameter inseridos no arquivo /tmp/zabbix/zabbix_agentd.conf"
        else
        echo "Falha ao inserir paramtros UserParameter no arquivo /tmp/zabbix/zabbix_agentd.conf"
      fi
      echo "Nao ha parametros de UserParameters para insercao no conf do Zabbix"
    fi
      else
      echo "Arquivo /opt/zabbix/zabbix_agentd.conf nao existe, sera criado durante a instalacao"
  fi
}

# FUNCAO DE VERIFICACAO DE ARQUIVOS .OLD

remove_old () {
  if [ -e /bin/zabbix_get.old ]
    then
    rm -rf /bin/zabbix_get.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo /bin/zabbix_get.old removido com sucesso"
      else
      echo "Falha na remocao do arquivo /bin/zabbix_get.old"
    fi
    else
    echo "Arquivo /bin/zabbix_get.old nao existente, dando continuidade na instalacao"
  fi

  if [ -e /bin/zabbix_sender.old ]
    then
    rm -rf /bin/zabbix_sender.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo /bin/zabbix_sender.old removido com sucesso"
      else
      echo "Falha na remocao do arquivo /bin/zabbix_sender.old"
    fi
    else
    echo "Arquivo /bin/zabbix_sender.old nao existente, dando continuidade na instalacao"
  fi

  if [ -e /sbin/zabbix_agentd.old ]
    then
    rm -rf /sbin/zabbix_agentd.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo /sbin/zabbix_agentd.old removido com sucesso"
      else
      echo "Falha na remocao do arquivo /sbin/zabbix_agentd.old"
    fi
    else
    echo "Arquivo /sbin/zabbix_agentd.old nao existente, dando continuidade na instalacao"
  fi

  if [ -e /sbin/zabbix_agent.old ]
    then
    rm -rf /sbin/zabbix_agent.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo /sbin/zabbix_agent.old removido com sucesso"
      else
      echo "Falha na remocao do arquivo /sbin/zabbix_agent.old"
    fi
    else
    echo "Arquivo /sbin/zabbix_agent.old nao existente, dando continuidade na instalacao"
  fi

  if [ -e /opt/zabbix.old ]
    then
    rm -rf /opt/zabbix.old
    if [ $? -eq "0" ]
      then
      echo "Diretorio /opt/zabbix.old removido com sucesso"
      else
      echo "Falha na remocao do diretorio /opt/zabbix.old"
    fi
    else
    echo "Arquivo /opt/zabbix.old nao existente, dando continuidade na instalacao"
  fi

  if [ -e /var/run/zabbix_agentd.pid.old ]
    then
    rm -rf /var/run/zabbix_agentd.pid.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo /var/run/zabbix_agentd.pid.old removido com sucesso"
      else
      echo "Falha na remocao do arquivo /var/run/zabbix_agentd.pid.old"
    fi
    else
    echo "Arquivo /var/run/zabbix_agentd.pid.old nao existente, dando continuidade na instalacao"
  fi

  if [ -e /var/log/zabbix_agentd.log.old ]
    then
    rm -rf /var/log/zabbix_agentd.log.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo /var/log/zabbix_agentd.log.old removido com sucesso"
      else
      echo "Falha na remocao do arquivo /var/log/zabbix_agentd.log.old"
    fi
    else
    echo "Arquivo /var/log/zabbix_agentd.log.old nao existente, dando continuidade na instalacao"
  fi
}

# FUNCAO DE CHECAGEM DE ARQUIVOS ANTIGOS E MOVENDO PARA .OLD

chk_old () {

  if [ -e /bin/zabbix_get ]
    then
    echo "Arquivo zabbix_get existente no diretorio /bin, movendo para .old"
    mv /bin/zabbix_get /bin/zabbix_get.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo zabbix_get renomeado para zabbix_get.old com sucesso"
      else
      echo "Falha no rename do arquivo zabbix_get para zabbix_get.old"
    fi
    else
    echo "Arquivo zabbix_get nao presente no diretorio /bin, sera instalado"
  fi

  if [ -e /bin/zabbix_sender ]
    then
    echo "Arquivo zabbix_sender existente no diretorio /bin, movendo para .old"
    mv /bin/zabbix_sender /bin/zabbix_sender.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo zabbix_sender renomeado para zabbix_sender.old com sucesso"
      else
      echo "Falha no rename do arquivo zabbix_sender para zabbix_sender.old"
    fi
    else
    echo "Arquivo zabbix_sender nao presente no diretorio /bin, sera instalado"
  fi

  if [ -e /sbin/zabbix_agentd ]
    then
    echo "Arquivo zabbix_agentd existente no diretorio /sbin, movendo para .old"
    mv /sbin/zabbix_agentd /sbin/zabbix_agentd.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo zabbix_agentd renomeado para zabbix_agentd.old com sucesso"
      else
      echo "Falha no rename do arquivo zabbix_sender para zabbix_sender.old"
    fi
    else
    echo "Arquivo zabbix_agentd nao presente no diretorio /sbin, sera instalado"
  fi

  if [ -e /sbin/zabbix_agent ]
    then
    echo "Arquivo zabbix_agent existente no diretorio /sbin, movendo para .old"
    mv /sbin/zabbix_agent /sbin/zabbix_agent.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo zabbix_agent renomeado para zabbix_agent.old com sucesso"
      else
      echo "Falha no rename do arquivo zabbix_agent para zabbix_agent.old"
    fi
    else
    echo "Arquivo zabbix_agent nao presente no diretorio /sbin, sera instalado"
  fi

  if [ -e /var/run/zabbix_agentd.pid ]
    then
    echo "Arquivo zabbix_agentd.pid existente no diretorio /var/run, movendo para .old"
    mv /var/run/zabbix_agentd.pid /var/run/zabbix_agentd.pid.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo zabbix_agentd.pid renomeado para zabbix_agentd.pid.old com sucesso"
      else
      echo "Falha no rename do arquivo zabbix_agentd.pid para zabbix_agentd.pid.old"
    fi
    else
    echo "Arquivo zabbix_agentd.pid nao presente no diretorio /var/run, sera instalado"
  fi

  if [ -e /var/log/zabbix_agentd.log ]
    then
    echo "Arquivo zabbix_agentd.log existente no diretorio /var/run, movendo para .old"
    mv /var/log/zabbix_agentd.log /var/log/zabbix_agentd.log.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo zabbix_agentd.log renomeado para zabbix_agentd.log.old com sucesso"
      else
      echo "Falha no rename do arquivo zabbix_agentd.log para zabbix_agentd.log.old"
    fi
    else
    echo "Arquivo zabbix_agentd.log nao presente no diretorio /var/run, sera instalado"
  fi

  if [ -e /etc/rc.zabbix ]
    then
    echo "Arquivo rc.zabbix existente no diretorio /etc, movendo para .old"
    mv /etc/rc.zabbix /etc/rc.zabbix.old
    if [ $? -eq "0" ]
      then
      echo "Arquivo rc.zabbix renomeado para rc.zabbix.old com sucesso"
      else
      echo "Falha no rename do arquivo rc.zabbix para rc.zabbix.old"
    fi
    else
    echo "Arquivo rc.zabbix nao presente no diretorio /etc/, sera instalado"
  fi

  if [ -e /opt/zabbix ]
    then
    echo "Diretorio zabbix existente no diretorio /opt, movendo para .old"
    mv -f /opt/zabbix /opt/zabbix.old
    if [ $? -eq "0" ]
      then
      echo "Diretorio zabbix renomeado para zabbix.old com sucesso"
      else
      echo "Falha no rename do diretorio zabbix para zabbix.old"
    fi
    else
    echo "Diretorio zabbix nao presente no diretorio /opt, sera instalado"
  fi
}

# FUNCAO PARA INSTALACAO DE NOVOS ARQUIVOS - INSERCAO DO INITTAB - START DO SERVICO

inst_start () {

# ACERTANDO USUARIO E GRUPO DOS ARQUIVOS NOS DIRETORIOS, MOVIMENTANDO ARQUIVOS PARA DIRETORIO DE INSTALACAO, INITTAB E START DO CLIENT

  chown monitor:monitor /tmp/zabbix_sender
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo zabbix_sender"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo zabbix_sender"
  fi

  chown monitor:monitor /tmp/zabbix_get
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo zabbix_get"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo zabbix_get"
  fi

  chown monitor:monitor /tmp/zabbix_agentd
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo zabbix_agentd"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo zabbix_agentd"
  fi

  chown -R monitor:monitor /tmp/zabbix
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo zabbix"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo zabbix"
  fi

  chown monitor:monitor /tmp/zabbix_agentd.pid
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo zabbix_agentd.pid"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo zabbix_agentd.pid"
  fi

  chown monitor:monitor /tmp/zabbix_agentd.log
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo zabbix_agentd.log"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo zabbix_agentd.log"
  fi

  chown monitor:monitor /tmp/rc.zabbix
  if [ $? -eq 0 ]
    then
    echo "Ajustado usuario e grupo do arquivo rc.zabbix"
  else
    echo "Falha ao ajustar usuario e grupo do arquivo rc.zabbix"
  fi

  chmod 755 /tmp/zabbix_sender
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo zabbix_sender para 755"
  else
    echo "Falha ao ajustar permissao do arquivo zabbix_sender"
  fi

  chmod 755 /tmp/zabbix_get
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo zabbix_get para 755"
  else
    echo "Falha ao ajustar permissao do arquivo zabbix_get"
  fi

  chmod 755 /tmp/zabbix_agentd
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo zabbix_agentd para 755"
  else
    echo "Falha ao ajustar permissao do arquivo zabbix_agentd"
  fi

  chmod -R 755 /tmp/zabbix
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo zabbix para 755"
  else
    echo "Falha ao ajustar permissao do diretorio zabbix"
  fi

  chmod 755 /tmp/zabbix_agentd.pid
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo zabbix_agentd.pid para 755"
  else
    echo "Falha ao ajustar permissao do diretorio zabbix_agentd.pid"
  fi

  chmod 777 /tmp/zabbix_agentd.log
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo zabbix_agentd.log para 777"
  else
    echo "Falha ao ajustar permissao do diretorio zabbix_agentd.log"
  fi

  chmod 755 /tmp/rc.zabbix
  if [ $? -eq 0 ]
    then
    echo "Ajustado permissao do arquivo rc.zabbix para 755"
  else
    echo "Falha ao ajustar permissao do diretorio rc.zabbix"
  fi

  mv /tmp/zabbix_get /tmp/zabbix_sender /bin
  
  if [ $? -eq "0" ]
    then
    echo "Arquivos zabbix_get e zabbix_sender movidos para o diretorio /bin com sucesso"
  else
    echo "Falha ao mover arquivo zabbix_get e zabbix_sender para o diretorio /bin"
  fi

  mv /tmp/zabbix_agentd /sbin

  if [ $? -eq "0" ]
    then
    echo "Arquivos zabbix_agentd e zabbix_agent movidos para o diretorio /sbin com sucesso"
  else
    echo "Falha ao mover arquivo zabbix_agentd e zabbix_agent para o diretorio /sbin"
  fi

  mv /tmp/zabbix_agentd.pid /var/run

  if [ $? -eq "0" ]
    then
    echo "Arquivo zabbix_agentd.pid movido para o diretorio /var/run com sucesso"
  else
    echo "Falha ao mover arquivo zabbix_agentd.pid para o diretorio /var/run"
  fi
        
  mv /tmp/zabbix_agentd.log /var/log
        
  if [ $? -eq "0" ]
    then
    echo "Arquivo zabbix_agentd.log movido para o diretorio /var/log com sucesso"
  else
    echo "Falha ao mover arquivo zabbix_agentd.log para o diretorio /var/log"
  fi
        
  mv /tmp/rc.zabbix /etc

  if [ $? -eq "0" ]
    then
    echo "Arquivo rc.zabbix movido para o diretorio /etc com sucesso"
  else
    echo "Falha ao mover arquivo rc.zabbix para o diretorio /etc"
  fi
        
  mv /tmp/zabbix /opt
        
  if [ $? -eq "0" ]
    then
    echo "Diretorio zabbix movido para /opt com sucesso"
  else
    echo "Falha ao mover diretorio zabbix para /opt"
  fi

  if [ "$(grep -ci zabbix /etc/inittab)" -ge "1" ]
    then
    echo "Linha Zabbix existente no arquivo inittab"
    else
    cp -p /etc/inittab /etc/inittab_"$DATA"
    echo "monitor:2:wait:/etc/rc.zabbix start" >> /etc/inittab
    echo "Acrescida linha Zabbix no arquivo inittab"
  fi
        
  sudo -u monitor /etc/rc.zabbix start
        
  if [ $? -eq "0" ]
    then
    sleep 5
    if [ "$(ps -ef | grep -i zabbix | grep -v grep | wc -l)" -gt "0" ]
      then
      echo "Agent do Zabbix inicializado com sucesso no servidor $(hostname)"
      else
      echo "Falha ao iniciar Agent do Zabbix no servidor $(hostname)"
    fi
    else
    echo "Falha ao iniciar Agent do Zabbix $ZBXVER no servidor $(hostname)"
  fi
}

# MATANDO PROCESSOS DO ZABBIX

if [ "$(ps -ef | grep -i zabbix | grep -v grep | wc -l)" -gt "0"  ]
  then
  echo "Efetuando stop do Zabbix Agent $ZBXVER"
  /etc/rc.zabbix stop
  sleep 5
  if [ "$(ps -ef | grep -i zabbix | grep -v grep | wc -l)" -eq "0" ]
    then
    echo "Processos do Zabbix finalizados, iniciando instalacao do Zabbix Agent $ZBXVER"
    check_user
    check_group
    check_userparameter
    remove_old
    chk_old
    inst_start
    else
    echo "Falha ao matar processos do Zabbix no servidor $(hostname), Zabbix Agent $ZBXVER nao instalado"
    exit
  fi
  else
  if [ "$(ps -ef | grep -i zabbix | grep -v grep | wc -l)" -eq "0" ]
    then
    echo "Nao ha processos do Zabbix em execucao, iniciando instalacao do Zabbix Agent $ZBXVER"
    check_user
    check_group
    check_userparameter
    remove_old
    chk_old
    inst_start
    else
    echo "Falha ao instalar o Zabbix Agent $ZBXVER no servidor $(hostname)"
  fi
fi

exit