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
            .frame(height: 300)
            .padding()
            
            Spacer()
            // 배너 광고 뷰 추가
            BannerAdView()
                .frame(width: UIScreen.main.bounds.width, height: 50)
                
        }
        .onAppear {
            viewModel.getParam()
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
