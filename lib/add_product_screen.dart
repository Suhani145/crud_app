import 'package:flutter/material.dart';

class AddProductList extends StatefulWidget
{
  const AddProductList({super.key});

  @override
  State<StatefulWidget> createState() => _AddProductList();
}

class _AddProductList extends State<AddProductList>
{
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _sizeTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Add Product List'),
      ),
      body:SingleChildScrollView(
        child: Padding(
         padding:const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameTEController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Name'
                  ),
                  validator: (String? value)
                  {
                    if(value == null || value.trim().isEmpty)
                      {
                        return 'Write your product name';
                      }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _priceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Unit Price',
                      hintText: 'Unit Price'
                  ),
                  validator: (String? value)
                  {
                    if(value == null || value.trim().isEmpty)
                      {
                        return 'Write your unit price';
                      }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Quantity'
                  ),
                  validator: (String? value)
                  {
                    if(value == null || value.trim().isEmpty)
                    {
                      return 'Write your quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _sizeTEController,
                  keyboardType: TextInputType.number,
                  decoration:const InputDecoration(
                      labelText: 'Size',
                      hintText: 'Size'
                  ),
                  validator: (String? value)
                  {
                    if(value == null || value.trim().isEmpty)
                    {
                      return 'Write your size';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _imageTEController,
                  decoration:const InputDecoration(
                      labelText: 'Image',
                      hintText: 'Image'
                  ),
                  validator: (String? value)
                  {
                    if(value == null || value.trim().isEmpty)
                    {
                      return 'Write your image';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()) {}
                    },
                    child: const Text('Add'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose()
  {
    _nameTEController.dispose();
    _priceTEController.dispose();
    _quantityTEController.dispose();
    _sizeTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }

}