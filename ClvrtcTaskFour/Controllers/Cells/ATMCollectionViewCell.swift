//
//  ATMCollectionViewCell.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 7.01.23.
//

import UIKit
import SnapKit

class ATMCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ATMCollectionViewCell"
    
    let atmInstallationPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let operatingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dispensedCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupCollectionViewCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        atmInstallationPlaceLabel.frame = contentView.bounds
        operatingHoursLabel.frame = contentView.bounds
        dispensedCurrencyLabel.frame = contentView.bounds
        
        contentView.backgroundColor = UIColor(red: 201 / 255, green: 205 / 255, blue: 214 / 255, alpha: 1)
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionViewCell() {
        contentView.addSubview(atmInstallationPlaceLabel)
        contentView.addSubview(operatingHoursLabel)
        contentView.addSubview(dispensedCurrencyLabel)
        
        atmInstallationPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.left.equalTo(contentView.snp.left).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
        
        operatingHoursLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(atmInstallationPlaceLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView.snp.left).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
        
        dispensedCurrencyLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(operatingHoursLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView.snp.left).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
    }    
}
