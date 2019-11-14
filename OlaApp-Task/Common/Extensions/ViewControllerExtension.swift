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


extension UIViewController{
    
    //MARK: - Alert View with auto dismiss
    func showAlertWithMessage(_ title: String = "Message",
                              message: String,
                              completion: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
            completion?()
        })
    }
}
