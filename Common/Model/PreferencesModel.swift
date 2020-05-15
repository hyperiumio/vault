import Combine
import Foundation

class PreferencesModel: ObservableObject {
    
    @Published var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    private let context: PreferencesModelContext
    private var stateTransitionSubscription: AnyCancellable?
    
    init(context: PreferencesModelContext) {
        let loadingModel = context.loadingModel()
        
        self.state = .loading(loadingModel)
        self.context = context
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .loading(let model):
            stateTransitionSubscription = model.completion()
                .map { [context] preferences in
                    let model = context.loadedModel(initialValues: preferences)
                    return .loaded(model)
                }
                .assign(to: \.state, on: self)
        case .loaded:
            stateTransitionSubscription = nil
        }
    }
    
}

extension PreferencesModel {
    
    enum State {
        
        case loading(PreferencesLoadingModel)
        case loaded(PreferencesLoadedModel)
        
    }
    
}
