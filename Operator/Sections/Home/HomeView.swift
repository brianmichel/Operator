//
//  HomeView.swift
//  Operator
//
//  Created by Brian Michel on 5/4/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

enum MyDeviceNames: String, CaseIterable {
    case iPadPro = "iPad Pro (12.9-inch) (4th generation)"
    case iPhone11ProMax = "iPhone 11 Pro Max"

    static var all: [String] {
        return MyDeviceNames.allCases.map { $0.rawValue }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: BackupView()) {
                        Image(systemName: "doc.on.doc.fill").padding(.trailing, 5)
                        Text("Backup & Restore")
                    }
                }
            }.navigationBarTitle(Text("Operator")).listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.horizontalSizeClass, .compact)
            WelcomeView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(MyDeviceNames.all, id: \.self) { devicesName in
            HomeView()
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
    }
}
