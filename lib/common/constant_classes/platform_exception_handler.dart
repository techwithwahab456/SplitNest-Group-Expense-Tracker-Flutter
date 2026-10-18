// lib/common/services/platform_exception_handler.dart
import 'package:flutter/services.dart';

class PlatformExceptionHandler {
  static String handle(PlatformException e) {
    switch (e.code) {
      case 'sign_in_failed':
        return "Sign-in process failed. Please try again.";
      case 'network_error':
        return "Network error occurred. Please check your connection.";
      case 'operation_in_progress':
        return "An operation is already in progress. Please wait.";
      case 'invalid_token':
        return "Invalid authentication token. Please log in again.";
      case 'service_not_available':
        return "Required service is unavailable. Please try later.";
      case 'app_not_authorized':
        return "App is not authorized to use this service.";
      case 'keychain_error':
        return "Secure storage error. Please reinstall the app.";
      case 'billing_error':
        return "Billing service error. Check your payment settings.";
      case 'feature_not_supported':
        return "This feature is not supported on your device.";
      case 'permission_denied':
        return "Required permission was denied. Check app settings.";
      default:
        return "System error: ${e.message ?? 'Unknown platform error'}";
    }
  }

  static String handleStorage(PlatformException e) {
    if (e.code == 'object_not_found') {
      return "Requested file not found in storage.";
    } else if (e.code == 'bucket_not_found') {
      return "Storage bucket not found. Contact support.";
    } else if (e.code == 'project_not_found') {
      return "Cloud project not found. Contact support.";
    } else if (e.code == 'quota_exceeded') {
      return "Storage quota exceeded. Please free up space.";
    }
    return handle(e);
  }
}
