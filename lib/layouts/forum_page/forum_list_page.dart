import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tavrida_flutter/repositories/forum/GetForums.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumsSearch.dart';

import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/widgets/CodeDialog.dart';

class ForumListPage extends StatefulWidget {
  const ForumListPage({super.key});

  @override
  State<ForumListPage> createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  Forums forums = Forums();

  late dynamic theme;
  Icon customIcon = const Icon(Icons.search);
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
      padding: const EdgeInsets.all(8),
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
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(7.5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: NetworkImage(
                          forums.forumList?[index].logoUrl as String),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.dstATop)),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        "${forums.forumList?[index].title}",
                        style: theme.textTheme.titleMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Text(
                          "${DateFormat('dd.MM.yyyy').format(startedAt)} "
                          "- ${DateFormat('dd.MM.yyyy').format(endedAt)}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        textAlign: TextAlign.start,
                        "${forums.forumList?[index].description.characters.take(180)}...",
                        style: theme.textTheme.bodyMedium,
                      )
                    ]),
              ),
            ));
      },
    );

    var appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: !isSearching
          ? Text("Площадки", style: theme.textTheme.titleLarge)
          : ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  hintText: 'Найти...',
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (query) => updateData(query),
                style: theme.textTheme.titleLarge,
              ),
            ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            showDialog(context: context, builder: (context){
              return const CodeDialog();
            });
          },
          icon: const Icon(Icons.download_outlined),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                if (!isSearching) {
                  customIcon = const Icon(Icons.cancel);
                  isSearching = true;
                } else {
                  customIcon = const Icon(Icons.search);
                  isSearching = false;
                  updateData(null);
                }
              });
            },
            icon: customIcon),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
