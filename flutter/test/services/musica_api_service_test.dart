import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_musica/models/musica_model.dart';
import 'package:flutter_musica/services/musica_api_service.dart';

void main() {
  group('Testes da Camada MusicaApiService (GetConnect)', () {
    late MusicaApiService apiService;

    setUp(() {
      apiService = MusicaApiService(urlBase: 'http://127.0.0.1:8000');
    });

    test('Inicialização do serviço com URL base', () {
      expect(apiService.urlBase, 'http://127.0.0.1:8000');
      expect(apiService.httpClient.baseUrl, 'http://127.0.0.1:8000');
      expect(apiService.httpClient.timeout, const Duration(seconds: 10));
    });

    test('Estrutura de dados para cadastro', () {
      final novaMusica = Musica(
        titulo: 'Cheia de Manias',
        artista: 'Raça Negra',
        album: 'Raça Negra',
        ano: 1992,
      );

      final payload = novaMusica.toJson();
      expect(payload['titulo'], 'Cheia de Manias');
      expect(payload['artista'], 'Raça Negra');
      expect(payload['album'], 'Raça Negra');
      expect(payload['ano'], 1992);
    });

    test('Parsing de lista de músicas', () {
      final List<dynamic> respostaSimulada = [
        {
          'id': 1,
          'titulo': 'Evidências',
          'artista': 'Chitãozinho & Xororó',
          'album': 'Cowboy do Asfalto',
          'ano': 1990,
        },
        {
          'id': 2,
          'titulo': 'Tempo Perdido',
          'artista': 'Legião Urbana',
          'album': 'Dois',
          'ano': 1986,
        }
      ];

      final musicas = respostaSimulada
          .map((item) => Musica.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(musicas.length, 2);
      expect(musicas[0].id, 1);
      expect(musicas[0].titulo, 'Evidências');
      expect(musicas[1].id, 2);
      expect(musicas[1].titulo, 'Tempo Perdido');
    });
  });
}
