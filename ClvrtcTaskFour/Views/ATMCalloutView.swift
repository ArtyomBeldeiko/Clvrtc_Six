//
//  ATMCalloutView.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 3.01.23.
//

import Foundation
import UIKit
import SnapKit

class ATMCalloutView: UIView {
    
    private let installationPlaceLabel = UILabel(frame: .zero)
    private let operatingHoursLabel = UILabel(frame: .zero)
    private let currencyLabel = UILabel(frame: .zero)
    private let cashInAvailabilityLabel = UILabel(frame: .zero)
    private let detailButton = UIButton(frame: .zero)
    private let mkAnnotatedATM: MKAnnotatedATM
    
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
        setupInstallationPlaceLabel()
        setupOperatingHoursLabel()
        setupCurrencyLabel()
        setupCashInAvailabilityLabel()
        setupDetailButton()
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
        operatingHoursLabel.font = .systemFont(ofSize: 12, weight: .regular)
        operatingHoursLabel.text = "Режим работы: \(mkAnnotatedATM.availability.standardAvailability.day.description)"
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
        detailButton.setTitleColor(.black, for: .normal)
        addSubview(detailButton)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(cashInAvailabilityLabel.snp.bottom).offset(5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
    }
}
