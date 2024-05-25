import 'dart:convert';
import 'package:crud_app/photo_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductList extends StatefulWidget {
  final PhotoModel product;

  const UpdateProductList({super.key, required this.product});

  @override
  State<StatefulWidget> createState() => _UpdateProductList();
}

class _UpdateProductList extends State<UpdateProductList> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName ?? '';
    _priceTEController.text = widget.product.unitPrice ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
    _quantityTEController.text = widget.product.qty ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _imageTEController.text = widget.product.img ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product List'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameTEController,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: 'Name'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _priceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Unit Price', hintText: 'Unit Price'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your unit price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _codeTEController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      labelText: 'Product Code', hintText: 'Product Code'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your product code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Quantity', hintText: 'Quantity'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _totalPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Total Price', hintText: 'Total Price'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your Total Price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                      labelText: 'Image', hintText: 'Image'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your image';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: !_updateProductInProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProduct();
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    setState(() {
      _updateProductInProgress = true;
    });

    String updateUrl = 'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.Id}';
    Uri updateProductUri = Uri.parse(updateUrl);

    Response response = await post(
      updateProductUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Img': _imageTEController.text,
        'ProductCode': _codeTEController.text,
        'ProductName': _nameTEController.text,
        'Qty': _quantityTEController.text,
        'TotalPrice': _totalPriceTEController.text,
        'UnitPrice': _priceTEController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update product')),
      );
    }

    setState(() {
      _updateProductInProgress = false;
    });
  }
}
