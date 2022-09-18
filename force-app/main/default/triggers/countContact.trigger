trigger countContact on Contact (after insert,after update,after delete) {
    if(Trigger.isinsert || Trigger.isupdate || Trigger.isdelete){
        try{
            set<id> accid = new set<id>();
            if(Trigger.New != null){
                for(Contact c: Trigger.New){
                    if(c.AccountId != null){
                        accid.add(c.AccountId);
                    }
                }
            }
            if(Trigger.Old != null){
                for(Contact c: Trigger.old){
                    if(c.AccountId != null){
                        accid.add(c.AccountId);
                    }
                }
            }
            
            list<Account> acc = [Select id,Name,noOfContacts__c,(Select id from Contacts) FROM Account where id in: accid];
            system.debug('-----acc----'+acc);
            if(acc != null){
                for(Account accValue: acc){
                    accValue.noOfContacts__c = accValue.Contacts.size();
                }
            }
            system.debug('-----acc----'+acc);
            if(acc != null){
                system.debug('-----acc----'+acc);
                update acc;
            }
        }
        catch(exception e){
            system.debug('Error in trigger'+e.getMessage());
            system.debug('Error in trigger---line number'+e.getlinenumber());
        }
    }
}