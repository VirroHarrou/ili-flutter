import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/services/models/model.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';

class ModelWidget extends StatefulWidget {
  final Model model;
  final VoidCallback onDelete;


  const ModelWidget({super.key, required this.model, required this.onDelete});

  @override
  State<ModelWidget> createState() => _ModelWidgetState();
}

class _ModelWidgetState extends State<ModelWidget> {
  double deleteMarkerSize = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () => context.push(Routes.loadingPage, extra: widget.model),
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 1 && deleteMarkerSize > 100){
            widget.onDelete();
          }
          if(deleteMarkerSize < 200) {
            setState(() {
              deleteMarkerSize = 0;
            });
          }
        },
        onHorizontalDragUpdate: (details) {
          setState(() {
            if (details.delta.dx > 0 || deleteMarkerSize != 0) {
              deleteMarkerSize = details.localPosition.distance / 4;
            }
          });
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: deleteMarkerSize,
                color: Colors.deepOrange,
                height: 130,
                child: Center(
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: AlwaysStoppedAnimation<double>(deleteMarkerSize/125),
                    size: 32,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.only(top: 16.0, right: 30.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.model.logoUrl!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.amber.withOpacity(1),
                          BlendMode.dstOver,
                        ),
                      ),
                      color: Colors.amber,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.black.withOpacity(0.5),
                            offset: const Offset(0,4),
                            blurRadius: 4,
                            spreadRadius: 0
                        )
                      ]
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 6,
                            left: 12.0,
                            top: 6,
                            right: 12,
                          ),
                          decoration: const BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  topRight: Radius.circular(24)
                              )
                          ),
                          child: Text(widget.model.title ?? '', style: AppTextStyles.titleH2White,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}