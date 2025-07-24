public with sharing class CreateAccount {
   @AuraEnabled
    public static Account createAccountImperatively(String name) {
        try{
            Account acc = new Account(Name = name);
            insert acc;
            return acc;

        }catch(Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException('Insert an Account Name');
        }
    }

}