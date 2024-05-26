import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget{
  final List<String> imageUrls;
  final double height;

  const ImageViewer({super.key, required this.imageUrls, this.height = 300});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final pageController = PageController(initialPage: 0);
  int currentIndex = 0;


  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained * 1,
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.contained * 4,
              );
            },
            itemCount: widget.imageUrls.length,
            pageController: pageController,
            onPageChanged: onPageChanged,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : (event.cumulativeBytesLoaded / event.expectedTotalBytes!),
                ),
              ),
            ),
          ),
        ),
        if (widget.imageUrls.length >= 2) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widget.imageUrls.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == currentIndex 
                          ? Colors.black.withOpacity(0.8)
                          : Colors.black.withOpacity(0.4),
                    ),
                  ),
                )
              ],
            ],
          )
        ],
      ],
    );
  }
}