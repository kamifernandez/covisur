//
//  ServicioGratuitosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ServicioGratuitosViewController.h"
#import "FTWCache.h"
#import "RequestUrl.h"
#import "NSString+MD5.h"
#import "utilidades.h"

@interface ServicioGratuitosViewController ()

@end

@implementation ServicioGratuitosViewController

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
    self.serviciosSeleccionados = [[NSMutableArray alloc] init];
    
    [self requestServerServiciosGratuitos];
}

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"";
    
    
    CellIdentifier = @"ServiciosGratuitosTableviewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ServiciosGratuitosTableviewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    
    [self.lblService setText:[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    NSString * texto = [[_dataServices objectAtIndex:indexPath.row] objectForKey:@"description"];
    
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
    
    //[self.lblDescription setText:[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"description"]];
        
    if ([[_dataServices objectAtIndex:indexPath.row] objectForKey:@"check"]) {
        if ([[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"check"] isEqualToString:@"YES"]) {
            [self.imgCheckService setHidden:FALSE];
            [cell setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
        }else{
            [cell setBackgroundColor:[UIColor whiteColor]];
            [self.imgCheckService setHidden:TRUE];
        }
    }
    UIImageView * imgCategoria = [cell viewWithTag:1];
    
    NSString * urlEnvio = [[self.dataServices objectAtIndex:0]objectForKey:@"field_image"];
    if ([urlEnvio isEqualToString:@""]) {
        [imgCategoria setFrame:CGRectMake(imgCategoria.frame.origin.x, imgCategoria.frame.origin.y - 15, imgCategoria.frame.size.width, imgCategoria.frame.size.height)];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [urlEnvio MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            //UIImage *image = [UIImage imageNamed:@"imagen-detalle@3x.png"];
            imgCategoria.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                //UIImage *image = [UIImage imageNamed:@"imagen-detalle@3x.png"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imgCategoria.image = image;
                });
            });
        }
        
        imgCategoria.contentMode = UIViewContentModeScaleAspectFill;
        
        [imgCategoria.layer setCornerRadius:imgCategoria.frame.size.height/2];
        [imgCategoria.layer setMasksToBounds:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[self.dataServices objectAtIndex:indexPath.row]objectForKey:@"field_service_link"]]]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Obtener Servicios de Pago

-(void)requestServerServiciosGratuitos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerServiciosGratuitos) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerServiciosGratuitos{
    NSMutableDictionary * dataServices = [RequestUrl serviciosGratuitos];
    [self performSelectorOnMainThread:@selector(ocultarCargandoServiciosGratuitos:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoServiciosGratuitos:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        _dataServices = [[documentosTemporal objectForKey:@"list"] copy];
        [self.tblSeleccionServicios reloadData];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Su usuario o contraseñan son incorrectos" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
