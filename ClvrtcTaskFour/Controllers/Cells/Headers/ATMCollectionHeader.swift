//
//  ATMCollectionHeader.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 8.01.23.
//

import UIKit

class ATMCollectionHeader: UICollectionReusableView {
    
    static let identifier = "ATMCollectionHeader"
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "title")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    public func configure() {
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
