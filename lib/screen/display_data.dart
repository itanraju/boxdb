import 'package:flutter/material.dart';
import 'package:learning/service/base_view.dart';

import '../helper/userdata.dart';
import '../provider/database_provider.dart';
import '../service/app_config.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({super.key});
  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  Widget build(BuildContext context) {
    return BaseView<DbProvider>(
      isConsumerAdded: true,
        onModelReady: (model){
      }, onModelDispose:(model){},
        builder: (BuildContext context,DbProvider model, Widget child){
      return Scaffold(
        appBar: AppBar(
          title: const Text("User Data"),
        ),
        body: Center(
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
        ),
      );
        }
    );
  }

  @override
  void initState() {
    appConfig<DbProvider>().getUserData();
  }
}
Widget getListTile(UserData userData,int index) {
  return ListTile(
    contentPadding: const EdgeInsets.all(10),
    leading: InkWell(
      onTap: () {
        UserData userData1=UserData(name: "Demo1", surname: "Demo2");
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

