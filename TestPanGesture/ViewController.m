//
//  ViewController.m
//  TestPanGesture
//
//  Created by Julio Rivas on 12/2/15.
//  Copyright (c) 2015 Julio Rivas. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>

#define TEMPLATE_BETTY_X 20
#define TEMPLATE_BETTY_Y (SCREEN_HEIGHT-2*TEMPLATE_BETTY_HEIGHT)
#define TEMPLATE_BETTY_WIDTH (SCREEN_WIDTH-2*TEMPLATE_BETTY_X)
#define TEMPLATE_BETTY_HEIGHT 50

#define TEMPLATE_BETTY_BUTTON_WIDTH 50

#define TEMPLATE_BETTY_PAGE_HIEGHT (SCREEN_HEIGHT*0.8)

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()
@property CGRect startBounds;
@end

@implementation ViewController
{
    //Final position
    CGPoint _finalPoint;
    
    //Coordinates for animation
    CGFloat _firstX;
    CGFloat _firstY;
}

#pragma mark - Actions

-(void)pushBetty:(id)sender
{
    CGPoint destiny;
    NSInteger size;

    if(_bettyButton.frame.origin.y==_initialPoint.y)
    {
        //Move up
        destiny=_finalPoint;
        size=_bettyButton.frame.size.height+_pageSize.height;
    }
    else
    {
        //Move down
        destiny=_initialPoint;
        size=_bettyButton.frame.size.height;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //Move up
        _bettyButton.frame = CGRectMake(destiny.x, destiny.y, _bettyButton.frame.size.width, _bettyButton.frame.size.height);
        
        //Scroll
        _scrollView.frame = CGRectMake(destiny.x, destiny.y, _scrollView.frame.size.width, size);
        
    }];
}



-(void)animationDidFinish:(id)sender{

    [self pushBetty:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    //Pan gesture only over scroll
    if([panGestureRecognizer view]!=_scrollView)return;
    
    //Start
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        NSLog(@"--- Start ---");
        
        _firstX = [[panGestureRecognizer view] center].x;
        _firstY = [[panGestureRecognizer view] center].y;
    }
    
    //Movement point
    CGPoint translatedPoint = [panGestureRecognizer translationInView:self.view];

    //Vars
    CGFloat x=0,y=0,width=0,height=0;
    
    //Orientation
    if(_bettyOrientation==WRTemplateBettyOrientationVertical){

        //Move Y
        translatedPoint = CGPointMake(_firstX, +translatedPoint.y+_firstY);
        
        //Final positions
        x = translatedPoint.x - [panGestureRecognizer view].bounds.size.width / 2;
        y = translatedPoint.y - [panGestureRecognizer view].bounds.size.height / 2;
        
        //Limit top
        if(y<_finalPoint.y)y=_finalPoint.y;
        
        //Limit down
        if(y>_initialPoint.y)y=_initialPoint.y;
        
        //Size
        width = [panGestureRecognizer view].bounds.size.width;
        height = _initialPoint.y-y+_bettyButton.frame.size.height;
        
    }else if(_bettyOrientation==WRTemplateBettyOrientationHorizonal){
        
        //Move X
        translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY);
        
        //Final positions
        x = translatedPoint.x - [panGestureRecognizer view].bounds.size.width / 2;
        y = translatedPoint.y - [panGestureRecognizer view].bounds.size.height / 2;
        
        //Limit left
        //TODO
        
        //Limit right
        //TODO
        
        //Size
        width = _initialPoint.x-x+_bettyButton.frame.size.width;
        height = [panGestureRecognizer view].bounds.size.height;
    }
    
    //New frame
    NSLog(@"translatedPoint: %@",NSStringFromCGPoint(CGPointMake(x, y)));
    [[panGestureRecognizer view] setFrame:CGRectMake(x, y, width, height)];
    _bettyButton.frame = CGRectMake(x, y, _bettyButton.frame.size.width, _bettyButton.frame.size.height);
    //[[panGestureRecognizer view] setCenter:translatedPoint];
    
    //End animation
    if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        NSLog(@"--- End ---");
        
        //Vars
        CGFloat velocityX,velocityY;
        CGFloat finalX=0,finalY=0;
        
        //Orientation
        if(_bettyOrientation==WRTemplateBettyOrientationVertical){
        
            //Velocity
            velocityY = (0.2*[panGestureRecognizer velocityInView:self.view].y);
            
            //Final position
            finalX = _firstX;
            finalY = translatedPoint.y + velocityY;
            
        }else if(_bettyOrientation==WRTemplateBettyOrientationHorizonal){
        
            //Velocity
            velocityX = (0.2*[panGestureRecognizer velocityInView:self.view].x);
            
            //Final point
            finalX = translatedPoint.x + velocityX;
            finalY = _firstY; // translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        }
        
        //Limits
        if(finalX<0){
            finalX=0;
        }else if(finalX>SCREEN_WIDTH){
            finalX=SCREEN_WIDTH;
        }
            
        if(finalY<0){
            finalY=0;
        }else if(finalY>SCREEN_HEIGHT){
            finalY=SCREEN_HEIGHT;
        }
        
        /*
        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            if (finalX < 0) {
                finalX = 0;
            } else if (finalX > 768) {
                finalX = 768;
            }
            
            if (finalY < 0) {
                //finalY = 0;
            } else if (finalY > 1024) {
                //finalY = 1024;
            }
        } else {
            if (finalX < 0) {
                finalX = 0;
            } else if (finalX > 1024) {
                finalX = 768;
            }
            
            if (finalY < 0) {
                //_finalY = 0;
            } else if (finalY > 768) {
                //_finalY = 1024;
            }
        }*/
        
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidFinish:)];
        //[[panGestureRecognizer view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Horientation
    _bettyOrientation=WRTemplateBettyOrientationVertical;
    
    //Page size
    _pageSize = CGSizeMake(SCREEN_WIDTH-2*TEMPLATE_BETTY_X, TEMPLATE_BETTY_PAGE_HIEGHT);
    
    //Init and final position
    _initialPoint = CGPointMake(TEMPLATE_BETTY_X, TEMPLATE_BETTY_Y);
    _finalPoint = CGPointMake(TEMPLATE_BETTY_X, _initialPoint.y-_pageSize.height);
    
    //Scroll
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.frame = CGRectMake(TEMPLATE_BETTY_X, TEMPLATE_BETTY_Y, TEMPLATE_BETTY_WIDTH, TEMPLATE_BETTY_HEIGHT);
    _scrollView.contentSize = _scrollView.frame.size;
    [self.view addSubview:_scrollView];
    
    //Betty button
    _bettyButton = [[UIButton alloc] initWithFrame:CGRectMake(TEMPLATE_BETTY_X, TEMPLATE_BETTY_Y, TEMPLATE_BETTY_BUTTON_WIDTH, TEMPLATE_BETTY_HEIGHT)];
    _bettyButton.backgroundColor = [UIColor grayColor];
    [_bettyButton addTarget:self action:@selector(pushBetty:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bettyButton];

    //Add pan gesture
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [gestureRecognizer setMinimumNumberOfTouches:1];
    [gestureRecognizer setMaximumNumberOfTouches:1];
    [_scrollView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
