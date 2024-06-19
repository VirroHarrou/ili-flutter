part of '../model_list_page.dart';

final info = Injector.appInstance.get<PackageInfo>();

AppBar generateAppBar(BuildContext context) {
  final theme = Theme.of(context);
  return AppBar(
    toolbarHeight: 66,
    centerTitle: false,
    backgroundColor: theme.colorScheme.background,
    title: Text(S.of(context).favorites, style: AppTextStyles.titleH1),
    titleSpacing: 20,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 0),
        child: SubmenuButton(
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
                leading: const Icon(Icons.link),
                title: Text(S.of(context).privacyPolicy, style: AppTextStyles.body),
                onTap: () async {
                  final Uri url = Uri.parse('https://ili-art.space/policy.html');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_support,),
                title: Text(S.of(context).contactWithUs, style: AppTextStyles.body),
                onTap: () async {
                  final Uri url = Uri.parse('https://t.me/mahad_structura');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(S.of(context).version(info.version),
                    style:  const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ],
            child: const Icon(Icons.more_horiz, color: AppColors.black,)
        ),
      )
    ],
  );
}