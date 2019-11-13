//
//  MapViewController.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 51.50007773,
            longitude: -0.1246402)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
    }

}
