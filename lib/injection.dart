import 'package:get_it/get_it.dart';
import 'package:md_detection/src/data/datasources/mp_datasource.dart';
import 'package:md_detection/src/data/repositories/mp_repositories_impl.dart';
import 'package:md_detection/src/domain/repositories/mp_repositories.dart';
import 'package:md_detection/src/domain/usecases/detection_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:md_detection/src/presentation/states/detection_result_helper.dart';
import 'package:md_detection/src/presentation/states/mp_notifier.dart';

final locator = GetIt.instance;

void init() {
  // Datasources
  locator.registerLazySingleton<MpDatasource>(
      () => MpDatasourceImpl(client: locator()));

  // Repositories
  locator.registerLazySingleton<MpRepositories>(
      () => MpRepositoriesImpl(mpDatasource: locator()));

  // Usecases
  locator
      .registerLazySingleton(() => DetectionUsecase(repositories: locator()));

  // Providers
  locator.registerFactory(() => MpNotifier(detectionUsecase: locator()));
  locator.registerFactory(() => DetectionResultHelper());

  // External
  locator.registerLazySingleton(() => http.Client());
}
