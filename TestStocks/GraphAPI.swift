//
//  GraphAPI.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 4/29/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import Foundation
protocol GraphProtocol {
    func imageDataReturned(data: NSData)
    func handleError(error: String)
    func noResultsFound()
}

class GraphAPI {

    var delegate: GraphProtocol?
    
    func searchYahooFor(graph: String) {
        
        if let escapedSearchTerm = graph.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            
            let urlPath = "http://chart.finance.yahoo.com/z?s=" + escapedSearchTerm + "&t=6m&q=l&l=on&z=l&p=m50,m200"
            let url = NSURL(string: urlPath)
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url!) {
                (data, response, error) -> Void in
                
                println("Task Completed 2.")
                
                if error != nil {
                    self.delegate?.handleError(error.localizedDescription)
                    println("Jason Error \(error.localizedDescription)")
                } else {
                    
                    let imageData = NSData(data: data)
                    
                    self.delegate?.imageDataReturned(imageData)
                }
            }
            task.resume()
        } else { self.delegate?.noResultsFound() }
    }
}