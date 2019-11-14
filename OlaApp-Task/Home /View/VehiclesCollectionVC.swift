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
    var selectedVehicle = PublishSubject<Vehicle>()
    var selectesIndex = PublishSubject<Int>()
    let imageProvider = ImageProvider()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        makeDefaultSelection()
        bindSelectionAndDeselection()
    }
    
    //MARK:- UI setup & Binding
    func bindUI(){
        let nib = UINib(nibName: "VehicleCell", bundle: nil)
        vehiclesCollectionView.register(nib,
                                        forCellWithReuseIdentifier: String(describing: VehicleCell.self))
        
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
                        cell.vehicleImage.image = image?.resizeImage()
                        if image == nil {
                            self.imageProvider.loadImages(from :mediaUrl, completion: {[weak self] image  in
                                let indexPath = self?.vehiclesCollectionView.indexPath(for: cell)
                                if index == indexPath?.row {
                                    cell.vehicleImage.image = image.resizeImage()
                                }
                            })
                        }
        }.disposed(by: disposeBag)
        
        vehiclesCollectionView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    //MARK: - Pre selected cell
    func makeDefaultSelection(){
        vehiclesList.subscribe(onNext: {[weak self] models in
            if models.count != 0{
                let selectedIndexPath = IndexPath(item: 0, section: 0)
                self?.selectedVehicle.onNext(models[selectedIndexPath.row])
                self?.selectedCell(at: selectedIndexPath)
            }
        }).disposed(by: disposeBag)
    }
    
    func selectedCell(at index: IndexPath){
        DispatchQueue.main.async {[weak self] in
            self?.selectesIndex.onNext(index.row)
            self?.vehiclesCollectionView.selectItem(at: index,
                                                    animated: true,
                                                    scrollPosition: .centeredHorizontally)
        }
    }
    
    //MARK: - Binding Collection View Selection
    func bindSelectionAndDeselection(){
        Observable.zip(vehiclesCollectionView.rx.itemSelected,
                       vehiclesCollectionView.rx.modelSelected(Vehicle.self))
            .bind{ [weak self] indexPath, model in
                self?.selectedVehicle.onNext(model)
                self?.selectedCell(at: indexPath)
        }.disposed(by: disposeBag)
    }
    
}

//MARK: - Collection View Delegate FlowLayout
extension VehiclesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.bounds.height - 1
        return CGSize(width: cellHeight, height: cellHeight)
    }
}

