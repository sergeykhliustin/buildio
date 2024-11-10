//
// AvatarCandidateAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import Models

package final class AvatarCandidateAPI: BaseAPI {

    /**
     Create avatar candidates
     
     - parameter appSlug: (path) App slug 
     - parameter avatarCandidate: (body) Avatar candidate parameters 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: [V0AvatarCandidateCreateResponseItem]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func avatarCandidateCreate(appSlug: String, avatarCandidate: [V0AvatarCandidateCreateParams]) async throws -> [V0AvatarCandidateCreateResponseItem] {
        return try await avatarCandidateCreateWithRequestBuilder(appSlug: appSlug, avatarCandidate: avatarCandidate).execute().body
    }

    /**
     Create avatar candidates
     - POST /apps/{app-slug}/avatar-candidates
     - Add new avatar candidates to a specific app
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - parameter appSlug: (path) App slug 
     - parameter avatarCandidate: (body) Avatar candidate parameters 
     - returns: RequestBuilder<[V0AvatarCandidateCreateResponseItem]> 
     */
    private func avatarCandidateCreateWithRequestBuilder(appSlug: String, avatarCandidate: [V0AvatarCandidateCreateParams]) -> RequestBuilder<[V0AvatarCandidateCreateResponseItem]> {
        var localVariablePath = "/apps/{app-slug}/avatar-candidates"
        let appSlugPreEscape = "\(APIHelper.mapValueToPathItem(appSlug))"
        let appSlugPostEscape = appSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{app-slug}", with: appSlugPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: avatarCandidate)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[V0AvatarCandidateCreateResponseItem]>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get list of the avatar candidates
     
     - parameter appSlug: (path) App slug 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0FindAvatarCandidateResponse
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func avatarCandidateList(appSlug: String) async throws -> V0FindAvatarCandidateResponse {
        return try await avatarCandidateListWithRequestBuilder(appSlug: appSlug).execute().body
    }

    /**
     Get list of the avatar candidates
     - GET /v0.1/apps/{app-slug}/avatar-candidates
     - List all available avatar candidates for an application
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - parameter appSlug: (path) App slug 
     - returns: RequestBuilder<V0FindAvatarCandidateResponse> 
     */
    private func avatarCandidateListWithRequestBuilder(appSlug: String) -> RequestBuilder<V0FindAvatarCandidateResponse> {
        var localVariablePath = "/v0.1/apps/{app-slug}/avatar-candidates"
        let appSlugPreEscape = "\(APIHelper.mapValueToPathItem(appSlug))"
        let appSlugPostEscape = appSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{app-slug}", with: appSlugPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0FindAvatarCandidateResponse>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Promote an avatar candidate
     
     - parameter appSlug: (path) App slug 
     - parameter avatarSlug: (path) Avatar candidate slug 
     - parameter avatarPromoteParams: (body) Avatar promote parameters 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0AvatarPromoteResponseModel
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    package func avatarCandidatePromote(appSlug: String, avatarSlug: String, avatarPromoteParams: V0AvatarPromoteParams) async throws -> V0AvatarPromoteResponseModel {
        return try await avatarCandidatePromoteWithRequestBuilder(appSlug: appSlug, avatarSlug: avatarSlug, avatarPromoteParams: avatarPromoteParams).execute().body
    }

    /**
     Promote an avatar candidate
     - PATCH /apps/{app-slug}/avatar-candidates/{avatar-slug}
     - Promotes an avatar candidate for an app
     - API Key:
       - type: apiKey Authorization 
       - name: PersonalAccessToken
     - parameter appSlug: (path) App slug 
     - parameter avatarSlug: (path) Avatar candidate slug 
     - parameter avatarPromoteParams: (body) Avatar promote parameters 
     - returns: RequestBuilder<V0AvatarPromoteResponseModel> 
     */
    private func avatarCandidatePromoteWithRequestBuilder(appSlug: String, avatarSlug: String, avatarPromoteParams: V0AvatarPromoteParams) -> RequestBuilder<V0AvatarPromoteResponseModel> {
        var localVariablePath = "/apps/{app-slug}/avatar-candidates/{avatar-slug}"
        let appSlugPreEscape = "\(APIHelper.mapValueToPathItem(appSlug))"
        let appSlugPostEscape = appSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{app-slug}", with: appSlugPostEscape, options: .literal, range: nil)
        let avatarSlugPreEscape = "\(APIHelper.mapValueToPathItem(avatarSlug))"
        let avatarSlugPostEscape = avatarSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{avatar-slug}", with: avatarSlugPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: avatarPromoteParams)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0AvatarPromoteResponseModel>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "PATCH", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}