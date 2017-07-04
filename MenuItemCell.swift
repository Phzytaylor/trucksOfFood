//
//  menuItemCell.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/15/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import Foundation
import Eureka




// MARK: MenuItemCell

public protocol MenuItemCellConformance {

    var menuItemTextField: UITextField? { get }
    var priceTextField: UITextField? { get }


}


///Base class that implements the cell logic

open class _MenuItemCell<T: MenuItemType>: Cell<T>, CellType, MenuItemCellConformance, UITextFieldDelegate {

    @IBOutlet open var menuItemTextField: UITextField?
    @IBOutlet open var seperatorView: UIView?
    @IBOutlet open var priceTextField: UITextField?
    
    open var textFieldOrdering: [UITextField?] = []
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        textFieldOrdering = [menuItemTextField, priceTextField]
    
    
    }
    
    deinit {
    
    menuItemTextField?.delegate = nil
    menuItemTextField?.removeTarget(self, action: nil, for: .allEvents)
    priceTextField?.delegate = nil
    priceTextField?.removeTarget(self, action: nil, for: .allEvents)
    imageView?.removeObserver(self, forKeyPath: "image")
    
    }
    
    open override func setup() {
        super.setup()
        height = { 120 }
        selectionStyle = . none
        
        imageView?.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.old.union(.new), context: nil)
        
        for textField in textFieldOrdering {
        
            textField?.addTarget(self, action: #selector(MenuItemCell.textFieldDidChange(_:)), for: .editingChanged)
            
            textField?.textAlignment = .left
            textField?.clearButtonMode = .whileEditing
            textField?.delegate = self
            textField?.font = .preferredFont(forTextStyle: UIFontTextStyle.body)
            
        
        }
        seperatorView?.backgroundColor = .gray
        
    }
    open override func update() {
        super.update()
        detailTextLabel?.text = nil
        
        for textField in textFieldOrdering{
        
        textField?.isEnabled = !row.isDisabled
        textField?.textColor = row.isDisabled ? .gray: .black
        textField?.autocorrectionType = .no
        textField?.autocapitalizationType = .words
        
        }
        menuItemTextField?.text = row.value?.menuItem
        menuItemTextField?.keyboardType = .asciiCapable
        
        priceTextField?.text = row.value?.price
        priceTextField?.keyboardType = .numbersAndPunctuation
        
        
        if let rowConformance = row as? MenuItemRowConformance{
        
            setPlaceholderToTextField(textField: menuItemTextField, placeholder: rowConformance.menuItemPlaceholder)
            
            setPlaceholderToTextField(textField: priceTextField, placeholder: rowConformance.pricePlaceholder)
            
        }
    }
    
    private func setPlaceholderToTextField(textField: UITextField?, placeholder: String?){
    
        if let placeholder = placeholder, let textField = textField {
        
            if let color = (row as? MenuItemRowConformance)?.placeholderColor{
            
                textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: color])
            
            } else{
            
                textField.placeholder = placeholder
            
            }
        
        
        }
    
    
    }

    
    open override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && (
        
            menuItemTextField?.canBecomeFirstResponder == true ||
            priceTextField?.canBecomeFirstResponder == true
        )
    }
    
    open override func cellBecomeFirstResponder(withDirection direction: Direction) -> Bool {
        return direction == .down ? textFieldOrdering.first??.becomeFirstResponder() ?? false : textFieldOrdering.last??.becomeFirstResponder() ?? false
    }
    
    open override func cellResignFirstResponder() -> Bool {
        return menuItemTextField?.resignFirstResponder() ?? true
        && priceTextField?.resignFirstResponder() ?? true
    }
    
    override open var inputAccessoryView: UIView? {
    
        if let v = formViewController()?.inputAccessoryView(for: row) as? NavigationAccessoryView {
        
            guard let first = textFieldOrdering.first, let last = textFieldOrdering.last, first != last else {
                return v
            
            }
            
            if first?.isFirstResponder == true {
                v.nextButton.isEnabled = true
                v.nextButton.target = self
                v.nextButton.action = #selector(MenuItemCell.internalNavigationAction(_:))
            
            }
            else if last?.isFirstResponder == true {
            
                v.previousButton.target = self
                v.previousButton.action = #selector(MenuItemCell.internalNavigationAction(_:))
                v.previousButton.isEnabled = true
                
            
            }
            else{
                v.previousButton.target = self
                v.previousButton.action = #selector(MenuItemCell.internalNavigationAction(_:))
                v.nextButton.target = self
                v.nextButton.action = #selector(MenuItemCell.internalNavigationAction(_:))
                v.previousButton.isEnabled = true
                v.nextButton.isEnabled = true
            
            
            }
            return v
        
        
        }
        return super.inputAccessoryView
    
    }
    
    
    func internalNavigationAction(_ sender: UIBarButtonItem) {
        guard let inputAccesoryView  = inputAccessoryView as? NavigationAccessoryView else { return }
        
        var index = 0
        for field in textFieldOrdering {
            if field?.isFirstResponder == true {
                let _ = sender == inputAccesoryView.previousButton ? textFieldOrdering[index-1]?.becomeFirstResponder() : textFieldOrdering[index+1]?.becomeFirstResponder()
                break
            }
            index += 1
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let obj = object as AnyObject?
        
        if let keyPathValue = keyPath, let changeType = change?[NSKeyValueChangeKey.kindKey], (obj === imageView && keyPathValue == "image" ) && (changeType as? NSNumber)?.uintValue == NSKeyValueChange.setting.rawValue{
            
            setNeedsUpdateConstraints()
            updateFocusIfNeeded()
        
        
        }
    }
    
    open func textFieldDidChange(_ textField : UITextField){
    
        if row.baseValue == nil {
        
            row.baseValue = MenuItem()
        
        }
        
        guard let textValue = textField.text else {
        
            switch(textField){
            case let field where field == menuItemTextField:
                row.value?.menuItem = nil
            
            case let field where field == priceTextField:
                row.value?.price = nil
                
            default:
                break
            
            
            }
            return
        }
        
        if let rowConformance = row as? MenuItemRowConformance{
        
            var useFormatterDuringInput = false
            var valueFormatter: Formatter?
            
            switch(textField){
            case let field where field == menuItemTextField:
                useFormatterDuringInput = rowConformance.menuItemUseFormatterDuringInput
                valueFormatter = rowConformance.menuItemFormatter
            
            case let field where field == priceTextField:
                useFormatterDuringInput = rowConformance.priceUseFormatterDuringInput
                valueFormatter = rowConformance.priceFormatter
                
            default:
                break
            
            }
            
            if let formatter = valueFormatter, useFormatterDuringInput{
                let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.allocate(capacity: 1))
                let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?>? = nil
                if formatter.getObjectValue(value, for: textValue, errorDescription: errorDesc){
                
                    switch(textField){
                    
                    case let field where field == menuItemTextField:
                        row.value?.menuItem = value.pointee as? String
                        
                    case let field where field == priceTextField:
                        row.value?.price = value.pointee as? String
                    
                    default:
                        break
                        
                    }
                    
                    if var selStartPos = textField.selectedTextRange?.start {
                        let oldVal = textField.text
                        textField.text = row.displayValueFor?(row.value)
                        if let f = formatter as? FormatterProtocol {
                            selStartPos = f.getNewPosition(forPosition: selStartPos, inTextInput: textField, oldValue: oldVal, newValue: textField.text)
                        
                        }
                        textField.selectedTextRange = textField.textRange(from: selStartPos, to: selStartPos)
                    
                    
                    }
                        return
                }
            
            
            }
        
        }
    
        guard !textValue.isEmpty else {
            switch(textField){
            case let field where field == menuItemTextField:
                row.value?.menuItem = nil
            case let field where field == priceTextField:
                row.value?.price = nil
            default:
                break
            
            }
            return
        }
        
        switch (textField) {
        case let field where field == menuItemTextField:
            row.value?.menuItem = textValue
        case let field where field == priceTextField:
            row.value?.price = textValue
        default:
            break
        }
        
    }
    
    //MARK: TextFieldDelegate
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        formViewController()?.beginEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
        textFieldDidChange(textField)
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldReturn(textField, cell: self) ?? true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return formViewController()?.textInputShouldEndEditing(textField, cell: self) ?? true
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldBeginEditing(textField, cell: self) ?? true
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldClear(textField, cell: self) ?? true
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldEndEditing(textField, cell: self) ?? true
    }
    
}

///Concrete inplementation of generic _MenuItemCell with row value type MenuItem

public final class MenuItemCell: _MenuItemCell<MenuItem> {

    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }



}
