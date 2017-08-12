module mpower.setup;
enum MPowerMode {live, test}

class MPowerSetup {
	private {
		string privateKey;
	 	string publicKey;
	 	string masterKey;
	 	string token;
	 	MPowerMode mode;
	}

	enum string ROOT_URL_BASE = "https://app.mpowerpayments.com";

	enum string LIVE_CHECKOUT_INVOICE_BASE_URL = "/api/v1/checkout-invoice/create";
   	enum string TEST_CHECKOUT_INVOICE_BASE_URL = "/sandbox-api/v1/checkout-invoice/create";

   	enum string LIVE_CHECKOUT_CONFIRM_BASE_URL = "/api/v1/checkout-invoice/confirm/";
   	enum string TEST_CHECKOUT_CONFIRM_BASE_URL = "/sandbox-api/v1/checkout-invoice/confirm/";

	enum string LIVE_OPR_BASE_URL = "/api/v1/opr/create";
	enum string TEST_OPR_BASE_URL = "/sandbox-api/v1/opr/create";

	enum string LIVE_OPR_CHARGE_BASE_URL = "/api/v1/opr/charge";
	enum string TEST_OPR_CHARGE_BASE_URL = "/sandbox-api/v1/opr/charge";

	enum string LIVE_DIRECT_PAY_CREDIT_URL = "/api/v1/direct-pay/credit-account";
	enum string TEST_DIRECT_PAY_CREDIT_URL = "/sandbox-api/v1/direct-pay/credit-account";

	enum string LIVE_DIRECT_CREDITCARD_CHARGE_URL = "/api/v1/direct-card/processcard";
	enum string TEST_DIRECT_CREDITCARD_CHARGE_URL = "/sandbox-api/v1/direct-card/processcard";

	this (string masterKey, string privateKey, string publicKey, string token, MPowerMode mode) 
	{
		this.masterKey = masterKey;
		this.privateKey = privateKey;
		this.publicKey = publicKey;
		this.token = token;
		this.mode = mode;
	}

	this() {} // for construction without arguments

	void setMasterKey(string str)
	{
		this.masterKey = str;
	}

	string getMasterKey()
	{
		return this.masterKey;
	}


	void setPrivateKey(string str)
	{
		this.privateKey = str;
	}

	string getPrivateKey()
	{
		return this.privateKey;
	}

	void setPublicKey(string str)
	{
		this.publicKey = str;
	}

	string getPublicKey()
	{
		return this.publicKey;
	}


	void setToken(string str)
	{
		this.token = str;
	}

	string getToken()
	{
		return this.token;
	}


	void setMode(MPowerMode mode)
	{
		this.mode = mode;
	}

	MPowerMode getMode()
	{
		return this.mode;
	}

	string getCheckoutInvoiceUrl() 
	{
		if (this.mode == MPowerMode.live) 
		{
			return ROOT_URL_BASE ~ LIVE_CHECKOUT_INVOICE_BASE_URL;
		} else
		{
			return ROOT_URL_BASE ~ TEST_CHECKOUT_INVOICE_BASE_URL;
		}
	}

	string getCheckoutConfirmUrl() 
	{
		if (this.mode == MPowerMode.live) 
		{
			return ROOT_URL_BASE ~ LIVE_CHECKOUT_CONFIRM_BASE_URL;
		} else
		{
			return ROOT_URL_BASE ~ TEST_CHECKOUT_CONFIRM_BASE_URL;
		}
	}

	string getOPRInvoiceUrl() 
	{
		if (this.mode == MPowerMode.live) 
		{
			return ROOT_URL_BASE ~ LIVE_OPR_BASE_URL;
		} else
		{
			return ROOT_URL_BASE ~ TEST_OPR_BASE_URL;
		}
	}

	string getOPRChargeUrl() 
	{
		if (this.mode == MPowerMode.live) 
		{
			return ROOT_URL_BASE ~ LIVE_OPR_CHARGE_BASE_URL;
		} else
		{
			return ROOT_URL_BASE ~ TEST_OPR_CHARGE_BASE_URL;
		}
	}

	string getDirectPayCreditUrl() 
	{
		if (this.mode == MPowerMode.live) 
		{
			return ROOT_URL_BASE ~ LIVE_DIRECT_PAY_CREDIT_URL;
		} else 
		{
			return ROOT_URL_BASE ~ TEST_DIRECT_PAY_CREDIT_URL;
		}
	}

	string getDirectCreditcardChargeUrl() 
	{
		if (this.mode == MPowerMode.live) 
		{
			return ROOT_URL_BASE ~ LIVE_DIRECT_CREDITCARD_CHARGE_URL;
		} else
		{
			return ROOT_URL_BASE ~ TEST_DIRECT_CREDITCARD_CHARGE_URL;
		}
	}
}