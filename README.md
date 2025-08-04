# HeadHunters

AI based CV and Job matching Flutter application.

## Overview

HeadHunters is a Flutter application designed to intelligently match job seekers with relevant job opportunities using AI-powered algorithms. The app aims to streamline the job-hunting process by leveraging advanced features such as CV parsing, personalized recommendations, and real-time notifications.

## Features

- **CV Upload & Parsing:** Job seekers can upload their CVs directly from their devices. The app parses and extracts relevant skills and experiences.
- **AI Job Matching:** Uses AI to match candidates with job postings that best fit their profiles.
- **Firebase Integration:** Utilizes Firebase services for authentication, cloud storage, Firestore database, and push notifications.
- **Google Sign-In:** Allows easy login and registration using Google accounts.
- **Personalized Notifications:** Get real-time updates about relevant job postings and application statuses.
- **Beautiful UI:** Uses custom fonts (Montserrat, Poppins) and a responsive design for a modern user experience.

## Tech Stack

- **Flutter** (Dart): Main application framework.
- **Firebase:** Authentication, Cloud Firestore, Storage, Cloud Messaging.
- **Provider:** State management.
- **Supporting Packages:** 
  - cupertino_icons
  - flutter_screenutil
  - flutter_spinkit
  - intl
  - google_fonts
  - dotted_border
  - file_picker
  - fluttertoast
  - shared_preferences
  - http
  - path_provider
  - permission_handler
  - file_saver
  - http_parser
  - mime
  - google_sign_in
  - image_picker

## Directory Structure

- `assets/`, `assets/images/`, `assets/dummy/`: App assets and images.
- `fonts/`: Custom fonts (Montserrat, Poppins) for enhanced UI.
- Main Dart source files and feature modules (not listed here, but organized for scalability).

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rajaumarr/HeadHunters.git
   cd HeadHunters
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files to the respective directories.
   - Set up your Firebase project as per the official docs.

4. **Run the app:**
   ```bash
   flutter run
   ```

## Contributing

Contributions, issues, and feature requests are welcome! Please open an issue or submit a pull request.

## License

[MIT](LICENSE)

---

*AI powered CV to job matching made simple!*
