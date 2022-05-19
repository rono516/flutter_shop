// ignore_for_file: prefer_const_constructors, prefer_final_fields

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:shop/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-products';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imgageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
      // ignore: null_check_always_fails
      id: '',
      title: '',
      price: 0,
      description: '',
      imageUrl: '');

  // var _initValues = {
  //   'title': '',
  //   'price': '',
  //   'description': '',
  //   'imageUrl': '',
  // };

  // var _isInit = true;

  @override
  void initState() {
    _imgageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   //Find the Product to be edited using id passed as an argument from user_products screen in the edit button
  //   if (_isInit) {
  //     final productId = ModalRoute.of(context)!.settings.arguments as String;

  //     if (productId == '') {
  //       _editedProduct =
  //           Provider.of<Products>(context, listen: false).findById(productId);

  //       _initValues = {
  //         'title': _editedProduct.title,
  //         'price': _editedProduct.price.toString(),
  //         'description': _editedProduct.description,
  //         // 'imageUrl': _editedProduct.imageUrl,
  //         'imageUrl': '',
  //       };
  //       _imageUrlController.text = _editedProduct.imageUrl;
  //     }
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  var _isLoading = false;

  @override
  void dispose() {
    _imgageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imgageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imgageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // void _saveForm() {
  //   final isValid = _form.currentState!.validate();

  //   if (!isValid) {
  //     return;
  //   }
  //   _form.currentState!.save();
  //   Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
  //   Navigator.of(context).pop();
  // }
  void _saveForm() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false)
        .addProduct(_editedProduct)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });

    // if (_editedProduct.id != null) {
    //   Provider.of<Products>(context, listen: false)
    //       .updateProduct(_editedProduct.id, _editedProduct);
    // } else {
    //   Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    // }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value!,
                              price: _editedProduct.price,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter price greater than Ksh. 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value!),
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a product description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: value!,
                              imageUrl: _editedProduct.imageUrl);
                        },
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocusNode);
                        // },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                                // _imageUrlController.text.isEmpty
                                //     ? Text('Enter imageURL')
                                //     :
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imgageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite,
                                    description: _editedProduct.description,
                                    imageUrl: value!);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

// ignore_for_file: prefer_const_constructors




















// import 'package:flutter/material.dart';
// import 'package:shop/providers/product.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/providers/products.dart';

// class EditProductScreen extends StatefulWidget {
//   const EditProductScreen({Key? key}) : super(key: key);

//   static const routeName = '/edit-products';

//   @override
//   State<EditProductScreen> createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode();
//   final TextEditingController _imageUrlController = TextEditingController();
//   final _imgageUrlFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//   var _editedProduct = Product(
//       // ignore: null_check_always_fails
//       id: '',
//       title: '',
//       price: 0,
//       description: '',
//       imageUrl: '');

//   var _initValues = {
//     'title': '',
//     'price': '',
//     'description': '',
//     'imageUrl': '',
//   };

//   var _isInit = true;

//   @override
//   void initState() {
//     _imgageUrlFocusNode.addListener(_updateImageUrl);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     //Find the Product to be edited using id passed as an argument from user_products screen in the edit button
//     if (_isInit) {
//       final productId = ModalRoute.of(context)!.settings.arguments as String;

//       if (productId != null) {
//         _editedProduct =
//             Provider.of<Products>(context, listen: false).findById(productId);

//         _initValues = {
//           'title': _editedProduct.title,
//           'price': _editedProduct.price.toString(),
//           'description': _editedProduct.description,
//           // 'imageUrl': _editedProduct.imageUrl,
//           'imageUrl': '',
//         };
//         _imageUrlController.text = _editedProduct.imageUrl;
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _imgageUrlFocusNode.removeListener(_updateImageUrl);
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     _imgageUrlFocusNode.dispose();
//     super.dispose();
//   }

//   void _updateImageUrl() {
//     if (!_imgageUrlFocusNode.hasFocus) {
//       setState(() {});
//     }
//   }

//   void _saveForm() {
//     final isValid = _form.currentState!.validate();

