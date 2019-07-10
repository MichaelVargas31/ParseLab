//
//  ChatViewController.m
//  ParseLab
//
//  Created by michaelvargas on 7/10/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ChatViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong,nonatomic) NSArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    
    [self.chatTableView reloadData];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
    chatMessage[@"text"] = self.messageTextField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Message saved");
            self.messageTextField.text = @"";
        } else {
            NSLog(@"issue with message: %@", error.localizedDescription);
        }
    }];
    
}




- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error) {
//            [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"here");
            // Load Chat view controller and set as root view controller
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            appDelegate.window.rootViewController = loginViewController;
            
        } else {
            NSLog(@"error");
        }
    }];
}




- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    cell.recievedChatLabel.text = self.chats[indexPath.row][@"text"];
    
    PFUser *user = self.chats[indexPath.row][@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

-(void) onTimer {
    // construct PFQuery
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2019"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"God chat messages: %@", objects);
            self.chats = objects;
            [self.chatTableView reloadData];

        }
        else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}



@end
