import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:puppy_spa/model/waitingListModel.dart';
import 'package:puppy_spa/services/appServices.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController petName = TextEditingController(text: "");
  TextEditingController ownerName = TextEditingController(text: "");
  String selectedTime = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Backendless.initApp(
        applicationId: "E187A55D-1496-F017-FF4B-4BD72C91F800",
        androidApiKey: "61CF7DD9-44F8-4A31-A59A-823A45003F18",
        iosApiKey: "EED70B05-6205-4411-A6B9-260B2BA5FF16",
        jsApiKey: "CE609266-546A-4168-919B-943A6CA7F111");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AppServices().getTodayWaitingList().whenComplete(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // snapshot.data?[index].petName ?? ""
    return Scaffold(
      appBar: AppBar(
        title: const Text("PuppySpa Today List"),
        leading: IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      child: TextField(
                        controller: petName,
                        decoration: const InputDecoration(
                          labelText: "Pet Name",
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                      ),
                    ),
                    Card(
                      child: TextField(
                        controller: ownerName,
                        decoration: const InputDecoration(
                          labelText: "Owner Name",
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DateTimePicker(
                          initialValue: '',
                          firstDate: DateTime(2000),
                          type: DateTimePickerType.dateTime,
                          lastDate: DateTime(2100),
                          dateLabelText: 'Appointment Date',
                          onChanged: (val) {
                            print(val);
                            selectedTime = val;
                          },
                          validator: (val) {
                            print(val);
                            return null;
                          },
                          onSaved: (val) {
                            if (val != null) {
                              print(val);
                              selectedTime = val;
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(20))),
                            onPressed: () async {
                              if (petName.text != "" &&
                                  ownerName.text != '' &&
                                  selectedTime != '') {
                                bool isSuccess = await AppServices()
                                    .addWaitingList(petName.text,
                                        ownerName.text, selectedTime);
                                if (isSuccess) {
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              }
                            },
                            child: const Text("Add Booking")),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<WaitingListItem>>(
            future: AppServices().getTodayWaitingList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        isThreeLine: true,
                        trailing: Checkbox(
                          onChanged: (value) async {
                            await AppServices().updateWaitingList(
                              snapshot.data?[index].objectId,
                              value,
                            );
                            setState(() {});
                          },
                          value: snapshot.data?[index].isServiced,
                        ),
                        leading: InkWell(
                          onTap: () async {
                            await AppServices().changePriority(
                              snapshot.data?[index].objectId,
                              snapshot.data?[index].priority ?? 2,
                            );
                            setState(() {});
                          },
                          onDoubleTap: () {},
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    getColor(snapshot.data?[index].priority)),
                          ),
                        ),
                        title: Text(
                            "Puppy Name: ${snapshot.data?[index].petName ?? ""}"),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Owner Name : ${snapshot.data?[index].petOwnerName ?? ""}"),
                            Text(
                                "Arrived Time: ${AppServices().parseTimeStamp(snapshot.data?[index].petArrivedTime ?? 0)}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  getColor(int? priority) {
    if (priority == 0) {
      return Colors.redAccent;
    } else if (priority == 1) {
      return Colors.amberAccent;
    } else if (priority == 2) {
      return Colors.lightGreenAccent;
    }
  }
}
