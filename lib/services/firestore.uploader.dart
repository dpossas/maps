import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreUploader {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://snow-labs.appspot.com');
  StorageUploadTask _storageUploadTask;

  File file;
  String filePath ;

  FirestoreUploader(this.file);

  Future<String> startUpload() async {
    filePath = 'image/${Uuid().v1()}.png';
    _storageUploadTask = _storage.ref().child(filePath).putFile(this.file);
    return await( await _storageUploadTask.onComplete).ref.getDownloadURL();
  }

  Stream get uploadTask => _storageUploadTask.events;
  bool get isCompleted => _storageUploadTask != null && _storageUploadTask.isComplete;
}
