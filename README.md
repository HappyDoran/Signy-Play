# Signy Play

 WWDC25 Swift Student Challenge - Deaf Children's Sign Language Education App

Signy Play is a project that helps deaf children who are learning the alphabet for the first time learn the American Sign Language (ASL) through games.

<img width="830" alt="Swift Student Challenge Winner ScreenShot" src="" />

<br />

Period : 2025.01.31 - 2025.02.23<br />
Development Environment: Xcode 16 App Playground<br />
Development equipment: iPad Pro (12.9 inches, 11 inches), iPad Mini
<br />

## Tech

[SwiftUI] - Advanced app experiences and tools.

[CoreML] - Train a variety of hand images and extract them into a CoreML model.

[Vision] - Use the device's camera to identify and extract information from hand images.

[AVFoundation] - Use the camera and show a preview.
<br>

## Demo

### Quiz Select Scene

Users can choose a quiz from one of the alphabet, word themes, and select the number of questions.

<img width="512" alt="Quiz Select Scene ScreenShot" src="" />

### Quiz Scene

Users can use the front-facing camera to recognize hands, detect hand shapes, and practice sign language.

<img width="512" alt="Quiz Scene ScreenShot" src="" />

<br>

## Source

### ML Model

I used data from Kaggle(https://www.kaggle.com/grassknoted/asl-alphabet) to train a Convolutional Neural Network.

### ASL Quiz Data

The quiz question data was searched on Google and designed in Figma in the form of appropriate cards.

[SwiftUI]: https://developer.apple.com/xcode/swiftui/
[CoreML]: https://developer.apple.com/documentation/coreml/
[Vision]: https://developer.apple.com/documentation/vision/
[AVFoundation]: https://developer.apple.com/documentation/AVFoundation/
