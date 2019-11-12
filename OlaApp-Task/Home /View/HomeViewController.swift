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

    let disposeBag = DisposeBag()
    lazy var homeViewModel = HomeViewModel()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
    }

    func binding(){
        homeViewModel
        .loading
        .bind(to: isAnimating)
        .disposed(by: disposeBag)
        
        homeViewModel.fetchVehicleList()
    }
    
}

