//
//  ViewController.swift
//  Ass4
//
//  Created by Aleksandre Surguladze on 29.12.21.
//

import UIKit

class ContactSection {
    
    var id: String
    var header: ContactHeaderModel?
    var contacts = [ContactCellModel]()
    
    var numberOfRows: Int {
        return contacts.count
    }
      
    init(id: String, header: ContactHeaderModel?, contacts: [ContactCellModel]) {
        self.id = id
        self.header = header
        self.contacts = contacts
    }
    
}

class ViewController: UIViewController, ContactCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoritesButton: UIBarButtonItem!
    
    private var tableData = [ContactSection]()
    private var isFavorited = false;
    
    var firstNameText: String?
    var lastNameText: String?
    var phoneNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = true
        
        tableView.register(
            UINib(nibName: "ContactCell", bundle: nil),
            forCellReuseIdentifier: "ContactCell"
        )
        
        tableView.register(
            UINib(nibName: "ContactHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "ContactHeader"
        )
    }
    
    func delete(at indexPath: IndexPath) {
        if tableData[indexPath.section].contacts.count == 1 {
            
            tableData.remove(at: indexPath.section)
            
            tableView.beginUpdates()
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            tableView.endUpdates()
            
            if isFavorited {
                reloadTable()
            }
            
        } else {
            
            tableData[indexPath.section].contacts.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            if isFavorited {
                tableView.beginUpdates()
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                tableView.endUpdates()
            }
            
        }
    }
    
    func favoriteButtonDidClick(_ contact: ContactCell) {
        if isFavorited {
            reloadTable()
        }
    }
    
    func addNewContactToList() {
        var id = ""
        
        if let first = lastNameText?.first {
            id = String(first)
        } else {
            guard let first = firstNameText?.first else {
                showWarningAlert()
                return
            }
            id = String(first)
            lastNameText = firstNameText
            firstNameText = nil
        }
    
        if let sectionIndex = tableData.firstIndex(where: { $0.id == id }) {
            
            tableData[sectionIndex].contacts.append(
                ContactCellModel(
                    firstName: firstNameText ?? "",
                    lastName: lastNameText ?? "",
                    phoneNumber: phoneNumber ?? "no phone number",
                    isFavorite: false,
                    delegate: self
                )
            )
            
            tableData[sectionIndex].contacts.sort(by: { $0.lastName < $1.lastName })
            
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
            tableView.endUpdates()
            
        } else {
            
            let section = ContactSection(
                id: id,
                header: ContactHeaderModel(title: id),
                contacts: [
                    ContactCellModel(
                        firstName: firstNameText ?? "",
                        lastName: lastNameText ?? "",
                        phoneNumber: phoneNumber ?? "no phone number",
                        isFavorite: false,
                        delegate: self
                    )
                ]
            )
            
            tableData.append(section)
            
            tableView.beginUpdates()
            tableView.insertSections(IndexSet(integer: tableData.count-1), with: .automatic)
            tableView.endUpdates()
            
            tableData.sort(by: { $0.id < $1.id })
            reloadTable()
        
        }
        
        clearTexts()
    }
    
    func reloadTable() {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        
        tableView.beginUpdates()
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        tableView.endUpdates()
    }
    
    func showWarningAlert() {
        let alert = UIAlertController(
            title: "Warning",
            message: "First name or Last name must be filled!",
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
    
    func clearTexts() {
        firstNameText = nil
        lastNameText = nil
        phoneNumber = nil
    }
    
    @IBAction func showFavorites() {
        isFavorited.toggle()
        
        if isFavorited {
            favoritesButton.image = UIImage(systemName: "star.fill")
        } else {
            favoritesButton.image = UIImage(systemName: "star")
        }
        
        reloadTable()
    }
    
    @IBAction func addNewContact() {
        let alert = UIAlertController(
            title: "New contact",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: { [unowned self] textField in
            textField.placeholder = "First name"
            textField.keyboardType = .default
            textField.addTarget(self, action: #selector(self.firstNameTextChanged(textField:)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { [unowned self] textField in
            textField.placeholder = "Last name"
            textField.keyboardType = .default
            textField.addTarget(self, action: #selector(self.lastNameTextChanged(textField:)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { [unowned self] textField in
            textField.placeholder = "Phone number"
            textField.keyboardType = .phonePad
            textField.addTarget(self, action: #selector(self.phoneNumberChanged(textField:)), for: .editingChanged)
        })
        alert.addAction(
            UIAlertAction(
                title: "Save ",
                style: .default,
                handler: { [unowned self] _ in
                    self.addNewContactToList()
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
    
    @objc func firstNameTextChanged(textField: UITextField) {
        firstNameText = textField.text
    }
    
    @objc func lastNameTextChanged(textField: UITextField) {
        lastNameText = textField.text
    }
    
    @objc func phoneNumberChanged(textField: UITextField) {
        phoneNumber = textField.text
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerModel = tableData[section].header else { return nil}
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactHeader")
        
        if let contactHeader = header as? ContactHeader {
            contactHeader.configure(with: headerModel)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ContactCell",
            for: indexPath
        )
        
        if let contactCell = cell as? ContactCell {
            contactCell.configure(with: tableData[indexPath.section].contacts[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = [
            UIContextualAction(style: .destructive, title: "Delete ", handler: { _,_,_ in
                self.delete(at: indexPath)
            })
        ]
        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isFavorited {
            return tableData[indexPath.section].contacts[indexPath.row].height
        } else {
            if tableData[indexPath.section].contacts[indexPath.row].isFavorite == true {
                return tableData[indexPath.section].contacts[indexPath.row].height
            }
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isFavorited {
            return tableData[section].header == nil ? CGFloat.leastNormalMagnitude : 44
        } else {
            if let _ = tableData[section].contacts.firstIndex(where: { $0.isFavorite == true }) {
                return tableData[section].header == nil ? CGFloat.leastNormalMagnitude : 44
            }
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableData[indexPath.section].contacts[indexPath.row].isExpanded.toggle()
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
