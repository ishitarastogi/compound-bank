# MINT

The mint function transfers an asset into the protocol, which begins accumulating interest based on the current Supply Rate for the asset.

 The user receives a quantity of cTokens equal to the underlying tokens supplied, divided by the current Exchange Rate.

If you know the exchange rate, divide your current currency by the exchange rate. For example, suppose that the USD/EUR exchange rate is 0.631 and you'd like to convert 100 USD into EUR.To accomplish this, simply multiply the 100 by 0.631 and the result is the number of EUR that you will receive: 63.10 EUR.

CErc20
```
function mint(uint mintAmount) returns (uint)
```
1. msg.sender: The account which shall supply the asset, and own the minted cTokens.
2. mintAmount: The amount of the asset to be supplied, in units of the underlying asset.
3. RETURN: 0 on success, otherwise an Error code

Before supplying an asset, users must first approve the cToken to access their token balance.


# Redeem
The redeem function converts a specified quantity of cTokens into the underlying asset, and returns them to the user. The amount of underlying tokens received is equal to the quantity of cTokens redeemed, multiplied by the current Exchange Rate. The amount redeemed must be less than the user's Account Liquidity and the market's available liquidity.



# Depositing money to Compound
Let’s start using the functions that we’ve defined in the interface.

We’ll modify our addBalance method.

The way to deposit ethers to compound is to use the mint() function.

If you notice the signature of this function in our interface, it is a payable function. That means we can send ethers to this function.
script fish area plastic year flash produce degree motion flash ceiling learn


Note that we’re not only calling ceth.mint() but also sending ethers by setting the value for this function call by using { value : msg.value }.

This means that we will send all the ethers that the user sends to addBalance directly to compound.

Before we change the other two functions getBalance and withdraw, we need to understand how Compound works.

When you deposit ETH using the mint() function, Compound generates some cETH for you. You can then give cETH to Compound and get back ETH.

Compound exposes how many cETH a certain user holds using the function balanceOf. It also exposes the number of ETH you can withdraw per cETH using exchangeRateStored. exchangeRateStored keeps steadily increasing, that’s how you earn interest on Compound. 1cETH keeps getting more valuable over time. If it returns 1ETH right now it will yield 1.00….01 ETH a couple minutes later.

We want to abstract the user from all these complications. They needn’t know that we’re using Compound internally to generate the interest. So we will take care of this calculation for them.

The current balance that a user can withdraw is the number of cETH they own multiplied by the exchange rate. Solidity doesn’t support floats and doubles. So exchangeRateStored is represented as an integer that must be divided by 10^18.

Let’s modify the getBalance function.



Now let’s try to deploy this and see it in action.

ceth.balanceOf() gives us the number of cETH the user owns

ceth.exchangeRateStored() gives us the number of ETH we’ll get per cETH

