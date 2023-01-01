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
    var ATMdata: [ATM]?
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isPitchEnabled = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    private func configureViews() {
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
    
    private func addAnnotations() {
        
        guard let data = ATMdata else { return }
        
        for ATMItem in data {
            let CLLocationCoordinate = CLLocationCoordinate2D(latitude: Double(ATMItem.address.geolocation.geographicCoordinates.latitude)!,
                                                              longitude: Double(ATMItem.address.geolocation.geographicCoordinates.longitude)!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        } else {
            let pin = "pin"
            var pinView: MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pin) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: pin)
            }
            return pinView
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        addAnnotations()
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
                print("Access is allowed")
                
            case .denied, .restricted:
                print("Access is denied")
                
            @unknown default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            renderLocation(location)
            
            let currentLocationPin = MKPointAnnotation()
            currentLocationPin.coordinate = location.coordinate
            mapView.addAnnotation(currentLocationPin)
        }
    }
}
