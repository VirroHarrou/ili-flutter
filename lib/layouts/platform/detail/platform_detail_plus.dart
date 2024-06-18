part of 'platform_detail_page.dart';

extension _PlatformDetailPlus on _PlatformDetailPageState {
  Widget buildPlatformPlus(PlatformDetailLoadedPlusState state,
      BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTop(state.platform),
          if (state.questionnaires.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).questionnaires,
                  style: AppTextStyles.label,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: QuestionnaireWidget(questionnaires: state.questionnaires),
            ),
          ],
          buildDefaultBody(state.platform),
          if (state.platformServices.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).informationAbout,
                  style: AppTextStyles.label,
                ),
              ),
            ),
            PlatformServices(
              elements: state.platformServices,
              allKey: S.of(context).all,
            ),
          ],
          if (state.platformNews.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(S.of(context).news, style: AppTextStyles.label,),
              ),
            ),
            PlatformNews(elements: state.platformNews),
          ],
          if (state.platformLinks.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8, right: 20.0, left: 20.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(S.of(context).usefulLinks, style: AppTextStyles.label,)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 28.0 * state.platformLinks.length,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.platformLinks.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(state.platformLinks[index].url ?? 'http://empty/content/');
                        try {
                          await launchUrl(url);
                        } catch (ex) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).couldNotLaunchUrl(url)),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            debugPrint(ex.toString());
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(state.platformLinks[index].title ?? S.of(context).linkWithoutTitle,
                          style: const TextStyle(
                            color: Color(0xFF6EB3F2),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF6EB3F2),
                          ),

                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 32,),
        ],
      ),
    );
  }
}