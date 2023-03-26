use fuels::{prelude::*, tx::ContractId,types::Identity};
// Load abi from json
abigen!(Contract(
    name = "BarterFi",
    abi = "out/debug/contracts-in-sway-abi.json"
));

async fn get_contract_instance() -> (BarterFi, ContractId, WalletUnlocked, WalletUnlocked) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(2),             /* Two wallets */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();
    let wallet_2 = wallets.pop().unwrap();

    let id = Contract::deploy(
        "./out/debug/contracts-in-sway.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/contracts-in-sway-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = BarterFi::new(id.clone(), wallet.clone());

    (instance, id.into(), wallet, wallet_2)
}

#[tokio::test]
async fn deployer_is_an_admin() {
    let (_instance, _id, _deployer, _user) = get_contract_instance().await;
    let deployer = Identity::Address(Address::from(_deployer.address()));
    // Now you have an instance of your contract you can use to test each function
    let result = _instance
        .methods()
        .initialize()
        .call()
        .await
        .unwrap();
    //assert deployer is admin
    assert_eq!(deployer, result.value);
    let result = _instance
        .methods()
        .check_admin(deployer)
        .call()
        .await
        .unwrap();
    assert_eq!(true, result.value);
}

#[tokio::test]
async fn can_apply_for_loan() {
    let (_instance, _id, _deployer, _user) = get_contract_instance().await;
    let applicant = Identity::Address(Address::from(_user.address()));
    let credit_score: u16 = 760;
    let requested_amount: u64 = 1_000_000;

    let result = _instance
        .methods()
        .apply_for_loan(applicant.clone(),requested_amount.clone(), credit_score.clone())
        .call()
        .await
        .unwrap();

    let application_id = result.value;

    let result = _instance
    .methods()
    .check_application(application_id)
    .call()
    .await
    .unwrap();

    let application = result.value;

    assert_eq!(application.barrower, applicant);
    assert_eq!(application.requested_amount, requested_amount);
    assert_eq!(application.credit_score, credit_score);
}

#[tokio::test]
async fn admin_can_approve_loan() {
    let (_instance, _id, _deployer, _user) = get_contract_instance().await;
    // let deployer = Identity::Address(Address::from(_deployer.address()));
    let applicant = Identity::Address(Address::from(_user.address()));
    let credit_score: u16 = 760;
    let requested_amount: u64 = 1_000_000;

    let result = _instance
        .methods()
        .apply_for_loan(applicant,requested_amount, credit_score)
        .call()
        .await
        .unwrap();

    let application_id = result.value;

    let result = _instance
        .methods()
        .check_application(application_id)
        .call()
        .await
        .unwrap();
    let application = result.value;
    assert_eq!(ApplicationState::Pending, application.state);

    //approve loan
    let interest_rate: u8 = 2; //percentage
    let collateral: u64 = 400_000;
    _instance
        .with_wallet(_deployer).expect("Fetching")
        .methods()
        .approve_loan(application_id, interest_rate, collateral)
        .call()
        .await
        .unwrap();

    let result = _instance
        .methods()
        .check_application(application_id)
        .call()
        .await
        .unwrap();
    let application = result.value;
    assert_eq!(ApplicationState::Approved, application.state);
}

// #[tokio::test]
// #[should_panic(expected = "OnlyAdminsCanAccess")]
// async fn not_admin_fail_to_approve_loan() {
//     let (_instance, _id, _deployer, user) = get_contract_instance().await;
//     let deployer = Identity::Address(Address::from(_deployer.address()));

//     let result = _instance
//         .methods()
//         .apply_for_loan()
//         .call()
//         .await
//         .unwrap();
//     //assert deployer is admin
//     assert_eq!(deployer, result.value);
// }
