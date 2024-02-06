//
//  RegionViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RegionViewController: BaseViewController<RegionView> {
    
    var viewModel: RegionViewModel?
    private var stationDetails = [StationDetailInfo]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.getPrices()
        
        self.setTable()
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = RegionViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.titleTextPost
            .doOnNext { [weak self] text in
                let descString = "주유소 최저가 순"
                let fullString = "\(text)   \(descString)"
                let attributedString = NSMutableAttributedString(string: fullString)
                
                if let range = fullString.range(of: text) {
                    let nsRange = NSRange(range, in: fullString)
                    
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: nsRange)
                }
                
                if let range = fullString.range(of: descString) {
                    let nsRange = NSRange(range, in: fullString)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: nsRange)
                }
                
                self?.contentView.titleLabel.attributedText = attributedString
            }
            .drive()
            .disposed(by: bag)
        
        output.stationInfoPost
            .doOnNext { [weak self] infos in
                self?.stationDetails = infos
            }
            .driveNext { [weak self] _ in
                self?.contentView.tableView.reloadData()
            }
            .disposed(by: bag)
    }
    
    private func setTable() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        setTableHeaderAd()
        
        contentView.tableView.reloadData()
    }
    
    private func setTableHeaderAd() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.tableView.frame.width, height: 50))
        headerView.backgroundColor = .clear // 배경색 설정

        let bannerView = contentView.makeBannerView()
        bannerView.rootViewController = self

        headerView.addSubview(bannerView)
        
        bannerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.tableView.tableHeaderView = headerView
    }
}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as? StationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(info: stationDetails[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.cellTap(info: stationDetails[indexPath.row])
    }
}
