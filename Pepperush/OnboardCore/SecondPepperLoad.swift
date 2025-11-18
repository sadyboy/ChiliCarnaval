import Foundation
import SwiftUI
import WebKit

class CarnavalOtherClass {
    var cvxuoztq: String?
    static let shared = CarnavalOtherClass()
    var zzrqhr: String?
    var vdhhf: String?
}
struct SecondPepperLoad: View {
    @ObservedObject var tvbabssffav: CarnavalViewModel = CarnavalViewModel()
    @State var tdzgjikvnzfucc: Bool = true
    var body: some View {
        ZStack{
            Image(.backMain).resizable()
                .edgesIgnoringSafeArea(.all)
            
            if let url = URL(string: CarnavalOtherClass.shared.vdhhf ?? "") {
                CustomLoading(jfbbzp: $tdzgjikvnzfucc) {
                    CarnavalVoler(url: url, zcjuz: tvbabssffav)
                        .background(Color.black.ignoresSafeArea())
                        .edgesIgnoringSafeArea(.bottom)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                                tdzgjikvnzfucc = false
                            }
                        }
                }
            } else {
                ZStack{
                    CustomLoading(jfbbzp: $tdzgjikvnzfucc) {
                        CarnavalVoler(url:  URL(string: tvbabssffav.qyrfwcuvjkt)!, zcjuz: tvbabssffav) .background(Color.black.ignoresSafeArea()).edgesIgnoringSafeArea(.bottom).onAppear{
                        }
                    }
                }.onAppear{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                        tdzgjikvnzfucc = false
                    }
                }
            }
        }
    }
}
