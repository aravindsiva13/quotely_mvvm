import '../../core/services/api_service.dart';
import '../models/document.dart';
import '../models/customer.dart';

class DocumentRepository {
  final MockApiService _apiService = MockApiService();

  Future<List<Document>> getDocuments() async {
    return await _apiService.getDocuments();
  }

  Future<Document> createDocument(Document document) async {
    return await _apiService.createDocument(document);
  }

  Future<Document> updateDocument(Document document) async {
    return await _apiService.updateDocument(document);
  }

  Future<void> deleteDocument(String documentId) async {
    return await _apiService.deleteDocument(documentId);
  }
}