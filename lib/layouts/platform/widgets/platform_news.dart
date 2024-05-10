import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../themes/app_colors.dart';
import 'view.dart';

class PlatformNews extends StatefulWidget {
  final List<PlatformNewsModel> elements;

  const PlatformNews({
    super.key,
    required this.elements,
  });

  @override
  State<PlatformNews> createState() => _PlatformNewsState();
}



class _PlatformNewsState extends State<PlatformNews> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20, right: 12),
        itemCount: widget.elements.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () async {
                final Uri url = Uri.parse(widget.elements[i].url ?? '');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Container(
                width: 115,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.black,
                  image: DecorationImage(
                    image: Image.network(widget.elements[i].logoUrl ?? '').image,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.srcATop),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.elements[i].title ?? 'Описание для новости пропало',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Подробнее ->',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.white,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
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
    );

  }
}