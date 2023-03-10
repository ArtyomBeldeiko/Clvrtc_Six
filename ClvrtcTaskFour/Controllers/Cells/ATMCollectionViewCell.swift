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
    
    lazy var atmInstallationPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var operatingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var dispensedCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = UIColor(named: "collectionViewBackground")
        setupCollectionViewCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        atmInstallationPlaceLabel.frame = contentView.bounds
        operatingHoursLabel.frame = contentView.bounds
        dispensedCurrencyLabel.frame = contentView.bounds
        
        contentView.backgroundColor = UIColor(named: "cellBackground")
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
            make.top.equalTo(atmInstallationPlaceLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
        
        dispensedCurrencyLabel.snp.makeConstraints { make in
            make.top.equalTo(operatingHoursLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
        }
    }    
}
