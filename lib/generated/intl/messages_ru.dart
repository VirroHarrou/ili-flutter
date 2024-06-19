// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(url) => "Неполучилось запустить ссылку ${url}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'нет вопросов', one: 'вопрос', two: 'вопроса', few: 'вопроса', many: 'вопросов', other: 'вопросов')}";

  static String m2(remain) => "${remain} вопросов";

  static String m3(version) => "Версия: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "all": MessageLookupByLibrary.simpleMessage("Всё"),
        "arWarningMessage": MessageLookupByLibrary.simpleMessage(
            "Если вам нет 18, используйте приложение в присутствии родителей. Cледите за своим окружением, AR может искажать объекты."),
        "begin": MessageLookupByLibrary.simpleMessage("Начать"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "complete": MessageLookupByLibrary.simpleMessage("Завершено"),
        "contactWithUs":
            MessageLookupByLibrary.simpleMessage("Связаться с нами"),
        "couldNotLaunchUrl": m0,
        "datesEvent": MessageLookupByLibrary.simpleMessage("Даты проведения"),
        "description": MessageLookupByLibrary.simpleMessage("Описание"),
        "downloadModelsAndWillAppear": MessageLookupByLibrary.simpleMessage(
            "Скачивайте модели и они появятся здесь"),
        "enterAnswer": MessageLookupByLibrary.simpleMessage("Введите ответ"),
        "enterModelCode":
            MessageLookupByLibrary.simpleMessage("Введите код модели"),
        "errorModelData":
            MessageLookupByLibrary.simpleMessage("Ошибка в данных модели!"),
        "errorWhileUpdating": MessageLookupByLibrary.simpleMessage(
            "При обновлении данных произошла ошибка, пожалуйста попробуйте позже"),
        "exit": MessageLookupByLibrary.simpleMessage("Выйти"),
        "favorites": MessageLookupByLibrary.simpleMessage("Каталог"),
        "find": MessageLookupByLibrary.simpleMessage("Найти..."),
        "homePage": MessageLookupByLibrary.simpleMessage("Главная"),
        "informationAbout":
            MessageLookupByLibrary.simpleMessage("Информация о"),
        "linkWithoutTitle":
            MessageLookupByLibrary.simpleMessage("Ссылка без названия"),
        "loadModel":
            MessageLookupByLibrary.simpleMessage("Загружаем 3D модель..."),
        "location": MessageLookupByLibrary.simpleMessage("Расположение"),
        "map": MessageLookupByLibrary.simpleMessage("Карта"),
        "modelLinkNotCorrect": MessageLookupByLibrary.simpleMessage(
            "Ссылка на модель не корректна для вашей платформы"),
        "news": MessageLookupByLibrary.simpleMessage("Новости"),
        "next": MessageLookupByLibrary.simpleMessage("Далее"),
        "ok": MessageLookupByLibrary.simpleMessage("Ок"),
        "platforms": MessageLookupByLibrary.simpleMessage("Площадки"),
        "platformsWillBeHereButEmpty": MessageLookupByLibrary.simpleMessage(
            "Здесь появятся площадки, но пока здесь пусто"),
        "pointCameraAtQR":
            MessageLookupByLibrary.simpleMessage("Наведите камеру на QR-код"),
        "privacyPolicy":
            MessageLookupByLibrary.simpleMessage("Политика конфиденциальности"),
        "questionnaires": MessageLookupByLibrary.simpleMessage("Опросники"),
        "questions": m1,
        "remainQuestions": m2,
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Упс! Что-то пошло не так..."),
        "stillEmpty": MessageLookupByLibrary.simpleMessage("Здесь пока пусто"),
        "successfullyCompletedSurvey": MessageLookupByLibrary.simpleMessage(
            "Спасибо! Вы успешно прошли опрос"),
        "usefulLinks": MessageLookupByLibrary.simpleMessage("Полезные ссылки"),
        "version": m3
      };
}
