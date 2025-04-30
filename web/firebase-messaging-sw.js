// Import scripts required for Firebase Messaging
importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js');

// Initialize Firebase app in the service worker with your config
firebase.initializeApp({
  apiKey: "AIzaSyCTwkVAdHdRBeB6I00jYk4HvoGHrSl02v0",
  authDomain: "mad-exam-e3b0b.firebaseapp.com",
  projectId: "mad-exam-e3b0b",
  storageBucket: "mad-exam-e3b0b.appspot.com",
  messagingSenderId: "756449054493",
  appId: "1:756449054493:web:ca2830218f32a4129a5bf4"
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

// Optional: Customize notification
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png' // Adjust path if needed
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
