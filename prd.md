

🌦  MAUSAM
Hawaman
India Hyperlocal Weather App
Product Requirements Document
Version 2.0  ·  June 2026  ·  Flutter Edition
Classification
Internal / Confidential
Status
Draft — Ready for Flutter Development
Platform
Android (Flutter 3.x)
Budget
₹0 ongoing (₹1,700 one-time Play Store)
Target Markets
All of India incl. rural villages
Previous Stack
React 18 + Vite PWA (deprecated)
Prepared By
Product Team


1. Executive Summary
Mausam (Hawaman) is a zero-cost, open-source, hyperlocal weather Android app built specifically for India — including the smallest villages. It aggregates multiple free forecast models, runs a confidence engine across them, and surfaces weather in a language and format that Indian users (including farmers) actually act on.

The Core Problem We Solve
• Generic weather apps show one forecast model with no uncertainty signal
• Rural India users get low-accuracy forecasts because grid resolution is poor
• Farmers need actionable data (spray windows, soil moisture) — not just temperature
• Most apps cost money to run at scale (API keys, servers, databases)
• PWA-based apps suffer from inconsistent UI across Android devices (overflow bugs, slow rendering)

1.1 Why Flutter (Stack Change from v1.0)
Version 1.0 specified a React PWA stack. This version migrates to Flutter for the following reasons:
Pixel-perfect layout engine — Flutter's Skia/Impeller renderer produces identical UI on all Android devices; CSS-based PWA layouts produce overflow and rendering bugs across different phones
Real push notifications — FCM (Firebase Cloud Messaging) works natively; PWA notifications are unreliable on Android Chrome
Play Store distribution — Flutter produces a proper APK/AAB; PWAs cannot be listed on Play Store without workarounds
Background sync and home screen widgets — WorkManager and home_widget packages enable background weather refresh and a lock screen / home widget
Performance on low-end hardware — Native Dart code with no JS bridge overhead runs significantly smoother on Redmi 12C / Realme Narzo N55 class devices

1.2 Mission Statement
Deliver the most accurate, most honest, and most actionable weather information to every Indian — from Mumbai to the smallest village in Nagaland — at zero infrastructure cost, forever.

1.3 Key Differentiators
Multi-model confidence engine — show probability, not just a single forecast
Honest uncertainty — tell users when models disagree
Farming mode — pesticide spray windows, soil moisture, growing conditions
Offline-first — works on 2G / intermittent internet via Drift local cache
Push notifications — rain alerts, spray window reminders via FCM
Home screen widget — current temp + rain probability without opening app
Version-controlled with GitHub — auto-notify users of updates
₹0 to build, ₹0 to run per month, forever


2. Product Vision & Goals
2.1 Vision
A farmer in rural Vidarbha should be able to open Mausam on a ₹3,000 Android phone with patchy internet, see rain probability for the next 48 hours with a confidence level, decide whether to spray pesticide tomorrow, receive a push notification if rain is incoming overnight, and trust that number — all without a single rupee going to any server or API vendor.

2.2 Business Goals
#
Goal
Success Metric
Status
G1
Cover all of India at hyperlocal resolution
GPS → forecast in < 2 sec for any coordinate
Phase 1
G2
Multi-model confidence display
Minimum 3 models compared on every forecast
Phase 1
G3
Farming features live at launch
Spray window + soil moisture on day-1
Phase 2
G4
Zero infrastructure cost
₹0/month confirmed for 12 months post-launch
All phases
G5
Push notification system
Rain alert delivered within 15 min of threshold
Phase 3
G6
Offline capability
Last forecast always shown with zero connectivity
Phase 1
G7
Home screen widget
1×2 widget showing temp + rain probability
Phase 3
G8
Play Store ready
Signed AAB, screenshots, listing ready
Phase 4


3. Tech Stack — Flutter Edition — ₹0 Forever
3.1 Architecture Overview
Architecture Principle
Pure client-side Flutter app → free APIs. No backend. No custom server. No database server.
Device does all computation. APIs are free-tier forever.
Result: ₹0/month regardless of number of users.
Distribution: APK sideload (free) or Play Store (₹1,700 one-time developer fee).

