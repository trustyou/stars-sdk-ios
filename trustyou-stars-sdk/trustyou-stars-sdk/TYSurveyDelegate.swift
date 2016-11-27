//
//  TYSurveyDelegate.swift
//  trustyou-stars-sdk
//
//  Created by Camille Mainz on 04/11/2016.
//  Copyright © 2016 TrustYou. All rights reserved.
//

import UIKit

public protocol TYSurveyDelegate {
    func onError(error: TrustYouError)
    func onSuccess(event: TrustYouEvent, surveyData: TYSurveyData?)
}
