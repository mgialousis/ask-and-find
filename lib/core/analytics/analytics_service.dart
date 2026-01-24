import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:pes_vres/core/config/analytics_config.dart';
import 'package:pes_vres/core/config/preferences_keys.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  static const String _deviceIdKey = 'analytics_device_id';

  bool _initialized = false;
  bool _enabled = false;

  Future<void> initialize() async {
    if (_initialized) return;

    if (AnalyticsConfig.apiKey.isEmpty) {
      _initialized = true;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(PreferencesKeys.analyticsEnabled) ?? true;

    final shouldSend = _enabled && _allowDebugOrRelease();

    final config = PostHogConfig(AnalyticsConfig.apiKey)
      ..host = AnalyticsConfig.host
      ..captureApplicationLifecycleEvents = true
      ..debug = !kReleaseMode
      ..optOut = !shouldSend;

    await Posthog().setup(config);

    await _registerSuperProperties();
    await _identifyDevice();

    _initialized = true;
  }

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;

    if (!AnalyticsConfig.allowDebug && !kReleaseMode) {
      return;
    }

    if (!_initialized) {
      return;
    }

    if (enabled) {
      await Posthog().enable();
      await _identifyDevice();
    } else {
      await Posthog().disable();
    }
  }

  Future<void> capture(
    String eventName, {
    Map<String, Object>? properties,
  }) async {
    if (!_shouldCapture()) return;
    await Posthog().capture(eventName: eventName, properties: properties);
  }

  Future<void> setUserProperties(Map<String, Object> properties) async {
    if (!_shouldCapture()) return;
    final deviceId = await _getOrCreateDeviceId();
    await Posthog().identify(userId: deviceId, userProperties: properties);
  }

  bool _allowDebugOrRelease() => kReleaseMode || AnalyticsConfig.allowDebug;

  bool _shouldCapture() {
    if (!_initialized) return false;
    if (AnalyticsConfig.apiKey.isEmpty) return false;
    if (!_allowDebugOrRelease()) return false;
    return _enabled;
  }

  Future<void> _identifyDevice() async {
    if (!_shouldCapture()) return;
    final deviceId = await _getOrCreateDeviceId();
    await Posthog().identify(userId: deviceId);
  }

  Future<void> _registerSuperProperties() async {
    final info = await PackageInfo.fromPlatform();
    await Posthog().register('app_version', info.version);
    await Posthog().register('build_number', info.buildNumber);
    await Posthog().register('platform', Platform.operatingSystem);
    await Posthog().register('os_version', Platform.operatingSystemVersion);
    await Posthog().register('locale', Platform.localeName);
    await Posthog().register('timezone', DateTime.now().timeZoneName);
    await Posthog().register('release_channel', _releaseChannel());
  }

  Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final deviceId = const Uuid().v4();
    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }

  String _releaseChannel() {
    if (kReleaseMode) return 'release';
    if (kProfileMode) return 'profile';
    return 'debug';
  }
}