//     if (!isValid) {
//       return;
//     }
//     _form.currentState!.save();

//     if (_editedProduct.id != null) {
//       Provider.of<Products>(context, listen: false)
//           .updateProduct(_editedProduct.id, _editedProduct);
//     } else {
//       Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
//     }
//     Navigator.of(context).pop();
//     // print(_editedProduct.title);
//     // print(_editedProduct.imageUrl);
//     // print(_editedProduct.price);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Product'),
//         actions: <Widget>[
//           IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//             key: _form,
//             child: ListView(
//               // ignore: prefer_const_literals_to_create_immutables
//               children: <Widget>[
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Title'),
//                   textInputAction: TextInputAction.next,
//                   initialValue: _initValues['title'],
//                   onFieldSubmitted: (_) {
//                     FocusScope.of(context).requestFocus(_priceFocusNode);
//                   },
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter a title.';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _editedProduct = Product(
//                         title: value!,
//                         price: _editedProduct.price,
//                         id: _editedProduct.id,
//                         isFavourite: _editedProduct.isFavourite,
//                         description: _editedProduct.description,
//                         imageUrl: _editedProduct.imageUrl);
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Price'),
//                   textInputAction: TextInputAction.next,
//                   initialValue: _initValues['price'],
//                   keyboardType: TextInputType.number,
//                   focusNode: _priceFocusNode,
//                   onFieldSubmitted: (_) {
//                     FocusScope.of(context).requestFocus(_descriptionFocusNode);
//                   },
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please Enter a Price';
//                     }
//                     if (double.tryParse(value) == null) {
//                       return 'Please Enter a valid number';
//                     }
//                     if (double.parse(value) <= 0) {
//                       return 'Enter price greater than Ksh. 0';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _editedProduct = Product(
//                         title: _editedProduct.title,
//                         price: double.parse(value!),
//                         id: _editedProduct.id,
//                         isFavourite: _editedProduct.isFavourite,
//                         description: _editedProduct.description,
//                         imageUrl: _editedProduct.imageUrl);
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   textInputAction: TextInputAction.next,
//                   initialValue: _initValues['description'],
//                   maxLines: 3,
//                   keyboardType: TextInputType.multiline,
//                   focusNode: _descriptionFocusNode,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please Enter a product description';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _editedProduct = Product(
//                         title: _editedProduct.title,
//                         price: _editedProduct.price,
//                         id: _editedProduct.id,
//                         isFavourite: _editedProduct.isFavourite,
//                         description: value!,
//                         imageUrl: _editedProduct.imageUrl);
//                   },
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       width: 100,
//                       height: 100,
//                       margin: const EdgeInsets.only(top: 8, right: 10),
//                       decoration: BoxDecoration(
//                           border: Border.all(width: 1, color: Colors.grey)),
//                       child: FittedBox(
//                         child: Image.network(
//                           _imageUrlController.text,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         decoration: InputDecoration(labelText: 'Image URL'),
//                         keyboardType: TextInputType.url,
//                         // initialValue: _initValues['imageUrl'],
//                         textInputAction: TextInputAction.done,
//                         controller: _imageUrlController,
//                         focusNode: _imgageUrlFocusNode,
//                         onFieldSubmitted: (_) {
//                           _saveForm();
//                         },
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter an image URL';
//                           }
//                           if (!value.startsWith('http') &&
//                               !value.startsWith('https')) {
//                             return 'Please enter a valid URL';
//                           }
//                           return null;
//                         },

//                         onSaved: (value) {
//                           _editedProduct = Product(
//                               title: _editedProduct.title,
//                               price: _editedProduct.price,
//                               id: _editedProduct.id,
//                               isFavourite: _editedProduct.isFavourite,
//                               description: _editedProduct.description,
//                               imageUrl: value!);
//                         },

//                         // _imageUrlController.text.isEmpty
//                         // ? Text('Enter imageURL')
//                         //  :
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Container(
//                 //     width: 100,
//                 //     height: 100,
//                 //     child: Image.network(_imageUrlController.text)),
//               ],
//             )),
//       ),
//     );
//   }
// }
