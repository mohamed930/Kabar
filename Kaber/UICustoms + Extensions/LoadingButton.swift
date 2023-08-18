//
//  LoadingButton.swift
//  Kaber
//
//  Created by Mohamed Ali on 18/08/2023.
//

import UIKit

public enum ActivityIndicatorAlignment: Int {
    case Left
    case Right
    case Center
    
}

public class LoadingButton: UIButton {
    
    let activityIndicatorView:UIActivityIndicatorView! = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
   
    public var indicatorAlignment:ActivityIndicatorAlignment = ActivityIndicatorAlignment.Right {
        didSet {
           setupPositionIndicator()
        }
    }
    
    public var indicatorAlignmentCenter:ActivityIndicatorAlignment = ActivityIndicatorAlignment.Center {
        didSet {
           setupPositionIndicatorCenter()
        }
    }
    
    
    public var loading:Bool = false {
        didSet {
           realoadView()
        }
    }
    
    public var indicatorColor:UIColor = UIColor.lightGray {
        didSet {
            activityIndicatorView.color = indicatorColor
        }
    }
    
    public var normalText:String? = nil {
        didSet {
            if(normalText == nil){
                normalText = (self.titleLabel?.text ?? "")
            }
            
            self.titleLabel?.text = normalText
        }
    }
    
    public var loadingText:String?
    
    var topContraints:NSLayoutConstraint?
    var bottomContraints:NSLayoutConstraint?
    var widthContraints:NSLayoutConstraint?
    var rightContraints:NSLayoutConstraint?
    var leftContraints:NSLayoutConstraint?
    var centerXConstraint: NSLayoutConstraint?
    var centerYConstraint: NSLayoutConstraint?
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        activityIndicatorView.hidesWhenStopped = true;
        self.normalText = self.titleLabel?.text
        self.addSubview(activityIndicatorView)
        setupPositionIndicator()
    }
    
    func realoadView() {
        if(loading){
            activityIndicatorView.isHidden = false;
            activityIndicatorView.startAnimating()
            if(self.loadingText != nil ){
                self.setTitle(loadingText, for: [])
                
            }
        }else{
            activityIndicatorView.stopAnimating()
            self.setTitle(normalText, for: [])
            
        }
      
    }
    
    func setupPositionIndicator()  {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        if(topContraints==nil){
            topContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .top, relatedBy: .equal, toItem: self,
                                               attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0,
                  constant: 0)
        }
        
        if(bottomContraints==nil){
            bottomContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .bottom, relatedBy: .equal, toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0,
                     constant: 0)
        }
        
        if(widthContraints==nil){
            widthContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .width, relatedBy: .equal, toItem: nil,
                                                 attribute: .width, multiplier: 1.0,
                        constant: 30)
        }
        
        if(rightContraints==nil){
            rightContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .trailingMargin, relatedBy: .equal, toItem: self,
                                                 attribute: .trailingMargin, multiplier: 1.0,
                                 constant: 0)
        }
        
        if(leftContraints==nil){
            leftContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .leading, relatedBy: .equal, toItem: self,
                                                attribute: .leading, multiplier: 1.0,
                          constant: 0)
        }
        
        if(indicatorAlignment == .Right ){
            NSLayoutConstraint.deactivate([leftContraints!])
            NSLayoutConstraint.activate([topContraints!,rightContraints!,widthContraints!,bottomContraints!])
        }else{
            NSLayoutConstraint.deactivate([rightContraints!])
            NSLayoutConstraint.activate([topContraints!,leftContraints!,widthContraints!,bottomContraints!])

        }
    }
    
    func setupPositionIndicatorCenter()  {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        if(topContraints==nil){
            topContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .top, relatedBy: .equal, toItem: self,
                                               attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0,
                  constant: 0)
        }
        
        if(bottomContraints==nil){
            bottomContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .bottom, relatedBy: .equal, toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0,
                     constant: 0)
        }
        
        if(widthContraints==nil){
            widthContraints = NSLayoutConstraint(item: activityIndicatorView as Any, attribute:
                    .width, relatedBy: .equal, toItem: nil,
                                                 attribute: .width, multiplier: 1.0,
                        constant: 30)
        }
        
        if centerXConstraint == nil {
            centerXConstraint = NSLayoutConstraint(item: activityIndicatorView as Any, attribute: .centerX,
                                                       relatedBy: .equal, toItem: self, attribute: .centerX,
                                                       multiplier: 1.0, constant: 0)
        }
        
        if centerYConstraint == nil {
            centerYConstraint = NSLayoutConstraint(item: activityIndicatorView as Any, attribute: .centerY,
                                                       relatedBy: .equal, toItem: self, attribute: .centerY,
                                                       multiplier: 1.0, constant: 0)
        }
        
        
        if(indicatorAlignmentCenter == .Center ){
            NSLayoutConstraint.deactivate([rightContraints!, leftContraints!])
            NSLayoutConstraint.activate([topContraints!,centerXConstraint!,centerYConstraint!,widthContraints!,bottomContraints!])
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
