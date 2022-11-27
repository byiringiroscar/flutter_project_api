import 'package:covid_tracker/Model/WorldStatesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/countries_list.dart';



class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> with TickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this
  )..repeat();


  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  final colorList = <Color> [
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * .01,),
              FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot){
                if(!snapshot.hasData){
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                          controller: _controller,
                        )
                    );
                }else{
                    return Expanded(
                      child: SingleChildScrollView( // this help us to scroll when we have overscreen stuff
                        child: Column(
                          children: [
                            PieChart(
                              dataMap:{
                                "total": double.parse(snapshot.data!.cases!.toString()),
                                "Recovered": double.parse(snapshot.data!.recovered!.toString()),
                                "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                  showChartValuesInPercentage: true
                              ),
                              chartRadius: MediaQuery.of(context).size.width / 3.2,
                              legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.left
                              ),
                              animationDuration: const Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: colorList,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .02),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    ReusableRow(title: 'Total', value: snapshot.data!.cases!.toString(),),
                                    ReusableRow(title: 'Deaths', value: snapshot.data!.deaths!.toString(),),
                                    ReusableRow(title: 'Recovered', value: snapshot.data!.recovered!.toString(),),
                                    ReusableRow(title: 'Active', value: snapshot.data!.active!.toString(),),
                                    ReusableRow(title: 'Critical', value: snapshot.data!.critical!.toString(),),
                                    ReusableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths!.toString(),),
                                    ReusableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered!.toString(),),

                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const CountriesListScreen()));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text("Tracker countries"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                }
              }),


            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title),
              Text(value)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
        ],
      ),
    );
  }
}

