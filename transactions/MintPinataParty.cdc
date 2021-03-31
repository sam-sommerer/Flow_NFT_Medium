import PinataPartyContract from 0xf8d6e0586b0a20c7

transaction {
    let receiverRef: &{PinataPartyContract.NFTReciever}
    let minterRef: &PinataPartyContract.NFTMinter

    prepare(acct: AuthAccount) {
        self.receiverRef = acct.getCapability<&{PinataPartyContract.NFTReceiver}>(/public/NFTReceiver)
            .borrow()
            ?? panic("Could not borrow receiver reference")        
      
        self.minterRef = acct.borrow<&PinataPartyContract.NFTMinter>(from: /storage/NFTMinter)
            ?? panic("Could not borrow minter reference")
    }

    execute {
        let metadata : {String: String} = {
            "name": "The Big Swing",
            "swing_velocity": "29",
            "swing_angle": "45",
            "rating": "5",
            "uri": "ipfs://QmRBZA6zE7nPHLHSRKitAQkhDxpxidMzWEpJGUUumw3fvY"
        }

        let newNFT <- self.minterRef.mintNFT()

        self.receiverRef.deposit(token: <- newNFT, metadata: metadata)

        log("NFT Minted and deposited to Account 2's Collection")
    }
}