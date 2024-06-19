import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injector/injector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/generated/l10n.dart';
import 'package:tavrida_flutter/layouts/models_page/bloc/model_list_bloc.dart';
import 'package:tavrida_flutter/layouts/models_page/widgets/model_widget.dart';
import 'package:tavrida_flutter/services/models/model.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';
import 'package:tavrida_flutter/ui/failures/failure.dart';
import 'package:tavrida_flutter/ui/loading_state_widget.dart';
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
              return FailureContent(
                  title: S.of(context).somethingWentWrong,
                  message: S.of(context).errorWhileUpdating,
                );
            case ModelListEmptyState():
              return EmptyContent(
                title: S.of(context).stillEmpty,
                message: S.of(context).downloadModelsAndWillAppear,
              );
            default:
              return Container();
          }
        },
        bloc: bloc,
      ),
    );
  }

  Widget buildLoaded(BuildContext context, List<Model> models) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 16),
      child: ListView.separated(
        itemBuilder: (context, i) {
          return ModelWidget(
            model: models[i],
            onDelete: () => bloc.add(ModelDeleteEvent(id: models[i].id ?? '')),
          );
        },
        itemCount: models.length,
        separatorBuilder: (context, i) => const SizedBox(height: 12,),
      ),
    );
  }
}