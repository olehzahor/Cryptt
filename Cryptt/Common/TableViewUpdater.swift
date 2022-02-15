import UIKit
typealias UpdateBlock = () -> Void

public enum TableViewUpdateType {
    case reloadData
    case insertRows(indexPaths: [IndexPath])
    case deleteRows(indexPaths: [IndexPath])
    case moveRow(indexPath: IndexPath, newIndexPath: IndexPath)
    case reloadRows(indexPaths: [IndexPath])
    case insertSection(indexSet: IndexSet)
    case deleteSection(indexSet: IndexSet)
    case moveSection(index: Int, newIndex: Int)
    case reloadSection(indexSet: IndexSet)
}

public final class TableUpdater {
    private let tableView: UITableView
    private var operationArray = [UpdateBlock]()
    
    public init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    public func update(actions: [TableViewUpdateType],
                       animationType: UITableView.RowAnimation = .automatic) {
        DispatchQueue.main.async { [weak self] in
            if animationType == .none {
                UIView.performWithoutAnimation {
                    self?.perform(actions: actions, animationType: animationType)
                }
            } else {
                self?.perform(actions: actions, animationType: animationType)
            }
        }
    }
    
    private func perform(actions: [TableViewUpdateType],
                         animationType: UITableView.RowAnimation = .automatic) {
        
        for action in actions {
            switch action {
            case .reloadData:
                reloadData()
                return
            case .insertRows(let indexPaths):
                insertRows(indexPaths, animationType: animationType)
            case .deleteRows(let indexPaths):
                deleteRows(indexPaths, animationType: animationType)
            case .moveRow(let indexPath, let newIndexPath):
                moveRows(indexPath, to: newIndexPath)
            case .reloadRows(let indexPaths):
                reloadRows(indexPaths, animationType: animationType)
            case .insertSection(let indexSet):
                insertSection(indexSet, animationType: animationType)
            case .deleteSection(let indexSet):
                deleteSection(indexSet, animationType: animationType)
            case .moveSection(let index, let newIndex):
                moveSection(index, to: newIndex)
            case .reloadSection(let indexSet):
                reloadSection(indexSet, animationType: animationType)
            }
        }
        endUpdates()
    }
    
    public func startUpdates() {
        
    }
    
    private func insertRows(_ indexPaths: [IndexPath], animationType: UITableView.RowAnimation) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.insertRows(at: indexPaths, with: animationType)
        }
    }
    
    private func deleteRows(_ indexPaths: [IndexPath], animationType: UITableView.RowAnimation) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.deleteRows(at: indexPaths, with: animationType)
        }
    }
    
    private func moveRows(_ indexPath: IndexPath, to newIndexPath: IndexPath) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
        }
    }
    
    private func reloadRows(_ indexPaths: [IndexPath], animationType: UITableView.RowAnimation) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: indexPaths, with: animationType)
        }
    }
    
    private func insertSection(_ index: IndexSet, animationType: UITableView.RowAnimation) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.insertSections(index, with: animationType)
        }
    }
    
    private func deleteSection(_ index: IndexSet, animationType: UITableView.RowAnimation) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.deleteSections(index, with: animationType)
        }
    }
    
    private func moveSection(_ index: Int, to newIndex: Int) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.moveSection(index, toSection: newIndex)
        }
    }
    
    private func reloadSection(_ index: IndexSet, animationType: UITableView.RowAnimation) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections(index, with: animationType)
        }
    }
    
    private func scrollToItem(at indexPath: IndexPath, at: UITableView.ScrollPosition, animated: Bool) {
        operationArray.append { [weak self] in
            guard let self = self else { return }
            self.tableView.scrollToRow(at: indexPath, at: at, animated: animated)
        }
    }
    
    private func endUpdates() {
        tableView.performBatchUpdates {
            operationArray.forEach { $0() }
            operationArray.removeAll()
        }
    }
    
    public func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.operationArray.removeAll()
            self?.tableView.reloadData()
        }
    }
}