Layer
Technology
Cost
Why
App Framework
Flutter 3.x + Dart
₹0
Pixel-perfect, same UI on all Android phones
State Management
Riverpod 2.x
₹0
Scalable, testable, no boilerplate
Local Database
Drift (SQLite)
₹0
Typed SQL, easy future Supabase migration
HTTP Client
Dio + flutter_cache_manager
₹0
Interceptors, retry, disk cache
Primary Weather API
Open-Meteo
₹0, no key
Best free API for India, 5 models
Air Quality
Open-Meteo AQI
₹0
PM2.5, PM10, AQI built-in
Radar / Satellite
RainViewer API
₹0 free tier
Live rain radar tiles
Geocoding
Nominatim (OSM)
₹0
Reverse geocoding, village-level
Maps
flutter_map + OpenStreetMap
₹0
No Google Maps billing, Leaflet equivalent
Push Notifications
FCM + firebase_messaging
₹0 free tier
Real Android push, reliable delivery
Local Notifications
flutter_local_notifications
₹0
Scheduled rain alerts
Home Widget
home_widget package
₹0
Android home screen weather widget
Background Sync
workmanager package
₹0
Refresh forecast in background
Animations
Flutter built-in + Lottie
₹0
60fps weather animations
Version Control
GitHub + Releases API
₹0
Update notifications
CI/CD
GitHub Actions → APK build
₹0
Auto-build on push
Distribution
APK / Google Play Store
₹0 / ₹1,700 one-time
Sideload free, Play Store one-time fee

3.2 Flutter Layout Safety Rules (Non-Negotiable)
⚠  Anti-Overflow Rules — Enforced from Day 1
• NEVER use fixed width/height in dp — always use LayoutBuilder or MediaQuery
• NEVER put a Column inside a Column without Expanded or Flexible on inner children
• ALL Text widgets must have overflow: TextOverflow.ellipsis and softWrap: true
• Horizontal scroll only in explicitly designated ListView.horizontal containers
• Use Flexible/Expanded inside Row/Column — never let children overflow their parent
• SingleChildScrollView + Column: always set physics and never nest unbounded heights
• Test on: 360dp (Redmi 12C), 390dp, 412dp, 430dp screen widths minimum
• Use flutter_screenutil or MediaQuery.of(context).size for all sizing

3.3 Local Database Schema (Drift / SQLite)
Flat relational schema — mirrors the original IndexedDB design for clean future migration to Supabase/PostgreSQL.

Table
Key Columns
Purpose
locations
id, name, lat, lng, is_default, district, state
Saved user locations
weather_forecasts
id, location_id, fetched_at, model, hourly_json, daily_json
Cached forecast per model
aqi_records
id, location_id, fetched_at, aqi, pm25, pm10, uv_index
Air quality cache
farming_logs
id, location_id, date, spray_windows_json, soil_moisture, crop
Farming mode data

3.4 Multi-Model Confidence Engine
This is the secret sauce. Instead of showing one forecast, fetch 3–5 models simultaneously and compute agreement. Logic is identical to v1.0 — only the implementation language changes from JS to Dart.

Model
Source
Strength
India Coverage
GFS (NOAA)
Open-Meteo
Global baseline
Full ✅
ICON (DWD)
Open-Meteo
Very good tropics
Full ✅
ECMWF-IFS
Open-Meteo
Gold standard
Full ✅
GEM (Canada)
Open-Meteo
Good monsoon
Full ✅
ERA5 Historical
Open-Meteo
Ground truth baseline
Full ✅

Confidence Algorithm (Dart Implementation)
1. Fetch rain probability from all 4 active models for each hour
2. Compute mean and standard deviation across models
3. If std deviation < 10%  →  HIGH confidence (models agree)
4. If std deviation 10–25%  →  MEDIUM confidence
5. If std deviation > 25%  →  LOW confidence (models disagree)
6. Display: Rain probability 78%  │  Confidence: HIGH  │  4/4 models agree


4. Feature Requirements
4.1 Phase 1 — Core (Launch)
F1 — Location & Search
Auto-detect location via GPS using geolocator package (with permission)
Manual search: city name, village name, PIN code via Nominatim
Save multiple locations in Drift locations table
Reverse geocode to show village/district/state name
Works for any GPS coordinate in India — including unmapped villages

F2 — Current Weather Widget
Temperature (°C), feels-like temperature
Sky condition with animated Lottie icon (sunny, cloudy, rain, thunderstorm, fog, haze)
Humidity, wind speed + direction, UV Index
Heat Index (feels hotter — critical for Indian summers)
Visibility
Last updated timestamp with auto-refresh every 15 minutes via WorkManager

