import 'dart:convert';

import 'package:faiapp/core/storage/cache_store.dart';
import 'package:faiapp/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:faiapp/features/workspace/domain/entities/workspace_plan.dart';
import 'package:faiapp/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:shared_contracts/shared_contracts.dart';

typedef CacheStoreLoader = Future<CacheStore> Function();

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl({
    required WorkspaceRemoteDataSource remoteDataSource,
    required CacheStoreLoader cacheStoreLoader,
  }) : _remoteDataSource = remoteDataSource,
       _cacheStoreLoader = cacheStoreLoader;

  static const _cacheKey = 'latest_workspace_plan';

  final WorkspaceRemoteDataSource _remoteDataSource;
  final CacheStoreLoader _cacheStoreLoader;

  @override
  Future<WorkspacePlan> generatePlan(WorkspaceDraft draft) async {
    final response = await _remoteDataSource.generatePlan(draft.toRequest());
    final cacheStore = await _cacheStoreLoader();
    await cacheStore.write(_cacheKey, jsonEncode(response.toJson()));
    return WorkspacePlan.fromDto(response);
  }

  @override
  Future<WorkspacePlan?> readCachedPlan() async {
    final cacheStore = await _cacheStoreLoader();
    final rawValue = await cacheStore.read(_cacheKey);
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    return WorkspacePlan.fromDto(
      WorkspacePlanResponse.fromJson(
        jsonDecode(rawValue) as Map<String, dynamic>,
      ),
    );
  }
}
