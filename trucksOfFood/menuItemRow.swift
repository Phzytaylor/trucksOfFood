//
//  menuItemRow.swift
//  
//
//  Created by Taylor Simpson on 6/15/17.
//
//

import Foundation
import Eureka

// MARK: Type

/**
 *  Protical to be implemented by menuItem types.
 */


public protocol MenuItemType: Equatable {

    var menuItem: String? { get set }
    var price: String? { get set }


}

public func == <T: MenuItemType>(lhs: T, rhs: T) -> Bool {

return lhs.menuItem == rhs.menuItem && lhs.price == rhs.price


}

//Row type for menuItemRow

public struct MenuItem: MenuItemType {

public var menuItem: String?
    
public var price: String?
    
    public init (){}
    
    public init(menuItem: String?, price: String?){
    
        self.menuItem = menuItem
        self.price = price
    
    }
    


}



public protocol MenuItemFormatterConformance: class {
    var menuItemUseFormatterDuringInput: Bool { get set }
    var menuItemFormatter: Formatter? { get set }
    
    var priceUseFormatterDuringInput: Bool { get set }
    var priceFormatter: Formatter? { get set }

}

public protocol MenuItemRowConformance: MenuItemFormatterConformance {

    var placeholderColor: UIColor? { get set }
    var menuItemPlaceholder: String? { get set }
    var pricePlaceholder: String? { get set }

}

// MARK: MenuItemRow

open class _MenuItemRow<Cell: CellType>: Row<Cell>, MenuItemRowConformance, KeyboardReturnHandler
    where Cell: BaseCell, Cell: MenuItemCellConformance {

    //Cofiguration for the keyboardReturnType of this row
    open var keyboardReturnType: KeyboardReturnTypeConfiguration?
    
    //The textColor for the textFields's placeholder
    open var placeholderColor: UIColor?
    
    ///The placeholder for the menuItem textField
    open var menuItemPlaceholder: String?
    
    //The placeholder for the price textField
    
    open var pricePlaceholder: String?
    
    /// A formatter to be uaed to format a user's input for the menuItem
    open var menuItemFormatter: Formatter?
    
    /// A formater to be used to format a user's input for the price
    
    open var priceFormatter: Formatter?
    
    /// If the formatter should be used while the user is editing the menuItem field
    
    open var menuItemUseFormatterDuringInput: Bool
    
    ///If the formatter should be used while the user is editing the price
    
    open var priceUseFormatterDuringInput: Bool
    
    public required init(tag: String?){
    
    menuItemUseFormatterDuringInput = false
    priceUseFormatterDuringInput = false
        
    super.init(tag: tag)
    
    
    
    }
    
  }

/// A MenuItem valued row where the user can enter a menuItem and a price

public final class MenuItemRow: _MenuItemRow<MenuItemCell>, RowType {
    public required init(tag: String? = nil) {
        super.init(tag: tag)
        // load correct bundle for cell nib file
        var bundle: Bundle
        if let bundleWithIdentifier = Bundle(identifier: "Taylor.trucksOfFood") {
            // Example or Carthage
            bundle = bundleWithIdentifier
        } else {
            // Cocoapods
            let podBundle = Bundle(for: MenuItemRow.self)
            let bundleURL = podBundle.url(forResource: "MenuItemRow", withExtension: "bundle")
            bundle = Bundle(url: bundleURL!)!
        }
        cellProvider = CellProvider<MenuItemCell>(nibName: "MenuItemCell", bundle: bundle)
    }
}
