# Дипломная работа. Сомкин Александр.

# Доступ Kibana: 84.201.150.187:5601
# Доступ Grafana: 84.201.144.119:3000 login: admin pass: 12345

# Задание можно посмотреть по ссылке:
## [SYS-DIPLOM](https://github.com/netology-code/sys-diplom)

# Все конфигурационные файлы в репозитории. 

# 1. С помощью Terraform создаётся инфраструктура 
[main.tf](https://github.com/AlexanderSomkin/diplom/blob/main/main.tf)
Сеть с четырьмя подсетями в трёх зонах доступности. Реализуется файервол разрешающий входящий трафик только к определённым портам.

![subnet](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/subnets.png)
# Балансировщик:
![balancer](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/balancer_1.png)
# Целевые группы:
![targetgroups](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/balancer_2.png)
# Группы безопасности:
![backendgroups](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/security.png)
# 2. Далее с помощью ansible проверяем доступность узлов ansible –i inventory.ini all -m ping.
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/ansible_ping.png)

Все узлы доступны, последний это наш балансировщик.

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/outputs.png)

# 3. Далее с помощью плейбуков устанавливается сервисы на соответсвующие ВМ - ansible-playbook -i inventory.ini --private-key=/home/som/.ssh/id_ed25519 prometheus.yml grafana.yml web-notls.yml node-exporter.yml nginxlog-exporter.yml elastic.yml kibana.yml filebeat.yml
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/yandex_vms.png)

ВМ "project" 51.250.38.230 моя машина с проектом.

# 4. Cайт.

Две ВМ vm-nginx-1 и vm-nginx-2 для web-серверов во внутренней сети. Установлен nginx с нашим сайтом. Заходим через bastion по ssh. Отображается запущенные nginx и filebeat.

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/ssh_1.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/ssh_2.png)

Публичный ip балансировщика открывает сайт. Конфигурация плейбука устанавливающий nginx и сайт взята из книги "Запускаем ansible" с небольшими доработками.
158.160.114.43:80 
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/ngnix.png)

# 5. Мониторинг.
Проверяем работу Prometheus ip 10.0.3.3.
Сбор метрик.
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/metrics.png)

Проверяем работу сервиса node-exporter.
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/node.png)

Переходим к Grafana. ip  84.201.169.56:3000.

Основные метрики с обоих серверов nginx1, nginx2 - CPU, RAM, диски, сеть, http_response_count_total, http_response_size_bytes
Перед этим загружаем подготовленный дашборд описаный в json файле.
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/dashboard.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/grafana_1.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/grafana_2.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/grafana_3.png)

Добавление tresholds.

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/tresholds.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/tresholds_2.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/tresholds_3.png)

Заходим в Kibana. ip 84.201.170.82:5601
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/kibana_1.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/kibana_2.png)

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/kibana_3.png)

# 6. Резервное копирование. 
Создаем snapshot дисков всех ВМ. Ограничиваем время жизни snaphot в неделю. Сами snaphot настраиваем на ежедневное копирование.
Расписание.
![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/snapshot.png)

# Правки: [main.tf](https://github.com/AlexanderSomkin/diplom/blob/main/main.tf)

Автоматизация дашбордов: 

![](https://github.com/AlexanderSomkin/diplom/blob/main/screenshots/640f030c-f0e7-489b-bd12-690a01629f51.jpg)



