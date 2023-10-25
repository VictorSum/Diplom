# Дипломный проект


###  Создание  инфраструктуры
С помощью Terraform создаётся [инфраструктура](./main.tf) .  
[Сеть](./network.tf) с четырьмя подсетями в трёх зонах доступности. Реализуется [файервол](https://cloud.yandex.ru/docs/vpc/concepts/security-groups) разрешающий  входящий трафик только к определённым портам.  
![s](/images/subnet.png)  

Балансировщик
![balancer1](/images/balancer1.png) 
![balancer](/images/balancer.png)   

Security Grups
![security](/images/security.png) 

Далее с помощью ansible проверяем доступность узлов `ansible all -m ping` 
![ping](/images/ping.png)  

Все узлы доступны, последний это наш балансировщик.     
![out](/images/output.png)   

Далее с помощью плейбуков устанавливается сервисы на соответсвующие ВМ - `ansible-playbook prometheus.yml grafana.yml web-notls.yml node-exporter.yml nginxlog-exporter.yml elastic.yml kibana.yml filebeat.yml`  

![вм](/images/вм.png) 
ВМ "test" 51.250.38.230 моя машина с проектом

### Cайт
Две ВМ vm-nginx-1 и vm-nginx-2 для web-серверов во внутренней сети. Установлен nginx с нашим сайтом. Заходим через bastion по ssh. Отображается запущенные nginx и filebeat 
![ssh](/images/ssh.png)  

Публичный ip [балансировщика](https://cloud.yandex.ru/docs/application-load-balancer/) открывает сайт. Конфигурация плейбука устанавливающий nginx и сайт взята из книги "Запускаем ansible" с небольшими доработками.  
[51.250.32.178:80](http://51.250.32.178/)
![сайт](/images/сайт.png)   

### Мониторинг  
Проверяем работу Prometheus ip 10.0.3.3  
 
Сбор метрик    
![prometheus](/images/prometius.png)  
Проверяем работу сервиса node-exporter  
![node](/images/node.png)  

Переходим к Grafana. ip [51.250.34.196:3000](http://51.250.34.196:3000/d/rYdddlPWk/node-exporter-full?orgId=1&from=now-1h&to=now&refresh=5s)  
login - isupov  
passw - 12345  

Основные метрики с обоих серверов nginx1, nginx2 -  CPU, RAM, диски, сеть, http_response_count_total, http_response_size_bytes  
Перед этим загружаем подготовленный дашборд описаный в [json](grafana/dashbrd-full.md) файле  
![g1](/images/json.png) 
![g1](/images/g1.png)   
![g2](/images/g2.png)  
![g3](/images/g3.png)   

Добавление tresholds  
![tresholds](/images/tresholds1.png)   
![tresholds](/images/tresholds2.png)   
![tresholds](/images/tresholds3.png)   

### Логи  
Проверка ВМ с установленным elasticsearch ip 10.0.3.4 
![elastic](/images/elastic.png)  
Заходим в Kibana ip [51.250.37.54:5601](http://51.250.37.54:5601/app/discover#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_a=(columns:!(),filters:!(),index:ff361830-ad44-11ed-b3e3-efd5edde9d3e,interval:auto,query:(language:kuery,query:''),sort:!(!('@timestamp',desc))))    
 
Добавляем в Kibana индексы 
![kibana1](/images/kibana1.png)   

логи
![kibana1](/images/kibana2.png) 


### Резервное копирование  
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.    
Расписание  
![sn](/images/sn1.png) 

Создание по расписанию в процессе
![sn1](/images/sn2.png) 






