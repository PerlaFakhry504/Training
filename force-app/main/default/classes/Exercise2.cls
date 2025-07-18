public with sharing class Exercise2 {
    public static void updateAccountContactCounts(List<Contact> newList, Map<Id, Contact> oldMap) {
        
        Set<Id> accountIdsSet = new Set<Id>();
        for (Contact ctc : newList) {
            if(ctc.AccountId != null && ( oldMap == null || (oldMap.containsKey(ctc.Id) &&(ctc.FirstName != oldMap.get(ctc.Id).FirstName || ctc.LastName != oldMap.get(ctc.Id).LastName)))) {
                accountIdsSet.add(ctc.AccountId);
            }
        }

        List<Account> accounts = [SELECT Id, (SELECT Id FROM Contacts WHERE FirstName = null OR LastName = 'Smith') FROM Account WHERE Id IN :accountIdsSet];

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : accounts) {
            Integer count = acc.Contacts.size();
            acc.Contact_Occurences__c = count;
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}