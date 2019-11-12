//
//  ViewControllerExtension.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController{
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public var isAnimating: Binder<Bool> {
        let loadingViewController = LoadingViewController()
        
        return Binder(self, binding: {[weak self] (vc, active) in
            if active {
                self?.add(loadingViewController)
            } else {
                loadingViewController.remove()
            }
        })
    }
}
