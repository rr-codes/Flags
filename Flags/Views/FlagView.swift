//
//  FlagView.swift
//  Flags
//
//  Created by Richard Robinson on 2021-05-30.
//

import SwiftUI
import MapKit

struct FlagViewCell: View {
    let label: String
    let value: String
    
    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
    
    init<S: Sequence>(label: String, value: S) where S.Element == String {
        self.init(label: label, value: value.joined(separator: ", "))
    }
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}

struct FlagView: View {
    let country: Country
        
    var body: some View {
        List {
            Section(header: Text("Flag \(country.flag)")) {
                Image(country.flagImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .listRowInsets(.init())
            }
            
            Section(header: Text("Datasheet")) {
                FlagViewCell(
                    label: "Country Name",
                    value: "\(country.name.official) (\(country.cca2))"
                )
                FlagViewCell(
                    label: "Capital",
                    value: country.capital
                )
                FlagViewCell(
                    label: "Top-Level Domain",
                    value: country.tld
                )
                FlagViewCell(
                    label: "Region",
                    value: country.region
                )
                FlagViewCell(
                    label: "Land Area",
                    value: "\(country.areaMeasurement)"
                )
                FlagViewCell(
                    label: "Currencies",
                    value: country.currencies.map { "\($1.symbol) (\($0))" }
                )
                FlagViewCell(
                    label: "Languages",
                    value: country.languages.values
                )
            }
            
            Section(header: Text("Location")) {
                Map(
                    coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: country.location,
                            span: MKCoordinateSpan(
                                latitudeDelta: 10,
                                longitudeDelta: 10
                            )
                        )
                    ),
                    interactionModes: MapInteractionModes.all
                )
                .frame(height: 200)
                .listRowInsets(.init())
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FlagView_Previews: PreviewProvider {
    static let country = FlagProvider().all.randomElement()!
    
    static var previews: some View {
        NavigationView {
            FlagView(country: country)
        }
    }
}
