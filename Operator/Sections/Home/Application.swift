//
//  ApplicationHostingController.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

final class ApplicationHostingController: UIHostingController<HomeView> {
    #if targetEnvironment(macCatalyst)
        let usbDeviceLocator = USBDeviceLocator()
    #endif

    override var shouldAutorotate: Bool {
        if traitCollection.userInterfaceIdiom == .phone {
            return false
        }

        return true
    }
}
