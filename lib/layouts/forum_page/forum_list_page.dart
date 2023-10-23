import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/forum/GetForums.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumsSearch.dart';

import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/CodeDialog.dart';

class ForumListPage extends StatefulWidget {
  const ForumListPage({super.key});

  @override
  State<ForumListPage> createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  Forums forums = Forums();

  late dynamic theme;
  Icon customIcon = const Icon(Icons.search, size: 32,);
  bool isSearching = false;

  Future<void> updateData(String? query) async {
    if (query == null) {
      forums = await getForumsAsync(10, 0);
    } else {
      forums = await getForumsSearchAsync(query);
    }
    setState(() {});
  }

  @override
  initState() {
    updateData(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    ListView listView = ListView.builder(
      itemCount: forums.forumList?.length ?? 0,
      itemBuilder: (context, index) {
        DateTime startedAt = DateTime.parse(forums.forumList?[index].startedAt ?? '12122012');
        DateTime endedAt = DateTime.parse(forums.forumList?[index].endedAt ?? '12122012');
        return InkWell(
            onTap: () {
              var id = forums.forumList?[index].id;
              Navigator.pushNamed(context, "/ForumDetail",
                  arguments: {"id": id});
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
                      image: NetworkImage(
                          forums.forumList?[index].imageUrls?.elementAtOrNull(0) ?? AppSettings.imageNotFoundUrl),
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
                        "${forums.forumList?[index].title}",
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
                        "${forums.forumList?[index].description}",
                        style: theme.textTheme.bodyMedium,
                      )
                    ]),
              ),
            ));
      },
    );

    var appBar = AppBar(
      toolbarHeight: 66,
      titleSpacing: 24,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.background,
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
            onChanged: (query) => updateData(query),
            style: theme.textTheme.bodySmall,
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
                  updateData(null);
                }
              });
            },
            icon: customIcon
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/QR");
            },
            icon: const Icon(Icons.qr_code_scanner, size: 32,)
        ),
        const Icon(Icons.save_alt, color: Colors.transparent, size: 14,),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
