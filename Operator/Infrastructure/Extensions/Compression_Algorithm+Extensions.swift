//
//  Compression_Algorithm+Extensions.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Compression

extension compression_algorithm {
    var name: String {
        switch self {
        case COMPRESSION_LZ4:
            return "lz4"
        case COMPRESSION_ZLIB:
            return "zlib"
        case COMPRESSION_LZMA:
            return "lzma"
        case COMPRESSION_LZ4_RAW:
            return "lz4_raw"
        case COMPRESSION_LZFSE:
            return "lzfse"
        default:
            fatalError("Unknown compression algorithm.")
        }
    }

    var pathExtension: String {
        return "." + name
    }

    init?(name: String) {
        switch name.lowercased() {
        case "lz4":
            self = COMPRESSION_LZ4
        case "zlib":
            self = COMPRESSION_ZLIB
        case "lzma":
            self = COMPRESSION_LZMA
        case "lzfse":
            self = COMPRESSION_LZFSE
        default:
            return nil
        }
    }
}
