//
//  UIExtensions.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 04/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func presentAlert(title: String, message: String, actionTitle: String) {
        
        let alertControllerStyle = UIAlertControllerStyle.alert
        let alertView = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        
        let alertActionStyle = UIAlertActionStyle.default
        let alertActionOK = UIAlertAction(title: actionTitle, style: alertActionStyle, handler: nil)
        
        alertView.addAction(alertActionOK)
        
        performUIUpdatesOnMain {
            self.present(alertView, animated: true, completion: nil)
        }
    }

    
}
