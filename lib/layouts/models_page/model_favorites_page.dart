import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tavrida_flutter/repositories/models/GetModelFavorites.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';

class ModelFavoritesPage extends StatefulWidget{
  const ModelFavoritesPage({super.key});

  @override
  State<StatefulWidget> createState() => _ModelFavoritesPageState();
}

class _ModelFavoritesPageState extends State<ModelFavoritesPage> {

  bool isSearching = false;
  List<Model> models = <Model>[];
  Icon customIcon = const Icon(Icons.search);

  @override
  void initState() {
    super.initState();
    _updateData(null);
  }

  void _updateData(String? search){
    var response = getModelFavoritesAsync(search);
    response.then((value) {
      setState(() {
        models = value?.modelList ?? <Model>[];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: !isSearching
          ? Text("Избранное", style: theme.textTheme.titleLarge)
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
              onChanged: (query) => _updateData(query),
              style: theme.textTheme.titleLarge,
            ),
          ),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              setState(() {
                if (!isSearching) {
                  customIcon = const Icon(Icons.cancel);
                  isSearching = true;
                } else {
                  customIcon = const Icon(Icons.search);
                  isSearching = false;
                  _updateData(null);
                }
              });
            },
            icon: customIcon),
      ],
    );
    ListView listView = ListView.separated(
      itemCount: models.length,
      padding: const EdgeInsets.all(8),
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 6,
            right: 6,
            bottom: 10,
          ),
          child: Container(
            height: 1,
            color: const Color(0xAAcccccc),
          ),
        );
      },
      itemBuilder: (context, index) {
        var model = models[index];
        DateTime startedAt = DateTime.parse(model.startedAt!);
        DateTime endedAt = DateTime.parse(model.endedAt!);
        return InkWell(
          highlightColor: Colors.white,
            onTap: () {
              Navigator.pushNamed(context, "/ar_page", arguments: model);
            },
            child: Card(
              color: AppColors.white,
              elevation: 0,
              child: Column(
                children: [
                  Row(
                    children:[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(model.forumLogoUrl!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text(model.forumTitle!, style: theme.textTheme.headlineLarge),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${DateFormat('dd.MM.yyyy').format(startedAt)} -'
                                  ' ${DateFormat('dd.MM.yyyy').format(endedAt)}',
                              style: theme.textTheme.labelMedium,),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(7.5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          image: NetworkImage(
                              model.logoUrl as String),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop)),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(model.title ?? '', style: theme.textTheme.titleMedium),
                        ),
                        Align(
                          alignment: const Alignment(0.95, -0.9),
                          child: FloatingActionButton(
                            onPressed: (){
                              setState(() {
                                if(model.like!){
                                  model.like = false;
                                } else{
                                  model.like = true;
                                }
                              });
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
                            hoverColor: const Color.fromRGBO(255, 255, 255, 0.4),
                            hoverElevation: 0,
                            child: model.like ?? true
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border_sharp),
                          )
                        )
                      ],
                    )
                  ),
                ],
              ),
            )
        );
      },
    );
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}