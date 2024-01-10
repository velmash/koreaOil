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
        
        if let data = self.viewModel?.initData {
            self.contentView.tempLb.text = "\(data.stationId)\n\(data.brand)\n\(data.brandName)\n\(data.price)\n\(data.distance)\n\(data.distance)\n\(data.lat)\n\(data.lon)\n\(data.stationType?.rawValue)"
        }
    }
}
