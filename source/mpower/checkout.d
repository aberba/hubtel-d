module mpower.checkout;

import mpower.setup;

import std.json;

enum HTTPStatus {ok=200}

struct MPowerUtility {
	MPowerSetup setup;

	this (MPowerSetup setup) {
		this.setup = setup;
	}

	JSONValue jsonRequest(string url, string payload) 
	{
		import requests;
		import std.conv: to;

		string output;

		Request req;
		Response res;

		try 
		{
			import std.stdio: writeln;
	
		    req = Request();
		    req.addHeaders([
		    	"Content-Type": "application/json",
	     	    "Content-Length": to!string(payload.length),
		      	"User-Agent": "MPower Checkout API D client v1",
				"mp-master-key": setup.getMasterKey(),
				"mp-private-key": setup.getPrivateKey(),
				"mp-public-key": setup.getPublicKey(),
				"mp-token": setup.getToken(),
				"mp-mode": setup.getMode() == MPowerMode.live ? "live" : "test"
				]);

		    writeln("resuesting ...");
	 
		    res = req.post(url, payload, "application/x-www-form-urlencoded");

		    writeln ("Response: ", res);

		    if (res.code != HTTPStatus.ok /*&& status != HttpURLConnection.HTTP_OK */) 
		    {
		        throw new Exception("Failed : HTTP error code : " ~ to!string(res.code));
		    }

		    output = to!string(res.responseBody);
	    } 
	    catch (Exception e) 
	    {
	 		import std.stdio: writeln;
	 		writeln("Exception in jsonRequest(): ", e.msg);
		}

		return parseJSON(output);
	}

	JSONValue getRequest(string url) 
	{
		import requests;
		import std.conv: to;

		Request req;
		Response res;
		string output;

		try 
		{
	
		   	req = Request();
		    req.addHeaders([
		    	"Content-Type": "application/json",
		      	"User-Agent": "MPower Checkout API D client v1",
				"mp-master-key": setup.getMasterKey(),
				"mp-private-key": setup.getPrivateKey(),
				"mp-public-key": setup.getPublicKey(),
				"mp-token": setup.getToken(),
				"mp-mode": setup.getMode() == MPowerMode.live ? "live" : "test"
				]);
	 
	 		res = req.get(url);

			if (res.code != HTTPStatus.ok /*&& status != HttpURLConnection.HTTP_OK */) 
			{
		        throw new Exception("Failed : HTTP error code : " ~ to!string(res.code));
		    }
	    } 
	    catch (Exception e) 
	    {
	 		import std.stdio: writeln;
	 		writeln("Exception in getRequest(): ", e.msg);
		}
 			
		return JSONValue(to!string(res.responseBody));
	}
}

public class MPowerCheckoutStore {
  	private {
  		string name = "Untitled Store";
  		string tagline;  
  		string postalAddress;  
  		string phoneNumber;  
  		string logoUrl;
  		string websiteUrl;
  		string returnUrl;
  		string cancelUrl;
  	}

	this(string name, string tagline)
	{
		this.setName(name);
		this.setTagline(tagline);
	}

	this(string name) 
	{
		this.setName(name);
	}

	this() {}

	void setName(string name)
	{
		this.name = name;
	}

	string getName()
	{
		return this.name;
	}


	void setTagline(string tagline)
	{
		this.tagline = tagline;
	}

	string getTagline()
	{
		return this.tagline;
	}


	void setPostalAddress(string postalAddress)
	{
		this.postalAddress = postalAddress;
	}

	string getPostalAddress()
	{
		return this.postalAddress;
	}


