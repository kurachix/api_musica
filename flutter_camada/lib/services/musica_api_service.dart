import 'package:get/get.dart';
import '../models/musica_model.dart';

class MusicaApiService extends GetConnect {
  // URL base padrão da API FastAPI (10.0.2.2 para emulador Android, localhost para Windows/Web)
  final String urlBase;

  MusicaApiService({this.urlBase = 'http://127.0.0.1:8000'}) {
    httpClient.baseUrl = urlBase;
    httpClient.timeout = const Duration(seconds: 10);
  }

  /// 1. Listar todas as músicas
  /// GET /musicas
  Future<List<Musica>> listar() async {
    final response = await get('/musicas');

    if (response.status.hasError) {
      throw Exception('Erro ao listar músicas: ${response.statusText}');
    }

    final List<dynamic> dados = response.body is List ? response.body : [];
    return dados.map((item) => Musica.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// 2. Buscar música por ID
  /// GET /musicas/{id}
  Future<Musica?> buscarPorId(int id) async {
    final response = await get('/musicas/$id');

    if (response.statusCode == 404) {
      return null;
    }

    if (response.status.hasError) {
      throw Exception('Erro ao buscar música: ${response.statusText}');
    }

    return Musica.fromJson(response.body as Map<String, dynamic>);
  }

  /// 3. Cadastrar nova música
  /// POST /musicas
  Future<Musica> cadastrar(Musica musica) async {
    final response = await post('/musicas', musica.toJson());

    if (response.status.hasError) {
      throw Exception('Erro ao cadastrar música: ${response.statusText}');
    }

    return Musica.fromJson(response.body as Map<String, dynamic>);
  }

  /// 4. Atualizar música existente
  /// PUT /musicas/{id}
  Future<Musica> atualizar(int id, Musica musica) async {
    final response = await put('/musicas/$id', musica.toJson());

    if (response.status.hasError) {
      throw Exception('Erro ao atualizar música: ${response.statusText}');
    }

    return Musica.fromJson(response.body as Map<String, dynamic>);
  }

  /// 5. Excluir música
  /// DELETE /musicas/{id}
  Future<bool> excluir(int id) async {
    final response = await delete('/musicas/$id');

    if (response.statusCode == 204 || response.statusCode == 200) {
      return true;
    }

    if (response.statusCode == 404) {
      return false;
    }

    throw Exception('Erro ao excluir música: ${response.statusText}');
  }
}
