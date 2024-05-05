import 'package:dart_extensions/dart_extensions.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/services/models/questionnaire.dart';
import 'package:tavrida_flutter/services/platform_service.dart';
import 'package:tavrida_flutter/services/questionnaire_service.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/ImagesCarousel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/view.dart';

class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final platformService = Injector.appInstance.get<PlatformService>();
  final questionnaireService = Injector.appInstance.get<QuestionnaireService>();
  Platform? platform;
  List<PlatformServicesModel> platformServices = [];
  List<PlatformNewsModel> platformNews = [];
  List<PlatformLinksModel> platformLinks = [];
  List<Questionnaire> questionnaires = [];
  List<QuestionController> controllers = [];
  bool isFirst = true;
  Map<dynamic, dynamic> arguments = <dynamic, dynamic>{};
  bool _showAdditionalInfo = true;

  void _toggleAdditionalInfo() {
    setState(() {
      _showAdditionalInfo = !_showAdditionalInfo;
    });
  }

  void setCountAnswers(Map<String, int> data){
    setState(() {
      questionnaires[questionnaires.indexWhere((element) => element.id == data.keys.first)]
          .answerCount = data.values.first;
    });
  }

  Future<void> updateData(String id) async {
    var platformNew = await platformService.getPlatformDetail(id: id);
    setState(() {
      platform = platformNew;
    });
    questionnaires = await questionnaireService.getQuestionnaireList(id: id) ?? [];
    for (var el in questionnaires) {
      if (context.mounted) {
        controllers.add(QuestionController(
          questionnaire: el,
          answersCountCallback: setCountAnswers,
      ));
      }
    }
    setState(() {});
    getPlatformElements(platform?.platformElements);
  }

  Future<void> getPlatformElements(List<dynamic> json) async {
    if (json.isEmptyOrNull) return;

    var jsonElement = json.firstOrNull;
    String type = jsonElement['type'] ?? '';
    json.removeAt(0);
    switch (type) {
      case 'PlatformNews':
        platformNews.add(PlatformNewsModel.fromJson(jsonElement));
        break;
      case 'PlatformService':
        platformServices.add(PlatformServicesModel.fromJson(jsonElement));
        break;
      case 'PlatformLink':
        platformLinks.add(PlatformLinksModel.fromJson(jsonElement));
        break;
      default:
        debugPrint('Platform element undetected: $jsonElement');
        break;
    }
    setState(() {});
    getPlatformElements(json);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    DateTime startedAt = DateTime.parse(platform?.startedAt ?? '12122012');
    DateTime endedAt = DateTime.parse(platform?.endedAt ?? '12122012');
    arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (isFirst) {
      updateData(arguments['id'] ?? '');
      isFirst = false;
    }
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 350,
                child: CarouselImages(
                    imageUrls: platform?.mediaUrls?.elementAtOrNull(0) == null
                        ? <String>[AppSettings.imageNotFoundUrl]
                        : platform!.mediaUrls!
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 26.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                          child: Text(
                              platform?.title ?? '',
                              style: theme.textTheme.titleLarge),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                      child: buildButtons(context),
                    ),
                    if (platform?.platformType == 2 && questionnaires.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 20.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Опросы', style: theme.textTheme.labelMedium,)
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          height: 105,
                          child: ListView.builder(
                            itemCount: questionnaires.length,
                            padding: const EdgeInsets.only(left: 20, right: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              var survey = questionnaires[i];
                              bool completed = survey.answerCount == survey.questionsCount;
                              return InkWell(
                                onTap: () {
                                  if (!completed) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => controllers[i].startQuestionnaire(context)
                                      );
                                    }
                                  },
                                child: Container(
                                  width: 115,
                                  height: 105,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: completed ?
                                        AppColors.black : const Color(0xFFECECED),
                                    boxShadow: !completed ? [
                                      const BoxShadow(
                                        color: Color.fromRGBO(51, 51, 51, 0.15),
                                        offset: Offset(3, 4),
                                        blurRadius: 4,
                                      ),
                                    ] : [],
                                    border: !completed ? Border.all(color: const Color.fromRGBO(51, 51, 51, 0.1))
                                    : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(survey.title!.length <= 50 ? survey.title!
                                        :'${survey.title?.characters.take(30).string}...',
                                        style: TextStyle(
                                          color: completed ? AppColors.white : AppColors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        maxLines: 3,
                                      ),
                                      Text(completed ? 'Пройден'
                                      : '${(survey.questionsCount - survey.answerCount)} вопросов',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: completed ? AppColors.white.withOpacity(0.8) :
                                        AppColors.black.withOpacity(0.8),
                                      ),),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,)
                    ],
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, right: 20.0, left: 20.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Описание', style: theme.textTheme.labelMedium,)
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                          child: Text(platform?.description ?? '', style: theme.textTheme.bodySmall),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 5, right: 20.0, left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Даты проведения', style: theme.textTheme.labelMedium,)
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                              "${DateFormat('dd.MM.yyyy').format(startedAt)} -"
                                  " ${DateFormat('dd.MM.yyyy').format(endedAt)}",
                              style: theme.textTheme.bodySmall),
                        )
                    ),
                    if (platform?.platformType == 2 && platformServices.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Информация об', style: theme.textTheme.labelMedium,)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PlatformServices(elements: platformServices),
                      ),
                    ],
                    if (platform?.platformType == 2 && platformNews.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Новости', style: theme.textTheme.labelMedium,)
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PlatformNews(elements: platformNews),
                      ),
                    ],
                    if (platform?.platformType == 2 && platformLinks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8, right: 20.0, left: 20.0),
                        child: InkWell(
                          onTap: _toggleAdditionalInfo,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Полезные ссылки', style: theme.textTheme.labelMedium,)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Visibility(
                          visible: _showAdditionalInfo,
                          child: SizedBox(
                            height: 28.0 * platformLinks.length,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: platformLinks.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    final Uri url = Uri.parse(platformLinks[index].url ?? '');
                                    if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(platformLinks[index].title ?? 'Ссылка без названия',
                                      style: const TextStyle(
                                        color: Color(0xFF6EB3F2),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFF6EB3F2),
                                      ),

                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
        hoverColor: const Color.fromRGBO(255, 255, 255, 0.4),
        hoverElevation: 0,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/QR");
                },
                padding: EdgeInsets.zero,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Container(
                        width: 24,
                        height: 24,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: const Icon(Icons.view_in_ar_outlined, color: Colors.white,),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Начать',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0.09,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )
            ),
          ),
          if (platform != null && !platform!.mapUrls.isEmptyOrNull) ...[
            const Spacer(),
            Expanded(
              flex: 7,
              child: MaterialButton(
                  onPressed: onMapTapped,
                  padding: EdgeInsets.zero,
                  child:Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF333333)),
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: const Icon(Icons.map_outlined, color: Colors.black87,)
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Карта',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ],
      ),
    );
  }

  void onMapTapped(){
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: const Alignment(0.95, -0.97),
                    child: FloatingActionButton(
                      onPressed: () => Navigator.pop(context),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                      backgroundColor: Colors.white.withOpacity(0.6),
                      hoverColor: Colors.white,
                      hoverElevation: 3,
                      child: const Icon(Icons.clear),
                    )
                ),
                const SizedBox(height: 12,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: ImageViewer(
                      imageUrls: platform?.mapUrls ?? [''],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

