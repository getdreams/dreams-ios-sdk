import UIKit
import Dreams

final class DreamsViewController: UIViewController {

    private let dreamsView = DreamsView()

    private var accountProvisioningRequestId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))

        dreamsView.delegate = self
        dreamsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dreamsView)

        NSLayoutConstraint.activate([
            dreamsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            dreamsView.topAnchor.constraint(equalTo: view.topAnchor),
            dreamsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            dreamsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dreamsView.open(idToken: "idToken", locale: Locale.current)
    }

    @objc
    func close() {
        dismiss(animated: true)
    }
}

extension DreamsViewController {

    func accountProvisionInitiated() {
        guard let requestId = accountProvisioningRequestId else { return }
        dreamsView.accountProvisionInitiated(requestId: requestId)
    }

    func updateIdToken() {

        // 1. Get a new idToken
        // 2. Pass it to the dreams view

        let idToken = "newIdToken"
        dreamsView.update(idToken: idToken)
    }
}

extension DreamsViewController: DreamsViewDelegate {

    func dreamsViewDelegateDidReceiveIdTokenExpired(view: DreamsView) {
        print("IdToken expired event received")
        updateIdToken()
    }

    func dreamsViewDelegateDidReceiveTelemetryEvent(view: DreamsView, name: String, payload: [String : Any]) {
        print("Telemetry event received: \(name) with payload: \(payload)")
    }

    func dreamsViewDelegateDidReceiveAccountProvisioningRequested(view: DreamsView, requestId: String) {
        accountProvisioningRequestId = requestId
    }

    func dreamsViewDelegateDidReceiveExitRequested(view: DreamsView) {
        print("Exit requested event received")
    }
}
