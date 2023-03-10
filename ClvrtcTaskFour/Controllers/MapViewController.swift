//
//  MapViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 28.12.22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //    MARK: - Constants
    
    let locationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: 52.425163, longitude: 31.015039)
    
    //    MARK: - Variables
    
    var annotatedATMData = [MKAnnotatedATM]()
    var annotatedBranchBankData = [MKAnnotatedBranchBank]()
    var annotatedServiceTerminalData = [MKAnnotatedServiceTerminal]()
    var annotatedFacilityData = [MKAnnotatedFacility]()
    var currentLocation: CLLocation?
    
    //    MARK: - UI Elements
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isPitchEnabled = true
        view.showsUserLocation = true
        return view
    }()
    
    lazy var activityIndicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background")
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(named: "titleColor")
        return activityIndicator
    }()
    
    override func loadView() {
        super.loadView()
        
        self.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        presentActivityIndicator()
        makeUIInactive()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.center = view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.frame = view.bounds
    }
    
    private func presentActivityIndicator() {
        view.addSubview(activityIndicatorContainer)
        activityIndicatorContainer.frame = view.bounds
        activityIndicatorContainer.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func renderLocation(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - fetchData
    
    func fetchData() {
        var atmData = [ATM]()
        var branchBankData = [BankBranch]()
        var serviceTerminalData = [ServiceTerminal]()
        var facilityData = [MKAnnotatedFacility]()
        
        let dispatchGroup = DispatchGroup()
        let listVC = self.parent?.children[1] as? ATMViewController
        
        if Reachability.isConnectedToNetwork() {
            
            dispatchGroup.enter()
            NetworkManager.shared.getATMData { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    atmData = data.data.atm
                    
                case .failure(_):
                    self.showAtmFetchFailureAlert()
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            NetworkManager.shared.getBranchBankData { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    branchBankData = data.data.branch
                    
                case .failure(_):
                    self.showBranchBankFetchFailureAlert()
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            NetworkManager.shared.getServiceTerminalData { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    serviceTerminalData = data
                    
                case .failure(_):
                    self.showServiceTerminalFetchFailureAlert()
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                
                for atmDataItem in atmData {
                    self.annotatedATMData.append(MKAnnotatedATM(atmID: atmDataItem.atmID,
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
                    
                    facilityData.append(MKAnnotatedFacility(id: atmDataItem.atmID,
                                                            currency: atmDataItem.currency.rawValue,
                                                            townName: atmDataItem.address.townName,
                                                            streetName: atmDataItem.address.streetName,
                                                            buildingNumber: atmDataItem.address.buildingNumber,
                                                            addressLine: atmDataItem.address.buildingNumber,
                                                            availability: atmDatesFormatter(atmDataItem.availability.standardAvailability.day),
                                                            latitude: Double(atmDataItem.address.geolocation.geographicCoordinates.latitude)!,
                                                            longitude: Double(atmDataItem.address.geolocation.geographicCoordinates.longitude)!))
                }
                
                self.annotatedATMData = self.annotatedATMData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                
                for branchBankDataItem in branchBankData {
                    self.annotatedBranchBankData.append(MKAnnotatedBranchBank(branchID: branchBankDataItem.branchId,
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
                    
                    facilityData.append(MKAnnotatedFacility(id: branchBankDataItem.branchId, currency: "",
                                                            townName: branchBankDataItem.address.townName,
                                                            streetName: branchBankDataItem.address.streetName,
                                                            buildingNumber: branchBankDataItem.address.buildingNumber,
                                                            addressLine: branchBankDataItem.address.addressLine,
                                                            availability: branchBankDatesFormatter(branchBankDataItem.information.availability.standardAvailability.day),
                                                            latitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.latitude)!,
                                                            longitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.longitude)!))
                }
                
                self.annotatedBranchBankData = self.annotatedBranchBankData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                
                for serviceTerminalItem in serviceTerminalData {
                    self.annotatedServiceTerminalData.append(MKAnnotatedServiceTerminal(infoID: serviceTerminalItem.infoID,
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
                    
                    facilityData.append(MKAnnotatedFacility(id: serviceTerminalItem.infoID.description,
                                                            currency: serviceTerminalItem.currency.rawValue,
                                                            townName: serviceTerminalItem.city,
                                                            streetName: serviceTerminalItem.address,
                                                            buildingNumber: serviceTerminalItem.house,
                                                            addressLine: serviceTerminalItem.locationNameDesc,
                                                            availability: serviceTerminalItem.workTime,
                                                            latitude: Double(serviceTerminalItem.gpsX)!,
                                                            longitude: Double(serviceTerminalItem.gpsY)!))
                }
                
                self.annotatedServiceTerminalData = self.annotatedServiceTerminalData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                
                self.mapView.addAnnotations(self.annotatedATMData)
                self.mapView.addAnnotations(self.annotatedServiceTerminalData)
                self.mapView.addAnnotations(self.annotatedBranchBankData)
                
                self.annotatedFacilityData = facilityData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                listVC?.groupedData = Dictionary(grouping: self.annotatedFacilityData, by: { $0.townName })
                
                DispatchQueue.main.async {
                    listVC?.collectionView.reloadData()
                }
                
                self.activityIndicatorContainer.isHidden = true
                self.makeUIActive()
                self.saveDataToDB()
            }
            
        } else {
            showNoInternerConnectionAlert()
            
            DataPersistenceManager.shared.fetchingMKAnnotatedATMData { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let atmData):
                    atmData.forEach { self.annotatedATMData.append(MKAnnotatedATM(atmID: $0.atmID!,
                                                                                  type: $0.type!,
                                                                                  baseCurrency: $0.baseCurrency!,
                                                                                  currency: $0.currency!,
                                                                                  cards: $0.cards!,
                                                                                  currentStatus: $0.currentStatus!,
                                                                                  streetName: $0.streetName!,
                                                                                  townName: $0.townName!,
                                                                                  buildingNumber: $0.buildingNumber!,
                                                                                  addressLine: $0.addressLine!,
                                                                                  addressDiscription: $0.addressDiscription!,
                                                                                  latitude: $0.latitude!,
                                                                                  longitude: $0.longitude!,
                                                                                  serviceType: $0.serviceType!,
                                                                                  access24Hours: $0.access24Hours,
                                                                                  isRescticted: $0.isRescticted,
                                                                                  sameAsOrganization: $0.sameAsOrganization,
                                                                                  standardAvailability: $0.standardAvailability!,
                                                                                  contactDetails: $0.contactDetails!)) }
                    
                    DispatchQueue.main.async {
                        self.mapView.addAnnotations(self.annotatedATMData)
                        self.activityIndicatorContainer.isHidden = true
                        self.makeUIActive()
                    }
                case .failure(_): break
                }
            }
            
            DataPersistenceManager.shared.fetchingMKAnnotatedBranchBankData { result in
                switch result {
                case .success(let branchBankData):
                    branchBankData.forEach { self.annotatedBranchBankData.append(MKAnnotatedBranchBank(branchID: $0.branchID!,
                                                                                                       name: $0.name!,
                                                                                                       cbu: $0.cbu!,
                                                                                                       equeue:  Int($0.equeue),
                                                                                                       wifi:  Int($0.wifi),
                                                                                                       streetName: $0.streetName!,
                                                                                                       buildingNumber: $0.buildingNumber!,
                                                                                                       department: $0.department!,
                                                                                                       townName: $0.townName!,
                                                                                                       addressLine: $0.addressLine!,
                                                                                                       addressDescription: $0.addressDescription!,
                                                                                                       latitude: $0.latitude!,
                                                                                                       longitude: $0.longitude!,
                                                                                                       standardAvailability: $0.standardAvailability!,
                                                                                                       currency: $0.currency!)) }
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        guard let self = self else { return }
                        
                        self.mapView.addAnnotations(self.annotatedBranchBankData)
                    }
                case .failure(_): break
                }
            }
            
            DataPersistenceManager.shared.fetchingMKAnnotatedServiceTerminalData { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let serviceTerminalData):
                    serviceTerminalData.forEach { self.annotatedServiceTerminalData.append(MKAnnotatedServiceTerminal(infoID: Int($0.infoID),
                                                                                                                      city: $0.city!,
                                                                                                                      addressType: $0.addressType!,
                                                                                                                      address: $0.address!,
                                                                                                                      house: $0.house!,
                                                                                                                      installPlace: $0.installPlace!,
                                                                                                                      locationNameDesc: $0.locationNameDesc!,
                                                                                                                      workTime: $0.workTime!,
                                                                                                                      timeLong: $0.timeLong!,
                                                                                                                      gpsX: $0.gpsX!,
                                                                                                                      gpsY: $0.gpsY!,
                                                                                                                      currency: $0.currency!,
                                                                                                                      cashInExist: $0.cashInExist!)) }
                    
                    DispatchQueue.main.async {
                        self.mapView.addAnnotations(self.annotatedServiceTerminalData)
                    }
                case .failure(_): break
                }
            }
            
            DataPersistenceManager.shared.fetchingMKAnnotatedFacilityData { result in
                switch result {
                case .success(let fetchedFacilityData):
                    fetchedFacilityData.forEach { facilityData.append(MKAnnotatedFacility(id: $0.id!,
                                                                                          currency: $0.currency!,
                                                                                          townName: $0.townName!,
                                                                                          streetName: $0.streetName!,
                                                                                          buildingNumber: $0.buildingNumber!,
                                                                                          addressLine: $0.addressLine!,
                                                                                          availability: $0.availability!,
                                                                                          latitude: $0.latitude,
                                                                                          longitude: $0.longitude)) }
                    
                    DispatchQueue.main.async {
                        listVC?.groupedData = Dictionary(grouping: facilityData, by: { $0.townName })
                        listVC?.collectionView.reloadData()
                    }
                case .failure(_): break
                }
            }
        }
    }
    
    private func saveDataToDB() {
        
        annotatedATMData.forEach { DataPersistenceManager.shared.storeMKAnnotatedATM(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
        
        annotatedBranchBankData.forEach { DataPersistenceManager.shared.storeMKAnnotatedBranchBank(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
        
        annotatedServiceTerminalData.forEach { DataPersistenceManager.shared.storeMKAnnotatedServiceTerminal(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
        
        annotatedFacilityData.forEach { DataPersistenceManager.shared.storeMKAnnotatedFacility(model: $0) { result in
            switch result {
            case .success(): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }}
    }
    
    func showAtmFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "????????????", message: "???? ?????????????? ?????????????????? ???????????? ?? ????????????????????", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "?????????????????? ?????? ??????", style: .default) { _ in
            self.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "??????????????", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showBranchBankFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "????????????", message: "???? ?????????????? ?????????????????? ???????????? ?? ???????????????????????????? ??????????", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "?????????????????? ?????? ??????", style: .default) { _ in
            self.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "??????????????", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showServiceTerminalFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "????????????", message: "???? ?????????????? ?????????????????? ???????????? ???? ??????????????????????", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "?????????????????? ?????? ??????", style: .default) { _ in
            self.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "??????????????", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showNoInternerConnectionAlert() {
        let noInternerConnectionAlert = UIAlertController(title: nil, message: "???????????????????? ???????????????? ?????? ?????????????? ?? ??????????????????", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "????????????", style: .default) { _ in
            noInternerConnectionAlert.dismiss(animated: true)
        }
        
        noInternerConnectionAlert.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(noInternerConnectionAlert, animated: true)
        }
    }
    
    func makeUIInactive() {
        if let parentVC = self.parent as? MainViewController {
            parentVC.viewContainerSegmentedControl.isUserInteractionEnabled = false
            parentVC.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func makeUIActive() {
        if let parentVC = self.parent as? MainViewController {
            parentVC.viewContainerSegmentedControl.isUserInteractionEnabled = true
            parentVC.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKind(of: MKUserLocation.self)) {
            return nil
        }
        
        let atmAnnotationIdentifier = "atmAnnotation"
        let branchBankIdentifier = "branchBankAnnotation"
        let serviceTerminalIdentifier = "serviceTerminalAnnotation"
        
        var view: MKAnnotationView!
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: atmAnnotationIdentifier) {
            view = dequedView
            view.annotation = annotation as? MKAnnotatedATM
        } else {
            if let annotatedATM = annotation as? MKAnnotatedATM {
                view = MKAnnotationView(annotation: annotatedATM, reuseIdentifier: atmAnnotationIdentifier)
                view.canShowCallout = true
                view.detailCalloutAccessoryView = ATMCalloutView(mkAnnotatedATM: annotatedATM)
                view.image = UIImage(named: "atm")
                view.frame.size = CGSize(width: 50, height: 50)
            }
        }
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: branchBankIdentifier) {
            view = dequedView
            view.annotation = annotation as? MKAnnotatedBranchBank
        } else {
            if let annotatedBranchBank = annotation as? MKAnnotatedBranchBank {
                view = MKAnnotationView(annotation: annotatedBranchBank, reuseIdentifier: branchBankIdentifier)
                view.canShowCallout = true
                view.detailCalloutAccessoryView = BranchBankCalloutView(mkAnnotatedBranchBank: annotatedBranchBank)
                view.image = UIImage(named: "bank")
                view.frame.size = CGSize(width: 50, height: 50)
            }
        }
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: serviceTerminalIdentifier) {
            view = dequedView
            view.annotation = annotation as? MKAnnotatedServiceTerminal
        } else {
            if let annotatedServiceTerminal = annotation as? MKAnnotatedServiceTerminal {
                view = MKAnnotationView(annotation: annotatedServiceTerminal, reuseIdentifier: serviceTerminalIdentifier)
                view.canShowCallout = true
                view.detailCalloutAccessoryView = ServiceTerminalCalloutView(mkAnnotatedServiceTerminal: annotatedServiceTerminal)
                view.image = UIImage(named: "terminal")
                view.frame.size = CGSize(width: 50, height: 50)
            }
        }
        return view
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                if Reachability.isConnectedToNetwork() {
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
                } else {
                    renderLocation(defaultLocation)
                    currentLocation = defaultLocation
                }
                
            case .denied, .restricted:
                showGeoDataRequestAlert()
                
            @unknown default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            if Reachability.isConnectedToNetwork() {
                renderLocation(location)
                currentLocation = location
            } else {
                renderLocation(defaultLocation)
                currentLocation = defaultLocation
            }
        }
    }
    
    private func showGeoDataRequestAlert() {
        let geoDataRequestAlert = UIAlertController(title: "???????????? ?? ????????????????????", message: "?????????????????? ???????????? ?????? ?????????????????????? ???????????? ????????????????????????????", preferredStyle: .alert)
        
        let goToSettingAction = UIAlertAction(title: "?????????????? ?? ??????????????????", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
            geoDataRequestAlert.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "??????????????", style: .cancel) { _ in
            geoDataRequestAlert.dismiss(animated: true)
        }
        
        geoDataRequestAlert.addAction(goToSettingAction)
        geoDataRequestAlert.addAction(cancelAction)
        
        self.present(geoDataRequestAlert, animated: true)
    }
}


// MARK: - ATMCalloutViewDelegate, BranchBankCalloutViewDelegate, ServiceTerminalCalloutViewDelegate

extension MapViewController: ATMCalloutViewDelegate, BranchBankCalloutViewDelegate, ServiceTerminalCalloutViewDelegate {
    func mapView(_ mapView: MKMapView, didTapCloseButton button: UIButton, for annotation: MKAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didTapDetailButton button: UIButton, for annotation: MKAnnotation) {
        guard let annotatedATMData = annotation as? MKAnnotatedATM else { return }
        
        let atmDetailedVC = ATMDetailedInfoViewController()
        
        atmDetailedVC.idLabel.text = "?????????????????????????? ??????????????????: \(annotatedATMData.atmID)"
        
        if annotatedATMData.type == "ATM" {
            atmDetailedVC.typeLabel.text = "??????: ????????????????"
        } else {
            atmDetailedVC.typeLabel.text = "??????: ???? ??????????????????????"
        }
        
        atmDetailedVC.baseCurrencyLabel.text = "C???????????????????? ????????????: \(annotatedATMData.baseCurrency)"
        atmDetailedVC.currencyLabel.text = "???????????????????? ????????????: \(annotatedATMData.currency)"
        atmDetailedVC.cardsLabel.text = "?????????????????? ??????????????: \(annotatedATMData.cards)"
        
        if annotatedATMData.currentStatus == "On" {
            atmDetailedVC.currentStatusLabel.text = "?????????????? ??????????????????: ????????????????"
        } else {
            atmDetailedVC.currentStatusLabel.text = "?????????????? ??????????????????: ???? ????????????????"
        }
        
        atmDetailedVC.addressLabel.text = "??????????: \(annotatedATMData.townName), \(annotatedATMData.streetName) \(annotatedATMData.buildingNumber) (\(annotatedATMData.addressLine))"
        atmDetailedVC.geolocationLabel.text = "???????????????????????????? ????????????????????: ?????????????? - \(annotatedATMData.longitude), ???????????? - \(annotatedATMData.latitude)"
        atmDetailedVC.servicesLabel.text = "????????????: \(annotatedATMData.serviceType)"
        
        if annotatedATMData.access24Hours == true {
            atmDetailedVC.access24hoursLabel.text = "???????????????? ??????????????????????????: ????"
        } else {
            atmDetailedVC.access24hoursLabel.text = "???????????????? ??????????????????????????: ??????"
        }
        
        if annotatedATMData.isRescticted == true {
            atmDetailedVC.restrictedAccessLabel.text = "???????????? ??????????????????: ????"
        } else {
            atmDetailedVC.restrictedAccessLabel.text = "???????????? ??????????????????: ??????"
        }
        
        if annotatedATMData.sameAsOrganization == true {
            atmDetailedVC.organizationOperatingHoursLabel.text = "???????????? ???? ?????????????? ??????????????????????-?????????????????????????????? ??????????????????: ????"
        } else {
            atmDetailedVC.organizationOperatingHoursLabel.text = "???????????? ???? ?????????????? ??????????????????????-?????????????????????????????? ??????????????????: ????"
        }
        
        atmDetailedVC.standardAvailabilityLabel.text = "?????????? ????????????: \(annotatedATMData.standardAvailability)"
        atmDetailedVC.contactDetailsLabel.text = "???????????????????? ?????????? ????????????????: \(annotatedATMData.contactDetails)"
        atmDetailedVC.atmItemLatitude = annotatedATMData.coordinate.latitude
        atmDetailedVC.atmItemLongitude = annotatedATMData.coordinate.longitude
        atmDetailedVC.atmItemTitle = "Belarusbank ATM \(annotatedATMData.streetName),  \(annotatedATMData.buildingNumber)"
        
        self.present(atmDetailedVC, animated: true)
    }
}

