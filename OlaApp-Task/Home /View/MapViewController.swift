//
//  MapViewController.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var mapView: MKMapView!
    var selectesIndex = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    var locationList = [LocationModel](){
        didSet{
            addAnnotations()
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Map view Setup 
        mapView.delegate = self
        mapView.register(VehicleAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    //MARK: - Adding Annotation
    func addAnnotations() {
        selectesIndex
            .subscribe(onNext: { index in
                DispatchQueue.main.async {
                    guard self.locationList.count != 0 else { return }
                    let location = self.locationList[index].coordinate
                    let viewRegion = MKCoordinateRegion(center: location,
                                                        latitudinalMeters: 2000,
                                                        longitudinalMeters: 2000)
                    self.mapView.setRegion(viewRegion, animated: true)
                    self.mapView.addAnnotations(self.locationList)
                }
            }).disposed(by: disposeBag)
    }
    
}

//MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {
    //Custom Annotation view Setup here
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "VehicleAnnotationView") as? VehicleAnnotationView
        return annotationView
    }
}

