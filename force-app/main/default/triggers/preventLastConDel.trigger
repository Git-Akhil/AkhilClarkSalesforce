trigger preventLastConDel on Contact (before delete) {
    try{
        Set<ID> accountIds = new Set<ID>(); 
        for (Contact contact : Trigger.old) {
            accountIds.add(contact.AccountId);
        }
        system.debug('accountIds-----'+accountIds);
        
        list<Account> acc = [Select Id,Name,(Select id from Contacts) FROM Account where Id in: accountIds];
        system.debug('-----acc----'+acc);
        
        Map<Id,Decimal> aIdVsConCount = new Map<Id,Decimal>();
        for(account accObj : acc){
            aIdVsConCount.put(accObj.Id,accObj.contacts.size());
        }
        
        for (Contact contact: Trigger.old) {
            if(aIdVsConCount.get(contact.AccountId) == 1) {
                contact.addError('This contact is the last contact for its account and cannot be deleted');
            }
        }
    }
    
    catch(exception e){
        system.debug('Error in trigger'+e.getMessage());
        system.debug('Error in trigger---line number'+e.getlinenumber());
    }
    
}