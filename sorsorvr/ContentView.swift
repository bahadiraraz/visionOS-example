import SwiftUI
import RealityKit
import RealityKitContent

struct CalculatorView: View {
    
    @State private var input: String = ""
    @State private var result: String = ""
    @State private var history: [String] = []
    
    var body: some View {
         VStack {
             HStack {
                 VStack {
                     Text("VisionOS Hesap Makinesi").font(.title)
                                         .padding(.vertical, 50)
                     TextField("Sayı girin", text: $input)
                         .padding()
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     
                     ForEach(1...3, id: \.self) { row in
                         HStack {
                             ForEach(1...3, id: \.self) { column in
                                 let number = (row - 1) * 3 + column
                                 Button(action: { appendCharacter("\(number)") }) {
                                     Text("\(number)")
                                 }
                                 .padding()
                             }
                         }
                     }
                     
               
                     HStack {
                         Button(action: { appendCharacter("+") }) { Text("+") }.padding()
                         Button(action: { appendCharacter("-") }) { Text("-") }.padding()
                         Button(action: { appendCharacter("*") }) { Text("*") }.padding()
                         Button(action: { appendCharacter("/") }) { Text("/") }.padding()
                         Button(action: { deleteLastCharacter() }) { Text("Sil") }.padding()
                         Button(action: { calculate() }) { Text("=") }.padding()
                     }
                     
                     Text("Sonuç: \(result)")
                         .padding()
                 }
                 .padding()
                 
                 VStack {
                     List(history, id: \.self) { item in
                         Text(item)
                     }
                     .frame(width: 150)
                     
                     Spacer()
                     
                     Text("Bahadir Araz")
                         .font(.footnote)
                         .padding(.bottom)
                 }
             }
         }
         .padding(.top)
         .edgesIgnoringSafeArea(.top)
     }
    
    func appendCharacter(_ character: String) {
        input.append(character)
        history.append(input)
    }
    
    func deleteLastCharacter() {
        guard !input.isEmpty else { return }
        input.removeLast()
        history.append(input)
    }
    
    func calculate() {
        guard let calculationResult = evaluateExpression(input) else {
            result = "Hata"
            return
        }
        result = "\(calculationResult)"
        history.append("\(input) = \(result)")
        input = ""
    }
    
    func evaluateExpression(_ expression: String) -> Double? {
        let expression = NSExpression(format: expression)
        guard let result = expression.expressionValue(with: nil, context: nil) as? Double else {
            return nil
        }
        return result
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            CalculatorView()
        }
        .navigationTitle("main")
        .padding(0)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
