//
//  RequestUrl.m
//  Tomapp
//
//  Created by Christian Fernandez on 20/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "RequestUrl.h"
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"

static NSString *domain = @"http://covisur.sainetingenieria10.com/desarrollo/";
static NSString *appKey = @"Basic cmVzdF9jb3Zpc3VyOjEyMzQ1Njc4OQ==";
static NSString *x_CSRF_Token = @"";

static NSString *user = @"rest_covisur";
static NSString *pass = @"123456789";

@implementation RequestUrl

+(NSString *)obtenerToken{
    
    NSString *stringDictio = @"";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@restws/session/token",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        stringDictio = [request responseString];
        NSLog(@"%@",stringDictio);
    }
    return stringDictio;
}

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * username = [datos objectForKey:@"username"];
    NSString * password = [datos objectForKey:@"password"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  username, @"username",
                                  password, @"password",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@app_login",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)variablesGlobales{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@variable",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)tiposDocumentos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@taxonomy_term?vocabulary=3",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)crearUsuario:(NSMutableDictionary *)datos{
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * pass = [datos objectForKey:@"pass"];
    NSString * mail = [datos objectForKey:@"mail"];
    NSString * field_id_number = [datos objectForKey:@"field_id_number"];
    NSString * field_id_type = [datos objectForKey:@"field_id_type"];
    NSString * field_user_names = [datos objectForKey:@"field_user_names"];
    NSString * field_user_lastnames = [datos objectForKey:@"field_user_lastnames"];
    NSString * field_address = [datos objectForKey:@"field_address"];
    NSString * field_contact_number = [datos objectForKey:@"field_contact_number"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  pass, @"pass",
                                  mail, @"mail",
                                  field_id_number, @"field_id_number",
                                  field_id_type, @"field_id_type",
                                  field_user_names, @"field_user_names",
                                  field_user_lastnames, @"field_user_lastnames",
                                  field_address, @"field_address",
                                  field_contact_number, @"field_contact_number",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)obtenerListadoServiciosActivos:(NSMutableDictionary *)datos{
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * uid = [datos objectForKey:@"uid"];
    NSString * field_order_status = [datos objectForKey:@"field_order_status"];
    NSString * pagina = [datos objectForKey:@"pagina"];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@node?type=service_orders&author=%@&field_order_status=%@&limit=5&page=%@",domain,uid,field_order_status,pagina];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)codigoContrasena:(NSMutableDictionary *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * email = [datos objectForKey:@"email"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  email, @"email",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@codes",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)enviarCodigoGenerado:(NSString *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@codes/?code_hash=%@",domain,datos];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)actualizarContrasena:(NSString *)datos andUid:(NSString *)uid{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];

    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  datos, @"pass",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user/%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"PUT"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)actualizarCuenta:(NSMutableDictionary *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * uid = [datos objectForKey:@"uid"];
    NSString * mail = [datos objectForKey:@"mail"];
    NSString * pass = [datos objectForKey:@"pass"];
    NSString * field_id_number = [datos objectForKey:@"field_id_number"];
    NSString * field_id_type = [datos objectForKey:@"field_id_type"];
    NSString * field_user_names = [datos objectForKey:@"field_user_names"];
    NSString * field_user_lastnames = [datos objectForKey:@"field_user_lastnames"];
    NSString * field_address = [datos objectForKey:@"field_address"];
    NSString * field_contact_number = [datos objectForKey:@"field_contact_number"];
    
    
    NSMutableDictionary * data = nil;
    
    if ([pass isEqualToString:@""]) {
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                mail, @"mail",
                field_id_number, @"field_id_number",
                field_id_type, @"field_id_type",
                field_user_names, @"field_user_names",
                field_user_lastnames, @"field_user_lastnames",
                field_address, @"field_address",
                field_contact_number, @"field_contact_number",
                nil];
    }else{
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                mail, @"mail",
                pass, @"pass",
                field_id_number, @"field_id_number",
                field_id_type, @"field_id_type",
                field_user_names, @"field_user_names",
                field_user_lastnames, @"field_user_lastnames",
                field_address, @"field_address",
                field_contact_number, @"field_contact_number",
                nil];
    }
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user/%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"PUT"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)miCuenta:(NSString *)idUsuario{
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@user/%@",domain,idUsuario];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)enviarDatosInvestigado:(NSMutableDictionary *)datos{
    
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * type = [datos objectForKey:@"type"];
    NSString * uid = [datos objectForKey:@"uid"];
    NSString * field_id_type = [datos objectForKey:@"field_id_type"];
    NSString * field_id_number_to_investigate = [datos objectForKey:@"field_id_number_to_investigate"];
    NSString * field_first_and_lastnames = [datos objectForKey:@"field_first_and_lastnames"];
    NSString * field_contact_number = [datos objectForKey:@"field_contact_number"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  type, @"type",
                                  uid, @"uid",
                                  field_id_type, @"field_id_type",
                                  field_id_number_to_investigate, @"field_id_number_to_investigate",
                                  field_first_and_lastnames, @"field_first_and_lastnames",
                                  field_contact_number, @"field_contact_number",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)serviciosPagos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@taxonomy_term?vocabulary=2&limit=5&page=0",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)reservar:(NSMutableDictionary *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * stringUid = [_defaults objectForKey:@"uid"]; //Poner para produccion
    //NSString * stringUid = @"85";
    
    NSString * type = [datos objectForKey:@"type"];
    NSString * uid = [_defaults objectForKey:@"idServicio"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  type, @"type",
                                  stringUid, @"uid",
                                  [datos objectForKey:@"payment_services"],@"payment_services",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node/%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"PUT"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)borrarReserva:(NSString *)idReserva{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * stringUid = [_defaults objectForKey:@"uid"]; //Poner para produccion
    //NSString * stringUid = @"85";
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"service_orders", @"type",
                                  stringUid, @"uid",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node/%@",domain,idReserva];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"DELETE"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)crearPago:(NSMutableDictionary *)dataEnvio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * type = [dataEnvio objectForKey:@"type"]; //Poner para produccion
    NSString * nid_service_order = [dataEnvio objectForKey:@"nid_service_order"];
    NSString * nid_credit_card = [dataEnvio objectForKey:@"nid_credit_card"];
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  type, @"type",
                                  nid_service_order, @"nid_service_order",
                                  nid_credit_card, @"nid_credit_card",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)serviciosGratuitos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@taxonomy_term?vocabulary=4&limit=5&page=0",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)eliminarUsuario:(NSString *)datos uid:(NSString *)andUid{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  datos, @"status",
                                  nil];
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@user/%@",domain,andUid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"PUT"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}


