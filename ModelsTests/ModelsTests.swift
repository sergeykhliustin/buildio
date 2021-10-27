//
//  ModelsTests.swift
//  ModelsTests
//
//  Created by severehed on 26.10.2021.
//

import XCTest
import Models

class ModelsTests: XCTestCase {
    lazy var jsons: [String: [Data]] = {
        guard let jsonsURL = Bundle(for: type(of: self)).resourceURL?.appendingPathComponent("TestResources").appendingPathComponent("TestJSONs") else { return [:]}
        let contents = (try? FileManager.default.contentsOfDirectory(at: jsonsURL, includingPropertiesForKeys: nil, options: [.producesRelativePathURLs])) ?? []
        return contents.reduce([String: [Data]](), { partialResult, url in
            var result = partialResult
            if url.pathExtension == "json", let modelName = url.lastPathComponent.split(separator: "_").first {
                let key = String(modelName)
                var dataArr = result[key] ?? []
                do {
                    let data = try Data(contentsOf: url)
                    dataArr.append(data)
                } catch {
                    print(error)
                }
                result[key] = dataArr
            }
            return result
        })
    }()

    func testModels() throws {
        let models = [
            V0BuildListAllResponseModel.self
        ]
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        for model in models {
            let dataArray = jsons[String(describing: model)] ?? []
            for data in dataArray {
                XCTAssertNoThrow(try decoder.decode(model, from: data))
            }
        }
    }
}
