//
//  FoodPickerScreen.swift
//  FoodPicker
//
//  Created by ALPS on 2023/4/27.
//

import SwiftUI

/**
 是不是同一个view ？变形 ： 转场
 如何判断是否为同一个view：
 是否在结构位置上相同
 其次判断ID是不是一样
 
 转场                                       变形
 发生场景：A <->B、有画面 <-> 无画面                                          调整内容的改变、启动的内容改变
 默认动画：预设淡入淡出，可通过调整期修改                                   大部分和数字有关的调整器都可以流畅的变形。遇到不会的不一定
 */
//转场
/*
 if selectedFood != nil {
     Color.red
 } else {
     Color.yellow
 }
 */
//变形
//selectedFood != nil ? Color.red : Color.yellow

struct FoodPickerScreen: View {
    @State private var selectedFood: Food?
    //var selectedFood: String?  //无法修改
    @State private var shouldShowInfo: Bool = false
    
    let food = Food.examples
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView.init(showsIndicators:false) {
                VStack(spacing: 30) {
                    foodImage
                    
                    Text("今天吃什么?").bold()
                    
                    selectedFoodInfoView
                    
                    Spacer().layoutPriority(1)
                    
                    selectFoodButton
                    
                    cancelButton
                }
                .padding()
                .maxWidth()
                .frame(minHeight: proxy.size.height)
                .font(.title2.bold())
                .mainButtonStyle()
                .animation(.mySpring, value: shouldShowInfo)
                .animation(.myEase, value: selectedFood)
            }.background(.bg2)
        }
    }
}

// MARK: - SubViews
private extension FoodPickerScreen {
    var foodImage: some View {
        Group {
            if let selectedFood {
                Text(selectedFood.image)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            } else {
                Image("dinner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }.frame(height:250)
    }
    
    var foodNameView: some View {
        HStack {
            Text(selectedFood!.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
                .id(selectedFood!.name)
                .transition(.delayInsertionOpacity)
            Button {
                shouldShowInfo.toggle()
            } label: {
                SFSymbol.info.foregroundColor(.secondary)
            }.buttonStyle(.plain)
        }
    }
    
    var foodDetailView: some View {
        VStack {
            if shouldShowInfo {
                //方式一：
                /*
                HStack {
                    VStack(spacing:12) {
                        Text("蛋白质")
                        Text("\(selectedFood!.protein.formatted()) g")
                    }
                    
                    Divider().frame(width: 1).padding(.horizontal)
                    
                    VStack(spacing:12) {
                        Text("脂肪")
                        Text("\(selectedFood!.fat.formatted()) g")
                    }
                    
                    Divider().frame(width: 1).padding(.horizontal)
                    
                    VStack(spacing:12) {
                        Text("碳水")
                        Text("\(selectedFood!.carb.formatted()) g")
                    }
                }.font(.title3)
                    .padding(.horizontal)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.systemBackground)))
                */
                
                //方式二：
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        Text("蛋白质")
                        Text("脂肪")
                        Text("碳水")
                    }.frame(minWidth: 60)
                    
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                        .padding(.horizontal, -10)
                    
                    GridRow {
                        Text(selectedFood!.$protein.description)
                        Text(selectedFood!.$fat.description)
                        Text(selectedFood!.$carb.description)
                    }
                }
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .roundedRectBackground()
                .transition(.moveUpWithOpacity)
            }
        }
        .maxWidth()
        .clipped()
    }
    
    @ViewBuilder var selectedFoodInfoView: some View {
        if let selectedFood {
            foodNameView
            
            Text("热量 \(selectedFood.$calorie.description)").font(.title2)
            
            foodDetailView
        }
    }
    
    var selectFoodButton: some View {
        Button {
            selectedFood = food.shuffled().filter {$0 != selectedFood }.first
        } label: {
            Text(selectedFood == .none ? "告诉我" : "换一个").frame(width: 200)
                .animation(.none, value: selectedFood)
                .transformEffect(.identity)
        }.padding(.bottom, -15)//padding = 30 - 15
    }
    
    var cancelButton: some View {
        Button {
            selectedFood = nil
            shouldShowInfo = false
        } label: {
            Text("重置").frame(width: 200)
        }.buttonStyle(.bordered)
    }
}

extension FoodPickerScreen {
    init(selectedFood: Food) {
        _selectedFood = State(wrappedValue: selectedFood)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FoodPickerScreen(selectedFood: .examples.first!)
        FoodPickerScreen(selectedFood: .examples.first!).previewDevice(.iPad)
        FoodPickerScreen(selectedFood: .examples.first!).previewDevice(.iPhoneSE)
    }
}

