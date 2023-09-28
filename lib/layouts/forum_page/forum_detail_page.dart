import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tavrida_flutter/main.dart';
import 'package:tavrida_flutter/repositories/forum/AddForumHistory.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumDetail.dart';
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
  Map<dynamic, dynamic> arguments = <dynamic, dynamic>{};

  Future<void> updateData(String id) async {
    forum = await getForumDetailAsync(id);
    addForumHistoryAsync(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = <String>[];
    imageUrls.add(forum?.logoUrl ?? '');
    imageUrls.addAll(forum?.imageUrls ?? <String>[]);
    var theme = Theme.of(context);
    DateTime startedAt = DateTime.parse(forum?.startedAt ?? '12122012');
    DateTime endedAt = DateTime.parse(forum?.endedAt ?? '12122012');
    arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    updateData(arguments['id'] ?? '');
    return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 350,
              child: CarouselImages(
                  imageUrls: imageUrls.first == ''
                      ? <String>[]
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, "/QR");
                            },
                            icon: const Icon(Icons.view_in_ar, color: AppColors.white,),
                            label: Text('Начать', style: theme.textTheme.headlineMedium),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppColors.buttonPrimary),
                              fixedSize: MaterialStateProperty.all(const Size(175, 45)),

                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.map_outlined, color: AppColors.black,),
                          label: Text('Карта', style: theme.textTheme.headlineLarge),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppColors.buttonSecondary),
                              fixedSize: MaterialStateProperty.all(const Size(175, 45))
                          ),
                        )
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
                          style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
          ],
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
}
