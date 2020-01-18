//
//  SignUpViewController.swift
//  ios_example_girlad
//
//  Created by Apple on 17/01/2020.
//  Copyright © 2020 DontBeAStranger. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSCognitoAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //check password format
    func checkPassword(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", "(?=.*[a-z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //check email format
    func checkEmail(_ email :String) -> Bool {
         let emailTest = NSPredicate(format:"SELF MATCHES %@", "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$")
         return emailTest.evaluate(with: email)
    }

    func validateFields() -> String?
    {
        if (email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "Please fill in all fields."
        }
        if (checkEmail(email.text!) == false)
        {
            return "Invalid email format"
        }
        if (checkPassword(password.text!) == false)
        {
            return "Password must contain 8 charcters and atleast 1 number"
        }
        return nil
    }

    @IBAction func signUpPressed(_ sender: Any) {
        let err = validateFields()
        if err != nil
        {
            let alert = UIAlertController(title: "Error Signing Up", message: err!, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            let emailValue = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordValue = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstNameValue = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastNameValue = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //add user to amazon cognito
        }
    }
}
