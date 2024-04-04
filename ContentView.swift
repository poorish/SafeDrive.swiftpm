import SwiftUI

struct ContentView: View {
    var body: some View {
        DrivingView(systemImageName: "driving", title: "Welcome to SafeDrive!")
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .ignoresSafeArea(.all,edges: .top)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DrivingView: View {
    let systemImageName: String
    let title: String
    
    @State private var viewActive = false
    @State private var gasActive = false
    @State private var storyActive = false
    
    var body: some View {
        
        ZStack{
            GeometryReader{proxy in
                Image(systemImageName)
                    .resizable()
                    .frame(width: proxy.size.width,height: proxy.size.height*0.45)
            }
            VStack(alignment:.center,spacing: 20){
                Group{
                    Text(title)
                        .font(.title).bold()
                }
                
                Button("Start",systemImage: "eye"){
                    viewActive = true
                }
                .sheet(isPresented: $viewActive, content: {
                    HostedViewController()
                })
                .buttonStyle(GrowingButton())
                
                Button("Tips for stay awake",systemImage: "eyes"){
                    storyActive = true
                }
                .sheet(isPresented: $storyActive, content: {
                    StoryView()
                })
                .buttonStyle(GrowingButton())
                
                Button("Nearest Gas Station",systemImage: "location"){
                    gasActive = true
                }
                .sheet(isPresented: $gasActive){
                    if #available(iOS 16.0, *){
                        GasStationView()
                            .presentationDetents([.fraction(0.6)])
                    }else{
                        GasStationView()
                    }
                }
                .buttonStyle(GrowingButton())
                
            }
            .offset(y:150)
        }
        .ignoresSafeArea()
    }
}

