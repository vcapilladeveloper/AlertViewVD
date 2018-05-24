//
//  AlertViewVDView.swift
//  AlertViewVD
//
//  Created by Victor Capilla Borrego on 24/5/18.
//  Copyright © 2018 Victor Capilla Borrego. All rights reserved.
//

protocol AlertViewDelegate {
    func actionButton()
}

public class AlertViewVDView: UIView {
    
    var delegate: AlertViewDelegate?
    
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var firstSubtitle: UILabel!
    @IBOutlet weak var secondSubtitle: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var alertViewContainer: UIView!
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func pushBottomButton(_ sender: UIButton) {
        delegate?.actionButton()
    }
    
    let nibName = "AlertViewVDView"
    var contentView: UIView!
    
    public var buttonTitle: String {
        get {
            return bottomButton.titleLabel?.text ?? ""
        }
        
        set {
            bottomButton.setTitle(newValue, for: .normal)
        }
    }
    
    public var firstSuntitleText: String {
        get{
            return firstSubtitle.text ?? ""
        }
        set{
            firstSubtitle.isHidden = false
            firstSubtitle.text = newValue
        }
    }
    
    public var secondSuntitleText: String {
        get{
            return secondSubtitle.text ?? ""
        }
        set{
            secondSubtitle.isHidden = false
            secondSubtitle.text = newValue
        }
    }
    
    public var textForTitle: String {
        get{
            return title.text ?? ""
        }
        set{
            title.isHidden = false
            title.text = newValue
        }
    }
    
    public var closeImg: UIImage{
        get {
            return closeImage.image ?? UIImage()
        }
        
        set {
            closeImage.image = newValue
        }
    }
    
    public var centerImg: UIImage{
        get {
            return centerImage.image ?? UIImage()
        }
        
        set {
            centerImage.image = newValue
        }
    }
    
    // MARK: Set up View
    public override init(frame: CGRect) {
        // For use in cado
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        // Set variable contentView to be view isnide XIB file. For these, access to de Bundle for this framework (self), the NIB and finaly the view inside NIB.
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
        
        // Finally, set empty text into labels.
        title.text = ""
        firstSubtitle.text = ""
        secondSubtitle.text = ""
        roundCorner()
    }
    
    // Allow view to control itself
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        print("ROUNDED ")
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
}
