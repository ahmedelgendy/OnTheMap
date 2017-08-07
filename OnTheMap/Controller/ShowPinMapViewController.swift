//
//  ShowPinMapViewController.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 07/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class ShowPinMapViewController: UIViewController {
    
    
    var locationString: String!
    var coordinates : CLLocationCoordinate2D!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAnnotation()
    }
    
    @IBAction func sendLocation(){
        Client().getUserData(completion: {
            (result, error) in
            if result!{
                Client().postStudentLocation(completion: {
                  (success, error) in
                    if success{
                        let tabsNavigation = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVCNav")
                        self.present(tabsNavigation!, animated: false)
                    }else{
                        self.presentAlert(title: "Add Location", message: "Error with your location", actionTitle: "ok")
                    }
                })
            }
        })
    }
    
    func makeAnnotation(){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = locationString
        mapView.addAnnotation(annotation)
        
        // zoom and move to coordinates
        let region = MKCoordinateRegionMakeWithDistance(coordinates!, 5000.0, 5000.0)
        
        mapView.region = region
    }
    
}
