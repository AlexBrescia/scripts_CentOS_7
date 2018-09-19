#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### CentOS7
####
#### Скрипт подготовлен на базе статьй https://serveradmin.ru/centos-7-nastroyka-servera/#_firewall, с небольшими корректировками.
#### 
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит базовую настройку сервера CentOS 7, запишет в конфигурационные файлы простейшую конфигурацию! 
   

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux CentOS 7 Minimal.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.

# Скрипт должен быть исполняемым.

# Возможные варианты загрузки скрипта, на сервер:

# Загрузка скрипта, от клиента на сервер (выполняем команды на клиенте:)

#            1) scp /home/user/Рабочий\ стол/jenkins.sh user@ip_адрес_сервера:/home/user   (Левая сторона до user, расположение скрипта на клиенте. Правая сторона, вместо user укажите вашу учётную запись на сервере и его ip.)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#            3) запускаем скрипт sudo ./name_script.sh

# или

# Скачивание скрипта с клиентской машины на сервер (выполняем команды на сервере:) 
#            1) scp user@ip_адрес_компьютера_с_которого_скачиваем:/home/user/name_script.sh /home/user   (/home/user директория куда файл будет скопирован)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#            3) запускаем скрипт sudo ./name_script.sh
 
### Скрипт базовой настройки сервера CentOS. ###

# Обновление системы.
echo $(tput setaf 2) "Обновляю систему." $(tput sgr 0)

yum update && yum upgrade -y

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Устанавливаю и настройка Midnight Commander.
echo $(tput setaf 2) "Устанавливаю и настройка Midnight Commander." $(tput sgr 0)

yum -y install mc

cp /usr/share/mc/syntax/sh.syntax /usr/share/mc/syntax/unknown.syntax

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Отключаю SELinux.
echo $(tput setaf 2) "Отключаю SELinux." $(tput sgr 0)

sed -i 's/(^SELINUX=).*/SELINUX=disabled/' /etc/selinux/config

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


### Настраиваю firewall.
#echo $(tput setaf 2) "Настраиваю firewall." $(tput sgr 0)						# Раскомментируйте, если вам нужен вывод в терминал. (если вы настроили секцию)!
## В этом блоке вы увидите пример настройки Файрвола. Отключение firewalld и установка iptables-services с его дальнейшей настройкой. 
## В самом конце будет добавлен скрипт автора статьи https://serveradmin.ru/centos-7-nastroyka-servera/#_firewall с настройкой iptables.
## Этот раздел будет полностью закомментирован, в связи с тем что одна ошибка может сделать подключение по ssh невозможным.
## Если вы раскомментируете этот раздел, и внесите свой поправки внимательно проверьте каждую строку! 
## И обязательно проверьте работу скрипта в тестовой среде!
## Если вы сомневаетесь, оставьте этот раздел без изменений. Следующая строка, отключает стандартный файрвол
## Основные строки кода, которые нужно раскомментировать в этой секции будут отмечены знаком ### 

systemctl stop firewalld							                         # Остановка сервиса стандартного файрвола 

systemctl disable firewalld 							                         # Отмена автозагрузки стандартного файрвола.  

    
#echo $(tput setaf 2) "Выполняю настройку файрвола." $(tput sgr 0)	###	                         # Если вы решили настроить файрвол, раскомментируйте строки (начало)   
			
#yum -y install iptables-services  					###	                         # Установка iptables.

#systemctl enable iptables						###	                         # Добавляю в автозапуск iptables.

### Скрипт автора статьй ###

#export IPT="iptables"							###	                         ## Основная секция 

# Внешний интерфейс
#export WAN=eth0							###	                         # Проверьте интерфейс, он может различаться.
#export WAN_IP=85.31.203.127						###	                         # Введите ваш ip адрес.

# Локальная сеть
#export LAN1=eth1							###	                         # Проверьте интерфейс, он может различаться.
#export LAN1_IP_RANGE=10.1.3.0/24					###	                         # Введите ваш ip адрес.

# Очищаем правила
#$IPT -F                                                                ###
#$IPT -F -t nat                                                         ###
#$IPT -F -t mangle                                                      ###
#$IPT -X                                                                ###
#$IPT -t nat -X                                                         ###
#$IPT -t mangle -X                                                      ###

