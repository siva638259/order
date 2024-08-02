import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductStorePage(),
    );
  }
}

class ProductStorePage extends StatefulWidget {
  @override
  _ProductStorePageState createState() => _ProductStorePageState();
}

class _ProductStorePageState extends State<ProductStorePage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['products'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text(
          'ஆர்டர் டெலிவரி',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              
              label: Text(
                'இன்று',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              iconAlignment: IconAlignment.end,
              icon: Icon(Icons.arrow_drop_down_circle_sharp, color: Colors.black),
              onPressed: () {
                // Navigate to pending orders page
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(height: 50),
                _buildChip('All', isSelected: true),
                _buildChip('Smartphones'),
                _buildChip('Laptops'),
                _buildChip('Fragrances'),
                _buildChip('Skincare'),
                _buildChip('Groceries'),
              ],
            ),
          ),
          SizedBox(height: 10), // Space between the chips and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Handle button 1 action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 237, 237), // Button color
                ),
                iconAlignment: IconAlignment.end,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black), // Icon
                label: Text('பாதையைத் தேர்ந்தெடுக்கவும்', style: TextStyle(color: Colors.black,fontSize: 7)), // Text
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle button 2 action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 237, 237), // Button color
                ),
                iconAlignment: IconAlignment.end,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black), // Icon
                label: Text('கடையைத் தேர்ந்தெடுக்கவும்', style: TextStyle(color: Colors.black,fontSize: 7)), // Text
              ),
            ],
          ),
          SizedBox(height: 20), // Space between the buttons and the grid view
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 239, 238, 238),
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
     
        },
        
        label: Text('மொத்தம் ₹399    |    ஆர்டர் பட்டியல்', style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.shopping_cart, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(category: label),
            ),
          );
        },
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[300],
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                product['thumbnail'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('\$${product['price']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Center(
        child: Text('Displaying products for $category'),
      ),
    );
  }
}
