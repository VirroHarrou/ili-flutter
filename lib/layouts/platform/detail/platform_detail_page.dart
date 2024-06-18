import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tavrida_flutter/common/routes.dart';
import 'package:tavrida_flutter/generated/l10n.dart';
import 'package:tavrida_flutter/services/models/platform.dart';
import 'package:tavrida_flutter/themes/app_colors.dart';
import 'package:tavrida_flutter/ui/app_text_styles.dart';
import 'package:tavrida_flutter/ui/buttons/text_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/platform_detail_bloc.dart';
import 'widgets/view.dart';

part 'platform_detail_builds.dart';
part 'platform_detail_plus.dart';

class PlatformDetailPage extends StatefulWidget {
  final Platform platform;

  const PlatformDetailPage({
    super.key,
    required this.platform,
  });

  @override
  State<PlatformDetailPage> createState() => _PlatformDetailPageState();
}

class _PlatformDetailPageState extends State<PlatformDetailPage> {
  late final PlatformDetailBloc bloc;

  @override
  void initState() {
    bloc = PlatformDetailBloc(widget.platform);
    bloc.add(PlatformDetailUpdateEvent(id: widget.platform.id ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlatformDetailBloc, PlatformDetailState>(
        bloc: bloc,
        builder: (context, state) {
          switch (state) {
            case PlatformDetailInitState():
              return SingleChildScrollView(
                child: Column(
                  children: [
                    buildTop(state.platform),
                    buildDefaultBody(state.platform),
                    const SizedBox(height: 32,),
                  ],
                ),
              );
            case PlatformDetailLoadedDefaultState():
              return SingleChildScrollView(
                child: Column(
                  children: [
                    buildTop(state.platform),
                    buildDefaultBody(state.platform),
                    const SizedBox(height: 32,),
                  ],
                ),
              );
            case PlatformDetailLoadedPlusState():
              return buildPlatformPlus(state, context);
            default:
              return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pop();
        },
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
        hoverColor: const Color.fromRGBO(255, 255, 255, 0.4),
        hoverElevation: 0,
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}