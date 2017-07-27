//
//  ConfirmacionServicioViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 17/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ConfirmacionServicioViewController.h"
#import "MisOrdenesServicioViewController.h"
#import "ServiciosViewController.h"
#import "MenuMiCuentaViewController.h"

@interface ConfirmacionServicioViewController ()

@end

@implementation ConfirmacionServicioViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(IBAction)btnVolver:(id)sender{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ServiciosViewController class]] || [controller isKindOfClass:[MenuMiCuentaViewController class]]) {
            
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
}

-(IBAction)btnOK:(id)sender{
    [self btnVolver:nil];
}

@end
