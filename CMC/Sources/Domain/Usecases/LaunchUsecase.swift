//
//  LaunchUsecase.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation
import RxSwift

protocol LaunchUsecase {
	func health() -> Single<LaunchModel>
}
