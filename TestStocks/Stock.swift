//
//  Stock.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 5/11/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import Foundation

struct Stock {
    
    let name: String
    let symbol: String
    var ask: String
    let previousClose: String
    
    init(name: String, symbol: String, ask: String, previousClose: String) {
        self.name = name
        self.symbol = symbol
        self.ask = ask
        self.previousClose = previousClose
    }
    
    func getPecentInfo() -> (percentChange: String, negative: Bool?) {
        let ask = NSNumberFormatter().numberFromString(self.ask)?.doubleValue
        let previousClose = NSNumberFormatter().numberFromString(self.previousClose)?.doubleValue
        
        
        if let price = ask, yesterdaysStockPrice = previousClose {
            let percentChange = (price - yesterdaysStockPrice) / yesterdaysStockPrice * 100
            return (String(format: "%0.02f", percentChange), percentChange < 0)
        }
        return ("--", nil)
    }
    
    func formatPrice(price: String) -> String {
        if let digitForm = NSNumberFormatter().numberFromString(price) {
            return String(format: "%.02f", digitForm.doubleValue)
        } else {
            return "--"
        }
    }
    
    static func stocksWithJSON(results: NSArray) -> [Stock] {
        var stocks = [Stock]()
        
        if results.count > 0 {
            for result in results {
                var companyName = result["name"] as? String ?? "--"
                var companySymbol = result["symbol"] as? String ?? "--"
                var stockAsk = result["Ask"] as? String ?? "--"
                var previousStockPrice = result["PreviousClose"] as? String ?? "--"
                
                var stock = Stock(name: companyName, symbol: companySymbol, ask: stockAsk, previousClose: previousStockPrice)
                
                stocks.append(stock)
            }
        }
        return stocks
    }
}