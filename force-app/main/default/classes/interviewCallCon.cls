public class interviewCallCon {

    @auraEnabled
    public static string getConvertedOpp(string recId){
        
        Lead l = [SELECT id,ConvertedopportunityId FROM Lead WHERE id=:recID];
        
        if(l.ConvertedopportunityId != null){
            Opportunity opp = new Opportunity();
            opp.id = l.ConvertedopportunityId;
            opp.StageName = 'Interview';
            update opp;
            return l.ConvertedOpportunityId;
        }else{
            return '';
        }
        
    }

    @auraEnabled
    public static leadWrapper getLeadData(string recId){
       Lead l = [SELECT id,Name,owner.name,Phone,email FROM Lead WHERE id=:recID];
       leadWrapper lw = new leadWrapper();
       lw.leadname = l.name;
       lw.ownerName = l.owner.name;
       lw.phoneNumber = l.Phone;
       lw.emailId = l.email;
       return lw;
    }

    @auraEnabled
    public static boolean sendInfoMail(string recId){
        Lead l = [SELECT id,Name,owner.name,Phone,email FROM Lead WHERE id=:recID];

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { l.email };
        message.subject = 'TaxRise Info';
        message.plainTextBody = 'Hi This is TaxRise';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        /*if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }*/
        return true;
    }
    
    @auraEnabled
    public static String sendEmailVerification(string recId){
        Lead l = [SELECT id,Name,owner.name,Phone,email FROM Lead WHERE id=:recID];
        String rendomCode =  string.valueOf(Math.round((Math.random() * (9000) + 1000)));

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { l.email };
        message.subject = 'TaxRise Verification Code';
        message.plainTextBody = 'hello,'+l.name+' Your verification code is '+rendomCode;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        /*if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }*/
        return rendomCode;
    }

    @auraEnabled
    public static string sendApprovalToManager(string recId){
        List<task> taskList = [SELECT id FROM Task WHERE whoid=:recid and OwnerId=:UserInfo.getUserId()];
        if(taskList != null){
            task t = new Task();
            t.WhoId = recId;
            t.Subject = 'Request for approval';
            t.Status = 'Open';
            t.OwnerId = UserInfo.getUserId();
            Database.SaveResult sr = Database.insert(t);
            if(sr.isSuccess()){
                return sr.getId();
            }
            else{
                return 'error';
            }
        }else{
            return taskList[0].id;
        }
    }

    @auraEnabled
    public static boolean checkApproval(string recId, string taskId){
       Task t = [SELECT Status FROM task WHERE id=:taskId];
       if(t.status == 'Completed'){
            return true;
       }else{
           return false;
       }
    }

    @auraEnabled
    public static string updateDoNotCall(string recId){
       Lead l = new Lead();
       l.id = recId;
       l.Do_Not_Call__c = true;
       Database.SaveResult sr = Database.update(l);
        if(sr.isSuccess()){
            return sr.getId();
        }
        else{
            return 'error';
        }
    }

    @auraEnabled
    public static string reScheduleCall(string recId, Datetime dateTm){
       Lead l = new Lead();
       l.id = recId;
       l.Reschedule_Date__c = dateTm;
       Database.SaveResult sr = Database.update(l);
        if(sr.isSuccess()){
            return sr.getId();
        }
        else{
            return 'error';
        }
    }

    public class leadWrapper{
        @AuraEnabled public string leadname;
        @AuraEnabled public string ownerName;
        @AuraEnabled public string phoneNumber;
        @AuraEnabled public string emailId;
    }
}