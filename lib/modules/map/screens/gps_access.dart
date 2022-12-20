import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';

class GPSScreen extends StatelessWidget {
  const GPSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            return state.isGpsEnabled
                ? const _AccessButton()
                : const _EnableGPSMessage();
          },
        ),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gpsBloc = BlocProvider.of<GpsBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Active GPS"),
        MaterialButton(
          color: Colors.black,
          elevation: 0,
          shape: const StadiumBorder(),
          onPressed: () {
            gpsBloc.requestGpsAccess();
          },
          child: const Text("Request access",
              style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class _EnableGPSMessage extends StatelessWidget {
  const _EnableGPSMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Must active GPS',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300));
  }
}
