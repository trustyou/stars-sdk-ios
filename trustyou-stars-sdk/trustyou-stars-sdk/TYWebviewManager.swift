//
//  TYWebviewManager.swift
//  trustyou-stars-sdk
//
//  Created by Camille Mainz on 31/10/2016.
//  Copyright © 2016 TrustYou. All rights reserved.
//

import UIKit
import WebKit

class TYWebviewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    let baseURL = "https://analytics.staging.trustyou.com/surveys/site/reviews/ty"
    let config = WKWebViewConfiguration()
    let embed = "ios"
    let version = "6.1"
    var delegate: TYSurveyDelegate?
    var loadSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "trustyou")
        self.config.userContentController = userContentController
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneButton));
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        navBar.barTintColor = UIColor.white

    }
    
    func doneButton() {
        self.dismissWebview(event: .SurveyClosed, surveyData: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showWebview(key: String, hotelID: String, delegate: TYSurveyDelegate, lang: String, guestName: String, guestEmail: String, prefillData: TYPrefillData) {
        self.delegate = delegate
        let urlString = baseURL + self.getRequestString(key: key, hotelID: hotelID, lang: lang, guestName: guestName, guestEmail: guestEmail, prefillData: prefillData).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlString)!
        let frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        let webview = WKWebView(frame: frame, configuration: config)
        webview.navigationDelegate = self
        webview.load(URLRequest(url: url))
        
        
        //timeout-timer
        _ = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.checkTimeout), userInfo: nil, repeats: false)
        
        //show webview
        self.view.addSubview(webview)
        self.modalPresentationStyle = .currentContext
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    func checkTimeout() {
        if !self.loadSuccess {
            self.dismissWebview(error: .Timeout)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let callback = convertStringToDictionary(text: message.body as! String) {
            if let event = callback["event"] as? String, let success = callback["success"] as? Bool {
                if event == "review_submitted" && success {
                    let body = message.body as! String
                    let range = body.range(of: "data\":")!
                    let index = body.index(body.endIndex, offsetBy: -1)
                    let newRange = Range(uncheckedBounds: (lower: range.upperBound, upper: index))
                    let trimmed = body.substring(with: newRange)
                    if let reviewData = self.convertStringToDictionary(text: trimmed) {
                        self.handleReviewSubmitted(data: reviewData)
                    }
                } else if event == "survey_loaded" && success {
                    self.loadSuccess = true
                } else if event == "survey_closed" && success {
                    self.dismissWebview(event: .SurveyClosed, surveyData: nil)
                } else if event == "submitting_review" && success {
                    if let delegate = self.delegate {
                        delegate.onSuccess(event: .SubmittingReview, surveyData: nil)
                    }
                }
            }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if (navigationResponse.response.url?.absoluteString.contains("trustyou.com"))! {
            let response = navigationResponse.response as! HTTPURLResponse
            let status = response.statusCode
            switch status {
            case 200:
                decisionHandler(.allow)
            case 400:
                decisionHandler(.cancel)
                self.dismissWebview(error: .InvalidParameters)
            case 403:
                decisionHandler(.cancel)
                self.dismissWebview(error: .APIKeyInvalid)
            case 404:
                decisionHandler(.cancel)
                self.dismissWebview(error: .SurveyNotFound)
            case 500:
                decisionHandler(.cancel)
                self.dismissWebview(error: .Internal)
            default:
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    func dismissWebview(error: TrustYouError) {
        self.dismiss(animated: true, completion: nil)
        if let delegate = self.delegate {
            delegate.onError(error: error)
        }
    }
    
    func dismissWebview(event: TrustYouEvent, surveyData: TYSurveyData?) {
        self.dismiss(animated: true, completion: nil)
        if let delegate = self.delegate {
            if let data = surveyData {
                delegate.onSuccess(event: event, surveyData: data)
            } else {
                delegate.onSuccess(event: event, surveyData: nil)
            }
        }
    }
    
    func handleReviewSubmitted(data: [String: AnyObject]) {
        let reviewData = TYSurveyData()
        if let clusterID = data["cluster_id"] as? String {
            reviewData.clusterID = clusterID
        }
        if let reviewID = data["review_id"] as? String {
            reviewData.reviewID = reviewID
        }
        if let creationTime = data["creation_time"] as? String {
            reviewData.creationTime = creationTime
        }
        if let visitMonth = data["visit_month"] as? String {
            reviewData.visitMonth = visitMonth
        }
        if let overallScore = data["overall_score"] as? String {
            reviewData.overallScore = overallScore
        }
        if let hotelRecommendation = data["hotel_recommendation"] as? String {
            reviewData.hotelRecommendation = hotelRecommendation
        }
        if let netPromoterScore = data["net_promoter_score"] as? String {
            reviewData.netPromoterScore = netPromoterScore
        }
        if let reviewTitle = data["review_title"] as? String {
            reviewData.reviewTitle = reviewTitle
        }
        if let reviewText = data["review_text"] as? String {
            reviewData.reviewText = reviewText
        }
        if let guestType = data["guest_type"] as? String {
            reviewData.guestType = guestType
        }
        if let guestNationality = data["guest_nationality"] as? String {
            reviewData.guestNationality = guestNationality
        }
        if let guestName = data["guest_name"] as? String {
            reviewData.guestName = guestName
        }
        if let guestEmail = data["guest_email"] as? String {
            reviewData.guestEmail = guestEmail
        }
        if let guestAge = data["guest_age"] as? String {
            reviewData.guestAge = guestAge
        }
        
        if let delegate = self.delegate {
            delegate.onSuccess(event: .ReviewSubmitted, surveyData: reviewData)
        }
    }
    
    func handleErrorEvent(errorCode: Int) {
        self.dismissWebview(error: .Network)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func getRequestString(key: String, hotelID: String, lang: String, guestName: String, guestEmail: String, prefillData: TYPrefillData) -> String {
        let requestBuilder = TYRequestBuilder(apiKey: key, hotelID: hotelID)
        requestBuilder.basicQuestions = prefillData.basicQuestionsToArray()
        if guestName != "" {
            requestBuilder.addPersonalData(type: .name, value: guestName)
        }
        if guestEmail != "" {
            requestBuilder.addPersonalData(type: .email, value: guestEmail)
        }
        requestBuilder.categoryQuestions = prefillData.categoryQuestions
        requestBuilder.customQuestions = prefillData.customQuestions
        
        return requestBuilder.buildRequest()
    }
    
}
