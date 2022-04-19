class EarphonesController < ApplicationController
  before_action :set_earphone, only: [:show, :edit, :update, :destroy]
  before_action :makeCart, if: :cartMissing
  before_action :setup_erc20

  # GET /earphones
  # GET /earphones.json
  def index
    #Get product list
    @earphones = Earphone.all
    #Get total cost of shopping cart
    session[:total] = session[:cart][0].to_i*10+session[:cart][1].to_i*7+session[:cart][2].to_i*11
    #Get the number of tokens of the input wallet
    if (!@contract.nil?) && (!session[:wallet].nil?)
      begin
        session[:available] = @contract.call.balance_of(session[:wallet])
      rescue
        session[:available] = nil
      end
    else
      session[:available] = nil
    end
  end

  def purchase
    #Handle the case when the cart contains 0 item
    if session[:total] == 0
      @message = "No item in the cart"
    #Handle the case when the user does not enter the wallet
    elsif session[:available].nil?
      @message = "Please enter your wallet"
    #Handle the case when the user does not have enough tokens to purchase
    elsif session[:available] < session[:total]
      @message = "Not enough token"
    #Perform transaction
    else
      @result = @contract.transact_and_wait.transfer("0x1C5E2767a2Ef7c678e49D00b97CbFFDC7F1E4A57",session[:total])
      #Handle the successful case
      if (@result.mined?)
        makeCart
        @message = "Thank you"
      #Handle the unsuccessful case
      else
        @message = "Failed"
      end
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
    #Clear the input wallet
    session[:wallet] = nil
    #Clear the created contract since the contract was created using a old wallet
    @contract = nil
    redirect_to "http:localhost:3000/"
  end

  def addToCart
    #Adjust the product index
    index = params[:index].to_i - 1
    amount = params[:amount].to_i
    #Add product to the cart
    session[:cart][index] += amount
    redirect_to "http:localhost:3000/"
  end

  def makeCart
    #Create and initialize a cart in session
    session[:cart] = [0,0,0]
  end

  def clearCart
    #Simply call makeCart to set the number of each product to 0.
    makeCart
    redirect_to "http:localhost:3000/"
  end

  def cartMissing
    if session[:cart].nil?
      return true
    else
      return false
    end
  end


  # GET /earphones/1
  # GET /earphones/1.json
  def show
  end

  # GET /earphones/new
  def new
    @earphone = Earphone.new
  end

  # GET /earphones/1/edit
  def edit
  end

  # POST /earphones
  # POST /earphones.json
  def create
    @earphone = Earphone.new(earphone_params)

    respond_to do |format|
      if @earphone.save
        format.html { redirect_to @earphone, notice: 'Earphone was successfully created.' }
        format.json { render :show, status: :created, location: @earphone }
      else
        format.html { render :new }
        format.json { render json: @earphone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /earphones/1
  # PATCH/PUT /earphones/1.json
  def update
    respond_to do |format|
      if @earphone.update(earphone_params)
        format.html { redirect_to @earphone, notice: 'Earphone was successfully updated.' }
        format.json { render :show, status: :ok, location: @earphone }
      else
        format.html { render :edit }
        format.json { render json: @earphone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /earphones/1
  # DELETE /earphones/1.json
  def destroy
    @earphone.destroy
    respond_to do |format|
      format.html { redirect_to earphones_url, notice: 'Earphone was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_earphone
      @earphone = Earphone.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def earphone_params
      params.require(:earphone).permit(:title, :image, :price)
    end
    
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
        @client.default_account = session[:wallet]
        @contract = Ethereum::Contract.create(client: @client, name: "ERC20", address: "0xce4eaf69BB8cff422a7BFbd26496A6E6847de6d4", abi: @abi)
    end
end
