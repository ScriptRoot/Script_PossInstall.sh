#!/usr/bin/env bash
#
################################
# Script desenvolvido por: Leandro Vezu
#
# Versão: 1.0
# Status: Public
#
# DESCRIÇÃO:
# Este script foi desenvolvido para facilitar a pós instalação do sistema
# ele irá baixar alguns pacotes que fica em uma lista, caso queira alterar/remover/acrescentar
# algum programa pasta alterar a lista, todo o código esta comentado facilitando assim a
# manutenção do mesmo, sinta-se livre para entrar em contato caso esteja com dúvidas.
################################

# Limpando o terminal
clear
# Importando o arquivo os-release (não alterar/remover)
source /etc/os-release
os_name=$(echo "$ID" | tr -d ' ' | tr '[:upper:]' '[:lower:]')

# Arquivo de log
log_arquivo="$HOME/poss_install.log"

# Lista de programas a serem instalados
programas=(
    "wget"             # Download de arquivo
    "curl"             # Cliente HTTP
    "nano"             # Editor de texto
    "git"              # Gerenciador de versões
)

######## Verificando o sistema linux e instalando os programas

# Ubuntu 
if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
    # Instalando pacotes
    echo "Seu sistema operancional foi identificado como $os_name"
    echo "Atualizando o sistema linux, aguarde a finalizacao do processo."
    sudo apt-get update -y &>> $log_arquivo
    echo "Processo finalizado"
    echo "Instalando os programas listados, aguarde a finalizacao da instalação."
    sudo apt-get install -y "${programas[@]}" &>> $log_arquivo
    echo "Programas instalados, verifique o arquivo de log para mais informações"
    sudo apt-get upgrade -y &>> $log_arquivo
    echo "Instalação concluída com sucesso!"
    exit 0

# CentOS ou Fedora
elif [[ "$os_name" == "centos" || "$os_name" == "fedora" ]]; then
    # Se o sistema for CentOS, é necessário habilitar o repositório de software extras
    if [[ "$os_name" == "centos" ]]; then
        sudo dnf install -y epel-release &>> $log_arquivo
    fi
    # Se o sistema for Fedora, é necessário habilitar o repositório de software extras
    if [[ "$os_name" == "fedora" ]]; then
        sudo dnf install -y dnf-plugins-core &>> $log_arquivo
    fi
    # Instalando pacotes
    echo "Seu sistema operancional foi identificado como $os_name"
    echo "Atualizando o sistema linux, aguarde a finalizacao do processo."
    sudo dnf update &>> $log_arquivo
    echo "Processo finalizado"
    sudo dnf install -y "${programas[@]}" &>> $log_arquivo
    echo "Programas instalados, verifique o arquivo de log para mais informações"
    exit 0

# Arch Linux
elif [[ "$os_name" == "arch" || "$os_name" == "archlinux" ]]; then
    # Instalando pacotes
    echo "Seu sistema operancional foi identificado como $os_name"
    echo "Atualizando o sistema linux, aguarde a finalizacao do processo."
    sudo pacman -Syu &>> $log_arquivo
    echo "Processo finalizado"
    sudo pacman -S --noconfirm "${programas[@]}" &>> $log_arquivo
    echo "Programas instalados, verifique o arquivo de log para mais informações"
    exit 0

# Freebsd
elif [[ "$os_name" == "freebsd" ]]; then
    # Instalando pacotes
    echo "Seu sistema operancional foi identificado como $os_name"
    echo "Instalando os programas listados, aguarde a finalizacao da instalação."
    sudo pkg install -y "${programas[@]}" &>> $log_arquivo
    echo "Programas instalados, verifique o arquivo de log para mais informações"
    exit 0

# Sistema não suportado
else
    echo "Este script não é suportado para este sistema operacional"
    exit 1

fi
######## Fim da verificação e instalação
