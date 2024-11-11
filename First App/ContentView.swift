import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var displayExpression = ""
    @State private var currentOperation: Operation?
    @State private var firstOperand: Double = 0
    @State private var isNewNumber = true

    enum Operation {
        case addition, subtraction, multiplication, division
    }

    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            // Display the current expression
            Text(displayExpression)
                .font(.headline)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .trailing)

            // Display area for current value or result
            Text(display)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 10)

            Spacer()

            // Buttons layout
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    CalculatorButton(label: "C", action: clear)
                    CalculatorButton(label: "+/-", action: toggleSign)
                    CalculatorButton(label: "%", action: percent)
                    CalculatorButton(label: "÷", action: { selectOperation(.division) })
                }

                HStack(spacing: 10) {
                    CalculatorButton(label: "7", action: { appendDigit("7") })
                    CalculatorButton(label: "8", action: { appendDigit("8") })
                    CalculatorButton(label: "9", action: { appendDigit("9") })
                    CalculatorButton(label: "×", action: { selectOperation(.multiplication) })
                }

                HStack(spacing: 10) {
                    CalculatorButton(label: "4", action: { appendDigit("4") })
                    CalculatorButton(label: "5", action: { appendDigit("5") })
                    CalculatorButton(label: "6", action: { appendDigit("6") })
                    CalculatorButton(label: "-", action: { selectOperation(.subtraction) })
                }

                HStack(spacing: 10) {
                    CalculatorButton(label: "1", action: { appendDigit("1") })
                    CalculatorButton(label: "2", action: { appendDigit("2") })
                    CalculatorButton(label: "3", action: { appendDigit("3") })
                    CalculatorButton(label: "+", action: { selectOperation(.addition) })
                }

                HStack(spacing: 10) {
                    CalculatorButton(label: "0", action: { appendDigit("0") })
                        .frame(maxWidth: .infinity)
                    CalculatorButton(label: ".", action: appendDecimal)
                    CalculatorButton(label: "=", action: calculateResult)
                }
            }
            .padding(10)
        }
    }

    // MARK: - Actions

    private func appendDigit(_ digit: String) {
        if isNewNumber {
            display = digit
            isNewNumber = false
        } else {
            display += digit
        }
        displayExpression += digit
    }

    private func appendDecimal() {
        if isNewNumber {
            display = "0."
            isNewNumber = false
            displayExpression += "0."
        } else if !display.contains(".") {
            display += "."
            displayExpression += "."
        }
    }

    private func clear() {
        display = "0"
        displayExpression = ""
        currentOperation = nil
        firstOperand = 0
        isNewNumber = true
    }

    private func toggleSign() {
        if let value = Double(display) {
            display = String(-value)
            displayExpression = display
        }
    }

    private func percent() {
        if let value = Double(display) {
            display = String(value / 100)
            displayExpression = display
            isNewNumber = true
        }
    }

    private func selectOperation(_ operation: Operation) {
        if let value = Double(display) {
            firstOperand = value
            currentOperation = operation
            isNewNumber = true
            displayExpression += operationSymbol(for: operation)
        }
    }

    private func calculateResult() {
        if let value = Double(display), let operation = currentOperation {
            var result: Double?
            
            switch operation {
            case .addition:
                result = firstOperand + value
            case .subtraction:
                result = firstOperand - value
            case .multiplication:
                result = firstOperand * value
            case .division:
                result = value != 0 ? firstOperand / value : nil
            }

            if let result = result {
                display = String(result)
                displayExpression += " = \(result)"
            } else {
                display = "Error"
                displayExpression = "Error"
            }
            currentOperation = nil
            isNewNumber = true
        }
    }

    private func operationSymbol(for operation: Operation) -> String {
        switch operation {
        case .addition: return " + "
        case .subtraction: return " - "
        case .multiplication: return " × "
        case .division: return " ÷ "
        }
    }
}

// MARK: - CalculatorButton View
struct CalculatorButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: 70)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
