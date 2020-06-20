//
//  PieChartView.swift
//  Expensit
//
//  Created by Borja Arias Drake on 13/06/2020.
//  Copyright © 2020 Borja Arias Drake. All rights reserved.
//

import SwiftUI


struct PieChartView: View {
    
    @State private var maskStartAngle: Double = 0
    @State private var maskEndAngle: Double = 360
    @State private var isOn = false
    @Binding var isPresented: Bool    
    var presenter: PieChartPresenter    
    

    var body: some View {
        
        return VStack {
            Text("\(presenter.title) Breakdown").bold()
            Spacer()
            ZStack {
                ForEach(presenter.sections) { section in
                    Arc(start: section.start, end: section.end).stroke(Color(section.color), lineWidth: 30).frame(width: 200, height: 200, alignment: .center).rotationEffect(.degrees(-90))
                }
                Arc(start: maskStartAngle, end: maskEndAngle, animatesEndAngle: false).stroke(Color.white, lineWidth: 40).frame(width: 200, height: 200, alignment: .center).rotationEffect(.degrees(-90)).animation(Animation.easeOut(duration: 1.3))
            }
            Spacer()
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.maskStartAngle = 360
            }
        }
    }
}

//struct PieChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartView()
//    }
//}



//struct PieChartView: View {
//
//    @State private var startAngle1: Double = 0
//    @State private var endAngle1: Double = 0
//
//    @State private var startAngle2: Double = 45
//    @State private var endAngle2: Double = 45
//
//    @State private var startAngle3: Double = 95
//    @State private var endAngle3: Double = 95
//
//    @State private var isOn = false
//
//    var body: some View {
//
//        return VStack {
//            Spacer()
//            ZStack {
//                Arc(start: self.startAngle1, end: self.endAngle1).stroke(Color.pink, lineWidth: 30).frame(width: 200, height: 200, alignment: .center).rotationEffect(.degrees(-90)).animation(Animation.easeOut(duration: 0.3))
//                Arc(start: self.startAngle2, end: self.endAngle2).stroke(Color.yellow, lineWidth: 30).frame(width: 200, height: 200, alignment: .center).rotationEffect(.degrees(-90)).animation(Animation.easeOut(duration: 0.8).delay(0.3))
//                Arc(start: self.startAngle3, end: self.endAngle3).stroke(Color.orange, lineWidth: 30).frame(width: 200, height: 200, alignment: .center).rotationEffect(.degrees(-90)).animation(Animation.easeOut(duration: 1.2).delay(1.1))
////                Arc(start: 200, end: 360).stroke(Color.red, lineWidth: 30).frame(width: 200, height: 200, alignment: .center).rotationEffect(.degrees(-90)).animation(animation)
//            }
//            Spacer()
//            Button(action: {
//                self.isOn.toggle()
//                self.endAngle1 = self.isOn ? 45 : 0
//                self.endAngle2 = self.isOn ? 95 : 45
//                self.endAngle3 = self.isOn ? 360 : 95
//            }) {
//                Text("Click me")
//            }
//        }
//    }
//
//
//
//
//}
//
//struct PieChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartView()
//    }
//}
