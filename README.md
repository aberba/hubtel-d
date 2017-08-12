# hubtel-d (incomplete)

> ## Alert!
> This API was not fully implemented to support all Mpower API functionality 
> since the Mpower Payments platform was discontinued during development. I recommend you check out [Hubtels's unofficial D API](https://github.com/aberba/hubtel)

This was an unofficial Mpower Payments API for [D](https://dlang.org).

## Usage
Subtitute the information used in the example below with your own account information.

```d
import mpower;

void main()
{
	
    MPowerSetup apiSetup = new MPowerSetup();
    apiSetup.setMasterKey("dd6f2c90-f075-012f-5b69-00155d866600");
    apiSetup.setPrivateKey("test_private_oDLVld1eNyh0IsetdhdJvcl0ygA");
    apiSetup.setPublicKey("test_public_zzF3ywvX9DE-dSDNhUqKoaTI4wc");
    apiSetup.setToken("ca03737cf94wcf644f36"); 
    apiSetup.setMode(MPowerMode.test); //"test|live"

    MPowerCheckoutStore storeSetup = new MPowerCheckoutStore();
    storeSetup.setName("My Awesome Online storeSetup");
    storeSetup.setTagline("This is an awesome Java storeSetup.");
    storeSetup.setPhoneNumber("024000001");
    storeSetup.setPostalAddress("606 Memorylane Chokor no.1 Road.");
    storeSetup.setWebsiteUrl("http://my-awesome-long-website-url.com/");

    storeSetup.setCancelUrl("CHECKOUT_CANCEL_URL");
    storeSetup.setReturnUrl("CHECKOUT_RETURN_URL");

    MPowerCheckoutInvoice co = new MPowerCheckoutInvoice(apiSetup, storeSetup);
    co.addItem("Crate of Apeteshi", 2, 10.00, 20.00);
    co.addItem("50kg Bag of Sultana Rice",1, 78.50, 78.50);
    co.addItem("Book - Marriage of Anansewaa", 1, 10.00, 10.00);

    co.setTotalAmount(108.50);

    co.addTax("VAT (15)",50);
    co.addTax("NHIL (10)",50);

    co.addCustomData("Firstname","Alfred");
    co.addCustomData("Lastname","Rowe");
    co.addCustomData("CartId",929292872);

    import std.stdio: writeln;
    if(co.create()) {
       	writeln("Invoice URL: " ~ co.getInvoiceUrl());
    }
    else
    {
      	writeln("Error Occured: " ~ co.getResponseCode());
    }
}
```