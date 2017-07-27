//
//  ServiciosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 20/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ServiciosViewController.h"
#import "ServicioGratuitosViewController.h"
#import "DatosInvestigadoViewController.h"

@interface ServiciosViewController ()

@end

@implementation ServiciosViewController

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

-(IBAction)btnServiciosPagos:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DatosInvestigadoViewController *datosInvestigadoViewController = [story instantiateViewControllerWithIdentifier:@"DatosInvestigadoViewController"];
    [self.navigationController pushViewController:datosInvestigadoViewController animated:YES];
}

-(IBAction)btnServiciosGratuitos:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ServicioGratuitosViewController *servicioGratuitosViewController = [story instantiateViewControllerWithIdentifier:@"ServicioGratuitosViewController"];
    [self.navigationController pushViewController:servicioGratuitosViewController animated:YES];
}

@end
