//
//  Model.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 5/11/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import Foundation

protocol DataSourceProtocol {
    func updateUIWith(stocks: Array<Stock>)
}


class Model: StockQuotesProtocol  {
    
    let api = YahooFinanceAPI()
    
    var delegate: DataSourceProtocol
    
    private var stockSymbols = ["AAPL", "GOOG", "MSFT", "FB", "TWTR", "TSLA"]
    
    init(delegate: DataSourceProtocol) {
        self.delegate = delegate
    }
    
    private var stockArray = [Stock]()
    
    func setDelegateForPortfolio() {
        api.delegate = self
    }
    
    
    // Handle Search
    func search(singleStock: Bool) {
        api.loadStocks(stockSymbols, singleStock: singleStock)
    }
    
    func quotesReturned(quotes: NSArray, singleStock: Bool) {
        if singleStock {
            let stock = Stock.stocksWithJSON(quotes)
            stockArray += stock
            stockSymbols.append(stock[0].symbol)
            println("In")
        } else {
            stockArray = Stock.stocksWithJSON(quotes)
        }
        
        delegate.updateUIWith(stockArray)
    }
    
    func removeStock(index: Int) {
        stockSymbols.removeAtIndex(index)
        stockArray.removeAtIndex(index)
        delegate.updateUIWith(stockArray)
    }
    
    func addSingleStockWith(symbol: Array<String>) {
        if !stockAlreadyExist(symbol) {
            api.loadStocks(symbol, singleStock: true)
        }

    }
    
    private func stockAlreadyExist(stocks: Array<String>) -> Bool {
        for stock in stockSymbols {
            if stocks[0] == stock {
                return true
            }
        }
        return false
    }

}