import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_5roga/core/constants/api_constants.dart';
import 'package:yalla_5roga/core/localization/locale_provider.dart';
import 'package:yalla_5roga/core/network/api_client.dart';
import 'package:yalla_5roga/core/network/dio_interceptors.dart';
import 'package:yalla_5roga/core/network/network_info.dart';
import 'package:yalla_5roga/core/theme/theme_provider.dart';
import 'package:yalla_5roga/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:yalla_5roga/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:yalla_5roga/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yalla_5roga/features/auth/domain/usecases/login_usecase.dart';
import 'package:yalla_5roga/features/auth/domain/usecases/register_usecase.dart';
import 'package:yalla_5roga/features/auth/presentation/providers/auth_provider.dart';
import 'package:yalla_5roga/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/outing_chat_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/outings_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/saved_outings_provider.dart';

class AppDependencies {
  const AppDependencies({
    required this.theme,
    required this.locale,
    required this.auth,
    required this.notifications,
    required this.outingChat,
    required this.outings,
    required this.savedOutings,
  });

  final ThemeProvider theme;
  final LocaleProvider locale;
  final AuthProvider auth;
  final NotificationsProvider notifications;
  final OutingChatProvider outingChat;
  final OutingsProvider outings;
  final SavedOutingsProvider savedOutings;

  static Future<AppDependencies> create() async {
    final prefs = await SharedPreferences.getInstance();
    final networkInfo = NetworkInfoImpl(Connectivity());

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.addAll([
      AuthInterceptor(prefs),
      AppLogInterceptor(),
      ErrorInterceptor(),
    ]);

    final repository = AuthRepositoryImpl(
      remote: AuthRemoteDataSourceImpl(ApiClient(dio)),
      local: AuthLocalDataSourceImpl(prefs),
      networkInfo: networkInfo,
    );

    final auth = AuthProvider(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
      repository: repository,
    );
    await auth.restoreSession();

    return AppDependencies(
      theme: ThemeProvider(prefs),
      locale: LocaleProvider(prefs),
      auth: auth,
      notifications: NotificationsProvider(),
      outingChat: OutingChatProvider(),
      outings: OutingsProvider(),
      savedOutings: SavedOutingsProvider(prefs),
    );
  }
}
