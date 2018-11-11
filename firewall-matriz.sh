#!/bin/bash
#Modelo alternativo de firewall

function startFirewall(){
    iptables -X
    iptables -F
    iptables -t nat -X
    iptables -t nat -F
    echo "1"> /proc/sys/net/ipv4/ip_forward
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
    iptables -A PREROUTING -t nat -i enp0s8 -p tcp --dport 80 -j DNAT --to 192.168.110.0:80
    iptables -A FORWARD -p tcp -d 192.168.110.0 --dport 80 -j ACCEPT
}

function stopFirewall(){
    iptables -X
    iptables -F
    iptables -t nat -X
    iptables -t nat -F
}

case "$1" in
    start )
        startFirewall
        echo "Firewall carregado com sucesso"
        ;;
    stop )
        stopFirewall
        echo "Regras de firewall removidas"
        ;;
    restart )
        stopFirewall
        sleep 1
        startFirewall
        ;;
    status )
        iptables -nL
        ;;
     * )
        echo "Use-> firewall start | stop | restart | status"
        ;;
esac
