class IndexController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :setup_braintree
    before_action :setup_erc20
    def home
      #Create braintree token
        @client_token = @gateway.client_token.generate
        #Get the number of token supply
        @available = @contract.call.balance_of("0x1C5E2767a2Ef7c678e49D00b97CbFFDC7F1E4A57")
        # Get the numb erof token of input wallet
        if (session[:wallet].nil?)
          @own = nil
        else
          begin
            @own = @contract.call.balance_of(session[:wallet])
          rescue
            @own = nil
          end
        end
    end

    def purchase
      #Perform transaction
        @result = @gateway.transaction.sale(
            :amount => params[:price].to_f*params[:amount].to_f,
            :payment_method_nonce => params[:nonce]
        )
        #Check transaction status
        if (@result.success?)
            @message = "Thank you"
            @contract.transact_and_wait.transfer(session[:wallet],params[:amount].to_i)
        else
            @message = "Failed"
        end

    end

    def back
      #Redirect to home page
      redirect_to "http:localhost:3000/"
    end

    def getWallet
      #Store the input wallet in session
      session[:wallet] = params[:wallet]
      redirect_to "http:localhost:3000/"
    end
  
    def removeWallet
      #Remove the wallet
      session[:wallet] = nil
      redirect_to "http:localhost:3000/"
    end

    private
    def setup_braintree
      #Setup braintree gateway
        @gateway = Braintree::Gateway.new(
            :environment => :sandbox,
            :merchant_id => 'vgk27hng6x8dmvmt',
            :public_key => '3f4tmg5ydg22k94b',
            :private_key => '7ead927c31b0c53f89f37b553f946d50',
)
    end

    private
    def setup_erc20
      #Setup the contract
        @abi = [
            {
                "inputs": [],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "constructor"
              },
              {
                "anonymous": false,
                "inputs": [
                  {
                    "indexed": true,
                    "internalType": "address",
                    "name": "_owner",
                    "type": "address"
                  },
                  {
                    "indexed": true,
                    "internalType": "address",
                    "name": "_spender",
                    "type": "address"
                  },
                  {
                    "indexed": false,
                    "internalType": "uint256",
                    "name": "_value",
                    "type": "uint256"
                  }
                ],
                "name": "Approval",
                "type": "event"
              },
              {
                "anonymous": false,
                "inputs": [
                  {
                    "indexed": true,
                    "internalType": "address",
                    "name": "_from",
                    "type": "address"
                  },
                  {
                    "indexed": true,
                    "internalType": "address",
                    "name": "_to",
                    "type": "address"
                  },
                  {
                    "indexed": false,
                    "internalType": "uint256",
                    "name": "_value",
                    "type": "uint256"
                  }
                ],
                "name": "Transfer",
                "type": "event"
              },
              {
                "constant": true,
                "inputs": [],
                "name": "totalSupply",
                "outputs": [
                  {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                  }
                ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
              },
              {
                "constant": true,
                "inputs": [
                  {
                    "internalType": "address",
                    "name": "_owner",
                    "type": "address"
                  }
                ],
                "name": "balanceOf",
                "outputs": [
                  {
                    "internalType": "uint256",
                    "name": "balance",
                    "type": "uint256"
                  }
                ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
              },
              {
                "constant": false,
                "inputs": [
                  {
                    "internalType": "address",
                    "name": "_to",
                    "type": "address"
                  },
                  {
                    "internalType": "uint256",
                    "name": "_value",
                    "type": "uint256"
                  }
                ],
                "name": "transfer",
                "outputs": [
                  {
                    "internalType": "bool",
                    "name": "success",
                    "type": "bool"
                  }
                ],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "function"
              },
              {
                "constant": false,
                "inputs": [
                  {
                    "internalType": "address",
                    "name": "_from",
                    "type": "address"
                  },
                  {
                    "internalType": "address",
                    "name": "_to",
                    "type": "address"
                  },
                  {
                    "internalType": "uint256",
                    "name": "_value",
                    "type": "uint256"
                  }
                ],
                "name": "transferFrom",
                "outputs": [
                  {
                    "internalType": "bool",
                    "name": "success",
                    "type": "bool"
                  }
                ],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "function"
              },
              {
                "constant": false,
                "inputs": [
                  {
                    "internalType": "address",
                    "name": "_spender",
                    "type": "address"
                  },
                  {
                    "internalType": "uint256",
                    "name": "_value",
                    "type": "uint256"
                  }
                ],
                "name": "approve",
                "outputs": [
                  {
                    "internalType": "bool",
                    "name": "success",
                    "type": "bool"
                  }
                ],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "function"
              },
              {
                "constant": true,
                "inputs": [
                  {
                    "internalType": "address",
                    "name": "_owner",
                    "type": "address"
                  },
                  {
                    "internalType": "address",
                    "name": "_spender",
                    "type": "address"
                  }
                ],
                "name": "allowance",
                "outputs": [
                  {
                    "internalType": "uint256",
                    "name": "remaining",
                    "type": "uint256"
                  }
                ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
              }
        ]
        @client = Ethereum::HttpClient.new('http://127.0.0.1:9545')
        @contract = Ethereum::Contract.create(client: @client, name: "ERC20", address: "0xce4eaf69BB8cff422a7BFbd26496A6E6847de6d4", abi: @abi)
    end
end