+(NSMutableDictionary *)MisServiciosPagos:(NSString *)uid{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@node?type=payments&author=%@&limit=6&page=0",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)obtenerTarjetasCredito:(NSString *)uid{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@node?type=credit_card_node_type&author=%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)borrarTarjetasCredito:(NSString *)uid{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@node/%@",domain,uid];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"DELETE"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)crearTarjetasCredito:(NSMutableDictionary *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * type = [datos objectForKey:@"type"];
    NSString * uid = [datos objectForKey:@"uid"];
    NSString * credit_card_number_month = [datos objectForKey:@"credit_card_number_month"];
    NSString * credit_card_number_year = [datos objectForKey:@"credit_card_number_year"];
    NSString * credit_card_number = [datos objectForKey:@"credit_card_number"];
    NSString * credit_card_name = [datos objectForKey:@"credit_card_name"];
    NSString * credit_card_brand = [datos objectForKey:@"credit_card_brand"];
    NSString * credit_card_security_code = [datos objectForKey:@"credit_card_security_code"];
    NSString * opcionales = [datos objectForKey:@"opcionales"];
    
    NSMutableDictionary * data = nil;
    
    if ([opcionales isEqualToString:@"NO"]) {
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                credit_card_security_code,@"credit_card_security_code",
                credit_card_name,@"credit_card_name",
                type, @"type",
                uid, @"uid",
                credit_card_number_month, @"credit_card_number_month",
                credit_card_number_year, @"credit_card_number_year",
                credit_card_number, @"credit_card_number",
                credit_card_brand, @"credit_card_brand",
                nil];
    }else{
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                credit_card_security_code,@"credit_card_security_code",
                credit_card_name,@"credit_card_name",
                type, @"type",
                uid, @"uid",
                credit_card_number_month, @"credit_card_number_month",
                credit_card_number_year, @"credit_card_number_year",
                credit_card_number, @"credit_card_number",
                credit_card_brand, @"credit_card_brand",
                [datos objectForKey:@"field_name_user_card"], @"field_name_user_card",
                [datos objectForKey:@"field_celphone"], @"field_celphone",
                [datos objectForKey:@"field_email_user_card"], @"field_email_user_card",
                [datos objectForKey:@"field_id_user_card"], @"field_id_user_card",
                [datos objectForKey:@"field_address_user_card"], @"field_address_user_card",
                nil];
    }
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)actualizarTarjetaCredito:(NSMutableDictionary *)datos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * type = [datos objectForKey:@"type"];
    //NSString * uid = [datos objectForKey:@"uid"]; // Producción
    NSString * uid = @"118";
    NSString * credit_card_number_month = [datos objectForKey:@"credit_card_number_month"];
    NSString * credit_card_number_year = [datos objectForKey:@"credit_card_number_year"];
    NSString * credit_card_number = [datos objectForKey:@"credit_card_number"];
    NSString * credit_card_name = [datos objectForKey:@"credit_card_name"];
    NSString * field_payment_method = [datos objectForKey:@"field_payment_method"];
    NSString * credit_card_security_code = [datos objectForKey:@"credit_card_security_code"];
    NSString * opcionales = [datos objectForKey:@"opcionales"];
    
    NSMutableDictionary * data = nil;
    
    if ([opcionales isEqualToString:@"NO"]) {
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                credit_card_security_code,@"credit_card_security_code",
                credit_card_name,@"credit_card_name",
                type, @"type",
                uid, @"uid",
                credit_card_number_month, @"credit_card_number_month",
                credit_card_number_year, @"credit_card_number_year",
                credit_card_number, @"credit_card_number",
                field_payment_method, @"credit_card_brand",
                nil];
    }else{
        data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                credit_card_security_code,@"credit_card_security_code",
                credit_card_name,@"credit_card_name",
                type, @"type",
                uid, @"uid",
                credit_card_number_month, @"credit_card_number_month",
                credit_card_number_year, @"credit_card_number_year",
                credit_card_number, @"credit_card_number",
                field_payment_method, @"credit_card_brand",
                [datos objectForKey:@"field_name_user_card"], @"field_name_user_card",
                [datos objectForKey:@"field_celphone"], @"field_celphone",
                [datos objectForKey:@"field_email_user_card"], @"field_email_user_card",
                [datos objectForKey:@"field_id_user_card"], @"field_id_user_card",
                [datos objectForKey:@"field_address_user_card"], @"field_address_user_card",
                nil];
    }
    
    NSError *error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                          error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@node",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[returnString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)obtenerTerminosCondiciones{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@node?type=terms_conditions",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

+(NSMutableDictionary *)obtenerCiudades{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    x_CSRF_Token = [_defaults objectForKey:@"tokeweb"];
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@taxonomy_term?vocabulary=6",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:appKey];
    [request addRequestHeader:@"x-CSRF-Token" value:x_CSRF_Token];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setUsername:user];
    [request setPassword:pass];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    
    return stringDictio;
}

@end
