# Firewall com Mikrotik
#
/ip firewall address-list add address=uai.com.br list=LIBERADOS
/ip firewall address-list add address=192.168.110.0/24 list=REDE-LAN
/ip firewall address-list add address=201.1.1.0/24 list=REDE-LAN
/ip firewall filter add action=accept chain=input comment="====================================== LIBERADOS ======================================" src-address-list=LIBERADOS
/ip firewall filter add action=drop chain=input comment="====================================== Invalidos ==========================================" connection-state=invalid
/ip firewall filter add action=drop chain=input comment="====================================== ICMP Broadcast ======================================" dst-address-type=broadcast protocol=icmp
/ip firewall filter add action=accept chain=input comment="====================================== Estabelecidas, Relacionadas e Untrack ======================" connection-state=established,related,untracked
/ip firewall filter add action=add-src-to-address-list address-list=PORTSCAN address-list-timeout=1w chain=input comment="====================================== PORTSCAN ======================================" protocol=tcp psd=21,3s,3,1
/ip firewall filter add action=add-src-to-address-list address-list=PORTSCAN address-list-timeout=1w chain=input protocol=udp psd=21,3s,3,1
/ip firewall filter add action=add-src-to-address-list address-list=PORTSCAN address-list-timeout=1w chain=input comment="====================================== PEGA MALANDRO =================================" dst-port=3389 protocol=tcp src-address-list=!LIBERADOS
/ip firewall filter add action=add-src-to-address-list address-list=FASE1 address-list-timeout=3s chain=input comment="====================================== PORTKNOCK ======================================" dst-port=3265 protocol=tcp
/ip firewall filter add action=add-src-to-address-list address-list=FASE2 address-list-timeout=3s chain=input dst-port=9878 protocol=tcp src-address-list=FASE1
/ip firewall filter add action=add-src-to-address-list address-list=LIBERADOS address-list-timeout=1d chain=input dst-port=2589 protocol=udp src-address-list=FASE2
/ip firewall filter add action=accept chain=input comment="====================================== Winbox ======================================" dst-port=8291 protocol=tcp src-address-list=LIBERADOS
/ip firewall filter add action=accept chain=input comment="====================================== L2TP com IPSec ======================================" dst-port=1701,500,4500 in-interface-list=OPERADORAS limit=200,5:packet protocol=udp
/ip firewall filter add action=accept chain=input protocol=ipsec-esp
/ip firewall filter add action=jump chain=input comment="======================================= CONTROLE DE ICMP ==============================" jump-target=Controle-ICMP protocol=icmp
/ip firewall filter add action=accept chain=input comment="================================  DNS CACHE ===============================" dst-port=53 in-interface-list=!OPERADORAS protocol=udp
/ip firewall filter add action=accept chain=input comment="==================================== DHCP ================================================" dst-port=67,68 protocol=udp
/ip firewall filter add action=drop chain=input comment="====================================  drop ssh brute forcers ==================================== " dst-port=22 protocol=tcp src-address-list=ssh_blacklist
/ip firewall filter add action=add-src-to-address-list address-list=ssh_blacklist address-list-timeout=1w3d chain=input connection-state=new dst-port=22 protocol=tcp src-address-list=ssh_stage3
/ip firewall filter add action=add-src-to-address-list address-list=ssh_stage3 address-list-timeout=1m chain=input connection-state=new dst-port=22 protocol=tcp src-address-list=ssh_stage2
/ip firewall filter add action=add-src-to-address-list address-list=ssh_stage2 address-list-timeout=1m chain=input connection-state=new dst-port=22 protocol=tcp src-address-list=ssh_stage1
/ip firewall filter add action=add-src-to-address-list address-list=ssh_stage1 address-list-timeout=1m chain=input connection-state=new dst-port=22 protocol=tcp
/ip firewall filter add action=accept chain=input comment=SSTP dst-port=443 protocol=tcp
/ip firewall filter add action=accept chain=input dst-port=22 protocol=tcp
/ip firewall filter add action=drop chain=input comment="======================================  DROP GERAL - WAN /LAN  ======================================"
/ip firewall filter add action=accept chain=Controle-ICMP comment="========================================== echo reply ====================" icmp-options=0:0-255 limit=50,5:packet protocol=icmp
/ip firewall filter add action=accept chain=Controle-ICMP comment="========================================= echo request =====================" icmp-options=8:0-255 limit=50,5:packet protocol=icmp
/ip firewall filter add action=accept chain=Controle-ICMP comment="=====================================   time exceeded =============" icmp-options=11:0-255 limit=50,5:packet protocol=icmp
/ip firewall filter add action=accept chain=Controle-ICMP comment="====================================== destination unreachable=======================" icmp-options=3:0-255 limit=50,5:packet protocol=icmp
/ip firewall filter add action=drop chain=Controle-ICMP icmp-options=0:0-255 protocol=icmp
/ip firewall filter add action=drop chain=forward comment="Anti - Spoofing" dst-address-list=!REDE-LAN log=yes src-address-list=!REDE-LAN
/ip firewall nat add action=accept chain=srcnat dst-address=192.168.200.0/24 src-address=192.168.110.0/24
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1-Operadora-1 src-address-list=REDE-LAN
/ip firewall raw add action=drop chain=prerouting comment="====================================== PORTSCAN ======================================" src-address-list=PORTSCAN
/ip firewall raw add action=accept chain=prerouting comment="====================================== ICMP Controlado ======================================" in-interface-list=OPERADORAS limit=50,5:packet protocol=icmp
/ip firewall raw add action=drop chain=prerouting in-interface-list=OPERADORAS protocol=icmp
/ip firewall raw add action=accept chain=prerouting limit=20,5:packet protocol=ipsec-ah
/ip firewall raw add action=drop chain=prerouting protocol=ipsec-ah
