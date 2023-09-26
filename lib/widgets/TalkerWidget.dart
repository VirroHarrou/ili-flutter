import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class TalkerWidget extends StatefulWidget{
  TalkerWidget({super.key, this.text, this.icon, required this.wight, required this.height, this.duration = 5});

  Icon? icon;
  String? text;
  double wight = 0;
  double height = 0;
  int duration;

  @override
  State<StatefulWidget> createState() => _TalkerWidgetState();
}

class _TalkerWidgetState extends State<TalkerWidget> {
  _TalkerWidgetState();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: widget.duration), () {
      setState(() {
        widget.wight = 0;
        widget.height = 0;
      });
    });
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: widget.height,
      width: widget.wight,
      decoration: const BoxDecoration(
          color: AppColors.lightWhite,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.icon,
          ),
          Text(widget.text ?? '', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}