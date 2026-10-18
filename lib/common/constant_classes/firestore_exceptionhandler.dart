// lib/common/services/firestore_exception_handler.dart
import 'package:firebase_core/firebase_core.dart';

class FirestoreExceptionHandler {
  static String handle(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return "You don't have permission to access this data.";
      case 'unavailable':
        return "Firestore service is currently unavailable. Please try again later.";
      case 'cancelled':
        return "Operation was cancelled by the server.";
      case 'invalid-argument':
        return "Invalid request data provided.";
      case 'deadline-exceeded':
        return "Request timed out. Please check your connection.";
      case 'not-found':
        return "Requested document not found.";
      case 'already-exists':
        return "Document already exists with these credentials.";
      case 'resource-exhausted':
        return "Resource limit exceeded. Please try again later.";
      case 'failed-precondition':
        return "Operation rejected due to invalid document state.";
      case 'aborted':
        return "Operation aborted by the system.";
      case 'out-of-range':
        return "Operation value is out of valid range.";
      case 'unimplemented':
        return "This operation is not supported.";
      case 'internal':
        return "Internal Firestore error occurred.";
      case 'data-loss':
        return "Unrecoverable data loss or corruption occurred.";
      case 'unauthenticated':
        return "User authentication required for this operation.";
      default:
        return "Firestore error: ${e.message ?? 'Unknown error'}";
    }
  }
}
