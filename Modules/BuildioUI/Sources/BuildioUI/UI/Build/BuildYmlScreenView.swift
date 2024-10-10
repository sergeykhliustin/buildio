//
//  BuildYmlScreenView.swift
//  
//
//  Created by Sergey Khliustin on 02.02.2022.
//

import SwiftUI
import BuildioLogic

struct BuildYmlScreenView: BaseView {
    @Environment(\.theme) private var theme
    @EnvironmentObject var model: BuildYmlViewModel
    
    @State private var window: UIWindow?
    
    var body: some View {
        RefreshableScrollView(refreshing: model.isScrollViewRefreshing) {
            VStack(alignment: .center, spacing: 8) {
                switch model.state {
                case .value:
                    TextElement(model.value!)
                case .error:
                    TextElement(model.errorString ?? "")
                default:
                    EmptyView()
                }
                
            }
            .font(.subheadline)
            .foregroundColor(theme.textColor)
            .padding(16)
        }
        .toolbar(content: {
            if let value = model.value {
                Button {
                    let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("bitrise_\(model.build.slug).yml"))
                    do {
                        try value.write(to: url, atomically: true, encoding: .utf8)
                        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        controller.popoverPresentationController?.sourceView = UIView()
                        UIApplication.shared.rootViewController?.present(controller, animated: true)
                    } catch {
                        logger.error(error)
                    }
                } label: {
                    Image(.square_and_arrow_up)
                }
            }

        })
        .withHostingWindow { window in
            self.window = window
        }
    }
}

extension UIApplication {
    var windowScene: UIWindowScene? {
        connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
    
    var rootViewController: UIViewController? {
        return windowScene?.windows.first?.rootViewController
    }
}
