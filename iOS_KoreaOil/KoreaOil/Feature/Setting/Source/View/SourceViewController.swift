//
//  SourceViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/13/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SourceViewController: BaseViewController<SourceView> {
    
    var viewModel: SourceViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        contentView.backBtn.rx.tap
            .subscribeNext { [weak self] _ in
                self?.viewModel?.goBack()
            }
            .disposed(by: bag)
    }
}
