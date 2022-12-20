import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';

class BtnFollow extends StatelessWidget {
  const BtnFollow({super.key});

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
                  mapBloc
                      .add(const OnToggleFollowingUserEvent(toggleValue: true));
                },
                icon: Icon(state.isfollowingUser
                    ? Icons.directions_run_outlined
                    : Icons.hail_rounded));
          })),
    );
  }
}
