//
//  StationDetailViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/10/24.
//

import UIKit
import GoogleMobileAds

class StationDetailViewController: BaseViewController<StationDetailView> {
    var viewModel: StationDetaionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let naviType = NaviType.allCases.first(where: { $0.rawValue == viewModel?.defaults.string(forKey: UDNaviType )}) ?? .tmap
        
        contentView.stopoverBtn.isHidden = naviType == .apple
        
        contentView.bannerView.rootViewController = self
        contentView.bannerView.delegate = self
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

extension StationDetailViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("광고 수신 성공")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("광고 수신 실패", error.localizedDescription)
    }
}
