//
//  VehicleAnnotationView.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 14/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import MapKit

class VehicleAnnotationView: MKAnnotationView {
    
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



