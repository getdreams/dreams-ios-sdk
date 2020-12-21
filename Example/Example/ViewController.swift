import UIKit
import Dreams

class ViewController: UIViewController {

    private var dreamsViewController: DreamsViewController?
    private var accountProvisioningRequestId: String?
    private var idTokenRequestId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(presentDreams), for: .touchUpInside)
        button.setTitle("Present Dreams", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc
    func presentDreams() {
        let vc = DreamsViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)

        dreamsViewController = vc
        dreamsViewController?.open(idToken: "idToken", locale: Locale.current)
    }
}

extension ViewController {

    func accountProvisionInitiated() {
        guard let requestId = accountProvisioningRequestId else { return }
        dreamsViewController?.accountProvisionInitiated(requestId: requestId)
    }

    func updateIdToken() {

        // 1. Get a new idToken
        // 2. Pass it to the dreams viewcontroller along with the request id
        guard let requestId = idTokenRequestId else { return }
        dreamsViewController?.update(idToken: "new_id_token", requestId: requestId)
    }
}

extension ViewController: DreamsViewControllerDelegate {

    func dreamsViewControllerDelegateDidReceiveIdTokenExpired(vc: DreamsViewController, requestId: String) {
        print("IdToken expired event received")

        idTokenRequestId = requestId
        updateIdToken()
    }

    func dreamsViewControllerDelegateDidReceiveTelemetryEvent(vc: DreamsViewController, name: String, payload: [String : Any]) {
        print("Telemetry event received: \(name) with payload: \(payload)")
    }

    func dreamsViewControllerDelegateDidReceiveAccountProvisioningRequested(vc: DreamsViewController, requestId: String) {
        accountProvisioningRequestId = requestId
    }

    func dreamsViewControllerDelegateDidReceiveExitRequested(vc: DreamsViewController) {
        print("Exit requested event received")
    }
}
