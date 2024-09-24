import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../global/constants.dart';
import '../data/user_repository.dart';


final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(http.Client(), backendUri);
});



