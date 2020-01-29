//
//  HttpManager.swift
//  ios_example_girlad
//
//  Created by gilad on 18/01/2020.
//  Copyright © 2020 DontBeAStranger. All rights reserved.
//


import Foundation
class HttpManager {
    let TYPE_KEY = "type"
    let CONTENT_KEY = "content"
    
    var hostnamesDict : Dictionary<String, String>
    
    
    
    enum ErrorTypes : Error{
        case BuildURLRequestError
    }
    
    init(hostnames_dict : Dictionary<String, String>) {
        self.hostnamesDict = hostnames_dict
    }
    
    
    
    
    private func BuildURLRequest(endpointName: String, path: String, parameters: [String:String] = [:], body: [String:String] = [:], method: String) -> URLRequest? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.hostnamesDict[endpointName]
        urlComponents.path = path
        var queryItems: [URLQueryItem] =  []
        let queryParameters = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        queryItems.append(contentsOf: queryParameters)
        urlComponents.queryItems = queryItems
        guard let completeUrl = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: completeUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        urlRequest.httpMethod = method
        urlRequest.httpBody = nil//body - add it
        return urlRequest
    }
    
    
    
    private func ProccessResponse(responseData : Data, httpStatus : Int = 666) -> APIResponse{
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                let apiResponse = APIResponse(responseType: APIResponse.ResponseTypes.JSON, statusCode: httpStatus, content: json)
                return apiResponse
            }
            else{
                //will never get here anyway, just for compiling
                let apiResponse = APIResponse(responseType: APIResponse.ResponseTypes.Other, statusCode: httpStatus, content: responseData)
                return apiResponse
            }
        }
        catch{
            //not a JSON response
            let apiResponse = APIResponse(responseType: APIResponse.ResponseTypes.Other, statusCode: httpStatus, content: responseData)
            return apiResponse
        }
        
    }
    
    func CreateRequest(endpointName: String, path: String, parameters: [String:String] = [:], body: [String:String] = [:], method: String, finalResponse : @escaping (APIResponse) -> Void) throws{
        guard let urlRequest = self.BuildURLRequest(endpointName: endpointName, path: path, parameters: parameters, body: body, method: method) else { throw ErrorTypes.BuildURLRequestError }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                
                guard let httpResponse = response as? HTTPURLResponse else {return}
                
                
                let httpStatus = httpResponse.statusCode
                
                finalResponse(self.ProccessResponse(responseData: data, httpStatus : httpStatus))
                //print(String(decoding: response, as:UTF8.self))
            }
            else{
                //check if status code is null. if it is return an agreed statusCode
                if let httpResponse = response as? HTTPURLResponse {
                let httpStatus = httpResponse.statusCode
                finalResponse(self.ProccessResponse(responseData: error as! Data, httpStatus : httpStatus))
                }
            }
        }.resume()
    }
}
