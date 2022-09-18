public with sharing class LwcInterviewCallClass {

    @AuraEnabled
    public static List<contact> getContactList(string idRec){
        try {
            list<Contact> ListOfAccountContact = [SELECT id,name,email,phone,Title FROM contact WHERE AccountId =:idRec];
            System.debug('------ListOfAccountContact-----'+ListOfAccountContact);
            return ListOfAccountContact;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static accountWrapper getAccountName(string rId){
        try {
            account a = [SELECT Name FROM account where id=: rId];
            accountWrapper aw = new accountWrapper();
            aw.Name = a.Name;
            return aw;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class accountWrapper{
       @AuraEnabled public string Name;
    }

//----------------------------------------------------- using field set -----------------------------------------------------------------------------------------------

    @AuraEnabled
    public static string getFieldNameAndRecord(string idRecord){

        SObject sObj = (SObject)(Type.forName('Schema.Contact').newInstance());
        List<Schema.FieldSetMember> lstFSMember = sObj.getSObjectType().getDescribe().fieldSets.getMap().get('LwcContactFieldSet').getFields();
        system.debug('====== lstmember ====='+lstFSMember);

        List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet('LwcContactFieldSet','Contact');



        
        string query= 'SELECT ';
        system.debug('idRecord ====>' + idRecord);

        list<string> fieldNamelist = new list<string>();

        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
            system.debug('API Name ====>' + fieldSetMemberObj.getFieldPath()); //api name- field Name
            system.debug('Label ====>' + fieldSetMemberObj.getLabel());
            system.debug('Type ====>' + fieldSetMemberObj.getType());   //type - STRING,PICKLIST
            //[SELECT id,name,email,phone,Title FROM contact WHERE AccountId =:idRec]
            fieldNamelist.add(fieldSetMemberObj.getFieldPath());
            //query += fieldSetMemberObj.getFieldPath() + ', ';
        }

        System.debug('list<string> fieldNamelist +++++++++>>'+fieldNamelist);

        query += String.join(fieldNamelist, ', ') + ' FROM contact WHERE AccountId =\'' +idRecord+'\''; 
        system.debug('Query ==========>'+query);
        list<Sobject> ListOfContact = Database.query(query);
        system.debug('ListOfContact ==========>'+ListOfContact);
        //system.debug('ListOfContact typeof =========>'+typeof('ListOfContact'));

        Map<String, String> returnMap = new Map<String,String>();
        returnMap.put('ApifieldNamelist', JSON.serialize(fieldNamelist));
        returnMap.put('fieldLabel', JSON.serialize(lstFSMember));
        returnMap.put('fieldRecord', JSON.serialize(ListOfContact));

        return JSON.serialize(returnMap);
            
    }

    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
    Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
    system.debug(' Map<String, Schema.SObjectType> GlobalDescribeMap =======> '+GlobalDescribeMap);
    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
    system.debug(' Schema.SObjectType SObjectTypeObj =======> '+SObjectTypeObj);
    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    system.debug('Schema.DescribeSObjectResult DescribeSObjectResultObj=======> '+DescribeSObjectResultObj);

    system.debug('====>' + DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName));

    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
    System.debug('Schema.FieldSet fieldSetObj =====>'+fieldSetObj);

    List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
    system.debug('List<Schema.FieldSetMember> fieldSetMemberList ====>' + fieldSetMemberList);  


    string fieldSetMemberListLabel =  fieldSetObj.getLabel();
    system.debug('List<Schema.FieldSetMember> fieldSetMemberListLabel ====>' + fieldSetMemberListLabel); 

    return fieldSetObj.getFields(); 
    }  

    //-------------popup Field Update-------------------------------------------------------------------------------------

    // @AuraEnabled
    // public static Contact updateContact(Contact Con){
    //     System.debug('Con ========>'+con);
    //     update con;
    //     return con;
    // }
}