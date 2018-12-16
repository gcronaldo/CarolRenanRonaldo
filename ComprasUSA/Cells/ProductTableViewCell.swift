//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Ronaldo Garcia on 15/12/18.
//  Copyright © 2018 Carol Renan Ronaldo. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbProduct: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func prepare(with product: Product) {
        lbProduct.text = product.name
        var price: Double = 0
        if let productPrice = product.priceUS {
            price = Double(productPrice) ?? 0
        }
        lbPrice.text = convertDoubleToCurrency(amount: price)
        
        if let image = product.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "gift")
        }
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
}

