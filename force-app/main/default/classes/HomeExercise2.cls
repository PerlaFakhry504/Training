public with sharing class HomeExercise2 {
    public static void CountContactOccurences(List <Contact> newList , Map<Id,Contact> oldMap ){
        Set <Id> AccountIds = new Set<Id>();
        for ( Contact cntct : newList ) {
            if (
            (
            (oldMap==null) 
                || 
            (cntct.FirstName != oldMap.get(cntct.Id).FirstName) 
                || 
            (cntct.LastName != oldMap.get(cntct.Id).LastName) 
            )
                &&
            (cntct.FirstName == Null || cntct.LastName == 'Smith')
            )
            AccountIds.add(cntct.AccountId);
        }
        
        List<Account> accountsList =[SELECT Id, ( SELECT Id FROM Contacts WHERE LastName = 'Smith' OR FirstName = Null )
                                    FROM Account 
                                    WHERE Id in :AccountIds ];
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Account acc : accountsList){
            Integer Count = acc.Contacts.size();
            acc.Contact_Occurences__c = Count ;
            accountsToUpdate.add(acc);
        }
        
        update accountsToUpdate;
    }
}