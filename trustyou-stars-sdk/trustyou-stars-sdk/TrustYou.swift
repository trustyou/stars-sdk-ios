//
//  TYSurveyManager.swift
//  trustyou-stars-sdk
//
//  Created by Camille Mainz on 31/10/2016.
//  Copyright © 2016 TrustYou. All rights reserved.
//

import Foundation

public class TrustYou {
    
    public class func showSurvey(apiKey: String,
                                 hotelID: String,
                                 delegate: TYSurveyDelegate,
                                 lang: String = "en",
                                 guestName: String = "",
                                 guestEmail: String = "",
                                 prefillData: TYPrefillData = TYPrefillData()) {
        
        let wvc = TYWebviewController()
        wvc.showWebview(key: apiKey,
                        hotelID: hotelID,
                        delegate: delegate,
                        lang: lang,
                        guestName: guestName,
                        guestEmail: guestEmail,
                        prefillData: prefillData)
    }
}

public enum TrustYouError {
    case APIKeyInvalid
    case SurveyNotFound
    case Timeout
    case Internal
    case Network
    case InvalidParameters
}

public enum TrustYouEvent {
    case ReviewSubmitted
    case SurveyClosed
    case SubmittingReview
}
