//
//  MainViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 27.12.22.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

class MainViewController: UIViewController {
    
    let containerViewModes = ["Map", "ATM List"]
    
    var mapVC = MapViewController()
    var ATMListVC = ATMViewController()
    
    //    MARK: - UI Elements
    
    lazy var viewContainerSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: containerViewModes)
        let normalText = UIFont.systemFont(ofSize: 16, weight: .regular)
        let selectedText = UIFont.systemFont(ofSize: 18, weight: .bold)
        segmentedControl.backgroundColor = UIColor(named: "background")
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : normalText], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : selectedText], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        setupViews()
    }
    
    private func configureNavigationBar() {
        let refreshImage = UIImage(systemName: "arrow.clockwise.circle")?.withTintColor(UIColor(named: "refreshButton")!).withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(uploadAction))
        navigationItem.title = "Map"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "background")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "titleColor")!]
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "background")
        
        view.addSubview(viewContainerSegmentedControl)
        view.addSubview(containerView)
        
        viewContainerSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(viewContainerSegmentedControl.snp.bottom)
            make.left.right.equalTo(view)
            make.bottomMargin.equalTo(view.snp.bottom)
        }
        
        setupContainerView()
    }
    
    private func setupContainerView() {
        addChild(mapVC)
        addChild(ATMListVC)
        
        containerView.addSubview(mapVC.view)
        containerView.addSubview(ATMListVC.view)
        
        mapVC.didMove(toParent: self)
        ATMListVC.didMove(toParent: self)
        
        mapVC.view.frame = containerView.bounds
        ATMListVC.view.frame = containerView.bounds
        
        ATMListVC.view.isHidden = true
    }
    
    @objc private func uploadAction() {
        let backgroundQueue = DispatchQueue(label: "ClvrtcTaskFour.Beldeiko.Clevertec.backgroundQueue", qos: .background, attributes: .concurrent)
        let annotatedBranchBankData = self.mapVC.annotatedBranchBankData
        let annotattedServiceTerminal = self.mapVC.annotatedServiceTerminalData
        
        var atmData = [ATM]()
        var branchBankData = [BankBranch]()
        var serviceTerminalData = [ServiceTerminal]()
    
        if Reachability.isConnectedToNetwork() {
            
            DispatchQueue.main.async {
                self.mapVC.activityIndicatorContainer.isHidden = false
                self.mapVC.makeUIInactive()
                self.mapVC.mapView.removeAnnotations(self.mapVC.mapView.annotations)
            }
            
            NetworkManager.shared.getATMData { result in
                switch result {
                case .success(let data):
                    self.mapVC.annotatedATMData.removeAll()
                    atmData = data.data.atm
                    
                case .failure(_):
                    self.mapVC.showAtmFetchFailureAlert()
                }
                
                for atmDataItem in atmData {
                    self.mapVC.annotatedATMData.append(MKAnnotatedATM(atmID: atmDataItem.atmID, type: atmDataItem.type.rawValue, baseCurrency: atmDataItem.baseCurrency.rawValue, currency: atmDataItem.currency.rawValue, cards: cardsFormatter(atmDataItem.cards), currentStatus: atmDataItem.currentStatus.rawValue, streetName: atmDataItem.address.streetName, townName: atmDataItem.address.townName, buildingNumber: atmDataItem.address.buildingNumber, addressLine: atmDataItem.address.addressLine, addressDiscription: atmDataItem.address.addressDescription.rawValue, latitude: atmDataItem.address.geolocation.geographicCoordinates.latitude, longitude: atmDataItem.address.geolocation.geographicCoordinates.longitude, serviceType: servicesFormatter(atmDataItem.services), access24Hours: atmDataItem.availability.access24Hours, isRescticted: atmDataItem.availability.isRestricted, sameAsOrganization: atmDataItem.availability.sameAsOrganization, standardAvailability: atmDatesFormatter(atmDataItem.availability.standardAvailability.day), contactDetails: atmDataItem.contactDetails.phoneNumber))
                    
                    
                    
                    
//                    self.mapVC.annotatedATMData.append(MKAnnotatedATM(atmID: atmDataItem.atmID, type: atmDataItem.type, baseCurrency: atmDataItem.baseCurrency, currency: atmDataItem.currency, cards: atmDataItem.cards, currentStatus: atmDataItem.currentStatus, address: atmDataItem.address, services: atmDataItem.services, availability: atmDataItem.availability, contactDetails: atmDataItem.contactDetails, coordinate: CLLocationCoordinate2D(latitude: Double(atmDataItem.address.geolocation.geographicCoordinates.latitude)!, longitude: Double(atmDataItem.address.geolocation.geographicCoordinates.longitude)!)))
                }
                
                self.mapVC.annotatedATMData = self.mapVC.annotatedATMData.sorted { $0.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) < $1.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) }
                
                DispatchQueue.main.async {
                    self.mapVC.mapView.addAnnotations(self.mapVC.annotatedATMData)
                    self.mapVC.activityIndicatorContainer.isHidden = true
                    self.mapVC.makeUIActive()
                }
            }
            
            backgroundQueue.async {
                NetworkManager.shared.getBranchBankData { result in
                    switch result {
                    case .success(let data):
                        self.mapVC.annotatedBranchBankData.removeAll()
                        branchBankData = data.data.branch
                        
                    case .failure(_):
                        self.mapVC.showBranchBankFetchFailureAlert()
                    }
                    
                    for branchBankDataItem in branchBankData {
                        self.mapVC.annotatedBranchBankData.append(MKAnnotatedBranchBank(branchID: branchBankDataItem.branchId, name: branchBankDataItem.name, cbu: branchBankDataItem.cbu, accountNumber: branchBankDataItem.accountNumber, equeue: branchBankDataItem.equeue, wifi: branchBankDataItem.wifi, accessibilities: branchBankDataItem.accessibilities, branchBankAddress: branchBankDataItem.address, information: branchBankDataItem.information, services: branchBankDataItem.services, coordinate: CLLocationCoordinate2D(latitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.latitude)!, longitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.longitude)!)))
                    }
                    
                    self.mapVC.annotatedBranchBankData = self.mapVC.annotatedBranchBankData.sorted { $0.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) < $1.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) }
                    
                    DispatchQueue.main.async {
                        self.mapVC.mapView.addAnnotations(self.mapVC.annotatedBranchBankData)
                    }
                }
            }
            
            backgroundQueue.async {
                NetworkManager.shared.getServiceTerminalData { result in
                    switch result {
                    case .success(let data):
                        self.mapVC.annotatedServiceTerminalData.removeAll()
                        serviceTerminalData = data
                        
                    case .failure(_):
                        self.mapVC.showServiceTerminalFetchFailureAlert()
                        self.ATMListVC.showServiceTerminalFetchFailureAlert()
                        
                        DispatchQueue.main.async {
                            self.mapVC.mapView.addAnnotations(self.mapVC.annotatedServiceTerminalData)
                        }
                    }
                    
                    for serviceTerminalItem in serviceTerminalData {
                        self.mapVC.annotatedServiceTerminalData.append(MKAnnotatedServiceTerminal(infoID: serviceTerminalItem.infoID, city: serviceTerminalItem.city, addressType: serviceTerminalItem.addressType.rawValue, address: serviceTerminalItem.address, house: serviceTerminalItem.house, installPlace: serviceTerminalItem.installPlace, locationNameDesc: serviceTerminalItem.locationNameDesc, workTime: serviceTerminalItem.workTime, timeLong: serviceTerminalItem.timeLong, gpsX: serviceTerminalItem.gpsX, gpsY: serviceTerminalItem.gpsY, currency: serviceTerminalItem.currency.rawValue, cashInExist: serviceTerminalItem.cashInExist.rawValue))
                        
                        
//                        self.mapVC.annotatedServiceTerminalData.append(MKAnnotatedServiceTerminal(infoID: serviceTerminalItem.infoID, area: serviceTerminalItem.area, cityType: serviceTerminalItem.cityType, city: serviceTerminalItem.city, addressType: serviceTerminalItem.addressType, address: serviceTerminalItem.address, house: serviceTerminalItem.house, installPlace: serviceTerminalItem.installPlace, locationNameDesc: serviceTerminalItem.locationNameDesc, workTime: serviceTerminalItem.workTime, timeLong: serviceTerminalItem.timeLong, gpsX: serviceTerminalItem.gpsX, gpsY: serviceTerminalItem.gpsY, serviceTerminalCurrency: serviceTerminalItem.currency, infType: serviceTerminalItem.infType, cashInExist: serviceTerminalItem.cashIn, cashIn: serviceTerminalItem.cashIn, typeCashIn: serviceTerminalItem.cashIn, infPrinter: serviceTerminalItem.infPrinter, regionPlatej: serviceTerminalItem.regionPlatej, popolneniePlatej: serviceTerminalItem.popolneniePlatej, infStatus: serviceTerminalItem.infStatus, coordinate: CLLocationCoordinate2D(latitude: Double(serviceTerminalItem.gpsX)!, longitude: Double(serviceTerminalItem.gpsY)!)))
                    }
                    
                    self.mapVC.annotatedServiceTerminalData = self.mapVC.annotatedServiceTerminalData.sorted { $0.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) < $1.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) }
                    
                    DispatchQueue.main.async {
                        self.mapVC.mapView.addAnnotations(self.mapVC.annotatedServiceTerminalData)
                    }
                }
            }
            
        } else {
            mapVC.showNoInternerConnectionAlert()
            ATMListVC.showNoInternerConnectionAlert()
        }
    }
    
    @objc func segmentedControlAction() {
        mapVC.view.isHidden = true
        ATMListVC.view.isHidden = true
        
        if viewContainerSegmentedControl.selectedSegmentIndex == 0 {
            mapVC.view.isHidden = false
            navigationItem.title = containerViewModes.first
        } else {
            ATMListVC.view.isHidden = false
            ATMListVC.collectionView.reloadData()
            navigationItem.title = containerViewModes.last
        }
    }
}
