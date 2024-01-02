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
//        List(viewModel.weekPriceData, id: \.self) { data in
//            Text(data.price)
//        }
//        .onAppear {
//            viewModel.getParam()
//        }
        
        Chart {
            ForEach(Array(viewModel.weekPriceData.enumerated()), id: \.element) { index, data in

                LineMark(
                    x: .value("날짜", index),
                    y: .value("가격", Double(data.price) ?? 0)
                )
                .foregroundStyle(by: .value("Cate1", "휘발유"))
            }
        }
        .onAppear {
            viewModel.getParam()
        }
    }
}

#Preview {
    OilChartUIView()
}
