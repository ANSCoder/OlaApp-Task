//
//  VehicleDetailVC.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VehicleDetailVC: UIViewController, Storyboarded {
    
    var vehicleDetails = PublishSubject<Vehicle>()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFuelType: UILabel!
    @IBOutlet weak var labelFuelLevel: UILabel!
    @IBOutlet weak var labelBrandName: UILabel!
    @IBOutlet weak var labelNumberPlate: UILabel!
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehicleDetails
            .subscribe(onNext: {[weak self] details in
                self?.labelName.text = details.vehicleDetails.name
                self?.labelFuelType.text = details.vehicleDetails.fuelType
                self?.labelFuelLevel.text = String(details.vehicleDetails.fuelLevel)
                self?.labelBrandName.text = details.vehicleDetails.make
                self?.labelNumberPlate.text = details.licensePlate
            }).disposed(by: disposeBag)
    }
}
