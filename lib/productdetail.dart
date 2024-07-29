import 'dart:convert';
import 'package:flutter/material.dart';
import 'payment.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ValueNotifier<int> _quantityNotifier = ValueNotifier<int>(1);

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['prod_name']),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(base64Decode(widget.product['prod_image'])),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['prod_name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('ປະເພດ: ${widget.product['prod_type']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('ລາຄາ: ${widget.product['prod_price']}',
                          style: const TextStyle(fontSize: 18)),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 35,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.pinkAccent),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      product: widget.product,
                                      quantity: _quantityNotifier.value,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'ຊື້',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: QuantitySelector(quantityNotifier: _quantityNotifier),
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final ValueNotifier<int> quantityNotifier;

  const QuantitySelector({
    Key? key,
    required this.quantityNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: quantityNotifier,
      builder: (context, quantity, child) {
        return Row(
          children: [
            ElevatedButton(
              onPressed: () {
                if (quantity > 1) {
                  quantityNotifier.value--;
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            Text(
              '$quantity',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                quantityNotifier.value++;
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        );
      },
    );
  }
}
