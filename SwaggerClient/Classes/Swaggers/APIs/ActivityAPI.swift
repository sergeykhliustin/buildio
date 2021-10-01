//
// ActivityAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class ActivityAPI {
    /**
     Get list of Bitrise activity events

     - parameter next: (query) Slug of the first activity event in the response (optional)
     - parameter limit: (query) Max number of elements per page (default: 50) (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func activityList(next: String? = nil, limit: Int? = nil, completion: @escaping ((_ data: V0ActivityEventListResponseModel?,_ error: Error?) -> Void)) {
        activityListWithRequestBuilder(next: next, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get list of Bitrise activity events
     - GET /me/activities

     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - examples: [{contentType=application/json, example={
  "data" : [ {
    "repository_avatar_icon_url" : "repository_avatar_icon_url",
    "repository_title" : "repository_title",
    "created_at" : "created_at",
    "description" : {
      "valid" : true,
      "string" : "string"
    },
    "slug" : "slug"
  }, {
    "repository_avatar_icon_url" : "repository_avatar_icon_url",
    "repository_title" : "repository_title",
    "created_at" : "created_at",
    "description" : {
      "valid" : true,
      "string" : "string"
    },
    "slug" : "slug"
  } ],
  "paging" : {
    "next" : "next",
    "page_item_limit" : 6,
    "total_item_count" : 1
  }
}}]
     - parameter next: (query) Slug of the first activity event in the response (optional)
     - parameter limit: (query) Max number of elements per page (default: 50) (optional)

     - returns: RequestBuilder<V0ActivityEventListResponseModel> 
     */
    open class func activityListWithRequestBuilder(next: String? = nil, limit: Int? = nil) -> RequestBuilder<V0ActivityEventListResponseModel> {
        let path = "/me/activities"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "next": next, 
                        "limit": limit?.encodeToJSON()
        ])


        let requestBuilder: RequestBuilder<V0ActivityEventListResponseModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
}
