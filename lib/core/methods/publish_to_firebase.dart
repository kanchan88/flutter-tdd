import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:workoneerweb/core/error/expection.dart';

class PublishToFirebase {

  // uploading image to firebase storages
  Future<String> uploadImage(Uint8List img) async {
    try{
      const uuid = Uuid();
      String uniqueId = uuid.v4();
      Reference ref = FirebaseStorage.instance.ref().child("client/$uniqueId");
      await ref.putData(img);
      return await ref.getDownloadURL();
    } catch (e){
      throw ServerException(e.toString());
    }
  }

  // uploading multiple images
  Future<List<String>> uploadAllImagesInFirebase(List<Uint8List> images) async {

    List<String> allUrl = [];

    for(int i=0; i<images.length; i++) {
      String url = await uploadImage(images[i]);
      allUrl.add(url);
    }

    return allUrl;
  }

}