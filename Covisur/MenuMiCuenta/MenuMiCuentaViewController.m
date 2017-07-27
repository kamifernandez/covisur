//
//  MenuMiCuentaViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 17/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MenuMiCuentaViewController.h"
#import "MisTarjetasViewController.h"
#import "MisOrdenesServicioViewController.h"
#import "MisPagosViewController.h"
#import "MiCuentaViewController.h"

@interface MenuMiCuentaViewController ()

@end

@implementation MenuMiCuentaViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - IBActions

-(IBAction)btnMisPagos:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisPagosViewController *misPagosViewController = [story instantiateViewControllerWithIdentifier:@"MisPagosViewController"];
    misPagosViewController.ventana = @"SI";
    [self.navigationController pushViewController:misPagosViewController animated:YES];
}

-(IBAction)btnMisServicios:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisOrdenesServicioViewController *misOrdenesServicioViewController = [story instantiateViewControllerWithIdentifier:@"MisOrdenesServicioViewController"];
    [self.navigationController pushViewController:misOrdenesServicioViewController animated:YES];
}

-(IBAction)btnMisTarjetas:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisTarjetasViewController *misTarjetasViewController = [story instantiateViewControllerWithIdentifier:@"MisTarjetasViewController"];
    [self.navigationController pushViewController:misTarjetasViewController animated:YES];
}

-(IBAction)btnMiCuenta:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MiCuentaViewController *miCuentaViewController = [story instantiateViewControllerWithIdentifier:@"MiCuentaViewController"];
    [self.navigationController pushViewController:miCuentaViewController animated:YES];
}

@end
