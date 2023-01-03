//
//  MainViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 27.12.22.
//

import UIKit
import SnapKit
import CoreLocation

class MainViewController: UIViewController {
    
    let containerViewModes = ["Map", "ATM List"]
    var mapVC = MapViewController()
    var ATMListVC = ATMViewController()
    
//    MARK: - UI Elements
    
    lazy var viewContainerSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: containerViewModes)
        let normalText = UIFont.systemFont(ofSize: 16, weight: .regular)
        let selectedText = UIFont.systemFont(ofSize: 18, weight: .bold)
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
    
    override func loadView() {
        super.loadView()
       
        fetchATMData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureNavigationBar()
        setupViews()
    }
    
    private func configureNavigationBar() {
        let refreshImage = UIImage(systemName: "arrow.clockwise.circle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(uploadAction))
        navigationItem.title = "Map"
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
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
    
    private func fetchATMData() {
        NetworkManager.shared.getATMData { result in
            switch result {
            case .success(let data):
                for dataItem in data.data.atm {
                    let mkAnnotatedATM = MKAnnotatedATM(atmID: dataItem.atmID, type: dataItem.type, baseCurrency: dataItem.baseCurrency, currency: dataItem.currency, cards: dataItem.cards, currentStatus: dataItem.currentStatus, address: dataItem.address, services: dataItem.services, availability: dataItem.availability, contactDetails: dataItem.contactDetails, coordinate: CLLocationCoordinate2D(latitude: Double(dataItem.address.geolocation.geographicCoordinates.latitude)!, longitude: Double(dataItem.address.geolocation.geographicCoordinates.longitude)!))
                    
                    DispatchQueue.main.async {
                        self.mapVC.annotatedATMData?.append(mkAnnotatedATM)
                        self.mapVC.mapView.addAnnotation(mkAnnotatedATM)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func uploadAction() {
        
    }
    
    @objc private func segmentedControlAction() {
        mapVC.view.isHidden = true
        ATMListVC.view.isHidden = true
        
        if viewContainerSegmentedControl.selectedSegmentIndex == 0 {
            mapVC.view.isHidden = false
            navigationItem.title = containerViewModes.first
        } else {
            ATMListVC.view.isHidden = false
            navigationItem.title = containerViewModes.last
        }
    }
}
