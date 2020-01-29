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
import AWSCore
import AWSCognito

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    let pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
    var idToken : String = ""
    var accessToken : String = ""
    var sentTo : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeReturnWithLeftSwipe()
        email.addDoneButtonOnKeyboard()
        password.addDoneButtonOnKeyboard()
        conPassword.addDoneButtonOnKeyboard()
        firstName.addDoneButtonOnKeyboard()
        lastName.addDoneButtonOnKeyboard()
        origin.addDoneButtonOnKeyboard()
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
        if (email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || origin.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
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
        if (password.text?.trimmingCharacters(in: .whitespacesAndNewlines) != conPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        {
            return "Password confirmation incorrect"
        }
        return nil
    }
    
    fileprivate func InsertToDB(_ manager: HttpManager, _ dbValue: [String : String]){
        do{try manager.CreateRequest(endpointName: "gateway", path: "/test/users/signup", parameters: dbValue,method: "POST", finalResponse : {
            response in
            //Handle Response
            DispatchQueue.main.async {
                switch(response.StatusCode)
                {
                case 200:
                    print("Success")
                case 502:
                    let alert = UIAlertController(title: "Error siging up", message: "\(dbValue["email"]) already exists", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Resume", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                default:
                    print(response.StringifyContent())
                    
                }
            }
            
        }
            
            )}
        catch {}
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let err = validateFields()
        if nil != nil
        {
            let alert = UIAlertController(title: "Correct the following field:", message: err!, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            print("Sending Request")
            //TODO: add option to load config dictionary from file inside HttpManager class
            let manager =  HttpManager(hostnames_dict: ["gateway" : "nluzyuk4o9.execute-api.us-east-2.amazonaws.com", "cognito" : "donotbeastranger.auth.us-east-2.amazoncognito.com"])
            do{
                //TODO: add parameters from UI
                let uuid = NSUUID().uuidString
                let emailValue = email.text!
                let firstValue = firstName.text!
                let lastValue = lastName.text!
                let originValue = origin.text!
                let passwordValue = password.text!
                
                
                let firstCog = AWSCognitoIdentityUserAttributeType()
                let lastCog = AWSCognitoIdentityUserAttributeType()
                let originCog = AWSCognitoIdentityUserAttributeType()
                let livesCog = AWSCognitoIdentityUserAttributeType()
                let picCog = AWSCognitoIdentityUserAttributeType()
                
                firstCog?.name = "name"
                lastCog?.name = "family_name"
                originCog?.name = "custom:FromWhere"
                livesCog?.name = "custom:LivesIn"
                picCog?.name = "picture"
                
                firstCog?.value = firstValue
                lastCog?.value = lastValue
                originCog?.value = originValue
                livesCog?.value = " "
                picCog?.value = " "
                
                let cogValue = [firstCog, lastCog, originCog, livesCog, picCog] as! [AWSCognitoIdentityUserAttributeType]
                var dbValue = ["uuid" : "", "username" : emailValue, "email" : emailValue, "name" : firstValue, "lastname" : lastValue, "image" : "guyProfilepic.jpg", "current_place" : originValue, "cities" : ""]
                
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                
                //ToDo: Check .signUp and how to finish user addition to cognito user pool
                pool.signUp(emailValue, password: passwordValue, userAttributes: (cogValue), validationData: nil).continueWith {[weak self] (task) -> Any? in
                    guard let strongSelf = self else { return nil }
                    DispatchQueue.global().async(execute: {
                        if let error = task.error as NSError? {
                            let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                                    message: error.userInfo["message"] as? String,
                                                                    preferredStyle: .alert)
                            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                            alertController.addAction(retryAction)
                            strongSelf.present(alertController, animated: true, completion:  nil)
                        }
                        //cognito successfully signed up
                        else if let result = task.result
                        {
                            //Insert User Details to DB
                            dbValue["uuid"] = result.userSub
                            self!.InsertToDB(manager, dbValue as! [String : String])
                            
                            //signs in the user and redirect him to home page if successfull
                            result.user.getSession(emailValue, password: passwordValue, validationData: nil).continueWith { (getSessionTask) -> AnyObject? in
                                
                                if getSessionTask.error != nil {
                                    print("error: \(getSessionTask.error) ")
                                }
                                else{
                                    let getSessionResult = getSessionTask.result
                                    strongSelf.idToken = (getSessionResult?.idToken!.tokenString)!
                                    strongSelf.accessToken = (getSessionResult?.accessToken!.tokenString)!
                                    CognitoUserDetails.singleton.IDToken = (getSessionResult?.idToken)!
                                    CognitoUserDetails.singleton.AccessToken = (getSessionResult?.accessToken!)!
                                    CognitoUserDetails.singleton.IsSignedIn = result.user.isSignedIn
                                    CognitoUserDetails.singleton.UUID = result.userSub
                                }
                                print ("1")
                                dispatchGroup.leave()
                                return nil
                            }
                            
                        }
                        
                        })
                    
                    print ("2")
                    
                    return nil
                }
                
                dispatchGroup.wait()
                    print ("3")
                if CognitoUserDetails.singleton.IsSignedIn! {
                   // self.performSegue(withIdentifier: "toHomePage", sender: nil)
                    let mainSB = self.storyboard
                    guard let destVC = mainSB?.instantiateViewController(withIdentifier: "UserHomeViewController") as? UserHomeViewController else{print("couldnt fetch VC"); return}
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
                
            }
                
            catch{
                //handle Errors
                let alert = UIAlertController(title: "Error signing up", message: (error as! String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func getSession(){
        pool.currentUser()?.getSession().continueWith { (getSessionTask) -> AnyObject? in
            
            if getSessionTask.error != nil {
                print("error: \(getSessionTask.error) ")
            }
            else{
                let getSessionResult = getSessionTask.result
                self.idToken = (getSessionResult?.idToken!.tokenString)!
                self.accessToken = (getSessionResult?.accessToken!.tokenString)!
                print ("Inside func: id token: \(self.idToken)\r\naccess token: \(self.accessToken)")
            }
            return nil
        }
    }
}
