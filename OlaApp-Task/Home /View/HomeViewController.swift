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
    let detailViewController = VehicleDetailVC.instantiate()
    @IBOutlet weak var mapViewContainer: UIStackView!
    @IBOutlet weak var vehicalTypeContainer: UIStackView!
    @IBOutlet weak var detailViewContainer: UIStackView!
    
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
    
    //MARK:- View Setup
    func viewSetUp(){
        mapViewContainer.addArrangedSubview(mapViewController.view)
        vehicalTypeContainer.addArrangedSubview(vehiclesCollectionVC.view)
        detailViewContainer.addArrangedSubview(detailViewController.view)
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
        
        homeViewModel
            .vehicleList.bind {[weak self] values in
                let new = values.map{ LocationModel(id: $0.id,
                                                    carImageUrl: $0.carImageURL,
                                                    coordinate: .init(latitude: $0.location.latitude,
                                                                      longitude: $0.location.longitude))}
                self?.mapViewController.locationList = new
        }.disposed(by: disposeBag)
        
        collectionViewBinding()
    }
    
    //MARK: - Collection View Binding
    func collectionViewBinding(){
        vehiclesCollectionVC
            .selectedVehicle
            .observeOn(MainScheduler.instance)
            .bind(to: detailViewController.vehicleDetails)
            .disposed(by: disposeBag)
        
        vehiclesCollectionVC
            .selectesIndex
            .observeOn(MainScheduler.instance)
            .bind(to: mapViewController.selectesIndex)
            .disposed(by: disposeBag)
    }
    
}

