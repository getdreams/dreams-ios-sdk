# Dreams iOS SDK

## Requirements
- iOS 10.0+
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
    Dreams.configure(clientId: "your_client_id", baseURL: "your_base_url")
    ```

3. Create an instance of a `DreamsViewController`.

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
7. 
	```swift
        let navigation = UINavigationController(rootViewController: viewController)
        present(navigation, animated: true) {
            viewController.launch(with: userCredentials)
        }

	```
	
This is just one example you can present it however you like including instantiation from Storyboards and xib's.


