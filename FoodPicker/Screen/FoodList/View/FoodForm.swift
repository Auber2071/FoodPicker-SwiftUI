//
//  FoodForm.swift
//  FoodPicker
//
//  Created by ALPS on 2023/4/29.
//

import SwiftUI

extension FoodListScreen {
    struct FoodForm: View {
        @Environment(\.dismiss) var dismiss
        @FocusState private var field: MyField?
        @State var food: Food
        var onSubmit: (Food) -> Void
        
        private var isNotValid: Bool {
            food.name.isEmpty || food.image.count > 2
        }
        
        private var invalildMessage: String? {
            if food.name.isEmpty { return "请输入名称"}
            if food.image.count > 2 { return "图片字符过多"}
            return .none
        }
        
        var body: some View {
            NavigationStack {
                VStack {
                    titleBar
                     
                    formView
                    
                    saveButton
                    
                }
                .background(.groupBg)
                .multilineTextAlignment(.trailing)
                .font(.title3)
                .scrollDismissesKeyboard(.interactively)
                .toolbar(content: buildKeyboardTools)
            }
        }
    }
}

// MARK: Subviews
private extension FoodListScreen.FoodForm {
    var titleBar: some View {
        HStack {
            Label("编辑食物资料", systemImage: .pencil)
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .push(to: .leading)
            
            Image(systemName: "xmark.circle.fill")
                .font(.largeTitle.bold())
                .foregroundColor(.secondary)
                .onTapGesture {
                    dismiss()
                }
            
        }.padding([.horizontal, .top])
    }
    
    var formView: some View {
        Form {
            LabeledContent("名称") {
                TextField("必填", text: $food.name)
                    .focused($field, equals: .title)
            }
            
            LabeledContent("图片") {
                TextField("最多输入 2 个字符", text: $food.image)
                    .focused($field, equals: .image)
            }
            
            buildNumberField(title: "热量", value: $food.$calorie, field: .calories)
            buildNumberField(title: "蛋白质", value: $food.$protein, field: .protein)
            buildNumberField(title: "脂肪", value: $food.$fat, field: .fat)
            buildNumberField(title: "碳水", value: $food.$carb, field: .carb)
        }.padding(.top, -16)
    }
    
    var saveButton: some View {
        Button {
            dismiss()
            onSubmit(food)
        } label: {
            Text(invalildMessage ?? "保存")
                .bold()
                .maxWidth()
        }
        .mainButtonStyle()
        .padding()
        .disabled(isNotValid)
    }
    
    func buildNumberField<Unit: MyUnitProtocol & Hashable>(title: String, value: Binding<Suffix<Unit>>, field: MyField) -> some View {
        LabeledContent(title) {
            HStack {
                TextField("", value: Binding(
                    get: { value.wrappedValue.wrappedValue },
                    set: { value.wrappedValue.wrappedValue = $0 }
                    
                ), format: .number.precision(.fractionLength(1)))
                    .focused($field, equals: field)
                    .keyboardType(.numbersAndPunctuation)
                
                if Unit.allCases.count <= 1 {
                    value.unit.wrappedValue.font(.body)
                    
                } else {
                    Picker("单位", selection: value.unit) {
                        ForEach(Unit.allCases) { $0 }
                    }.labelsHidden()
                }
                
            }
            
        }
    }
    
    func buildKeyboardTools() -> some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(action:goPreviousField) { SFSymbol.chevronUp }
            Button(action:goNextField) { SFSymbol.chevronDown }
        }
    }
}

// MARK: Focus Handling
private extension FoodListScreen.FoodForm {
    func goPreviousField() {
        guard let rawValue = field?.rawValue else { return }
        field = .init(rawValue: rawValue - 1)
    }
    
    func goNextField() {
        guard let rawValue = field?.rawValue else { return }
        field = .init(rawValue: rawValue + 1)
    }

}


private enum MyField: Int {
    case title, image, calories, protein, fat, carb
}

private extension TextField where Label == Text {
    func focused(_ field: FocusState<MyField?>.Binding, equals this: MyField) -> some View {
        submitLabel(this == .carb ? .done : .next)
            .focused(field, equals: this)
            .onSubmit {
                field.wrappedValue = .init(rawValue: this.rawValue + 1)
            }
    }
        
}

// MARK: Preview
struct FoodForm_Previews: PreviewProvider {
    static var previews: some View {
        FoodListScreen.FoodForm(food: Food.examples.first!) { _ in
            
        }
    }
}
