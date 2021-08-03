## Technologies used
The app is written in Swift 5, with Xcode 12.2, UIKit as the ui framework, unit and ui testing is done with the native tools provided by XCode

## How to run
Open ImageViewer.xcodeproj select target ImageViewer and select device/simulator, then run.
In order to run tests, on the left side open test navigator panel and run all the tests, on the reports tab the coverage can be seen.
Note: on Resources/Info.plist you can change SERVER_URL

## Architecture choose
For this small project the native MVC architecture is perfect, it's the simplest architecture pattern, also the native approach promoted by Apple, and it lets you develop fast, but I chose MVVM pattern over MVC in order to show my knowledge about MVVM. I decided to implemented it without using any framework.

## Project structure 
* ImageViewer: Contains the main app code
    * Util: contains small helper classes, constants and extensions.
    * Resources: contains the apps resources (images, strings)
    * Network: contains the networking layer code
    * Launch: App init managers
    *  Viewer
        * View: contains custom UIViews, storyboards and table cells
        * Model: contains the apps models
        * Repository: contains any logic regarding to local persistency or network service calls
        * Controller: contains the view controllers
* ImageViewerTests: Contains the unit tests
* ImageViewerUITests: Contains the ui tests

Note: Project was structured based on screaming architecture approach.

## Error handling from dev perspective
Requests: when a request fails it might be for many reasons, NetworkError gather some general cases and provide a custom description for the user, NetworkManager will provide the necessary information. Also no internet reachability is implemented, if the user doesn't have a connection, it will just show the generic network failure.

## Errors from user perspective
Requests: When requesting image list, if an error occurs, an UIAlertController will appear showing a related error, if dismiss button is tapped, the landing screen is shown again, and if user pull the screen down, a loading indicator will appear and a new request it'll triggered.

## unit tests
The unit tests are focused on the logic, and test everything from the ViewModel up to the Network layer. They don't test anything on view controllers or views.

## UI Tests
Ui tests as expected are focused on View layer and cover around 75% coverage of the app.

#### Localization
Localization was done using the Localization.strings method, not using the localized storyboards, the app supports english and spanish.

## Why no Pods?
I tried not using external libraries, not because I'm against using libraries in particular, but I think it's best for showing my knowledge of the platform.
