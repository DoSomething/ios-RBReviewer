//
//  ViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOLoginViewController.h"
#import "DSOInboxViewController.h"

#import <SlothKit/DSOClient.h>
#import <TSMessage.h>

@interface DSOLoginViewController ()

@property (strong, nonatomic) DSOClient *client;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)loginTapped:(id)sender;

@end

@implementation DSOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Login";
    self.client = [DSOClient sharedClient];
    [self checkForKeychain];
}

- (void) checkForKeychain {

    NSDictionary *authValues = [self.client getSavedLogin];
    if ([authValues count] > 0) {
        self.usernameTextField.text = authValues[@"username"];
        self.passwordTextField.text = authValues[@"password"];
    }
}


- (IBAction)loginTapped:(id)sender {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    [self.client loginWithUsername:username password:password completionHandler:^(NSDictionary *response){
        UINavigationController *inboxNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"inboxNavigationController"];
        DSOInboxViewController *inboxVC = (DSOInboxViewController *)inboxNavVC.topViewController;
        inboxVC.displayWelcomeMessage = YES;
        [self presentViewController:inboxNavVC animated:YES completion:nil];
        
    } errorHandler:^(NSError *error){
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Aw, shit"
                                           subtitle:error.localizedDescription
                                               type:TSMessageNotificationTypeError];
        
    }];
}
@end
