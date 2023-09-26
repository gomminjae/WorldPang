//
//  TTSManager.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/24.
//

import UIKit
import AVFoundation

class TTSManager {
    
    static let shared = TTSManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func play(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.rate = 0.4
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    
}
