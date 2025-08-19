import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/equipment.dart';
import '../models/consumption.dart';
import '../models/financial.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://sindipro-backend.onrender.com';
  final AuthService _authService = AuthService();

  // Equipment endpoints
  Future<List<Equipment>> getEquipment([String? condominium]) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final uri = condominium != null 
          ? Uri.parse('$baseUrl/api/equipment/?condominium=$condominium')
          : Uri.parse('$baseUrl/api/equipment/');
      
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Equipment.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        // Try to refresh token and retry
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return getEquipment(condominium);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to load equipment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Equipment> createEquipment(Map<String, dynamic> equipmentData) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/equipment/'),
        headers: headers,
        body: jsonEncode(equipmentData),
      );

      if (response.statusCode == 201) {
        return Equipment.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return createEquipment(equipmentData);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to create equipment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<MaintenanceRecord> addMaintenanceRecord(
      String equipmentId, Map<String, dynamic> recordData) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/equipment/$equipmentId/maintenance/'),
        headers: headers,
        body: jsonEncode(recordData),
      );

      if (response.statusCode == 201) {
        return MaintenanceRecord.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return addMaintenanceRecord(equipmentId, recordData);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to add maintenance record: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Consumption endpoints
  Future<List<ConsumptionReading>> getConsumptionReadings([String? condominium]) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final uri = condominium != null 
          ? Uri.parse('$baseUrl/api/consumption/readings/?condominium=$condominium')
          : Uri.parse('$baseUrl/api/consumption/readings/');
      
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ConsumptionReading.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return getConsumptionReadings(condominium);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to load consumption readings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<ConsumptionReading> addConsumptionReading(Map<String, dynamic> readingData) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/consumption/readings/'),
        headers: headers,
        body: jsonEncode(readingData),
      );

      if (response.statusCode == 201) {
        return ConsumptionReading.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return addConsumptionReading(readingData);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to add consumption reading: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Financial endpoints
  Future<MaintenanceBudget> getMaintenanceBudget(String condominium) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/financial/maintenance-budget/$condominium/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return MaintenanceBudget.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return getMaintenanceBudget(condominium);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to load maintenance budget: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<MaintenanceExpense> addMaintenanceExpense(Map<String, dynamic> expenseData) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/financial/maintenance-expenses/'),
        headers: headers,
        body: jsonEncode(expenseData),
      );

      if (response.statusCode == 201) {
        return MaintenanceExpense.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return addMaintenanceExpense(expenseData);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to add maintenance expense: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<String> uploadImage(File imageFile, String endpoint) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$endpoint'),
      );

      // Add headers manually since MultipartRequest doesn't use headers directly
      final token = await _authService.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data['url']; // Assuming the API returns the image URL
      } else if (response.statusCode == 401) {
        final refreshed = await _authService.refreshAccessToken();
        if (refreshed) {
          return uploadImage(imageFile, endpoint);
        } else {
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Failed to upload image: $responseBody');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}