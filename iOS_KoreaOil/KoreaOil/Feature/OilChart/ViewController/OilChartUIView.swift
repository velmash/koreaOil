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
        ScrollView {
            VStack(alignment: .leading) {
                Text("지난 7일간 유가 추이")
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading], 15)
                
                HStack {
                    Button(OilType.gasolin.rawValue) {
                        viewModel.setOilBtnSelected(.gasolin)
                    }
                    .buttonStyle(OilTypeButtonStyle(isSelected: viewModel.selectedOilType == OilType.gasolin.rawValue))
                    
                    Button(OilType.premium.rawValue) {
                        viewModel.setOilBtnSelected(.premium)
                    }
                    .buttonStyle(OilTypeButtonStyle(isSelected: viewModel.selectedOilType == OilType.premium.rawValue))
                    
                    Button(OilType.disel.rawValue) {
                        viewModel.setOilBtnSelected(.disel)
                    }
                    .buttonStyle(OilTypeButtonStyle(isSelected: viewModel.selectedOilType == OilType.disel.rawValue))
                    
                    Button(OilType.gas.rawValue) {
                        viewModel.setOilBtnSelected(.gas)
                    }
                    .buttonStyle(OilTypeButtonStyle(isSelected: viewModel.selectedOilType == OilType.gas.rawValue))
                    
                    Button(OilType.kerosene.rawValue) {
                        viewModel.setOilBtnSelected(.kerosene)
                    }
                    .buttonStyle(OilTypeButtonStyle(isSelected: viewModel.selectedOilType == OilType.kerosene.rawValue))
                }
                .padding([.leading], 15)
                
                Chart {
                    ForEach(Array(viewModel.oilPricesData.enumerated()), id: \.element) { index, data in
                        LineMark(
                            x: .value("날짜", data.date.convertChartsDate() ?? ""),
                            y: .value("가격", Double(data.price))
                        )
                    }
                }
                .chartYScale(domain: viewModel.minMaxPrices)
                .frame(height: 250)
                .padding()
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(height: 50)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    .overlay(
                        Text("//TODO: 광고 넣기")
                            .font(.system(size: 18))
                    )
                    .padding([.leading, .trailing], 15)
                
                Text("상세")
                    .font(.system(size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top], 15)
                
                ForEach(viewModel.oilPricesData, id: \.self) { item in
                    HStack {
                        Text("· \(item.date.convertDate()!)")
                            .font(.system(size: 15))
                        Spacer()
                        Text("₩\(String(format: "%.2f", item.price))")
                            .font(.system(size: 15))
                    }
                    .padding([.leading, .trailing], 15)
                    .frame(maxWidth: .infinity, idealHeight: 30, alignment: .leading)
                }
            }
            .padding([.bottom], 10)
        }
        .onAppear {
            viewModel.getChartsDatas()
        }
    }
}

#Preview {
    OilChartUIView()
}
