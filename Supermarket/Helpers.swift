//
//  Helpers.swift
//  Supermarket
//
//  Created by Ilya Masalov on 02/07/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Bond
import ReactiveKit
import RealmSwift


protocol Editable {
    func setEditing(_ editing: Bool)
}

extension UIColor {
    
    static var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }
}

extension CaseIterable where Self: Equatable {
    
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

extension SkyFloatingLabelTextField: Editable {
    
    func setEditing(_ editing: Bool) {
        isUserInteractionEnabled = editing
        titleColor = editing ? .systemBlue : .black
        selectedTitleColor = editing ? .systemBlue : .black
    }
}

extension RealmCollectionChange where CollectionType: Swift.Collection, CollectionType.Index == Int {
    
    func toOrderedCollectionChangeset() throws -> OrderedCollectionChangeset<CollectionType> {
        switch self {
        case .initial(let collection):
            return OrderedCollectionChangeset(collection: collection, diff: OrderedCollectionDiff())
        case .update(let collection, let deletions, let insertions, let modifications):
            let diff = OrderedCollectionDiff(inserts: insertions, deletes: deletions, updates: modifications, moves: [])
            return OrderedCollectionChangeset(collection: collection, diff: diff)
        case .error(let error):
            throw error
        }
    }
}

extension Results {
    
    func toChangesetSignal() -> Signal<OrderedCollectionChangeset<Results<Element>>, NSError> {
        return Signal { observer in
            let token = self.observe { change in
                do {
                    observer.receive(try change.toOrderedCollectionChangeset())
                } catch {
                    observer.receive(completion: .failure(error as NSError))
                }
            }
            return BlockDisposable {
                token.invalidate()
            }
        }
    }
}

extension Results: QueryableSectionedDataSourceProtocol {
    
    public var numberOfSections: Int {
        return 1
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        return count
    }
    
    public func item(at indexPath: IndexPath) -> Element {
        return self[indexPath.row]
    }
}
