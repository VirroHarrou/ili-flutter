import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget{
  final List<String> imageUrls;
  final double height;
  final double maxScale;
  final PhotoViewComputedScale computedScale;
  final bool disableGestures;

  const ImageViewer({
    super.key,
    required this.imageUrls,
    this.height = 300,
    this.maxScale = 4,
    this.computedScale = PhotoViewComputedScale.contained,
    this.disableGestures = false,
  });

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
    return Stack(
      alignment: Alignment.bottomCenter,
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
                initialScale: widget.computedScale * 1,
                minScale: widget.computedScale * 1,
                disableGestures: widget.disableGestures,
                maxScale: widget.computedScale * widget.maxScale,
              );
            },
            itemCount: widget.imageUrls.length,
            pageController: pageController,
            onPageChanged: onPageChanged,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 40.0,
                height: 40.0,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
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
            ),
          )
        ],
      ],
    );
  }
}