F3 — Hourly Forecast (48 hours)
Horizontal ListView.horizontal card strip — no overflow, touch-friendly
Rain probability per hour with confidence badge
Temperature curve using fl_chart
Wind gusts
"Best time to go out" smart suggestion

F4 — 7-Day Daily Forecast
Min/max temperature
Rain probability with confidence level
Dominant weather condition with icon
Day-of-week label

F5 — Multi-Model Confidence Display
Show rain probability from each model as horizontal LinearProgressIndicator bars
Overall confidence: HIGH / MEDIUM / LOW badge (color coded)
"X of Y models predict rain" human summary
Tap to expand → show individual model values
Educate user: "Why models sometimes disagree" tooltip/bottom sheet

F6 — Rain Radar
Embedded RainViewer radar tiles on flutter_map + OpenStreetMap
Animated — shows last 2 hours of rain movement
User location pinned on map
Play/pause animation control
No horizontal scroll — constrained to card bounds

F7 — Air Quality Index (AQI)
Overall AQI number with color chip (Good / Moderate / Unhealthy / Hazardous)
PM2.5, PM10 values
UV Index with "protection needed" recommendation
Health advisory: "Avoid outdoor exercise" / "Wear mask" etc.
Source: Open-Meteo air quality API (free, no key)

4.2 Phase 2 — Farming Mode (Priority for Rural India)
Why Farming Mode Matters
India has 140 million farming households.
A farmer's #1 question: "Can I spray pesticide tomorrow?" — not "What is the temperature?"
Farming mode answers the questions farmers actually have.

F8 — Spray Window Recommendation
Show green/yellow/red Container cards for each hour of next 48 hours
GREEN: Wind < 15 km/h + No rain in next 4 hours + Humidity < 80%
YELLOW: Marginal conditions — spray with caution
RED: Do not spray (rain imminent, wind too high, humidity too high)
Hindi/regional language label option via flutter_localizations

F9 — Soil Moisture Estimate
Derived from last 7-day rainfall + evapotranspiration from Open-Meteo
Show: Low / Medium / High / Waterlogged
Irrigation recommendation: "No irrigation needed today"

F10 — Growing Conditions
Temperature suitability for common crops (wheat, rice, cotton, sugarcane)
User selects crop from a DropdownButton
Show: Ideal / Acceptable / Stressful for current conditions

4.3 Phase 3 — Notifications & Widgets
F11 — Push Rain Alerts (FCM)
User sets rain alert threshold (e.g., notify if rain probability > 70%)
WorkManager background job checks forecast every hour
If threshold met → trigger local notification via flutter_local_notifications
FCM used for future server-side alerts when Play Store version is live
₹0 — FCM free tier is unlimited for this use case

F12 — Home Screen Widget
1×2 Android widget showing: location name, current temp, rain probability
Tap widget → opens app to full forecast
Updated by WorkManager background task every 30 minutes
Implemented via home_widget package

F13 — GitHub-Based Version Check & Update Banner
On app launch, fetch latest release from GitHub Releases API
Compare with APP_VERSION constant embedded at build time
If newer → show dismissible update SnackBar / Banner widget
Banner text: "Mausam v1.2 is available — update on Play Store"
GitHub API free tier: 60 requests/hour/IP — more than sufficient


5. UX & Design Requirements
5.1 Flutter Layout Safety — No Overflow Ever
Anti-Overflow Rules (Non-Negotiable — Flutter Specific)
• Use LayoutBuilder at page level to get real screen constraints
• Wrap all Row children in Expanded or Flexible — never let text overflow
• Use ListView.builder for all lists — never Column inside SingleChildScrollView for long lists
• Text widgets: always set overflow: TextOverflow.ellipsis, maxLines where appropriate
• Images: use BoxFit.cover inside SizedBox or AspectRatio — never unconstrained Image
• Test on: Redmi 12C (360dp), Samsung A-series (412dp), OnePlus (430dp)
• Horizontal scroll only in ListView.horizontal — never in unconstrained Row

5.2 Design System
Token
Value
Usage
primaryColor
#1A56DB (Blue)
AppBar, CTAs, confidence HIGH badge
successColor
#065F46 (Green)
Good AQI, spray window OK, HIGH confidence
warningColor
#92400E (Amber)
MEDIUM confidence, caution
dangerColor
#991B1B (Red)
LOW confidence, spray window RED
borderRadius
16px
All Cards — friendly, modern feel
fontDisplay
Mukta (Google Fonts)
Supports Devanagari for Hindi labels
fontBody
Inter / Mukta
All body text

