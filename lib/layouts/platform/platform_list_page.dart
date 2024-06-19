import 'package:flutter/material.dart';
import 'package:tavrida_flutter/generated/l10n.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';
import 'package:tavrida_flutter/ui/failures/failure.dart';
import 'package:tavrida_flutter/ui/loading_state_widget.dart';

import 'platform_list_controller.dart';
import 'widgets/view.dart';

class PlatformListPage extends StatefulWidget {
  const PlatformListPage({super.key});

  @override
  State<PlatformListPage> createState() => _PlatformListPageState();
}

class _PlatformListPageState extends State<PlatformListPage> {
  final controller = PlatformListController();
  late ThemeData theme;
  Icon customIcon = const Icon(Icons.search, size: 32,);
  bool isSearching = false;

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(theme, context),
      body: PagedListView(
        pagingController: controller.pageController,
        builderDelegate: PagedChildBuilderDelegate<Platform>(
          itemBuilder: (context, item, index) => PlatformCard(platform: item),
          firstPageProgressIndicatorBuilder: (context) => buildLoading(context),
          firstPageErrorIndicatorBuilder: (context) => buildFailure(
            message: S.of(context).errorWhileUpdating,
          ),
          noItemsFoundIndicatorBuilder: (context) => EmptyContent(
            title: S.of(context).stillEmpty,
            message: S.of(context).platformsWillBeHereButEmpty,
          ),
        ),
      ),
    );
  }

  Widget buildFailure({required String message}) {
    return FailureContent(
      title: S.of(context).somethingWentWrong,
      message: message,
    );
  }

  AppBar _buildAppBar(ThemeData theme, BuildContext context) => AppBar(
    toolbarHeight: 66,
    titleSpacing: 24,
    automaticallyImplyLeading: false,
    backgroundColor: theme.colorScheme.background,
    title: !isSearching
        ? Text(S.of(context).platforms, style: AppTextStyles.titleH1)
        : TextField(
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          hintText: S.of(context).find,
          //Todo: hint style
          hintStyle: const TextStyle(
            color: Colors.black38,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: AppColors.lightGrey,
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          )
      ),
      //Todo: implement search
      onChanged: (query) {
          controller.filter = query.trim();
          controller.pageController.refresh();
        },
      style: AppTextStyles.body,
    ),
    actions: <Widget>[
      IconButton(
          onPressed: () {
            setState(() {
              if (!isSearching) {
                customIcon = const Icon(Icons.clear, size: 32,);
                isSearching = true;
              } else {
                customIcon = const Icon(Icons.search, size: 32,);
                isSearching = false;
                controller.filter = '';
                controller.pageController.refresh();
              }
            });
          },
          icon: customIcon
      ),
      const Icon(Icons.save_alt, color: Colors.transparent, size: 14,),
    ],
  );
}

