//
//  StationDetailViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import UIKit

class StationDetailViewController: BaseViewController<StationDetailView> {
    var viewModel: StationDetaionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        guard let viewModel = self.viewModel, let stationInfo = viewModel.initData else { return }
        
        self.contentView.bindStationInfoUI(info: stationInfo)
        
        contentView.backBtn.rx.tap
            .subscribeNext { [weak self] _ in
                self?.viewModel?.goBack()
            }
            .disposed(by: bag)
    }
}
