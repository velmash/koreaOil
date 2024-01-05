//
//  OilChartUIView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/22/23.
//

import SwiftUI
import Charts

struct OilChartUIView: View {
    @ObservedObject var viewModel = OilChartViewModel()
    
    var body: some View {
        VStack {
            
            Text("지난 7일간 유가 추이")
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading], 15)
                .padding(.bottom, 20)
            
            Chart {
                ForEach(Array(viewModel.weekPriceData.enumerated()), id: \.element) { index, data in
                    LineMark(
                        x: .value("날짜", index),
                        y: .value("가격", Double(data.price) ?? 0)
                    )
                    .foregroundStyle(by: .value("Cate1", "휘발유"))
                }
            }
            .frame(height: 300) // 차트의 높이를 조정
            .padding() // 주변에 패딩 추가
            
            Spacer() // 하단 여백
        }
        .onAppear {
            viewModel.getParam()
        }
    }
}

#Preview {
    OilChartUIView()
}
