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
    func mapView(_ mapView: MKMapView, didTapDetailButton button: UIButton, for annotation: MKAnnotation)
}

class BranchBankCalloutView: UIView {
    
    private let closeButton = UIButton(frame: .zero)
    private let addressLabel = UILabel(frame: .zero)
    private let operatingHoursLabel = UILabel(frame: .zero)
    private let detailButton = UIButton(frame: .zero)
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
        setupDetailButton()
    }
    
    private func setupCloseButton() {
        let image = UIImage(systemName: "xmark.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        closeButton.setImage(image, for: .normal)
        addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(-8)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.right.equalTo(snp.right).offset(5)
        }
    }
    
    private func setupAddressLabel() {
        addressLabel.font = .systemFont(ofSize: 12, weight: .regular)
        addressLabel.text = "Адрес: \(mkAnnotatedBranchBank.branchBankAddress.townName), \(mkAnnotatedBranchBank.branchBankAddress.streetName), \(mkAnnotatedBranchBank.branchBankAddress.buildingNumber)"
        addressLabel.numberOfLines = 0
        addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
        }
    }
    
    private func setupOperatingHoursLabel() {
    
        let formattedDate = branchBankDatesFormatter(mkAnnotatedBranchBank.information.availability.standardAvailability.day)
        
        operatingHoursLabel.font = .systemFont(ofSize: 12, weight: .regular)
        operatingHoursLabel.text = "Режим работы: \(formattedDate)"
        operatingHoursLabel.numberOfLines = 0
        addSubview(operatingHoursLabel)
        operatingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        operatingHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
        }
    }
        
    private func setupDetailButton() {
        detailButton.setTitle("Подробнее", for: .normal)
        detailButton.setTitleColor(.red, for: .normal)
        addSubview(detailButton)
        detailButton.addTarget(self, action: #selector(presentDetailedATMInfoVC), for: .touchUpInside)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(operatingHoursLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    @objc func didTapCloseButton() {
        if let mapView = mapView, let delegate = mapView.delegate as? ATMCalloutViewDelegate {
            delegate.mapView(mapView, didTapCloseButton: UIButton(type: .custom), for: mkAnnotatedBranchBank)
        }
    }
    
    @objc private func presentDetailedATMInfoVC() {
        if let mapView = mapView, let delegate = mapView.delegate as? ATMCalloutViewDelegate {
            delegate.mapView(mapView, didTapDetailButton: UIButton(type: .custom), for: mkAnnotatedBranchBank)
        }
    }
}

