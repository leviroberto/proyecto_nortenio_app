import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/custom_app_bar.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/stats_grid.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

import 'covid_bar_chart.dart';

class TabPrincipalMotorizado extends StatefulWidget {
  @override
  _TabPrincipalMotorizadoState createState() => _TabPrincipalMotorizadoState();
}

class _TabPrincipalMotorizadoState extends State<TabPrincipalMotorizado> {
  final covidUSADailyNewCases = [
    12.17,
    11.15,
    10.02,
    11.21,
    13.83,
    14.16,
    14.30
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.colorBody,
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          /*   _buildRegionTabBar(), */
          /*  _buildStatsTabBar(), */
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: CovidBarChart(covidCases: covidUSADailyNewCases),
            ),
          )
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Estadísticas',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
