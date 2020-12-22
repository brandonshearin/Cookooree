//
//  ExpandingTextView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 12/21/20.
//

import SwiftUI

struct ExpandingTextView: View {
    @Binding var text: String
    let minHeight: CGFloat = 150
    @State private var textViewHeight: CGFloat?

    var body: some View {
        ZStack{
            Color.blue
            WrappedTextView(text: $text, textDidChange: self.textDidChange)
                .frame(height: textViewHeight ?? minHeight)
        }
        
        
    }

    private func textDidChange(_ textView: UITextView) {
        self.textViewHeight = max(textView.contentSize.height, minHeight)
    }
}

struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    let textDidChange: (UITextView) -> Void

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void

        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}

struct ExpandingTextView_Previews: PreviewProvider {
    
    @State static var text = ""
    static var previews: some View {
        ExpandingTextView(text: $text)
    }
}
