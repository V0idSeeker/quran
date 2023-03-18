import 'package:flutter/material.dart';
import 'package:quran/db_filler.dart';
import 'database_manager_v2.dart';
import 'varss.dart';

// Define the main app class
void main() => runApp(MainDisplay());

class MainDisplay extends StatefulWidget {
  @override
  State<MainDisplay> createState() => _MainDisplayState();
}

class _MainDisplayState extends State<MainDisplay> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      home: LoginPage(),
    );
  }
}

// Define the login page
class LoginPage extends StatefulWidget {
  @override
  MainDisplayState createState() => MainDisplayState();
}

class MainDisplayState extends State<LoginPage> {

  db_maneger_v2 data_base=db_maneger_v2();
  int current_page = 1;
  void _prev_page() {
    setState(() {
      current_page--;
    });
  }
  void _next_page() {
    setState(() {
      current_page++;
    });
  }
  String check_prev_page() {
    if (current_page == 1)
      return "";
    else
      return (current_page - 1).toString();
  }
  check_next_page() {
    if (current_page == 10)
      return "";
    else
      return (current_page + 1).toString();
  }
  Widget page_parts(List<Map> data)
  {
    List<Widget> pageparts=[];
    String paragraph="";
    for(int i=0;i<data.length;i++)
    {
      if(data[i]["ayah_number"].toString()=="0")
      { if(paragraph!=""){pageparts.add(Text(paragraph ,maxLines: null,));paragraph=""; };
      pageparts.add(Text(data[i]["ayah_number"].toString()));
      }
      else{
        paragraph=paragraph+data[i]["ayah_text"].toString();
      }

    }
    if(paragraph!="")pageparts.add(Text(paragraph ,maxLines: null,));
    return Column(children: pageparts ,);
    //return Column();
  }
  Widget pagee()
  { return Container(
    decoration: const BoxDecoration(
      image:DecorationImage(
      image: AssetImage("img/backround1.jpg"),
        fit: BoxFit.cover,
    ),),
    height: MediaQuery.of(context).size.height * 0.85,

    child: FutureBuilder(future: data_base.get_ayat_of_page(current_page),
        builder: (BuildContext context ,AsyncSnapshot<List<Map>>snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          else return page_parts(snapshot.data!);

        }
    ),
  );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:  FutureBuilder(future: data_base.get_page_title(current_page),
        builder: (context,AsyncSnapshot<String>snapshot){
          if(!snapshot.hasData) return Text("ffff");
          else return Text(snapshot.data.toString());

        },
        ),
        )
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width/3,
        elevation: 20,
        child: Container(
          color: Colors.black,
        ),
      ),
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        pagee(),
        //center_page
        /*   Container(
          height: MediaQuery.of(context).size.height * 0.85,
          color: Colors.red,
          child: FutureBuilder(future: data_base.readData("SELECT * FROM ayat"),
          builder: (BuildContext context ,AsyncSnapshot<List<Map>>snapshot){
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            else return ListView.builder(itemCount: snapshot.data!.length,
                itemBuilder: (context , i){
                return Text("${snapshot.data![i]}");
                }
                );


          },
          ),
        ),*/
        Container(
          //page_counter
          height: MediaQuery.of(context).size.height * 0.05,
          color: Colors.greenAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(check_next_page())
              ,
              IconButton(
                  onPressed: () {
                    if (current_page != 10)
                      _next_page();

                  },
                  icon: Icon(Icons.arrow_back_ios_sharp)),
              Text(current_page.toString()),
              IconButton(
                onPressed: () {
                  if (current_page != 1)
                    _prev_page();

                },
                icon: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Text(check_prev_page())
            ],
          ),
        )
      ]),
    );
  }
}
