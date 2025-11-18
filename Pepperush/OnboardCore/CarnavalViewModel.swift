import Foundation
import WebKit
import OneSignal
import SwiftUI

class CarnavalViewModel: ObservableObject {
    @AppStorage("erytygjvctryxycfg") var hoehy: Bool = true
    @Published var vwizmthx: Bool = false
    @AppStorage("werdfbdfsbdfb") var qyrfwcuvjkt: String = "ergeqgserg"
    @AppStorage("beubhjvdbfbjvd") var hwezi: URL!
    @Published var opjxdur: Bool = false
    
    @Published var tcw: String = "evsdfbdfb"
    @Published var fpjoumgbiw: WKWebView? = nil
    @Published var psayljeblh: URLRequest? = nil
    func hfyccvwpvsfok() {
        tin = false
    }
    @Published var heyguspipuz = UserDefaults.standard.bool(forKey: "eergdsgfg")
    @Published var fdrj: Bool = false
    @Published var tin: Bool = true
    
}

struct CarnavalVoler: View {
    
    enum CarnavalChip {
        case kzvr(WKNavigationAction,  (WKNavigationActionPolicy) -> Void)
        case uzipzmvugaij(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
        case rhdbzalbeez(WKNavigation)
        case pxwzaqbtdtr(WKNavigation)
        case iafcsgaj(WKNavigation)
        case tigw(WKNavigation)
        case snjjzhyhulcw(WKNavigation,Error)
        case jhmda(WKNavigation,Error)
    }
    
    init(url: URL, zcjuz: CarnavalViewModel) {
        self.init(uRLRequest: URLRequest(url: url),
                  zcjuz: zcjuz)
    }
    
    @ObservedObject var ekkmjcauady: CarnavalViewModel
    
    init(uRLRequest: URLRequest, zcjuz: CarnavalViewModel) {
        self.pinesqtpk = uRLRequest
        self.ekkmjcauady = zcjuz
        
    }
    
    private var navigationC: ((_ navigationAction: CarnavalVoler.CarnavalChip) -> Void)?
    let pinesqtpk: URLRequest
    var body: some View {
        ZStack{
            ViewPresent(hwgvfbdsfbvweghjb: ekkmjcauady,
                        action: navigationC,
                        request: pinesqtpk).zIndex(99)
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            
                            ekkmjcauady.fdrj = true
                            ekkmjcauady.fpjoumgbiw?.removeFromSuperview()
                            ekkmjcauady.fpjoumgbiw?.superview?.setNeedsLayout()
                            ekkmjcauady.fpjoumgbiw?.superview?.layoutIfNeeded()
                            ekkmjcauady.fpjoumgbiw = nil
                            ekkmjcauady.opjxdur = false
                        }) {
                            
                            Image(systemName: "chevron.backward.circle.fill").resizable().frame(width: 20, height: 20).foregroundColor(.white)
                            
                        }.padding(.leading, 20).padding(.top, 15)
                        Spacer()
                    }
                    Spacer()
                }
            }.ignoresSafeArea()
        }.statusBarHidden(true)
        
            .onAppear(){
                AppDelegate.shared = UIInterfaceOrientationMask.all
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
    }
}

struct ViewPresent : UIViewRepresentable {
    
    @ObservedObject var aiuvrutwew: CarnavalViewModel
    
    init(hwgvfbdsfbvweghjb: CarnavalViewModel,
         action: ((_ navigationAction: CarnavalVoler.CarnavalChip) -> Void)?,
         request: URLRequest) {
        self.action = action
        self.request = request
        self.aiuvrutwew = hwgvfbdsfbvweghjb
        self.mpenybjteckdg = WKWebView()
        self.mpenybjteckdg?.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.mpenybjteckdg?.scrollView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.mpenybjteckdg = WKWebView()
        self.mpenybjteckdg?.isOpaque = false
        viewDidLoad()
        
    }
    private var skwemzcwvhlmr: WKWebView?
    let action: ((_ navigationAction: CarnavalVoler.CarnavalChip) -> Void)?
    @State private var fqh: NSKeyValueObservation?
    @State var dxxjfxcc: UIColor!
    let request: URLRequest
    @State private var mpenybjteckdg: WKWebView?
    
    func viewDidLoad() {
        self.mpenybjteckdg?.backgroundColor = UIColor.black
        if #available(iOS 15.0, *) {
            fqh = mpenybjteckdg?.observe(\.themeColor) {  webView, _ in
                self.mpenybjteckdg?.backgroundColor = webView.themeColor ?? .systemBackground
            }
        } else {
            
        }
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        self.mpenybjteckdg = WKWebView()
        
