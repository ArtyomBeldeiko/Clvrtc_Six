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
    
    let activityIndicatorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background")
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
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
            NetworkManager.shared.getATMData { result in
                switch result {
                case .success(let data):
                    atmData = data.data.atm
                    
                case .failure(_):
                    self.showAtmFetchFailureAlert()
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            NetworkManager.shared.getBranchBankData { result in
                switch result {
                case .success(let data):
                    branchBankData = data.data.branch
                    
                case .failure(_):
                    self.showBranchBankFetchFailureAlert()
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            NetworkManager.shared.getServiceTerminalData { result in
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
                    self.annotatedATMData.append(MKAnnotatedATM(atmID: atmDataItem.atmID, type: atmDataItem.type.rawValue, baseCurrency: atmDataItem.baseCurrency.rawValue, currency: atmDataItem.currency.rawValue, cards: cardsFormatter(atmDataItem.cards), currentStatus: atmDataItem.currentStatus.rawValue, streetName: atmDataItem.address.streetName, townName: atmDataItem.address.townName, buildingNumber: atmDataItem.address.buildingNumber, addressLine: atmDataItem.address.addressLine, addressDiscription: atmDataItem.address.addressDescription.rawValue, latitude: atmDataItem.address.geolocation.geographicCoordinates.latitude, longitude: atmDataItem.address.geolocation.geographicCoordinates.longitude, serviceType: servicesFormatter(atmDataItem.services), access24Hours: atmDataItem.availability.access24Hours, isRescticted: atmDataItem.availability.isRestricted, sameAsOrganization: atmDataItem.availability.sameAsOrganization, standardAvailability: atmDatesFormatter(atmDataItem.availability.standardAvailability.day), contactDetails: atmDataItem.contactDetails.phoneNumber))
                    
//
//
//
//                    self.annotatedATMData.append(MKAnnotatedATM(atmID: atmDataItem.atmID, type: atmDataItem.type, baseCurrency: atmDataItem.baseCurrency, currency: atmDataItem.currency, cards: atmDataItem.cards, currentStatus: atmDataItem.currentStatus, address: atmDataItem.address, services: atmDataItem.services, availability: atmDataItem.availability, contactDetails: atmDataItem.contactDetails, coordinate: CLLocationCoordinate2D(latitude: Double(atmDataItem.address.geolocation.geographicCoordinates.latitude)!, longitude: Double(atmDataItem.address.geolocation.geographicCoordinates.longitude)!)))
                    
                    facilityData.append(MKAnnotatedFacility(id: atmDataItem.atmID, currency: atmDataItem.currency.rawValue, townName: atmDataItem.address.townName, streetName: atmDataItem.address.streetName, buildingNumber: atmDataItem.address.buildingNumber, addressLine: atmDataItem.address.buildingNumber, availability: atmDatesFormatter(atmDataItem.availability.standardAvailability.day), latitude: Double(atmDataItem.address.geolocation.geographicCoordinates.latitude)!, longitude: Double(atmDataItem.address.geolocation.geographicCoordinates.longitude)!))
                }
                
                self.annotatedATMData = self.annotatedATMData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                
                for branchBankDataItem in branchBankData {
                    self.annotatedBranchBankData.append(MKAnnotatedBranchBank(branchID: branchBankDataItem.branchId, name: branchBankDataItem.name, cbu: branchBankDataItem.cbu, accountNumber: branchBankDataItem.accountNumber, equeue: branchBankDataItem.equeue, wifi: branchBankDataItem.wifi, accessibilities: branchBankDataItem.accessibilities, branchBankAddress: branchBankDataItem.address, information: branchBankDataItem.information, services: branchBankDataItem.services, coordinate: CLLocationCoordinate2D(latitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.latitude)!, longitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.longitude)!)))
                    
                    facilityData.append(MKAnnotatedFacility(id: branchBankDataItem.branchId, currency: "", townName: branchBankDataItem.address.townName, streetName: branchBankDataItem.address.streetName, buildingNumber: branchBankDataItem.address.buildingNumber, addressLine: branchBankDataItem.address.addressLine, availability: branchBankDatesFormatter(branchBankDataItem.information.availability.standardAvailability.day), latitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.latitude)!, longitude: Double(branchBankDataItem.address.geoLocation.geographicCoordinates.longitude)!))
                }
                
                self.annotatedBranchBankData = self.annotatedBranchBankData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                
                for serviceTerminalItem in serviceTerminalData {
                    self.annotatedServiceTerminalData.append(MKAnnotatedServiceTerminal(infoID: serviceTerminalItem.infoID, area: serviceTerminalItem.area, cityType: serviceTerminalItem.cityType, city: serviceTerminalItem.city, addressType: serviceTerminalItem.addressType, address: serviceTerminalItem.address, house: serviceTerminalItem.house, installPlace: serviceTerminalItem.installPlace, locationNameDesc: serviceTerminalItem.locationNameDesc, workTime: serviceTerminalItem.workTime, timeLong: serviceTerminalItem.timeLong, gpsX: serviceTerminalItem.gpsX, gpsY: serviceTerminalItem.gpsY, serviceTerminalCurrency: serviceTerminalItem.currency, infType: serviceTerminalItem.infType, cashInExist: serviceTerminalItem.cashIn, cashIn: serviceTerminalItem.cashIn, typeCashIn: serviceTerminalItem.cashIn, infPrinter: serviceTerminalItem.infPrinter, regionPlatej: serviceTerminalItem.regionPlatej, popolneniePlatej: serviceTerminalItem.popolneniePlatej, infStatus: serviceTerminalItem.infStatus, coordinate: CLLocationCoordinate2D(latitude: Double(serviceTerminalItem.gpsX)!, longitude: Double(serviceTerminalItem.gpsY)!)))
                    
                    facilityData.append(MKAnnotatedFacility(id: serviceTerminalItem.infoID.description, currency: serviceTerminalItem.currency.rawValue, townName: serviceTerminalItem.city, streetName: serviceTerminalItem.address, buildingNumber: serviceTerminalItem.house, addressLine: serviceTerminalItem.locationNameDesc, availability: serviceTerminalItem.workTime, latitude: Double(serviceTerminalItem.gpsX)!, longitude: Double(serviceTerminalItem.gpsY)!))
                }
                
                self.annotatedServiceTerminalData = self.annotatedServiceTerminalData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                
                self.mapView.addAnnotations(self.annotatedATMData)
                self.mapView.addAnnotations(self.annotatedServiceTerminalData)
                self.mapView.addAnnotations(self.annotatedBranchBankData)
                
                facilityData = facilityData.sorted { $0.distance(to: self.currentLocation ?? self.defaultLocation) < $1.distance(to: self.currentLocation ?? self.defaultLocation) }
                listVC?.groupedData = Dictionary(grouping: facilityData, by: { $0.townName })
                
                DispatchQueue.main.async {
                    listVC?.collectionView.reloadData()
                }
                
                self.activityIndicatorContainer.isHidden = true
                self.makeUIActive()
            }
            
        } else {
            showNoInternerConnectionAlert()
        }
    }
    
    func showAtmFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные о банкоматах", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { _ in
            self.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showBranchBankFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные о подразделениях банка", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { _ in
            self.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showServiceTerminalFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные об инфокиосках", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { _ in
            self.fetchData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(networkFetchFailureAlert, animated: true)
        }
    }
    
    func showNoInternerConnectionAlert() {
        let noInternerConnectionAlert = UIAlertController(title: nil, message: "Приложение работает без доступа к интернету", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Хорошо", style: .default) { _ in
            noInternerConnectionAlert.dismiss(animated: true)
        }
        
        noInternerConnectionAlert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(noInternerConnectionAlert, animated: true)
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
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
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
            renderLocation(location)
            currentLocation = location
        }
    }
    
    private func showGeoDataRequestAlert() {
        let geoDataRequestAlert = UIAlertController(title: "Доступ к геолокации", message: "Разрешите доступ для определения Вашего местоположения", preferredStyle: .alert)
        
        let goToSettingAction = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
            geoDataRequestAlert.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
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
//        let operatingHours = atmDatesFormatter(annotatedATMData.availability.standardAvailability.day)
//        let cards = cardsFormatter(annotatedATMData.cards)
//        let services = servicesFormatter(annotatedATMData.services)
        
        atmDetailedVC.idLabel.text = "Идентификатор банкомата: \(annotatedATMData.atmID)"
        
        if annotatedATMData.type == "ATM" {
            atmDetailedVC.typeLabel.text = "Тип: банкомат"
        } else {
            atmDetailedVC.typeLabel.text = "Тип: не установлено"
        }
        
        atmDetailedVC.baseCurrencyLabel.text = "Cтандартная валюта: \(annotatedATMData.baseCurrency)"
        atmDetailedVC.currencyLabel.text = "Выдаваемая валюта: \(annotatedATMData.currency)"
        atmDetailedVC.cardsLabel.text = "Платежные системы: \(annotatedATMData.cards)"
        
        if annotatedATMData.currentStatus == "On" {
            atmDetailedVC.currentStatusLabel.text = "Текущее состояние: работает"
        } else {
            atmDetailedVC.currentStatusLabel.text = "Текущее состояние: не работает"
        }
        
        atmDetailedVC.addressLabel.text = "Адрес: \(annotatedATMData.townName), \(annotatedATMData.streetName) \(annotatedATMData.buildingNumber) (\(annotatedATMData.addressLine))"
        atmDetailedVC.geolocationLabel.text = "Географические координаты: долгота - \(annotatedATMData.longitude), широта - \(annotatedATMData.latitude)"
        atmDetailedVC.servicesLabel.text = "Услуги: \(annotatedATMData.serviceType)"
        
        if annotatedATMData.access24Hours == true {
            atmDetailedVC.access24hoursLabel.text = "Работает круглосуточно: да"
        } else {
            atmDetailedVC.access24hoursLabel.text = "Работает круглосуточно: нет"
        }
        
        if annotatedATMData.isRescticted == true {
            atmDetailedVC.restrictedAccessLabel.text = "Доступ ограничен: да"
        } else {
            atmDetailedVC.restrictedAccessLabel.text = "Доступ ограничен: нет"
        }
        
        if annotatedATMData.sameAsOrganization == true {
            atmDetailedVC.organizationOperatingHoursLabel.text = "Работа по графику организации-местонахождения банкомата: да"
        } else {
            atmDetailedVC.organizationOperatingHoursLabel.text = "Работа по графику организации-местонахождения банкомата: да"
        }
        
        atmDetailedVC.standardAvailabilityLabel.text = "Режим работы: \(annotatedATMData.standardAvailability)"
        atmDetailedVC.contactDetailsLabel.text = "Контактный номер телефона: \(annotatedATMData.contactDetails)"
        atmDetailedVC.atmItemLatitude = annotatedATMData.coordinate.latitude
        atmDetailedVC.atmItemLongitude = annotatedATMData.coordinate.longitude
        atmDetailedVC.atmItemTitle = "Belarusbank ATM \(annotatedATMData.streetName),  \(annotatedATMData.buildingNumber)"
        
        self.present(atmDetailedVC, animated: true)
    }
}

