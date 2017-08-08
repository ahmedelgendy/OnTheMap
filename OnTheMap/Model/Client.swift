//
//  Client.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 31/07/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import UIKit

class Client: NSObject {
    
    // shared session
    var session = URLSession.shared
    static var objectId : String!
    static var isLocationPosted: Bool! = false
    
    override init() {
        super.init()
    }
    
    func taskForGetMethod(_ method: String, _ params: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?)->Void)->URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: URLFromParams(params,withPathExtension: method))
        
        request.addValue(Client.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Client.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForPostMethod(_ method: String, body: [String:AnyObject], _ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?)->Void)->URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: URLFromParams([:],withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue(Client.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Client.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?)-> Void) {
        
        var parsedResult: AnyObject! = nil
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    func URLFromParams(_ params:[String:AnyObject], withPathExtension: String? = nil) -> URL{
        
        var components = URLComponents()
        components.scheme = Client.Constants.ApiScheme
        components.host = Client.Constants.ApiHost
        components.path = Client.Constants.ApiPath + (withPathExtension ?? "")
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in params{
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    func openURL(_ urlString:String?, completion: @escaping (_ success:Bool?) -> Void){
        guard urlString != "" else{
            completion(false)
            return
        }
        let url = URL(string: urlString!)
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!, options: [:], completionHandler:{
                (success) in
                completion(success)
            })
        }else{
            completion(false)
        }
    }

    // MARK: Shared Instance
    class func shared() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}
