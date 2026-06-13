# Changelog

All notable changes to this project will be documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)  
Versioning: [Semantic Versioning](https://semver.org/)

## [Unreleased]

## [0.2.0] - 2026-06-13

### Added
- Android Glance widgets for quick glucose viewing from the launcher.
- Persistent notification preview for always-visible glucose status.
- Chart touch inspection for checking readings at a specific point in time.
- Local alert engine foundation, disabled by default.

### Changed
- Improved data refresh behavior for xDrip+ Local and Nightscout sources.
- Improved Home view controls, including glucose unit switching and clearer sync status.
- Refined the public preview scope to keep unreleased/internal features out of the repository.

## [0.1.0] - 2026-06-04

### Added
- Home page: real-time glucose reading, trend direction, insight banner
- History: calendar heatmap (90-day), weekly pattern, AGP detail
- Statistics: TIR / AGP / Glucotype / Personal Baseline
- Episodes: high/low episode detection and deep analysis
- Profile: personal baseline, data source configuration
- Settings: display, data, export
- Data sources: xDrip+ HTTP (Android), Nightscout (cross-platform), built-in mock
- Local SQLite cache with 5-minute background polling
- Pure-Dart analysis engine: TIR, CV, dawn detection, episode detector, Glucotype classifier
- Python mock Nightscout server (`mockserver/`) with 5 CGM scenario presets
