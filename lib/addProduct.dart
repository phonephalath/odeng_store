import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'service/DoingWithProductDetailsApi.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  AddProductPageStale createState() => AddProductPageStale();
}

class AddProductPageStale extends State<AddProductPage> {
  bool getSaveStatus = false;
  final nameCon = TextEditingController();
  final desCon = TextEditingController();
  final priCon = TextEditingController();
  final picker = ImagePicker();
  XFile? pickedImage;

  Future<void> summitSave() async {
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບ'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    var prodName = nameCon.text;
    var prodDesc = desCon.text;
    var prodPrice = double.parse(priCon.text);
    var prodType = selectedType;

    var imageBytes = getImageByte();
    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ກະລຸນາອັບໂຫຼດຮູບ'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    var respone = await addProduct.postProduct(
      prodName,
      prodDesc,
      prodPrice,
      prodType!,
      imageBytes,
    );

    if (respone.statusCode == 200) {
      getSaveStatus = true;
      print('ເພີ່ມສິນຄ້າສຳເລັດ');
    } else {
      getSaveStatus = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ໄຟລ໌ຮູບມີຂະໜາດໃຫຍ່ເກີນໄປ ກະລຸນາໃສ່ຮູບໃໝ່'),
          duration: Duration(seconds: 2),
        ),
      );
      print('ເພີ່ມສິນຄ້າບໍ່ສຳເລັດ');
    }
  }

  BoxDecoration boxUploadImage = BoxDecoration(
      border: Border.all(
          color: const Color.fromARGB(255, 187, 187, 187), width: 8.0),
      borderRadius: BorderRadius.circular(20.0));
  final prodType = [
    'ກ້ອງບູເລັດ',
    'ກ້ອງໂດຣມ',
    'ເຄື່ອງບັນທຶກ',
    'ຮາດດິດ',
    'alarm system'
  ];
  String? selectedType;
  String? dialogMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'ເພີ່ມສິນຄ້າ',
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
              controller: nameCon,
              decoration: InputDecoration(
                labelText: 'ຊື່ສິນຄ້າ',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: desCon,
              decoration: InputDecoration(
                labelText: 'ລາຍລະອຽດສິນຄ້າ',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: priCon,
              decoration: InputDecoration(
                labelText: 'ລາຄາສິນຄ້າ',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              items: prodType.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              value: selectedType,
              decoration: InputDecoration(
                labelText: 'ປະເພດສິນຄ້າ',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
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
              '*ກະລຸນາໃຊ້ຮູບທີ່ມີຄວາມຈຳຕຳກວ່າ 50Kb',
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
                  dialogMessage = 'ບັນທຶກສິນຄ້າ!!';
                } else {
                  dialogMessage = 'ບັນທຶກລົ້ມຫຼຽວ';
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
              child: const Text('ເພີ່ມສິນຄ້າ'),
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

  void showDialogWarrnig(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: Text('ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບ'),
        );
      },
    );
  }
}
