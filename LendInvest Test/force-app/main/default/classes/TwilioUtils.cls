//Created 25/01/2023 by Kush Saparia
//Utility Class used for invoking/handling Twilio REST API
public class TwilioUtils {
    //Callout Settings
    public static final TwilioSMS__c smsSettings = TwilioSMS__c.getOrgDefaults();

    //Callout to send SMS messages
    @future(callout = true)
    public static void SendFutureSMS(String toNumber, String smsBody) {
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        HttpRequest req = CreateSMSRequest();
        req.setBody('To=' + EncodingUtil.urlEncode(toNumber, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(smsSettings.FromNumber__c,'UTF-8') + '&Body=' + smsBody);
        res = http.send(req);
        System.debug(res.getBody());
        if(res.getStatusCode() != 201){
            errorWrapper er = (errorWrapper)json.deserialize(res.getBody(), errorWrapper.class);
            system.debug(er);
            system.debug(er.message);
        }    
    }
    
    public static HTTPResponse SendSMS(String toNumber, String smsBody) {
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        HttpRequest req = CreateSMSRequest();
        req.setBody('To=' + EncodingUtil.urlEncode(toNumber, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(smsSettings.FromNumber__c,'UTF-8') + '&Body=' + smsBody);
        res = http.send(req);
        System.debug(res.getBody());
        if(res.getStatusCode() != 201){
            errorWrapper er = (errorWrapper)json.deserialize(res.getBody(), errorWrapper.class);
            system.debug(er);
            system.debug(er.message);
            throw new SMSException('Error: '+er.message);
        } else {
            return res;
        }    
    } 

    //Creates Http Request for SMS Messages
    private static HttpRequest CreateSMSRequest(){   
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:TwilioSMS/' + smsSettings.AccountSID__c + '/Messages.json');
        req.setMethod('POST');
        return (req);
    }

    //wrapper to catch any errors
    public class errorWrapper{
        String code;
        String message;
        String moreInfo;
        String status; 
    }

    //custom Exception returned by SMS Message
    public class SMSException extends Exception{
    }
        
}