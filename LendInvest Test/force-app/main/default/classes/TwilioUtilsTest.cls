@isTest
private class TwilioUtilsTest {
    
    //Dummy SMS callout success
    private class SuccessSMSMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(201);
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            res.setBody('{"code" : "201", "message" : "Success",  "moreInfo" : "", "status" : "" }');
            return res;
        }
    }
    //Dummy SMS callout error
    private class FailSMSMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(404);
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            res.setBody('{"code" : "400", "message" : "Bad Request",  "moreInfo" : "Error Message Test", "status" : "60200" }');
            return res;
        }
    }

    @isTest //tests for success response from FUTURE SMS request
    static void sendSMSFutureSuccess() {
        Account acc = new Account(Name='Test 1 Acc', Phone='+44123456789');
        Opportunity opp = new Opportunity(Name='Test 1 Opp', CloseDate=Date.valueOf('2025-01-01'), Stagename='Closed Won', Amount=50000);
        Test.setMock(HttpCalloutMock.class, new SuccessSMSMock());
        Test.startTest();
        insert acc;
        opp.AccountId=acc.Id;
        insert opp;
        Test.stopTest();
    }

    @isTest //tests for failed response from FUTURE SMS request
    static void sendSMSFutureFail() {
        Test.setMock(HttpCalloutMock.class, new FailSMSMock());
        Test.startTest();
        TwilioUtils.SendFutureSMS('+44123456789','Fail Body');
        Test.stopTest();
    }

    @isTest //tests for success response from SMS request
    static void sendSMSSuccess() {
        Test.setMock(HttpCalloutMock.class, new SuccessSMSMock());
        Test.startTest();
        TwilioUtils.SendSMS('+44123456789','Success Body');
        Test.stopTest();
    }

    @isTest //tests for failed response from SMS request
    static void sendSMSFail() {
        Test.setMock(HttpCalloutMock.class, new FailSMSMock());
        Test.startTest();
        try {
            TwilioUtils.SendSMS('+44123456789','Fail Body');
            System.Assert(false, 'Error response did not trigger exception');
        } catch (TwilioUtils.SMSException e){ 
            System.assert(true);
        } catch (Exception e){ 
                System.assert(false, 'Incorrect exception type caught');
            }        
        Test.stopTest();
    }

    @isTest 
    static void twilioSendCustomSMSGoldControllerTestSuccess(){
        twilioSendCustomSMSGoldController.SMSWrapper wrap = new twilioSendCustomSMSGoldController.SMSWrapper();
        wrap.SMSBody = 'test body'; 
        wrap.ToNumber='+44123456789';
        Test.setMock(HttpCalloutMock.class, new SuccessSMSMock());
        test.startTest();
        twilioSendCustomSMSGoldController.sendSMS(wrap);
        test.stopTest();
    }

    @isTest //Tests for invalid inputs passed into the controller 
    static void twilioSendCustomSMSGoldControllerTestFail(){
        twilioSendCustomSMSGoldController.SMSWrapper wrap = new twilioSendCustomSMSGoldController.SMSWrapper();
        wrap.SMSBody = ''; 
        wrap.ToNumber='';
        test.startTest();
        try{
            twilioSendCustomSMSGoldController.sendSMS(wrap);
            system.Assert(false,'Blank phone number/SMS body should not be allowed to pass');
        } catch(TwilioUtils.SMSException e){
            System.Assert(true);                        
        }
        test.stopTest();
    }
}