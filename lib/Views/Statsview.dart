import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'package:flutter_application_1/backend/Ouvrage.dart';
import 'package:flutter_application_1/backend/Personnel.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pie_chart/pie_chart.dart';

import '../backend/Lecteur.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data =  ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final personnel = data[0] as Personnel ;
    final mysqlconn = data[1]as MySqlConnection ;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques"),

      ),
      body: FutureBuilder<Object>(
        future:personnel.get_stats(mySqlConnection: mysqlconn) ,
        builder: (context, snapshot) {
       if(snapshot.connectionState == ConnectionState.done) { final data =   snapshot.data as Set<dynamic>;
          final List<charts.Series<Personnel,String>> list1 = [
            charts.Series<Personnel,String>(id: "Activité de notre personnel"
            , data:data.elementAt(0) as  List<Personnel>
            , domainFn: (Personnel pers,_)=>(pers.nom + " " + pers.prenom)
            , measureFn: (Personnel pers , _)=>pers.minutes_en_service,
            
            )
          ];
  final List<charts.Series<Ouvrage,String>> list2 = [
            charts.Series<Ouvrage,String>(id: "Les 10 ouvrages les plus demandés "
            , data:data.elementAt(1) as  List<Ouvrage>
            , domainFn: (Ouvrage ouvrage,_)=>ouvrage.nomOuvrage + " " + ouvrage.nomAuteur
            , measureFn: (Ouvrage ouvrage , _)=>ouvrage.prets_tot
            )
          ];
            final List<charts.Series<Lecteur,String>> list3 = [
            charts.Series<Lecteur,String>(id: "Les 10 Lecteurs les plus actifs "
            , data:data.elementAt(2) as  List<Lecteur>
            , domainFn: (Lecteur lecteur,_)=>lecteur.nom + " " + lecteur.prenom
            , measureFn: (Lecteur lecteur , _)=>lecteur.nb_prets,
            )
          ];
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  
                       Column(
                         children: [
                           const Text("Activité de notre personnel ",style: TextStyle(fontSize: 20),),
                        const SizedBox(height: 30,),
                        Container(
                          height: 500,
                          width: 1600,
                          child: 
                           charts.BarChart(
            
                            list1,animate: true,animationDuration: Duration(seconds: 3),
                         )
                           
                        ),
                         ],
                       ),
                       
                 const  SizedBox(height: 50,),
                                       Column(
                                         children: [
                                           const Text("Top 10 Ouvrages demandés ",style: TextStyle(fontSize: 20),),
                                                                       SizedBox(height: 30,),
                  
                           Container(
                          height: 500,
                          width: 1600,
                          child: 
                           charts.BarChart(list2,animate: true,animationDuration: Duration(seconds: 3),)
                          
                        ),   ],
                                       ),
                            SizedBox(height:40,),
                         
                  
                                       SingleChildScrollView(
                                         child: Column(
                                           children: [
                                             const Text("Top 10 Lecteurs actifs ",style: TextStyle(fontSize: 20),),
                                                             SizedBox(height: 30,),          
                                                       
                                                          Container(
                                                         height: 500,
                                                         width: 1600,
                                                         child: 
                                                          charts.BarChart(list3,animate: true,animationDuration: Duration(seconds: 3),)
                                                         
                                                       ), ],
                                         ),
                                       ),
                       SizedBox(height: 30,),
              Text("Répartition des abonnements",style: TextStyle(fontSize: 20),),
               SizedBox(height: 40,),
              Row(
                children: [
                  SizedBox(width: 470,),
                  PieChart(
  dataMap: data.elementAt(3) as Map<String,double>
  ,
  animationDuration: Duration(milliseconds: 800),
  chartLegendSpacing: 32,
  chartRadius: MediaQuery.of(context).size.width / 2.7,
  colorList: [
    Colors.red,
    Colors.blue,
    Colors.green,
  ],
  chartType: ChartType.ring,
  legendOptions: LegendOptions(
    showLegendsInRow: false,
    legendPosition: LegendPosition.right,
    showLegends: true,
    legendTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  chartValuesOptions: ChartValuesOptions(
    showChartValueBackground: true,
    showChartValues: true,
    showChartValuesInPercentage: true,
    showChartValuesOutside: false,
    decimalPlaces: 1,
  ),
),

                ],
              ),
              
                    SizedBox(height: 30,),
              Text("Fidélité des lecteurs",style: TextStyle(fontSize: 20),),
               SizedBox(height: 40,),
              Row(
                children: [
                  SizedBox(width: 470,),
                  PieChart(
  dataMap: data.elementAt(4) as Map<String,double>
  ,
  animationDuration: Duration(milliseconds: 800),
  chartLegendSpacing: 32,
  chartRadius: MediaQuery.of(context).size.width / 2.7,
  colorList: [
    Colors.yellow,
    Color.fromARGB(255, 188, 171, 15),
    Color.fromARGB(255, 239, 178, 37),
        Color.fromARGB(255, 209, 167, 69),

      Color.fromARGB(255, 218, 116, 52),
        Color.fromARGB(255, 217, 62, 19),
  ].reversed.toList(),
  chartType: ChartType.ring,
  legendOptions: LegendOptions(
    showLegendsInRow: false,
    legendPosition: LegendPosition.right,
    showLegends: true,
    legendTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  chartValuesOptions: ChartValuesOptions(
    showChartValueBackground: true,
    showChartValues: true,
    showChartValuesInPercentage: true,
    showChartValuesOutside: false,
    decimalPlaces: 1,
  ),
),

                ],
              ),
              SizedBox(height: 40,),
            Text("Stats des prets",style: TextStyle(fontSize: 20),),

              SizedBox(height: 40,),
              Row(
                children: [
                  SizedBox(width: 470,),
                  PieChart(
  dataMap: data.elementAt(5) as Map<String,double>
  ,
  animationDuration: Duration(milliseconds: 800),
  chartLegendSpacing: 32,
  chartRadius: MediaQuery.of(context).size.width / 2.7,
  colorList: [ Color.fromARGB(255, 217, 62, 19),
    Color.fromARGB(255, 14, 44, 180),
   
        Color.fromARGB(255, 22, 159, 120),
  ].reversed.toList(),
  chartType: ChartType.disc,
  legendOptions: LegendOptions(
    showLegendsInRow: false,
    legendPosition: LegendPosition.right,
    showLegends: true,
    legendTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  chartValuesOptions: ChartValuesOptions(
    showChartValueBackground: true,
    showChartValues: true,
    showChartValuesInPercentage: true,
    showChartValuesOutside: false,
    decimalPlaces: 1,
  ),
),

                ],
              ),
                      ],
                      
                    ),
            ),
           
      
          );
        }else{
          return const Center(child: CircularProgressIndicator(),);
        }}
      ),
    );
  }
}