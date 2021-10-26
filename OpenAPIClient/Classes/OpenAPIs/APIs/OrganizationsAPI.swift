//
// OrganizationsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import Models

open class OrganizationsAPI {

    /**
     List the organizations that the user is part of
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func orgList(apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: V0OrganizationListRespModel?, _ error: Error?) -> Void)) {
        orgListWithRequestBuilder().execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List the organizations that the user is part of
     - GET /organizations
     - List all Bitrise organizations that the user is part of
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - returns: RequestBuilder<V0OrganizationListRespModel> 
     */
    open class func orgListWithRequestBuilder() -> RequestBuilder<V0OrganizationListRespModel> {
        let localVariablePath = "/organizations"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0OrganizationListRespModel>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get a specified organization.
     
     - parameter orgSlug: (path) The organization slug 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func orgShow(orgSlug: String, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, completion: @escaping ((_ data: V0OrganizationRespModel?, _ error: Error?) -> Void)) {
        orgShowWithRequestBuilder(orgSlug: orgSlug).execute(apiResponseQueue) { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Get a specified organization.
     - GET /organizations/{org-slug}
     - Get a specified Bitrise organization that the user is part of.
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - parameter orgSlug: (path) The organization slug 
     - returns: RequestBuilder<V0OrganizationRespModel> 
     */
    open class func orgShowWithRequestBuilder(orgSlug: String) -> RequestBuilder<V0OrganizationRespModel> {
        var localVariablePath = "/organizations/{org-slug}"
        let orgSlugPreEscape = "\(APIHelper.mapValueToPathItem(orgSlug))"
        let orgSlugPostEscape = orgSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{org-slug}", with: orgSlugPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0OrganizationRespModel>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}
