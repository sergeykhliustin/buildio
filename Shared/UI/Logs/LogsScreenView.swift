//
//  LogsScreenView.swift
//  Buildio
//
//  Created by severehed on 01.11.2021.
//

import SwiftUI
import Models
import Rainbow

@available(iOS 15, *)
private extension Rainbow.Segment {
    var attributedString: AttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let background = self.backgroundColor, let color = Color.color(for: background) {
            attributes[.backgroundColor] = UIColor(color)
        }
        if let foreground = self.color, let color = Color.color(for: foreground) {
            attributes[.foregroundColor] = UIColor(color)
        } else {
            attributes[.foregroundColor] = UIColor.white
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
        let attributeContainer = AttributeContainer(attributes)
        return AttributedString(self.text, attributes: attributeContainer)
    }
}

struct LogsScreenView: BaseView {
    @StateObject var model: LogsViewModel
    @Namespace var bottomID
    
    init(build: V0BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: LogsViewModel(build: build))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if case .loading = model.state {
                ProgressView().padding(16)
            }
            if let value = model.value {
                ScrollViewReader { reader in
                    ScrollView {
                        ForEach(0..<value.logChunks.count) { index in
                            buildTextViews(value.logChunks[index].chunk)
                                .padding(.horizontal, 8)
                        }
                        EmptyView().id(bottomID)
                    }
                    .font(.footnote)
                    .onChange(of: value.logChunks.count, perform: { newValue in
                        reader.scrollTo(bottomID)
                    })
                }
            }
        }
        .navigationTitle("Build #\(String(model.build.buildNumber)) logs")
    }
    
    @ViewBuilder
    private func buildTextViews(_ chunk: String) -> some View {
        let terminal = Rainbow.extractEntry(for: chunk)
        Group {
            if #available(iOS 15, *) {
                Text(attributedString(for: terminal.segments))
                    .padding([.horizontal], 8)
            } else {
                Text(terminal.segments.map({ $0.text }).joined())
                    .background(Color.black)
                    .foregroundColor(.white)
                    .padding(8)
            }
//            ForEach(0..<terminal.segments.count) { index in
//                buildTextView(terminal.segments[index])
//                    .padding(8)
//            }
        }
        .background(Color.black)
        .cornerRadius(4)
    }
    
    @available(iOS 15, *)
    private func attributedString(for segments: [Rainbow.Segment]) -> AttributedString {
        return segments.reduce(AttributedString()) { partialResult, segment in
            var result = partialResult
            result.append(segment.attributedString)
            return result
        }
    }
    
    @ViewBuilder
    private func buildTextView(_ segment: Rainbow.Segment) -> some View {
        var view = Text(segment.text)
        if let background = segment.backgroundColor, let color = Color.color(for: background) {
            view = view.background(color) as! Text
        }
        if let foreground = segment.color, let color = Color.color(for: foreground) {
            view = view.foregroundColor(color)
        } else {
            view = view.foregroundColor(.white)
        }
        if let styles = segment.styles {
//            for style in styles {
//                switch style {
//                case .bold:
//                    view = view.font(.bold)
//                case .dim:
//                    <#code#>
//                case .italic:
//                    <#code#>
//                case .underline:
//                    <#code#>
//                case .blink:
//                    <#code#>
//                case .swap:
//                    <#code#>
//                case .strikethrough:
//                    <#code#>
//                case .default:
//                    break
//                }
//
//            }
        }
        return view
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: V0BuildResponseItemModel.preview())
    }
}
