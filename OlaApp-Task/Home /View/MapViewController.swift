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
        
        mapView.delegate = self
        mapView.register(ArtworkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
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

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ArtworkView") as? ArtworkView
        
        return annotationView
    }
}

class ArtworkView: MKAnnotationView {
    
    let imageProvider = ImageProvider()
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? LocationModel else {return}
            
            if let imageName = artwork.carImageUrl {
                guard let mediaUrl = NSURL(string: imageName) else {
                    image = nil
                    return
                }
                let imageFile = self.imageProvider.cache.object(forKey: mediaUrl)
                image = imageFile?.resizeImage(targetSize: CGSize(width: 50, height: 50))
                if image == nil {
                    self.imageProvider.loadImages(from :mediaUrl, completion: {[weak self] image  in
                        self?.image = image.resizeImage(targetSize: CGSize(width: 50, height: 50))
                    })
                }
            } else {
                image = nil
            }
        }
    }
}



