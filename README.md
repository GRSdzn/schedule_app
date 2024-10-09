# schedule_app

A Flutter project for get schedule from api.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Структура приложения

- app — ваш главный уровень, где могут находиться роутеры и другие глобальные настройки.

- bloc — уровень, отвечающий за управление состоянием с использованием BLoC (Business Logic Component). Хорошая практика — хранить все BLoC, события и состояния в одной папке.

- data — уровень, отвечающий за получение данных. В этом слое у вас находятся модели и репозитории, которые управляют данными, получаемыми из API или других источников.

- domain — уровень, отвечающий за бизнес-логику. Здесь находятся интерфейсы репозиториев и модели, специализированные для бизнес-логики.

- presentation — уровень, отвечающий за отображение интерфейса и взаимодействие с пользователем. Здесь находятся виджеты и другие компоненты UI.
