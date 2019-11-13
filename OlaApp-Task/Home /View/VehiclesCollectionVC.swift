//
//  VehiclesCollectionVC.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VehiclesCollectionVC: UIViewController, Storyboarded {
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var vehiclesCollectionView: UICollectionView!
    var vehiclesList = PublishSubject<Vehicles>()
    var groupList = PublishSubject<[String: Vehicles]>()
    let imageProvider = ImageProvider()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    //MARK:- UI setup & Binding
    func bindUI(){
        let nib = UINib(nibName: "VehicleCell", bundle: nil)
        vehiclesCollectionView.register(nib,
                                        forCellWithReuseIdentifier: String(describing: VehicleCell.self))
        
        vehiclesList.subscribe(onNext: {[weak self] array in
           let groupValues =  array.grouping { $0.group }
           self?.groupList.onNext(groupValues)
        }).disposed(by: disposeBag)
        
        vehiclesList
            .bind(to: vehiclesCollectionView
                .rx
                .items(cellIdentifier: "VehicleCell",
                       cellType: VehicleCell.self)) {  (index, model, cell) in
                        cell.vehicleTitle.text = model.group
                        guard let mediaUrl = NSURL(string: model.carImageURL) else {
                            return
                        }
                        let image = self.imageProvider.cache.object(forKey: mediaUrl)
                        cell.vehicleImage.image = image
                        if image == nil {
                            self.imageProvider.loadImages(from :mediaUrl, completion: {[weak self] image  in
                                let indexPath = self?.vehiclesCollectionView.indexPath(for: cell)
                                if index == indexPath?.row {
                                    cell.vehicleImage.image = image
                                }
                            })
                        }
        }.disposed(by: disposeBag)
        
        vehiclesCollectionView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension VehiclesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.bounds.height - 1
        return CGSize(width: cellHeight, height: cellHeight)
    }
}

extension Sequence {
    func grouping<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
