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
    
    let provider = FlagProvider()
    
    
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
            FlagViewController(activeCountry: $activeCountry, countries: provider.all)
            .navigationTitle("Flags")
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                Button {
                   // controller.shuffle()
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
