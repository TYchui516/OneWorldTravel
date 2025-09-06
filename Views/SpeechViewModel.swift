//
//  SpeechViewModel.swift
//  One World Travel
//
//  Created by TY Chui on 6/9/2025.
//

import Foundation
import Speech
import AVFoundation

@MainActor
class SpeechViewModel: ObservableObject {
    @Published var isListening = false
    @Published var errorMessage: String?
    @Published var activeSpeaker = "User A"
    @Published var messages: [ConversationMessage] = []

    private let service = TranslationService()
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let synthesizer = AVSpeechSynthesizer()

    func startListening() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            errorMessage = "語音辨識器不可用"
            return
        }
        recognitionTask?.cancel()
        recognitionTask = nil
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true)

            let inputNode = audioEngine.inputNode
            request = SFSpeechAudioBufferRecognitionRequest()
            guard let request = request else { return }
            request.shouldReportPartialResults = true

            recognitionTask = recognizer.recognitionTask(with: request) { result, error in
                if let result = result, result.isFinal {
                    Task { await self.handleSpoken(result.bestTranscription.formattedString) }
                }
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.stopListening()
                }
            }

            let format = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                self.request?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
            isListening = true
        } catch {
            errorMessage = "啟動語音識別失敗：\(error.localizedDescription)"
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        recognitionTask?.cancel()
        isListening = false
    }

    private func handleSpoken(_ text: String) async {
        _ = (activeSpeaker == "User A") ? "Chinese" : "English"
        let targetLang = (activeSpeaker == "User A") ? "English" : "Chinese"

        do {
            let translated = try await service.translate(text: text, targetLang: targetLang)
            let msg = ConversationMessage(speaker: activeSpeaker, original: text, translated: translated)
            messages.append(msg)
            let utterance = AVSpeechUtterance(string: translated)
            utterance.voice = AVSpeechSynthesisVoice(language: targetLang == "English" ? "en-US" : "zh-TW")
            synthesizer.speak(utterance)
        } catch {
            errorMessage = "翻譯失敗：\(error.localizedDescription)"
        }
    }
}
