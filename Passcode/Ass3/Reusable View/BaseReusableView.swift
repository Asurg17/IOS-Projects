//
//  BaseReusableView.swift
//  Ass3
//
//  Created by Aleksandre Surguladze on 01.12.21.
//

import UIKit

class BaseReusableView: UIButton {
    
    @IBOutlet var contentView: UIView!
    
    var nibName: String {
        return String(describing: Self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: BaseReusableView.self)
        bundle.loadNibNamed(String(describing: Self.self ), owner: self, options: nil)
        
        guard let contentView = contentView else { fatalError("ContentView not set!") }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
    }

}

