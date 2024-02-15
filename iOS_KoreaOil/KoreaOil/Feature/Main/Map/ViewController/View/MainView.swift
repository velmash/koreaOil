//
//  MainView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 11/3/23.
//

import UIKit
import NMapsMap
import SnapKit
import Then

class MainView: BaseView {
    var mapView: NMFMapView?
    
    lazy var searchBar = createSearchBar()
    lazy var searchView = SearchView()
    lazy var goMinPriceBtn = createGoMinPriceBtn()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.searchView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        self.backgroundColor = .white
        
        mapView = NMFMapView(frame: self.frame)
        setInitMapview(mapView)
        
        if let mapView {
            self.addSubview(mapView)
        }
        
        addSubview(searchView)
        addSubview(searchBar)
        addSubview(goMinPriceBtn)
        
        //TODO: 사양 정해서 searchBar 구현 해야함
        searchBar.isHidden = true
    }
    
    override func addConstraints() {
        if let mapView {
            mapView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-self.tabBarHeight)
            }
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(topSafetyAreaInset + 20)
            $0.height.equalTo(40)
        }
        
        searchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        goMinPriceBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(20 + bottomSafetyAreaInset + tabBarHeight))
            $0.width.equalTo(130)
            $0.height.equalTo(40)
        }
    }
    
    func showBottomView() {
        self.searchView.isHidden = false
    }
    
    func hideBottomView() {
        self.searchView.isHidden = true
        self.searchBar.resignFirstResponder()
    }
    
    private func setInitMapview(_ mapView: NMFMapView?) {
        mapView?.minZoomLevel = 13
        mapView?.maxZoomLevel = 16
        mapView?.isTiltGestureEnabled = false
        mapView?.isRotateGestureEnabled = false
    }
}

extension MainView {
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 4
        searchBar.layer.borderColor = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1).cgColor
        searchBar.layer.borderWidth = 1
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "gr-d") ?? .lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
            textfield.tintColor = UIColor(named: "yp-m")
            textfield.textColor = UIColor(named: "bk")
            textfield.font = UIFont.systemFont(ofSize: 14)
            textfield.backgroundColor = .white
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            }
            
            if let rightView = textfield.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
            }
            
            textfield.clearButtonMode = .never
        }
        
        searchBar.showsCancelButton = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("", for: .normal)
            cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            cancelButton.tintColor = .gray
        }
        
        return searchBar
    }
    
    private func createGoMinPriceBtn() -> UIButton {
        let btn = UIButton()
        
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.layer.borderColor =  UIColor.gray.cgColor
        btn.layer.borderWidth = 2
        btn.setTitle("  최저가로 지도 이동  ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        
        return btn
    }
}
