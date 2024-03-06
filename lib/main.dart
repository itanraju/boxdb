import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:learning/helper/userdata.dart';
import 'package:learning/provider/database_provider.dart';
import 'package:learning/screen/display_data.dart';
import 'package:learning/service/app_config.dart';
import 'package:learning/service/base_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserDataAdapter());
  setupAppConfig();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override

  Widget build(BuildContext context) {
    return BaseView(onModelReady: (model){}, onModelDispose: (model){},
    isConsumerAdded: true,
    builder: (BuildContext context,DbProvider model,Widget child){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            ElevatedButton(onPressed: (){
              showInsertDialog(context);
            }, child: const Text("Insert")),
            ElevatedButton(onPressed: (){
              /*appConfig<DbProvider>().getUserData();
              showDisplayDataDialog(context);*/
              Navigator.of(context)
                  .push(MaterialPageRoute(
                  builder: (context) => const DisplayData()));
            }, child: const Text("Display")),
            SizedBox(
              height: 300,
              child: model.showLoading?
              const CircularProgressIndicator():
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: model.userDataList.isEmpty?const Center(
                  child: Text(
                    "No Data Available",
                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ):ListView(
                  children: [
                    for(int i=0;i<model.userDataList.length;i++)...[
                      getListTile(model.userDataList[i],i)
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

void showInsertDialog(BuildContext context)
{
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool nameValidate=false;
  bool surnameValidate=false;
  String nameErrorMsg="";
  String surnameErrorMsg="";
  showGeneralDialog(context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      pageBuilder: (_,__,___){
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState){
        return BaseView<DbProvider>(
            onModelReady: (model){
              }, onModelDispose: (model){
            },
          builder: (BuildContext context,DbProvider model,Widget child){
              return Material(
                type: MaterialType.transparency,
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.50,
                    width: MediaQuery.of(context).size.width*0.85,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Center(
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration:InputDecoration(
                              labelText: 'Enter Name',
                              errorText: nameValidate ? nameErrorMsg:"",
                            ),
                          ),
                          TextField(
                            controller: surnameController,
                            decoration:InputDecoration(
                              labelText: 'Enter Surname',
                              errorText: surnameValidate ? surnameErrorMsg:"",
                            ),
                          ),
                          ElevatedButton(onPressed: (){
                            if(nameController.text.isNotEmpty && surnameController.text.isNotEmpty)
                            {
                              /*setState((){
                          nameValidate=false;
                          surnameValidate=false;
                        });*/

                              if (kDebugMode) {
                                print("Done");
                              }

                              UserData userData=UserData(name: nameController.text.toString(), surname: surnameController.text.toString());
                              model.addUserData(context,userData);

                            }
                            else
                            {
                              if(nameController.text.isEmpty && surnameController.text.isEmpty)
                              {
                                setState((){
                                  nameErrorMsg="not null";
                                  surnameErrorMsg="not null";
                                  nameValidate=true;
                                  surnameValidate=true;
                                });
                              }
                              else
                              {
                                if(surnameController.text.isEmpty)
                                {
                                  setState((){
                                    surnameErrorMsg="not null";
                                    nameValidate=false;
                                    surnameValidate=true;
                                  });
                                }
                                else
                                {
                                  setState((){
                                    nameErrorMsg="not null";
                                    nameValidate=true;
                                    surnameValidate=false;
                                  });
                                }
                              }
                            }
                          },child: const Text("Insert")
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
          },
        );
      }
    );
  });
}

Widget getListTile(UserData userData,int index) {
  return ListTile(
    contentPadding: const EdgeInsets.all(10),
    leading: InkWell(
      onTap: () {
        UserData userData1=UserData(name: "Demo", surname: "Demo2");
        appConfig<DbProvider>().updateUserData(userData1,index);
      },
      child: const Icon(
        Icons.edit,
        size: 35,
      ),
    ),
    title: Text(
      userData.name,
      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      userData.surname,
      style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
    ),
    trailing: InkWell(
      onTap: (){
        appConfig<DbProvider>().deleteUserData(userData);
      },
      child: const Icon(
        Icons.delete_forever,
        size: 25,
      ),
    ),
  );
}

