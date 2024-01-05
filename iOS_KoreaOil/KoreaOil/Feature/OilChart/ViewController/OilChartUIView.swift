//
//  OilChartUIView.swift
//  KoreaOil
//
//  Created by 윤형찬 on 12/22/23.
//

import SwiftUI
import Charts
import GoogleMobileAds
import Then

struct OilChartUIView: View {
    @ObservedObject var viewModel = OilChartViewModel()
    
    var body: some View {
        VStack {
            Text("지난 7일간 유가 추이")
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .bottom, .leading], 15)
            
            Chart {
                ForEach(Array(viewModel.premiumPriceData.enumerated()), id: \.element) { index, data in
                    LineMark(
                        x: .value("날짜", data.date.convertChartsDate() ?? ""),
                        y: .value("가격", Double(data.price))
                    )
                    .foregroundStyle(by: .value("Cate1", "고급휘발유"))
                }
                
                ForEach(Array(viewModel.gasolinPriceData.enumerated()), id: \.element) { index, data in
                    LineMark(
                        x: .value("날짜", data.date.convertChartsDate() ?? ""),
                        y: .value("가격", Double(data.price))
                    )
                    .foregroundStyle(by: .value("Cate1", "휘발유"))
                }
                
                ForEach(Array(viewModel.diselPriceData.enumerated()), id: \.element) { index, data in
                    LineMark(
                        x: .value("날짜", data.date.convertChartsDate() ?? ""),
                        y: .value("가격", Double(data.price))
                    )
                    .foregroundStyle(by: .value("Cate1", "경유"))
                }
                
                ForEach(Array(viewModel.gasPriceData.enumerated()), id: \.element) { index, data in
                    LineMark(
                        x: .value("날짜", data.date.convertChartsDate() ?? ""),
                        y: .value("가격", Double(data.price))
                    )
                    .foregroundStyle(by: .value("Cate1", "가스"))
                }
                
                ForEach(Array(viewModel.kerosenePriceData.enumerated()), id: \.element) { index, data in
                    LineMark(
                        x: .value("날짜", data.date.convertChartsDate() ?? ""),
                        y: .value("가격", Double(data.price))
                    )
                    .foregroundStyle(by: .value("Cate1", "등유"))
                }
            }
            .frame(height: 300)
            .padding()
            
            Spacer()
            
            BannerAdView()
                .frame(width: UIScreen.main.bounds.width, height: 50)
                
        }
        .onAppear {
            viewModel.getChartsDatas()
        }
    }
}

#Preview {
    OilChartUIView()
}

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "01cdf8405031d3f88cdb758e32340add" ]
        
        let banner = GADBannerView(adSize: GADAdSizeBanner).then {
            $0.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Test ID
            $0.load(GADRequest())
        }
        
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) { }
}
