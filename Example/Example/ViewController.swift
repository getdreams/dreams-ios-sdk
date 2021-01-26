import UIKit
import Dreams

//
// This ViewController is initialized and presented by InterfaceBuilder (Main.storyboard)
//
class ViewController: UIViewController {
    @IBAction func presentDreams() {
        let viewController = DreamsViewController()
        let userCredentials = DreamsCredentials(idToken: "idToken")
        viewController.use(delegate: self)
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true) {
            viewController.launch(with: userCredentials, locale: Locale.current) { result in
                switch result {
                case .success:
                    () // Dreams did launch successfully
                case .failure(let launchError):
                    switch launchError {
                    case .alreadyLaunched:
                        () // You cannot launch Dreams when launching is in progess
                    case .invalidCredentials:
                        () // The provided credentials were invalid
                    case .httpErrorStatus(let httpStatus):
                        print(httpStatus) // The server returned a HTTP error status
                    case .requestFailure(let error):
                        print(error) // Other server errors (NSError instance)
                    }
                }
            }
        }
    }
}

//
// Example implementation of DreamsDelegate
//
extension ViewController: DreamsDelegate {
    func handleDreamsCredentialsExpired(completion: @escaping (DreamsCredentials) -> Void) {
        print("IdToken expired event received")
        
        completion(DreamsCredentials(idToken: "newtoken"))
    }
    
    func handleDreamsTelemetryEvent(name: String, payload: [String : Any]) {
        print("Telemetry event received: \(name) with payload: \(payload)")
    }
    
    func handleDreamsAccountProvisionInitiated(completion: @escaping () -> Void) {
        print("Account Provision Initiated event received")

        completion()
    }
    
    func handleExitRequest() {
        // For example:
        presentedViewController?.dismiss(animated: true, completion: nil)
        print("Exit requested event received")
    }
}
