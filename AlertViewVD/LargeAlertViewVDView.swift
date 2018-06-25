//
//  LargeAlertViewVDView.swift
//  AlertViewVD
//
//  Created by Victor Capilla Borrego on 27/5/18.
//  Copyright © 2018 Victor Capilla Borrego. All rights reserved.
//

public class LargeAlertViewVDView: UIView {
    
    let nibName = "LargeAlertViewVDView"
    var contentView: UIView!
    var action: (()->Void)?
    var cancelAction: (()->Void)?
    
    @IBOutlet var middleImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var alertViewContainer: UIView!
    
    @IBAction func close(sender: UIButton) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alertViewContainer.frame.origin.y = self.contentView.frame.height
            self.contentView.alpha = 0.0
        }){ _ in
            if let action = self.cancelAction{
                action()
            }
            self.removeFromSuperview()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var closeImg: UIImageView!
    
    var tableViewElements: [TableViewElement]?
    
    public var centerImg: UIImage{
        get {
            return middleImage.image ?? UIImage()
        }
        set {
            middleImage.image = newValue
        }
    }
    
    public init(frame: CGRect, _ array: [TableViewElement]){
        super.init(frame: frame)
        tableViewElements = array
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        tableView.dataSource = self
        let bundle = Bundle(for: type(of: self))
        // Get the nib form bundle
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        // The view inside NIB
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        // Add contetView that we get from nib inside bundle, in this class View hierarchy
        contentView.bounds = self.bounds
        addSubview(contentView)
        
        // Set contetnView equal bounds of the parent view
        contentView.center = self.center
        // Tell that we don't aprove any resizing because view has specific size, passing an empty array.
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        closeImg.image = UIImage(named: "close_default", in: bundle, compatibleWith: nil)!
        roundCorner()
        tableView.reloadData()
    }
    
    public func roundCorner() {
        if #available(iOS 11.0, *) {
            alertViewContainer.layer.cornerRadius = CGFloat(10.0)
            alertViewContainer.clipsToBounds = true
            alertViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
            let path = UIBezierPath(roundedRect: alertViewContainer.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = alertViewContainer.bounds
            maskLayer.path = path.cgPath
            alertViewContainer.layer.mask = maskLayer
        }
    }
    
    // Allow view to control itself
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let originalY = alertViewContainer.frame.origin.y
        alertViewContainer.frame.origin.y = contentView.frame.height
        contentView.alpha = 0.0
        UIView.animate(withDuration: 0.35, animations: {
            self.alertViewContainer.frame.origin.y = originalY
            self.contentView.alpha = 1.0
        })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LargeAlertViewVDView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let elements = tableViewElements { return elements.count } else { return 0}
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let elements = tableViewElements {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCustomCell
            cell.setUp(elements[indexPath.row])
            return cell
            
        } else { return UITableViewCell() }
        
    }
    
}

public struct TableViewElement {
    var first: String = ""
    var second: String = ""
    var third: String = ""
    public init(_ first: String, _ second: String, _ third: String) {
        self.first = first
        self.second = second
        self.third = third
    }
    
}
