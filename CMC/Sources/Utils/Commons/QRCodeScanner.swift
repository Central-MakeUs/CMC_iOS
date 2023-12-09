//
//  QRCodeScanner.swift
//  CMC
//
//  Created by Siri on 12/9/23.
//  Copyright © 2023 com.softsquared.cmc. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

import RxSwift
import RxCocoa

class ReaderView: UIView {
	
	// 카메라 화면을 보여줄 Layer
	var previewLayer: AVCaptureVideoPreviewLayer?
	var captureSession: AVCaptureSession?
	
	private let disposeBag = DisposeBag()
	
	private let scanResultSubject = PublishSubject<String>()
	
	/// 이 놈으로, 밖에서 qr데이터 다룹시다잉
	var scanResult: Observable<String> {
		return scanResultSubject.asObservable()
	}
	
	/// 여기는 PreviewLayer를 다루기 위한 값들 (레이어로 추가하기 위함)
	private var cornerLength: CGFloat = 36
	private var cornerLineWidth: CGFloat = 4
	private var rectOfInterest: CGRect {
		CGRect(x: (bounds.width / 2) - (192 / 2),
					 y: (bounds.height / 2) - (192 / 2),
					 width: 192, height: 192)
	}
	
	var isRunning: Bool {
		guard let captureSession = self.captureSession else {
			return false
		}
		return captureSession.isRunning
	}
	
