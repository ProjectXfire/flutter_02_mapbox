import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';

class BtnPolylines extends StatelessWidget {
  const BtnPolylines({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
          maxRadius: 25,
          child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
            return IconButton(
                onPressed: () {
                  mapBloc.add(const OnToggleRouteEvent());
                },
                icon: Icon(state.showRoute ? Icons.hide_source : Icons.route));
          })),
    );
  }
}
