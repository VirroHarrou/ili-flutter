import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injector/injector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tavrida_flutter/layouts/models_page/bloc/model_list_bloc.dart';
import 'package:tavrida_flutter/services/models/model.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/widgets/DataEmpty.dart';
import 'package:tavrida_flutter/widgets/loading_state_widget.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/app_bar.dart';

class ModelListPage extends StatefulWidget{
  const ModelListPage({super.key});

  @override
  State<StatefulWidget> createState() => ModelListPageState();
}

class ModelListPageState extends State<ModelListPage> {
  final bloc = ModelListBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(ModelListInitEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: BlocBuilder<ModelListBloc, ModelListState>(
        builder: (BuildContext context, ModelListState state) {
          switch (state) {
            case ModelListLoadingState():
              return buildLoading(context);
            case ModelListLoadedState():
              return buildLoaded(context, state.models);
            case ModelListInitState():
              return Container();
            case ModelListFailureState():
              return Container(color: AppColors.red,);
            case ModelListEmptyState():
              return generateDataEmpty(context, 'Скачивайте модели, и они появятся здесь');
            default:
              return Container();
          }
        },
        bloc: bloc,
      ),
    );
  }

  Widget buildLoaded(BuildContext context, List<Model> models) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 16),
      child: ListView.separated(
        itemBuilder: (context, i) {
          final model = models[i];
          return InkWell(
            onTap: () {
              context.push('/Load', extra: model);
              //Navigator.pushNamed(context, '/Load', arguments: model);
            },
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
                      onPressed: () => bloc.add(ModelDeleteEvent(id: model.id ?? '')),
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
      ),
    );
  }
}