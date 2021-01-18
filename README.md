# Dreams iOS SDK

## Requirements
- iOS 10.3+
- Swift 5.0+

## Installation

### Cocoapods
To integrate Dreams into your project using Cocoapods, add `Dreams` to your `Podfile`.
```ruby
pod 'Dreams'
```
Then run the following command.
```bash
$ pod install
```

### Manually

If you prefer not to use Cocoapods, you can simply integrate Dreams into your project by dragging in the files from the `Sources` folder.


## Usage

1. Import `Dreams` in your `AppDelegate`.

```swift
import Dreams
```
    
2. Add the following to your `application:didFinishLaunchingWithOptions:` in your `AppDelegate`.


```swift
let configuration = DreamsConfiguration(clientId: "your_client_id", baseURL: URL(string: "your_base_url")!)
Dreams.configure(configuration)
```

3. Create an instance of a `DreamsViewController`. This is just one example you can use it however you like including from Storyboards and xib's.

```swift
 let viewController = DreamsViewController()
```
    
4. Set the delegate and implement the `DreamsDelegate` methods.

```swift
viewController.use(delegate: self)
```
    
5. Prepare user's credentials.

```swift 
let userCredentials = DreamsCredentials(idToken: "idToken")
```

6. Present ViewController and then launch Dreams.

```swift
let navigation = UINavigationController(rootViewController: viewController)
present(navigation, animated: true) {
    viewController.launch(with: userCredentials)
}

```

### DreamsDelegate

This method is called when credentials passed whith `launch(with:locale:)` expired and new ones must be generated.

```swift
func handleDreamsCredentialsExpired(completion: @escaping (String) -> Void) {
    // Call `completion` when account provision is initiated.
    completion(DreamsCredentials(idToken: "newtoken"))
}
```

This method is called when a tracked event happened.

```swift
func handleDreamsTelemetryEvent(name: String, payload: [String : Any]) {
    print("Telemetry event received: \(name) with payload: \(payload)")
}
``` 

This method is called when the host app is expected to initiate account provision.

```swift
func handleDreamsAccountProvisionInitiated(completion: @escaping () -> Void) {
    // Call `completion` when account provision is initiated.
    // You can store the `completion` in a property to call it later.
    completion()
}
```
This method is called when user finished interaction with Dreams and the interface should be dismissed.
    
```swift
func handleExitRequest() {
    // For example:
    presentedViewController?.dismiss(animated: true, completion: nil)
}
```

## Unit Tests

To run unit tests manually:

```bash
xcodebuild -workspace "./Dreams.xcworkspace" -scheme "DreamsTests" -destination "platform=iOS Simulator,name=iPhone 8,OS=14.3" build-for-testing test
```

Using fastlane:

```bash
fastlane ios test
```
