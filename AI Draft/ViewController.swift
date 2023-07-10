import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import StoreKit

var storeVM = StoreVM();

class NewViewController: UIViewController {

    
    
    
    var isPurchased: Bool = false;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissal()
        
    }
    

    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    
    func setupUI() {
            view.addSubview(logoutButton)
        Task{
            
            await storeVM.requestProducts()
            await storeVM.updateCustomerProductStatus()

            for (index, subscription) in storeVM.subscriptions.enumerated() {
                let button = UIButton(type: .system)
                button.tintColor = .white
                button.setTitle("\(subscription.displayName) \(subscription.displayPrice)", for: .normal)
                button.frame = CGRect(x: 50, y: 100 + (index * 50), width: 200, height: 40)
                button.addAction(UIAction(handler: { _ in
                    Task{
                        await self.buySubscriptionButtonTapped(product: subscription)
                    }
                    
                }), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(button)
                
                NSLayoutConstraint.activate([
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    button.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: CGFloat(index + 1) * 60),                     button.widthAnchor.constraint(equalToConstant: 200),
                    button.heightAnchor.constraint(equalToConstant: 40)
                ])
            }
        }
            
            NSLayoutConstraint.activate([
                logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                logoutButton.widthAnchor.constraint(equalToConstant: 100),
                logoutButton.heightAnchor.constraint(equalToConstant: 40),
            ])
            
            view.backgroundColor = .gray
        }
    
    
        
    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            self.logoutSuccess()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
            self.showAlert(message: error.localizedDescription)
        }
    }

    func buySubscriptionButtonTapped(product: Product) async {
        do {
            if try await storeVM.purchase (product) != nil {

                isPurchased = true
            }
        } catch {
            print("Purchase failed")
        }

    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
    func logoutSuccess() {
         let viewController = ViewController()
         let navigationController = UINavigationController(rootViewController: viewController)
         navigationController.modalPresentationStyle = .fullScreen

         
         dismiss(animated: true) {
             self.present(navigationController, animated: true, completion: nil)
         }
     }
    
    

    
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    
}



class ProViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissal()
        
    }
    

    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let cancelSubscriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel Subscription", for: .normal)
        button.addTarget(self, action: #selector(cancelSubscriptionButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    

    
    
    func setupUI() {
            view.addSubview(logoutButton)
//            view.addSubview(cancelSubscriptionButton)

            
            NSLayoutConstraint.activate([
                logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                logoutButton.widthAnchor.constraint(equalToConstant: 100),
                logoutButton.heightAnchor.constraint(equalToConstant: 40),

//                cancelSubscriptionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                cancelSubscriptionButton.centerYAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: -60),
//                cancelSubscriptionButton.heightAnchor.constraint(equalToConstant: 40),

            ])
            
        view.backgroundColor = .white
        }
    
    
        
    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            self.logoutSuccess()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
            self.showAlert(message: error.localizedDescription)
        }
    }

    @objc func cancelSubscriptionButtonTapped() {
        print("storeVM.cancelSubscription(storeVM.subscriptions[0])")
        storeVM.cancelSubscription(storeVM.subscriptions[0])
    }

   

    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
    func logoutSuccess() {
         let viewController = ViewController()
         let navigationController = UINavigationController(rootViewController: viewController)
         navigationController.modalPresentationStyle = .fullScreen

         
         dismiss(animated: true) {
             self.present(navigationController, animated: true, completion: nil)
         }
     }
    
    

    
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    
}



class ViewController: UIViewController {
    
    let signInConfig = GIDConfiguration(clientID: "1028426391487-fujtjn6n3juurgm8d4vn6ps9qcffdmlf.apps.googleusercontent.com");
    @IBOutlet weak var signInButton: GIDSignInButton!

    @IBAction func GIDSignInButtonTap(_ sender: Any) {
        GIDSignIn.sharedInstance.configuration = signInConfig;

        GIDSignIn.sharedInstance.signIn(
            withPresenting: self) { signInResult, error in
                guard signInResult != nil else {
                return
              }
                
            guard let user = signInResult else {return}
            let email = user.user.profile?.email
            print(email!)
            self.loginSuccess()
                
            }
    }
        
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.textContentType = .username
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textContentType = .password
        return textField
    }()

    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password", for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    



    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupKeyboardDismissal()
        

        if Auth.auth().currentUser != nil {
            print("AUTHENTICATED")
            DispatchQueue.main.async {
                    self.loginSuccess()
                }
           
        }
        else {
            print("NONAUTHENTICATED")
        }
        

    }

    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        print("keyboard dismiss")
        view.endEditing(true)
    }


    func setupUI() {
        let appleButton = ASAuthorizationAppleIDButton();
        appleButton.translatesAutoresizingMaskIntoConstraints = false;
        appleButton.addTarget(self, action: #selector(didTapOnAppleButton), for: .touchUpInside)
        
        view.backgroundColor = .white
        

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(appleButton)
        
        

        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emailTextField.widthAnchor.constraint(equalToConstant: 200),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 40),

            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 150),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 40),
            
            appleButton.centerYAnchor.constraint (equalTo: view.centerYAnchor, constant: 250),
            appleButton.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -30)
            
        ])
    }
    
    
    @objc func didTapOnAppleButton(){
        print("button tapped")
        print("TAP")
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [ .fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self

        controller.performRequests()
    }

    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription) \(error)")
                self.showAlert(message: error.localizedDescription)
                return
            }

            // User creation successful
            self.showAlert(message: "User created successfully!")
            self.loginSuccess()
        }
    }

    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.showAlert(message: error.localizedDescription)
                return
            }

            self.loginSuccess()
        }
    }

    @objc func forgotPasswordButtonTapped() {
        guard let email = emailTextField.text else {
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
                self.showAlert(message: error.localizedDescription)
                return
            }

            self.showAlert(message: "Password reset email sent!")
        }
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func loginSuccess() {
        
        Task{
            await storeVM.requestProducts()
            await storeVM.updateCustomerProductStatus()

            if let subscriptionGroupStatus = storeVM.subscriptionGroupStatus {
                if subscriptionGroupStatus == .expired || subscriptionGroupStatus == .revoked {

                }
            }
            if storeVM.purchasedSubscriptions.isEmpty {
                let newViewController = NewViewController()
                    let navigationController = UINavigationController(rootViewController: newViewController)
                    navigationController.modalPresentationStyle = .fullScreen

                    // Dismiss the current view controller before presenting the new one
                    dismiss(animated: true) {
                        self.present(navigationController, animated: true, completion: nil)
                    }
            } else {
                print(storeVM.purchasedSubscriptions)
                let proViewController = ProViewController()
                    let navigationController = UINavigationController(rootViewController: proViewController)
                    navigationController.modalPresentationStyle = .fullScreen

                    // Dismiss the current view controller before presenting the new one
                    dismiss(animated: true) {
                        self.present(navigationController, animated: true, completion: nil)
                    }
            }
            
        }
        
       
    }
    


}



extension ViewController {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
        }
        
    }
}


extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController (controller: ASAuthorizationController,
                                  didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential{
        case let credentials as ASAuthorizationAppleIDCredential:
            print(credentials)
            let user = User(credentials: credentials)
            self.loginSuccess()
            print(user)
        default:
            print("BREAK CASE")
            break
        }
        
    }
    func authorizationController (controller: ASAuthorizationController,
                                  didCompleteWithError error: Error) {
        print("Something bad happened", error)
    }
    
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor (for controller: ASAuthorizationController) -> ASPresentationAnchor{
        return view.window!
    }
    
}

