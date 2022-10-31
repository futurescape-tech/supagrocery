import 'package:logger/logger.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supagrocery/app/app.locator.dart';
import 'package:supagrocery/app/supabase_api.dart';
import 'package:supagrocery/services/authentication_service.dart';

abstract class SupabaseService<T> {
  final _authService = locator<AuthenticationService>();
  final _logger = Logger();

  String tableName() {
    return "";
  }

  Future<PostgrestResponse> all() async {
    _logger.i(tableName());
    final response = await supabase
        .from(tableName())
        .select()
        .eq('created_by', _authService.user!.id);
    return response;
  }

  Future<PostgrestResponse> find(String id) async {
    _logger.i(tableName() + ' ' + id);
    final response = await supabase
        .from(tableName())
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  Future<PostgrestResponse> create(Map<String, dynamic> json) async {
    _logger.i(tableName() + ' ' + json.toString());
    final response = await supabase.from(tableName()).insert(json);
    return response;
  }

  Future<PostgrestResponse> update({
    required String id,
    required Map<String, dynamic> json,
  }) async {
    _logger.i(tableName() + ' ' + json.toString());
    final response =
        await supabase.from(tableName()).update(json).eq('id', id);
    return response;
  }

  Future<PostgrestResponse> delete(String id) async {
    _logger.i(tableName() + ' ' + id);
    final response =
        await supabase.from(tableName()).delete().eq('id', id);
    return response;
  }
}
