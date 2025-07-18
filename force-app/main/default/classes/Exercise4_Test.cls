@isTest
private class Exercise4_Test {

   @isTest
    static void modifyOfferIdentifier_TEST(){

        // Test Opportunity 1
        Opportunity opp1 = new Opportunity (Name = 'Test Opp1' , Identifier__c = 'OTP' , StageName='Prospecting' , CloseDate=Date.today());
        insert opp1;

        // Test Opportunity 2
        Opportunity opp2 = new Opportunity (Name = 'Test Opp2' , Identifier__c = 'STF', StageName='Prospecting' , CloseDate=Date.today());
        insert opp2;

        // Test Offers

        Opportunity opp1ToUse =[SELECT Id FROM Opportunity WHERE Id = :opp1.Id ];
        Opportunity opp2ToUse =[SELECT Id FROM Opportunity WHERE Id = :opp2.Id ];



        Offer__c off1 = new Offer__c ( Name = 'off1' ,  Opportunity__c = opp1Touse.Id);    
        insert off1; 
        Offer__c off1ToUse = [SELECT Offer_Identifier__c FROM Offer__c WHERE Id = :off1.Id];

        Offer__c off2 = new Offer__c ( Name = 'off2' ,  Opportunity__c = opp2Touse.Id);
        insert off2;
        Offer__c off2ToUse = [SELECT Offer_Identifier__c FROM Offer__c WHERE Id = :off2.Id];


        Offer__c off3 = new Offer__c ( Name = 'off3' ,  Opportunity__c = opp1Touse.Id);
        insert off3;
        Offer__c off3ToUse = [SELECT Offer_Identifier__c FROM Offer__c WHERE Id = :off3.Id];

       

        System.assertEquals('OTP-001', off1ToUse.Offer_Identifier__c);
        System.assertEquals('STF-001', off2ToUse.Offer_Identifier__c);
        System.assertEquals('OTP-002', off3ToUse.Offer_Identifier__c);

        


       
    }

}
