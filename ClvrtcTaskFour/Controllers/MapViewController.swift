//
//  MapViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 28.12.22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var annotatedATMData: [MKAnnotatedATM]?
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isPitchEnabled = true
        view.showsUserLocation = true
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        fetchATMData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
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
    
    private func renderLocation(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func fetchATMData() {
        if Reachability.isConnectedToNetwork() {
            NetworkManager.shared.getATMData { result in
                switch result {
                case .success(let data):
                    for dataItem in data.data.atm {
                        let mkAnnotatedATM = MKAnnotatedATM(atmID: dataItem.atmID, type: dataItem.type, baseCurrency: dataItem.baseCurrency, currency: dataItem.currency, cards: dataItem.cards, currentStatus: dataItem.currentStatus, address: dataItem.address, services: dataItem.services, availability: dataItem.availability, contactDetails: dataItem.contactDetails, coordinate: CLLocationCoordinate2D(latitude: Double(dataItem.address.geolocation.geographicCoordinates.latitude)!, longitude: Double(dataItem.address.geolocation.geographicCoordinates.longitude)!))
                        
                        self.annotatedATMData?.append(mkAnnotatedATM)
                        
                        DispatchQueue.main.async {
                            self.mapView.addAnnotation(mkAnnotatedATM)
                        }
                    }
                    
                case .failure(_):
                    self.showNetworkFetchFailureAlert()
                }
            }
        } else {
            showNoInternerConnectionAlert()
        }
    }
    
    private func showNetworkFetchFailureAlert() {
        let networkFetchFailureAlert = UIAlertController(title: nil, message: "Ошибка", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить еще раз", style: .default) { _ in
            self.fetchATMData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            networkFetchFailureAlert.dismiss(animated: true)
        }
        
        networkFetchFailureAlert.addAction(retryAction)
        networkFetchFailureAlert.addAction(cancelAction)
        
        self.present(networkFetchFailureAlert, animated: true)
    }
    
    private func showNoInternerConnectionAlert() {
        let noInternerConnectionAlert = UIAlertController(title: nil, message: "Приложение работает без доступа к интернету", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Хорошо", style: .default) { _ in
            noInternerConnectionAlert.dismiss(animated: true)
        }
        
        noInternerConnectionAlert.addAction(okAction)
        
        self.present(noInternerConnectionAlert, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKind(of: MKUserLocation.self)) {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if let mkAnnotatedATM = annotation as? MKAnnotatedATM {
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = ATMCalloutView(mkAnnotatedATM: mkAnnotatedATM)
        }
        return annotationView
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


// MARK: - ATMCalloutViewDelegate

extension MapViewController: ATMCalloutViewDelegate {
    func mapView(_ mapView: MKMapView, didTapCloseButton button: UIButton, for annotation: MKAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didTapDetailButton button: UIButton, for annotation: MKAnnotation) {
        guard let annotatedATMData = annotation as? MKAnnotatedATM else { return }
        
        let atmDetailedVC = ATMDetailedInfoViewController()
        let operatingHours = datesFormatter(annotatedATMData.availability.standardAvailability.day)
        let cards = cardsFormatter(annotatedATMData.cards)
        let services = servicesFormatter(annotatedATMData.services)
        
        atmDetailedVC.idLabel.text = "Идентификатор банкомата: \(annotatedATMData.atmID)"
        
        if annotatedATMData.type.rawValue.hasPrefix("ATM") {
            atmDetailedVC.typeLabel.text = "Тип: банкомат"
        } else {
            atmDetailedVC.typeLabel.text = "Тип: не установлено"
        }
        
        atmDetailedVC.baseCurrencyLabel.text = "Cтандартная валюта: \(annotatedATMData.baseCurrency.rawValue)"
        atmDetailedVC.currencyLabel.text = "Выдаваемая валюта: \(annotatedATMData.currency.rawValue)"
        atmDetailedVC.cardsLabel.text = "Платежные системы: \(cards)"
        
        if annotatedATMData.currentStatus.rawValue.hasPrefix("On") {
            atmDetailedVC.currentStatusLabel.text = "Текущее состояние: работает"
        } else {
            atmDetailedVC.currentStatusLabel.text = "Текущее состояние: не работает"
        }
        
        atmDetailedVC.addressLabel.text = "Адрес: \(annotatedATMData.address.townName), \(annotatedATMData.address.streetName) \(annotatedATMData.address.buildingNumber) (\(annotatedATMData.address.addressLine))"
        atmDetailedVC.geolocationLabel.text = "Географические координаты: долгота - \(annotatedATMData.coordinate.longitude), широта - \(annotatedATMData.coordinate.latitude)"
        atmDetailedVC.servicesLabel.text = "Услуги: \(services)"
        
        if annotatedATMData.availability.access24Hours == true {
            atmDetailedVC.access24hoursLabel.text = "Работает круглосуточно: да"
        } else {
            atmDetailedVC.access24hoursLabel.text = "Работает круглосуточно: нет"
        }
        
        if annotatedATMData.availability.isRestricted == true {
            atmDetailedVC.restrictedAccessLabel.text = "Доступ ограничен: да"
        } else {
            atmDetailedVC.restrictedAccessLabel.text = "Доступ ограничен: нет"
        }
        
        if annotatedATMData.availability.sameAsOrganization == true {
            atmDetailedVC.organizationOperatingHoursLabel.text = "Работа по графику организации-местонахождения банкомата: да"
        } else {
            atmDetailedVC.organizationOperatingHoursLabel.text = "Работа по графику организации-местонахождения банкомата: да"
        }
        
        atmDetailedVC.standardAvailabilityLabel.text = "Режим работы: \(operatingHours)"
        atmDetailedVC.contactDetailsLabel.text = "Контактный номер телефона: \(annotatedATMData.contactDetails.phoneNumber)"
        atmDetailedVC.atmItemLatitude = annotatedATMData.coordinate.latitude
        atmDetailedVC.atmItemLongitude = annotatedATMData.coordinate.longitude
        atmDetailedVC.atmItemTitle = "Belarusbank ATM \(annotatedATMData.address.streetName),  \(annotatedATMData.address.buildingNumber)"
        
        self.present(atmDetailedVC, animated: true)
    }
}
