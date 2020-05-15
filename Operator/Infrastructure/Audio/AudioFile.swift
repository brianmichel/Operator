//
//  AudioFile.swift
//  Operator
//
//  Created by Brian Michel on 5/4/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AudioToolbox

struct ApplicationSpecificChunk {
    let ckID: UInt32
    let ckSize: Int32
    let applicationSignature: OSType
    let data: NSString
}

// https://gist.github.com/patrickjuchli/d1b07f97e0ea1da5db09
extension FourCharCode {
    public init(stringLiteral value: StringLiteralType) {
        var code: FourCharCode = 0
        // Value has to consist of 4 printable ASCII characters, e.g. '420v'.
        // Note: This implementation does not enforce printable range (32-126)
        if value.count == 4 && value.utf8.count == 4 {
            for byte in value.utf8 {
                code = code << 8 + FourCharCode(byte)
            }
        }
        else {
            print("FourCharCode: Can't initialize with '\(value)', only printable ASCII allowed. Setting to '????'.")
            code = 0x3F3F3F3F // = '????'
        }
        self = code
    }
}

typealias AudioPropertyInfo = (property: AudioFilePropertyID, size: UInt32, writable: UInt32)

final class AudioFile {
    private let fileId: AudioFileID

    var userDataCount: UInt32 {
        var itemCount: UInt32 = 0

        let code = FourCharCode(stringLiteral: "APPL")

        let status = AudioFileCountUserData(fileId, code, &itemCount)

        guard status == noErr else  {
            return 0
        }

        var size: UInt32 = 0
        AudioFileGetUserDataSize(fileId, code, 0, &size)

        guard let data: UnsafeMutablePointer<UInt8> = get(userDataPointer: code, index: 0, inputSize: size) else  {
            return 0
        }
        defer {
            data.deallocate()
        }

        // Explicitly do not free when done here since we're not copying the raw pointer bytes (gotta go fast)
        let string: String? = String(cString: data)
        // Determine if we've reached the OP-1 JSON, and if so advance 4 bytes and strip control characters.
        if let almostJSON = string, almostJSON.starts(with: "op-1") {
            let strippedString = almostJSON[4..<almostJSON.count].trimmingCharacters(in: .controlCharacters)

            do {
                let parsed = try JSONSerialization.jsonObject(with: strippedString.data(using: .utf8)!)
                print("Parsed: \(parsed)")
            } catch(let error) {
                print("Error Parsing String - \(error)")
            }
        }

        return itemCount
    }

    var dataFormat: AudioStreamBasicDescription {
        guard let description: AudioStreamBasicDescription = get(property: kAudioFilePropertyDataFormat) else {
            return AudioStreamBasicDescription()
        }

        return description
    }

    init?(url: URL) {
        var audioFile: AudioFileID?

        let status = AudioFileOpenURL(url as CFURL, .readPermission, kAudioFileAIFFType, &audioFile)

        print("status: \(status)")

        if let file = audioFile {
            fileId = file
        } else {
            return nil
        }

        print("Data count: \(self.userDataCount)")
    }

    func get<T>(userData code: FourCharCode, index: UInt32, inputSize: UInt32 = UInt32(MemoryLayout<T>.size)) -> T? {
        var size = inputSize
        var propertyData = unsafeBitCast(calloc(1, Int(size)), to: UnsafeMutablePointer<T>.self)

        defer {
            free(propertyData)
        }

        let status = AudioFileGetUserData(fileId,
                                          code,
                                          index,
                                          &size,
                                          propertyData)

        if status == noErr && size > 0 {
            return propertyData[0]
        }

        return nil
    }

    func get<T>(userDataPointer code: FourCharCode, index: UInt32, inputSize: UInt32 = UInt32(MemoryLayout<T>.size)) -> UnsafeMutablePointer<T>? {
        var size = inputSize
        let propertyData = unsafeBitCast(calloc(1, Int(size)), to: UnsafeMutablePointer<T>.self)

        let status = AudioFileGetUserData(fileId,
                                          code,
                                          index,
                                          &size,
                                          propertyData)

        if status == noErr && size > 0 {
            return propertyData
        }

        return nil
    }

    func get(info property: AudioFilePropertyID) -> AudioPropertyInfo? {
        var size: UInt32 = 0
        var writable: UInt32 = 0

        let status = AudioFileGetPropertyInfo(fileId,
                                              property,
                                              &size,
                                              &writable)

        if status == noErr {
            return (property, size, writable)
        }

        return nil
    }

    func get<T>(property: AudioFilePropertyID) -> T? {
        var size = UInt32(MemoryLayout<T>.size)
        var propertyData = unsafeBitCast(calloc(1, Int(size)), to: UnsafeMutablePointer<T>.self)

        defer {
            free(propertyData)
        }

        let status = AudioFileGetProperty(fileId,
                                          property,
                                          &size,
                                          propertyData)

        print("Got status \(status) when looking for property \(property)")

        if status == noErr && size > 0 {
            return propertyData.pointee
        }

        return nil
    }

    deinit {
        AudioFileClose(fileId)
    }
}