# Запрещаем все, что не разрешено
#$IPT -P INPUT DROP                                                     ###
#$IPT -P OUTPUT DROP							###
#$IPT -P FORWARD DROP							###

# Разрешаем localhost и локалку
#$IPT -A INPUT -i lo -j ACCEPT						###
#$IPT -A INPUT -i $LAN1 -j ACCEPT					###
#$IPT -A OUTPUT -o lo -j ACCEPT						###
#$IPT -A OUTPUT -o $LAN1 -j ACCEPT					###

# Разрешаем пинги
#$IPT -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT                 ###
#$IPT -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT    ###
#$IPT -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT              ###
#$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT               ###

# Разрешаем исходящие подключения сервера
#$IPT -A OUTPUT -o $WAN -j ACCEPT					###
#$IPT -A INPUT -i $WAN -j ACCEPT

# разрешаем установленные подключения
#$IPT -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT    ###
#$IPT -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT   ###
#$IPT -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT  ###

# Отбрасываем неопознанные пакеты
#$IPT -A INPUT -m state --state INVALID -j DROP                         ###
#$IPT -A FORWARD -m state --state INVALID -j DROP                       ###

# Отбрасываем нулевые пакеты
#$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP                      ###

# Закрываемся от syn-flood атак
#$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP              ###
#$IPT -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP             ###				     



# Разрешаем доступ из локалки наружу
#$IPT -A FORWARD -i $LAN1 -o $WAN -j ACCEPT                             ###

# Закрываем доступ снаружи в локалку
#$IPT -A FORWARD -i $WAN -o $LAN1 -j REJECT                             ###


# Включаем NAT
#$IPT -t nat -A POSTROUTING -o $WAN -s $LAN1_IP_RANGE -j MASQUERADE     ###

# открываем доступ к SSH
#$IPT -A INPUT -i $WAN -p tcp --dport 22 -j ACCEPT	                ###			             # Основная секция завершена. Исправьте порт если вы будету настраивать другой.



# Блокируем доступ с указанных адресов								             # Дополнительная секция. Можете настроить по желанию.
#$IPT -A INPUT -s 84.122.21.197 -j REJECT

# Пробрасываем порт в локалку
#$IPT -t nat -A PREROUTING -p tcp --dport 23543 -i ${WAN} -j DNAT --to 10.1.3.50:3389
#$IPT -A FORWARD -i $WAN -d 10.1.3.50 -p tcp -m tcp --dport 3389 -j ACCEPT

# Открываем доступ к почтовому серверу								
#$IPT -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT

#Открываем доступ к web серверу
#$IPT -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

#Открываем доступ к DNS серверу
#$IPT -A INPUT -i $WAN -p udp --dport 53 -j ACCEPT

# Включаем логирование
#$IPT -N block_in
#$IPT -N block_out
#$IPT -N block_fw

#$IPT -A INPUT -j block_in
#$IPT -A OUTPUT -j block_out
#$IPT -A FORWARD -j block_fw

#$IPT -A block_in -j LOG --log-level info --log-prefix "--IN--BLOCK"
#$IPT -A block_in -j DROP
#$IPT -A block_out -j LOG --log-level info --log-prefix "--OUT--BLOCK"
#$IPT -A block_out -j DROP
#$IPT -A block_fw -j LOG --log-level info --log-prefix "--FW--BLOCK"
#$IPT -A block_fw -j DROP

# Сохраняем правила
#/sbin/iptables-save  > /etc/sysconfig/iptables				

### Скрипт автора статьй завершен. ###

#echo $(tput setaf 3) "Выполнено!" $(tput sgr 0).			   			                  # Раскомментируйте, если вам нужен вывод в терминал. (если вы настроили секцию)!


# Выполняю настройку времени.
echo $(tput setaf 2) "Выполняю настройку синхронизации времени." $(tput sgr 0)

