import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bitacora_dto.dart';
import '../models/create_bitacora_request.dart';
import 'auth_service.dart';

class BitacoraService {
  static const String baseUrl = 'https://tiusr7pl.cuc-carrera-ti.ac.cr/api_bitacora/api/bitacora';

  // GET con filtros: /search?usuario=X&fecha=YYYY-MM-DD
  static Future<List<BitacoraDto>> getBitacorasFiltered(int? usuario, DateTime? fecha) async {
    final buffer = StringBuffer('$baseUrl/search?');
    if (usuario != null) {
      buffer.write('usuario=$usuario&');
    }
    if (fecha != null) {
      final fechaString = '${fecha.year}-${fecha.month.toString().padLeft(2,'0')}-${fecha.day.toString().padLeft(2,'0')}';
      buffer.write('fecha=$fechaString&');
    }

    final url = Uri.parse(buffer.toString());

    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
      'refreshToken': AuthService.refreshToken ?? '',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => BitacoraDto.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener bitácoras: ${response.statusCode} - ${response.body}');
    }
  }

  // POST: Crear bitácora
  static Future<BitacoraDto> createBitacora(CreateBitacoraRequest req) async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
      'refreshToken': AuthService.refreshToken ?? '',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(req.toJson());

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return BitacoraDto.fromJson(data);
    } else {
      throw Exception('Error al crear bitácora: ${response.statusCode} - ${response.body}');
    }
  }

  // GET sin filtro: /api/bitacora
  static Future<List<BitacoraDto>> getBitacoras() async {
    final url = Uri.parse(baseUrl);

    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
      'refreshToken': AuthService.refreshToken ?? '',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => BitacoraDto.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener bitácoras: ${response.statusCode} - ${response.body}');
    }
  }
}
