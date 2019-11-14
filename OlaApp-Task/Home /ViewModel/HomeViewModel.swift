//
//  HomeViewModel.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


struct HomeViewModel {
    
    let vehicleLoader: VehicleLoader
    let loading = PublishSubject<Bool>()
    let vehicleList = PublishSubject<Vehicles>()
    
    
    //MARK: - Dependency Injection
    init(vehicleLoader: VehicleLoader = VehicleLoader()) {
        self.vehicleLoader = vehicleLoader
    }
    
    //MARK: - Fetching Vehicle List
    func fetchVehicleList(){
        loading.onNext(true)
        DispatchQueue.global().async {
            self.vehicleLoader.loadProduct().observe { result in
                switch result{
                case .success(let values):
                    self.vehicleList.onNext(values)
                    self.loading.onNext(false)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
