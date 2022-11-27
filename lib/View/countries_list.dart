import 'package:flutter/material.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:covid_tracker/View/detail_screen.dart';


class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  StatesServices statesServices = StatesServices();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value){
                    setState(() {

                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Search with country name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0)
                      )
                  ),
                ),
              ),
              Expanded(
                  child: FutureBuilder(
                    future: statesServices.countriesListApi(),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                      if(!snapshot.hasData){

                        return ListView.builder(
                            itemCount: 6,
                            itemBuilder: (context, index){
                              return Shimmer.fromColors(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Container(height: 10,width: 89, color: Colors.white,),
                                        subtitle: Container(height: 10,width: 89, color: Colors.white,),
                                        leading: Container(height: 50,width: 50, color: Colors.white,),
                                      )
                                    ],
                                  ),
                                  baseColor: Colors.grey.shade700,
                                  highlightColor: Colors.grey.shade100
                              );

                            });
                      }else{
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              String name = snapshot.data![index]['country'];
                              if(searchController.text.isEmpty){
                                return Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                                          image: snapshot.data![index]['countryInfo']['flag'],
                                          name: snapshot.data![index]['country'],
                                          totalCases: snapshot.data![index]['cases'],
                                          totalRecovered: snapshot.data![index]['recovered'],
                                          totalDeaths: snapshot.data![index]['deaths'],
                                          active: snapshot.data![index]['active'],
                                          test: snapshot.data![index]['tests'],
                                          todayRecovered: snapshot.data![index]['todayRecovered'],
                                          critical: snapshot.data![index]['critical'],

                                        )));
                                      },
                                      child: ListTile(
                                        title: Text(snapshot.data![index]['country']),
                                        subtitle: Text(snapshot.data![index]['cases'].toString()),
                                        leading: Image(
                                            height: 50,
                                            width: 50,
                                            image: NetworkImage(
                                                snapshot.data![index]['countryInfo']['flag']
                                            )),
                                      ),
                                    )
                                  ],
                                );
                              }
                              else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                                return Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                                          image: snapshot.data![index]['countryInfo']['flag'],
                                          name: snapshot.data![index]['country'],
                                          totalCases: snapshot.data![index]['cases'],
                                          totalRecovered: snapshot.data![index]['recovered'],
                                          totalDeaths: snapshot.data![index]['deaths'],
                                          active: snapshot.data![index]['active'],
                                          test: snapshot.data![index]['tests'],
                                          todayRecovered: snapshot.data![index]['todayRecovered'],
                                          critical: snapshot.data![index]['critical'],
                                        )));
                                      },
                                      child: ListTile(
                                        title: Text(snapshot.data![index]['country']),
                                        subtitle: Text(snapshot.data![index]['cases'].toString()),
                                        leading: Image(
                                            height: 50,
                                            width: 50,
                                            image: NetworkImage(
                                                snapshot.data![index]['countryInfo']['flag']
                                            )),
                                      ),
                                    )
                                  ],
                                );
                              }
                              else{
                                return Container();
                              }

                        });
                      }

                    },
                  )
              )
            ],
          )
      ),
    );
  }
}
