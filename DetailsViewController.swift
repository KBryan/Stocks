//
//  DetailsViewController.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 4/29/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, GraphProtocol {
    
    
    @IBOutlet weak var graphImage: UIImageView!

    var stocksData = []
    
    var navConTitle: String?
    var api: GraphAPI?
    var stock: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        api = GraphAPI()
        api!.delegate = self
        api!.searchYahooFor(stock!)
        navigationController?.navigationBar.topItem?.title = navConTitle ?? "Yahoo Stocks"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func noResultsFound() {
    }
    
    func handleError(error: String) {
    }
    
    func imageDataReturned(data: NSData) {
        dispatch_async(dispatch_get_main_queue()) {
            if let graphImage = UIImage(data: data) {
                self.graphImage.image = graphImage
            }
        }
    }
}
