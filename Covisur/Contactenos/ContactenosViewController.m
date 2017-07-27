//
//  ContactenosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ContactenosViewController.h"

@interface ContactenosViewController ()

@end

@implementation ContactenosViewController

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
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topVista.constant = self.topVista.constant + 75;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topVista.constant = self.topVista.constant + 95;
    }
    [self.view layoutIfNeeded];
}

-(void)agregarContacto{
    CNContactStore *store = [[CNContactStore alloc] init];
    
    // create contact
    
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.familyName = @"Soporte SUAN";
    contact.givenName = @"Soporte SUAN";
    
    CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:[CNPhoneNumber phoneNumberWithStringValue:@"+5714101231"]];
    contact.phoneNumbers = @[homePhone];
    
    CNContactViewController *controller = [CNContactViewController viewControllerForUnknownContact:contact];
    controller.contactStore = store;
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:TRUE];
}

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCorreo:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"contacto@example.com"]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene configurada una cuenta de correo, por favor configure su cuenta y vuelve a intentarlo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"100" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(IBAction)btnLlamar:(id)sender{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"¿Desea comunicarse con nuestra linea de atención al cliente?" forKey:@"Message"];
    [msgDict setValue:@"SI" forKey:@"Aceptar"];
    [msgDict setValue:@"NO" forKey:@"Cancel"];
    [msgDict setValue:@"103" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

-(IBAction)btnWhatsApp:(id)sender{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"Si no tiene nuestro numero de contacto agregado, por favor agregelo antes de continuar" forKey:@"Message"];
    [msgDict setValue:@"SI" forKey:@"Aceptar"];
    [msgDict setValue:@"NO" forKey:@"Cancel"];
    [msgDict setValue:@"101" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

#pragma mark - Mail Composer Delegates

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
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
                                        if ([msgDict objectForKey:@"101"]) {
                                            NSString * textoCompartir = [NSString stringWithFormat:@"whatsapp://send?text=%@",@"Hola, deseo ponerme en contacto con ustedes"];
                                            textoCompartir=[NSString stringWithFormat:@"%@",[textoCompartir stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                            NSURL *whatsappURL = [NSURL URLWithString:textoCompartir];
                                            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                                                [[UIApplication sharedApplication] openURL: whatsappURL];
                                            }else{
                                                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                                                [msgDict setValue:@"Atención" forKey:@"Title"];
                                                [msgDict setValue:@"No encontramos WhatsApp instalado, ¿Quieres descárgarlo?" forKey:@"Message"];
                                                [msgDict setValue:@"SI" forKey:@"Aceptar"];
                                                [msgDict setValue:@"NO" forKey:@"Cancel"];
                                                [msgDict setValue:@"102" forKey:@"Tag"];
                                                
                                                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                                                    waitUntilDone:YES];
                                            }
                                        }else if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"102"]) {
                                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/co/app/whatsapp-messenger/id310633997?mt=8"]];
                                        }else if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"103"]){
                                            UIDevice *device = [UIDevice currentDevice];
                                            
                                            NSString *cellNameStr = @"+5714101231";
                                            
                                            if ([[device model] isEqualToString:@"iPhone"] ) {
                                                
                                                NSString *phoneNumber = [@"tel://" stringByAppendingString:cellNameStr];
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                
                                            } else {
                                                
                                                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                                                [msgDict setValue:@"Atención" forKey:@"Title"];
                                                [msgDict setValue:@"tu dispositivo no soporta llamdas" forKey:@"Message"];
                                                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                                                
                                                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                                                    waitUntilDone:YES];
                                            }
                                        }
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       if ([msgDict objectForKey:@"101"]) {
                                           [self agregarContacto];
                                       }
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

@end
