Here is a concise `README.md` you can put in the project root:

```markdown
# yt_dlp_test

A Flutter experiment to play **YouTube music audio in the background** on Android using `youtube_explode_dart` and `just_audio`.

## What this app does

- Takes a YouTube video URL (e.g. `https://youtu.be/jWJQl-9n3XA` – *Sirivennela*).  
- Uses `youtube_explode_dart` to:
  - Resolve the video ID and metadata.
  - Fetch available stream manifest.
  - Select the best muxed (audio+video) stream URL. [web:25]
- Uses `just_audio` to:
  - Load the selected stream URL.
  - Play/pause audio, including with the screen off (background audio). [web:13]

## Tech stack

- **Flutter** (stable channel, Android target). [attached_file:1]
- **Packages:**
  - `youtube_explode_dart` – YouTube stream extraction without official API. [web:25]
  - `just_audio` – Low-level audio player built on ExoPlayer for Android. [web:13]
  - `http` – Basic HTTP client used with custom `HttpOverrides` for headers. [web:65]

## How it was created

1. **Created a new Flutter app**

   ```bash
   flutter create yt_dlp_test
   cd yt_dlp_test
   ```

2. **Added dependencies**

   ```bash
   flutter pub add youtube_explode_dart
   flutter pub add just_audio
   flutter pub add http
   ```

3. **Implemented main logic**

   - In `lib/main.dart`:
     - Built a simple UI with:
       - `TextField` for YouTube URL input.
       - Button: “Extract & Play Audio”.
       - Log area to show title, duration, quality, errors.
       - Play/Pause controls.
     - Created a `YoutubeExplode` instance to:
       - `videos.get(url)` → get video info.
       - `streamsClient.getManifest(video.id)` → get manifest.
       - `manifest.muxed.withHighestBitrate()` → pick the best stream. [web:25]
     - Wired the picked URL into `AudioPlayer.setUrl(...)` from `just_audio`, then called `play()`. [web:13]

4. **Handled 403 (Forbidden) issues**

   - Added a custom `HttpOverrides` to set a desktop-like User-Agent to avoid some 403 responses from YouTube when streaming directly. [web:28]

5. **Tested on real device**

   - Ran with `flutter run` on Android device.
   - Verified:
     - Audio extraction works for the target music video.
     - Playback continues when screen is off (background audio behavior is provided by `just_audio`/ExoPlayer). [web:13]

## How to run this project

1. Clone the repository:

   ```bash
   git clone https://github.com/<your-username>/yt_dlp_test.git
   cd yt_dlp_test
   ```

2. Get packages:

   ```bash
   flutter pub get
   ```

3. Run on Android device:

   ```bash
   flutter run
   ```

4. In the app:
   - Paste a YouTube URL.
   - Tap **Extract & Play Audio**.
   - Use play/pause buttons to control playback.

## Notes / Limitations

- YouTube’s streaming mechanisms can change; `youtube_explode_dart` may occasionally need updates to keep working reliably. [web:29]
- This project is for **learning and experimentation**; ensure you respect YouTube’s Terms of Service and copyright when using or distributing it. [web:28]
```