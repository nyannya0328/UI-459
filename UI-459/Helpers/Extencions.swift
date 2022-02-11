//
//  Extencions.swift
//  UI-458
//
//  Created by nyannyan0328 on 2022/02/10.
//

import SwiftUI

extension View{
    
    
    func spotLight(enabled : Bool,text : String = "")->some View{
        
        return self
        
            .overlay {
                
                if enabled{
                    
                    
                    
                    GeometryReader{proxy in
                        
                        let rect = proxy.frame(in: .global)
                        
                        
                        spotLightView(title: text, rect: rect) {
                            
                            self
                            
                        }
                    }
                }
                
            }
         
        
        
        
    }
    
    
    
    func getScreenBounds()->CGRect{
        
        return UIScreen.main.bounds
    }
    func lLeading()->some View{
           
           self
               .frame(maxWidth:.infinity,alignment: .leading)
       }
       func lTreading()->some View{
           
           self
               .frame(maxWidth:.infinity,alignment: .trailing)
       }
       func lCenter()->some View{
           
           self
               .frame(maxWidth:.infinity,alignment: .center)
       }
       
       func maxHW()->some View{
           
           self
               .frame(maxWidth:.infinity,maxHeight: .infinity)
           
       
       }
    
    func getRootView()->UIViewController{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            
            return .init()
        }
        
        guard let rootView = screen.windows.first?.rootViewController else{
            
            return .init()
        }
        
        return rootView
    }

}
struct onBoard_extecions_Previews: PreviewProvider {
    static var previews: some View {
        onBoard()
    }
}

struct spotLightView<Content : View> : View{
    
    var content : Content
    
    var title : String
    
    var rect : CGRect
    
    init(title : String,rect : CGRect,@ViewBuilder content : @escaping()->Content) {
        self.content = content()
        self.title = title
        self.rect = rect
    }
    
    @State var tag : Int = 1009
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        Rectangle()
            .fill(.clear)
            .onAppear {
                
                
                addOvelayView()
            }
            .onDisappear {
                
                removeOvelary()
                
            }
        
        
        
        
        
    }
    
    func removeOvelary(){
        
        getRootView().view.subviews.forEach { view in
            
            if view.tag == self.tag{
                
                view.removeFromSuperview()
            }
        }
        
        
        
    }
    
    
    func addOvelayView(){
        
        
        
        let hosting = UIHostingController(rootView: ovelaySwiftUIView())
        hosting.view.frame = getScreenBounds()
        hosting.view.backgroundColor = .clear
        
        
        if self.tag == 1009{
            
            
            self.tag = generateRandom()
        }
        
        
        hosting.view.tag = self.tag
        
        getRootView().view.subviews.forEach { view in
            if view.tag == self.tag{
                
                return
            }
        }
        
        getRootView().view.addSubview(hosting.view)
        
    }
    
    
    @ViewBuilder
    func ovelaySwiftUIView() -> some View{
        
        
        
        ZStack{
            
            
            Rectangle()
                .fill(Color("Spotlight").opacity(scheme == .dark ? 0.8 : 0.5))
                .mask({
                    
                    let radi = (rect.height / rect.width) > 0.7 ? rect.width : 10
                    
                    Rectangle()
                        .overlay {
                            
                            content
                                .padding(5)
                                .background(.white,in: RoundedRectangle(cornerRadius: radi))
                                .frame(width: rect.width, height: rect.height)
                                .position()
                                .blendMode(.destinationOut)
                                .offset(x: rect.midX, y: rect.midY)
                                
                            
                        }
                    
                    
                })
            
            if title != ""{
                
                
                
                Text(title)
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
                    .position()
                    .offset(x: getScreenBounds().midX, y: rect.maxY > (getScreenBounds().height - 150) ? (rect.minY - 150) : (rect.minY + 150))
                    .padding()
                    .lineLimit(2)
            }
            
            
            
        }
     
            .maxHW()
            .ignoresSafeArea()
        
    }
    
    func generateRandom() -> Int{
        
        let random = Int(UUID().uuid.0)
        
        let subViews = getRootView().view.subviews
        
        
        for index in subViews.indices{
            
            
            if subViews[index].tag == random{
                
                
                return generateRandom()
            }
        }
        
        return random
        
    }
    
}


