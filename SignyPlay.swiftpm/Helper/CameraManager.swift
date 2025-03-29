//
//  CameraManager.swift
//  SSC
//
//  Created by Doran on 2/12/25.
//

import SwiftUI
@preconcurrency import AVFoundation

enum CameraError: Error {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case createCaptureInput(Error)
    case deniedAuthorization
    case restrictedAuthorization
    case unknownAuthorization
}

class CameraManager : @unchecked Sendable, ObservableObject {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    static let shared = CameraManager()
    
    @Published var isSessionConfigured = false
    @Published var error: CameraError?
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.camera.sessionQueue")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured
    
    private init() {
        configure()
    }
    
    private func configure() {
        checkPermissions()
        sessionQueue.async { [weak self] in
            self?.configureCaptureSession()
            self?.session.startRunning()
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authorized in
                if !authorized {
                    self?.status = .unauthorized
                    self?.setError(.deniedAuthorization)
                }
                self?.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            setError(.restrictedAuthorization)
        case .denied:
            status = .unauthorized
            setError(.deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            setError(.unknownAuthorization)
        }
    }
    
    private func setError(_ error: CameraError) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else { return }
        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
            DispatchQueue.main.async {
                self.isSessionConfigured = true
            }
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            setError(.cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                setError(.cannotAddInput)
                status = .failed
                return
            }
        } catch {
            setError(.createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            if let connection = videoOutput.connection(with: .video) {
                connection.videoOrientation = .portrait
            }
        } else {
            setError(.cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}
