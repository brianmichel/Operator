//
//  AudioFile.swift
//  Operator
//
//  Created by Brian Michel on 5/4/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AudioKit
import AudioToolbox
import AVFoundation
import CoreAudio

typealias AudioPropertyInfo = (property: AudioFilePropertyID, size: UInt32, writable: UInt32)

final class AudioFile {
    private let url: URL
    private let fileId: AudioFileID
    private let audioFile: AKAudioFile

    lazy var userData: RawDrumHeaderMetadata? = {
        var itemCount: UInt32 = 0

        let code = FourCharCode(stringLiteral: "APPL")

        let status = AudioFileCountUserData(fileId, code, &itemCount)

        guard status == noErr else {
            return nil
        }

        var size: UInt32 = 0
        AudioFileGetUserDataSize(fileId, code, 0, &size)

        guard let data: UnsafeMutablePointer<UInt8> = get(userDataPointer: code, index: 0, inputSize: size) else {
            return nil
        }
        defer {
            data.deallocate()
        }
        // Explicitly do not free when done here since we're not copying the raw pointer bytes (gotta go fast)
        let string: String? = String(cString: data)
        // Determine if we've reached the OP-1 JSON, and if so advance 4 bytes and strip control characters.
        if let almostJSON = string, almostJSON.starts(with: "op-1") {
            let strippedString = almostJSON[4 ..< almostJSON.count].trimmingCharacters(in: .controlCharacters)

            do {
                let parsed = try JSONDecoder().decode(RawDrumHeaderMetadata.self, from: strippedString.data(using: .utf8)!)
                Log.debug("Parsed: \(parsed)")

                return parsed
            } catch {
                Log.error("Error Parsing String - \(error)")
            }
        }

        return nil
    }()

    var dataFormat: AudioStreamBasicDescription {
        guard let description: AudioStreamBasicDescription = get(property: kAudioFilePropertyDataFormat) else {
            return AudioStreamBasicDescription()
        }

        return description
    }

    var totalBytes: UInt64 {
        guard let totalBytes: UInt64 = get(property: kAudioFilePropertyAudioDataByteCount) else {
            return 0
        }

        return totalBytes
    }

    var duration: Float64 {
        guard let duration: Float64 = get(property: kAudioFilePropertyEstimatedDuration) else {
            return 0
        }

        return duration
    }

    init?(url: URL) {
        self.url = url
        var audioFile: AudioFileID?

        let status = AudioFileOpenURL(url as CFURL, .readPermission, kAudioFileAIFFType, &audioFile)

        Log.debug("status: \(status)")

        do {
            self.audioFile = try AKAudioFile(forReading: url)
        } catch {
            return nil
        }

        if let file = audioFile {
            fileId = file
        } else {
            return nil
        }
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

        if status == noErr, size > 0 {
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

        if status == noErr, size > 0 {
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

        if status == noErr, size > 0 {
            return propertyData.pointee
        }

        return nil
    }

    func createAudioPlayerForSlice(at startTime: Double, to endTime: Double) -> AKAudioPlayer? {
        do {
            let onePacketDuration = dataFormat.mSampleRate
            let startPacket = Int64(onePacketDuration * startTime)
            let endPacket = Int64(onePacketDuration * endTime)
            let clip = try audioFile.extracted(fromSample: startPacket, toSample: endPacket)

            let player = try AKAudioPlayer(file: clip)

            return player
        } catch {
            Log.error("Unable to extract AKAudioFile - \(error)")
        }

        return nil
    }

    deinit {
        AudioFileClose(fileId)
    }
}
