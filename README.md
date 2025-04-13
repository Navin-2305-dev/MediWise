# 🩺 MediWise - Smart Healthcare Companion App

**MediWise** is an AI-powered healthcare mobile app built with **Flutter**. It enables users to analyze medical reports, detect symptoms, manage digital health records, and consult doctors via secure video calls — all in one place.

---

## ✨ Features

- 🔬 **AI Health Report Analysis** — Upload and analyze medical reports with AI.
- 🤖 **Symptom Checker & AI Chatbot** — Get possible diagnoses based on symptoms using a conversational interface.
- 🧑‍⚕️ **Doctor & Patient Dashboards** — Dedicated views for doctors and patients.
- 📷 **Skin Disease Detection** — Upload images to detect skin diseases using **Gemini API**.
- 📞 **Secure Telemedicine** — Real-time video consultations powered by **Twilio**.
- 🧾 **Digital Health Records** — Store and access patient records with unique patient IDs.
- 🔐 **Firebase Authentication** — Secure user login and data access.

---

## 🚀 Getting Started

### ✅ Prerequisites

Before running the app, make sure you have the following installed and set up:

- Flutter SDK (latest stable version)
- Android Studio or Visual Studio Code
- A Firebase project with Authentication and Firestore enabled
- Twilio account for video calls
- Gemini API key from Google AI Studio

---

### 📦 Installation

1. **Clone the Repository**

```bash
git clone https://github.com/your-username/mediwise-flutter.git
cd mediwise-flutter
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Configure Firebase**

Add your Firebase config files to the appropriate directories:

```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

Make sure Firebase Authentication and Firestore are enabled in your Firebase console.

4. **Set Up Gemini API**

- Obtain your Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey)
- Add the key securely to your project, either:
  - Via environment variables (`.env`)
  - Or through secure backend integration

5. **Run the App**

```bash
flutter run
```

---

## 🧠 Tech Stack

| Technology     | Purpose                                      |
|----------------|----------------------------------------------|
| **Flutter**    | Cross-platform mobile development            |
| **Firebase**   | Authentication & Cloud Firestore             |
| **Twilio**     | Secure video consultations                   |
| **Provider**   | State management                             |
| **Dio / HTTP** | API communication with backend services      |
| **Gemini API** | Report analysis & skin disease detection     |

---

## 📸 Screenshots (Coming Soon)

- 🏠 Home Page  
- 🤖 AI Chatbot  
- 📄 Upload Report Page  
- 👨‍⚕️ Doctor Dashboard  
- 📞 Video Consultation  

---

## 🌟 Future Roadmap

- 🔌 Offline Access to Health Records  
- ⏰ Native Push Notifications for Medication Reminders  
- 🌙 Dark Mode Support  
- ⌚ Integration with Wearables (e.g., Smartwatches)

---

## 🤝 Contributing

We welcome contributions from the community!

To contribute:

1. **Fork** this repository  
2. **Create a feature branch**

```bash
git checkout -b feature/your-feature-name
```

3. **Commit your changes**

```bash
git commit -m "Add your feature"
```

4. **Push to the branch**

```bash
git push origin feature/your-feature-name
```

5. **Open a Pull Request**

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).  
© 2025 MediWise Flutter Team
