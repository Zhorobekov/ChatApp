# chat-app-Zhorobekov
[![CI](https://github.com/Zhorobekov/ChatApp/actions/workflows/main.yaml/badge.svg)](https://github.com/Zhorobekov/ChatApp/actions/workflows/main.yaml)

Realtime Мессенджер разработанный в рамках курса по iOS разработке. В нем использован следующий стек технологий:

● Архитектура: MVP (Model-View-Presenter), которая обеспечивает разделение ответственности и улучшает тестируемость приложения. 

● Сетевой слой реализован с использованием Combine - фреймворка, позволяющего обрабатывать асинхронные события и реализовывать реактивное программирование.

● Для создания пользовательского интерфейса (UI) приложения были использованы классические таблицы, а для управления данными в таблицах - Diffable Data Source. Это позволяет эффективно обновлять таблицы, используя разницу между состояниями данных и обеспечивает более плавный пользовательский опыт.

● Для обеспечения качества и надежности приложения были написаны как модульные (unit) тесты, так и тесты пользовательского интерфейса (UI). Тесты были разделены на отдельные тест-планы, что упрощает их управление и выполнение.

● Для автоматизации процессов сборки, тестирования и развертывания приложения был подключен инструмент Fastlane. Fastlane также отправляет уведомления в Discord, обеспечивая команду разработчиков актуальной информацией о процессе разработки.


https://github.com/Zhorobekov/ChatApp/assets/89958441/0873659b-6569-4a4d-bcf7-e0152a91eb84
