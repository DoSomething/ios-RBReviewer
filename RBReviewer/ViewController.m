//
//  ViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "ViewController.h"
#import "DSODoSomethingAPIClient.h"
#import "DSOUser.h"

static NSString *APIToken;
static NSDictionary *APIUser;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)loginTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greetingLabel.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTapped:(id)sender {

    NSDictionary *auth = [[NSDictionary alloc] init];

    auth = @{@"username":self.usernameTextField.text,
              @"password":self.passwordTextField.text};
    
    [DSODoSomethingAPIClient loginUserWithCompletionHandler:^(NSDictionary *response){
        
        APIToken = response[@"token"];
        APIUser = response[@"user"];
        self.greetingLabel.hidden = FALSE;
        self.greetingLabel.text = [NSString stringWithFormat:@"Hi, %@",APIUser[@"mail"]];
        self.usernameTextField.hidden = TRUE;
        self.passwordTextField.hidden = TRUE;
        self.loginButton.hidden = TRUE;
        
    } :auth];
}
@end
