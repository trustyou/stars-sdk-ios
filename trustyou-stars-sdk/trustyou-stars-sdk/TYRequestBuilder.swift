//
//  TYRequestBuilder.swift
//  trustyou-stars-sdk
//
//  Created by Camille Mainz on 16/11/2016.
//  Copyright © 2016 TrustYou. All rights reserved.
//

import UIKit

class TYRequestBuilder {
    
    let embed = "ios"
    let version = "6.1"
    let apiKey: String
    let hotelID: String
    
    let apiPrefix = "https://analytics.staging.trustyou.com/surveys/site/reviews/ty?"
    
    var basicQuestions = [(TYBasicQuestion, String)]()
    var personalData = [(String, String)]()
    var categoryQuestions = [TYCategoryQuestion]()
    var customQuestions = [TYCustomQuestion]()
    
    init(apiKey: String, hotelID: String) {
        self.apiKey = apiKey
        self.hotelID = hotelID
    }
    
    func addPersonalData(type: TYPersonalData, value: String) {
        personalData.append((type.rawValue, value))
    }
    
    private var basicRequest: String {
        return "?key=\(apiKey)&hotel_id=\(hotelID)&embed=\(self.embed)&v=\(self.version)"
    }
    
    private var personalDataRequest: String {
        var request = ""
        for (key, value) in personalData {
            request += "&pd[\(key)]=\(value)"
        }
        return request
    }
    
    private var basicQuestionRequest: String {
        var request = ""
        for (key, value) in basicQuestions {
            request += "&bq[\(key.rawValue)]=\(value)"
        }
        return request
    }
    
    private var categoryQuestionRequest: String {
        var request = ""
        for question in categoryQuestions {
            if let score = question.score {
                request += "&catq[\(question.id)].score=\(score)"
            }
            if let review = question.review {
                request += "&catq[\(question.id)].review=\(review)"
            }
        }
        return request
    }
    
    private var customQuestionRequest: String {
        var request = ""
        for question in customQuestions {
            request += "&cq[\(question.uuid)]=\(question.value)"
        }
        return request
    }
    
    func buildRequest() -> String {
        return self.basicRequest + self.personalDataRequest + self.basicQuestionRequest + self.categoryQuestionRequest + self.customQuestionRequest
    }
    
}

enum TYBasicQuestion: String {
    case score = "score"
    case title = "title"
    case review = "review"
    case travellerType = "traveller_type"
    case travellerAge = "traveller_age"
    case travellerNationality = "traveller_nationality"
    case wouldYouRecommend = "recommend"
    case nps = "nps"
    case visitMonth = "visit_month"
    case visitYear = "visit_year"
}
enum TYPersonalData: String {
    case name = "name"
    case email = "email"
}
