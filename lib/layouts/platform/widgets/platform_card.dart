import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';

class PlatformCard extends StatelessWidget {
  const PlatformCard({
    super.key,
    required this.platform,
  });

  final Platform platform;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
        onTap: () {
          context.push(Routes.platform, extra: platform);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
          child: Container(
            height: 366,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: FadeInImage.assetNetwork(
                      placeholder: "assets/no_results_found.png",
                      image: platform.mediaUrls?.elementAtOrNull(0) ?? "").image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop)),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: const [BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.left,
                    "${platform.title}",
                    style: AppTextStyles.titleH1White,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      child: Text(
                        "${DateFormat.yMd().format(DateTime.parse(platform.startedAt!))} "
                            "- ${DateFormat.yMd().format(DateTime.parse(platform.endedAt!))}",
                        style: AppTextStyles.body,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    maxLines: 4,
                    textAlign: TextAlign.start,
                    "${platform.description}",
                    style: AppTextStyles.bodyWhite,
                  )
                ]),
          ),
        ));
  }
}