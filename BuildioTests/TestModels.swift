//
//  BuildioTests.swift
//  BuildioTests
//
//  Created by severehed on 26.10.2021.
//

import XCTest
import Models

class BuildioTests: XCTestCase {
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
        for model in models {
            let dataArray = jsons[String(describing: model)] ?? []
            for data in dataArray {
                _ = try JSONDecoder().decode(model, from: data)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
