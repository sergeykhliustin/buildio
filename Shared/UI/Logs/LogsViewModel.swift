//
//  LogsViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import Foundation
import Models
import Combine
import Rainbow
import UIKit
import SwiftUI

class LogsViewModel: BaseViewModel<BuildLogResponseModel> {
    let build: V0BuildResponseItemModel
    private var timer: Timer?
    @Published var attributedLogs: NSAttributedString?
    
    init(build: V0BuildResponseItemModel) {
        self.build = build
        super.init()
    }
    
    override func fetch() -> AnyPublisher<BuildLogResponseModel, ErrorResponse> {
        BuildsAPI().buildLog(appSlug: build.repository.slug, buildSlug: build.slug)
            .eraseToAnyPublisher()
    }
    
    override func afterRefresh() {
        guard let value = value else { return }
        let logChunks = value.logChunks
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let attributed = logChunks.reduce(NSMutableAttributedString()) { partialResult, chunk in
                partialResult.append(self.chunkToAttributed(chunk.chunk))
                return partialResult
            }
            DispatchQueue.main.sync {
                self.attributedLogs = attributed
                if !value.isArchived {
                    self.scheduleNextUpdate()
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }
    
    private func chunkToAttributed(_ chunk: String) -> NSAttributedString {
        let entry = Rainbow.extractEntry(for: chunk)
        return entry.segments.reduce(NSMutableAttributedString()) { partialResult, segment in
            partialResult.append(segment.attributedString)
            return partialResult
        }
    }
    
    private func scheduleNextUpdate() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh()
        })
    }
}

private extension Rainbow.Segment {
    var attributedString: NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let background = self.backgroundColor, let color = Color.color(for: background) {
            attributes[.backgroundColor] = UIColor(color)
        }
        if let foreground = self.color, let color = Color.color(for: foreground) {
            attributes[.foregroundColor] = UIColor(color)
        } else {
            attributes[.foregroundColor] = UIColor(Color.b_LogsDefault)
        }
        for style in styles ?? [] {
            switch style {
            case .bold:
                attributes[.font] = UIFont.boldSystemFont(ofSize: 13)
            case .italic:
                attributes[.font] = UIFont.italicSystemFont(ofSize: 13)
            case .underline:
                attributes[.underlineStyle] = NSUnderlineStyle.single
            case .strikethrough:
                attributes[.strikethroughStyle] = NSUnderlineStyle.single
            default:
                break
            }
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
}
