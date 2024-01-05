//
//  OilTypeButton.swift
//  KoreaOil
//
//  Created by 윤형찬 on 1/5/24.
//

import SwiftUI

struct OilTypeButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12))
            .frame(height: 30) // 먼저 프레임의 높이를 지정
            .padding(.horizontal) // 수평 패딩만 적용
            .background(isSelected ? Color.gray : Color.clear)
            .foregroundColor(isSelected ? .white : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0) // 크기 변화
            .animation(.spring(), value: configuration.isPressed)
    }
}
