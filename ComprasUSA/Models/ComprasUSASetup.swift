//
//  ComprasUSASetup.swift
//  ComprasUSA
//
//  Created by Ronaldo Garcia on 15/12/18.
//  Copyright © 2018 Carol Renan Ronaldo. All rights reserved.
//

import Foundation

enum userDefaultKeys: String {
    case quotationDollar = "quotationDollar"
    case IOF = "iof"
}

class ComprasUSASetup {
    
    let defaults = UserDefaults.standard
    static var shared: ComprasUSASetup = ComprasUSASetup()
    
    var quotationDollar: Double {
        get {
            return defaults.double(forKey: userDefaultKeys.quotationDollar.rawValue)
        }
        set {
            defaults.set(newValue, forKey: userDefaultKeys.quotationDollar.rawValue)
        }
    }
    
    var iof: Double {
        get {
            return defaults.double(forKey: userDefaultKeys.IOF.rawValue)
        }
        set {
            defaults.set(newValue, forKey: userDefaultKeys.IOF.rawValue)
        }
    }
    
    private init() {
        
        if defaults.double(forKey: userDefaultKeys.quotationDollar.rawValue) == 0 {
            defaults.set(0.00, forKey: userDefaultKeys.quotationDollar.rawValue)
        }
        if defaults.double(forKey: userDefaultKeys.IOF.rawValue) == 0 {
            defaults.set(0.00, forKey: userDefaultKeys.IOF.rawValue)
        }
        
    }
    
}
