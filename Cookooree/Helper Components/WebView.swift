//
//  WebView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 12/16/20.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let req = URLRequest(url: url)
        
        webView.load(req)
        
        print("yo")
        print(url, req)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: URL(string: "https://unicorndreamfactory.com/cookooree/support/")!)
    }
}
