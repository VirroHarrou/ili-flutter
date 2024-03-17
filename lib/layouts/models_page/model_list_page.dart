import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';

import '../../repositories/views/models.dart';

class ModelListPage extends StatefulWidget{
  const ModelListPage({super.key});

  @override
  State<StatefulWidget> createState() => ModelListPageState();
}

class ModelListPageState extends State<ModelListPage> {
  late final theme = Theme.of(context);
  List<Model> models = [];

  @override
  void initState() {
    super.initState();
    _findLoadingModels();
  }

  Future<void> _findLoadingModels() async {
    models = [];
    var dir = await getApplicationDocumentsDirectory();
    var ids = <String>[];
    await dir.list().forEach((element) {
      ids.add(element.path.split('/').last.toString());
    });
    _getListModel(ids);
  }

  Future<void> _getListModel(List<String> ids) async {
    for (var element in ids) {
      final model = await getModelAsync(null, element.split('.').first);
      if (model != null) {
        setState(() {
         models.add(model);
        });
      }
    }
  }

  Future<void> _deleteModelFile(String filename) async {
    var dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.delete();
    _findLoadingModels();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        centerTitle: true,
        backgroundColor: theme.colorScheme.background,
        title: Text("Сохраненные модели", style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
            itemBuilder: (context, iterator) {
              final model = models[iterator];
              return InkWell(
                onTap: () => Navigator.pushNamed(context, '/Load', arguments: model),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 360,
                    width: 360,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              model.logoUrl!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.multiply)),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: const Alignment(-0.00, 1.00),
                        end: const Alignment(0, -1),
                        colors: [Colors.black, Colors.black.withOpacity(0.7781251072883606), Colors.black.withOpacity(0.6567537784576416), Colors.black.withOpacity(0)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(model.title ?? '', style: theme.textTheme.titleMedium,),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            iconSize: 40,
                            color: Colors.black,
                            onPressed: () => _deleteModelFile('${model.id}.glb'),
                            icon: const Icon(Icons.playlist_remove, color: Colors.white,)
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            separatorBuilder: (context, iterator) => const SizedBox(height: 16,),
            itemCount: models.length,
        ),
      ),
    );
  }
}