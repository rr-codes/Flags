//
//  FlagController.swift
//  Flags
//
//  Created by Richard Robinson on 2021-06-02.
//

import Foundation
import Combine
import SwiftUI
import UIKit
//
//struct FlagCell: View {
//    @Binding var activeCountry: Country?
//
//    let country: Country
//
//    var body: some View {
//        Button {
//            activeCountry = country
//        } label: {
//            Image(country.flagImageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        }
//    }
//}


struct FlagViewController: UIViewControllerRepresentable {
    @Binding var activeCountry: Country?
    
    var countries: [Country]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UITableViewController {
        let controller = UITableViewController(style: .insetGrouped)
        controller.tableView.delegate = context.coordinator
        controller.tableView.dataSource = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        uiViewController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        let parent: FlagViewController

        init(_ viewController: FlagViewController) {
            self.parent = viewController
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            1
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            parent.countries.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let country = parent.countries[indexPath.section]
            
            let image = UIImage(named: country.flagImageName)
            let imageView = UIImageView(image: image)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.contentView.addSubview(imageView)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            parent.countries[section].name.common
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let country = parent.countries[indexPath.section]
            self.parent.activeCountry = country
        }
    }
}
