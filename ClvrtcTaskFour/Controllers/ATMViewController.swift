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
    
    var groupedData: [String: [MKAnnotatedFacility]] = [:]
    
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
    
    lazy var activityIndicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background")
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(named: "titleColor")
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "cellBackground")
        configureCollectionView()
        presentActivityIndicator()
        activityIndicatorContainer.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.center = view.center
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func presentActivityIndicator() {
        view.addSubview(activityIndicatorContainer)
        activityIndicatorContainer.frame = view.bounds
        activityIndicatorContainer.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func showAtmFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные о банкоматах", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { [weak self] _ in
            
            let mapVC = self?.parent?.children[0] as? MapViewController
            mapVC?.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showBranchBankFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные о подразделениях банка", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { [weak self] _ in
            
            let mapVC = self?.parent?.children[0] as? MapViewController
            mapVC?.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showServiceTerminalFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные об инфокиосках", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { [weak self] _ in
            
            let mapVC = self?.parent?.children[0] as? MapViewController
            mapVC?.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showNoInternerConnectionAlert() {
        let noInternerConnectionAlert = UIAlertController(title: nil, message: "Приложение работает без доступа к интернету", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Хорошо", style: .default) { _ in
            noInternerConnectionAlert.dismiss(animated: true)
        }
        
        noInternerConnectionAlert.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(noInternerConnectionAlert, animated: true)
        }
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
        return groupedData.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedData[Array(groupedData.keys)[section]]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATMCollectionViewCell.identifier, for: indexPath) as? ATMCollectionViewCell else { return UICollectionViewCell() }
        
        if let ATMData = groupedData[Array(groupedData.keys)[indexPath.section]] {
            let ATMItem = ATMData[indexPath.row]
            cell.atmInstallationPlaceLabel.text = "\(ATMItem.streetName), \(ATMItem.buildingNumber) \n\(ATMItem.addressLine ?? "")"
            cell.operatingHoursLabel.text = "\(ATMItem.availability)"
            cell.dispensedCurrencyLabel.text = "\(ATMItem.currency!.dropLast(1))"
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ATMCollectionHeader.identifier, for: indexPath) as! ATMCollectionHeader
        
        header.configure()
        
        header.label.text = "\(Array(groupedData.keys)[indexPath.section])"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parentVC = self.parent as? MainViewController
        let mapVC = self.parent?.children[0] as? MapViewController
        let annotations = mapVC?.mapView.annotations
        var targetedItem: MKAnnotation!
        
        if let ATMData = groupedData[Array(groupedData.keys)[indexPath.section]] {
            let selectedItem = ATMData[indexPath.item]
            parentVC?.viewContainerSegmentedControl.selectedSegmentIndex = 0
            parentVC?.viewContainerSegmentedControl.sendAction(#selector(parentVC?.segmentedControlAction), to: parentVC, for: nil)
            targetedItem = annotations?.first(where: { $0.coordinate.latitude == selectedItem.latitude && $0.coordinate.longitude == selectedItem.longitude })
            mapVC?.mapView.selectAnnotation(targetedItem, animated: true)
        }
    }
}

