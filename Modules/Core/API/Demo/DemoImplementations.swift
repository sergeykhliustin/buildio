//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 20.12.2021.
//

import Foundation

private extension String {
    func appendingPath(_ path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
}

final class DemoRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return DemoRequestBuilder<T>.self
    }

    func getBuilder<T: Codable>() -> RequestBuilder<T>.Type {
        return DemoDecodableRequestBuilder<T>.self
    }
}

final class DemoRequestBuilder<T>: URLSessionRequestBuilder<T>, @unchecked Sendable {
    required init(method: String, URLString: String, parameters: [String: Any]?, headers: [String: String] = [:]) {
        logger.debug("")
        super.init(method: method, URLString: URLString, parameters: parameters, headers: headers)
    }
    
    override func executeCompletion(_ completion: @Sendable @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        if ProcessInfo.processInfo.environment["DEMO_RECORD"] != nil {
            return super.executeCompletion(completion)
        } else {
            completion(.failure(.demoRestricted))
            return requestTask
        }
    }
}

final class DemoDecodableRequestBuilder<T: Codable>: URLSessionDecodableRequestBuilder<T>, @unchecked Sendable {
    override func executeCompletion(_ completion: @Sendable @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        if let path = demoRecordPath {
            try? FileManager.default
                .createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            let fileUrl = URL(fileURLWithPath: path).appendingPathComponent("data.json")
            let completionWrapped: @Sendable (Result<Response<T>, ErrorResponse>) -> Void = {
                if case .success(let response) = $0 {
                    let value = response.body
                    do {
                        let data = try CodableHelper.encode(value: value)
                        try data.write(to: fileUrl)
                    } catch {
                        logger.error(error)
                    }
                }
                completion($0)
            }
            return super.executeCompletion(completionWrapped)
        } else {
            if let demoDataURL = demoDataFileURL,
                var data = try? Data(contentsOf: demoDataURL) {
                let appIconPlaceholder = Data("[[APP_ICON]]".utf8)
                if let appIconURL = Bundle.main.url(forResource: "app_icon", withExtension: "png")?.absoluteString.data(using: .utf8) {
                    while let range = data.range(of: appIconPlaceholder) {
                        data.replaceSubrange(range, with: appIconURL)
                    }
                }
                
                do {
                    switch T.self {
                    case is String.Type:
                        let value = String(data: data, encoding: .utf8) ?? ""
                        // swiftlint:disable force_cast
                        completion(.success(Response(statusCode: 200, header: [:], body: value as! T)))
                        // swiftlint:enable force_cast
                    default:
                        let value = try CodableHelper.decode(type: T.self, from: data)
                        completion(.success(Response(statusCode: 200, header: [:], body: value)))
                    }
                    
                } catch {
                    logger.error(error)
                    completion(.failure(.demoRestricted))
                }
            } else {
                completion(.failure(.demoRestricted))
            }
        }
        return requestTask
    }
    
    private let demoRedirectRules: [String: String] = [
        "v0.1/apps/b1f7617eef3ca71b/builds": "v0.1/builds",
        "artifacts": "v0.1/apps/b1f7617eef3ca71b/builds/1/artifacts",
        "log": "v0.1/apps/b1f7617eef3ca71b/builds/1/log",
        "bitrise.yml": "v0.1/apps/b1f7617eef3ca71b/builds/1/bitrise.yml"
    ]
    
    private func applyRedirectRules(_ path: String) -> String {
        let trimmed = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if trimmed.hasSuffix("artifacts") {
            return demoRedirectRules["artifacts"] ?? path
        } else if trimmed.hasSuffix("log") {
            return demoRedirectRules["log"] ?? path
        } else if trimmed.hasSuffix("bitrise.yml") {
            return demoRedirectRules["bitrise.yml"] ?? path
        }
        return demoRedirectRules[trimmed] ?? path
    }
    
    private var demoDataFileURL: URL? {
        guard let components = URLComponents(string: URLString) else { return nil }
        let pathComponent = applyRedirectRules(components.path)
        return Bundle.module.resourceURL?
            .appendingPathComponent("DemoData")
            .appendingPathComponent(self.method)
            .appendingPathComponent(pathComponent)
            .appendingPathComponent("data.json")
    }
    
    private var demoRecordPath: String? {
        guard ProcessInfo.processInfo.environment["DEMO_RECORD"] != nil else { return nil }
        guard let components = URLComponents(string: URLString) else { return nil }
        return NSTemporaryDirectory()
            .appendingPath("DemoData")
            .appendingPath(self.method)
            .appendingPath(components.path)
    }
}
