import 'package:flutter/material.dart';
import '../providers/product.dart';

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

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
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
    final isValid = _formLinker.currentState.validate();
    if(!isValid) return ;
    _formLinker.currentState.save();
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
        child: Form(
          key: _formLinker,
          child: ListView(
            children: <Widget>[
              TextFormField(
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
                    id: null,
                  );
                },
                validator: (value){
                  //returning null means that the value satisfied the validator
                  if(value.isEmpty){
                    return 'please fill in the blanks';
                  }
                  return null;
                },
              ),
              TextFormField(
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
                    price: value.isNotEmpty ? double.parse(value):0,
                    description: _editedWillSavedProduct.description,
                    imageUrl: _editedWillSavedProduct.imageUrl,
                    id: null,
                  );
                },
              ),
              TextFormField(
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
                    id: null,
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
                        color: Theme
                            .of(context)
                            .primaryColor,
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
                          id: null,
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
