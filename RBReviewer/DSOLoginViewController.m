//
//  ViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOLoginViewController.h"
#import "DSOInboxViewController.h"
#import "DSODoSomethingAPIClient.h"
#import <SSKeychain/SSKeychain.h>
#import <SSKeychain/SSKeychainQuery.h>
#import <TSMessage.h>

@interface DSOLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)loginTapped:(id)sender;

@end

@implementation DSOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Login";
    [self checkForKeychain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkForKeychain
{
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    
    NSDictionary *authValues = [client getSavedLogin];
    if ([authValues count] > 0) {
        self.usernameTextField.text = authValues[@"username"];
        self.passwordTextField.text = authValues[@"password"];
    }
}


- (IBAction)loginTapped:(id)sender {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];

    [client loginWithUsername:username andPassword:password andCompletionHandler:^(NSDictionary *response){
        UINavigationController *inboxNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"inboxNavigationController"];
        DSOInboxViewController *inboxVC = (DSOInboxViewController *)inboxNavVC.topViewController;
        inboxVC.displayWelcomeMessage = YES;
        [self presentViewController:inboxNavVC animated:YES completion:nil];
        
    } andErrorHandler:^(NSError *error){
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Aw, shit"
                                           subtitle:error.localizedDescription
                                               type:TSMessageNotificationTypeError];
        
    }];
}
@end
