@isTest
public class Exercise2_Test {

    @isTest
    static void testInsertContacts () {
       
        Account acc = new Account(Name = 'Acme');
        insert acc;

        Contact c1 = new Contact(LastName = 'Smith', AccountId = acc.Id);
        Contact c2 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
        Contact c3 = new Contact(LastName = 'Brown', AccountId = acc.Id);
        

         Test.startTest();
         insert new List<Contact>{c1, c2, c3};
         Test.stopTest();

        acc = [SELECT Contact_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals( 2, acc.Contact_Occurences__c, 'Error , we expected only 2 since we have only 2 contacts that matchs the criteria');

    }
    

   
    @isTest 
    private static void testUpdateContactNameChange() {
        Account acc = new Account(Name = 'ABC Labs');
        insert acc;
        Contact cntct = new Contact(LastName = 'Smith', AccountId = acc.Id);
        insert cntct;
       
        Test.startTest();
        Exercise2.updateAccountContactCounts(new List<Contact>{ cntct }, null);
        Test.stopTest();
        Integer result = [SELECT Contact_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, result ,'Error: only one contact matches the criteria');
        
        cntct.LastName = 'Jones';
        
        Test.startTest();
            update cntct;
        Test.stopTest();
        
        Integer result = [SELECT Contact_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals( 0, acc.Contact_Occurences__c, 'error: zero contacts match te criteria');
    }
}




