//
//  USBDeviceLocator.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation
#if targetEnvironment(macCatalyst)
    import IOKit.usb
#endif

protocol DeviceLocator {}

#if targetEnvironment(macCatalyst)
    final class USBDeviceLocator: DeviceLocator {
        private struct TeenageEngineeringValues {
            static let usbVendorID: UInt16 = 0x2367
            static let opzProductID: UInt16 = 0xC
        }

        private enum USBLocationEvent {
            case found
            case terminated
        }

        private let queue = DispatchQueue(label: "me.foureyes.Operator.usb-device-detection")
        private let notificationPort = IONotificationPortCreate(kIOMasterPortDefault)

        private var addedIterator: io_iterator_t = 0
        private var removedIterator: io_iterator_t = 0

        init() {
            IONotificationPortSetDispatchQueue(notificationPort, queue)

            let searchQuery = IOServiceMatching(kIOUSBDeviceClassName) as NSMutableDictionary
            searchQuery[kUSBVendorID] = NSNumber(value: TeenageEngineeringValues.usbVendorID)
            searchQuery[kUSBProductID] = NSNumber(value: TeenageEngineeringValues.opzProductID)
            searchQuery[kUSBInterfaceClass] = NSNumber(value: kUSBMassStorageInterfaceClass)

            let selfPointer = Unmanaged.passUnretained(self).toOpaque()

            let found: IOServiceMatchingCallback = { userData, iterator in
                let this = Unmanaged<USBDeviceLocator>.fromOpaque(userData!).takeUnretainedValue()
                this.ioServiceCallback(for: .found, iterator: iterator)
            }
            let removed: IOServiceMatchingCallback = { userData, iterator in
                let this = Unmanaged<USBDeviceLocator>.fromOpaque(userData!).takeUnretainedValue()
                this.ioServiceCallback(for: .terminated, iterator: iterator)
            }

            IOServiceAddMatchingNotification(notificationPort, kIOFirstMatchNotification, searchQuery, found, selfPointer, &addedIterator)
            IOServiceAddMatchingNotification(notificationPort, kIOTerminatedNotification, searchQuery, removed, selfPointer, &removedIterator)

            ioServiceCallback(for: .found, iterator: addedIterator)
            ioServiceCallback(for: .terminated, iterator: removedIterator)
        }

        private func ioServiceCallback(for event: USBLocationEvent, iterator: io_iterator_t) {
            repeat {
                let nextService = IOIteratorNext(iterator)
                guard nextService != 0 else { break }
                switch event {
                case .found:
                    Log.debug("We found a service! \(nextService)")
                case .terminated:
                    Log.debug("A service was removed! \(nextService)")
                }
                IOObjectRelease(nextService)
            } while true
        }
    }
#endif
