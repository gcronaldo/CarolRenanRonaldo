//
//  SummaryViewController.swift
//  ComprasUSA
//
//  Created by Ronaldo Garcia on 15/12/18.
//  Copyright © 2018 Carol Renan Ronaldo. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController {

    @IBOutlet weak var lbUS: UILabel!
    @IBOutlet weak var lbRS: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateTotalTax()
    }
    
    func calculateTotalTax() {
        
        let productRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let productFetched = try context.fetch(productRequest)
            var priceUS: Double = 0
            var priceRS: Double = 0
            for product in productFetched as! [NSManagedObject] {
                if let priceUSFetched = product.value(forKey: "priceUS") as? String {
                    if let pricesUS = Double(priceUSFetched) {
                        priceUS = priceUS + pricesUS
                    }
                }
                if let priceRSFetched = product.value(forKey: "priceRS") as? String {
                    if let pricesRS = Double(priceRSFetched) {
                        priceRS = priceRS + pricesRS
                    }
                }
            }   
            lbUS.text = convertDoubleToCurrency(amount: priceUS)
            lbRS.text = convertDoubleToCurrency(amount: priceRS)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }

}
