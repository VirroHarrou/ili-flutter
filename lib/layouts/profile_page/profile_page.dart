import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumHistory.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class ProfilePage extends StatefulWidget{
  ProfilePage({super.key});

  Forums? forumsHistory;

  @override
  State<StatefulWidget> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{

  Future<void> updateData() async {
    widget.forumsHistory = await getForumHistoryAsync();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appBar = AppBar(
        automaticallyImplyLeading: false,
        title: Text('Аккаунт', style: theme.textTheme.titleLarge,),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/");
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              )
          ),
        ],
      );
    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: const CircleAvatar(
                radius: 20,
                  backgroundColor: Color(0xffc6c6c6),
                  child: Icon(
                      Icons.person_2,
                      color: AppColors.black,
                    ),
                  ),
              title: Text(User.email ?? '',
                  style: theme.textTheme.titleLarge)
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.forumsHistory?.forumList?.length ?? 0,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                DateTime startedAt = DateTime.parse(widget.forumsHistory?.forumList?[index].startedAt ?? '12122012');
                DateTime endedAt = DateTime.parse(widget.forumsHistory?.forumList?[index].endedAt ?? '12122012');
                var inkWell = InkWell(
                    onTap: () {
                      var id = widget.forumsHistory?.forumList?[index].id;
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
                                  widget.forumsHistory?.forumList?[index].logoUrl as String),
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
                                "${widget.forumsHistory?.forumList?[index].title}",
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
                                "${widget.forumsHistory?.forumList?[index].description.substring(0, 180)}...",
                                style: theme.textTheme.bodyMedium,
                              )
                            ]
                        ),
                      ),
                    )
                );
                return inkWell;
              },
            ),
          ),
        ],
      )

    );
  }

}