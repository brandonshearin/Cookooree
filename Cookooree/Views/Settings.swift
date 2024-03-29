//
//  Settings.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/20/20.
//

import SwiftUI

struct link: Hashable, Identifiable {
    var id: String
    var title: String
    var link: String
}

struct Settings: View {
    
    let links = [link(id: "1", title: "Send feedback", link: "https://unicorndreamfactory.com/cookooree/support/"),
                 link(id: "2", title: "Help", link: "https://unicorndreamfactory.com/cookooree/help/"),
                 link(id: "3", title: "Privacy Policy", link: "https://unicorndreamfactory.com/cookooree/privacy/"),
                 link(id: "4", title: "Terms of Use", link: "https://unicorndreamfactory.com/cookooree/terms/")]
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var screenOn: Bool
    
    @State private var showWebView = false
    @State private var destination: link?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.custom("Barlow",
                                  size: 24,
                                  relativeTo: .largeTitle))
                    .padding(.horizontal)
                Toggle("Keep screen on",
                       isOn: $screenOn.onChange {
                        UIApplication.shared.isIdleTimerDisabled = screenOn
                       })
                    .padding()
                Divider()
                
                ForEach(links, id: \.self) { link in
                    LinkView(l: link)
                        .onTapGesture {
                            showWebView.toggle()
                            destination = link
                        }
                }
                
                Text("Cookooree v1.0.0")
                    .padding()
                    .foregroundColor(Color(.secondaryLabel))
                Divider()
                
                Spacer()
                
            }
            .sheet(item: $destination){ dest in
                NavigationView {
                    WebView(url: URL(string: dest.link)!)
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarItems(trailing: closeBtn(action: {
                            self.destination = nil
                        }))
                }
            }
            .padding()
            .navigationBarItems(trailing:
                                    closeBtn(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }))
        }
    }
}

struct Settings_Previews: PreviewProvider {
    @State static var screenOn = false
    static var previews: some View {
        NavigationView{
            Settings(screenOn: $screenOn)
        }
        
    }
}

struct LinkView: View {
    
    var l: link
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(l.title)
                .foregroundColor(Color(.systemBlue))
                .padding()
            Divider()
        }
        .contentShape(Rectangle())
    }
}

struct closeBtn: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Image(systemName: "multiply.circle.fill")
                .imageScale(.large)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}