	void setPhoneNumber(string phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	string getPhoneNumber()
	{
		return this.phoneNumber;
	}


	void setWebsiteUrl(string websiteUrl)
	{
		this.websiteUrl = websiteUrl;
	}

	string getWebsiteUrl()
	{
		return this.websiteUrl;
	}


	void setLogoUrl(string logoUrl){
		this.logoUrl = logoUrl;
	}

	string getLogoUrl(){
		return this.logoUrl;
	}


	void setCancelUrl(string cancelUrl){
		this.cancelUrl = cancelUrl;
	}

	string getCancelUrl(){
		return this.cancelUrl;
	}


	void setReturnUrl(string returnUrl){
		this.returnUrl = returnUrl;
	}

	string getReturnUrl(){
		return this.returnUrl;
	}

	JSONValue getSettings() {
		auto settings = 
			[
				"name": JSONValue(this.getName()),
				"tagline": JSONValue(this.getTagline()),
				"postal_address": JSONValue(this.getPostalAddress()),
				"phone": JSONValue(this.getPhoneNumber()),
				"logo_url": JSONValue(this.getLogoUrl()),
				"website_url": JSONValue(this.getWebsiteUrl())
			];
		return JSONValue(settings);
	}
}


class MPowerCheckout {
	string responseText;
	string responseCode;
	string status;
  	string token;
  	string transactionId;
  	string description;

  	static string SUCCESS = "success";
  	static string FAIL = "fail";
  	static string COMPLETED = "completed";
  	static string PENDING = "pending";

  	string getStatus() {
    	return this.status;
  	}

  	string getResponseText() {
    	return this.responseText;
  	}

  	string getResponseCode() {
    	return this.responseCode;
  	}

  	string getToken() {
    	return this.token;
  	}

  	string getTransactionId() {
    	return this.transactionId;
  	}

  	string getDescription() {
    	return this.description;
  	}
}


class MPowerCheckoutInvoice: MPowerCheckout {

	protected {
		JSONValue invoice;
		JSONValue actions;
  		JSONValue items;
  		JSONValue customData;
  		JSONValue customer;
  		JSONValue taxes;
  		
  		int itemsCount = 0;
  		int taxesCount = 0;
  		double totalAmount = 0.0;
  		string currency = "ghs";
  		string description;
  		string cancelUrl;
  		string returnUrl;
  		string invoiceUrl;
  		string receiptUrl;
  		
  		MPowerSetup setup;
  		MPowerCheckoutStore store;
  		MPowerUtility utility;
  	}
	
	this (MPowerSetup setup, MPowerCheckoutStore store) 
	{
		this.setup = setup;
		this.store = store;
		this.utility = MPowerUtility(setup);
		this.cancelUrl = store.getCancelUrl();
		this.returnUrl = store.getReturnUrl();

		// FIX: Get rid of these with proper JSON object initialization
		items = JSONValue(["item_1": 2]);
		taxes = JSONValue(["tax_1": 2]);
		invoice = JSONValue(["items": 2]);
		customData = JSONValue(["time": 1]);
	}

	void setTotalAmount(double amount) 
	{
		this.totalAmount = amount;
	}

	double getTotalAmount() 
	{
		return this.totalAmount;
	}


	void setReturnUrl(string url) 
	{
		this.returnUrl = url;
	}

	string getReturnUrl() 
	{
		return this.returnUrl;
	}


	void setCancelUrl(string url) 
	{
		this.cancelUrl = url;
	}

	string getCancelUrl() 
	{
		return this.cancelUrl;
	}


	void setInvoiceUrl(string url) 
	{
		this.invoiceUrl = url;
	}

	string getInvoiceUrl() 
	{
		return this.invoiceUrl;
	}


	void setReceiptUrl(string url) 
	{
		this.receiptUrl = url;
	}

	string getReceiptUrl() 
	{
		return this.receiptUrl;
	}


	void setDescription(string description) 
	{
		this.description = description;
	}

	//string getDescription() 
	//{
	//	return this.description;
	//}

	string getItems() 
	{
		return this.items.toString();
	}

	string getTaxes() 
	{
		return this.taxes.toString();
	}

	JSONValue getCustomData(string key) 
	{
		return this.customData[key];
	}

	JSONValue getCustomerInfo(string key) 
	{
		return this.customer[key];
	}

	void addItem(string name, int quantity, double unitPrice, double totalPrice) 
	{
		import std.conv: to;

		JSONValue item = JSONValue([
			"name": JSONValue(name),
			"quantity": JSONValue(quantity),
			"unit_price": JSONValue(unitPrice),
			"total_price": JSONValue(totalPrice),
		]);

		this.items.object["item_" ~ to!string(this.itemsCount)] = item;
		this.itemsCount += 1;
	}

