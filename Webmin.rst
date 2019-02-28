Webmin
============

* Webmin é um programa de gerenciamento de servidor, que roda em plataformas unix.
Com ele você pode usar também o Usermin e o Virtualmin.
O Webmin funciona como um centralizador de configurações do sistema
Monitoração dos serviços e de servidores, fornecendo uma interface amigável
quando configurado com um servidor web, pode ser acessado de qualquer local, através de um navegador:
https:\\(ip do servidor):(porta de utilização). Exemplo: https:\\ 172.168.5.12:10000

Instalação
---------------
**Para Debian e derivados**

``wget http://prdownloads.sourceforge.net/webadmin/webmin_1.900_all.deb``

Após baixar o arquivo execute o comando:

``dpkg --install webmin_1.900_all.deb``

É necessário baixar algumas dependencias para que o serviço rode com eficiência.

``apt install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python``

A instalação será feita automaticamente para ``/usr/ share/webmin``
O nome de usuário de administração definido como ``root`` e a senha para sua senha atual.
Agora você deve conseguir acessar o Webmin na URL http://localhost:10000/
Ou, se acessá-lo remotamente, substitua ``localhost`` pelo endereço IP do seu sistema.

Importante
--------------
**Algumas distribuições baseadas no Debian (Ubuntu em particular) não permitem logins pelo usuário root por padrão.
No entanto, o usuário criado no momento da instalação do sistema pode usar sudo para alternar para root.
Webmin permitirá que qualquer usuário com esse recurso sudo faça o login com privilégios de root completos.**

**Se você quiser se conectar a partir de um servidor remoto e seu sistema tiver um firewall instalado,
será necessário criar regra para habilitar a porta 10000**

Pacotes de fontes
--------------------
Os arquivos necessários para construir o pacote Debian são:
``deb/webmin_1.900.dsc`` , ``deb / webmin_1.900.diff`` e ``webmin-1.900.tar.gz``
