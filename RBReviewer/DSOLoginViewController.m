//
//  ViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOLoginViewController.h"
#import "DSODoSomethingAPIClient.h"
#import "SSKeychain/SSKeychain.h"
#import "SSKeychain/SSKeychainQuery.h"

@interface DSOLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)loginTapped:(id)sender;
- (IBAction)logoutTapped:(id)sender;

@end

@implementation DSOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greetingLabel.hidden = TRUE;
    self.logoutButton.hidden = TRUE;
    self.reviewButton.hidden = TRUE;
    self.title = @"Login";
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

- (IBAction)logoutTapped:(id)sender {
    [DSODoSomethingAPIClient logoutUserWithCompletionHandler:^(NSDictionary *response){
        
        self.greetingLabel.hidden = TRUE;
        self.usernameTextField.hidden = FALSE;
        self.passwordTextField.hidden = FALSE;
        self.loginButton.hidden = FALSE;
        self.logoutButton.hidden = TRUE;
        self.reviewButton.hidden = TRUE;
    }];
}

- (IBAction)loginTapped:(id)sender {

    NSDictionary *auth = [[NSDictionary alloc] init];
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    auth = @{@"username":username,
              @"password":password};
    
    [DSODoSomethingAPIClient loginUserWithCompletionHandler:^(NSDictionary *response){
        NSString *email = [DSODoSomethingAPIClient sharedClient].user[@"mail"];
        NSString *token = [DSODoSomethingAPIClient sharedClient].authHeaders[@"X-CSRF-Token"];
        [SSKeychain setPassword:password forService:@"DoSomething.org" account:username];
        self.greetingLabel.hidden = FALSE;
        self.greetingLabel.numberOfLines = 0;
        self.greetingLabel.text = [NSString stringWithFormat:@"Hi, %@!\n\nYour token is:\n%@", email, token];
        self.usernameTextField.hidden = TRUE;
        self.passwordTextField.hidden = TRUE;
        self.loginButton.hidden = TRUE;
        self.logoutButton.hidden = FALSE;
        self.reviewButton.hidden = FALSE;
        self.title = @"Home";
    } :auth];
}
@end
