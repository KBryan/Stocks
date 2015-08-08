//
//  GetJSONData.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 5/8/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import Foundation


class GetJSONData {
    
    
    let urlPath = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=yahoo&callback=YAHOO.Finance.SymbolSuggest.ssCallback"
    var arrayOfStockResulsts: [[String]] = []
    
    func fetchData() {
        
        if let stockJSON = urlPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            
            // stockJSON instead
            let callURl = NSURL(string: urlPath)
            var sharedSession = NSURLSession.sharedSession()
            
            let downLoadTask = sharedSession.dataTaskWithURL(callURl!) {
                data, response, error -> Void in
                
                if error != nil {
                    println("JSON Error \(error.localizedDescription)")
                } else {
                    var jsonError: NSError?
                    
                    var text = NSString(data: data, encoding: 4)!
                    var range = text.rangeOfString("ssCallback")
                    var subtext = text.substringFromIndex(range.location + range.length)
                    
                    var finalText = subtext.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
                    var trimmedData = finalText.dataUsingEncoding(4, allowLossyConversion: false)
                    
                    if let stockDictionary = NSJSONSerialization.JSONObjectWithData(trimmedData!, options: .AllowFragments, error: &jsonError)
                        as? NSDictionary {
                        
                            println("\(stockDictionary)")
                    } else {
                        println("\(jsonError?.localizedDescription)")
                    }
                }
            }
            downLoadTask.resume()
        }
    }
}