//
//  ViewController.swift
//  ContactBook
//
//  Created by Aleksandre Surguladze on 11.01.22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var frc: NSFetchedResultsController<Contacts>!
    var dbContext = DBManager.shared.persistentContainer.viewContext
    
    var contactName: String?
    var contactNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchContacts()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(
            UINib(
                nibName: "ContactCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "ContactCell"
        )
        
        collectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress(guesture:))
            )
        )
    }
    
    func fetchContacts() {
        let request = Contacts.fetchRequest() as NSFetchRequest<Contacts>
        let sort = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sort]
        
        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dbContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            collectionView.reloadData()
        } catch {}
    }
    
    func addNewContact() {
        if checkIfValid() {
            let contact = Contacts(context: dbContext)
            contact.name = contactName
            contact.number = contactNumber
            
            do {
                try dbContext.save()
            } catch {}
        }
        
        clear()
    }
    
    func checkIfValid() -> Bool {
        if contactName == nil || contactName?.isEmpty == true {
            showWarningAlert(warningText: "Please enter Contact Name!")
            return false
        }
        
        if contactNumber == nil || contactNumber?.isEmpty == true {
            showWarningAlert(warningText: "Please enter Contact Number!")
            return false
        }
        
        return true
    }
    
    func showWarningAlert(warningText: String) {
        let alert = UIAlertController(
            title: "Warning",
            message: warningText,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: .default,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    func clear() {
        contactName = ""
        contactNumber = ""
    }
    
    @objc func handleLongPress(guesture: UILongPressGestureRecognizer) {
        if(guesture.state == .began) {
            let location = guesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                if let _ = collectionView.cellForItem(at: indexPath) {
                    if let contact = frc.fetchedObjects?[indexPath.row] {
                        let alert = UIAlertController(
                            title: "Delete contact?",
                            message: "Contact " + contact.name! + " will be deleted!",
                            preferredStyle: .alert
                        )
                        alert.addAction(
                            UIAlertAction(
                                title: "Delete",
                                style: .destructive,
                                handler: { [unowned self] _ in
                                    dbContext.delete(contact)
                                    do {
                                        try dbContext.save()
                                    } catch {}
                                }
                            )
                        )
                        alert.addAction(
                            UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil
                            )
                        )
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func addContact() {
        let alert = UIAlertController(
            title: "Add Contact",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: { [unowned self] textField in
            textField.placeholder = "Contact Name"
            textField.keyboardType = .default
            textField.addTarget(self, action: #selector(self.contactNameTextChanged(textField:)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { [unowned self] textField in
            textField.placeholder = "Contact Number"
            textField.keyboardType = .phonePad
            textField.addTarget(self, action: #selector(self.contactNumberTextChanged(textField:)), for: .editingChanged)
        })
        alert.addAction(
            UIAlertAction(
                title: "Save",
                style: .default,
                handler: { [unowned self] _ in
                    self.addNewContact()
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    @objc func contactNameTextChanged(textField: UITextField) {
        contactName = textField.text
    }
    
    @objc func contactNumberTextChanged(textField: UITextField) {
        contactNumber = textField.text
    }

}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frc.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath)
        if let contactCell = cell as? ContactCell {
            contactCell.configure(with: frc.fetchedObjects![indexPath.row])
        }
        cell.layoutIfNeeded()
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Constants.topBottomSpacing,
            left: Constants.spacing,
            bottom: Constants.topBottomSpacing,
            right: Constants.spacing
        )
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spareWidth = collectionView.frame.width - (2 * Constants.spacing) - ((Constants.itemCountInLine - 1) * Constants.spacing) - Constants.additionalSpacing
        let cellWidth = spareWidth / Constants.itemCountInLine
        let cellHeight = cellWidth * 1.30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.lineSpacing
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case.insert:
            fetchContacts()
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
    }
}

extension ViewController {
    
    struct Constants {
        static let itemCountInLine: CGFloat = 3
        static let spacing: CGFloat = 10
        static let lineSpacing: CGFloat = 20
        static let topBottomSpacing: CGFloat = 20
        static let additionalSpacing: CGFloat = 1 //10
    }
    
}