mv /etc/localtime /etc/localtime.bak										   # Создание резервной копии, конфигурационного файла.
ln -s /usr/share/zoneinfo/Europe/Samara /etc/localtime								   # Запись в файл часового пояса Samara (Исправьте на свой).
yum install ntp													   # Устанавливаю утилиту синхронизации времени ntp в CentOS
/usr/sbin/ntpdate pool.ntp.org											   # Выполняю синхронизацию времени.
systemctl start ntpd												   # Запускаю сервис ntpd.
systemctl enable ntpd												   # Добавляю сервис ntpd, в автозагрузку.	
ln -s '/usr/lib/systemd/system/ntpd.service' '/etc/systemd/system/multi-user.target.wants/ntpd.service'		   # Создаю символическую ссылку.	

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Устанавливаю сетевые утилиты.
echo $(tput setaf 2) "Устанавливаю сетевые утилиты." $(tput sgr 0)

yum -y install net-tools.x86_64
yum -y install bind-utils

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Добавляю репозитории EPEL." $(tput sgr 0)

yum -y install epel-release

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Добавляю репозитории rpmforge." $(tput sgr 0)

rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
yum install http://repository.it4i.cz/mirrors/repoforge/redhat/el7/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Настройка автоматического обновления системы.
echo $(tput setaf 2) "Настройка автоматического обновления системы." $(tput sgr 0)

yum -y install yum-cron   # Конфигурационные файлы yum-cron находятся по адресу /etc/yum/yum-cron.conf     В разделе [email], можно указать параметры отправки сообщений.

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Отключаю флуд сообщений в /var/log/messages.
echo $(tput setaf 2) "Отключаю флуд сообщений в /var/log/messages." $(tput sgr 0)

{
 
  echo 'if $programname == "systemd" and ($msg contains "Starting Session" or $msg contains "Started Session" or $msg contains "Created slice" or $msg contains "Starting user-" or $msg contains "Starting User Slice of" or $msg contains "Removed session" or $msg contains "Removed slice User Slice of" or $msg contains "Stopping User Slice of") then stop'

} > /etc/rsyslog.d/ignore-systemd-session-slice.conf

systemctl restart rsyslog												# перезапускаю службу rsyslog. 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Настраиваю файл хранения истории.
echo $(tput setaf 2) "Настраиваю файл хранения истории." $(tput sgr 0)

export HISTSIZE=10000													 # Увеличиваю размер сохраняемых команд до 10000 
export HISTTIMEFORMAT="%h %d %H:%M:%S "											 # Этот параметр сохраняет дату и время.
PROMPT_COMMAND='history -a'												 # После выполнения команды, сохраняет её в историю. 
export HISTIGNORE="ls:ll:history:w"											 # Cписок исключений для тех команд, запись которых в историю не требуется
															 # Проверить результат можно так  cat ~/.bashrc

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Установка iftop, atop, htop, lsof
echo $(tput setaf 2) "Установка iftop, atop, htop, lsof" $(tput sgr 0)

yum -y install iftop													  # Показывает загрузку сетевого интерфейса.
yum -y install htop													  # Диспетчер задач
yum -y install atop													  # Информирует о том, какие файлы используются теми или иными процессами.

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Установка  wget, bzip2, traceroute, gdisk
echo $(tput setaf 2) "Установка  wget, bzip2, traceroute, gdisk" $(tput sgr 0)

yum -y install wget bzip2 traceroute gdisk												  

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Базовая нстройка сервера CentOS7 завершена!" $(tput sgr 0)


echo $(tput setaf 2) "Комментарий" $(tput sgr 0)							                   # Комментарий от автора. 

echo $(tput setaf 2) "Для проверки интерфейса сети выполните команду ls /etc/sysconfig/network-scripts (ifcfg-(eth0) проверьте интерфейс, он может различаться)" $(tput sgr 0)   

echo $(tput setaf 2) "Для настройки сети выполните команду vi или (mc,nano) /etc/sysconfig/network-scripts/ifcfg-eth0" $(tput sgr 0)

echo $(tput setaf 2) "Для перезагрузки сети, выполните команду service network restart" $(tput sgr 0)

echo $(tput setaf 2) "Для настройки ssh выполните команду vi (mc,nano) /etc/ssh/sshd_config" $(tput sgr 0)	            # Комментарий завершен.

echo $(tput setaf 2) "" $(tput sgr 0)

echo $(tput setaf 2) "Комментарий завершен" $(tput sgr 0)							






