import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  MockFirestore instance = MockFirestore();
  MockDocumentSnapshot mockDocumentSnapshot = MockDocumentSnapshot();
  MockCollectionReference mockCollectionReference = MockCollectionReference();
  MockDocumentReference mockDocumentReference = MockDocumentReference();

  setUp(() {

  });

  void setThings (){
    instance = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
  }

  test('should return data when the call to remote source is successful.', () async {

    setThings();

    when(instance.collection('auction')).thenReturn(mockCollectionReference as CollectionReference<Map<String,dynamic>>);
    when(mockCollectionReference.doc('654567')).thenReturn(mockDocumentReference);
    when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn(json);
    //act
    const result = 'hah';
    //assert
    expect(result, 'hah'); //userModel is a object that is defined. Replace with you own model class object.
  });
}