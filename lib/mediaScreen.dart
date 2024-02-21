import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaScreen extends StatefulWidget {
  final String userPhoneNumber;

  const MediaScreen({Key? key, required this.userPhoneNumber}) : super(key: key);

  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late Stream<QuerySnapshot> _imagesStream;

  @override
  void initState() {
    super.initState();
    _imagesStream = FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.userPhoneNumber)
        .collection('media')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _imagesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final imageUrl = documents[index].get('imageUrl');
                if (imageUrl != null) {
                  return FutureBuilder(
                    future: _getImage(imageUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            // Implement onTap functionality, e.g., view full-screen image
                            // You can navigate to a new screen to view the image in full screen
                          },
                          child: Image.memory(
                            snapshot.data as Uint8List,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return Container(); // Placeholder for empty state
                    },
                  );
                } else {
                  return Container(); // Placeholder for empty state
                }
              },
            );
          }

          return Container(); // Placeholder for empty state
        },
      ),
    );
  }

  Future<Uint8List?> _getImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      final data = await ref.getData();
      return data;
    } catch (e) {
      print('Error loading image from $imageUrl: $e');
      return null;
    }
  }

}
