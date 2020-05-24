//
//  AudioSourceNode.swift
//  Operator
//
//  Created by Brian Michel on 5/24/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AVFoundation
import Foundation

final class AudioSourceNode {
    private(set) var node: AVAudioSourceNode?
    private var buffer: UnsafeMutablePointer<UInt16>
    private let bufferSize: UInt32
    private let format: AudioStreamBasicDescription

    init(buffer: UnsafeMutablePointer<UInt16>, size: UInt32, format: AudioStreamBasicDescription) {
        self.buffer = buffer
        self.format = format
        bufferSize = size

        node = AVAudioSourceNode { (_, timeStampPointer, frameCount, audioBufferListPointer) -> OSStatus in
            let mutableBufferList = UnsafeMutableAudioBufferListPointer(audioBufferListPointer)

            Log.debug("Timestamp - \(timeStampPointer.pointee)")
            for frame in 0 ..< Int(frameCount) {
                for buffer in mutableBufferList {
                    let mutableBuffer = UnsafeMutableBufferPointer<UInt16>(buffer)
                    let sample = self.buffer[frame]
                    Log.debug("Using sample \(frame) - \(sample) of \(self.bufferSize)")

                    mutableBuffer[frame] = sample
                }
            }

            return noErr
        }
    }

    deinit {
        buffer.deallocate()
    }
}
