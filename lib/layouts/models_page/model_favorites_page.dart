import 'package:flutter/material.dart';
import 'package:tavrida_flutter/repositories/views/models.dart';

class ModelFavoritesPage extends StatefulWidget{
  ModelFavoritesPage({super.key});

  List<Model> models = <Model>[];

  @override
  State<StatefulWidget> createState() => _ModelFavoritesPageState();

}

class _ModelFavoritesPageState extends State<ModelFavoritesPage> {
  @override
  Widget build(BuildContext context) {
    var models = widget.models;
    var theme = Theme.of(context);
    ListView listView = ListView.builder(
      itemCount: models.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              var id = models[index].id;
              Navigator.pushNamed(context, "/ForumDetail",
                  arguments: {"id": id});
            },
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(7.5),
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: NetworkImage(
                        models[index].logoUrl as String),
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
                      "${models[index].title}",
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                  ]),
            ));
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.search),
          )
        ],
      ),
      body: listView,
    );
  }
}