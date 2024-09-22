//
//  SpeechSynthesizerHandler.swift
//  my-music-app
//
//  Created by Deepak Malkan on 9/6/24.
//

import Foundation
import AVKit

/// Thin wrapper over AVSpeechSynthesizer
public struct SpeechSynthesizerHandler {
    private let speechSynthesizer = AVSpeechSynthesizer ()
    
    public init () {
        
    }

    public func speak (text: String, voice: AVSpeechSynthesisVoice?) {
        let filteredText = text.removeCharacters (from: "-()")
        let utterance = AVSpeechUtterance (string: filteredText)
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.5
        utterance.volume = 100
        if voice != nil {
            utterance.voice = voice
        }
        else {
            utterance.voice = AVSpeechSynthesisVoice (language: "en-US")
        }
        speechSynthesizer.speak (utterance)
    }
    
    public func speakInUSEnglish (text:String) {
        // let voice = AVSpeechSynthesisVoice (identifier: "com.apple.voice.compact.en-US.Samantha")
        let voice = AVSpeechSynthesisVoice (identifier: "com.apple.eloquence.en-US.Shelley")
        speak (text: text, voice: voice)
    }
    
    public func speakInIndianEnglish (text:String) {
        let voice = AVSpeechSynthesisVoice (identifier: "com.apple.voice.compact.en-IN.Rishi")
        speak (text: text, voice: voice)
    }

    public func speakInHindi (text:String) {
        let voice = AVSpeechSynthesisVoice (identifier: "com.apple.voice.compact.hi-IN.Lekha")
        speak (text: text, voice: voice)
    }
}
