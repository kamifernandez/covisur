//
//  ResumenServiciosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 16/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ResumenServiciosViewController.h"
#import "PagoServiciosViewController.h"
#import "utilidades.h"

@interface ResumenServiciosViewController ()

@end

@implementation ResumenServiciosViewController

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
    [[NSBundle mainBundle] loadNibNamed:@"ResumenServiciosHeaderTableView" owner:self options:nil];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [self.lblTipoDocumento setText:[_defaults objectForKey:@"tipodocumento"]];
    [self.lblNumeroDocumento setText:[_defaults objectForKey:@"numerodocumento"]];
    [self.lblNombres setText:[_defaults objectForKey:@"nombres"]];
    [self.lblTelefono setText:[_defaults objectForKey:@"telefono"]];
    [self.tablaConfirmarServicios setTableHeaderView:self.headerTabla];
    [self.lblValorTotal setText:self.dataTotal];
    [self.vistaNumeroPaso.layer setCornerRadius:self.vistaNumeroPaso.frame.size.width/2];
    [self.lblPaso setText:_paso];
}

#pragma mark - IBActions

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSeguir:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PagoServiciosViewController *pagoServiciosViewController = [story instantiateViewControllerWithIdentifier:@"PagoServiciosViewController"];
    if ([self.lblPaso.text isEqualToString:@"3"]) {
        pagoServiciosViewController.paso = @"4";
    }else{
        pagoServiciosViewController.paso = @"5";
    }
    pagoServiciosViewController.valor = self.lblValorTotal.text;
    [self.navigationController pushViewController:pagoServiciosViewController animated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataServicesConfirmacion count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"";
    
    
    CellIdentifier = @"ResumenServicioTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ResumenServicioTableViewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    
    [self.lblService setText:[[_dataServicesConfirmacion objectAtIndex:indexPath.row] objectForKey:@"name"]];
    NSString * texto = [[_dataServicesConfirmacion objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    UIFont *font = [UIFont systemFontOfSize: 14];
    NSAttributedString *tes = [utilidades
                               attributedHTMLString: texto
                               useFont: font
                               useHexColor: @"rgb(93,93,93)"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: tes];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing: 6];
    [style setAlignment: NSTextAlignmentJustified];
    
    [mutableAttributedString addAttribute: NSParagraphStyleAttributeName
                                    value: style
                                    range: NSMakeRange(0, mutableAttributedString.mutableString.length)];
    
    //
    self.lblDescription.attributedText = mutableAttributedString;
    [self.lblFecha setHidden:TRUE];
    if ([[self.dataServicesConfirmacion objectAtIndex:indexPath.row] objectForKey:@"fechaNormal"]) {
        [self.lblFecha setText:[NSString stringWithFormat:@"%@, %@",[[_dataServicesConfirmacion objectAtIndex:indexPath.row] objectForKey:@"fechaNormal"],[[_dataServicesConfirmacion objectAtIndex:indexPath.row] objectForKey:@"direccion"]]];
        [self.lblFecha setHidden:FALSE];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int heigth = 130;
    if ([[self.dataServicesConfirmacion objectAtIndex:indexPath.row] objectForKey:@"fechaNormal"]) {
        heigth = 176;
    }
    return heigth;
}

@end
