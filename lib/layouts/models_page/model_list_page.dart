import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tavrida_flutter/repositories/models/GetModel.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/DataEmpty.dart';

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
    setState(() {
      models = [];
    });
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
    await _findLoadingModels();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        centerTitle: false,
        backgroundColor: theme.colorScheme.background,
        title: Text("Сохраненные модели", style: theme.textTheme.titleLarge),
        titleSpacing: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 16),
        child: models.isNotEmpty ? ListView.separated(
            itemBuilder: (context, i) {
              final model = models[i];
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
                          child: FloatingActionButton(
                            elevation: 0,
                            shape: const CircleBorder(),
                            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
                            enableFeedback: false,
                            onPressed: () => _deleteModelFile('${model.id}.glb'),
                            child: const Icon(Icons.delete_forever_rounded,
                              size: 32,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            separatorBuilder: (context, iterator) => const SizedBox(height: 16,),
            itemCount: models.length,
        ) : generateDataEmpty(context, 'Скачивайте модели, и они появятся здесь'),
      ),
    );
  }
}