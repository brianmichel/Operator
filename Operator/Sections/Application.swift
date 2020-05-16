//
//  File.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

final class ApplicationHostingController: UIHostingController<ContentView> {
    let usbDeviceLocator = USBDeviceLocator()
}
