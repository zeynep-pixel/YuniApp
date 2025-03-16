import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yu_app/screens/events.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  String? userClub; // Kullanıcının kulübü (Firestore'dan alınacak)
  var enteredTitle = '';
  var enteredDetails = '';
  var enteredPlace = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedFinishDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchUserClub();
  }

  Future<void> fetchUserClub() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userClub = userDoc.data()?['clubName'] ?? "Bilinmiyor";
        });
      }
    } catch (e) {
      print("Kullanıcı kulübü alınırken hata oluştu: $e");
    }
  }

  void saveItem() async {
    if (_formKey.currentState!.validate() && userClub != null) {
      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance.collection('all-events').add({
          'clup': userClub,
          'title': enteredTitle,
          'details': enteredDetails,
          'place': enteredPlace,
          'startdate': selectedStartDate,
          'finishdate': selectedFinishDate,
          'isActive': false,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Etkinlik başarıyla kaydedildi!')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => Events()),
        );
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
      appBar: AppBar(title: const Text('Yeni Etkinlik Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                
                const SizedBox(height: 10),

                TextFormField(
                  maxLength: 200,
                  decoration: const InputDecoration(labelText: 'Etkinlik Adı'),
                  validator: (value) => value!.isEmpty ? 'Boş bırakılamaz.' : null,
                  onSaved: (value) => enteredTitle = value!,
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
                            setState(() => selectedStartDate = pickedDate);
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
                            setState(() => selectedFinishDate = pickedDate);
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
                  validator: (value) => value!.isEmpty ? 'Boş bırakılamaz.' : null,
                  onSaved: (value) => enteredDetails = value!,
                ),

                TextFormField(
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Mekan'),
                  validator: (value) => value!.isEmpty ? 'Boş bırakılamaz.' : null,
                  onSaved: (value) => enteredPlace = value!,
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