5.3 Accessibility
Minimum tap target: 48×48dp — all InkWell and GestureDetector areas
Color is never the only indicator — always pair with text label or icon
Semantics widget wrapping all weather icons for screen reader support
Respect system font scale — use sp units, not dp for text
Dark mode support via ThemeData with both light and dark ColorScheme


6. Project Structure & GitHub Workflow
6.1 Flutter Directory Structure
mausam/
  ├── lib/
  │   ├── main.dart
  │   ├── app.dart                    # MaterialApp + Riverpod ProviderScope
  │   ├── core/
  │   │   ├── constants.dart          # APP_VERSION, API base URLs
  │   │   ├── theme.dart              # ThemeData light + dark
  │   │   └── router.dart             # go_router route definitions
  │   ├── features/
  │   │   ├── weather/               # F2, F3, F4 — current + forecast
  │   │   ├── confidence/            # F5 — multi-model engine
  │   │   ├── radar/                 # F6 — RainViewer + flutter_map
  │   │   ├── aqi/                   # F7 — air quality
  │   │   ├── farming/               # F8, F9, F10 — farming mode
  │   │   ├── notifications/         # F11 — FCM + local notifications
  │   │   └── location/              # F1 — GPS + search + saved
  │   ├── data/
  │   │   ├── db/                    # Drift schema + DAOs
  │   │   ├── api/                   # Dio clients for Open-Meteo, RainViewer
  │   │   └── repositories/          # Data layer abstractions
  │   └── widgets/                   # Shared UI components
  ├── android/                       # Android-specific config
  ├── test/                          # Unit + widget tests
  ├── .github/workflows/             # CI/CD — build APK on push
  └── pubspec.yaml

6.2 Key pubspec.yaml Dependencies
Package
Version
Purpose
Cost
flutter_riverpod
^2.x
State management
₹0
drift
^2.x
Local SQLite database
₹0
dio
^5.x
HTTP client with interceptors
₹0
flutter_cache_manager
^3.x
Disk cache for API responses
₹0
flutter_map
^6.x
OSM maps (Leaflet equivalent)
₹0
geolocator
^11.x
GPS location
₹0
firebase_messaging
^14.x
FCM push notifications
₹0
flutter_local_notifications
^17.x
Local scheduled alerts
₹0
home_widget
^0.x
Android home screen widget
₹0
workmanager
^0.x
Background sync tasks
₹0
fl_chart
^0.x
Temperature/rain charts
₹0
lottie
^3.x
Animated weather icons
₹0
go_router
^13.x
Navigation / routing
₹0
google_fonts
^6.x
Mukta + Inter fonts
₹0
flutter_localizations
SDK
Hindi + English i18n
₹0

6.3 Versioning Strategy
Semantic versioning: MAJOR.MINOR.PATCH (e.g. v1.2.3) — same as v1.0 PRD
MAJOR: Breaking change or major feature overhaul
MINOR: New feature added (farming mode, notification type, new widget)
PATCH: Bug fix, data source update, UI polish
Every GitHub Release includes: version tag, changelog, APK asset attached

6.4 CI/CD Pipeline (Free)
Step
Tool
Output
Cost
Code push → lint + test
GitHub Actions
Pass/fail status
₹0
PR → build debug APK
GitHub Actions + Flutter
APK artifact
₹0
Merge to main → release APK
GitHub Actions + Flutter
Signed APK on GitHub Release
₹0
GitHub Release created
GitHub Releases API
App fetches version on next launch
₹0


7. Non-Functional Requirements
Category
Requirement
Target
Flutter Approach
Performance
App startup time
< 2 sec cold start
Deferred loading, lazy Riverpod providers
Performance
Scroll frame rate
60fps on Redmi 12C
ListView.builder, const widgets
Performance
API → UI render
< 3 sec on 3G
Skeleton loaders while fetching
Reliability
Offline display
Always shows last cached data
Drift local DB serves stale data
Reliability
API fallback
If one model fails, show others
Dio retry + per-model error handling
Layout
No overflow errors
Zero RenderFlex overflow on any device
LayoutBuilder + Flexible discipline
Privacy
No server-side user data
All data on device only
Drift only, no custom backend
Cost
Monthly infra cost
₹0.00
All free-tier APIs + no backend
i18n
Language support Phase 1
English + Hindi labels
flutter_localizations + ARB files
Notifications
Rain alert latency
< 15 min from threshold
WorkManager 15-min minimum interval


