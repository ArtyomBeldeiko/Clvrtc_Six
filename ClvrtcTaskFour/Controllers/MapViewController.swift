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
        return view
    }()
    
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
    
    private func addAnnotations() {
        guard let data = annotatedATMData else { return }
        
        for ATMItem in data {
            let annotation = MKPointAnnotation()
            annotation.coordinate = ATMItem.coordinate
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if let mkAnnotatedATM = annotation as? MKAnnotatedATM {
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = ATMCalloutView(mkAnnotatedATM: mkAnnotatedATM)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .close)
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
