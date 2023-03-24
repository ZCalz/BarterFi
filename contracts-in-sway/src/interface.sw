library interface;

abi Barterfi {
    #[storage(read, write)]
    fn initialize();

    #[storage(read, write)]
    fn apply_for_loan(     
        barrower: Indentity,
        requested_amount: u64,
        credit_score: u16
    );

    #[storage(read, write)]
    fn approve_loan(application_id:u64, interest_rate: u64, collateral: u64);

    #[storage(read, write)]
    fn provide_collateral(application_id: u64);

    #[storage(read, write)]
    fn fund_loan() -> bool;

    #[storage(read, write)]
    fn estimate_interest() -> u64;
}

abi NativeAssetToken {
    fn mint_coins(mint_amount: u64);
    fn burn_coins(burn_amount: u64);
    fn force_transfer_coins(coins: u64, asset_id: ContractId, target: ContractId);
    fn transfer_coins_to_output(coins: u64, asset_id: ContractId, recipient: Address);
    fn deposit();
    fn get_balance(target: ContractId, asset_id: ContractId) -> u64;
    fn mint_and_send_to_contract(amount: u64, destination: ContractId);
    fn mint_and_send_to_address(amount: u64, recipient: Address);
}