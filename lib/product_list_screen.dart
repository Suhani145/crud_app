import 'package:crud_app/add_product_screen.dart';
import 'package:crud_app/update_product_screen.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget
{
  const ProductList({super.key});

  @override
  State<StatefulWidget> createState() => _ProductList();
}

class _ProductList extends State<ProductList>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Product List'),
      ),
     body:ListView.separated(
       itemCount: 5,
         itemBuilder: (context, index)
             {
               return _productListDetails();
             },
       separatorBuilder: (_,__)=> const Divider(),
     ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(
           builder: (context)=> const AddProductList()));
        },
        child:const Icon(Icons.add),
      ),
    );
  }

  Widget _productListDetails() {
    return ListTile(
               leading: Image.network('https://images.pexels.com/photos/14838102/pexels-photo-14838102.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
               title:const Text('Product Name'),
               subtitle: const Wrap(
                   children: [
                     Text('Product Price : 100'),
                     Text('Product Quantity: 100'),
                     Text('Product Size : 100')
                   ]),
               trailing: Wrap(
                 children: [
                   IconButton(
                       onPressed: (){
                         Navigator.push(context,
                             MaterialPageRoute(
                                 builder: (context)=> const UpdateProductList())
                         );
                       },
                       icon: const Icon(Icons.edit)
                   ),
                   IconButton(
                       onPressed: (){
                         showDeleteConfirmationDialog();
                       },
                       icon: const Icon(Icons.delete)
                   ),
                 ],
               ),
             );
  }
  void showDeleteConfirmationDialog()
  {
    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title:const Text('Delete'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Yes')
          )
        ],
      );
    }
    );
  }
}