import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tavrida_flutter/main.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/forum/AddForumHistory.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumDetail.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';
import 'package:tavrida_flutter/repositories/models/GetModelList.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/ImagesCarousel.dart';

class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  Forum? forum;
  Model? model;
  bool isFirst = true;
  Map<dynamic, dynamic> arguments = <dynamic, dynamic>{};

  Future<void> updateData(String id) async {
    forum = await getForumDetailAsync(id);
    addForumHistoryAsync(id);
    setState(() {});
    String? idModel;
    getModelListAsync(id).then((modelListModel) async {
      idModel = modelListModel?.models?.first.id;
      if (idModel == null) return;
      model = await getModelAsync(null, idModel);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = <String>[];
    imageUrls.addAll(forum?.imageUrls ?? <String>[]);
    var theme = Theme.of(context);
    DateTime startedAt = DateTime.parse(forum?.startedAt ?? '12122012');
    DateTime endedAt = DateTime.parse(forum?.endedAt ?? '12122012');
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
                    imageUrls: imageUrls.elementAtOrNull(0) == null
                        ? <String>[AppSettings.imageNotFoundUrl]
                        : imageUrls
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            forum?.title ?? '',
                            style: theme.textTheme.titleLarge)
                    ),
                    Padding(
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
                                    const Spacer(),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Описание', style: theme.textTheme.labelMedium,)
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(forum?.description ?? '', style: theme.textTheme.bodySmall)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Даты проведения', style: theme.textTheme.labelMedium,)
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "${DateFormat('dd.MM.yyyy').format(startedAt)} -"
                                " ${DateFormat('dd.MM.yyyy').format(endedAt)}",
                            style: theme.textTheme.bodySmall)
                    ),
                    if (model == null) const Center() else Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/ar_page", arguments: model);
                        },
                        child: Container(
                          height: 70,
                          decoration: ShapeDecoration(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF333333)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.view_in_ar, color: Colors.black87, size: 32,)
                              ),
                              Text("Тестовая 3D-модель", style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Open Sans",
                              )),
                            ],
                          ),
                        )
                      ),
                    ),
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

  void onMapTapped(){
    //Todo: подправить логику в части errorDialog
    var errorDialog = Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 600,
        width: 350,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 600,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/no_results_found_icon.svg", height: 128),
                      Text("Изображение отсутсвует", style: Theme.of(context).textTheme.headlineLarge),
                    ]
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.95, -0.97),
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                backgroundColor: Colors.white,
                hoverColor: Colors.white,
                hoverElevation: 3,
                child: const Icon(Icons.clear),
              )
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (_) {
        final urls = forum?.mapUrls as List<String>;
        if(urls.isEmpty){
          return errorDialog;
        }
        var imageUrl = forum?.mapUrls?.first;
        var image = Image.network(imageUrl ?? '', errorBuilder: (context, exc, _) {
          return errorDialog;
        },);
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 600,
            width: 350,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 600,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white,
                    ),
                    child: image,
                  ),),
                Align(
                    alignment: const Alignment(0.95, -0.97),
                    child: FloatingActionButton(
                      onPressed: () => Navigator.pop(context),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                      backgroundColor: Colors.white,
                      hoverColor: Colors.white,
                      hoverElevation: 3,
                      child: const Icon(Icons.clear),
                    )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
