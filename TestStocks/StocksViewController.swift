//
//  ViewController.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 4/28/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataSourceProtocol {

    let kCellIdentifier = "Stock Cell"
    
    var api: Model!
    
    var stocks = [Stock]()
    
    @IBAction func unwindToStockTableView(sgue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var stocksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        stocksTableView.backgroundColor = UIColor.blackColor()
        api = Model(delegate: self)
        api.setDelegateForPortfolio()
        api.search(false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Stock Cell") as! StockTableViewCell
        let stock = stocks[indexPath.row]
        
        let ask = stock.ask
        let percentInfo = stock.getPecentInfo()
        
        cell.symbolLabel.text = stock.symbol
        cell.priceLable.text = stock.formatPrice(ask)
        cell.percentLabel.text = percentInfo.percentChange + "%"
        
        if (percentInfo.negative != nil) {
            if percentInfo.negative == true {
                cell.arrowLable.text = "▼"
                 cell.arrowLable.textColor = UIColor.redColor()
            } else {
                cell.arrowLable.text = "▲"
                cell.arrowLable.textColor = UIColor(red: 0.3255, green: 0.8392, blue: 0.4118, alpha: 1.0)
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.blackColor()
    }
    
    func updateUIWith(stocks: Array<Stock>) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stocks = stocks
            self.stocksTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        api.removeStock(indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController

        // check for navigation controller
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let dvc = destination as? DetailsViewController {
           
            if let identifier = segue.identifier {
                
                // outlets cant be set here. PERIOD lecture 7 iOS course 53.50
                switch identifier {
                case "Show Detail":
                    var stockIndex = stocksTableView.indexPathForSelectedRow()!.row
                    
                    dvc.stock = stocks[stockIndex].symbol
                    dvc.navConTitle = stocks[stockIndex].symbol
                    
                default: break
                }
            }
        }
    }
}

