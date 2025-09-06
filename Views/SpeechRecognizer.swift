import Foundation
import Speech
import AVFoundation
import Combine

class SpeechRecognizer: NSObject, ObservableObject {
    @Published var transcribedText: String = ""
    @Published var didFinishTranscribing: Bool = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW")) // 改 "en-US" 可辨識英文
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var silenceTimer: Timer?
    
    // MARK: - 開始錄音
    func startTranscribing() {
        requestAuthorizationIfNeeded()
        reset()
        
        // 設定音訊 Session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0) // ✅ 移除舊的 tap
        
        recognitionTask = speechRecognizer?.recognitionTask(
            with: recognitionRequest!,
            resultHandler: { [weak self] result, error in
                guard let self = self else { return }
                
                if let result = result {
                    DispatchQueue.main.async {
                        self.transcribedText = result.bestTranscription.formattedString
                        self.restartSilenceTimer()
                    }
                    if result.isFinal {
                        self.finishTranscribing()
                    }
                }
                
                if error != nil {
                    self.finishTranscribing()
                }
            }
        )
        
        // ⚠️ 用 inputFormat(forBus:) 避免格式錯誤
        let recordingFormat = inputNode.inputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    // MARK: - 停止錄音
    func stopTranscribing() {
        finishTranscribing()
    }
    
    private func finishTranscribing() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.didFinishTranscribing = true
        }
    }
    
    private func reset() {
        transcribedText = ""
        didFinishTranscribing = false
    }
    
    // MARK: - 語音 + 麥克風授權
    private func requestAuthorizationIfNeeded() {
        // 語音辨識授權
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized: print("✅ 語音辨識已授權")
            case .denied: print("❌ 語音辨識被拒絕")
            case .restricted: print("⚠️ 裝置不支援語音辨識")
            case .notDetermined: print("⚠️ 尚未選擇是否允許語音辨識")
            @unknown default: break
            }
        }
        
        // 麥克風權限
            if #available(iOS 17, *) {
                // iOS 17+ 改用 AVAudioApplication
                AVAudioApplication.requestRecordPermission { granted in
                    if granted {
                        print("🎤 麥克風授權成功 (iOS17+)")
                    } else {
                        print("⚠️ 麥克風沒有授權 (iOS17+)")
                    }
                }
            } else {
                // iOS 16 及以下繼續用 AVAudioSession
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    if granted {
                        print("🎤 麥克風授權成功 (iOS16-)")
                    } else {
                        print("⚠️ 麥克風沒有授權 (iOS16-)")
                    }
                }
            }
        }
    // MARK: - 偵測靜音 2 秒自動結束
    private func restartSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.finishTranscribing()
        }
    }
}
