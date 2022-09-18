public with sharing class akhilLwcInterviewcallClass {
    
    @AuraEnabled
    public static leadWrapper getLeadData(string recId){
        lead leadRec = [SELECT id,Name,owner.name,Phone,Email FROM Lead WHERE id=:recId];
        //System.debug('=========Lead Name======',leadRec.Name);
        leadWrapper Lw = new leadWrapper();
        Lw.leadname = leadRec.name;
        Lw.OwnerName = leadRec.owner.name;
        Lw.phoneNumber = leadRec.Phone;
        Lw.emailId = leadRec.email;
        system.debug('----Lw.emailId----'+Lw.emailId);
        return Lw;
    }
    
    @AuraEnabled
    public static string updateDoNotCall(string recId){
        System.debug('------inside class updateDoNotCall recId-----'+recId);
        Lead l = new Lead();
        l.id = recId;
        l.Do_Not_Call__c = true;
        Database.SaveResult sr = Database.update(l);
        if(sr.isSuccess()){
            System.debug('------inside class updateDoNotCall if sr.getId()-----'+sr.getId());
            return sr.getId();
        }else{
            System.debug('------inside class updateDoNotCall else error-----');
            return 'error';
        }
    }

    @AuraEnabled
    public static string reScheduleCall(string recId, Datetime dateTm){
        System.debug('------inside class reScheduleCall recId-----'+recId);
        lead l = new lead();
        l.id = recId;
        l.Reschedule_Date__c = dateTm;
        Database.SaveResult sr = Database.update(l);
        if(sr.isSuccess()){
            System.debug('------inside class reScheduleCall if sr.getId()-----'+sr.getId());
            return sr.getId();
        }else{
            System.debug('------inside class reScheduleCall else error-----');
            return 'error';
        }
    }

    @AuraEnabled
    public static boolean sendInfoMail(string recId){
        lead l = [SELECT id,name,Email FROM Lead WHERE id=:recId];
        System.debug('-----sencInfoMail lead l ------'+l);

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new string[] {l.email};
        system.debug('-----message.toAddresses------'+message.toAddresses);
        message.subject = 'TaxtRise Info';
        system.debug('-----message.subject------'+message.subject);
        message.plainTextBody = 'Hi This is TaxRise';
        system.debug('-----message.plainTextBody------'+message.plainTextBody);
        Messaging.SingleEmailMessage[] messages = new list<Messaging.SingleEmailMessage> {message};
        system.debug('-----Messaging.SingleEmailMessage[] messages------'+messages);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success){
            System.debug('The email was sent successfully.');
        }else{
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return true;
    }

    @AuraEnabled
     public static string sendEmailVerification(string recId){
        lead l = [SELECT id,Name,Phone,email FROM lead WHERE id=:recId];
        System.debug('-----sendEmailVerification lead l ------'+l);
        string rendomCode = string.valueOf(Math.round((Math.random() * (9000) + 1000)));
        system.debug('----sendEmailVerification -> remdomCode -----'+rendomCode);

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new string[] {l.email};
        system.debug('-----message.toAddresses------'+message.toAddresses);
        message.subject = 'TaxRise Verification Code';
        system.debug('-----message.subject------'+message.subject);
        message.plainTextBody = 'hello,'+l.name+'Your Verification code is '+ rendomCode;
        system.debug('-----message.plainTextBody------'+message.plainTextBody);
        Messaging.SingleEmailMessage[] messages = new list<Messaging.SingleEmailMessage>{message};
        system.debug('-----Messaging.SingleEmailMessage[] messages------'+messages);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return rendomCode;
    }

    @AuraEnabled
    public static string sendApprovalToManager(string recId){
        system.debug('---recId----'+recId);
        system.debug('-----UserInfo.getUserId()----'+UserInfo.getUserId());
        list<task> taskList = [SELECT id FROM Task WHERE whoid =: recId and OwnerId =: UserInfo.getUserId() and status = 'Open'];
        if(taskList != null){
            task t = new Task();
            t.whoId = recId;
            t.Subject = 'Request for approval';
            t.status = 'Open';
            t.OwnerId = UserInfo.getUserId();
            Database.SaveResult sr = Database.insert(t);
            if(sr.isSuccess()){
                system.debug('----inside sendApprovalToManager if=>isSuccess------'+sr.getId());
                return sr.getId();
            }
            else{
                system.debug('----inside sendApprovalToManager else=>error------');
                return 'error';
            }
        }else{
            system.debug('-----inside else null taskList[0].id -------'+taskList[0].id);
            return taskList[0].id;
        }
    }

    @AuraEnabled
    public static boolean checkApproval(string recId,string taskId){
        system.debug('---inside checkApproval recId ----'+recId);
        system.debug('---inside checkApproval taskId ----'+taskId);

            Task t = [SELECT Status FROM Task WHERE id=:taskId];
            if(t.Status == 'Completed'){
                return true;
            }else{
                return false;
            }
    }

    public class leadWrapper{
        @AuraEnabled public string leadname;
        @AuraEnabled public string OwnerName;
        @AuraEnabled public string phoneNumber;
        @AuraEnabled public string emailId;

    }
}