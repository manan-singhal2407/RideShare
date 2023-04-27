import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../data/network/service/retrofit_service.dart';

@module
abstract class NetworkModule {

  @injectable
  Dio get dio => Dio();

  @injectable
  RestClient get restClient => RestClient(dio);

  @injectable
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @injectable
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;
}