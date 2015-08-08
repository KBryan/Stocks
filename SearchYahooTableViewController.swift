//
//  SearchYahooTableViewController.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 5/2/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import UIKit


class SearchYahooTableViewController: UIViewController, SearchYahooProtocol, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stockTableView: UITableView!
    
    var api = SearchYahooFinance()
    var stockData = []
    var symbols = [String]()
    
    var cancelButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var promptLabel = searchBar.subviews[0].subviews[2] as! UILabel
        //promptLabel.textColor = .whiteColor()
        //searchBar
        stockTableView.backgroundColor = .blackColor()
        searchBar.becomeFirstResponder()
        
        api.delegate = self
        // vimp
        searchBar.delegate = self
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockData.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .blackColor()
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Result Cell", forIndexPath: indexPath) as! SearchTableViewCell
        if stockData.count != 0 {
            if let rowData: NSDictionary = stockData[indexPath.row] as? NSDictionary,
                symbol = rowData["symbol"] as? String,
                exchange = rowData["exchDisp"] as? String,
                name = rowData["name"] as? String {
                    
                    // up or down is previous close - ask
                    cell.symbolLabel.text = symbol
                    cell.exchange.text = exchange
                    cell.nameLabel.text = name
            }
        } else {
            println("No Results Found")
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchBar.resignFirstResponder()
        
        if let rowData = stockData[indexPath.row] as? NSDictionary,
            symbol = rowData["symbol"] as? String {
                let cleanString = symbol.removeChar { $0 != Character ("^") }
                symbols.append(cleanString)
        } else {
            println("No actual selection.")
        }
        
        performSegueWithIdentifier("Cell Selected", sender: self)
    }
    
    // FIX THIS! Cancel button pressed
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cancelButtonPressed = !cancelButtonPressed
        performSegueWithIdentifier("Cell Selected", sender: self)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let stock = searchBar.text {
            promptLabel.text = "Validating request..."
            api.fetchData(stock)
        }
    }
    
     // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if !cancelButtonPressed {
            if segue.identifier == "Cell Selected" {
                if let dvc = segue.destinationViewController as? StocksViewController {
                    dvc.api.addSingleStockWith(symbols)
                    // println("Seguing")
                }
            }
        }
    }
    
    
    func quoteReturned(quotes: NSArray) {
        // blocks takes nothing and returns nothing
        dispatch_async(dispatch_get_main_queue()) {
            self.stockData = quotes
            self.stockTableView.reloadData()
            self.promptLabel.text = "Type a company name or stock symbol."
        }
    }
    
    func handleError(error: String) {
        promptLabel.text = error
    }
    
    func noResultsFound() {
        promptLabel.text = "No Results Found."
        stockData = []
        dispatch_async(dispatch_get_main_queue()) {
            self.stockTableView.reloadData()
        }
    }
}

extension String {
    func removeChar(pred: Character -> Bool) -> String {
        var newString = String()
        for c in self {
            if pred(c) {
                newString.append(c)
            }
        }
        return newString
    }
}
