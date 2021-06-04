import Combine

class FlagController: ObservableObject {
    @Published var countries: [Country] = []
    
    init(using provider: FlagProvider) {
        self.countries = provider.all
    }
    
    func sort() {
        countries.sort()
    }
    
    func shuffle() {
        countries.shuffle()
    }
}
