//
//  SearchYahooFinance.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 5/2/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import Foundation

protocol SearchYahooProtocol {
    func quoteReturned(quotes: NSArray)
    func handleError(error: String)
    func noResultsFound()
}

class SearchYahooFinance {
    
    var delegate: SearchYahooProtocol?
    var arrayOfStockResulsts: [[String]] = []
    
    func fetchData(stock: String) {

        if let escapedSearchTerm = stock.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            
            let urlPath = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=" + escapedSearchTerm + "&callback=YAHOO.Finance.SymbolSuggest.ssCallback"
            
            // stockJSON instead
            let callURl = NSURL(string: urlPath)
            var sharedSession = NSURLSession.sharedSession()
            
            let downLoadTask = sharedSession.dataTaskWithURL(callURl!) {
                data, response, error -> Void in
                
                if error != nil {
                    
                    println("JSON Error \(error.localizedDescription)")
                    self.delegate?.handleError(error.localizedDescription)
                    
                } else {
                    var jsonError: NSError?
                    
                    var text = NSString(data: data, encoding: 4)!
                    var range = text.rangeOfString("ssCallback")
                    var subtext = text.substringFromIndex(range.location + range.length)
                    
                    var finalText = subtext.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
                    var trimmedData = finalText.dataUsingEncoding(4, allowLossyConversion: false)
                    
                    if let stockDictionary = NSJSONSerialization.JSONObjectWithData(trimmedData!, options: .AllowFragments, error: &jsonError)
                        as? NSDictionary {
                            //println("\(stockDictionary)")
                            
                            let results = stockDictionary["ResultSet"]!["Result"] as? NSArray
                            
                            if let quotes = results {
                                if quotes.count != 0 {
                                    self.delegate?.quoteReturned(quotes)
                                    
                                } else {
                                    self.delegate?.noResultsFound()
                                }
                                
                            } else {
                                println("Didn't make it :/")
                            }
                            
                    } else {
                        println("\(jsonError?.localizedDescription)")
                        if let err = jsonError?.localizedDescription {
                            self.delegate?.handleError(err)
                        }
                    }
                }
            }
            downLoadTask.resume()
        } else { self.delegate?.noResultsFound() }
    }
}