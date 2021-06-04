//
//  Flag.swift
//  Flags
//
//  Created by Richard Robinson on 2021-05-30.
//

import Foundation
import MapKit

struct Country: Codable, Comparable, Identifiable {
    struct Name: Codable {
        let common: String
        let official: String
    }
    
    struct Currency: Codable {
        let name: String
        let symbol: String
    }
    
    let name: Name
    let tld: [String]
    let cca2: String
    let cca3: String
    let independent: Bool?
    let unMember: Bool?
    let currencies: [String : Currency]
    let capital: [String]
    let region: String
    let subregion: String?
    let languages: [String : String]
    let latlng: [Double]
    let borders: [String]
    let area: Double
    let flag: String
    
    var id: String {
        cca3
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }
    
    var areaMeasurement: Measurement<UnitArea> {
        Measurement(value: area, unit: UnitArea.squareKilometers)
    }
    
    var flagImageName: String {
        cca2.lowercased()
    }
    
    static func < (lhs: Country, rhs: Country) -> Bool {
        lhs.name.common < rhs.name.common
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name.common == rhs.name.common
    }
}
