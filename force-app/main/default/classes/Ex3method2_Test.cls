@isTest
private class Ex3method2_Test {

    @testSetup
    static void setupTestData() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Opportunity opp = new Opportunity( Name = 'Test Opp', StageName = 'Prospecting', 
        CloseDate = Date.today(), AccountId = acct.Id );
        insert opp;

        Quote__c quote = new Quote__c(Name = 'Test Quote', Opportunity__c = opp.Id );
        insert quote;
    }

    @isTest 
    static void testDuplicateQuoteError() {

        Account acct = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Quote__c quote = [SELECT Id FROM Quote__c WHERE Name = 'Test Quote' LIMIT 1];
        
    
        insert new Competitor__c( Name = 'First Comp', Account__c = acct.Id , Quote__c = quote.Id );
        
        try {
            insert new Competitor__c (Name = 'Second Comp', Account__c = acct.Id, Quote__c = quote.Id );
            System.assert(false, 'Should have thrown an exception for duplicate Quote');

        } catch (DmlException e) {
            System.assert( e.getMessage().contains('mafik'));
        }
    }

    @isTest 
    static void testAssignCompetitorToAccount() {
        
        Account acct = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Quote__c quote = [ SELECT Id, Opportunity__c, Opportunity__r.Name FROM Quote__c WHERE Name = 'Test Quote' LIMIT 1 ];
        
        Competitor__c initial = new Competitor__c( Name = 'Initial Comp', Account__c = acct.Id, Quote__c   = quote.Id );
        insert initial;

        //i bring the created one and in assert if this one is empty means error
        Competitor__c compCreated = [ SELECT Id, Account__c, Quote__c FROM Competitor__c WHERE Id = :initial.Id];

        System.assertNotEquals(null, compCreated);
        System.assertEquals(acct.Id, compCreated.Account__c);
        System.assertEquals(quote.Id, compCreated.Quote__c);
        
    }
}
