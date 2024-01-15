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
        
        let input = StationDetaionViewModel.Input(
            goBackBtnTap: self.contentView.backBtn.rx.tap.asDriverOnErrorJustComplete(),
            callBtnTap: self.contentView.callBtn.rx.tap.asDriverOnErrorJustComplete(),
            stopoverBtnTap: self.contentView.stopoverBtn.rx.tap.asDriverOnErrorJustComplete(),
            destBtnTap: self.contentView.destBtn.rx.tap.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input: input)
        
        output.stationDetailInfoPost
            .driveNext { [weak self] detailInfo in
                self?.contentView.bindStationInfoDetailUI(info: detailInfo)
            }
            .disposed(by: bag)
    }
}
