import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavrida_flutter/main.dart';
import 'package:tavrida_flutter/repositories/Settings.dart';
import 'package:tavrida_flutter/repositories/forum/GetForumHistory.dart';
import 'package:tavrida_flutter/repositories/user/user_repository.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/DataEmpty.dart';
import 'package:tavrida_flutter/widgets/NotAvailable.dart';

class ProfilePage extends StatefulWidget{
  ProfilePage({super.key});

  List<Forum> forums = [];

  @override
  State<StatefulWidget> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{

  Future<void> updateData() async {
    getForumHistoryAsync().then((value)  {
      widget.forums = value?.forumList ?? [];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  showExitDialog(BuildContext context) {
    var theme = Theme.of(context);
    // set up the buttons
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(94, 38)),
        backgroundColor: MaterialStateProperty.all(const Color(0xFFF2F2F2)),
      ),
      onPressed:  () {
        Navigator.of(context).pop();
      },
      child: Text("Отмена", style: theme.textTheme.bodySmall,),
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(84, 38)),
        backgroundColor: MaterialStateProperty.all(AppColors.red),
      ),
      onPressed:  () {
        final storage = SharedPreferences.getInstance().then((value) {
          value.remove('authUserToken');
          value.remove('isLogin');
          value.remove('isNoName');
          value.remove('userEmail');
          Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
        });
      },
      child: Text("Выйти", style: theme.textTheme.bodyMedium),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.white,
      title: Text("Выход", style: theme.textTheme.headlineLarge,),
      content: Text("Вы уверены, что хотите выйти из аккаунта ${User.email}?",
        style: theme.textTheme.bodySmall,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteDialog(BuildContext context){
    var theme = Theme.of(context);
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(94, 38)),
        backgroundColor: MaterialStateProperty.all(const Color(0xFFF2F2F2)),
      ),
      onPressed:  () {
        Navigator.of(context).pop();
      },
      child: Text("Отмена", style: theme.textTheme.bodySmall,),
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.red),
      ),
      onPressed:  () {
        final storage = SharedPreferences.getInstance().then((value) {
          value.remove('authUserToken');
          value.remove('isLogin');
          value.remove('userEmail');
          tryDeleteUser();
          Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
        });
      },
      child: Text("Удалить", style: theme.textTheme.bodyMedium),
    );

    AlertDialog alert = AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.white,
      title: Text("Удалить аккаунт?", style: theme.textTheme.headlineLarge,),
      content: Text("Вы уверены, что хотите удалить аккаунт ${User.email}?",
        style: theme.textTheme.bodySmall,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appBar = AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 66,
        titleSpacing: 24,
        title: Text('История посещений', style: theme.textTheme.titleLarge,),
        actions: [
          !AppSettings.isNoName ?
          SubmenuButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(30, 30)),
            ),
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(30),
                shadowColor: MaterialStateProperty.all(Colors.black),
                surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
              ),
              menuChildren: [
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text("Выйти из аккаунта", style: theme.textTheme.bodySmall),
                  onTap: () {
                    showExitDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.red,),
                  title: Text("Удалить аккаунт", style: theme.textTheme.headlineSmall),
                  onTap: () {
                    showDeleteDialog(context);
                  },
                )
              ],
              child: const Icon(Icons.more_vert, color: AppColors.black,)
          ) : const Icon(Icons.no_adult_content, color: Colors.transparent),
        ],
      );
    ListView listView = ListView.builder(
              itemCount: widget.forums.length ?? 0,
              itemBuilder: (context, index) {
                DateTime startedAt = DateTime.parse(widget.forums[index].startedAt ?? '12122012');
                DateTime endedAt = DateTime.parse(widget.forums[index].endedAt ?? '12122012');
                var inkWell = InkWell(
                    onTap: () {
                      var id = widget.forums[index].id;
                      Navigator.pushNamed(context, "/ForumDetail",
                          arguments: {"id": id});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
                      child: Container(
                        height: 366,
                        width: 366,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.forums[index].logoUrl),
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
                                widget.forums[index].title,
                                style: theme.textTheme.titleMedium,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
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
                                "${widget.forums[index].description}...",
                                style: theme.textTheme.bodyMedium,
                              )
                            ]
                        ),
                      ),
                    )
                );
                return inkWell;
              },
            );
    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: AppSettings.isLogin && !AppSettings.isNoName
                ? widget.forums.isNotEmpty
                  ? listView
                  : generateDataEmpty(context, "Участвуйте в различных событиях, а мы\nсохраним историю ваших посещений")
                : generateNotAvailable(context),
          ),
        ],
      )
    );
  }

}