	void addItem(string name, int quantity, double unitPrice, double totalPrice, string description) 
	{
		import std.conv: to;

		auto item = [
			"name": JSONValue(name),
			"quantity": JSONValue(quantity),
			"unit_price": JSONValue(unitPrice),
			"total_price": JSONValue(totalPrice),
			"description": JSONValue(description),
		];

		this.items.object["item_" ~ to!string(itemsCount)] = JSONValue(item);
		this.itemsCount += 1;
	}

	void addTax(string name, double amount) 
	{
		import std.conv: to;

		JSONValue tax = [
			"name": JSONValue(name),
			"quantity": JSONValue(amount),
		];

		this.taxes.object["tax_" ~ to!string(this.taxesCount)] = JSONValue(tax);
		this.taxesCount += 1;
	}

	void addCustomData(string key, string data) 
	{
		this.customData.object[key] = JSONValue(data);
	}

	void addCustomData(string key, int data)
	{
		this.customData.object[key] = JSONValue(data);
	}

	bool create() 
	{
		bool isSuccess = false;
		this.invoice.object["items"] = JSONValue(this.items);
		this.invoice.object["taxes"] = JSONValue(this.taxes);
		this.invoice.object["total_amount"] = JSONValue(this.getTotalAmount());
		this.invoice.object["description"] = JSONValue(this.getDescription());

		auto payload = JSONValue([
			"invoice": JSONValue(this.invoice),
			"store": JSONValue(this.store.getSettings())
			]);

		auto actions = JSONValue([
			"cancel_url": JSONValue(this.getCancelUrl()),
			"return_url": JSONValue(this.getReturnUrl())
			]);

		payload.object["actions"] = JSONValue(actions);

		JSONValue /* result = JSONValue(["item_1": 2]); */
		result = utility.jsonRequest
		(setup.getCheckoutInvoiceUrl(), payload.toString());

		if (!result.isNull()) 
		{
			this.responseText = result["response_text"].str;
			this.responseCode = result["response_code"].str;
			
			if (this.responseCode == "00") 
			{
				this.token = result["token"].str;
				this.responseText = result["description"].str;
				this.setInvoiceUrl( result["response_text"].str);
				this.status = this.SUCCESS;
				isSuccess = true;
			} 
			else 
			{
				this.status = this.FAIL;
				isSuccess = false;
			}
		}

		return isSuccess;
	}

	bool confirm(string token) 
	{
		import std.conv: to;
		JSONValue  jsonData = utility.getRequest(setup.getCheckoutConfirmUrl() ~ token);

		bool  isSuccess = false;

		/// fix empty results
		if (jsonData != JSONValue.init && jsonData.type == JSON_TYPE.OBJECT) 
		{
			if (jsonData["status"].toString() == this.COMPLETED) {
				invoice = JSONValue(jsonData["invoice"]);
				this.status = jsonData["status"].toString();
				this.setReceiptUrl(jsonData["receipt_url"].toString());
				this.customData = JSONValue(jsonData["custom_data"]);
				this.customer = JSONValue(jsonData["customer"]);
				this.taxes = JSONValue(invoice["taxes"]);
				this.items = JSONValue(invoice["items"]);
				this.setTotalAmount( to!bool(invoice["total_amount"].toString()) );
				this.responseText = "Checkout Invoice has been paid";
				this.responseCode = "00";
				isSuccess = true;
			} 
			else 
			{
				invoice = JSONValue(jsonData["invoice"]);
				this.status = jsonData["status"].toString();
				this.setReceiptUrl( jsonData["receipt_url"].toString() );
				this.customData = JSONValue(jsonData["custom_data"]);
				this.customer = JSONValue(jsonData["customer"]);
				this.taxes = JSONValue(invoice["taxes"]);
				this.items = JSONValue(invoice["items"]);
				this.setTotalAmount( to!double(invoice["total_amount"].toString()) );
				this.responseText = "Checkout Invoice has not been paid";
				this.responseCode = "1003";
			}
		} 
		else 
		{
			this.responseText = "Invoice Not Found";
			this.responseCode = "1002";
			this.status = this.FAIL;
		}

		return isSuccess;
	}
}