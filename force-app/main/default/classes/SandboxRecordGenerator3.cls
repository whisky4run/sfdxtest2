global class SandboxRecordGenerator3 implements SandboxPostCopy {
    // Account name.
    static final String accName1 = 'チームA';
    static final String accName2 = 'チームB';

	
    
    // ProductModelMaster__c.ProductType__c (Picklist)
    static final String pickTypePC		= 'PC';
    static final String pickTypeKbd		= 'キーボード';
    static final String pickTypeMouse	= 'マウス';
    static final String pickTypeDisplay	= 'ディスプレイ';
    static final String pickTypeOther	= 'その他';

	// Obj01: Account を Insert する
	private void ins01_Accounts () {
		List<Account> acclist = new List<Account>();
		
		for (obj01_Account obj : o01_Accounts) {
			acclist.add (new Account (Name=obj.Name, Phone=obj.Phone));
		}
		
		if (acclist.size() > 0){
			insert acclist;
		}
	}
	
	// Obj02: Contact を Insert する（★ Account と関連付ける)
	private void ins02_Contacts () {
		List<Contact> conlist = new List<Contact>();
		String accName;
		
		for (obj02_Contact con : o02_Contacts) {
			accName = con.accName;
			Account acc = Database.query ('SELECT Id, Name FROM Account WHERE Name = :accName');
			if (acc != null) {
				conlist.add (new Contact (LastName=con.LastName, FirstName=con.FirstName, Email=con.Email, AccountId=acc.Id));
			}
		}
		
		if (conlist.size() > 0){
			insert conlist;
		}
	}

	// Obj03: ProductModelMaster__c を Insert する
	private void ins03_ProductModelMasters () {
		List<ProductModelMaster__c> pmlist = new List<ProductModelMaster__c>();
		
		for (obj03_ProductModelMaster pm : o03_Products) {
			pmlist.add (new ProductModelMaster__c (Name=pm.Name, Cost__c=pm.Cost, ProductType__c=pm.PType));
		}
		
		if (pmlist.size() > 0) {
			insert pmlist;
		}
	}

	// Obj04: StockMaster を Insert する（★ ProductModelMaster と関連付ける)
	private void ins04_StockMasters () {
		List<StockMaster__c> smlist = new List<StockMaster__c>();
		String	pmName;
		
		for (obj04_StockMaster sm : o04_StockMaster) {
			pmName = sm.ModelName;
			ProductModelMaster__c pm = Database.query ('SELECT Id, Name FROM ProductModelMaster__c WHERE Name = :pmName');
			if (pm != null) {
				smlist.add (new StockMaster__c (Name=sm.Name, Amount__c=sm.Amount, ProductModel__c=pm.Id));
			}
		}
		
		if (smlist.size() > 0){
			insert smlist;
		}
	}

    // ★投入データ記述用の内部クラスを作成する（投入するオブジェクトの数分）
    // 【オブジェクト01】 Account
    class obj01_Account {
    	// 投入するデータに合わせた型を定義する
    	String		Name;			// Name
    	String		Phone;			// Phone
    	String		BillingAddress;	// BillingAddress
    	
    	obj01_Account (String nm, String phoneNum, String addr) {
    		Name			= nm;
    		Phone			= phoneNum;
    		BillingAddress	= addr;
    	}    	
    }
    
    // 【オブジェクト02】 Contact
    class obj02_Contact {
    	// 投入するデータに合わせた型を定義する
    	String		accName;		// Account (Name)
    	String		LastName;		// LastName
    	String		FirstName;		// FirstName
    	String		Email;			// Email
    	
    	obj02_Contact (String acc, String lnm, String fnm, String em) {
    		accName		= acc;
    		LastName	= lnm;
    		FirstName	= fnm;
    		Email		= em;
    	}   	
    }
       
    // 【オブジェクト03】 ProductModelMaster__c
    class obj03_ProductModelMaster {
    	// 投入するデータに合わせた型を定義する
    	String		Name;	// Name
    	Integer		Cost;	// Cost__c
    	String		PType;	// ProductType__c
    	
    	// メソッドは不要でコンストラクタのみとする
    	obj03_ProductModelMaster (String nm, Integer cs, String pt){
    		Name	= nm;
    		Cost	= cs;
    		PType	= pt;
    	}
    }
    
    // 【オブジェクト04】StockMaster__c
    class obj04_StockMaster {
    	// 投入するデータに合わせた型を定義する
    	String		ModelName;	// ProductModel__c (Parent Name)
    	String		Name;		// Name
    	Integer		Amount;		// Amount__c
    	
    	// メソッドは不要でコンストラクタのみとする
    	obj04_StockMaster (String model, String nm, Integer am) {
    		ModelName	= model;
    		Name		= nm;
    		Amount		= am;
    	}
    }


	// DATA [Account]
	final static List<obj01_Account> o01_Accounts = new List<obj01_Account> {
		// Name (取引先名)		  Phone (電話番号)	　BillingAddress (請求先住所)
//		{'株式会社ヨド'			, '03-9999-5555'	, '東京都新宿区西新宿1-22-15'		}
//		{'バシ Inc.'				, '03-1234-9876'	, '東京都江戸川区江戸川6丁目'		
		new obj01_Account('株式会社ヨド'			, '03-9999-5555'	, '東京都新宿区西新宿1-22-15'),
		new obj01_Account('バシ Inc.'				, '03-1234-9876'	, '東京都江戸川区江戸川6丁目')
	};

	// DATA [Contact]
	final static List<obj02_Contact> o02_Contacts = new List<obj02_Contact> {
		// Account Name (★取引先名)	LastName	FirstName		Email
//		{'株式会社ヨド'			, 'たんとう'	, '太郎'		, 'sample@developer.com'	}
//		{'株式会社ヨド'			, 'じょうし'	, '次郎'		, 'sample22@developer.com'	}
//		{'バシ Inc.'				, 'ウシウシ'	, '三郎'		, 'developer@example.com'	}	
		new obj02_Contact('株式会社ヨド'			, 'たんとう'	, '太郎'		, 'sample@developer.com'		),
		new obj02_Contact('株式会社ヨド'			, 'じょうし'	, '次郎'		, 'sample22@developer.com'		),
		new obj02_Contact('バシ Inc.'				, 'ウシウシ'	, '三郎'		, 'developer@example.com'	)
	};

	// DATA [ProductModelMaster__c]
    final static List<obj03_ProductModelMaster> o03_Products = new List<obj03_ProductModelMaster> {
    	// Name 			  Cost__c	 ProductType__c (picklist)
/*		{'PC_その1'			,	2000,	pickTypePC		}
    	{'PC_その2'			,	1850,	pickTypePC		}
    	{'マウス_その1'		,	 350,	pickTypeMouse	}
    	{'マウス_その2'		,	 430,	pickTypeMouse	}
    	{'キーボード_A'		,	 620,	pickTypeKbd		}
    	{'キーボード_B'		,	 590,	pickTypeKbd		}
    	{'ディスプレイ_X'		,	1150,	pickTypeDisplay	}
    	{'ディスプレイ_Z'		,	1030,	pickTypeDisplay }
    	{'電源ケーブル'		,	  90,	pickTypeOther	}
    	{'USBケーブル'		,	 120,	pickTypeOther	}	*/
    	new obj03_ProductModelMaster('PC_その1'			,	2000,	pickTypePC),
    	new obj03_ProductModelMaster('PC_その2'			,	1800,	pickTypePC),
    	new obj03_ProductModelMaster('マウス_その1'		,	 350,	pickTypeMouse),
    	new obj03_ProductModelMaster('マウス_その2'		,	 430,	pickTypeMouse),
    	new obj03_ProductModelMaster('キーボード_A'		,	 620,	pickTypeKbd),
    	new obj03_ProductModelMaster('キーボード_B'		,	 590,	pickTypeKbd),
    	new obj03_ProductModelMaster('ディスプレイ_X'		,	1150,	pickTypeDisplay),
    	new obj03_ProductModelMaster('ディスプレイ_Z'		,	1030,	pickTypeDisplay),
    	new obj03_ProductModelMaster('電源ケーブル'		,	  90,	pickTypeOther),
    	new obj03_ProductModelMaster('USBケーブル'		, 	 120,	pickTypeOther)
    };

	final static String sufStock = '_Stock';
	
	// DATA [StockMaster__c]
	final static List<obj04_StockMaster> o04_StockMaster = new List<obj04_StockMaster> {
		// ProductName		 Name		 Amount__c
		// ★ProductName は ProductModelMaster で投入する Name のいずれかに合わせる必要がある
/*		{'PC_その1'			,	'PC1' + sufStock,			25	}
    	{'PC_その2'			,	'PC2' + sufStock,			40	}
    	{'マウス_その1'		,	'マウス_A' + sufStock,		60	}
    	{'キーボード_B'		,	'Keyboard_B' + sufStock,	95  }
    	{'ディスプレイ_Z'		,	'Display_Z' + sufStock,		30  }
    	{'USBケーブル'		,	'USB Cable' + sufStock,	   125  }		*/
    	new obj04_StockMaster('PC_その1'			,	'PC1' + sufStock,			25),
    	new obj04_StockMaster('PC_その2'			,	'PC2' + sufStock,			40),
    	new obj04_StockMaster('マウス_その1'		,	'マウス_A' + sufStock,		60),
    	new obj04_StockMaster('キーボード_B'		,	'Keyboard_B' + sufStock,	95),
    	new obj04_StockMaster('ディスプレイ_Z'		,	'Display_Z' + sufStock,		30),
    	new obj04_StockMaster('USBケーブル'		,	'USB Cable' + sufStock,	   125)
	};



    
    static final List<String> prdNames = new List<String>{	'PC_その1',
    														'マウス_その1', 
    														'キーボード_その1',
    														'ディスプレイ_その1',
    														'電源アダプタ_X'
    														};
    static final List<Integer> stkAmounts = new List<Integer> {25, 105, 90, 35, 170};
    
    
    
    
    global void runApexClass (SandboxContext context) {
 		ins01_Accounts();
 		ins02_Contacts();
 		ins03_ProductModelMasters();
 		ins04_StockMasters();
 /*   	
        List<inputProductModel> prdArray = new List<inputProductModel>();
    
    
    
        insertProductModel(prdArray);
        insertStockMaster(prdArray);
        insertAccount();
        insertContact();
 */
    }
/*    
    class inputProductModel {
    	String	inpName;
    	Integer	inpCost;
    	String	inpType;
    	
    	inputProductModel (String name, Integer cost, String type){
    		inpName	= name;
    		inpCost	= cost;
    		inpType = type;
    	}
    }
    
    class inputStockMaster {
    	String	inpName;
    	Integer	inpAmount;
    	Id		inpProdId;
    	
    	inputStockMaster (String name, Integer amount, Id prodId){
    		inpName	= name;
    		inpAmount = amount;
    		inpProdId = prodId;	
    	}
    }
    
    private void insertProductModel (List<inputProductModel> prdArray) {
        List<ProductModelMaster__c> pcmArray = new List<ProductModelMaster__c>();
        
        // Records for ProductModelMaster__c
        prdArray.add (new inputProductModel (prdNames[0], 500, pickTypePC));
        prdArray.add (new inputProductModel (prdNames[1], 150, pickTypeMouse));
        prdArray.add (new inputProductModel (prdNames[2], 170, pickTypeKbd));
        prdArray.add (new inputProductModel (prdNames[3], 230, pickTypeDisplay));
        prdArray.add (new inputProductModel (prdNames[4],  50, pickTypeOther));
        
        for (inputProductModel i : prdArray){
        	pcmArray.add (new ProductModelMaster__c (name=i.inpName, Cost__c=i.inpCost, ProductType__c=i.inpType));
        }
    
		if (pcmArray.size() > 0){ 	
	        insert pcmArray;			
		}       
    }
    
    private void insertStockMaster (List<inputProductModel> prdArray) {
        List<StockMaster__c> stcArray = new List<StockMaster__c>();
        List<inputStockMaster> inpstArray = new List<inputStockMaster>();
        Integer idx = 0;

		for (inputProductModel i : prdArray){
			String stType = i.inpType;
			ProductModelMaster__c prd = Database.query ('SELECT Id, Name, ProductType__c FROM ProductModelMaster__c WHERE ProductType__c = :stType');
			if (prd != null){
				inpstArray.add (new inputStockMaster (prd.Name + '_Stk', stkAmounts[idx++], prd.Id));
			}
		}
		
		for (inputStockMaster is : inpstArray){
			stcArray.add (new StockMaster__c (name=is.inpName, Amount__c=is.inpAmount, ProductModel__c=is.inpProdId));
		}
        
        if (stcArray.size() > 0){
            insert stcArray;
        }
    }
    
    private void insertAccount() {
        List<Account> accArray = new List<Account>();
        
        Account acc1 = new Account(name = accName1);
        accArray.add (acc1);
        Account acc2 = new Account(name = accName2);
        accArray.add (acc2);
        insert accArray;
    }
    
    private void insertContact() {
        List<Contact> conArray = new List<Contact>();
     
        Account acc1 = Database.query ('SELECT Id FROM Account WHERE name = :accName1');
        
        if (acc1 != null) {
            Contact con1 = new Contact(LastName = '担当者1', AccountId = acc1.Id);
            conArray.add (con1);
        }
        
        Account acc2 = Database.query ('SELECT Id FROM Account WHERE name = :accName2');
        
        if (acc2 != null) {
            Contact con2 = new Contact(lastname = '担当者2', AccountId = acc2.Id);
            conArray.add (con2);
        }
     
        if (conArray.size() > 0){       
            insert conArray;         
        }
    }
*/    
    
}