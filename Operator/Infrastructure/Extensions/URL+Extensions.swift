//
//  URL+Extensions.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

extension URL {
    func enclosingFolderURL() -> URL {
        // Kind of hacky, but fine for now.
        #if targetEnvironment(macCatalyst)
            return deletingLastPathComponent()
        #else
            let deletedLastPath = deletingLastPathComponent()
            guard let recreated = URL(string: "shareddocuments://\(deletedLastPath.path)") else {
                Log.error("Unable to convert file path URL for non-macCatalyst target environments!")
                fatalError("Unable to convert file path URL for non-macCatalyst target environments!")
            }

            return recreated
        #endif
    }
}
