//Created 25/01/2023 by Kush Saparia
//Allows LWC to invoke Twilio REST API and send outbound SMS message
public class twilioSendCustomSMSGoldController {
    @AuraEnabled
    public static integer sendSMS(SMSWrapper SMSWrap){
        
        if (String.isBlank(SMSWrap.SMSBody) || String.isBlank(SMSWrap.ToNumber)){
            throw new TwilioUtils.SMSException('Error: Phone Number or SMS Message is missing. No:'+SMSWrap.ToNumber+' Body:'+SMSWrap.SMSBody);
        }
        else{
            HTTPResponse res = TwilioUtils.SendSMS(SMSWrap.ToNumber, SMSWrap.SMSBody);
            System.debug(res);
            return res.getStatusCode();
        }      
    }
    
    //Wrapper used to send data from LWC to Controller
    public class SMSWrapper{
        @AuraEnabled
        public string SMSBody{get;set;}
        @AuraEnabled
        public string ToNumber{get;set;}
    }

}