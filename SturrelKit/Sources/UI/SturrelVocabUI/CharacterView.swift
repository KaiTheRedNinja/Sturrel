//
//  CharacterView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 27/11/23.
//

import SwiftUI
import WebKit

enum CharacterAction {
    case startCharAnimation
    case pauseCharAnimation
    case resumeAnimation
}

struct CharacterView: View {
    var text: String
    @State var size: CGSize = .zero
    @Binding var action: CharacterAction?

    init(_ text: String, action: Binding<CharacterAction?>? = nil) {
        self.text = text
        self._action = action ?? .constant(nil)
    }

    var body: some View {
        CharacterViewWrapper(text: text, size: $size, action: $action)
            .background {
                GeometryReader { (geom) -> Color in
                    DispatchQueue.main.async {
                        size = geom.size
                    }
                    return Color.clear
                }
            }
    }
}

private struct CharacterViewWrapper: UIViewRepresentable {
    typealias UIViewType = WKWebView

    var text: String

    @Binding var size: CGSize
    @Binding var action: CharacterAction?

    @State var loaded: Bool = false
    @State var currentSize: CGSize = .zero

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.loadHTMLString(
"""
<!DOCTYPE html>
<html>
<head>
    <title>Vocab</title>
</head>
<body>
    <div id="character-target-div"></div>
</body>
</html>
""",
            baseURL: nil
        )

        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard loaded else { return }

        // maybe todo: set the size if it changed

        // if state isnt nil, do it
        if let action = action {
            switch action {
            case .startCharAnimation:
                uiView.evaluateJavaScript("writer.animateCharacter()")
            case .pauseCharAnimation:
                uiView.evaluateJavaScript("writer.pauseAnimation()")
            case .resumeAnimation:
                uiView.evaluateJavaScript("writer.resumeAnimation()")
            }

            DispatchQueue.main.async {
                self.action = nil
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CharacterViewWrapper

        init(parent: CharacterViewWrapper) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let js = Bundle.main.url(forResource: "hanzi-writer", withExtension: "js"),
                  let data = try? Data(contentsOf: js),
                  let jsString = String(data: data, encoding: .utf8)
            else {
                fatalError("JS Not Found")
            }

            let size = parent.size
            let smaller = min(size.width, size.height)

            webView.evaluateJavaScript(jsString) { _, _ in
                webView.evaluateJavaScript(
"""
var writer = HanziWriter.create('character-target-div', '\(self.parent.text)', {
    width: \(Int(smaller*3.6)),
    height: \(Int(smaller*3.6)),
    padding: 5
});
"""
                )
            }
            parent.loaded = true
        }
    }
}

private struct CharacterPreview: View {
    @State var action: CharacterAction?

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(), count: 3)) {
                    ForEach(1..<13) { scale in
                        CharacterView("你", action: $action)
                            .frame(width: Double(scale*10), height: Double(scale*10))
                            .overlay {
                                Color.blue.opacity(0.1)
                            }
                    }
                }
            }

            HStack {
                Button {
                    action = .startCharAnimation
                } label: {
                    Image(systemName: "play")
                }

                Button {
                    action = .pauseCharAnimation
                } label: {
                    Image(systemName: "pause")
                }

                Button {
                    action = .resumeAnimation
                } label: {
                    Image(systemName: "circle")
                }
            }
            .font(.largeTitle)

            Text("Animation requires internet connection")
                .font(.subheadline)
                .foregroundStyle(Color.additional)
        }
    }
}

#Preview {
    CharacterPreview()
}
