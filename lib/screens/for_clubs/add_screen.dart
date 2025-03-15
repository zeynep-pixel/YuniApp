import 'package:flutter/material.dart';
import 'package:yu_app/screens/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  var enteredClup = '';
  var enteredTitle = '';
  var enteredDetails = '';
  var enteredPlace = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedFinishDate = DateTime.now();

  void saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Firestore referansını al
        CollectionReference eventsRef =
            FirebaseFirestore.instance.collection('all-events');

        // Yeni belge ekle
        await eventsRef.add({
          'clup': enteredClup,
          'title': enteredTitle,
          'details': enteredDetails,
          'place': enteredPlace,
          'startdate': selectedStartDate,
          'finishdate': selectedFinishDate,
          'isActive': false, // Boolean değer
        });

        // Kullanıcıya başarı mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Etkinlik başarıyla kaydedildi!')),
        );

        _formKey.currentState!.reset();

        setState(() {
          enteredClup = '';
          enteredTitle = '';
          enteredDetails = '';
          enteredPlace = '';
          selectedStartDate = DateTime.now();
          selectedFinishDate = DateTime.now();
        });

        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Events()));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Etkinlik Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Klüp Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Klüp adı boş olamaz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredClup = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 200,
                  decoration: const InputDecoration(labelText: 'Etkinlik Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Etkinlik adı boş olamaz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredTitle = value!;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Başlangıç Tarihi',
                          hintText:
                              "${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}",
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedStartDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedStartDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Bitiş Tarihi',
                          hintText:
                              "${selectedFinishDate.day}/${selectedFinishDate.month}/${selectedFinishDate.year}",
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedFinishDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedFinishDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 500,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Açıklama boş olamaz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredDetails = value!;
                  },
                ),
                TextFormField(
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Mekan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mekan adı boş olamaz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredPlace = value!;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveItem,
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
