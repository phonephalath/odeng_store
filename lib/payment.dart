// payment_page.dart
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final int quantity;

  const PaymentPage({Key? key, required this.product, required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        double.parse(product['prod_price'].toString()) * quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ການຊໍາລະເງິນ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ສະຫຼຸບລາຍການ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('ຊື່ສິນຄ້າ: ${product['prod_name']}'),
            Text('ຈໍານວນ: $quantity'),
            Text('ລາຄາຕໍ່ຫນ່ວຍ: ${product['prod_price']}'),
            Text('ລາຄາລວມ: $totalPrice'),
            const SizedBox(height: 32),
            const Text(
              'ວິທີການຊໍາລະເງິນ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('ບັດເຄຣດິດ'),
              onTap: () {
                // Implement credit card payment logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('ໂອນເງິນຜ່ານທະນາຄານ'),
              onTap: () {
                // Implement bank transfer payment logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('ຈ່າຍເງິນສົດ'),
              onTap: () {
                // Implement cash payment logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
