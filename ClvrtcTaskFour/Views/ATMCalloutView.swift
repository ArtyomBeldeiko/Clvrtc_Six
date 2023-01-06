//
//  ATMCalloutView.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 3.01.23.
//

import Foundation
import UIKit
import SnapKit
import MapKit

protocol ATMCalloutViewDelegate: AnyObject {
    func mapView(_ mapView: MKMapView, didTapCloseButton button: UIButton, for annotation: MKAnnotation)
    func mapView(_ mapView: MKMapView, didTapDetailButton button: UIButton, for annotation: MKAnnotation)
}

class ATMCalloutView: UIView {
    
    private let closeButton = UIButton(frame: .zero)
    private let installationPlaceLabel = UILabel(frame: .zero)
    private let operatingHoursLabel = UILabel(frame: .zero)
    private let currencyLabel = UILabel(frame: .zero)
    private let cashInAvailabilityLabel = UILabel(frame: .zero)
    private let detailButton = UIButton(frame: .zero)
    private let mkAnnotatedATM: MKAnnotatedATM
    
    private var mapView: MKMapView? {
        var view = superview
        while view != nil {
            if let mapView = view as? MKMapView { return mapView }
            view = view?.superview
        }
        return nil
    }
    
    init(mkAnnotatedATM: MKAnnotatedATM) {
        self.mkAnnotatedATM = mkAnnotatedATM
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
    
    private func setupInstallationPlaceLabel() {
        installationPlaceLabel.font = .systemFont(ofSize: 12, weight: .regular)
        installationPlaceLabel.text = "Mecто установки: \(mkAnnotatedATM.address.addressLine)"
        installationPlaceLabel.numberOfLines = 0
        addSubview(installationPlaceLabel)
        installationPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        installationPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
        }
    }
    
    private func setupOperatingHoursLabel() {
        
        let formattedDate = datesFormatter(mkAnnotatedATM.availability.standardAvailability.day)
        
        operatingHoursLabel.font = .systemFont(ofSize: 12, weight: .regular)
        operatingHoursLabel.text = "Режим работы: \(formattedDate)"
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
        currencyLabel.text = "Выдаваемая валюта: \(mkAnnotatedATM.baseCurrency.rawValue)"
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
        
        if mkAnnotatedATM.services.contains(where: { $0.serviceType.rawValue.hasPrefix("Прием наличных")}) {
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
        }
    }
    
    private func setupDetailButton() {
        detailButton.setTitle("Подробнее", for: .normal)
        detailButton.setTitleColor(.red, for: .normal)
        addSubview(detailButton)
        detailButton.addTarget(self, action: #selector(presentDetailedATMInfoVC), for: .touchUpInside)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(cashInAvailabilityLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    @objc func didTapCloseButton() {
        if let mapView = mapView, let delegate = mapView.delegate as? ATMCalloutViewDelegate {
            delegate.mapView(mapView, didTapCloseButton: UIButton(type: .custom), for: mkAnnotatedATM)
        }
    }
    
    @objc private func presentDetailedATMInfoVC() {
        if let mapView = mapView, let delegate = mapView.delegate as? ATMCalloutViewDelegate {
            delegate.mapView(mapView, didTapDetailButton: UIButton(type: .custom), for: mkAnnotatedATM)
        }
    }
}
