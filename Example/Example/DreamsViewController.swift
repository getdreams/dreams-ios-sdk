import UIKit
import Dreams

final class DreamsViewController: UIViewController {

    private let dreamsView = DreamsView()

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
        dreamsView.open(accessToken: "accessToken", locale: Locale.current)
    }

    @objc
    func close() {
        dismiss(animated: true)
    }
}

extension DreamsViewController: DreamsViewDelegate {

    func dreamsViewDelegateDidReceiveAccessTokenExpired(view: DreamsView) {
        // set new accesstoken
    }

    func dreamsViewDelegateDidReceiveOffboardingCompleted(view: DreamsView) {
        // offboarding 
    }
}
