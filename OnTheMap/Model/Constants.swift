//
//  Constants.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 30/07/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation

extension Client{
    
    struct Constants {
        // api keys
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // URL
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let LoginURL = "https://www.udacity.com/api/session"
        static let RegisterURL = "https://www.udacity.com/account/auth#!/signup"
        static let GetUserURL = "https://www.udacity.com/api/users/"
    }
    
    struct Methods {
        static let StudentLocations = "/StudentLocation"
    }
    
    struct ParametersKey {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
    }
    struct ResponseKeys {
        static let SessionID = "id"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
}
