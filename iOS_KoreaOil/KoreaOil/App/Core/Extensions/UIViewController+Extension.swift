//
//  UIViewController+Extension.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/22/24.
//

import UIKit
import PopupDialog

extension UIViewController {
    func makeTutorialPopup(_ with: (() -> Void)?) -> PopupDialog {
        let defaults = UserDefaults.standard
        
        let title = "사용 설명"
        let message = "\n· \"하단 탭 > 설정\" 에서 원하는 유종과 반경, 내비게이션 앱을 선택하고 간편히 길안내를 받으세요!\n\n· 주유소 상세 정보에서 주유소의 여러 편의시설 유무와 전화번호를 확인하세요!\n\n· 전국 7일간 유가 변동 추이를 차트로 확인해 보세요!\n\n\n· 추적 권한을 사용하시면 현재 있는 지역의 주유소 중 가장 저렴한 주유소 10개 리스트를 확인하실 수 있습니다!\n\n· 앱 권한 설정은 \"설정 > 한유최정 앱 에서 변경 가능합니다!"
        
        let popup = PopupDialog(title: title, message: message, tapGestureDismissal: false, panGestureDismissal: false)
        let button = CancelButton(title: "닫기", height: 45, dismissOnTap: true) {
            if let with {
                with()
            }
            defaults.set(true, forKey: "isShownTutorial")
        }
        
        popup.addButtons([button])
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor = .white
        dialogAppearance.titleFont            = .boldSystemFont(ofSize: 25)
        dialogAppearance.titleColor           = UIColor(white: 0.4, alpha: 1)
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont          = .systemFont(ofSize: 14)
        dialogAppearance.messageColor         = UIColor(white: 0.6, alpha: 1)
        dialogAppearance.messageTextAlignment = .left
        
        let buttonAppearance = DefaultButton.appearance()

        // Default button
        buttonAppearance.titleFont      = .systemFont(ofSize: 14)
        buttonAppearance.titleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
        buttonAppearance.buttonColor    = .white
        buttonAppearance.separatorColor = UIColor(white: 0.9, alpha: 1)

        // Below, only the differences are highlighted

        // Cancel button
        CancelButton.appearance().titleColor = .lightGray
        
        
        return popup
    }
}
