import SwiftUI

extension View {
    func pressAnimation() -> some View {
        self.buttonStyle(PressableButtonStyle())
    }
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.windows.first?.windowScene as? UIWindowScene) {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        return .zero
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currencyString(_ value: Double, allowedDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = allowedDigits
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    var currencySymbol: String  {
        let locale = Locale.current
        return locale.currencySymbol ?? ""
    }
    
    func total(_ transactions: [Transaction], category: Category) -> Double {
        let filtered = transactions.filter({ $0.category == category.rawValue })
        let total = filtered.reduce(Double.zero) { partialResult, transaction in
            return partialResult + transaction.amount
        }
        return total
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .shadow(color: Constants.Colors.appTint, radius: configuration.isPressed ? 5 : 0)
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
        
    }
} 
