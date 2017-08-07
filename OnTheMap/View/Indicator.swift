//
//  Indicator.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 06/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation
import UIKit

class Indicator {
    
    var overlayView = UIView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    func showIndicator(view: UIView!){
        
        overlayView = UIView(frame: UIScreen.main.bounds)

        indicator.center = overlayView.center
        performUIUpdatesOnMain {
            self.indicator.startAnimating()
            view.addSubview(self.indicator)
        }

    }
    
    func hideIndicator(view: UIView!){
        performUIUpdatesOnMain {
            self.indicator.stopAnimating()
        }
    }
    
    static let shared = Indicator()
}
