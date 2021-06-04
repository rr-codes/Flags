//
//  ContentView.swift
//  Flags
//
//  Created by Richard Robinson on 2021-05-30.
//

import SwiftUI
import MapKit

extension Optional where Wrapped: View {
    func orEmpty() -> some View {
        self.map { AnyView($0) } ?? AnyView(EmptyView())
    }
}

struct ContentView: View {
    @State private var activeCountry: Country? = nil
    
    @StateObject var controller = FlagController(using: .init())
    
    var navigationLink: some View {
        NavigationLink(
            destination: activeCountry.map { FlagView(country: $0) }.orEmpty(),
            isActive: Binding {
                activeCountry != nil
            } set: { (value) in
                if (!value) {
                    activeCountry = nil
                }
            }
        ) {
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(controller.countries) { country in
                    Section(header: Text(country.name.common)) {
                        Button {
                            activeCountry = country
                        } label: {
                            Image(country.flagImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .listRowInsets(.init())
                    }
                }
            }
            .navigationTitle("Flags")
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                Button {
                    controller.shuffle()
                } label: {
                    Image(systemName: "shuffle")
                        .imageScale(.large)
                }
            }
            .background(navigationLink)
        }
        .onOpenURL { url in
            guard url.scheme == "com.richardrobinson.flags", url.host == "flags" else {
                return
            }
            
            let activeCountryId = url.lastPathComponent
            activeCountry = FlagProvider().find(by: activeCountryId)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
