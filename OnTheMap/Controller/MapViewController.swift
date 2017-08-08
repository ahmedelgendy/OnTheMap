//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 02/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Client.shared().getStudents(){
            (result, error) in
            
            if error != nil{
                performUIUpdatesOnMain {
                    self.presentAlert(title: "Data Error", message: "Can not getting data", actionTitle: "Ok")
                }
            }else{
                performUIUpdatesOnMain {
                    self.makeAnnotations()
                }
            }
        }
        
        zoomToUserLocation()
    }

    
    func makeAnnotations(){

        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for student in StudentData.shared.students{
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName 
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func zoomToUserLocation(){
        if !((User.latitude == 0.0) && (User.longitude == 0.0)){
            let lat = CLLocationDegrees(User.latitude)
            let long = CLLocationDegrees(User.longitude)
            
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // zoom and move to coordinates
            let region = MKCoordinateRegionMakeWithDistance(coordinates, 3000, 3000)
            mapView.region = region
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                Client.shared().openURL(toOpen){
                    (success) in
                    if !success!{
                        self.presentAlert(title: "URL Error", message: "Can not open URL", actionTitle: "Ok")
                    }
                }
            }
        }
    }
    
}
