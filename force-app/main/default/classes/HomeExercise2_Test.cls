@isTest
public class Exercise2_Test {

    @isTest
    static void testContacts () {
       
        Account acc = new Account(Name = 'Acme');
        insert acc;

        Contact c1 = new Contact(LastName = 'Smith', AccountId = acc.Id);
        Contact c2 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
        Contact c3 = new Contact(LastName = 'Brown', AccountId = acc.Id);
        
         insert new List<Contact>{c1, c2, c3};
        
        acc = [SELECT Contact_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2, acc.Contact_Occurences__c, 'Error , we expected only 2 since we have only 2 contacts that matchs the criteria');
        c3.FirstName='hanna';
        update c3;
        acc = [SELECT Contact_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2, acc.Contact_Occurences__c, 'Error , we expected only 2 since we have only 2 contacts that matchs the criteria');
        

    }
}