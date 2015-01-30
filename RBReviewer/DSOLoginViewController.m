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
#import "SSKeychain/SSKeychain.h"
#import "SSKeychain/SSKeychainQuery.h"
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
    [self checkForKeychain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkForKeychain
{
    NSArray *dsAccounts = [SSKeychain accountsForService:@"DoSomething.org"];
    if ([dsAccounts count] > 0) {
        NSDictionary *account = dsAccounts[0];
        self.usernameTextField.text = account[@"acct"];
        self.passwordTextField.text = [SSKeychain passwordForService:@"DoSomething.org" account:account[@"acct"]];
    }
}


- (IBAction)loginTapped:(id)sender {

    NSDictionary *auth = [[NSDictionary alloc] init];
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    auth = @{@"username":username,
              @"password":password};
    
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];

    [client loginWithCompletionHandler:^(NSDictionary *response){
        [SSKeychain setPassword:password forService:@"DoSomething.org" account:username];
        NSLog(@"Response:%@", response);
        NSDictionary *user = response[@"user"];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
        [TSMessage showNotificationInViewController:vc
                                              title:@"Welcome back!"
                                           subtitle:user[@"mail"]
                                        type:TSMessageNotificationTypeMessage];
        
    } andDictionary:auth andViewController:self];
}
@end
