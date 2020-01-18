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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
