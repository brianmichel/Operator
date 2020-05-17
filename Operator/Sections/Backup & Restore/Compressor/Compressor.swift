//
//  Compressor.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Compression
import Foundation

struct CompressorError: Error {
    let message: String
}

// From https://developer.apple.com/documentation/accelerate/compressing_and_decompressing_files_with_stream_compression
class Compressor {
    static func streamingCompression(operation: compression_stream_operation,
                                     sourceFileHandle: FileHandle,
                                     destinationFileHandle: FileHandle,
                                     algorithm: compression_algorithm,
                                     progressUpdateFunction: (Int64) -> Void) throws {
        let bufferSize = 32768
        let destinationBufferPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            destinationBufferPointer.deallocate()
        }

        // Create the compression_stream and throw an error if failed
        var stream = compression_stream()
        var status = compression_stream_init(&stream, operation, algorithm)
        guard status != COMPRESSION_STATUS_ERROR else {
            throw CompressorError(message: "Unable to initialize the compression stream.")
        }
        defer {
            compression_stream_destroy(&stream)
        }

        // Stream setup after compression_stream_init
        // It is indeed important to do it after, since compression_stream_init will zero all fields in stream
        stream.src_size = 0
        stream.dst_ptr = destinationBufferPointer
        stream.dst_size = bufferSize

        var sourceData: Data?
        repeat {
            var flags = Int32(0)

            // If this iteration has consumed all of the source data,
            // read a new tempData buffer from the input file.
            if stream.src_size == 0 {
                sourceData = sourceFileHandle.readData(ofLength: bufferSize)

                stream.src_size = sourceData!.count
                if sourceData!.count < bufferSize {
                    flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
                }
            }

            // Perform compression or decompression.
            if let sourceData = sourceData {
                let count = sourceData.count

                sourceData.withUnsafeBytes {
                    let baseAddress = $0.bindMemory(to: UInt8.self).baseAddress!

                    stream.src_ptr = baseAddress.advanced(by: count - stream.src_size)
                    status = compression_stream_process(&stream, flags)
                }
            }

            switch status {
            case COMPRESSION_STATUS_OK,
                 COMPRESSION_STATUS_END:

                // Get the number of bytes put in the destination buffer. This is the difference between
                // stream.dst_size before the call (here bufferSize), and stream.dst_size after the call.
                let count = bufferSize - stream.dst_size

                let outputData = Data(bytesNoCopy: destinationBufferPointer,
                                      count: count,
                                      deallocator: .none)

                // Write all produced bytes to the output file.
                destinationFileHandle.write(outputData)

                // Reset the stream to receive the next batch of output.
                stream.dst_ptr = destinationBufferPointer
                stream.dst_size = bufferSize
                progressUpdateFunction(Int64(sourceFileHandle.offsetInFile))
            case COMPRESSION_STATUS_ERROR:
                Log.error("There was an error compressing the stream COMPRESSION_STATUS_ERROR")
                return

            default:
                break
            }

        } while status == COMPRESSION_STATUS_OK

        sourceFileHandle.closeFile()
        destinationFileHandle.closeFile()
    }
}

extension compression_stream {
    init() {
        self = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1).pointee
    }
}
