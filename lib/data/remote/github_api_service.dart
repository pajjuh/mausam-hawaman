import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import 'dio_client.dart';

/// Service to check for app updates via GitHub Releases API
class GitHubApiService {
  final Dio _dio;

  GitHubApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  /// Fetch the latest release version from GitHub
  /// Returns null if check fails (non-blocking)
  Future<GitHubRelease?> getLatestRelease() async {
    try {
      final url = ApiConstants.githubLatestRelease(
        AppConstants.githubOwner,
        AppConstants.githubRepo,
      );

      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        return GitHubRelease.fromJson(
            response.data as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      // Version check is non-critical — fail silently
      return null;
    }
  }

  /// Compare current version with latest release
  /// Returns true if an update is available
  static bool isUpdateAvailable(String currentVersion, String latestTag) {
    // Strip 'v' prefix if present
    final current = currentVersion.replaceFirst('v', '');
    final latest = latestTag.replaceFirst('v', '');

    final currentParts = current.split('.').map(int.tryParse).toList();
    final latestParts = latest.split('.').map(int.tryParse).toList();

    for (var i = 0; i < 3; i++) {
      final c = (i < currentParts.length ? currentParts[i] : 0) ?? 0;
      final l = (i < latestParts.length ? latestParts[i] : 0) ?? 0;
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  }
}

/// Parsed GitHub release info
class GitHubRelease {
  final String tagName;
  final String name;
  final String body;
  final String htmlUrl;
  final DateTime? publishedAt;

  const GitHubRelease({
    required this.tagName,
    required this.name,
    required this.body,
    required this.htmlUrl,
    this.publishedAt,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) {
    return GitHubRelease(
      tagName: json['tag_name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      htmlUrl: json['html_url']?.toString() ?? '',
      publishedAt: DateTime.tryParse(
          json['published_at']?.toString() ?? ''),
    );
  }
}
