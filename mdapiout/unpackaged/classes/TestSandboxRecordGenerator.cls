@isTest
class TestSandboxRecordGenerator {
    
    static testMethod void testGenerateRecords() {
        SandboxRecordGenerator testClass = new SandboxRecordGenerator();
        
        Test.testSandboxPostCopyScript (testClass,
                                        UserInfo.getOrganizationId(),
                                        UserInfo.getOrganizationId(), 
                                        'SampleDev');

        List<StockMaster__c> results = [SELECT Id FROM StockMaster__c];
        System.assert (0 < results.size());
    }
    
    static testMethod void testGenerateRecords2() {
    	SandboxRecordGenerator2 testClass = new SandboxRecordGenerator2();
    	
        Test.testSandboxPostCopyScript (testClass,
                                        UserInfo.getOrganizationId(),
                                        UserInfo.getOrganizationId(), 
                                        'SampleDev');

        List<StockMaster__c> results = [SELECT Id FROM StockMaster__c];
        System.assert (0 < results.size());    	
    }
    
    static testMethod void testGenerateRecords3() {
    	SandboxRecordGenerator3 testClass = new SandboxRecordGenerator3();
    	
    	
        Test.testSandboxPostCopyScript (testClass,
                                        UserInfo.getOrganizationId(),
                                        UserInfo.getOrganizationId(), 
                                        'SampleDev');

        List<StockMaster__c> results = [SELECT Id FROM StockMaster__c];
    }
}