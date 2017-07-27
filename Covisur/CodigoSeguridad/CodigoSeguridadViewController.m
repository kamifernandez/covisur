//
//  CodigoSeguridadViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "CodigoSeguridadViewController.h"
#import "NSMutableAttributedString+Color.h"
#import "NuevaContrasenaViewController.h"
#import "RequestUrl.h"
#import "utilidades.h"

@interface CodigoSeguridadViewController (){
    BOOL ocultarVista;
}

@end

@implementation CodigoSeguridadViewController

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
    ocultarVista = YES;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Introducir codigó de seguridad"];
    [string setColorForText:@"Introducir codigó" withColor:[UIColor colorWithRed:102.0/255.0 green:168.0/255.0 blue:223.0/255.0 alpha:1]];
    [string setColorForText:@"de seguridad" withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
    [self.lblTitulo setAttributedText:string];
    
    //[self mostrarOcultraVista];
}

#pragma mark - Own Methods

-(void)mostrarOcultraVista{
    if (ocultarVista) {
        self.viewAlerta.alpha = 1.0;
        self.viewAlerta.hidden = FALSE;
        [self performSelector:@selector(mostrarOcultraVista) withObject:nil afterDelay:3.5];
        ocultarVista = NO;
    }else{
        self.viewAlerta.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.viewAlerta.alpha = 0.0;
        }completion:^(BOOL finished){
            self.viewAlerta.hidden = FALSE;
            ocultarVista = YES;
        }];
    }
}

-(void)pasarVistaNuevaContrasena{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NuevaContrasenaViewController *nuevaContrasenaViewController = [story instantiateViewControllerWithIdentifier:@"NuevaContrasenaViewController"];
    [self.navigationController pushViewController:nuevaContrasenaViewController animated:YES];
}

#pragma mark - IBActions

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)enviarCodigo:(id)sender{
    if ([utilidades verifyEmpty:self.view]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        [self requestServerCodigoContrasena];
    }
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtCodigo isEqual:textField]) {
        [self.view endEditing:true];
    }
    return true;
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


#pragma mark - WebService
#pragma mark - Enviar Codigo

-(void)requestServerCodigoContrasena{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCodigoContrasena) object:nil];
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

-(void)envioServerCodigoContrasena{
    _data = [RequestUrl enviarCodigoGenerado:self.txtCodigo.text];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCodigoContrasena) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoCodigoContrasena{
    if ([_data count]>0) {
        if ([_data objectForKey:@"list"]) {
            NSMutableArray * tempDictio = [_data objectForKey:@"list"];
            NSDictionary * uidUser = [[tempDictio objectAtIndex:0] objectForKey:@"uid"];
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[uidUser objectForKey:@"id"] forKey:@"uidContrasena"];
            [self pasarVistaNuevaContrasena];
        }else{
            [self mostrarOcultraVista];
        }
    }else{
        [self mostrarOcultraVista];
    }
    [self mostrarCargando];
}

@end
