import 'package:flutter/material.dart';
import 'service/GetAdBox.dart';
import 'service/PostAdBox.dart';

class EditAdBoxDetailsPage extends StatefulWidget {
  const EditAdBoxDetailsPage({Key? key}) : super(key: key);
  @override
  EditAdBoxDetailsPageStale createState() => EditAdBoxDetailsPageStale();
}

class EditAdBoxDetailsPageStale extends State<EditAdBoxDetailsPage> {
  List adDatails = [];
  void showDeleteAdDia(BuildContext context, List adDetail, int index) {
    bool checkStatus = false;
    String dialogMessage = '';
    Future<void> deleteAd() async {
      var respone = await DeleteAd.deleteAd(adDetail[index]['_id']);
      if (respone.statusCode == 200) {
        checkStatus = true;
      } else {
        checkStatus = false;
      }
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const SizedBox(
              height: 100,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'ທ່ານຕ້ອງການຈະລົບ ຫຼື ບໍ່?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateProperty.all(
                  //       const Color.fromARGB(255, 235, 32, 32)),
                  //   foregroundColor: MaterialStateProperty.all(Colors.white),
                  // ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ປິດ')),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.pinkAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    final dialogShow = showDialog(
                      context: context,
                      builder: (context) => const Dialog(
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 15,
                              ),
                              Text('ກຳລັງໂຫຼດ...'),
                            ],
                          ),
                        ),
                      ),
                    );
                    await deleteAd();
                    Navigator.pop(context);
                    if (checkStatus) {
                      dialogMessage = 'ລົບໂຄສະນາ!';
                    } else {
                      dialogMessage = 'ລົບໂຄສະນາລົມຫຼຽວ, ກະລຸນາລອງອີກຄັ້ງ';
                    }
                    Navigator.pop(context);
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(dialogMessage),
                        duration: const Duration(seconds: 4),
                      ));
                    });
                  },
                  child: const Text('ລົບ!'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'ແກ້ໄຂລາຍລະອຽດໂຄສະນາ',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
        future: getAdboxdetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text('ກຳລັງໂຫຼດ ...'),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              adDatails = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List<Widget>.generate(
                    adDatails.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 194, 194, 194),
                              width: 0.5),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          title: Text(adDatails[index]['ad_text']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    showDeleteAdDia(context, adDatails, index),
                                icon: const Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {}
          }
          return Container();
        },
      ),
    );
  }
}
