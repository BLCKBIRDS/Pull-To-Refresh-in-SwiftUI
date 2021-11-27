//
//  ExchangeRateView.swift
//  MasteringPullToRefresh
//
//  Created by Work on 27.11.21.
//

import SwiftUI

let apiKey = "*YOUR API KEY*"

struct ExchangeRateView: View {
    
    @State var exchangeRateUSDtoYEN = ""
    @State var exchangeRateEURtoCNH = ""
    
    var body: some View {
        NavigationView {
            List {
                ExchangeRateListRow(concurrency: "US-Dollar : Jap. Yen", symbol: "USD", exchangeRate: $exchangeRateUSDtoYEN)
                ExchangeRateListRow(concurrency: "Euro : Chin. Yuan", symbol: "EUR", exchangeRate: $exchangeRateEURtoCNH)
            }
                .refreshable {
                    exchangeRateUSDtoYEN = await getExchangeRate(apiCallString: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=\(apiKey)")
                    exchangeRateEURtoCNH = await getExchangeRate(apiCallString: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=EUR&to_currency=CNY&apikey=\(apiKey)")
                }
                .listStyle(.grouped)
                .navigationTitle("Forex Rates 💹")
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

struct ExchangeRate: Codable {
    let realtimeCurrencyExchangeRate: RealtimeCurrencyExchangeRate

    enum CodingKeys: String, CodingKey {
        case realtimeCurrencyExchangeRate = "Realtime Currency Exchange Rate"
    }
}

struct RealtimeCurrencyExchangeRate: Codable {
    let exchangeRate: String

    enum CodingKeys: String, CodingKey {
        case exchangeRate = "5. Exchange Rate"
    }
}

struct ExchangeRateListRow: View {
    
    let concurrency: String
    let symbol: String
    
    @Binding var exchangeRate: String
    
    var body: some View {
        HStack {
            Text(concurrency)
                .font(.headline)
            Spacer()
            VStack(alignment: .leading) {
                if let roundedExchangeRate = Float(exchangeRate) {
                    Text("1 \(symbol) =")
                        .font(.footnote)
                        .opacity(0.3)
                    Text(String(format:"%.2f", roundedExchangeRate))
                        .font(.headline)
                        .foregroundColor(.green)
                } else {
                    Text("...")
                        .opacity(0.5)
                }
            }
        }
            .frame(height: 50)
    }
}

struct ExchangeRateView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRateView()
    }
}
