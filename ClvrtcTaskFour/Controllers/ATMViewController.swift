//
//  ATMViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 28.12.22.
//

import UIKit
import SnapKit
import MapKit

class ATMViewController: UIViewController {
    
    var groupedATMData: [String: [ATM]] = [:]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ATMCollectionViewCell.self, forCellWithReuseIdentifier: ATMCollectionViewCell.identifier)
        collectionView.register(ATMCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ATMCollectionHeader.identifier)
        collectionView.backgroundColor = UIColor(named: "collectionViewBackground")
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        fetchATMData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "cellBackground")
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    func fetchATMData() {
        if Reachability.isConnectedToNetwork() {
            NetworkManager.shared.getATMData { result in
                switch result {
                case .success(let data):
                    var fetchedData = [ATM]()
                    fetchedData.append(contentsOf: data.data.atm)
                    self.groupedATMData = Dictionary(grouping: fetchedData, by: { $0.address.townName })
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                case .failure(_):
                    self.showNetworkFetchFailureAlert()
                }
            }
        } else {
            showNoInternerConnectionAlert()
        }
    }
    
    private func showNetworkFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: nil, message: "Ошибка", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { _ in
            self.fetchATMData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    private func showNoInternerConnectionAlert() {
        let noInternerConnectionAlert = UIAlertController(title: nil, message: "Приложение работает без доступа к интернету", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Хорошо", style: .default) { _ in
            noInternerConnectionAlert.dismiss(animated: true)
        }
        
        noInternerConnectionAlert.addAction(okAction)
        
        self.present(noInternerConnectionAlert, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ATMViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddigWidth = 10 * (3 + 1)
        let availableWidth = collectionView.frame.width - CGFloat(paddigWidth)
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: widthPerItem * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: - UICollectionViewDataSource

extension ATMViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupedATMData.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedATMData[Array(groupedATMData.keys)[section]]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATMCollectionViewCell.identifier, for: indexPath) as? ATMCollectionViewCell else { return UICollectionViewCell() }
        
        if let ATMData = groupedATMData[Array(groupedATMData.keys)[indexPath.section]] {
            let ATMItem = ATMData[indexPath.row]
            cell.atmInstallationPlaceLabel.text = "\(ATMItem.address.streetName), \(ATMItem.address.buildingNumber) \n\(ATMItem.address.addressLine)"
            cell.operatingHoursLabel.text = atmDatesFormatter((ATMItem.availability.standardAvailability.day))
            cell.dispensedCurrencyLabel.text = ATMItem.currency.rawValue
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ATMCollectionHeader.identifier, for: indexPath) as! ATMCollectionHeader
        
        header.configure()
        
        header.label.text = "\(Array(groupedATMData.keys)[indexPath.section])"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let ATMData = groupedATMData[Array(groupedATMData.keys)[indexPath.section]] {
            let selectedATMItem = ATMData[indexPath.item]
            
            if let parentVC = self.parent as? MainViewController {
                parentVC.viewContainerSegmentedControl.selectedSegmentIndex = 0
                parentVC.viewContainerSegmentedControl.sendAction(#selector(parentVC.segmentedControlAction), to: parentVC, for: nil)
                
                if let mapVC = parentVC.children[0] as? MapViewController {
                    if mapVC.annotatedATMData != nil {
                        let annotation = mapVC.annotatedATMData.contains(where: { $0.atmID == selectedATMItem.atmID })
                        mapVC.mapView.selectAnnotation(annotation as! MKAnnotation, animated: true)
                    }
                }
            }
        }
    }
}

