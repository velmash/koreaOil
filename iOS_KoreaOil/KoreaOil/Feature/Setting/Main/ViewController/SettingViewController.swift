//
//  SettingViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import GoogleMobileAds
import RxSwift
import RxCocoa
import RxGesture

class SettingViewController: BaseViewController<SettingView> {
    weak var settingTableView: UITableView?
    weak var bottomSheetTableView: UITableView?
    
    var viewModel: SettingViewModel?
    
    var selectedUDType: String = ""
    
    var settingItems = SettingType.allCases
    var sheetItems = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Admob Setting
        contentView.bannerView.rootViewController = self
        contentView.bannerView.delegate = self
        
        self.setTables()
        IAPManager.shared.delegate = self
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.contentView.payBtn.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribeNext { owner, _ in
                owner.contentView.loadingIndicator.startAnimating()
                IAPManager.shared.startPurchase()
            }
            .disposed(by: bag)
    }
    
    private func setTables() {
        
        // TableViews init
        settingTableView = contentView.tableView
        bottomSheetTableView = contentView.bottomSheet.tableView
        
        settingTableView?.dataSource = self
        settingTableView?.delegate = self
        
        bottomSheetTableView?.dataSource = self
        bottomSheetTableView?.delegate = self
        
        settingTableView?.reloadData()
        bottomSheetTableView?.reloadData()
    }
    
    private func reloadTables() {
        self.settingTableView?.reloadData()
        self.bottomSheetTableView?.reloadData()
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == settingTableView {
            return settingItems.count
        } else {
            if self.contentView.bottomSheet.contentView.layer.frame.height < 350 && sheetItems.count > 4 {
                self.contentView.bottomSheet.tableView.isScrollEnabled = true
            } else {
                self.contentView.bottomSheet.tableView.isScrollEnabled = false
            }
            return sheetItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == settingTableView {
            return 60
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == settingTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: settingItems[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetTableViewCell", for: indexPath) as? BottomSheetTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: sheetItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == settingTableView {
            if let viewModel, settingItems[indexPath.row] == .source {
                viewModel.goSourceVC()
            } else if settingItems[indexPath.row] == .tutorial {
                let popup = self.makeTutorialPopup(nil)
                self.present(popup, animated: true, completion: nil)
            } else {
                self.sheetItems = settingItems[indexPath.row].getAllCases()
                self.selectedUDType = settingItems[indexPath.row].getUDType()
                
                self.contentView.bottomSheet.isHidden = false
                
                reloadTables()
            }
        } else {
            viewModel?.setUDValue(type: self.selectedUDType, value: sheetItems[indexPath.row])
            reloadTables()
        }
    }
}

extension SettingViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("광고 수신 성공")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("광고 수신 실패", error.localizedDescription)
    }
}

extension SettingViewController: IAPManagerDelegate {
    func endPay() {
        self.contentView.loadingIndicator.stopAnimating()
    }
}
