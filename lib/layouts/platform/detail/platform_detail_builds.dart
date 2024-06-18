part of 'platform_detail_page.dart';

extension _PlatformDetailBuilds on _PlatformDetailPageState {
  Widget buildTop(Platform platform) {
    return Column(
      children: [
        ImageViewer(
          imageUrls: platform.mediaUrls!,
          height: 350,
          maxScale: 1,
          computedScale: PhotoViewComputedScale.covered,
          disableGestures: true,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 5),
          child: Column(
            children: [
              //Title
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                  child: Text(
                    platform.title!,
                    style: AppTextStyles.titleH1,
                  ),
                ),
              ),
              //Main buttons
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 8,
                        child: AppTextButton.filled(
                          text: S.of(context).begin,
                          icon: const Icon(Icons.view_in_ar, color: Colors.white,),
                          onTap: () => context.push(Routes.qrScanner),
                        ),
                      ),
                      if (!platform.mapUrls.isEmptyOrNull) ...[
                        const Spacer(),
                        Expanded(
                          flex: 8,
                          child: AppTextButton.outlined(
                            text: S.of(context).map,
                            onTap: () => _onMapTapped(platform),
                            icon: const Icon(Icons.map_outlined, color: AppColors.black,),
                          ),
                        ),
                      ],
                    ],
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildDefaultBody(Platform platform) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, right: 20.0, left: 20.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(S.of(context).description, style: AppTextStyles.label,)
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Text(platform.description ?? '', style: AppTextStyles.body,),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5, right: 20.0, left: 20.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).datesEvent, style: AppTextStyles.label,)
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "${DateFormat.yMMMd().format(DateTime.parse(platform.startedAt!))} -"
                    " ${DateFormat.yMMMd().format(DateTime.parse(platform.endedAt!))}",
                style: AppTextStyles.body,
              ),
            )
        ),
      ],
    );
  }

  void _onMapTapped(Platform platform){
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: const Alignment(0.95, -0.97),
                      child: FloatingActionButton(
                        onPressed: () => context.pop(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                        backgroundColor: Colors.white.withOpacity(0.6),
                        hoverColor: Colors.white,
                        hoverElevation: 3,
                        child: const Icon(Icons.clear),
                      )
                  ),
                  const SizedBox(height: 12,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: ImageViewer(
                        height: MediaQuery.of(context).size.height * 0.65,
                        imageUrls: platform.mapUrls!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}