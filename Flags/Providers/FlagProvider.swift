//
//  FlagProvider.swift
//  Flags
//
//  Created by Richard Robinson on 2021-05-30.
//

import Foundation
import UIKit
import Combine
import MapKit

class FlagProvider {
    private let countries: [Country]
    
    init() {
        guard let asset = NSDataAsset(name: "countries") else {
            fatalError("Missing data asset: countries")
        }
        
        self.countries = try! JSONDecoder().decode([Country].self, from: asset.data)
    }
    
    var all: [Country] {
        countries
    }
    
    func countryOfTheDay(for date: Date) -> Country {
        let today = Calendar.current.ordinality(of: .day, in: .year, for: date)!
        
        var rng = SplitMix64(seed: UInt64(today))
        
        let shuffled = countries.shuffled(using: &rng)
        return shuffled.first!
    }
    
    func find(by cca3Code: String) -> Country {
        countries.first { $0.cca3 == cca3Code }!
    }
}
