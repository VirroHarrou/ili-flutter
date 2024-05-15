import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tavrida_flutter/layouts/platform/bloc/platform_list_bloc.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/DataEmpty.dart';
import 'package:tavrida_flutter/widgets/loading_state_widget.dart';

class PlatformListPage extends StatefulWidget {
  const PlatformListPage({super.key});

  @override
  State<PlatformListPage> createState() => _PlatformListPageState();
}

class _PlatformListPageState extends State<PlatformListPage> {
  final bloc = PlatformListBloc();
  late ThemeData theme;
  Icon customIcon = const Icon(Icons.search, size: 32,);
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    bloc.add(PlatformListUpdateEvent());
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: buildAppBar(theme, context),
      body: BlocBuilder<PlatformListBloc, PlatformListState>(
        bloc: bloc,
        builder: (context, state) {
          switch (state) {
            case PlatformListEmpty():
              return generateDataEmpty(context, 'Здесь появятся форумы, но пока здесь пусто');
            case PlatformListLoading():
              return buildLoading(context);
            case PlatformListLoaded():
              return buildLoadedList(state.platforms);
            case PlatformListFailure():
              return buildFailure(message: state.message,);
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget buildFailure({required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/something_went_wrong.svg', height: 200, fit: BoxFit.cover,),
            const SizedBox(height: 24,),
            const Text(
              'Упс! Что-то пошло не так...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadedList(List<Platform> platforms){
    return ListView.builder(
      itemCount: platforms.length,
      itemBuilder: (context, index) {
        DateTime startedAt = DateTime.parse(platforms[index].startedAt ?? '12122012');
        DateTime endedAt = DateTime.parse(platforms[index].endedAt ?? '12122012');
        return InkWell(
            onTap: () {
              var id = platforms[index].id;
              context.push('/ForumDetail', extra: id);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
              child: Container(
                height: 366,
                width:  366,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: FadeInImage.assetNetwork(
                          placeholder: "assets/no_results_found.png",
                          image: platforms[index].mediaUrls?.elementAtOrNull(0) ?? "").image,
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
                        "${platforms[index].title}",
                        style: theme.textTheme.titleMedium,
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
                            "${DateFormat('dd.MM.yyyy').format(startedAt)} "
                                "- ${DateFormat('dd.MM.yyyy').format(endedAt)}",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        maxLines: 4,
                        textAlign: TextAlign.start,
                        "${platforms[index].description}",
                        style: theme.textTheme.bodyMedium,
                      )
                    ]),
              ),
            ));
      },
    );
  }

  AppBar buildAppBar(ThemeData theme, BuildContext context) => AppBar(
    toolbarHeight: 66,
    titleSpacing: 24,
    automaticallyImplyLeading: false,
    backgroundColor: theme.colorScheme.background,
    title: !isSearching
        ? Text("Площадки", style: theme.textTheme.titleLarge)
        : TextField(
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          hintText: 'Найти...',
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
      onChanged: (query) => bloc.add(PlatformListSearchUpdateEvent(query: query)),
      style: theme.textTheme.bodySmall,
    ),
    actions: <Widget>[
      IconButton(
          onPressed: () {
            setState(() {
              if (!isSearching) {
                customIcon = const Icon(Icons.clear, size: 32,);
                isSearching = true;
                bloc.add(PlatformListUpdateEvent());
              } else {
                customIcon = const Icon(Icons.search, size: 32,);
                isSearching = false;
                bloc.add(PlatformListUpdateEvent());
              }
            });
          },
          icon: customIcon
      ),
      const Icon(Icons.save_alt, color: Colors.transparent, size: 14,),
    ],
  );
}