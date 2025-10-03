//
//  APIConfig.swift
//  BattleGroundAssement
//
//  Created by Satyam on 08/07/25.
//


public struct APIConfig {
    
    
    public struct APIUrl {
        
        #if DEV
        static let domain = APIUrl.dev
        #elseif QA
        static let domain = APIUrl.qa
        #elseif STAGING
        static let domain = APIUrl.staging
        #elseif RELEASE
        static let domain = APIUrl.prod
        #endif
        
        static let dev = "https://jsonplaceholder.typicode.com"
        private static let qa = ""
        private static let staging = ""
        private static let prod = ""
        private static let devmp = ""
        
//        public static var privacyPolicyURL: String {
//            return APIUrl.domain + "/privacy-policy"
//        }
    }
 
}
