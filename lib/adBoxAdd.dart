import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'service/PostAdBox.dart';

class AddAdBoxInfo extends StatefulWidget {
  const AddAdBoxInfo({Key? key}) : super(key: key);
  @override
  AddAdBoxInfoPage createState() => AddAdBoxInfoPage();
}

class AddAdBoxInfoPage extends State<AddAdBoxInfo> {
  bool getSaveStatus = false;
  String? dialogMessage;
  final adTextCon = TextEditingController();
  final picker = ImagePicker();
  XFile? pickedImage;
  BoxDecoration boxUploadImage = BoxDecoration(
      border: Border.all(
          color: const Color.fromARGB(255, 187, 187, 187), width: 8.0),
      borderRadius: BorderRadius.circular(20.0));

  Future<void> summitSave() async {
    var adText = adTextCon.text;
    var adImg = getImageByte();
    if (adImg == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ກະລຸນາອັບໂຫຼດຮູບ'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    var respone = await AddAdDitails.postAdDetail(adImg, adText);
    if (respone.statusCode == 200) {
      getSaveStatus = true;
      print('ເພີ່ມຂໍ້ມູນໂຄສະນາສຳເລັດ');
    } else {
      getSaveStatus = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ກະລຸນາໃຊ້ຮູບທີ່ມີຄວາມຈຳຕໍ່ກວ່າ 50Kb'),
          duration: Duration(seconds: 2),
        ),
      );
      print('ເພີ່ມໂຄສະນາສິນຄ້າບໍ່ສຳເລັດ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'ເພີ່ມໂຄສະນາ',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: adTextCon,
              decoration: InputDecoration(
                labelText: 'Ad ຄຳອະທິບາຍໂຄສະນາ',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                decoration: boxUploadImage,
                height: 250,
                width: double.infinity,
                child: pickedImage != null
                    ? InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Image.file(File(pickedImage!.path)))
                    : Focus(
                        descendantsAreFocusable: false,
                        canRequestFocus: false,
                        child: IconButton(
                          iconSize: 60.0,
                          onPressed: pickImage,
                          color: Colors.grey,
                          highlightColor: Colors.transparent,
                          //splashColor: Colors.transparent,
                          // splashRadius: 0,
                          icon: const Icon(
                            Icons.photo_library_outlined,
                          ),
                        ),
                      )),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '*ກະລຸນາໃຊ້ຮູບທີ່ມີຄວາມຈຳຕ່ໍາກວ່າ 50Kb',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
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
                dialogShow;
                await summitSave();
                if (getSaveStatus) {
                  dialogMessage = 'ບັນທຶກໂຄສະນາ!!';
                } else {
                  dialogMessage = 'ບັນທຶກລົ້ມຫຼຽວ!!';
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(dialogMessage!),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                });
                // ignore: use_build_context_synchronously
              },
              child: const Text('ເພີ່ມລາຍລະອຽດ'),
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = pickedFile;
    });
  }

  String? getImageByte() {
    if (pickedImage != null) {
      File file = File(pickedImage!.path);
      return base64Encode(file.readAsBytesSync());
    }
    return null;
  }
  //end
}
