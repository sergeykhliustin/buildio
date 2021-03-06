//
// OrganizationsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import Models

public final class OrganizationsAPI: BaseAPI {

    /**
     List the organizations that the user is part of
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0OrganizationListRespModel
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func orgList(apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue) async throws -> V0OrganizationListRespModel {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = orgListWithRequestBuilder().execute(apiResponseQueue) { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
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
    private func orgListWithRequestBuilder() -> RequestBuilder<V0OrganizationListRespModel> {
        let localVariablePath = "/organizations"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0OrganizationListRespModel>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }

    /**
     Get a specified organization.
     
     - parameter orgSlug: (path) The organization slug 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: V0OrganizationRespModel
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func orgShow(orgSlug: String, apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue) async throws -> V0OrganizationRespModel {
        var requestTask: RequestTask?
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                requestTask = orgShowWithRequestBuilder(orgSlug: orgSlug).execute(apiResponseQueue) { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response.body)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: { [requestTask] in
            requestTask?.cancel()
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
    private func orgShowWithRequestBuilder(orgSlug: String) -> RequestBuilder<V0OrganizationRespModel> {
        var localVariablePath = "/organizations/{org-slug}"
        let orgSlugPreEscape = "\(APIHelper.mapValueToPathItem(orgSlug))"
        let orgSlugPostEscape = orgSlugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{org-slug}", with: orgSlugPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = authorizationHeaders()

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<V0OrganizationRespModel>.Type = requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters)
    }
}
