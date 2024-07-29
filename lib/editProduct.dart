import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'service/getProductApi.dart';
import 'service/DoingWithProductDetailsApi.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  EditProductPageStale createState() => EditProductPageStale();
}

class EditProductPageStale extends State<EditProductPage> {
  List products = [];
  List forFilterProduct = [];
  String? selectedValue;
  @override
  void initState() {
    super.initState();
  }

  void showEditProductDialog(BuildContext context, List products, int index) {
    bool checkStatus = false;
    String dialogMessage = '';
    final TextEditingController prodName =
        TextEditingController(text: products[index]['prod_name']);
    final TextEditingController prodDes =
        TextEditingController(text: products[index]['prod_desc']);
    final TextEditingController prodPrice =
        TextEditingController(text: products[index]['prod_price'].toString());
    Future<void> saveEdit(String id) async {
      var productName = prodName.text;
      var productDes = prodDes.text;
      var productPrice = double.parse(prodPrice.text);

      var respone = await UpdateProduct.putProducts(
        productName,
        productDes,
        productPrice,
        id,
      );
      if (respone.statusCode == 200) {
        checkStatus = true;
        print('ແກ້ໄຂສຳເລັດ');
      } else {
        // getSaveStatus = false;
        checkStatus = false;
        print('ແກ້ໄຂບໍ່ສຳເລັດ');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ແກ້ໄຂຂໍ້ມູນສິນຄ້າ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ຊື່ສິນຄ້າ',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                controller: prodName,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ລາຍລະອຽດສິນຄ້າ',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                controller: prodDes,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'ລາຄາສິນຄ້າ',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                controller: prodPrice,
              ),
            ],
          ),
          actions: [
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ປິດ')),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
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
                await saveEdit(products[index]['_id']);
                Navigator.pop(context);

                if (checkStatus) {
                  dialogMessage = 'ສິນຄ້າໄດ້ຖືກແກ້ໄຂ';
                } else {
                  dialogMessage = 'ສິນຄ້າບໍ່ໄດ້ຖືກແກ້ໄຂ';
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(dialogMessage),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                });
              },
              child: const Text('ບັນທຶກ'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, List products, int index) {
    bool checkStatus = false;
    String dialogMessage = '';
    Future<void> deleteProduct() async {
      var respone = await DeleteProduct.deleteProducct(products[index]['_id']);
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
            content: SizedBox(
              height: 150,
              child: Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'ທ່ານຕ້ອງການຈະລົບ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${products[index]['prod_name']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'ຫຼື ບໍ່?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
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
                    await deleteProduct();
                    Navigator.pop(context);
                    if (checkStatus) {
                      dialogMessage = 'ສິນຄ້າຖືກລົບ';
                    } else {
                      dialogMessage = 'ລົບສິນຄ້າບໍ່ສຳເລັດ, ກະລຸນາລອງອີກຄັ້ງ';
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
          'ແກ້ໄຂສິນຄ້າ',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
        future: getProducts(),
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
                    Text('ກຳລັງໂຫຼດ...'),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              forFilterProduct = snapshot.data!;
              products = snapshot.data!;
              return Column(
                children: [
                  Container(
                      child: DropdownButton(
                          value: selectedValue,
                          items: const [
                            DropdownMenuItem(
                              value: 'ກ້ອງບູເລັດ',
                              child: Text('ກ້ອງບູເລັດ'),
                            ),
                            DropdownMenuItem(
                              value: 'ກ້ອງໂດຣມ',
                              child: Text('ກ້ອງໂດຣມ'),
                            ),
                            DropdownMenuItem(
                              value: 'ເຄື່ອງບັນທຶກ',
                              child: Text('ເຄື່ອງບັນທຶກ'),
                            ),
                            DropdownMenuItem(
                              value: 'ຮາດດິດ',
                              child: Text('ຮາດດິດ'),
                            ),
                            DropdownMenuItem(
                              value: 'alarm system',
                              child: Text('alarm system'),
                            ),
                          ],
                          onChanged: fillterProduct)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 194, 194, 194),
                                width: 0.5),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: Text(products[index]['prod_name']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_note),
                                  onPressed: () => showEditProductDialog(
                                      context, products, index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => showDeleteDialog(
                                      context, products, index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      getProducts();
                    });
                  },
                  child: const Text('ລອງອີກຄັ້ງ'));
            }
          }
          return Container();
        },
      ),
    );
  }

  void fillterProduct(String? value) {
    List fillteredProduct = forFilterProduct
        .where((element) => element['prod_type'] == value)
        .toList();
    setState(() {
      products = fillteredProduct;
    });
  }
  //end
}
