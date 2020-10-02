# Dreams iOS SDK

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
2. Add the following to your `application:didFinishLaunchingWithOptions:` in your `Appdelegate`.
    ```swift
    Dreams.setup(clientId: "your_client_id", baseURL: "your_base_url")
    ```

3. Create an instance of a `DreamsView` and add it to the view hierarchy .
    ```swift
    let dreamsView = DreamsView()
    self.view.addSubview(dreamsView)
    ```
4. Call the `open(accessToken:locale)` method.
    ```swift
    dreamsView.open(accessToken: "access_token", locale: "some_locale")
    ```