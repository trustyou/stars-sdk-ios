# TrustYou Stars SDK - iOS
## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate TrustYouStarsSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'TrustYouStarsSDK'
end
```

Then, run the following command:

```bash
$ pod install
```
## Usage
### 1. Open Survey
To open a survey, you need to call the static method **showSurvey** located in the **TrustYou**-class.
The **showSurvey** method takes the following parameters:
#### Required
- apiKey (String):  API-key obtained from TrustYou
- hotelID (String): Id of the selected hotel
- delegate (TYSurveyDelegate): Delegate conforming to the [TYSurveyDelegate](#### TYSurveyDelegate) protocol.

#### Optional
- lang (String): Language the survey is shown in. Defaults to **"en"**
- guestName (String): Pre-filled name of the guest
- guestEmail (String): Pre-filled e-mail address of the guest
- prefillData (TYPrefillData): Prefilled data, see [TYPrefillData](#### TYPrefillData)

#### Example
```swift
TrustYou.showSurvey(apiKey: "1234-5678",
                    hotelID: "123",
                    delegate: self)
```
### 2. Success and Error Handling
#### TYSurveyDelegate
TYSurveyDelegate requires you to implement two functions which are called when either the survey was successfully closed or an error occured. The survey data is only passed in case of an **ReviewSubmitted** event and uses the [TYSurveyData](#### TYSurveyData) model.
```swift
func onClosed(event: TrustYouEvent, surveyData: TYSurveyData?) {
      //handle Survey Data
}

func onError(error: TrustYouError) {
        //handle Errors
}
```
#### TrustYouEvent
TrustYouEvent is an enum representation of all the events that can occur when showing a survey. Its cases are:
```swift
case ReviewSubmitted    // review was successfully submitted
case SurveyClosed       // survey is finished and the overlay will be dismissed
case SubmittingReview   // currently submitting the review to TrustYou
```

#### TrustYouError
TrustYouError is an enum representation of all the errors that can occur when trying to show a survey. Its cases are:
```swift
case APIKeyInvalid      // check if your API-Key is valid
case SurveyNotFound     // no survey for this hotel defined
case Timeout            // network timeout
case Internal           // internal error with TrustYou or the SDK
case Network            // network connection unavailable or unreliable
case InvalidParameters  // the passed parameters are invalid
```
### 3. Data Models
#### TYPrefillData
TYSurveyData is an object representation of the data passed to customize the shown survey. Every parameter is optional, so you may only add the ones you need.
- score: Int
- title: String
- review: String
- travellerType: TYTravellerType
- travellerAge: Int
- travellerNationality: String
- wouldYouRecommend: Bool
- nps: Int
- visitMonth: Int
- visitYear: Int

You can also add custom questions (**TYCustomQuestion**) and category questions (**TYCategoryQuestion**) by using these functions on the TYPrefillData-object:
```swift
//category question
let categoryQuestion = TYCategoryQuestion(id: "12345")
categoryQuestion.score = 5
categoryQuestion.review = "Review"
prefillData.addCategoryQuestion(question: categoryQuestion)

//custom question
let customQuestion = TYCustomQuestion(uuid: 1234-1234-1234, value: "Value")
prefillData.addCustomQuestion(question: customQuestion)
```
**TYCategoryQuestion** consist of a mandatory *id*, with optional parameters for *review* (String) and *score* (Int).
**TYCustomQuestion** consist of a mandatory *uuid* and *value* (both String).
You can get the id and uuid form TrustYou.

#### TYSurveyData
TYSurveyData is an object representation of the data entered by the user to the survey and then returned to the host app.
- clusterID: String
- reviewID: String
- creationTime: String
- visitMonth: String
- overallScore: String
- hotelRecommendation: String
- netPromoterScore: String
- reviewTitle: String
- reviewText: String
- guestType: String
- guestAge: String
- guestNationality: String
- guestName: String
- guestEmail: String
