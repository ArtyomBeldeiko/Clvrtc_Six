//
//  MainViewController.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 27.12.22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
//    MARK: - Constants
    
    let containerViewModes = ["Map", "ATM List"]
    let mapVC = MapViewController()
    let ATMListVC = ATMViewController()
    
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
