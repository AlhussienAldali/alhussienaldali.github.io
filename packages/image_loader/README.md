# image_loader

Mobile Engineer Take-Home
# Link to video
You can watch the app in action [here](https://github.com/AlhussienAldali/image_loader/tree/main/vido_clip).

# Image

The app uses the cached_network_image package to efficiently load and cache large remote images.
This improves perceived performance and avoids unnecessary network requests when images are reused.

# API Call & Architecture

I structured networking in a way that balances scalability with simplicity:

* **Network Service** – a generic service responsible for all HTTP concerns.
* **Feature Repository** – exposes domain-specific methods to the UI layer, such as fetchFromApi().


This separation isolates API concerns, makes the UI independent from data sources, and keeps the architecture intentionally minimal for a single-screen app.


# State Management

**ChangeNotifier** was chosen as a lightweight state management solution.

* It handles:
* loading states
* error handling
* image fetching

derived UI state (background color)

This approach keeps business logic out of the UI while avoiding unnecessary complexity for a small app.

# Color Extraction

The dominant background color is extracted from a downscaled version of the image to balance performance and accuracy.
Downscaling reduces processing cost while preserving overall color distribution, enabling smooth background transitions without blocking the UI.

# Error Handling

Errors are handled at two distinct levels:

* API Errors – if the image endpoint fails or returns an invalid response, an error message is displayed to the user.
* 
* Image Loading Errors – if the image URL is valid but the image fails to load (network issues, decoding errors), a fallback broken image icon is shown.

This separation ensures clearer feedback and a resilient user experience.

# Light & Dark Mode Handling

The app adapts to light and dark mode through visualizations, not hard-coded theme colors:

* While loading, the background uses light or dark colors derived from the current mode.
* Once the image is loaded, the dominant color from the image drives the background.
* Foreground elements like the loader, buttons, and borders automatically select colors with sufficient contrast against the current background, maintaining readability and accessibility.

# Design Decisions

* Minimal but Scalable Architecture – separated network service, repository, and UI layers without forcing additional abstraction.
* ChangeNotifier for State – lightweight, simple, and sufficient for a single-screen app.
* Dynamic Background – computed from the image’s dominant color for an immersive experience.
* Foreground Contrast – dynamically determined based on background color to ensure visibility across light/dark modes.
* User Experience – smooth transitions, placeholder while loading, clear feedback on errors, and cached images for performance.
* Simplicity – no unnecessary frameworks or boilerplate; every layer has a clear responsibility.

# Text and URLs

All static text strings and URLs are stored in a separate file for simplicity and maintainability.
This keeps the UI code clean and allows for easy updates or localization in the future.
