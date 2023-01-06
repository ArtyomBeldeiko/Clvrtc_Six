//
//  ATMDetailedInfoViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 5.01.23.
//

import UIKit
import SnapKit

class ATMDetailedInfoViewController: UIViewController {
    
    private var contentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentSize = contentSize
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame.size = contentSize
        return view
    }()
    
    private let createRouteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Построить маршрут", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let baseCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let geolocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let servicesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let access24hoursLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let restrictedAccessLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let organizationOperatingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let standardAvailabilityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contactDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.contentSize = self.contentSize
    }
    
    private func setupViews() {
        
        view.addSubview(createRouteButton)
        view.addSubview(scrollView)
        
        createRouteButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalTo(240)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(createRouteButton.snp.top).offset(-5)
        }
        
        setupScrollView()
    }
    
    private func setupScrollView() {
        scrollView.addSubview(contentView)
        contentView.addSubview(idLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(baseCurrencyLabel)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(cardsLabel)
        contentView.addSubview(currentStatusLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(geolocationLabel)
        contentView.addSubview(servicesLabel)
        contentView.addSubview(access24hoursLabel)
        contentView.addSubview(restrictedAccessLabel)
        contentView.addSubview(organizationOperatingHoursLabel)
        contentView.addSubview(standardAvailabilityLabel)
        contentView.addSubview(contactDetailsLabel)
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        baseCurrencyLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        currencyLabel.snp.makeConstraints { make in
            make.top.equalTo(baseCurrencyLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        cardsLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        currentStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(cardsLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(currentStatusLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        geolocationLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        servicesLabel.snp.makeConstraints { make in
            make.top.equalTo(geolocationLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        access24hoursLabel.snp.makeConstraints { make in
            make.top.equalTo(servicesLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        restrictedAccessLabel.snp.makeConstraints { make in
            make.top.equalTo(access24hoursLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        organizationOperatingHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(restrictedAccessLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        standardAvailabilityLabel.snp.makeConstraints { make in
            make.top.equalTo(organizationOperatingHoursLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        contactDetailsLabel.snp.makeConstraints { make in
            make.top.equalTo(standardAvailabilityLabel.snp.bottom).offset(6)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
    }
}
