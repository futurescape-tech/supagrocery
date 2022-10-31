import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';
import 'package:supagrocery/app/app.locator.dart';
import 'package:supagrocery/app/supabase_api.dart';
import 'package:supagrocery/datamodels/application_models.dart';
import 'package:supagrocery/services/local_storage_service.dart';

class AuthenticationService {
  final _logger = Logger();
  final _localStorageService = locator<LocalStorageService>();

  AppUser? _user = null;
  AppUser? get user => _user;
  bool get hasUser => _user != null;

  Future<void> initialize() async {
    final accessToken = await _localStorageService.getItem('token');
    _logger.i(accessToken);

    if (accessToken == null) {
      return;
    }

    final response = await supabase.auth.admin.getUserById(accessToken);

    if (response.user != null) {
      return;
    }

    final user = response.user!;
    _logger.i(user.toJson());
    await fetchUser(id: user.id);
  }

  Future<AppUser?> signIn({required AuthDto payload}) async {
    final response = await supabase.auth.signInWithPassword(
      email: payload.email,
      password: payload.password,
    );

    // if (response.error != null) {
    //   _logger.e(response.error!.message);
    //   return null;
    // }
    _logger.i(response.user);
    await _localStorageService.setItem('token', response.session!.accessToken);
    return await fetchUser(id: response.user!.id);
  }

  Future<AppUser?> signUp({required AuthDto payload}) async {
    final response =
        await supabase.auth.signUp(email: payload.email,password: payload.password);

    if (response.user != null) {
      _logger.e(response.user!.email);
      return null;
      
    }

    final user = response.user!;
    _logger.i(user.toJson());
    await _createUser(user, payload);
    await _localStorageService.setItem('token', response.session!.accessToken);
    return await fetchUser(id: user.id);
  }

  Future<void> signOut() async {
    final response = await supabase.auth.signOut();

    // if (response.user != null) {
    //   _logger.e(response.error!.message);
    //   return;
    // }
    // _logger.i(response.rawData);
    await _localStorageService.removeItem('token');
    return;
  }

  Future<AppUser?> fetchUser({required String id}) async {
    final response = await supabase
        .from("app_users")
        .select()
        .eq('id', id)
        .single()
        .execute();

    _logger.i(
      'Count: ${response.count}, Status: ${response.status}, Data: ${response.data}',
    );

    if (response.data != null) {
      _logger.e(response.data);
      return null;
    }

    _logger.i(response.data);
    final data = AppUser.fromJson(response.data);
    _user = data;

    return data;
  }

  Future<PostgrestResponse> _createUser(User user, AuthDto payload) {
    return supabase
        .from("app_users")
        .insert(
          AppUser(
            id: user.id,
            name: payload.name!,
            email: user.email.toString(),
          ),
        )
        .execute();
  }
}
