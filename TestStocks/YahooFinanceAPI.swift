//
//  YahooAPI.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 4/29/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import Foundation

protocol StockQuotesProtocol {
    func quotesReturned(quotes: NSArray, singleStock: Bool)
}

class YahooFinanceAPI {
    
    var delegate: StockQuotesProtocol?

    
    func loadStocks(symbols: Array<String>, singleStock: Bool) {
        
        var urlPath: String?
        
        if singleStock {
            urlPath = "http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22" + symbols[0] + "%22%29%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
        } else {
            urlPath = createURL(symbols)
        }
       
        let url = NSURL(string: urlPath!)
        
        // what is a singleton?
        let session = NSURLSession.sharedSession()
        
        // final argument is a closure, which is executed
        // after a request is sent and the result determined
        let task = session.dataTaskWithURL(url!) {
            
            // part of the closure
            data, response, error -> Void in
            
            // implementation begins
            //println("Task completed")
            
            if error != nil {
                println("JSON Error \(error.localizedDescription)")
            }
            
            var err: NSError?
            
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                
                if err != nil {
                    println("JSON Error \(err!.localizedDescription)")
                }
                
                // check
                //println("\(jsonResult)")
                
                if let results = jsonResult["query"]!["results"] as? NSDictionary {
                    
                    if let quotes = results["quote"] as? NSArray {
                        // multiple stocks
                        self.delegate?.quotesReturned(quotes, singleStock: singleStock)
                        
                    } else if let quotes = results["quote"] as? NSDictionary {
                         // single stock
                        var quotesArray = [quotes]
                        self.delegate?.quotesReturned(quotesArray, singleStock: singleStock)
                    }
                } else { println("Stocks Offline.") }
            }
        }
        task.resume()
    }
    
    
    
    
    private let beginningOfURL = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("
    
    private let endURL = ")%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
    
    private func createURL(symbols: Array<String>) -> String {
        
        let borders = "%22"
        let separator = "%2C"
        var newStockString = ""
        var counter = 1
        
        for stockSymbol in symbols {
            
            if let escapedSymbol = stockSymbol.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                if counter == symbols.count {
                    newStockString = newStockString + borders + escapedSymbol + borders
                } else {
                    newStockString = newStockString + borders + escapedSymbol + borders + separator
                }
                counter++
            }
        }
        return beginningOfURL + newStockString + endURL
    }
}