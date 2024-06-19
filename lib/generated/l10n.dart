// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Platforms`
  String get platforms {
    return Intl.message(
      'Platforms',
      name: 'platforms',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Something went wrong...`
  String get somethingWentWrong {
    return Intl.message(
      'Oops! Something went wrong...',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Find...`
  String get find {
    return Intl.message(
      'Find...',
      name: 'find',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get homePage {
    return Intl.message(
      'Main',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `Catalog`
  String get favorites {
    return Intl.message(
      'Catalog',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Point the camera at the QR code`
  String get pointCameraAtQR {
    return Intl.message(
      'Point the camera at the QR code',
      name: 'pointCameraAtQR',
      desc: '',
      args: [],
    );
  }

  /// `If you are under 18, use the app in the presence of your parents. Keep an eye on your surroundings, AR can distort objects.`
  String get arWarningMessage {
    return Intl.message(
      'If you are under 18, use the app in the presence of your parents. Keep an eye on your surroundings, AR can distort objects.',
      name: 'arWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter the model code`
  String get enterModelCode {
    return Intl.message(
      'Enter the model code',
      name: 'enterModelCode',
      desc: '',
      args: [],
    );
  }

  /// `An error in the model data`
  String get errorModelData {
    return Intl.message(
      'An error in the model data',
      name: 'errorModelData',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Quit`
  String get exit {
    return Intl.message(
      'Quit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `The link to the model is not correct for your mobile platform`
  String get modelLinkNotCorrect {
    return Intl.message(
      'The link to the model is not correct for your mobile platform',
      name: 'modelLinkNotCorrect',
      desc: '',
      args: [],
    );
  }

  /// `Uploading a 3D model...`
  String get loadModel {
    return Intl.message(
      'Uploading a 3D model...',
      name: 'loadModel',
      desc: '',
      args: [],
    );
  }

  /// `It's still empty here`
  String get stillEmpty {
    return Intl.message(
      'It\'s still empty here',
      name: 'stillEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Download the models and they will appear here`
  String get downloadModelsAndWillAppear {
    return Intl.message(
      'Download the models and they will appear here',
      name: 'downloadModelsAndWillAppear',
      desc: '',
      args: [],
    );
  }

  /// `There will be platforms here, but so far it is empty`
  String get platformsWillBeHereButEmpty {
    return Intl.message(
      'There will be platforms here, but so far it is empty',
      name: 'platformsWillBeHereButEmpty',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while updating the data, please try again later`
  String get errorWhileUpdating {
    return Intl.message(
      'An error occurred while updating the data, please try again later',
      name: 'errorWhileUpdating',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactWithUs {
    return Intl.message(
      'Contact us',
      name: 'contactWithUs',
      desc: '',
      args: [],
    );
  }

  /// `Version: {version}`
  String version(Object version) {
    return Intl.message(
      'Version: $version',
      name: 'version',
      desc: '',
      args: [version],
    );
  }

  /// `Begin`
  String get begin {
    return Intl.message(
      'Begin',
      name: 'begin',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message(
      'Map',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Dates of the event`
  String get datesEvent {
    return Intl.message(
      'Dates of the event',
      name: 'datesEvent',
      desc: '',
      args: [],
    );
  }

  /// `Questionnaires`
  String get questionnaires {
    return Intl.message(
      'Questionnaires',
      name: 'questionnaires',
      desc: '',
      args: [],
    );
  }

  /// `Information about`
  String get informationAbout {
    return Intl.message(
      'Information about',
      name: 'informationAbout',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get news {
    return Intl.message(
      'News',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Useful links`
  String get usefulLinks {
    return Intl.message(
      'Useful links',
      name: 'usefulLinks',
      desc: '',
      args: [],
    );
  }

  /// `Link without title`
  String get linkWithoutTitle {
    return Intl.message(
      'Link without title',
      name: 'linkWithoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch {url}`
  String couldNotLaunchUrl(Object url) {
    return Intl.message(
      'Could not launch $url',
      name: 'couldNotLaunchUrl',
      desc: '',
      args: [url],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `{remain} questions`
  String remainQuestions(Object remain) {
    return Intl.message(
      '$remain questions',
      name: 'remainQuestions',
      desc: '',
      args: [remain],
    );
  }

  /// `{count, plural, =0{no questions} =1{question} =2{questions} few{questions} many{questions} other{questions}}`
  String questions(num count) {
    return Intl.plural(
      count,
      zero: 'no questions',
      one: 'question',
      two: 'questions',
      few: 'questions',
      many: 'questions',
      other: 'questions',
      name: 'questions',
      desc: '',
      args: [count],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Ок`
  String get ok {
    return Intl.message(
      'Ок',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Thanks! You have successfully completed the survey`
  String get successfullyCompletedSurvey {
    return Intl.message(
      'Thanks! You have successfully completed the survey',
      name: 'successfullyCompletedSurvey',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Enter the answer`
  String get enterAnswer {
    return Intl.message(
      'Enter the answer',
      name: 'enterAnswer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
