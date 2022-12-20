import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Services
import 'package:flutter_04_map/modules/map/services/_services.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
// Routes
import 'package:flutter_04_map/routes.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
    BlocProvider(
        create: (context) => SearchBloc(trafficService: TrafficService()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "loading",
      routes: AppRoutes.generateRoutes(),
    );
  }
}
