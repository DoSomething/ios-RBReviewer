//
//  DSOInboxZeroView.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/27/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOInboxZeroView.h"
#import "DSOInboxViewController.h"
#import <UIImageView-PlayGIF/YFGIFImageView.h>

@implementation DSOInboxZeroView
-(void)layoutSubviews {
    [super layoutSubviews];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSString *name = NSStringFromClass([self class]);
        [[NSBundle mainBundle] loadNibNamed:name
                                      owner:self
                                    options:nil];
        
        [self addSubview:self.view];
        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2000guitar.gif" ofType:nil]];
 
        YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(-16, 0,  [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height / 2)];
        gifView.gifData = gifData;
        [self addSubview:gifView];
        [gifView startGIF];
    }
    return self;
}

- (IBAction)rockOnTapped:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *rootViewController = (UINavigationController *)window.rootViewController;
    [rootViewController popToRootViewControllerAnimated:YES];
}
@end
