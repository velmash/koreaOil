//
//  OilChartViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import SwiftUI

class OilChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftUIView = OilChartUIView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .white
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        
        
        addChild(hostingController)
        hostingController.view.frame = self.view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
