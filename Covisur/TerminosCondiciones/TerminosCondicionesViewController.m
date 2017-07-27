//
//  TerminosCondicionesViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "TerminosCondicionesViewController.h"
#import "utilidades.h"
#import "RequestUrl.h"

@interface TerminosCondicionesViewController ()

@end

@implementation TerminosCondicionesViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestServerServiciosTerminosCondiciones];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    NSDictionary * temp = [[_dataServices objectAtIndex:0] objectForKey:@"body"];
    NSString * texto = temp[@"value"];
    
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
    self.tvtTerminos.attributedText = mutableAttributedString;
}

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}//aps[@"alert"][@"loc-key"]

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

#pragma mark - Obtener Servicios Terminos y Condiciones

-(void)requestServerServiciosTerminosCondiciones{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerServiciosTerminosCondiciones) object:nil];
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

-(void)envioServerServiciosTerminosCondiciones{
    NSMutableDictionary * dataServices = [RequestUrl obtenerTerminosCondiciones];
    [self performSelectorOnMainThread:@selector(ocultarCargandoServiciosTerminosCondiciones:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoServiciosTerminosCondiciones:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        _dataServices = [[documentosTemporal objectForKey:@"list"] copy];
        [self configurerView];
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
