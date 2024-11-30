import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This generates the code for our Riverpod provider
// The generated code will be in auth_remote_repository.g.dart
part 'auth_remote_repository.g.dart';

// @riverpod annotation creates a provider for AuthRemoteRepository
// This will generate a provider named authRemoteRepositoryProvider
// The provider will be accessible throughout the app using ref.watch(authRemoteRepositoryProvider)
@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  // This is a simple provider that returns an instance of AuthRemoteRepository
  // Since this repository doesn't depend on other providers, we just return a search instance
  // If this repository needed dependencies, we could access other providers using ref.watch() here
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}${ServerConstant.signUp}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}${ServerConstant.logIn}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap['user'])
          .copyWith(token: resBodyMap['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getUserData(String token) async {
    try {
      final response = await http.get(
          Uri.parse('${ServerConstant.serverUrl}auth/'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token
          }
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200){
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    }
    catch (e){
      return Left(AppFailure(e.toString()));
    }
  }
}
