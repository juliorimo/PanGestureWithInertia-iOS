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

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {

    /*CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];*/

    
    switch (panGestureRecognizer.state) {
    
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            
//            [self pop_removeAnimationForKey:@"decelerate"];
//            self.startBounds = self.bounds;
        }
        
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"UIGestureRecognizerStateChanged");
            
            //Limits
            CGPoint translation = [panGestureRecognizer translationInView:_scrollView];
            NSLog(@"translation: %@",NSStringFromCGPoint(translation));
            
            //Limits
            if(_scrollView.frame.origin.y+translation.y<_finalPoint.y )
            {
                _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y+translation.y, _scrollView.frame.size.width, _scrollView.frame.size.height-translation.y);
                NSLog(@"scroll: %@",NSStringFromCGRect(_scrollView.frame));
            }
            
            /*CGPoint translation = [panGestureRecognizer translationInView:self];
            CGRect bounds = self.startBounds;
            
            CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
            CGFloat minBoundsOriginX = 0.0;
            CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
            bounds.origin.x = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));
            
            CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
            CGFloat minBoundsOriginY = 0.0;
            CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
            bounds.origin.y = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));
            
            self.bounds = bounds;*/
        }
    
        break;
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"UIGestureRecognizerStateEnded");
            
            /*CGPoint velocity = [panGestureRecognizer velocityInView:self];
            if (self.bounds.size.width >= self.contentSize.width) {
                velocity.x = 0;
            }
            if (self.bounds.size.height >= self.contentSize.height) {
                velocity.y = 0;
            }
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;
            NSLog(@"velocity: %@", NSStringFromCGPoint(velocity));
            
            POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
            
            
            POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.rounak.bounds.origin" initializer:^(POPMutableAnimatableProperty *prop) {
                // read value
                prop.readBlock = ^(id obj, CGFloat values[]) {
                    NSLog(@"readBlock values: %f", values[0]);
                    values[0] = [obj bounds].origin.x;
                    values[1] = [obj bounds].origin.y;
                };
                // write value
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    CGRect tempBounds = [obj bounds];
                    NSLog(@"writeBlock values: %f", values[0]);
                    tempBounds.origin.x = values[0];
                    tempBounds.origin.y = values[1];
                    [obj setBounds:tempBounds];
                };
                // dynamics threshold
                prop.threshold = 0.01;
            }];
            decayAnimation.property = prop;
            decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            [self pop_addAnimation:decayAnimation forKey:@"decelerate"];*/
        }
        break;
        
        default:
        break;
    }
}


-(void)animationDidFinish:(id)sender{

    [self pushBetty:nil];
}

-(void)move:(id)sender {
    
    //Pan gesture only over scroll
    if([(UIPanGestureRecognizer*)sender view]!=_scrollView)return;
    
    //Start
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        NSLog(@"--- Start ---");
        
        _firstX = [[sender view] center].x;
        _firstY = [[sender view] center].y;
    }
    
    //Movement point
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];

    //Orientation
    if(_bettyOrientation==WRTemplateBettyOrientationVertical){

        //Move Y
        translatedPoint = CGPointMake(_firstX, +translatedPoint.y+_firstY);
        
    }else if(_bettyOrientation==WRTemplateBettyOrientationHorizonal){
        
        //Move X
        translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY);
    }
    
    //Movement
    CGFloat x = translatedPoint.x - [sender view].bounds.size.width / 2;
    CGFloat y = translatedPoint.y - [sender view].bounds.size.height / 2;
    
    CGFloat width = [sender view].bounds.size.width;
    CGFloat height = _initialPoint.y-y+_bettyButton.frame.size.height;//  [sender view].bounds.size.height;
    
    NSLog(@"translatedPoint: %@",NSStringFromCGPoint(CGPointMake(x, y)));
    [[sender view] setFrame:CGRectMake(x, y, width, height)];
    
    //[[sender view] setCenter:translatedPoint];
    
    //End animation
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        NSLog(@"--- End ---");
        
        //Vars
        CGFloat velocityX,velocityY;
        CGFloat finalX=0,finalY=0;
        
        //Orientation
        if(_bettyOrientation==WRTemplateBettyOrientationVertical){
        
            //Velocity
            velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
            
            //Final position
            finalX = _firstX;
            finalY = translatedPoint.y + velocityY;
            
        }else if(_bettyOrientation==WRTemplateBettyOrientationHorizonal){
        
            //Velocity
            velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
            
            //Final point
            finalX = translatedPoint.x + velocityX;
            finalY = _firstY; // translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        }
        
        //Limits
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
        }
        
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidFinish:)];
        //[[sender view] setCenter:CGPointMake(finalX, finalY)];
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
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [gestureRecognizer setMinimumNumberOfTouches:1];
    [gestureRecognizer setMaximumNumberOfTouches:1];
    [_scrollView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
