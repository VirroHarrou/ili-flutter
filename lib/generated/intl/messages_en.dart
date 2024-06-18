// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(url) => "Could not launch ${url}";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'no questions', one: 'question', two: 'questions', few: 'questions', many: 'questions', other: 'questions')}";

  static String m2(remain) => "${remain} questions";

  static String m3(version) => "Version: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "arWarningMessage": MessageLookupByLibrary.simpleMessage(
            "If you are under 18, use the app in the presence of your parents. Keep an eye on your surroundings, AR can distort objects."),
        "begin": MessageLookupByLibrary.simpleMessage("Begin"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "complete": MessageLookupByLibrary.simpleMessage("Complete"),
        "contactWithUs": MessageLookupByLibrary.simpleMessage("Contact us"),
        "couldNotLaunchUrl": m0,
        "datesEvent":
            MessageLookupByLibrary.simpleMessage("Dates of the event"),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "downloadModelsAndWillAppear": MessageLookupByLibrary.simpleMessage(
            "Download the models and they will appear here"),
        "enterAnswer": MessageLookupByLibrary.simpleMessage("Enter the answer"),
        "enterModelCode":
            MessageLookupByLibrary.simpleMessage("Enter the model code"),
        "errorModelData":
            MessageLookupByLibrary.simpleMessage("An error in the model data"),
        "errorWhileUpdating": MessageLookupByLibrary.simpleMessage(
            "An error occurred while updating the data, please try again later"),
        "exit": MessageLookupByLibrary.simpleMessage("Quit"),
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "find": MessageLookupByLibrary.simpleMessage("Find..."),
        "homePage": MessageLookupByLibrary.simpleMessage("Main"),
        "informationAbout":
            MessageLookupByLibrary.simpleMessage("Information about"),
        "linkWithoutTitle":
            MessageLookupByLibrary.simpleMessage("Link without title"),
        "loadModel":
            MessageLookupByLibrary.simpleMessage("Uploading a 3D model..."),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "map": MessageLookupByLibrary.simpleMessage("Map"),
        "modelLinkNotCorrect": MessageLookupByLibrary.simpleMessage(
            "The link to the model is not correct for your mobile platform"),
        "news": MessageLookupByLibrary.simpleMessage("News"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "ok": MessageLookupByLibrary.simpleMessage("Ок"),
        "platforms": MessageLookupByLibrary.simpleMessage("Platforms"),
        "platformsWillBeHereButEmpty": MessageLookupByLibrary.simpleMessage(
            "There will be platforms here, but so far it is empty"),
        "pointCameraAtQR": MessageLookupByLibrary.simpleMessage(
            "Point the camera at the QR code"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "questionnaires":
            MessageLookupByLibrary.simpleMessage("Questionnaires"),
        "questions": m1,
        "remainQuestions": m2,
        "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
            "Oops! Something went wrong..."),
        "stillEmpty":
            MessageLookupByLibrary.simpleMessage("It\'s still empty here"),
        "successfullyCompletedSurvey": MessageLookupByLibrary.simpleMessage(
            "Thanks! You have successfully completed the survey"),
        "usefulLinks": MessageLookupByLibrary.simpleMessage("Useful links"),
        "version": m3
      };
}
