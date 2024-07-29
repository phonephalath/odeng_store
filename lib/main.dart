import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odeng_store/adBoxAdd.dart';
import 'package:odeng_store/editAdBox.dart';
import 'package:odeng_store/editProduct.dart';
import 'package:odeng_store/service/GetAdBox.dart';
import 'package:odeng_store/service/getProductApi.dart';
import 'package:odeng_store/widget/skeletonLoad.dart';
import 'package:odeng_store/addProduct.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:odeng_store/register.dart';
import 'package:odeng_store/login.dart';
import 'package:odeng_store/profile.dart';
import 'package:odeng_store/productdetail.dart';
import 'package:odeng_store/about_us.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odeng Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
        fontFamily: 'NotoSansLao',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(userId: ''),
        '/addproduct': (context) => const AddProductPage(),
        '/editproduct': (context) => const EditProductPage(),
        '/adBoxInfoAdd': (context) => const AddAdBoxInfo(),
        '/adBoxEdit': (context) => const EditAdBoxDetailsPage(),
        '/register': (context) => const RegisterPage(),
        '/about': (context) => const AboutUsPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String userId;

  const MyHomePage({super.key, required this.userId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List dataProduct = [];
  List dataAdBox = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              // ignore: sort_child_properties_last
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ເມນູ',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ຈັດການສິນຄ້າ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              focusColor: Colors.pinkAccent,
              title: const Text(
                'ເພີ່ມສິນຄ້າ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/addproduct');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              focusColor: Colors.pinkAccent,
              title: const Text(
                'ແກ້ໄຂສິນຄ້າ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/editproduct');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              focusColor: Colors.pinkAccent,
              title: const Text(
                'ເພີ່ມລາຍລະອຽດໂຄສະນາ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/adBoxInfoAdd');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              focusColor: Colors.pinkAccent,
              title: const Text(
                'ແກ້ໄຂລາຍລະອຽດໂຄສະນາ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/adBoxEdit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              focusColor: Colors.pinkAccent,
              title: const Text(
                'ກ່ຽວກັບພວກເຮົາ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          //dataProduct = await getProducts();
          setState(() {});
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 250,
              child: FutureBuilder(
                  future: getAdboxdetails(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Dialog(
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(20),
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
                    } else if (snap.connectionState == ConnectionState.done) {
                      if (snap.hasData) {
                        List originalDataList = snap.data!;
                        final shuffleList = List.from(originalDataList)
                          ..shuffle();
                        final randomList = shuffleList.take(6);
                        dataAdBox = randomList.toList();
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List<Widget>.generate(
                              dataAdBox.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 350,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 5),
                                        pauseAutoPlayOnTouch: true,
                                        pauseAutoPlayOnManualNavigate: true,
                                        pauseAutoPlayInFiniteScroll: true),
                                    items: [
                                      for (int index = 0;
                                          index < dataAdBox.length;
                                          index++)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          width: 350,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.memory(
                                                base64Decode(
                                                    dataAdBox[index]['ad_pic']),
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                      Colors.black
                                                          .withOpacity(0.5),
                                                      Colors.transparent
                                                    ],
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end: Alignment
                                                            .topCenter)),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Text(
                                                      dataAdBox[index]
                                                          ['ad_text'],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (snap.hasError) {
                        return const SizedBox(
                          height: 300,
                          child: Text('ມີບາງຢ່າງຜິດພາດ'),
                        );
                      }
                    }
                    return const SizedBox(
                      height: 300,
                      child: Text("error"),
                    );
                  }),
            ),
            FutureBuilder(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SkeletonBox(
                    key: Key('skeleton'),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    dataProduct = snapshot.data!;
                    Iterable smfilltered = dataProduct.where(
                        (element) => element['prod_type'] == 'ກ້ອງບູເລັດ');
                    final smSuffle = List.from(smfilltered)..shuffle();
                    List<dynamic> showDataListSm = smSuffle.toList();
                    Iterable dsfilltered = dataProduct
                        .where((ds) => ds['prod_type'] == 'ກ້ອງໂດຣມ');
                    final dsSuffle = List.from(dsfilltered)..shuffle();
                    List<dynamic> showDataListds = dsSuffle.toList();
                    Iterable pcfilltered = dataProduct
                        .where((pc) => pc['prod_type'] == 'ເຄື່ອງບັນທຶກ');
                    final pcSuffle = List.from(pcfilltered)..shuffle();
                    List<dynamic> showDataListPc = pcSuffle.toList();
                    Iterable tlfilltered =
                        dataProduct.where((tl) => tl['prod_type'] == 'ຮາດດິດ');
                    final tlSuffle = List.from(tlfilltered)..shuffle();
                    List<dynamic> showDataListTl = tlSuffle.toList();
                    Iterable swfilltered = dataProduct
                        .where((sw) => sw['prod_type'] == 'alarm system');
                    final swSuffle = List.from(swfilltered)..shuffle();
                    List<dynamic> showDataListSw = swSuffle.toList();

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const Padding(
                          //show smart phone part
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'ກ້ອງບູເລັດ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List<Widget>.generate(
                                showDataListSm.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                    product:
                                                        showDataListSm[index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 250,
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.white, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 0.5,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 120,
                                                child: Image.memory(
                                                    base64Decode(
                                                        showDataListSm[index]
                                                            ['prod_image'])),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showDataListSm[index]
                                                        ['prod_name'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ປະເພດ: ${showDataListSm[index]['prod_type']}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ລາຄາ: ${showDataListSm[index]['prod_price'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 35,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .pinkAccent),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {},
                                                            child: const Text(
                                                              'ຊື້',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                        const Padding(
                          //show desktop part
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'ກ້ອງໂດຣມ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List<Widget>.generate(
                                showDataListds.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                    product:
                                                        showDataListds[index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 250,
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.white, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 0.5,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 120,
                                                child: Image.memory(
                                                    base64Decode(
                                                        showDataListds[index]
                                                            ['prod_image'])),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showDataListds[index]
                                                        ['prod_name'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ປະເພດ: ${showDataListds[index]['prod_type']}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ລາຄາ: ${showDataListds[index]['prod_price'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 35,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .pinkAccent),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {},
                                                            child: const Text(
                                                              'ຊື້',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                        const Padding(
                          //show pc part
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'ເຄື່ອງບັນທຶກ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List<Widget>.generate(
                                showDataListPc.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                    product:
                                                        showDataListPc[index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 250,
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.white, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 0.5,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 120,
                                                child: Image.memory(
                                                    base64Decode(
                                                        showDataListPc[index]
                                                            ['prod_image'])),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showDataListPc[index]
                                                        ['prod_name'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ປະເພດ: ${showDataListPc[index]['prod_type']}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ລາຄາ: ${showDataListPc[index]['prod_price'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 35,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .pinkAccent),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {},
                                                            child: const Text(
                                                              'ຊື້',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                        const Padding(
                          //show tablet
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'ຮາດດິດ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List<Widget>.generate(
                                showDataListTl.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                    product:
                                                        showDataListTl[index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 250,
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.white, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 0.5,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 120,
                                                child: Image.memory(
                                                    base64Decode(
                                                        showDataListTl[index]
                                                            ['prod_image'])),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showDataListTl[index]
                                                        ['prod_name'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ປະເພດ: ${showDataListTl[index]['prod_type']}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ລາຄາ: ${showDataListTl[index]['prod_price'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 35,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .pinkAccent),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {},
                                                            child: const Text(
                                                              'ຊື້',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                        const Padding(
                          //show smart watch
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'alarm system',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List<Widget>.generate(
                                showDataListSw.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailPage(
                                                    product:
                                                        showDataListSw[index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 250,
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.white, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 0.5,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 120,
                                                child: Image.memory(
                                                    base64Decode(
                                                        showDataListSw[index]
                                                            ['prod_image'])),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showDataListSw[index]
                                                        ['prod_name'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ປະເພດ: ${showDataListSw[index]['prod_type']}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ລາຄາ: ${showDataListSw[index]['prod_price'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 35,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .pinkAccent),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {},
                                                            child: const Text(
                                                              'ຊື້',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
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
          ],
        ),
      ),
    );
  }
}
