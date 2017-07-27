//
//  MenuTerminosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MenuTerminosViewController.h"
#import "TerminosCondicionesViewController.h"
#import "ContactenosViewController.h"

@interface MenuTerminosViewController ()

@end

@implementation MenuTerminosViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    [self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)btnTerminosCondiciones:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TerminosCondicionesViewController *terminosCondicionesViewController = [story instantiateViewControllerWithIdentifier:@"TerminosCondicionesViewController"];
    [self.navigationController pushViewController:terminosCondicionesViewController animated:YES];
}

-(IBAction)btnContactenos:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactenosViewController *contactenosViewController = [story instantiateViewControllerWithIdentifier:@"ContactenosViewController"];
    [self.navigationController pushViewController:contactenosViewController animated:YES];
}

@end
