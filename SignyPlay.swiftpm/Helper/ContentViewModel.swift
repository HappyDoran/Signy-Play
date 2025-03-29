//
//  CameraViewModel.swift
//  SSC
//
//  Created by Doran on 2/12/25.
//

import AVFoundation

@MainActor
class ContentViewModel: NSObject, ObservableObject, @preconcurrency AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isSessionRunning: Bool = false
    @Published var recognizedText: String = ""
    @Published var currentLetter: String = ""
    @Published var confidence: Double = 0.0
    @Published var currentName: String = "" 
    @Published var boundingBox: CGRect = .zero
    
    let cameraManager = CameraManager.shared
    let signRecognizer = SignRecognizer()
    
    private let processingQueue = DispatchQueue(label: "com.camera.processingQueue", attributes: .concurrent)
    
    override init() {
        super.init()
        setupCamera()
        observeRecognizerUpdates()
    }
    
    private func setupCamera() {
        cameraManager.set(self, queue: processingQueue)
    }
    
    private func observeRecognizerUpdates() {
        Task {
            for await (newName, newText, newCurrentLetter, newConfidence, newboundingBox) in signRecognizer.updates {
                await MainActor.run {
                    self.currentName = newName
                    self.recognizedText = newText
                    self.currentLetter = newCurrentLetter
                    self.confidence = newConfidence
                    self.boundingBox = newboundingBox
                }
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let bufferCopy = copySampleBuffer(sampleBuffer) else { return }
        
        Task {
            await signRecognizer.processFrame(bufferCopy)
        }
    }
    
    func startSession() {
        cameraManager.session.startRunning()
        isSessionRunning = true
    }
    
    func stopSession() {
        cameraManager.session.stopRunning()
        isSessionRunning = false
    }
    
    func copySampleBuffer(_ sampleBuffer: CMSampleBuffer) -> CMSampleBuffer? {
        var newBuffer: CMSampleBuffer?
        CMSampleBufferCreateCopy(allocator: kCFAllocatorDefault, sampleBuffer: sampleBuffer, sampleBufferOut: &newBuffer)
        return newBuffer
    }
    
    func removeLastCharacter() {
        Task {
            await signRecognizer.removeLastCharacter()
            self.recognizedText.removeLast()
        }
    }
    
    func resetText() {
        Task {
            await signRecognizer.resetText()
            self.recognizedText = ""
        }
    }
}
