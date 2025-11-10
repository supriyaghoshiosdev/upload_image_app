# 📸 Upload Image App (SwiftUI + Firebase Realtime Database)

A SwiftUI-based iOS application that allows users to **upload**, **view**, and **delete images** seamlessly using **Firebase Realtime Database** — without Firebase Storage.  
The app features a clean grid-based layout for managing uploaded images and a custom confirmation popup for deletion actions.

---

## 🚀 Features

- **Image Upload**  
  Users can select or capture an image and upload it directly to Firebase Realtime Database (as Base64-encoded strings).

- **Image Listing**  
  Displays all uploaded images in a **2-column grid layout**, fetched dynamically from Firebase.

- **Custom Delete Confirmation**  
  When deleting an image, a smooth popup confirmation (not a native alert) appears before removing it from the database.

- **Responsive UI**  
  Adapts beautifully to different screen sizes using SwiftUI’s `GeometryReader` and `LazyVGrid`.

- **Real-Time Updates**  
  Changes made in Firebase reflect instantly on all connected clients, providing a live experience.

---

## 🧩 Tech Stack

| Component | Technology |
|------------|-------------|
| **Frontend** | SwiftUI |
| **Backend** | Firebase Realtime Database |
| **Language** | Swift 5 |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **UI Components** | LazyVGrid, GeometryReader, Custom Popups |

---
