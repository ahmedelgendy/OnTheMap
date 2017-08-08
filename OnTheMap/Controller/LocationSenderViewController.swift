//
//  LocationSenderViewController.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 07/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import UIKit
import MapKit

class LocationSenderViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction func dismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender:AnyObject) {
        
        if (locationTextField.text?.isEmpty)! || (websiteTextField.text?.isEmpty)!{
            presentAlert(title: "Error", message: "Please enter your location and Email", actionTitle: "Ok")
        }else{
            geocodeFromString()
        }
        
    }
    
    
    func geocodeFromString(){
        Indicator.shared.showIndicator(view: self.view)
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = locationTextField.text
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.start(completionHandler:{
            (response, error) in

            if error == nil {
                let coordinates = response?.mapItems.first?.placemark.coordinate
                let locationString = response?.mapItems.first?.placemark.title
                
                User.latitude = coordinates!.latitude
                User.longitude = coordinates!.longitude
                User.mapString = locationString!
                User.mediaURL = self.websiteTextField.text!
                Indicator.shared.hideIndicator(view: self.view)
                self.showPinOnTheMap(coordinates!)
            }else{
                Indicator.shared.hideIndicator(view: self.view)
                self.presentAlert(title: "Location Error", message: "Could not find location", actionTitle: "Ok")
            }
            
        })

    }
    
    func respondIfFirstResponder(){
        
    }
    
    func showPinOnTheMap(_ coordinates: CLLocationCoordinate2D){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowPinMapViewController") as! ShowPinMapViewController
        vc.coordinates = coordinates
        vc.locationString = User.mapString
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


// LoginViewController (Configure UI)
extension LocationSenderViewController{
    
    func configureUI(){
        configureTextField(locationTextField)
        configureTextField(websiteTextField)
    }
    
}

extension LocationSenderViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureTextField(_ textField:UITextField){
        textField.delegate = self
    }
    
    
}