	/// 촬영 시 어떤 데이터를 검사할건지? - QRCode
	let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initialSetupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initialSetupView()
	}
	
	/// AVCaptureSession을 실행하는 화면을 구성 후 실행합니다.
	private func initialSetupView() {
		self.clipsToBounds = true
		self.captureSession = AVCaptureSession()
		
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
		
		let videoInput: AVCaptureInput
		
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch let error {
			print(error.localizedDescription)
			return
		}
		
		guard let captureSession = self.captureSession else {
			self.fail()
			return
		}
		
		if captureSession.canAddInput(videoInput) {
			captureSession.addInput(videoInput)
		} else {
			self.fail()
			return
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
		
		if captureSession.canAddOutput(metadataOutput) {
			captureSession.addOutput(metadataOutput)
			
			metadataOutput.rx.didOutputMetadataObjects
				.subscribe(onNext: { [weak self] metadataObjects in
					self?.handleMetadataObjects(metadataObjects)
				})
				.disposed(by: disposeBag)
			
			metadataOutput.metadataObjectTypes = self.metadataObjectTypes
		} else {
			self.fail()
			return
		}
		
		self.setPreviewLayer()
		self.setFocusZoneCornerLayer()
		/*
		 // QRCode 인식 범위 설정하기
		 metadataOutput.rectOfInterest 는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정합니다.
		 !! 단 해당 값은 먼저 AVCaptureSession를 running 상태로 만든 후 지정해주어야 정상적으로 작동합니다 !!
		 */
		self.start()
		metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
	}
	
	//MARK: - 기존의 AVCaptureMetadataOutputObjectsDelegate 메서드를 Rx로 처리합시더
	private func handleMetadataObjects(_ metadataObjects: [AVMetadataObject]) {
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
						let stringValue = readableObject.stringValue else {
				return
			}
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			scanResultSubject.onNext(stringValue)
			stop(isButtonTap: true)
		}
	}
	
	/// 중앙에 사각형의 Focus Zone Layer을 설정합니다.
	private func setPreviewLayer() {
		let readingRect = rectOfInterest
		
		guard let captureSession = self.captureSession else {
			return
		}
		
		/*
		 AVCaptureVideoPreviewLayer를 구성.
		 */
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		previewLayer.frame = self.layer.bounds
		
		// MARK: - Scan Focus Mask
		/*
		 Scan 할 사각형(Focus Zone)을 구성하고 해당 자리만 dimmed 처리를 하지 않음.
		 */
		/*
		 CAShapeLayer에서 어떠한 모양(다각형, 폴리곤 등의 도형)을 그리고자 할 때 CGPath를 사용한다.
		 즉 previewLayer에다가 ShapeLayer를 그리는데
		 ShapeLayer의 모양이 [1. bounds 크기의 사각형, 2. readingRect 크기의 사각형]
		 두개가 그려져 있는 것이다.
		 */
		let path = CGMutablePath()
		path.addRect(bounds)
		path.addRect(readingRect)
		
		/*
		 그럼 Path(경로? 모양?)은 그렸으니 Layer의 특징을 정하고 추가해보자.
		 먼저 CAShapeLayer의 path를 위에 지정한 path로 설정해주고,
		 QRReader에서 백그라운드 색이 dimmed 처리가 되어야 하므로 layer의 투명도를 0.6 정도로 설정한다.
		 단 여기서 QRCode를 읽을 부분은 dimmed 처리가 되어 있으면 안 된다.
		 이럴때 fillRule에서 evenOdd를 지정해주는데
		 Path(도형)이 겹치는 부분(여기서는 readingRect, QRCode 읽는 부분)은 fillColor의 영향을 받지 않는다
		 */
		let maskLayer = CAShapeLayer()
		maskLayer.path = path
		maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
		maskLayer.fillRule = .evenOdd
		
		previewLayer.addSublayer(maskLayer)
		
		self.layer.addSublayer(previewLayer)
		self.previewLayer = previewLayer
	}
	
	// MARK: - Focus Edge Layer
	/// Focus Zone의 모서리에 테두리 Layer을 씌웁니다.
	private func setFocusZoneCornerLayer() {
		var cornerRadius = previewLayer?.cornerRadius ?? CALayer().cornerRadius
		if cornerRadius > cornerLength { cornerRadius = cornerLength }
		if cornerLength > rectOfInterest.width / 2 { cornerLength = rectOfInterest.width / 2 }
		
		// Focus Zone의 각 모서리 point
		let upperLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
		let upperRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
		let lowerRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
		let lowerLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
		
		// 각 모서리를 중심으로 한 Edge를 그림.
		let upperLeftCorner = UIBezierPath()
		upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
		upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
		upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))
		
		let upperRightCorner = UIBezierPath()
		upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
		upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
														radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
		upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))
		
		let lowerRightCorner = UIBezierPath()
		lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
		lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
														radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
		lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))
		
		let bottomLeftCorner = UIBezierPath()
		bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
		bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
														radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
		bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
		
		// 그려진 UIBezierPath를 묶어서 CAShapeLayer에 path를 추가 후 화면에 추가.
		let combinedPath = CGMutablePath()
		combinedPath.addPath(upperLeftCorner.cgPath)
		combinedPath.addPath(upperRightCorner.cgPath)
		combinedPath.addPath(lowerRightCorner.cgPath)
		combinedPath.addPath(bottomLeftCorner.cgPath)
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = combinedPath
		shapeLayer.strokeColor = UIColor.white.cgColor
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineWidth = cornerLineWidth
		shapeLayer.lineCap = .square
		
		self.previewLayer!.addSublayer(shapeLayer)
	}
}

// MARK: - ReaderView Running Method
extension ReaderView {
	func start() {
		print("# AVCaptureSession Start Running")
		self.captureSession?.startRunning()
	}
	
	func stop(isButtonTap: Bool) {
		self.captureSession?.stopRunning()
	}
	
	func fail() {
		self.captureSession = nil
	}
	
}

internal extension CGPoint {
	
	// MARK: - CGPoint+offsetBy
	func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
		var point = self
		point.x += dx
		point.y += dy
		return point
	}
}

/// AVCaptureMetadataOutputObjectsDelegate 관련 Rx 확장
extension Reactive where Base: AVCaptureMetadataOutput {
		var didOutputMetadataObjects: Observable<[AVMetadataObject]> {
				return Observable.create { observer in
						let delegate = RxAVCaptureMetadataOutputObjectsDelegate(observer: observer)
						base.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
						return Disposables.create {
								base.setMetadataObjectsDelegate(nil, queue: nil)
						}
				}
		}
}

final class RxAVCaptureMetadataOutputObjectsDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
		private let observer: AnyObserver<[AVMetadataObject]>
		init(observer: AnyObserver<[AVMetadataObject]>) {
				self.observer = observer
		}
		func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
				observer.onNext(metadataObjects)
		}
}
