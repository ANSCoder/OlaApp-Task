//
//  ImageProvider.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 13/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit


struct ImageProvider {
    
    fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
    internal var cache = NSCache<NSURL, UIImage>()

    
    //MARK: - Fetch image from URL and Images cache
    func loadImages(from url: NSURL, completion: @escaping (_ image: UIImage) -> Void) {
        downloadQueue.async(execute: { () -> Void in
            if let image = self.cache.object(forKey: url) {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            
            do{
                let data = try Data(contentsOf: url as URL)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: url)
                        completion(image)
                    }
                } else {
                    print("Could not decode image")
                }
            }catch {
                print("Could not load URL: \(url): \(error)")
            }
        })
    }
}

