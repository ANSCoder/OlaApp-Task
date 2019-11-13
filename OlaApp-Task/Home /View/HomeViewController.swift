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
    let mapViewController = MapViewController.instantiate()
    let vehiclesCollectionVC = VehiclesCollectionVC.instantiate()
    @IBOutlet weak var mapViewContainer: UIStackView!
    @IBOutlet weak var vehicalTypeContainer: UIStackView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetUp()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Network request
        homeViewModel.fetchVehicleList()
    }
    
    func viewSetUp(){
        mapViewContainer.addArrangedSubview(mapViewController.view)
        vehicalTypeContainer.addArrangedSubview(vehiclesCollectionVC.view)
    }
    
    //MARK: - UI Binding
    func binding(){
        homeViewModel
            .loading
            .observeOn(MainScheduler.instance)
            .bind(to: isAnimating)
            .disposed(by: disposeBag)
        
        homeViewModel
            .vehicleList
            .observeOn(MainScheduler.instance)
            .bind(to: vehiclesCollectionVC.vehiclesList)
            .disposed(by: disposeBag)
    }
    
}

