//
//  AuthClient.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 01/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation

extension Client{

    func getUserData(completion : @escaping (_ success: Bool?, _ errorMessage: String)->Void){

        let url: URL = URL(string: Constants.GetUserURL + User.uniqueKey)!
        let request = NSMutableURLRequest(url: url)

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completion(nil, "Connection Error")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */

            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: {
                (data, error) in
                guard error == nil else{
                    completion(false, "Could not convert data")
                    return
                }
                guard let newData = data?["user"] as? NSDictionary else{
                    return
                }
                guard let firstname = newData["first_name"] as? String else{
                    return
                }
                guard let lastName = newData["last_name"] as? String else{
                    return
                }
                User.firstName = firstname
                User.lastName = lastName
                completion(true, "")
            })
        }
        

        task.resume()
    }
    
    func letsLogin(_ params: [String: AnyObject], _ completionForLogin: @escaping(_ success: Bool, _ errorString: String?)->Void){
        loginRequest(params){
            (result,error) in
            guard error == nil else{
                completionForLogin(false, "Connection Error")
                return
            }
            
            if let credentialsError = result?["error"] as? String{
                completionForLogin(false, credentialsError)
                return
            }
            guard let account = result!["account"] as? NSDictionary else {
                return
            }

            guard let uniqueKey = account["key"] as? String else {
                return
            }

            User.uniqueKey = uniqueKey
            
            completionForLogin(true, "")
        }
    }
    
    func loginRequest(_ params: [String: AnyObject], completionHandlerForLogin: @escaping (_ result: AnyObject?, _ error: NSError?)->Void){
        
        let request = NSMutableURLRequest(url: URL(string: Constants.LoginURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var paramsDict = [String:AnyObject]()
        paramsDict["udacity"] = params as AnyObject
        
        let jsonData = try? JSONSerialization.data(withJSONObject: paramsDict)

        request.httpBody = jsonData

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogin(nil, NSError(domain: "login", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForLogin)
            
        }
        task.resume()
    }
    
    
    
    func logout() {
        let request = NSMutableURLRequest(url: URL(string: Constants.LoginURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
