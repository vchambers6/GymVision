//
//  GifImage.swift
//  GymVision
//
//  Created by Vanessa Chambers on 3/28/24.
//
// This was created following the video tutorial created by Pedro Rojas on 16/08/21, which can be found at this link: https://www.youtube.com/watch?v=9fz8EW-dX-I
// GitHub: https://github.com/pitt500/GifView-SwiftUI/blob/main/GifView_SwiftUI/GifView_SwiftUI/GifImage.swift

import SwiftUI
import WebKit
import SwiftGifOrigin

struct GifImageLoader: UIViewRepresentable {
    private var data: Data
    
    init(data: Data) {
        self.data = data
    }
    

    func makeUIView(context: Context) -> UIImageView {
        let image = UIImage.gif(data: self.data)!
        let imageView = UIImageView(image: image)
        return imageView
//        Image(uiImage:)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//        let webView = WKWebView()
////        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
////
////        let data = try! Data(contentsOf: url)
////
//
//        
//        webView.load(self.data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: URL(string: "about:blank")!)
//        
//        webView.layer.cornerRadius = cornerRadius
//        webView.layer.masksToBounds = true
//       
//        return webView
    }
    
    
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
//        uiView.reload()
    }
}

#Preview {
    GifImage("back_handspring_so_3")
}
