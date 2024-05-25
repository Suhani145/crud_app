import 'dart:convert';
import 'package:crud_app/add_product_screen.dart';
import 'package:crud_app/photo_model.dart';
import 'package:crud_app/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<StatefulWidget> createState() => _ProductList();
}
class _ProductList extends State<ProductList> {
  bool _getProductListInProgress = false;
  List<PhotoModel> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        color: Colors.purple,
        child: Visibility(
          visible: !_getProductListInProgress,
          replacement: const Center(child: CircularProgressIndicator(color: Colors.purple)),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _productListDetails(productList[index]);
            },
            separatorBuilder: (_, __) =>Divider(color: Colors.purple.shade200,
              height:25,
              indent: 10,
              endIndent: 10,),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductList()),
          );
          if (added == true) {
            _getProductList();
          }
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _productListDetails(PhotoModel product) {
    return ListTile(
      title: Text(product.productName ?? 'Unknown'),
      leading: Image.network(product.img ?? ''),
      subtitle: Wrap(
        children: [
          Text('Unit Price: ${product.unitPrice ?? ''}  '),
          Text('Quantity: ${product.qty ?? ''}  '),
          Text('Total Price: ${product.totalPrice ?? ''}  '),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProductList(product: product),
                ),
              );
              if (updated == true) {
                _getProductList();
              }
            },
            icon: Icon(Icons.edit, color: Colors.green.shade600),
          ),
          IconButton(
            onPressed: () {
              showDeleteConfirmationDialog(product.id ?? '');
            },
            icon: Icon(Icons.delete, color: Colors.red.shade500),
          ),
        ],
      ),
    );
  }

  Future<void> _getProductList() async {
    setState(() {
      _getProductListInProgress = true;
    });

    const String url = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri getProductUri = Uri.parse(url);
    Response response = await get(getProductUri);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final jsonProductList = decodedData['data'];
      productList = jsonProductList.map<PhotoModel>((json) => PhotoModel.fromJson(json)).toList();
    } else {
      showSnackBar('Get Products Failed');
    }

    setState(() {
      _getProductListInProgress = false;
    });
  }
  void showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text('Delete', style: TextStyle(color: Colors.red.shade800)),
          content: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No', style: TextStyle(color: Colors.green.shade600)),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(productId);
                Navigator.pop(context);
              },
              child:Text('Yes', style: TextStyle(color: Colors.red.shade800)),
            ),
          ],
        );
      },
    );
  }
  Future<void> _deleteProduct(String productId) async {
    setState(() {
      _getProductListInProgress = true;
    });

    String deleteUrl = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri deleteUri = Uri.parse(deleteUrl);
    Response response = await get(deleteUri);
    if (response.statusCode == 200) {
      _getProductList();
    } else {
      setState(() {
        _getProductListInProgress = false;
      });
      showSnackBar('Deletion failed');
    }
  }
  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(content)));
  }
}
