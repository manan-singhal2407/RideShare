# RideShare (Car-Sharing Service)

![App Logo](https://github.com/manan-singhal2407/RideShare/blob/main/assets/images/Screenshot-1.jpeg?raw=true)

The RideShare App is a car-sharing service that allows passengers with overlapping routes to share rides, reducing costs and promoting sustainable transportation. It provides features like ride booking, ride-sharing preferences, nearby driver discovery, and ride history. The system will also include single-sharing services for passengers who do not have a ride share partner.

![App Flow](https://github.com/manan-singhal2407/RideShare/blob/main/assets/images/Screenshot-2.jpeg?raw=true)


## RideShare Rider App

Rider App is a user-friendly mobile application made using Flutter designed to facilitate cab-sharing for passengers with overlapping routes. With features such as user authentication, ride-share preferences, and convenient location services using Google Maps, riders can easily book rides and find nearby drivers. The app allows users to view their ride history, providing transparency and access to previous ride details. It also enables users to see ride-share partner information and the amount saved through ride-sharing. Additionally, the app allows riders to provide driver ratings and feedback, ensuring a quality experience.

![Rider App Flow](https://github.com/manan-singhal2407/RideShare/blob/main/assets/images/Screenshot-3.jpeg?raw=true)
![Rider App Flow](https://github.com/manan-singhal2407/RideShare/blob/main/assets/images/Screenshot-4.jpeg?raw=true)

### External Services

- Google Maps for Android
- Google Search Places
- Firebase Authentication
- Cloud Firestore for database
- Firebase Storage
- Firebase crashlytics

### Features

- Users can securely login, signup, and logout from the system using Firebase Authentication.
- Users have the option to enable or disable ride-sharing based on their comfort level. 
- Users can set parameters such as maximum time delay and minimum fare to ensure a suitable ride-sharing experience.
- The app utilizes Google Search Places to enable autocomplete functionality in the search bar, making it easy for users to enter their desired pickup and drop-off locations.
- Users can book rides using the application, selecting their preferred pickup and drop-off locations, and requesting a driver.
- Users can access their previous ride details through the app, allowing them to review their ride history and associated costs.
- If a ride-share is successfully matched, users can view their ride-share partner's details and the amount they are collectively saving, promoting transparency and trust.
- Users can provide ratings and feedback to the drivers based on their ride experience, contributing to the overall quality of the service.

### Issues

- The app currently lacks a feature that allows users to edit their profile information. This functionality should be added to enable users to update their details as needed.
- Users do not have the ability to request the deletion of their account. Implementing an account deletion feature would enhance user control and privacy.

## RideShare Driver App

Driver App is a platform for drivers to participate in the cab-sharing system. It enables drivers to login/signup, set their availability status, and choose their ride-sharing preferences. They can accept ride requests from a list of available rides and start the journey with the accepted passenger. If ride-sharing is enabled, drivers can also view and accept merged ride requests to optimize their efficiency.

![Driver App Flow](https://github.com/manan-singhal2407/RideShare/blob/main/assets/images/Screenshot-5.jpeg?raw=true)
![Driver App Flow](https://github.com/manan-singhal2407/RideShare/blob/main/assets/images/Screenshot-6.jpeg?raw=true)

### External Services

- Google Maps for Android
- Firebase Authentication
- Cloud Firestore for database
- Firebase Storage
- Firebase crashlytics

### Features

- Drivers can securely login and signup in the system, allowing them to access the app's features using Firebase Authentication.
- Drivers can set their availability status as online or offline, indicating their readiness to accept ride requests.
- Drivers can choose to enable or disable ride-sharing based on their preferences and comfort level.
- Drivers can accept ride requests from the available list of rides, enabling them to start the journey with the accepted passenger.
- If the ride-sharing option is enabled, drivers can view and accept merged ride requests, optimizing their efficiency and earning potential.
- Drivers can securely logout from the app when they are no longer available for rides.

### Issues

- The app currently does not include a process for verifying and collecting driver details such as Aadhar and Pan.
- Similar to the rider app, the driver app lacks a profile editing feature, preventing drivers from updating their information as needed.
- Similar to the rider app, the driver app do not have the ability to request the deletion of their account. Implementing an account deletion feature would enhance user control and privacy.
