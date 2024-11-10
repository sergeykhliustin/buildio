//
// UserAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import Models

package final class UserAPI: BaseAPI {

    /**
     The active addon tokens of the user
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: [String]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func userAddonTokens() async throws -> [String] {
        return try await userAddonTokensWithRequestBuilder().execute().body
    }

    /**
     The active addon tokens of the user
     - GET /me/addon-tokens
     - Lists the active addon tokens of the user with some extra details.
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - returns: RequestBuilder<[String]> 
     */
    private func userAddonTokensWithRequestBuilder() -> RequestBuilder<[String]> {
        let localVariablePath = "/me/addon-tokens"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[String]>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Removes an active addon token of the user
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func userAddonTokensDelete() async throws {
        return try await userAddonTokensDeleteWithRequestBuilder().execute().body
    }

    /**
     Removes an active addon token of the user
     - DELETE /me/addon-tokens/{addon-id}
     - Removes the active addon token of the user.
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - returns: RequestBuilder<Void> 
     */
    private func userAddonTokensDeleteWithRequestBuilder() -> RequestBuilder<Void> {
        let localVariablePath = "/me/addon-tokens/{addon-id}"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     The subscription plan of the user
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0UserPlanRespModel
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func userPlan() async throws -> V0UserPlanRespModel {
        return try await userPlanWithRequestBuilder().execute().body
    }

    /**
     The subscription plan of the user
     - GET /me/plan
     - Get the subscription of the user: the current plan, any pending plans, and the duration of a trial period if applicable
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - returns: RequestBuilder<V0UserPlanRespModel> 
     */
    private func userPlanWithRequestBuilder() -> RequestBuilder<V0UserPlanRespModel> {
        let localVariablePath = "/me/plan"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0UserPlanRespModel>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get your profile data
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0UserProfileRespModel
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func userProfile() async throws -> V0UserProfileRespModel {
        return try await userProfileWithRequestBuilder().execute().body
    }

    /**
     Get your profile data
     - GET /me
     - Shows the authenticated users profile data
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - returns: RequestBuilder<V0UserProfileRespModel> 
     */
    private func userProfileWithRequestBuilder() -> RequestBuilder<V0UserProfileRespModel> {
        let localVariablePath = "/me"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0UserProfileRespModel>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get a specific user
     
     - parameter userSlug: (path) User slug 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0UserProfileRespModel
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func userShow(userSlug: String) async throws -> V0UserProfileRespModel {
        return try await userShowWithRequestBuilder(userSlug: userSlug).execute().body
    }

    /**
     Get a specific user
     - GET /users/{user-slug}
     - Show information about a specific user
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - parameter userSlug: (path) User slug 
     - returns: RequestBuilder<V0UserProfileRespModel> 
     */
    private func userShowWithRequestBuilder(userSlug: String) -> RequestBuilder<V0UserProfileRespModel> {
        var localVariablePath = "/users/{user-slug}"
        let userSlugPreEscape = "\(APIHelper.mapValueToPathItem(userSlug))"
        let userSlugPostEscape = userSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{user-slug}", with: userSlugPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0UserProfileRespModel>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}