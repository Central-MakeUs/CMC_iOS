//
//  ViewModelType.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import RxSwift

protocol ViewModelType: AnyObject{
	associatedtype Input
	associatedtype Output
	
	
	// MARK: - Properties
	var disposeBag: DisposeBag { get }
	
	// MARK: - Methods
	func transform(input: Input) -> Output
}

