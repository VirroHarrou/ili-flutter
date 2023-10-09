import 'package:flutter/material.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class CarouselImages extends StatefulWidget{
  const CarouselImages({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<StatefulWidget> createState() =>
      _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
           itemCount: widget.imageUrls.length,
           pageSnapping: true,
           itemBuilder: (context, index){
             return Container(
               decoration: BoxDecoration(
                 image: DecorationImage(
                     fit:BoxFit.cover,
                     image: NetworkImage(widget.imageUrls[index]),
                     colorFilter: ColorFilter.mode(
                       Colors.black.withOpacity(0.2),
                       BlendMode.multiply,
                     )
                 ),
                 gradient: const LinearGradient(
                   begin: Alignment(0.00, 1.00),
                   end: Alignment(0, -1),
                   colors: [Colors.black, Colors.transparent],
                 ),
               ),
             );
           },
           onPageChanged: (index){
             setState(() {
               _currentIndex = index;
             });
           },
         ),
        Align(
          alignment: const Alignment(0.0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.map((item) {
              int index = widget.imageUrls.indexOf(item);
              return Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:  _currentIndex == index
                      ? const Color.fromRGBO(255, 255, 255, 0.8)
                      : const Color.fromRGBO(255, 255, 255, 0.3),
                ),
              );
            }
            ).toList(),
          ),
        )
      ],
    );
  }
}