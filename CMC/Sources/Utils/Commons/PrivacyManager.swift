//
//  PrivacyManager.swift
//  CMC
//
//  Created by 조용인 on 1/13/24.
//  Copyright © 2024 com.softsquared.cmc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class PrivacyManager {

    static let shared = PrivacyManager()

    private init() {}

    func requestPermission() -> Observable<Bool> {
        return Observable.create { observer in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                observer.onNext(true)
            case .notDetermined:
                DispatchQueue.main.async {
                    self.requestCameraPermission { granted in
                        observer.onNext(granted)
                    }
                }
            default:
                observer.onNext(false)
            }
            return Disposables.create()
        }
    }

    private func requestCameraPermission(closureResult: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                closureResult(granted)
            }
        }
    }

    // 나중에 권한 더 필요하면, title은 파라미터로 받던지 하자...
    func goToSettingsAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "QRCode 촬영을 위해 카메라 접근이 필요합니다.\n카메라 접근을 허용해 주세요.",
            message: "",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "설정",
                style: .default, handler: { _ in
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
        )
        return alert
    }
}
