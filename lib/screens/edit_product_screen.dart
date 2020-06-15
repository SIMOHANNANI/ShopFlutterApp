import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Edit-product';

  @override
  _EditProductScreen createState() => _EditProductScreen();
}

class _EditProductScreen extends State {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formLinker = GlobalKey<FormState>();
  var _editedWillSavedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  bool _isInit = true;
  bool _isLoading = false;
  var _initProductValues = {
    'title': '',
    'description': '',
    'price': 0,
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  // ignore: must_call_super
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final _editTargetedProduct =
            Provider.of<ProductsProvider>(context, listen: false)
                .findById(productId);
        print(_editTargetedProduct.title);
        _initProductValues = {
          'title': _editTargetedProduct.title,
          'description': _editTargetedProduct.description,
          'price': _editTargetedProduct.price.toString(),
//          'imageUrl': _editTargetedProduct.imageUrl,
          'imageUrl': 'f',
        };
        _imageUrlController.text = _editTargetedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formLinker.currentState.validate();
    if (!isValid) return;
    _formLinker.currentState.save();
    if (_editedWillSavedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedWillSavedProduct.id, _editedWillSavedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedWillSavedProduct)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operation to perform ...'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: _isLoading ? Center(child: CircularProgressIndicator(),):Form(
          key: _formLinker,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initProductValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedWillSavedProduct = Product(
                    title: value,
                    price: _editedWillSavedProduct.price,
                    description: _editedWillSavedProduct.description,
                    imageUrl: _editedWillSavedProduct.imageUrl,
                    id: _editedWillSavedProduct.id,
                    isFavorite: _editedWillSavedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  //returning null means that the value satisfied the validator
                  if (value.isEmpty) {
                    return 'please fill in the blanks';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initProductValues['price'].toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                onSaved: (value) {
                  _editedWillSavedProduct = Product(
                    title: _editedWillSavedProduct.title,
                    price: value.isNotEmpty ? double.parse(value) : 0,
                    description: _editedWillSavedProduct.description,
                    imageUrl: _editedWillSavedProduct.imageUrl,
                    id: _editedWillSavedProduct.id,
                    isFavorite: _editedWillSavedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null) return 'invalid price';
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initProductValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionNode,
                onSaved: (value) {
                  _editedWillSavedProduct = Product(
                    title: _editedWillSavedProduct.title,
                    price: _editedWillSavedProduct.price,
                    description: value,
                    imageUrl: _editedWillSavedProduct.imageUrl,
                    id: _editedWillSavedProduct.id,
                    isFavorite: _editedWillSavedProduct.isFavorite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    margin: EdgeInsets.only(top: 8.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(
                            child: Text(
                            'Enter a URL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ))
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        _editedWillSavedProduct = Product(
                          title: _editedWillSavedProduct.title,
                          price: _editedWillSavedProduct.price,
                          description: _editedWillSavedProduct.description,
                          imageUrl: value,
                          id: _editedWillSavedProduct.id,
                          isFavorite: _editedWillSavedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
