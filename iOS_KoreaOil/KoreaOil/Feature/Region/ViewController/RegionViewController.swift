//
//  RegionViewController.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import RxSwift
import RxCocoa

class RegionViewController: BaseViewController<RegionView> {
    
    var viewModel: RegionViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    private func setTable() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentView.tableView.reloadData()
    }
}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as? StationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure()
        
        return cell
    }
}
