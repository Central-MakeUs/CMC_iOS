//
//  Xcconfigs.swift
//  CMC
//
//  Created by Siri on 2023/10/24.
//  Copyright © 2023 com.centralMakeusChallenge. All rights reserved.
//

import Foundation

struct Xcconfig {
		static let BASE_URL = Bundle.main.infoDictionary?["Base_Url"] as! String
		static let BASE_API_URL = Bundle.main.infoDictionary?["Base_Api_Url"] as! String
		static let BUNDLE_ID = Bundle.main.infoDictionary?["Custom_Bundle_Id"] as! String
}
