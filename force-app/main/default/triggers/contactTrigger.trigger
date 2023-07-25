trigger contactTrigger on Contact (After insert,After update,After delete) {
    Set<id> accids = new Set<id>();
    Set<id> Oldaccids = new Set<id>();
    list<Account> accountsToUpdate = New List<Account>();
    if(Trigger.isinsert){
        for(Contact con: Trigger.new){
            accids.add(con.accountid);
        }
        System.debug('Account ids'+accids);
        Map <id,Account> acctList= New map<Id,Account>([Select id,Contact_Count__c from Account where id in : accids]);
        System.debug('Account Map'+acctList);
        for(Contact con: Trigger.new){
            Account acc= acctList.get(con.AccountId);
            System.debug('Accounts'+acc);
            if(String.isEmpty(acc.Contact_Count__c))
                acc.Contact_Count__c ='0';
            acc.Contact_Count__c = String.valueof(Integer.valueOf(acc.Contact_Count__c) +1);
            acctList.put(con.AccountId,acc);
        }
        accountsToUpdate= acctList.values();
    }
    if(Trigger.isupdate){
        for(contact con: Trigger.new){
            accids.add(con.AccountId);
            Contact con2= Trigger.oldMap.get(con.id);
            if(con2.AccountId != con.AccountId){
              accids.add(con2.AccountId);
            }
        }
    }
    if(Trigger.isdelete){
        
    }
    if(accountsToUpdate != null && accountsToUpdate.size()>0){
        update accountsToUpdate;
    }
}