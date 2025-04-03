import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<String> _selectedCategoryIds = []; // Seçilen kategorilerin ID'lerini tutan liste

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    // Firestore'dan kategorileri çek
    var querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'], // kategorinin ismi
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>( 
      future: _fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Hiç kategori bulunamadı.'));
        }

        List<Map<String, dynamic>> categories = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Yatay kaydırma
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var category = categories[index];
                bool isSelected = _selectedCategoryIds.contains(category['id']); 

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCategoryIds.remove(category['id']); 
                      } else {
                        _selectedCategoryIds.add(category['id']); 
                      }
                    });
                    print("Seçilen Kategoriler: $_selectedCategoryIds");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFFFC529) : Colors.white, 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category['name'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
