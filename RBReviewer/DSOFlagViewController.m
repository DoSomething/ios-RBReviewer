//
//  DSOFlagViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/21/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOFlagViewController.h"

@interface DSOFlagViewController ()
@property (strong, nonatomic) NSMutableArray *options;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *saveButton;

@end

@implementation DSOFlagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.options = [[NSMutableArray alloc] init];
    NSMutableDictionary *d1 = [[NSMutableDictionary alloc] init];
    d1[@"label"] = @"Irrelevant";
    d1[@"key"] = @"irrelevant";
    d1[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d1];
    NSMutableDictionary *d2 = [[NSMutableDictionary alloc] init];
    d2[@"label"] = @"Inappropriate";
    d2[@"key"] = @"inappropriate";
    d2[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d2];
    NSMutableDictionary *d3 = [[NSMutableDictionary alloc] init];
    d3[@"label"] = @"Unrealistic quantity";
    d3[@"key"] = @"inappropriate";
    d3[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d3];
    NSMutableDictionary *d4 = [[NSMutableDictionary alloc] init];
    d4[@"label"] = @"Delete this image";
    d4[@"key"] = @"delete";
    d4[@"checked"] = [NSNumber numberWithInt:0];
    [self.options addObject:d4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.options count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    NSDictionary *option = [self.options objectAtIndex:indexPath.row];
    cell.textLabel.text = option[@"label"];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSMutableDictionary *option = (NSMutableDictionary *)self.options[indexPath.row];
    NSString *key = [option objectForKey:@"key"];


    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    BOOL checked = [[option objectForKey:@"checked"] boolValue];
    if (!checked) {
        cell.image = [UIImage imageNamed:@"approved.png"];
        [option setObject:[NSNumber numberWithInt:1]  forKey:@"checked"];
        if ([key isEqual:@"delete"]) {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Delete Image" message:@"Are you sure? This cannot be undone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
        }
    }
    else {
        cell.image = nil;
        [option setObject:[NSNumber numberWithInt:0]  forKey:@"checked"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