        if uiView.canGoBack, aiuvrutwew.fdrj {
            uiView.goBack()
            aiuvrutwew.fdrj = false
            
        }
    }
    var yfavxcceqgcrzm: ((_ url: URL) -> Void)?
    
    final class CarnavalPolers: NSObject {
        var fsilfvcqsukar: WKWebView?
        var parent: ViewPresent
        var inavrrdoolbbt = 0
        var nmdvzfiroj = ""
        var gxldsjzfi: CarnavalViewModel
        let action: ((_ navigationAction: CarnavalVoler.CarnavalChip) -> Void)?
        init(parent: ViewPresent, action: ((_ navigationAction: CarnavalVoler.CarnavalChip) -> Void)?, zcjuz: CarnavalViewModel) {
            self.parent = parent
            self.action = action
            self.gxldsjzfi = zcjuz
            super.init()
        }
    }
}

extension ViewPresent.CarnavalPolers: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        gxldsjzfi.tin = false
        gxldsjzfi.vwizmthx = webView.canGoBack
        action?(.snjjzhyhulcw(navigation, error))
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        action?(.rhdbzalbeez(navigation))
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        action?(.iafcsgaj(navigation))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        gxldsjzfi.tin = false
        action?(.jhmda(navigation, error))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response as? HTTPURLResponse
        if let jeu = response?.allHeaderFields as? [String: Any] {
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if action == nil  {
            completionHandler(.performDefaultHandling, nil)
        } else {
            action?(.uzipzmvugaij(challenge, completionHandler))
        }
        
    }
    
    
    func webView(_ uyhdsfuygf: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let fapmpvq = "var allLinks = document.getElementsByTagName('a');if (allLinks) { var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target');if (target && target == '_blank') {link.setAttribute('target','_self');} } }"
        uyhdsfuygf.evaluateJavaScript(fapmpvq, completionHandler: nil)
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            uyhdsfuygf.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }
        
        if action == nil {
            decisionHandler(.allow)
        } else {
            action?(.kzvr(navigationAction, decisionHandler))
            
        }
        
        
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame != true {
            
            let fsilfvcqsukar = WKWebView(frame: webView.bounds, configuration: configuration)
            
            fsilfvcqsukar.navigationDelegate = self
            
            fsilfvcqsukar.uiDelegate = self
            
            webView.addSubview(fsilfvcqsukar)
            webView.setNeedsLayout()
            webView.layoutIfNeeded()
            
            gxldsjzfi.fpjoumgbiw = fsilfvcqsukar
            
            gxldsjzfi.opjxdur = true
            
            return fsilfvcqsukar
        }
        return fsilfvcqsukar
    }
    
    func webView(_ vgweubhdvhsdkv: WKWebView, didFinish navigation: WKNavigation!) {
        gxldsjzfi.tin = false
        
        gxldsjzfi.heyguspipuz = true
        UserDefaults.standard.set(gxldsjzfi.heyguspipuz, forKey: "eergdsgfg")
        
        vgweubhdvhsdkv.allowsBackForwardNavigationGestures = true
        gxldsjzfi.vwizmthx = vgweubhdvhsdkv.canGoBack
        if let title = vgweubhdvhsdkv.title {
            gxldsjzfi.tcw = title
        }
        
        vgweubhdvhsdkv.configuration.mediaTypesRequiringUserActionForPlayback = .all
        vgweubhdvhsdkv.configuration.allowsInlineMediaPlayback = false
        vgweubhdvhsdkv.configuration.allowsAirPlayForMediaPlayback = false
        action?(.tigw(navigation))
        
        guard let destinationUrl = vgweubhdvhsdkv.url?.absoluteURL.absoluteString else {
            
            return
        }
        
        var components = URLComponents(string: destinationUrl)!
        let ouctlgnmphsvr = components.url!.absoluteString
        
        if gxldsjzfi.qyrfwcuvjkt == "ergeqgserg" && self.gxldsjzfi.hoehy{
            self.gxldsjzfi.qyrfwcuvjkt = components.url!.absoluteString
            self.gxldsjzfi.hoehy = false
            self.gxldsjzfi.tin = false
        } else {}
    }
    func refreshCus(_ webView: WKWebView) {
        if webView == fsilfvcqsukar {
            fsilfvcqsukar?.removeFromSuperview()
            fsilfvcqsukar = nil
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        action?(.pxwzaqbtdtr(navigation))
        if let url = webView.url {
        }
    }
}
extension ViewPresent {
    func makeCoordinator() -> CarnavalPolers {
        return CarnavalPolers(parent: self, action: nil, zcjuz: self.aiuvrutwew)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        var view = WKWebView()
        let ubdgetu = WKPreferences()
        @ObservedObject var zcjuz: CarnavalViewModel
        ubdgetu.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences = ubdgetu
        configuration.applicationNameForUserAgent = "Version/17.2 Mobile/15E148 Safari/604.1"
        view = WKWebView(frame: .zero, configuration: configuration)
        view.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        view.navigationDelegate = context.coordinator
        view.uiDelegate = context.coordinator
        view.allowsBackForwardNavigationGestures = true
        view.load(request)
        return view
    }
}
