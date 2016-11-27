//
//  TYPrefillData.swift
//  trustyou-stars-sdk
//
//  Created by Camille Mainz on 15/11/2016.
//  Copyright © 2016 TrustYou. All rights reserved.
//

import UIKit

public class TYPrefillData {
    
    //basic questions
    public var score: Int?
    public var title: String?
    public var review: String?
    public var travellerType: TYTravellerType?
    public var travellerAge: Int?
    public var travellerNationality: String?
    public var wouldYouRecommend: Bool?
    public var nps: Int?
    public var visitMonth: Int?
    public var visitYear: Int?
    
    public init() {
        
    }
    
    //category and custom questions
    var categoryQuestions = [TYCategoryQuestion]()
    var customQuestions = [TYCustomQuestion]()
    
    //add Questions
    public func addCategoryQuestion(question: TYCategoryQuestion) {
        self.categoryQuestions.append(question)
    }
    public func addCustomQuestion(question: TYCustomQuestion) {
        self.customQuestions.append(question)
    }
    
    func basicQuestionsToArray() -> [(TYBasicQuestion, String)] {
        var questions = [(TYBasicQuestion, String)]()
        if let bqScore = score {
            questions.append((TYBasicQuestion.score, String(bqScore)))
        }
        if let bqTitle = title {
            questions.append((TYBasicQuestion.title, bqTitle))
        }
        if let bqReview = review {
            questions.append((TYBasicQuestion.review, bqReview))
        }
        if let bqType = travellerType {
            questions.append((TYBasicQuestion.travellerType, bqType.rawValue))
        }
        if let bqAge = travellerAge {
            questions.append((TYBasicQuestion.travellerAge, String(bqAge)))
        }
        if let bqNat = travellerNationality {
            questions.append((TYBasicQuestion.travellerNationality, bqNat))
        }
        if let bqRec = wouldYouRecommend {
            if bqRec {
                questions.append((TYBasicQuestion.wouldYouRecommend, "yes"))
            } else {
                questions.append((TYBasicQuestion.wouldYouRecommend, "no"))
            }
        }
        if let bqNps = nps {
            questions.append((TYBasicQuestion.nps, String(bqNps)))
        }
        if let bqMonth = visitMonth {
            questions.append((TYBasicQuestion.visitMonth, String(bqMonth)))
        }
        if let bqYear = visitYear {
            questions.append((TYBasicQuestion.visitYear, String(bqYear)))
        }
        return questions
    }
}

public enum TYTravellerType: String {
    case Business = "business"
    case Family = "family"
    case Couple = "couple"
    case Friends = "friends"
    case Single = "single"
}
