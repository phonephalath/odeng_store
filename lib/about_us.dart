import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ກ່ຽວກັບພວກເຮົາ'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Odeng Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ຈັດຈຳໜ່າຍກ້ອງວົງຈອນ ແບະ ອຸປະກອນ alarm.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'ສະມາຊິກໃນກຸ່ມ ຫ້ອງ 2IT_CON2',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ນາງ ພອນພາລັດ ຫອມແສນສີ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'ນາງ ວຽງດາວັນ ຈັນທະວົງ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'ທ້າວ ເກດສະດາ ບົວລະວົງ',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
