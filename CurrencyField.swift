import SwiftUI

public struct CurrencyField: View {
    
    @Binding
    private var value: Double
    private let placeholder: String
    
    @State private var currencyText = ""
    @State private var currencyDouble = 0.0
    @FocusState var isFocused: Bool
    
    public init(value: Binding<Double>, placeholder: String) {
        _value = value
        self.placeholder = placeholder
    }
    
    var separator: String {
        return Locale.current.decimalSeparator ?? "."
    }
    public var body: some View {
        HStack {
            TextField("", text: $currencyText, prompt: Text(placeholder))
                .onChange(of: currencyText) { newValue in
                    guard isFocused else { return }
                    let correctedValue = newValue.asDecimal(to: 2, separator: separator)
                    guard let doubleValue = correctedValue.asDouble() else {
                        currencyText = decimalStringValue
                        return
                    }
                    value = doubleValue
                    currencyText = correctedValue
                }
                .focused($isFocused)
                .onChange(of: isFocused, perform: { focused in
                    if focused == true {
                        currencyText = decimalStringValue
                    } else {
                        currencyText = currencyValue
                    }
                })
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button {
                            isFocused = false
                        } label: {
                            Text("Done")
                                .foregroundColor(.accentColor)
                                .padding(.trailing)
                        }
                    }
                }
        }
    }
    
    private var currencyFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.isLenient = true
        nf.maximumFractionDigits = 2
        return nf
    }
    
    private var currencyValue: String {
        value != 0 ? currencyFormatter.string(from: value as NSNumber) ?? "" : ""
    }
    
    private var decimalStringFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.isLenient = true
        nf.maximumFractionDigits = 2
        return nf
    }
    
    private var decimalStringValue: String {
        value != 0 ? decimalStringFormatter.string(from: value as NSNumber) ?? "" : ""
    }
}

fileprivate extension String {
    /// Returns a string properly formated as a decmial numer to the indicated number of places.
    func asDecimal(to place: Int, separator: String) -> String {
        var filteredValue = self.filter{ "0123456789.,".contains($0) }
        let separatorCount = filteredValue.filter({ separator.contains($0) }).count
        if  separatorCount > 1 {
            filteredValue = String(filteredValue.dropLast(1))
        }
        if separatorCount > 0 {
            var filteredValueArray = Array(filteredValue)
            //Because a swift double uses "." as a separator, it must be converted here
            if let separatorIndex = filteredValueArray.firstIndex(of: Character(separator)) {
                filteredValueArray[separatorIndex] = "."
            }
            while filteredValueArray.firstIndex(of: ".") ?? filteredValueArray.count  < filteredValueArray.count - (1 + place) {
                filteredValueArray = filteredValueArray.dropLast()
            }
            filteredValue = filteredValueArray.map(String.init).joined()
            guard let _ = Double(filteredValue) else { return "" }
            if let separatorIndex = filteredValueArray.firstIndex(of: ".") {
                let characteristicArray = filteredValueArray[0...separatorIndex - 1]
                let characteristic = characteristicArray.map(String.init).joined()
                let mantissaArray = filteredValueArray[separatorIndex + 1..<filteredValueArray.count]
                let mantissa = mantissaArray.map(String.init).joined()
                return characteristic + separator + mantissa
            }
        }
        guard let _ = Double(filteredValue) else { return "" }
        return filteredValue
    }
    
    func asDouble() -> Double? {
        var filteredValue = self.filter{ "0123456789.,".contains($0) }
        if self.filter({ ",".contains($0) }).count == 0 {
            return Double(filteredValue)
        } else {
            let filteredValueArray = Array(filteredValue)
            if let separatorIndex = filteredValueArray.firstIndex(of: ",") {
                let characteristicArray = filteredValueArray[0...separatorIndex - 1]
                let characteristic = characteristicArray.map(String.init).joined()
                let mantissaArray = filteredValueArray[separatorIndex + 1..<filteredValueArray.count]
                let mantissa = mantissaArray.map(String.init).joined()
                filteredValue = characteristic + "." + mantissa
                return Double(filteredValue)
            }
        }
        return nil
    }
}

struct CurrencyFieldIntermediary: View {
    
    @State var value = 0.0
    var body: some View {
        HStack {
            Spacer()
            Text("Bill Amount")
                .font(.headline.weight(.bold))
            CurrencyField(value: $value, placeholder: "placeholder")
        }
    }
}

struct CurrencyField_Previews: PreviewProvider {
    
    static var previews: some View {
        CurrencyFieldIntermediary()
    }
}
