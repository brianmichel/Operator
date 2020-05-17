//
//  DocumentPicker.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI
import UIKit

final class DocumentPicker: NSObject, UIViewControllerRepresentable {
    @Published var selectedURLs = [URL]()

    typealias UIViewControllerType = UIDocumentPickerViewController

    lazy var viewController: UIDocumentPickerViewController = {
        let viewController = UIDocumentPickerViewController(documentTypes: ["public.folder"],
                                                            in: .open)
        viewController.allowsMultipleSelection = false
        viewController.shouldShowFileExtensions = true
        viewController.delegate = self
        return viewController
    }()

    func makeUIViewController(context _: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        viewController.delegate = self
        return viewController
    }

    func updateUIViewController(_: UIDocumentPickerViewController, context _: UIViewControllerRepresentableContext<DocumentPicker>) {}
}

extension DocumentPicker: UIDocumentPickerDelegate {
    func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        Log.debug(String(describing: urls))

        selectedURLs = urls
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true) {}
        Log.debug("cancelled")
    }
}
