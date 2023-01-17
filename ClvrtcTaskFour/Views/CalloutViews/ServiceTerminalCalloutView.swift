//
//  ServiceTerminalCalloutView.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 14.01.23.
//

import Foundation
import UIKit
import SnapKit
import MapKit

protocol ServiceTerminalCalloutViewDelegate: AnyObject {
    func mapView(_ mapView: MKMapView, didTapCloseButton button: UIButton, for annotation: MKAnnotation)
}

class ServiceTerminalCalloutView: UIView {
    
    private let closeButton = UIButton(frame: .zero)
    private let installationPlaceLabel = UILabel(frame: .zero)
    private let operatingHoursLabel = UILabel(frame: .zero)
    private let currencyLabel = UILabel(frame: .zero)
    private let cashInAvailabilityLabel = UILabel(frame: .zero)
    private let mkAnnotatedServiceTerminal: MKAnnotatedServiceTerminal
    
    private var mapView: MKMapView? {
        var view = superview
        while view != nil {
            if let mapView = view as? MKMapView { return mapView }
            view = view?.superview
        }
        return nil
    }
    
    init(mkAnnotatedServiceTerminal: MKAnnotatedServiceTerminal) {
        self.mkAnnotatedServiceTerminal = mkAnnotatedServiceTerminal
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        setupCloseButton()
        setupInstallationPlaceLabel()
        setupOperatingHoursLabel()
        setupCurrencyLabel()
        setupCashInAvailabilityLabel()
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
    
    private func setupInstallationPlaceLabel() {
        installationPlaceLabel.font = .systemFont(ofSize: 12, weight: .regular)
        installationPlaceLabel.text = "Mecто установки: \(mkAnnotatedServiceTerminal.address.description), \(mkAnnotatedServiceTerminal.house)"
        installationPlaceLabel.numberOfLines = 0
        addSubview(installationPlaceLabel)
        installationPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        installationPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(closeButton.snp.left).offset(-5)
        }
    }
    
    private func setupOperatingHoursLabel() {
        
        operatingHoursLabel.font = .systemFont(ofSize: 12, weight: .regular)
        operatingHoursLabel.text = "Режим работы: \(mkAnnotatedServiceTerminal.workTime)"
        operatingHoursLabel.numberOfLines = 0
        addSubview(operatingHoursLabel)
        operatingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        operatingHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(installationPlaceLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
        }
    }
    
    private func setupCurrencyLabel() {
        currencyLabel.font = .systemFont(ofSize: 12, weight: .regular)
        currencyLabel.text = "Валюта: \(mkAnnotatedServiceTerminal.currency.dropLast(1))"
        currencyLabel.numberOfLines = 0
        addSubview(currencyLabel)
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.snp.makeConstraints { make in
            make.top.equalTo(operatingHoursLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
        }
    }
    
    private func setupCashInAvailabilityLabel() {
        
        if mkAnnotatedServiceTerminal.cashInExist == "да" {
            cashInAvailabilityLabel.text = "Прием наличных: доступно"
        } else {
            cashInAvailabilityLabel.text = "Прием наличных: недоступно"
        }
 
        cashInAvailabilityLabel.font = .systemFont(ofSize: 12, weight: .regular)
        cashInAvailabilityLabel.numberOfLines = 0
        addSubview(cashInAvailabilityLabel)
        cashInAvailabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        cashInAvailabilityLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
    }
        
    @objc func didTapCloseButton() {
        if let mapView = mapView, let delegate = mapView.delegate as? ServiceTerminalCalloutViewDelegate {
            delegate.mapView(mapView, didTapCloseButton: UIButton(type: .custom), for: mkAnnotatedServiceTerminal)
        }
    }
}
