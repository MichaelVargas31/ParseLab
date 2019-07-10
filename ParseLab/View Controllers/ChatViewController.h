//
//  ChatViewController.h
//  ParseLab
//
//  Created by michaelvargas on 7/10/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)didTapSend:(id)sender;
- (IBAction)didTapLogout:(id)sender;


@end

NS_ASSUME_NONNULL_END
