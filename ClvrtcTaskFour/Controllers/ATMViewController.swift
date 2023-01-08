//
//  ATMViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 28.12.22.
//

import UIKit
import SnapKit

class ATMViewController: UIViewController {
    
    var ATMdata: [ATM]?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ATMCollectionViewCell.self, forCellWithReuseIdentifier: ATMCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        fetchATMData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func fetchATMData() {
        NetworkManager.shared.getATMData { result in
            switch result {
            case .success(let data):
                var fetchedData = [ATM]()
                fetchedData.append(contentsOf: data.data.atm)
                self.ATMdata = fetchedData
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
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
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ATMdata?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATMCollectionViewCell.identifier, for: indexPath) as? ATMCollectionViewCell else { return UICollectionViewCell() }
        
        if let data = ATMdata {
            cell.atmInstallationPlaceLabel.text = "\(data[indexPath.row].address.streetName), \(data[indexPath.row].address.buildingNumber) \n\(data[indexPath.row].address.addressLine)"
            cell.operatingHoursLabel.text = datesFormatter( data[indexPath.row].availability.standardAvailability.day)
            cell.dispensedCurrencyLabel.text = data[indexPath.row].currency.rawValue
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
        return cell
    }
}

