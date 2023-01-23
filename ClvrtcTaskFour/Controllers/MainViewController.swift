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
    
    
    lazy var viewContainerSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: containerViewModes)
        let normalText = UIFont.systemFont(ofSize: 16, weight: .regular)
        let selectedText = UIFont.systemFont(ofSize: 18, weight: .bold)
        segmentedControl.backgroundColor = UIColor(named: "background")
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : normalText], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : selectedText], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        return segmentedControl
    }()
    
    private let containerView: UIView = {
        let view = UIView()
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
        
        var atmData = [ATM]()
        var branchBankData = [BankBranch]()
        var serviceTerminalData = [ServiceTerminal]()
    
        if Reachability.isConnectedToNetwork() {
            
            DispatchQueue.main.async { [weak self] in
                self?.mapVC.activityIndicatorContainer.isHidden = false
                self?.mapVC.makeUIInactive()
                self?.mapVC.mapView.removeAnnotations(self?.mapVC.mapView.annotations ?? [])
            }
            
            NetworkManager.shared.getATMData { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.mapVC.annotatedATMData.removeAll()
                    atmData = data.data.atm
                    
                case .failure(_):
                    self.mapVC.showAtmFetchFailureAlert()
                }
                
                for atmDataItem in atmData {
                    self.mapVC.annotatedATMData.append(MKAnnotatedATM(atmID: atmDataItem.atmID,
                                                                      type: atmDataItem.type.rawValue,
                                                                      baseCurrency: atmDataItem.baseCurrency.rawValue,
                                                                      currency: atmDataItem.currency.rawValue,
                                                                      cards: cardsFormatter(atmDataItem.cards),
                                                                      currentStatus: atmDataItem.currentStatus.rawValue,
                                                                      streetName: atmDataItem.address.streetName,
                                                                      townName: atmDataItem.address.townName,
                                                                      buildingNumber: atmDataItem.address.buildingNumber,
                                                                      addressLine: atmDataItem.address.addressLine,
                                                                      addressDiscription: atmDataItem.address.addressDescription.rawValue,
                                                                      latitude: atmDataItem.address.geolocation.geographicCoordinates.latitude,
                                                                      longitude: atmDataItem.address.geolocation.geographicCoordinates.longitude,
                                                                      serviceType: servicesFormatter(atmDataItem.services),
                                                                      access24Hours: atmDataItem.availability.access24Hours,
                                                                      isRescticted: atmDataItem.availability.isRestricted,
                                                                      sameAsOrganization: atmDataItem.availability.sameAsOrganization,
                                                                      standardAvailability: atmDatesFormatter(atmDataItem.availability.standardAvailability.day),
                                                                      contactDetails: atmDataItem.contactDetails.phoneNumber))
                }
                
                self.mapVC.annotatedATMData = self.mapVC.annotatedATMData.sorted { $0.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) < $1.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) }
                
                DispatchQueue.main.async {
                    self.mapVC.mapView.addAnnotations(self.mapVC.annotatedATMData)
                    self.mapVC.activityIndicatorContainer.isHidden = true
                    self.mapVC.makeUIActive()
                }
            }
            
            backgroundQueue.async { [weak self] in
                
                guard let self = self else { return }
                
                NetworkManager.shared.getBranchBankData { result in
                    switch result {
                    case .success(let data):
                        self.mapVC.annotatedBranchBankData.removeAll()
                        branchBankData = data.data.branch
                        
                    case .failure(_):
                        self.mapVC.showBranchBankFetchFailureAlert()
                    }
                    
                    for branchBankDataItem in branchBankData {
                        self.mapVC.annotatedBranchBankData.append(MKAnnotatedBranchBank(branchID: branchBankDataItem.branchId,
                                                                                         name: branchBankDataItem.name,
                                                                                         cbu: branchBankDataItem.cbu,
                                                                                         equeue: branchBankDataItem.equeue,
                                                                                         wifi: branchBankDataItem.wifi,
                                                                                         streetName: branchBankDataItem.address.streetName,
                                                                                         buildingNumber: branchBankDataItem.address.buildingNumber,
                                                                                         department: branchBankDataItem.address.department,
                                                                                         townName: branchBankDataItem.address.townName,
                                                                                         addressLine: branchBankDataItem.address.addressLine,
                                                                                         addressDescription: branchBankDataItem.address.description,
                                                                                         latitude: branchBankDataItem.address.geoLocation.geographicCoordinates.latitude,
                                                                                         longitude: branchBankDataItem.address.geoLocation.geographicCoordinates.longitude,
                                                                                         standardAvailability:branchBankDatesFormatter(branchBankDataItem.information.availability.standardAvailability.day),
                                                                                         currency: branchBankDataItem.services.currencyExchange.description))
                    }
                    
                    self.mapVC.annotatedBranchBankData = self.mapVC.annotatedBranchBankData.sorted { $0.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) < $1.distance(to: self.mapVC.currentLocation ?? self.mapVC.defaultLocation) }
                    
                    DispatchQueue.main.async {
                        self.mapVC.mapView.addAnnotations(self.mapVC.annotatedBranchBankData)
                    }
                }
            }
            
            backgroundQueue.async { [weak self] in
                
                guard let self = self else { return }
                
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
                        self.mapVC.annotatedServiceTerminalData.append(MKAnnotatedServiceTerminal(infoID: serviceTerminalItem.infoID,
                                                                                                  city: serviceTerminalItem.city,
                                                                                                  addressType: serviceTerminalItem.addressType.rawValue,
                                                                                                  address: serviceTerminalItem.address,
                                                                                                  house: serviceTerminalItem.house,
                                                                                                  installPlace: serviceTerminalItem.installPlace,
                                                                                                  locationNameDesc: serviceTerminalItem.locationNameDesc,
                                                                                                  workTime: serviceTerminalItem.workTime,
                                                                                                  timeLong: serviceTerminalItem.timeLong,
                                                                                                  gpsX: serviceTerminalItem.gpsX,
                                                                                                  gpsY: serviceTerminalItem.gpsY,
                                                                                                  currency: serviceTerminalItem.currency.rawValue,
                                                                                                  cashInExist: serviceTerminalItem.cashInExist.rawValue))
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
