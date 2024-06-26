import 'package:flutter/material.dart';

class AddEntryPopup extends StatefulWidget {
  final Function(String title, double amount) onSubmit;

  const AddEntryPopup({super.key, required this.onSubmit});

  @override
  State<AddEntryPopup> createState() => _AddEntryPopupState();
}

class _AddEntryPopupState extends State<AddEntryPopup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_title, _amount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // Get keyboard height
    return Padding(
        padding: EdgeInsets.only(
            bottom: bottomInset, top: 20.0, left: 15.0, right: 15.0),
        child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (newValue) => _title = newValue!,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (newValue) => _amount = double.parse(newValue!),
              ),
              const SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Text('Submit',
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600)))))
            ])));
  }
}
