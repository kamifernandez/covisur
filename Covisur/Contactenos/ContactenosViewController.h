//
//  ContactenosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@import Contacts;
@import ContactsUI;

@interface ContactenosViewController : UIViewController <MFMailComposeViewControllerDelegate,CNContactViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topVista;

@end
