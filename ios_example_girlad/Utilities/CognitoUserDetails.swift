//
//  CognitoUserDetails.swift
//  ios_example_girlad
//
//  Created by gilad on 27/01/2020.
//  Copyright © 2020 DontBeAStranger. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class CognitoUserDetails{
    
    var IDToken : AWSCognitoIdentityUserSessionToken?
    var AccessToken : AWSCognitoIdentityUserSessionToken?
    var IsSignedIn : Bool?
    var UUID : String?
    
    class var singleton : CognitoUserDetails{return _singleton}
}

private let _singleton = CognitoUserDetails()
