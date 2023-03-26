library interface;
dep data_structures;
use data_structures::{Application};

abi BarterFi {
    #[storage(read, write)]
    fn initialize() -> Identity;

    #[storage(read)]
    fn check_admin(user: Identity) -> bool;

    #[storage(read)]
    fn check_application(application_id: u64) -> Application;

    #[storage(read, write)]
    fn apply_for_loan(barrower: Identity, requested_amount: u64, credit_score: u16) -> u64;

    #[storage(read, write)]
    fn approve_loan(application_id: u64, interest_rate: u8, collateral: u64);



    // #[storage(read, write), payable]
    // fn provide_collateral(application_id: u64);


    // #[storage(read, write)]
    // fn fund_loan() -> bool;

    // #[storage(read, write)]
    // fn estimate_interest() -> u64;
}

abi NativeAssetToken {
    #[storage(read, write)]
    fn mint_coins(mint_amount: u64);

    #[storage(read, write)]
    fn burn_coins(burn_amount: u64);

    #[storage(read, write)]
    fn force_transfer_coins(coins: u64, asset_id: ContractId, target: ContractId);

    #[storage(read, write)]
    fn transfer_coins_to_output(coins: u64, asset_id: ContractId, recipient: Address);

    #[storage(read, write)]
    fn deposit();

    #[storage(read, write)]
    fn get_balance(target: ContractId, asset_id: ContractId) -> u64;

    #[storage(read, write)]
    fn mint_and_send_to_contract(amount: u64, destination: ContractId);

    #[storage(read, write)]
    fn mint_and_send_to_address(amount: u64, recipient: Address);
}
