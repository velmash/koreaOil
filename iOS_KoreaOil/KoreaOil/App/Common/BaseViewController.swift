//
//  BaseViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import RxSwift

class BaseViewController<ContentView: UIView>: UIViewController, UIGestureRecognizerDelegate {
    var bag = DisposeBag()
    
    var contentView: ContentView {
        return view as! ContentView
    }
    override func loadView() {
        self.view = ContentView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        bag = DisposeBag()
        self.bindViewModel()
    }
    
    func bindViewModel() { }
    
    func convertViewToImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}

