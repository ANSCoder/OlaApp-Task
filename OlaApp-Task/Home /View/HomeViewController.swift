//
//  HomeViewController.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            let loadData = VehicleLoader()
            loadData.loadProduct().observe { result in
                switch result{
                case .success(let values):
                    print(values)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

