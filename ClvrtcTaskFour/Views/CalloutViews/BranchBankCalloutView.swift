//
//  BranchBankCalloutView.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 14.01.23.
//

import Foundation
import UIKit
import SnapKit
import MapKit

protocol BranchBankCalloutViewDelegate: AnyObject {
    func mapView(_ mapView: MKMapView, didTapCloseButton button: UIButton, for annotation: MKAnnotation)
}

class BranchBankCalloutView: UIView {
    
    private let closeButton = UIButton(frame: .zero)
    private let addressLabel = UILabel(frame: .zero)
    private let operatingHoursLabel = UILabel(frame: .zero)
    private let mkAnnotatedBranchBank: MKAnnotatedBranchBank
    
    private var mapView: MKMapView? {
        var view = superview
        while view != nil {
            if let mapView = view as? MKMapView { return mapView }
            view = view?.superview
        }
        return nil
    }
    
    init(mkAnnotatedBranchBank: MKAnnotatedBranchBank) {
        self.mkAnnotatedBranchBank = mkAnnotatedBranchBank
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        setupCloseButton()
        setupAddressLabel()
        setupOperatingHoursLabel()
    }
    
    private func setupCloseButton() {
        let image = UIImage(systemName: "xmark.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        closeButton.setImage(image, for: .normal)
        addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(-8)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.right.equalTo(snp.right).offset(5)
        }
    }
    
    private func setupAddressLabel() {
        addressLabel.font = .systemFont(ofSize: 12, weight: .regular)
        addressLabel.text = "Адрес: \(mkAnnotatedBranchBank.townName), \(mkAnnotatedBranchBank.streetName), \(mkAnnotatedBranchBank.buildingNumber)"
        addressLabel.numberOfLines = 0
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(closeButton.snp.left).offset(-5)
        }
    }
    
    private func setupOperatingHoursLabel() {
    
        operatingHoursLabel.font = .systemFont(ofSize: 12, weight: .regular)
        operatingHoursLabel.text = "Режим работы: \(mkAnnotatedBranchBank.standardAvailability)"
        operatingHoursLabel.numberOfLines = 0
        addSubview(operatingHoursLabel)
        operatingHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
    }
            
    @objc func didTapCloseButton() {
        if let mapView = mapView, let delegate = mapView.delegate as? BranchBankCalloutViewDelegate {
            delegate.mapView(mapView, didTapCloseButton: UIButton(type: .custom), for: mkAnnotatedBranchBank)
        }
    }
}

