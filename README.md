# Part 1 Deploy ERC20 locally (Must completed this part first):
1. Start Ganache
2. Click NEW WORKSPACE
3. In the SERVER section, set PORT NUMBER = 9545
4. In the ACCOUNTS&KEYS section, enter the following Mnemonic:
faculty cigar age pigeon rapid danger artwork frog carbon moral chalk squirrel
5. Click SAVE WORKSPACE
6. Start terminal
7. $ cd erc20_0
8. $ truffle migrate
9. Make sure the contract address of ERC20 is:
0xce4eaf69BB8cff422a7BFbd26496A6E6847de6d4
# Part 2 Buy tokens in Exchange Platform:
1. $ cd exchange-platform
2. $ bundle install
3. $ rails s
4. Go to 127.0.0.1:3000
5. Enter a valid wallet (i.e. choose one from the 2nd to 10th accounts in Ganache) and
click “Submit” button, which is next to the input.
6. Enter valid card information and click “Request Pay Method”
7. Enter a valid number of token (greater than 0) and click the “Submit” button, which
is next to the input.
8. Click the “Back” button to go back to the home page.
9. You should see that the available supply decreases and the number of tokens you
have increases.
10. Make sure you have enough tokens (e.g. 100) before using the e-commerce
platform.
# Part 3 Spend tokens in E-commerce Platform:
1. $ cd ecommerce-platform
2. $ bundle install
3. $ rails s
4. Go to 127.0.0.1:3000
5. Enter a valid wallet (i.e. choose one from the 2nd to 10th accounts in Ganache) and
click “Submit” button, which is next to the input.
6. Enter a valid number of item (integer greater than 0) and click the “Add to Cart”
button, which is next to the input.
7. At the bottom of the page, check the total cost of the cart. Make sure you have
enough tokens to purchase.
8. Click “Purchase” to buy the items.
11. Click the “Back” button to the home page.
12. You should see that the number of tokens you have decreases.