8. Development Phases & Milestones
Phase 1 — Foundation (Week 1–2)
Flutter project setup: Riverpod, Drift, Dio, go_router, theme
F1: Location detection (geolocator) + Nominatim reverse geocoding + search
F2: Current weather widget (Open-Meteo, single model first)
F3: Hourly forecast ListView.horizontal strip
F4: 7-day daily forecast
F13: GitHub version check + update banner
GitHub Actions CI: lint + build APK on every push
Milestone: Working APK installable via sideload

Phase 2 — Intelligence (Week 3–4)
F5: Multi-model confidence engine (GFS + ICON + ECMWF in Dart)
F6: Rain radar (RainViewer tiles on flutter_map)
F7: AQI widget (Open-Meteo air quality endpoint)
Drift caching layer: weather_forecasts + aqi_records tables
Layout audit: test on 5 different Android screen sizes, fix all overflows

Phase 3 — Notifications & Widgets (Week 5–6)
F11: FCM setup + WorkManager background job + local rain alert notifications
F12: Home screen widget via home_widget package
F8: Spray window recommendation engine
F9: Soil moisture estimate
F10: Crop growing conditions
Hindi language labels for farming widgets

Phase 4 — Polish & Play Store (Week 7–8)
Lottie weather animations
Dark mode ThemeData
Accessibility audit — Semantics widgets, tap targets
Performance profiling with Flutter DevTools on Redmi 12C
Signed APK + AAB generation via GitHub Actions
Play Store listing: screenshots, description, icon
GitHub v1.0.0 release tag → APK published


9. Open Questions & Decisions Needed
#
Question
Options
Default
Q1
App name — Mausam or rename?
Mausam / Barish / SkyCast India
Mausam
Q2
Default language on first load?
English / Auto-detect system language
Auto-detect
Q3
Radar map style?
Dark tile / Satellite / Street map
Dark tile
Q4
Primary color theme?
Blue (sky) / Teal / Saffron accent
Blue #1A56DB
Q5
Farming mode — always visible or toggle?
BottomNavigationBar tab / toggle switch
Bottom tab
Q6
GitHub repo — public or private?
Public (open source) recommended
Public
Q7
FCM: local-only alerts or server-push?
WorkManager local / FCM server alerts
Local first
Q8
Play Store release timing?
Phase 4 / After 100 testers / On v1.0
Phase 4


10. Appendix — Key API Endpoints
Open-Meteo Weather (Primary)
Current + Hourly + Daily Forecast
GET https://api.open-meteo.com/v1/forecast
  ?latitude={lat}&longitude={lon}
  &current=temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m,uv_index
  &hourly=precipitation_probability,temperature_2m,wind_speed_10m
  &daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max
  &models=gfs_global,icon_global,ecmwf_ifs025,gem_global
  &timezone=Asia%2FKolkata

No API key required. Free forever.

GitHub Releases API (Version Check)
Version Check Endpoint
GET https://api.github.com/repos/{owner}/{repo}/releases/latest

Returns: { "tag_name": "v1.2.3", "body": "Changelog..." }
Compare tag_name with APP_VERSION constant in constants.dart
Rate limit: 60 requests/hour per IP — more than sufficient

RainViewer Radar
Radar Tiles Endpoint
Step 1: GET https://api.rainviewer.com/public/weather-maps.json
         → Returns list of available radar timestamps

Step 2: Use flutter_map TileLayer with URL:
  https://tilecache.rainviewer.com/v2/radar/{timestamp}/512/{z}/{x}/{y}/6/1_1.png

Animate last 5 timestamps for rain movement visualization.
Free tier: unlimited tiles. No API key required.

Firebase Cloud Messaging (FCM) — Push Notifications
FCM Setup (one-time)
1. Create Firebase project at console.firebase.google.com (free)
2. Add Android app with package name (e.g. com.mausam.app)
3. Download google-services.json → place in android/app/
4. Add firebase_messaging + flutter_local_notifications to pubspec.yaml
5. WorkManager job runs every 15 min → checks forecast → triggers local notification if rain threshold met

Cost: FCM free tier = unlimited messages. ₹0.

— End of PRD v2.0 — Flutter Edition —
Ready to build in Flutter 🚀
Confidential — Internal Use Only