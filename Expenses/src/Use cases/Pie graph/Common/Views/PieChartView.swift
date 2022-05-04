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
            Text("\(presenter.title) Category Breakdown")
                .font(.system(size: 35))
                .fontWeight(.black)
                .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            ZStack {
                ForEach(presenter.sections) { section in
                    Arc(start: section.start, end: section.end)
                        .stroke(Color(section.color), lineWidth: 30)
                        .frame(width: 200, height: 200, alignment: .center)
                        .rotationEffect(.degrees(-90))
                }
                Arc(start: maskStartAngle, end: maskEndAngle, animatesEndAngle: false)
                    .stroke(Color.white, lineWidth: 40)
                    .frame(width: 200, height: 200, alignment: .center)
                    .rotationEffect(.degrees(-90))
                    .animation(Animation.easeOut(duration: 1.3))
            }
            Spacer()
        }
        .onAppear {
            Task {
                await presenter.onViewDidAppear()
            }
            
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    self.maskStartAngle = 360
                }
            }                       
        }
    }
}
