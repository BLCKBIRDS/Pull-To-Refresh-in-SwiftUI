//
//  DetailExchangeRateView.swift
//  MasteringPullToRefresh
//
//  Created by Work on 27.11.21.
//

import SwiftUI

struct DetailExchangeRateView: View {
    
    let baseSymbol: String
    let outputSymbol: String
    
    @State var exchangeRate: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("1 \(baseSymbol) =")
                    .bold()
                if let roundedExchangeRate = Float(exchangeRate) {
                    Text("\(String(format:"%.2f", roundedExchangeRate)) \(outputSymbol)")
                        .font(.largeTitle)
                        .bold()
                } else {
                    ProgressView()
                }
                RateRefresher()
                    .refreshable {
                        exchangeRate = await getExchangeRate(apiCallString: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=\(apiKey)")
                    }
            }
                .frame(height: 50)
                .navigationBarTitle("\(baseSymbol) : \(outputSymbol) 💱")
                .onAppear {
                    Task {
                        exchangeRate = await getExchangeRate(apiCallString: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=\(apiKey)")
                    }
                }
        }
    }
    
    func getExchangeRate(apiCallString: String) async -> String {
        let url = URL(string: apiCallString)!
        let request = URLRequest(url: url)
        let (data, _) = try! await URLSession.shared.data(for: request)
        let parsedData = try! JSONDecoder().decode(ExchangeRate.self, from: data)
        let exchangeRate = parsedData.realtimeCurrencyExchangeRate.exchangeRate
        
        return exchangeRate
    }
}

struct DetailExchangeRateView_Previews: PreviewProvider {
    static var previews: some View {
        DetailExchangeRateView(baseSymbol: "USD", outputSymbol: "YEN", exchangeRate: "")
    }
}

struct RateRefresher: View {
    
    @State var isLoading = false
    
    @Environment(\.refresh) private var refresh
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                if let refresh = refresh {
                    Button(action: {
                        isLoading = true
                        Task {
                            await refresh()
                            isLoading = false
                        }
                    }) {
                        Text("Update Rate")
                    }
                }
            }
        }
    }
}
