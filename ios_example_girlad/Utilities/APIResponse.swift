//
//  APIResponse.swift
//  ios_example_girlad
//
//  Created by gilad on 22/01/2020.
//  Copyright © 2020 DontBeAStranger. All rights reserved.
//

import Foundation
class APIResponse{
    enum ResponseTypes : Int{
        case JSON
        case Other
        case Empty
        case Error
    }
    
    var StatusCode : Int
    var ResponseType : ResponseTypes
    var Content : Any
    
    init(responseType : ResponseTypes, statusCode: Int, content : Any)
    {
        self.StatusCode = statusCode
        self.ResponseType = responseType
        self.Content = content
    }
    
    func StringifyContent() -> String {
        do{
            switch self.ResponseType {
            case APIResponse.ResponseTypes.JSON:
                let jsonData = try JSONSerialization.data(withJSONObject: self.Content as? Dictionary<String, Any>, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                return jsonString!
            default:
                guard let dataString = String(data: self.Content as! Data, encoding: .utf8) else { return "Couldnt Stringify"}
                return dataString
            }
        }
        catch{
            return "Couldnt Stringify"
        }
    }
}
