//
//  ViewController.h
//  TestPanGesture
//
//  Created by Julio Rivas on 12/2/15.
//  Copyright (c) 2015 Julio Rivas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WRTemplateBettyOrientation) {
    WRTemplateBettyOrientationVertical=0,
    WRTemplateBettyOrientationHorizonal
};

@interface ViewController : UIViewController

@property (nonatomic,assign) WRTemplateBettyOrientation bettyOrientation;

@property (nonatomic,assign) CGPoint initialPoint;
@property (nonatomic,assign) CGSize pageSize;

@property (nonatomic,strong) UIButton *bettyButton;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

