//
//  SplashScreenView.swift
//  Sahaty
//
//  Created by mido mj on 2/22/25.
//


//
//  SplachScreenView.swift
//  SwiftfulSourseControl
//
//  Created by mido mj on 11/23/24.
//

import SwiftUI

struct SpdlashScreenView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var textTitle: String = "صحتي"
    let hapticFeedback = UINotificationFeedbackGenerator()


    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack(spacing: 20){
                // MARK: - HEADER
//                Spacer()
                VStack(spacing: 10){
                    Text(textTitle)
                    .font(.system(size: 55))
                    .fontWeight(.heavy)
                    .foregroundColor(.accent)
                    .transition(.opacity)
                    Text("تطبيق يوفر للأطباء والمرضى طريقة سهلة للتواصل وتحسين الرعاية الصحية")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -150)
                .animation(.easeIn(duration: 1), value: isAnimating)
                Spacer()
                // MARK: - CENTER
                ZStack{
                    CircleGroupView(ShapeColor: .accent, ShapeOpacity: 0.1)
                      .offset(x: imageOffset.width * -1)
                      .blur(radius: abs(imageOffset.width / 5))
                      .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("onboarding")
                      .resizable()
                      .scaledToFit()
                      .opacity(isAnimating ? 1 : 0)
                      .animation(.easeOut(duration: 0.5), value: isAnimating)
                      .offset(x: imageOffset.width * 1.2, y: 0)
                      .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                      .animation(.easeOut(duration: 1), value: imageOffset)


                }
                Spacer()
                
                // MARK: - FOOTER
                ZStack{
                    Button(action: {
                    }) {
                        Text("ابدأ")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 40,height: 40)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal, 40)
                }
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            }
 
        }
        .onAppear(perform: {
          isAnimating = true
        })
    }
}
#Preview {
    SpdlashScreenView()
}

struct CircleGroupView: View {
  // MARK: - PROPERTY
  
  @State var ShapeColor: Color
  @State var ShapeOpacity: Double
  @State private var isAnimating: Bool = false
  
  // MARK: - BODY
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(ShapeColor.opacity(ShapeOpacity), lineWidth: 40)
        .frame(width: 260, height: 260, alignment: .center)
      Circle()
        .stroke(ShapeColor.opacity(ShapeOpacity), lineWidth: 80)
        .frame(width: 260, height: 260, alignment: .center)
    } //: ZSTACK
    .blur(radius: isAnimating ? 0 : 10)
    .opacity(isAnimating ? 1 : 0)
    .scaleEffect(isAnimating ? 1 : 0.5)
    .animation(.easeOut(duration: 1), value: isAnimating)
    .onAppear(perform: {
      isAnimating = true
    })
  }
}
