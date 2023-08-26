import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumDetail.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/BottomNavigationBase.dart';
import '../../repositories/models/models.dart';

class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  Forum? forum;
  Map<dynamic, dynamic> arguments = <dynamic, dynamic>{};

  Future<void> updateData(String id) async {
    forum = await getForumDetailAsync(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    updateData(arguments['id'] ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          forum?.title ?? 'null',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forum?.imageUrls?.length ?? 0,
                itemBuilder: (context, index) {
                  return Image(
                    image: NetworkImage(forum?.imageUrls?[index] ?? ''),
                    height: 300,
                  );
                }
              ),
            ),
            Stack(
              children: [
                Text(forum?.title ?? ''),
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.ac_unit),
                    label: Text('Войти', style: theme.textTheme.titleMedium,),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
