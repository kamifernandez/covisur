//
//  RecuperarContrasenaViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "RecuperarContrasenaViewController.h"
#import "NSMutableAttributedString+Color.h"
#import "CodigoSeguridadViewController.h"
#import "utilidades.h"
#import "RequestUrl.h"

@interface RecuperarContrasenaViewController (){
    BOOL ocultarVista;
}

@end

@implementation RecuperarContrasenaViewController

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
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Enviar codigó a mi correo electrónico"];
    [string setColorForText:@"Enviár codigó" withColor:[UIColor colorWithRed:102.0/255.0 green:168.0/255.0 blue:223.0/255.0 alpha:1]];
    [string setColorForText:@"a mi correo electrónico" withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
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
    CodigoSeguridadViewController *codigoSeguridadViewController = [story instantiateViewControllerWithIdentifier:@"CodigoSeguridadViewController"];
    [self.navigationController pushViewController:codigoSeguridadViewController animated:YES];
}

#pragma mark - IBActions

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)enviarCorreo:(id)sender{
    if ([utilidades verifyEmpty:self.view]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtUsuario.text]){
            [self requestServerCodigoContrasena];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica el campo correo sea valido" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtUsuario isEqual:textField]) {
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            [self pasarVistaNuevaContrasena];
                                        }
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
#pragma mark - Codigo Contraseña

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
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    [datosEnvio setObject:self.txtUsuario.text forKey:@"email"];
    _data = [RequestUrl codigoContrasena:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCodigoContrasena) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoCodigoContrasena{
    if ([_data count]>0) {
        if ([[_data objectForKey:@"id"] intValue] != 0) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Un código fue enviado a su correo inscrito" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"101" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            [self mostrarOcultraVista];
        }
    }else{
        [self mostrarOcultraVista];
    }
    [self mostrarCargando];
}

@end
