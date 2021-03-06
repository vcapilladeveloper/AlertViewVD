//
//  AlertViewVDView.swift
//  AlertViewVD
//
//  Created by Victor Capilla Borrego on 24/5/18.
//  Copyright © 2018 Victor Capilla Borrego. All rights reserved.
//

public class AlertViewVDView: UIView {
    
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var firstSubtitle: UILabel!
    @IBOutlet weak var secondSubtitle: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var alertViewContainer: UIView!
    
    @IBAction func dismissView(_ sender: UIButton) {
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
    
    @IBAction func pushBottomButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alertViewContainer.frame.origin.y = self.contentView.frame.height
            self.contentView.alpha = 0.0
        }){ _ in
            if let action = self.okAction{
                action()
            }
            self.removeFromSuperview()
        }
    }
    
    let nibName = "AlertViewVDView"
    var contentView: UIView!
    
    var action: (()->Void)?
    var okAction: (()->Void)?
    var cancelAction: (()->Void)?
    
    public var titleColor: UIColor {
        get{
            return title.textColor
        }
        set{
            title.textColor = newValue
        }
    }
    
    public var firstSubtitleColor: UIColor {
        get{
            return firstSubtitle.textColor
        }
        set{
            firstSubtitle.textColor = newValue
        }
    }
    
    public var secondSubtitleColor: UIColor {
        get{
            return secondSubtitle.textColor
        }
        set{
            secondSubtitle.textColor = newValue
        }
    }
    
    public var buttonTitle: String {
        get {
            return bottomButton.titleLabel?.text ?? ""
        }
    
        set {
            bottomButton.isHidden = false
            bottomButton.setTitle(newValue, for: .normal)
        }
    }
    
    public var buttonColor: UIColor {
        get{
            return bottomButton.backgroundColor ?? UIColor.white
        }
        
        set{
            bottomButton.backgroundColor = newValue
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
        
        closeImg = UIImage(named: "close_default", in: bundle, compatibleWith: nil)!
        centerImg = UIImage(named: "success_icon", in: bundle, compatibleWith: nil)!
        roundCorner()
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
    
    // Allow view to control itself
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
    }
    
    public func addOkAction(_ action: @escaping ()->Void){
        self.okAction = action
        bottomButton.isHidden = false
    }
    
    
    public func addCloseAction(_ action: @escaping ()->Void){
        self.cancelAction = action
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
