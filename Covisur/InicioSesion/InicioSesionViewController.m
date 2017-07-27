//
//  InicioSesionViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "InicioSesionViewController.h"
#import "CerrarSesionViewController.h"
#import "utilidades.h"
#import "RequestUrl.h"

@interface InicioSesionViewController ()

@end

@implementation InicioSesionViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
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
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.topIconConstraint.constant = 40;
        self.topPrimeraCajaConstraint.constant = 60;
        self.topCajaAbajoCajaConstraint.constant = 100;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topIconConstraint.constant = 250;
        self.topIconConstraint.constant = 70;
        self.topPrimeraCajaConstraint.constant = 90;
        self.topCajaAbajoCajaConstraint.constant = 160;
        self.ladingRegistrarse.constant = self.ladingRegistrarse.constant + 20;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topIconConstraint.constant = 70;
        self.topPrimeraCajaConstraint.constant = 90;
        self.topCajaAbajoCajaConstraint.constant = 160;
        self.ladingRegistrarse.constant = self.ladingRegistrarse.constant + 30;
    }
    [self.view layoutIfNeeded];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"login"] isEqualToString:@"YES"]) {
        [self pasarInicio:NO];
    }
}

#pragma mark Own Methods

-(void)pasarInicio:(BOOL)animacion{
    [self requestServerGolbales];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    for (UITabBarItem* item in self.tabBarController.tabBar.items)
    {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -10)];
    }
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:animacion];
}

#pragma mark IBActions

-(IBAction)btnLogin:(id)sender{
    if ([utilidades verifyEmpty:self.scroll]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtUsuario.text]){
            [self requestServerLogin];
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

-(IBAction)btnRegistrar:(id)sender{
    /*UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InicioJuegoViewController *inicioJuegoViewController = [story instantiateViewControllerWithIdentifier:@"InicioJuegoViewController"];
    [self.navigationController pushViewController:inicioJuegoViewController animated:YES];*/
}

-(IBAction)btnolvideContrasena:(id)sender{
    /*UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InicioJuegoViewController *inicioJuegoViewController = [story instantiateViewControllerWithIdentifier:@"InicioJuegoViewController"];
    [self.navigationController pushViewController:inicioJuegoViewController animated:YES];*/
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtUsuario isEqual:textField]) {
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
        [self.view endEditing:true];
    }
    return true;
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scroll.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, _tViewSeleccionado.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = _tViewSeleccionado.frame.origin.y-100;
        }else{
            tamano = _tViewSeleccionado.frame.origin.y-130;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        [_scroll setContentOffset:scrollPoint animated:YES];
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _scroll.contentInset = contentInsets;
         _scroll.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
                                            [_defaults setObject:@"NO" forKey:@"login"];
                                            for (UIViewController *controller in self.navigationController.viewControllers) {
                                                
                                                //Do not forget to import AnOldViewController.h
                                                if ([controller isKindOfClass:[InicioSesionViewController class]]) {
                                                    
                                                    [self.navigationController popToViewController:controller
                                                                                          animated:YES];
                                                    break;
                                                }
                                            }
                                        }
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

#pragma mark - Custom Tab

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0)
    {
        // First Tab is selected do something
    }else if (tabBarController.selectedIndex == 1){
        NSLog(@"Prueba");
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[CerrarSesionViewController class]]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Cerrar Sesión" forKey:@"Title"];
        [msgDict setValue:@"Esta seguro que desea cerrar sesión" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        return NO;
    }
    return YES;
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
#pragma mark - Login

-(void)requestServerLogin{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerLogin) object:nil];
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

-(void)envioServerLogin{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    [datosEnvio setObject:self.txtUsuario.text forKey:@"username"];
    [datosEnvio setObject:self.txtContrasena.text forKey:@"password"];
    
    _data = [RequestUrl login:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoLogin) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoLogin{
    if ([_data count]>0) {
        if ([[_data objectForKey:@"message"] isEqualToString:@"El usuario se ha logueado satisfactoriamente "]) {
            NSMutableDictionary * datosTemporales = [_data objectForKey:@"user"];
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:[datosTemporales objectForKey:@"uid"] forKey:@"uid"];
            [_defaults setObject:[datosTemporales objectForKey:@"name"] forKey:@"name"];
            [_defaults setObject:[datosTemporales objectForKey:@"mail"] forKey:@"mail"];
            NSLog(@"Logeado con exito");
            [_defaults setObject:@"YES" forKey:@"login"];
            [self pasarInicio:YES];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Su usuario o contraseñan son incorrectos" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
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

#pragma mark - Variables Globales

-(void)requestServerGolbales{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerGolbales) object:nil];
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

-(void)envioServerGolbales{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    [datosEnvio setObject:self.txtUsuario.text forKey:@"username"];
    [datosEnvio setObject:self.txtContrasena.text forKey:@"password"];
    _data = nil;
    _data = [RequestUrl variablesGlobales];
    [self performSelectorOnMainThread:@selector(ocultarCargandoGolbales) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoGolbales{
    if ([_data count]>0) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:[_data objectForKey:@"no_work_days"] forKey:@"no_work_days"];
        [_defaults setObject:[_data objectForKey:@"start_hour"] forKey:@"start_hour"];
        [_defaults setObject:[_data objectForKey:@"finish_hour"] forKey:@"finish_hour"];
        int diasMinimos = [[_data objectForKey:@"min_day_schedule"] intValue];
        diasMinimos = diasMinimos/24;
        [_defaults setObject:[NSString stringWithFormat:@"%i",diasMinimos] forKey:@"min_day_schedule"];
        [_defaults setObject:[_data objectForKey:@"max_day_schedule"] forKey:@"max_day_schedule"];
        [_defaults setObject:[_data objectForKey:@"level_risk"] forKey:@"level_risk"];
        [_defaults setObject:[_data objectForKey:@"level_risk_msg"] forKey:@"level_risk_msg"];
        [_defaults setObject:[_data objectForKey:@"time_delete_schedule"] forKey:@"time_delete_schedule"];
    }else{
        [self requestServerGolbales];
    }
}

@end
