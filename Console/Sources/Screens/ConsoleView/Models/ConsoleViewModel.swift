//
//  ConsoleViewModel.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import Combine
import Foundation
import MultipartKit
import OrderedCollections

class MarkerToggleViewModel: ObservableObject, Identifiable, Hashable {
    static func == (lhs: MarkerToggleViewModel, rhs: MarkerToggleViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum Kind {
        case all
        case custom
    }
    
    var id: String
    var kind: Kind
    var isOn: Bool
    
    init(id: String, kind: Kind = .custom, isOn: Bool) {
        self.id = id
        self.kind = kind
        self.isOn = isOn
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ConsoleViewModel: ObservableObject {
    private var allItems: [ConsoleViewItem]
    @Published var searchText: String
    @Published var markerToggleViewModels: OrderedSet<MarkerToggleViewModel>
    @Published var shouldShowMarkers: Bool
    @Published var items: [ConsoleViewItem]
    @Published var logLevelFilters: [LogLevelFilterToggleViewModel]
    var subscriptions: [Cancellable] = []
    
    init() {
        self.searchText = ""
        self.markerToggleViewModels = [
            .init(id: "All Markers", kind: .all, isOn: true)
        ]
        self.shouldShowMarkers = false
        self.items = []
        self.allItems = []
        self.logLevelFilters = [
            LogLevelFilterToggleViewModel(id: .all, title: "All", isOn: true),
            LogLevelFilterToggleViewModel(id: .debug, title: "Debug", isOn: true),
            LogLevelFilterToggleViewModel(id: .info, title: "Info", isOn: true),
            LogLevelFilterToggleViewModel(id: .warning, title: "Warning", isOn: true),
            LogLevelFilterToggleViewModel(id: .error, title: "Error", isOn: true)
        ]
        
        let eventMessageSubscription = Server.shared.eventMessages.sink { [weak self] eventMessage in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.objectWillChange.send()
                let newItem = ConsoleViewItem(title: eventMessage.message,
                                              message: eventMessage.json.map({ JsonItemViewModel(json: $0) }),
                                              markers: eventMessage.marker,
                                              logLevel: .init(logLevel: eventMessage.level),
                                              isExpanded: true)
                let isAllMarkersEnabled: Bool = self.markerToggleViewModels[0].isOn
                let newMarkers = newItem.markers.map { MarkerToggleViewModel(id: $0, kind: .custom, isOn: isAllMarkersEnabled) }
                self.markerToggleViewModels.append(contentsOf: newMarkers)
                
                self.allItems.append(newItem)
                if self.shouldShow(item: newItem) {
                    self.items.append(newItem)
                }
            }
        }
        subscriptions.append(eventMessageSubscription)
        
        let searchTextSubscription = $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.items = self.allItems.filter(self.shouldShow)
            })
        subscriptions.append(searchTextSubscription)
    }
    
    func updateButtonState(shouldShowMarkers: Bool) {
        self.shouldShowMarkers = shouldShowMarkers
    }
    
    func updateMarkerSelection(id: MarkerToggleViewModel.ID, value: Bool) {
        guard let state = markerToggleViewModels.first(where: { $0.id == id }) else {
            return
        }
        
        objectWillChange.send()
        switch state.kind {
        case .all:
            markerToggleViewModels.forEach({ $0.isOn = value })
        case .custom:
            state.isOn = value
            markerToggleViewModels[0].isOn = markerToggleViewModels.filter({ $0.kind == .custom }).allSatisfy({ $0.isOn })
        }
        
        items = allItems.filter(shouldShow)
    }
    
    func updateLogLevelSelection(id: LogLevelFilterToggleViewModel.ID, value: Bool) {
        guard let state = logLevelFilters.first(where: { $0.id == id }) else {
            return
        }
        
        objectWillChange.send()
        switch state.id {
        case .all:
            logLevelFilters.forEach({ $0.isOn = value })
        default:
            state.isOn = value
            logLevelFilters[0].isOn = logLevelFilters.filter({ $0.id != .all }).allSatisfy({ $0.isOn })
        }
        
        items = allItems.filter(shouldShow)
    }
    
    func trashButtonPressed() {
        objectWillChange.send()
        items.removeAll()
        allItems.removeAll()
        shouldShowMarkers = false
        markerToggleViewModels = [markerToggleViewModels[0]]
    }
    
    func collapseItem(id: UUID) {
        guard let item = items.first(where: { $0.id == id }) else {
            return
        }
        
        objectWillChange.send()
        item.isExpanded.toggle()
    }
    
    func collapseJsonContainer(itemID: UUID, collpaseItemID: UUID) {
        guard let item = items.first(where: { $0.id == itemID }),
              let collapseItem = item.collapseItems.first(where: { $0.id == collpaseItemID }),
              let source = collapseItem.source
        else { return }
        
        objectWillChange.send()
        source.isExpanded.toggle()
        item.recalculateJson()
    }

    // MARK: - Helpers
    private func shouldShow(item: ConsoleViewItem) -> Bool {
        // contains search???
        if !searchText.isEmpty {
            let containsTitle = item.title.contains(searchText)
            let containsMessage = false
            if !(containsTitle || containsMessage) {
                return false
            }
        }
        
        let selectedMarkers = markerToggleViewModels.filter({ $0.isOn }).map({ $0.id })
        if !selectedMarkers.contains(where: { item.markers.contains($0) }) {
            return false
        }
        
        let selectedLevels = logLevelFilters.filter({ $0.isOn }).map({ $0.id })
        if !selectedLevels.contains(item.logLevel) {
            return false
        }
        
        return true
    }
}

