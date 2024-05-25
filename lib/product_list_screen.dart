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
        child: Visibility(
          visible: !_getProductListInProgress,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _productListDetails(productList[index]);
            },
            separatorBuilder: (_, __) => const Divider(),
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
        child: const Icon(Icons.add),
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
          //const SizedBox(width: 4),
          Text('Quantity: ${product.qty ?? ''}  '),
          Text('Total Price: ${product.productCode ?? ''}  '),
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
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDeleteConfirmationDialog(product.id ?? '');
            },
            icon: const Icon(Icons.delete),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Get Products Failed')),
      );
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
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(productId);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deletion failed')),
      );
    }
  }
}
