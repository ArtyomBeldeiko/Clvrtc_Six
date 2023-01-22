//
//  MainScenePresenter.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 21.01.23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainScenePresentationLogic {
  func presentSomething(response: MainScene.Something.Response)
}

class MainScenePresenter: MainScenePresentationLogic {
  weak var viewController: MainSceneDisplayLogic?
    
  func presentSomething(response: MainScene.Something.Response) {
    let viewModel = MainScene.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
