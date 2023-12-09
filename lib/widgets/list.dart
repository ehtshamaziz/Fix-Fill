import 'package:flutter/material.dart';




class ItemListScreen extends StatelessWidget {
  final List<Item> items = [
    Item(
      title: 'Item 1',
      description: 'This is item 1 description.',
      imageUrl: 'https://example.com/item1.jpg',
    ),
    Item(
      title: 'Item 2',
      description: 'This is item 2 description.',
      imageUrl: 'https://example.com/item2.jpg',
    ),
    Item(
      title: 'Item 3',
      description: 'This is item 3 description.',
      imageUrl: 'https://example.com/item3.jpg',
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    final List<Item> items = [
      Item(
        title: 'Item 1',
        description: 'This is item 1 description.',
        imageUrl: 'https://example.com/item1.jpg',
      ),
      Item(
        title: 'Item 2',
        description: 'This is item 2 description.',
        imageUrl: 'https://example.com/item2.jpg',
      ),
      Item(
        title: 'Item 3',
        description: 'This is item 3 description.',
        imageUrl: 'https://example.com/item3.jpg',
      ),
      // Add more items as needed
    ];
    return Scaffold(

      body: Container(
        child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item.title),
            subtitle: Text(item.description),
            onTap: () {
              // Handle item click here
            },
          );
        },
      ),
      )
    );
  }
}

class Item {
  final String title;
  final String description;
  final String imageUrl;

  Item({required this.title, required this.description, required this.imageUrl});
}
