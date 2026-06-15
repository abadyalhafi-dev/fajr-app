# 🕌 منبه الفجر — Fajr Alarm & Prayer Calendar

A personal Android app that wakes you for Fajr with precise, daily-changing prayer times. Fully Arabic, RTL, dark-navy theme, works offline.

---

## ✨ Features

- **Offline prayer times** — calculated with the **Umm al-Qura** method, no internet needed for daily use.
- **Hybrid location** — fetches your GPS once, saves it, then works offline. A "تحديث الموقع" button re-fetches when you travel.
- **Fajr pre-alarm** — fires 15 min before Fajr (adjustable 5–45 min) with a softer sound.
- **Fajr main alarm** — fires exactly at Fajr with your chosen Adhan.
- **Other prayers** — individual on/off toggles, OFF by default.
- **Persistent alarm** — rings until you force-dismiss (no snooze).
- **Custom sounds** — pick any audio file from your phone for the Adhan and the pre-alarm.
- **Calendar** — monthly prayer times, Hijri + Gregorian dates, and personal events.
- **Arabic numerals**, **Tajawal** font, mosque + sunrise logo.

---

## 📦 How to build the APK on Codemagic (no PC install needed)

1. **Put this project on GitHub**
   - Create a free GitHub account.
   - Create a new repository and upload this entire `fajr_app` folder (use GitHub's "upload files" button in the browser — you can drag the whole folder).

2. **Connect Codemagic**
   - Go to [codemagic.io](https://codemagic.io) and sign up (free).
   - Click **Add application** → connect your GitHub → select the repo.
   - Codemagic will detect the included `codemagic.yaml` automatically.

3. **Build**
   - Pick the **"Build Fajr App APK"** workflow → **Start new build**.
   - Wait ~10–15 minutes. Codemagic runs `flutter pub get` then `flutter build apk --release`.

4. **Download the APK**
   - When it finishes, download the `.apk` from the build's **Artifacts** section.
   - (Optional) Edit `codemagic.yaml` and put your email in to get it sent automatically.

---

## 📲 How to install on your phone

1. Transfer the APK to your phone (email it to yourself, USB, or Google Drive).
2. Tap the APK file. Android will ask to allow installing from this source → **Allow**.
3. Open the app.

### ⚠️ Important — make the alarm reliable
Android aggressively limits background apps, which can stop alarms. On first launch the app will ask for permissions. Please grant **all** of them, and also do this manually once:

- **Notifications** → Allow
- **Alarms & reminders** (exact alarms) → Allow
- **Battery** → Settings → Apps → منبه الفجر → Battery → set to **Unrestricted** / disable optimization
- On Samsung/Xiaomi/Huawei/Oppo: also add the app to **"never sleeping apps"** / **auto-start** allowed list (these brands are the most aggressive).

Then open the **المنبه** tab → tap **"حفظ وتحديث التنبيهات"** to schedule everything.

---

## 🔊 Setting your sounds

1. Download a **Madinah Adhan** MP3 to your phone (search "Madinah Adhan mp3 download").
2. In the app: **المنبه** tab → **صوت أذان الفجر** → pick the file.
3. Do the same for **صوت التنبيه المبكر** (the softer pre-alarm) with any gentle tone.

> The app copies your chosen file into its own storage, so it keeps working even if you later move the original. A built-in fallback tone plays if you don't pick one.

---

## 🗂 Project structure

```
fajr_app/
├── pubspec.yaml            # dependencies
├── codemagic.yaml          # one-click cloud build config
├── lib/
│   ├── main.dart           # entry point, RTL + Arabic setup, alarm routing
│   ├── main_navigation.dart
│   ├── theme/app_theme.dart
│   ├── models/personal_event.dart
│   ├── services/
│   │   ├── prayer_service.dart    # Umm al-Qura offline calculation
│   │   ├── location_service.dart  # hybrid GPS
│   │   ├── alarm_service.dart     # scheduling + full-screen alarms
│   │   └── storage_service.dart   # local settings & events
│   ├── widgets/            # logo, countdown, prayer list
│   └── screens/            # home, calendar, alarm settings, settings, ringing
├── assets/sounds/          # fallback alarm tone
└── android/                # manifest (permissions), gradle, icons
```

---

## 🛠 If a build fails

Cloud builds sometimes hit a package-version snag. If Codemagic shows a red error, copy the error log and send it back — it's usually a one-line fix in `pubspec.yaml`. The first build is the one most likely to need a small tweak; after that it's smooth.

---

*Built for personal use. May Allah accept your prayers. 🤲*
