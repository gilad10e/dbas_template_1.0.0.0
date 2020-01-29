//
//  SignInViewController.swift
//  ios_example_girlad
//
//  Created by Apple on 17/01/2020.
//  Copyright © 2020 DontBeAStranger. All rights reserved.
//

import UIKit
import AWSCognitoAuth
import AWSCognitoIdentityProvider

class SignInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var signInButton: UIButton!
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    var emailText: String?
    var idToken : String?
    var accessToken : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        makeReturnWithLeftSwipe()
        email.addDoneButtonOnKeyboard()
        password.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func homePagePressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if (self.email.text != nil && self.password.text != nil) {
            print ("start signin")
            let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: email.text!, password: password.text!)
            self.passwordAuthenticationCompletion?.set(result: authDetails)
            
            let pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
            let currUser = pool.currentUser()
            if(currUser == nil) {
                pool.currentUser()?.getSession()
            } else {
                print(currUser!.isSignedIn)
                print(currUser!.username)
            }
        } else {
            let alertController = UIAlertController(title: "Missing information",
                                                    message: "Please enter a valid user name and password",
                                                    preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            alertController.addAction(retryAction)
        }
    }
    
}

extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
            if (self.emailText == nil) {
                self.emailText = authenticationInput.lastKnownUsername
            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.email.text = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
