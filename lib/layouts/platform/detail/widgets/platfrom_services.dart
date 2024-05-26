import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'view.dart';

class PlatformServices extends StatefulWidget {
  final List<PlatformServicesModel> elements;

  const PlatformServices({
    super.key,
    required this.elements,
  });

  @override
  State<PlatformServices> createState() => _PlatformServicesState();
}

class _PlatformServicesState extends State<PlatformServices> {
  late List<PlatformServicesModel> selectedElements;
  Map<String, bool> unions = {'Всё':true};

  @override
  void initState() {
    super.initState();
    selectedElements = widget.elements;
    for(var el in widget.elements){
      if (el.union == null) continue;
      if (unions.containsKey(el.union)) continue;
      setState(() {
        unions.addAll({el.union!: false});
      });
    }
  }

  Future<void> selectedNew(String key) async {
    print(key);
    unions.forEach((key, value) {
      unions[key] = false;
    });
    unions[key] = true;
    if(key == 'Всё') {
      selectedElements = widget.elements;
      setState(() {});
      return;
    }
    selectedElements = [];
    for (var element in widget.elements) {
      if (element.union == key) selectedElements.add(element);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 212,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: unions.keys.length,
                padding: const EdgeInsets.only(left: 20, right: 12),
                itemBuilder: (context, i) {
                  var value = unions.keys.toList()[i];
                  var selected = unions.values.toList()[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () => selectedNew(unions.keys.toList()[i]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: selected ? AppColors.black : AppColors.white,
                          border: !selected ? Border.all(color: AppColors.black, width: 1) : null,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: selected ? AppColors.white : AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedElements.length,
                padding: const EdgeInsets.only(left: 20, right: 12),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => buildDialog(context, selectedElements[i]),
                      ),
                      child: Container(
                        width: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFECECED),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 48,
                                child: Image.network(selectedElements[i].logoUrl ?? '', fit: BoxFit.contain,)
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(selectedElements[i].title!.length >= 30 ?
                              '${selectedElements[i].title?.characters.take(30).string}...':
                              selectedElements[i].title!,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                maxLines: 3,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('${selectedElements[i].location}',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )
    );
  }

  Widget buildDialog(BuildContext context, PlatformServicesModel model){
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => context.pop(),
              shape: const CircleBorder(),
              backgroundColor: AppColors.white.withOpacity(0.6),
              child: const Icon(Icons.close, color: Colors.black,),
            ),
          ),
          const SizedBox(height: 12,),
          Container(
            width: 336,
            padding: const EdgeInsets.only(
              top: 36,
              right: 20,
              left: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  color: Color.fromRGBO(0, 0, 0, 0.12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: SizedBox(
                    height: 64,
                    child: Image.network(model.logoUrl ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    model.title ?? '',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Описание', style: theme.textTheme.labelMedium,)
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(model.description ?? '', style: theme.textTheme.bodySmall),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Расположение', style: theme.textTheme.labelMedium,)
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(model.location ?? '', style: theme.textTheme.bodySmall),
                ),
                if (!model.url.isEmptyOrNull) ... [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () async {
                            final Uri url = Uri.parse(model.url!);
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.link_outlined, color: Color(0xFF6EB3F2),),
                              const SizedBox(width: 4,),
                              Text(model.urlName ?? 'Полезная ссылка',
                                style: const TextStyle(
                                  color: Color(0xFF6EB3F2),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}