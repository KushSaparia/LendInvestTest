//Created 25/01/2023 by Kush Saparia
//Utility Class used for invoking/handling Twilio REST API
public class TwilioUtils {

    //Twilio API Credentials
    private static final String accountSid = 'AC4b34076c2395c7125ea0ea4db15bdb57';
    private static final String authToken = '225b1deb54859f32bb940377d8b7cd8b';
    private static final String fromNumber = '+17707621164';
    private static final String VERSION = '3.2.0';

    //Callout to send SMS messages
    @future(callout = true)
    public static void SendFutureSMS(String toNumber, String smsBody) {
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        HttpRequest req = CreateSMSRequest();
        req.setBody('To=' + EncodingUtil.urlEncode(toNumber, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(fromNumber,'UTF-8') + '&Body=' + smsBody);
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
        req.setBody('To=' + EncodingUtil.urlEncode(toNumber, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(fromNumber,'UTF-8') + '&Body=' + smsBody);
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
        Blob creds = Blob.valueOf(accountSid+':' +authToken);       
        req.setEndPoint('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/Messages.json');
        req.setMethod('POST');
        req.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
        req.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Accept-Charset', 'utf-8');
        req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(creds));
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