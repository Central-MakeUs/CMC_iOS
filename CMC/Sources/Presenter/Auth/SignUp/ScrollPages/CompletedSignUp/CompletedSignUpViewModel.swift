//
//  CompletedSignUpViewModel.swift
//  CMC
//
//  Created by Siri on 10/28/23.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

import UIKit

final class CompletedSignUpViewModel: ViewModelType {
	
	struct Input {
		let nickname: Observable<String>
		let generation: Observable<String>
		let position: Observable<Part>
	}
	
	struct Output {
		let nextAvailable: Observable<Bool>
	}
	
	var disposeBag: DisposeBag = DisposeBag()
	
	private let defaultGeneration = "기수를 선택해주세요"
	private let defaultPosition = "포지션을 선택해주세요"
			
	
	// MARK: - Initializers
	init() {
		
	}
	
	func transform(input: Input) -> Output {
		let nicknameValid = input.nickname
			.map { !$0.isEmpty }
		
		let generationValid = input.generation
			.map { $0 != self.defaultGeneration }
		
		let positionValid = input.position
			.map { $0.rawValue != self.defaultPosition }
		
		let nextAvailable = Observable.combineLatest(
			nicknameValid,
			generationValid,
			positionValid
		)
			.map { $0 && $1 && $2 }
		
		return Output(
			nextAvailable: nextAvailable
		)
	}
	
}
