module sushi_masterchef_admin::admin {
    use aptos_framework::account;
    use aptos_framework::resource_account;
    use aptos_framework::coin;

    use sushi_multisig_wallet::multisig_wallet;
    use sushi_masterchef::masterchef;

    const MULTISIG_WALLET_ADDRESS: address = @sushi_masterchef_admin;

    const GRACE_PERIOD: u64 = 14 * 24 * 60 * 60; // in seconds

    struct Capabilities has key {
        signer_cap: account::SignerCapability,
    }

    struct SetAdminParams has copy, store {
        admin: address,
    }

    struct SetUpkeepAdminParams has copy, store {
        upkeep_admin: address,
    }

    struct AddPoolParams<phantom CoinType> has copy, store {
        alloc_point: u64,
        is_regular: bool,
        with_update: bool,
    }

    struct SetPoolParams has copy, store {
        pid: u64,
        alloc_point: u64,
        with_update: bool,
    }

    struct UpdateAptosRateParams has copy, store {
        regular_farm_rate: u64,
        special_farm_rate: u64,
        with_update: bool,
    }

    struct UpgradeMasterchefParams has copy, store {
        metadata: vector<u8>,
        code: vector<vector<u8>>,
    }

    fun init_module(sender: &signer) {
        let owners = vector[@sushi_masterchef_admin_owner1, @sushi_masterchef_admin_owner2, @sushi_masterchef_admin_owner3];
        let threshold = 2;
        multisig_wallet::initialize(sender, owners, threshold);

        multisig_wallet::register_multisig_txs<SetAdminParams>(sender);
        multisig_wallet::register_multisig_txs<SetUpkeepAdminParams>(sender);
        multisig_wallet::register_multisig_txs<SetPoolParams>(sender);
        multisig_wallet::register_multisig_txs<UpdateAptosRateParams>(sender);
        multisig_wallet::register_multisig_txs<UpgradeMasterchefParams>(sender);

        let signer_cap = resource_account::retrieve_resource_account_cap(sender, @sushi_masterchef_admin_dev);
        move_to(sender, Capabilities {
            signer_cap,
        });
    }

    public entry fun register_multisig_txs<ParamsType: copy + store>() acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::register_multisig_txs<ParamsType>(&signer);
    }

    public entry fun register_coin<CoinType>() acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        coin::register<CoinType>(&signer);
    }

    public entry fun init_add_owner(sender: &signer, eta: u64, owner: address) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_add_owner(sender, &signer, eta, expiration, owner);
    }

    public entry fun init_remove_owner(sender: &signer, eta: u64, owner: address) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_remove_owner(sender, &signer, eta, expiration, owner);
    }

    public entry fun init_set_threshold(sender: &signer, eta: u64, threshold: u8) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_set_threshold(sender, &signer, eta, expiration, threshold);
    }

    public entry fun init_withdraw<CoinType>(sender: &signer, eta: u64, to: address, amount: u64) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_withdraw<CoinType>(sender, &signer, eta, expiration, to, amount);
    }

    public entry fun approve_add_owner(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_add_owner(sender, &signer, seq_number);
    }

    public entry fun approve_remove_owner(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_remove_owner(sender, &signer, seq_number);
    }

    public entry fun approve_set_threshold(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_set_threshold(sender, &signer, seq_number);
    }

    public entry fun approve_withdraw<CoinType>(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_withdraw<CoinType>(sender, &signer, seq_number);
    }

    public entry fun execute_add_owner(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::execute_add_owner(sender, &signer, seq_number);
    }

    public entry fun execute_remove_owner(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::execute_remove_owner(sender, &signer, seq_number);
    }

    public entry fun execute_set_threshold(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::execute_set_threshold(sender, &signer, seq_number);
    }

    public entry fun execute_withdraw<CoinType>(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::execute_withdraw<CoinType>(sender, &signer, seq_number);
    }

    public entry fun init_set_admin(sender: &signer, eta: u64, admin: address) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_multisig_tx<SetAdminParams>(sender, &signer, eta, expiration, SetAdminParams {
            admin,
        });
    }

    public entry fun init_set_upkeep_admin(sender: &signer, eta: u64, upkeep_admin: address) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_multisig_tx<SetUpkeepAdminParams>(sender, &signer, eta, expiration, SetUpkeepAdminParams {
            upkeep_admin,
        });
    }

    public entry fun init_add_pool<CoinType>(sender: &signer, eta: u64, alloc_point: u64, is_regular: bool, with_update: bool) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_multisig_tx<AddPoolParams<CoinType>>(sender, &signer, eta, expiration, AddPoolParams<CoinType> {
            alloc_point,
            is_regular,
            with_update,
        });
    }

    public entry fun init_set_pool(sender: &signer, eta: u64, pid: u64, alloc_point: u64, with_update: bool) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_multisig_tx<SetPoolParams>(sender, &signer, eta, expiration, SetPoolParams {
            pid,
            alloc_point,
            with_update,
        });
    }

    public entry fun init_update_aptos_rate(sender: &signer, eta: u64, regular_farm_rate: u64, special_farm_rate: u64, with_update: bool) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_multisig_tx<UpdateAptosRateParams>(sender, &signer, eta, expiration, UpdateAptosRateParams {
            regular_farm_rate,
            special_farm_rate,
            with_update,
        });
    }

    public entry fun init_upgrade_masterchef(sender: &signer, eta: u64, metadata: vector<u8>, code: vector<vector<u8>>) acquires Capabilities {
        let expiration = eta + GRACE_PERIOD;
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::init_multisig_tx<UpgradeMasterchefParams>(sender, &signer, eta, expiration, UpgradeMasterchefParams {
            metadata,
            code,
        });
    }

    public entry fun approve_set_admin(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_multisig_tx<SetAdminParams>(sender, &signer, seq_number);
    }

    public entry fun approve_set_upkeep_admin(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_multisig_tx<SetUpkeepAdminParams>(sender, &signer, seq_number);
    }

    public entry fun approve_add_pool<CoinType>(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_multisig_tx<AddPoolParams<CoinType>>(sender, &signer, seq_number);
    }

    public entry fun approve_set_pool(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_multisig_tx<SetPoolParams>(sender, &signer, seq_number);
    }

    public entry fun approve_update_aptos_rate(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_multisig_tx<UpdateAptosRateParams>(sender, &signer, seq_number);
    }

    public entry fun approve_upgrade_masterchef(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);
        multisig_wallet::approve_multisig_tx<UpgradeMasterchefParams>(sender, &signer, seq_number);
    }

    public entry fun execute_set_admin(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);

        multisig_wallet::execute_multisig_tx<SetAdminParams>(sender, &signer, seq_number);

        let SetAdminParams { admin } = multisig_wallet::multisig_tx_params<SetAdminParams>(MULTISIG_WALLET_ADDRESS, seq_number);
        masterchef::set_admin(&signer, admin);
    }

    public entry fun execute_set_upkeep_admin(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);

        multisig_wallet::execute_multisig_tx<SetUpkeepAdminParams>(sender, &signer, seq_number);

        let SetUpkeepAdminParams { upkeep_admin } = multisig_wallet::multisig_tx_params<SetUpkeepAdminParams>(MULTISIG_WALLET_ADDRESS, seq_number);
        masterchef::set_upkeep_admin(&signer, upkeep_admin);
    }

    public entry fun execute_add_pool<CoinType>(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);

        multisig_wallet::execute_multisig_tx<AddPoolParams<CoinType>>(sender, &signer, seq_number);

        let AddPoolParams<CoinType> { alloc_point, is_regular, with_update } = multisig_wallet::multisig_tx_params<AddPoolParams<CoinType>>(MULTISIG_WALLET_ADDRESS, seq_number);
        masterchef::add_pool<CoinType>(&signer, alloc_point, is_regular, with_update);
    }

    public entry fun execute_set_pool(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);

        multisig_wallet::execute_multisig_tx<SetPoolParams>(sender, &signer, seq_number);

        let SetPoolParams { pid, alloc_point, with_update } = multisig_wallet::multisig_tx_params<SetPoolParams>(MULTISIG_WALLET_ADDRESS, seq_number);
        masterchef::set_pool(&signer, pid, alloc_point, with_update);
    }

    public entry fun execute_update_aptos_rate(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);

        multisig_wallet::execute_multisig_tx<UpdateAptosRateParams>(sender, &signer, seq_number);

        let UpdateAptosRateParams { regular_farm_rate, special_farm_rate, with_update } = multisig_wallet::multisig_tx_params<UpdateAptosRateParams>(MULTISIG_WALLET_ADDRESS, seq_number);
        masterchef::update_aptos_rate(&signer, regular_farm_rate, special_farm_rate, with_update);
    }

    public entry fun execute_upgrade_masterchef(sender: &signer, seq_number: u64) acquires Capabilities {
        let capabilities = borrow_global<Capabilities>(MULTISIG_WALLET_ADDRESS);
        let signer = account::create_signer_with_capability(&capabilities.signer_cap);

        multisig_wallet::execute_multisig_tx<UpgradeMasterchefParams>(sender, &signer, seq_number);

        let UpgradeMasterchefParams { metadata, code } = multisig_wallet::multisig_tx_params<UpgradeMasterchefParams>(MULTISIG_WALLET_ADDRESS, seq_number);
        masterchef::upgrade_masterchef(&signer, metadata, code);
    }

    #[test_only]
    use std::signer;

    #[test_only]
    use std::debug;

    #[test_only]
    use aptos_framework::genesis;
    #[test_only]
    use aptos_framework::timestamp;

    #[test_only]
    const MINUTE_IN_SECONDS: u64 = 60;
    #[test_only]
    const HOUR_IN_SECONDS: u64 = 60 * 60;
    #[test_only]
    const DAY_IN_SECONDS: u64 = 24 * 60 * 60;

    #[test(
        sender = @sushi_masterchef_admin_owner1,
        sushi_multisig_wallet_dev = @sushi_multisig_wallet_dev,
        sushi_multisig_wallet = @sushi_multisig_wallet,
        sushi_masterchef_admin_dev = @sushi_masterchef_admin_dev,
        sushi_masterchef_admin = @sushi_masterchef_admin,
        sushi_masterchef_dev = @masterchef_origin,
        sushi_masterchef = @sushi_masterchef
    )]
    fun init_set_admin_successfully(
        sender: signer,
        sushi_multisig_wallet_dev: signer,
        sushi_multisig_wallet: signer,
        sushi_masterchef_admin_dev: signer,
        sushi_masterchef_admin: signer,
        sushi_masterchef_dev: signer,
        sushi_masterchef: signer,
    )
    acquires Capabilities {

        before_each_test(
            &sender,
            &sushi_multisig_wallet_dev,
            &sushi_multisig_wallet,
            &sushi_masterchef_admin_dev,
            &sushi_masterchef_admin,
            &sushi_masterchef_dev,
            &sushi_masterchef
        );

        let eta = timestamp::now_seconds() + HOUR_IN_SECONDS;

        let new_admin_addr = @0x12345;

        let seq_number = multisig_wallet::next_seq_number(MULTISIG_WALLET_ADDRESS);
        init_set_admin(&sender, eta, new_admin_addr);

        assert!(multisig_wallet::is_multisig_tx_approved_by<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number, signer::address_of(&sender)), 0);
        assert!(multisig_wallet::num_multisig_tx_approvals<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number) == 1, 0);
        assert!(!multisig_wallet::is_multisig_tx_executed<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number), 0);
    }

    #[test(
        sender = @sushi_masterchef_admin_owner2,
        initiator = @sushi_masterchef_admin_owner1,
        sushi_multisig_wallet_dev = @sushi_multisig_wallet_dev,
        sushi_multisig_wallet = @sushi_multisig_wallet,
        sushi_masterchef_admin_dev = @sushi_masterchef_admin_dev,
        sushi_masterchef_admin = @sushi_masterchef_admin,
        sushi_masterchef_dev = @masterchef_origin,
        sushi_masterchef = @sushi_masterchef
    )]
    fun approve_set_admin_successfully(
        sender: signer,
        initiator: signer,
        sushi_multisig_wallet_dev: signer,
        sushi_multisig_wallet: signer,
        sushi_masterchef_admin_dev: signer,
        sushi_masterchef_admin: signer,
        sushi_masterchef_dev: signer,
        sushi_masterchef: signer,
    )
    acquires Capabilities {
        before_each_test(
            &sender,
            &sushi_multisig_wallet_dev,
            &sushi_multisig_wallet,
            &sushi_masterchef_admin_dev,
            &sushi_masterchef_admin,
            &sushi_masterchef_dev,
            &sushi_masterchef
        );

        let eta = timestamp::now_seconds() + HOUR_IN_SECONDS;
        let new_admin_addr = @0x12345;

        let seq_number = multisig_wallet::next_seq_number(MULTISIG_WALLET_ADDRESS);
        init_set_admin(&initiator, eta, new_admin_addr);
        approve_set_admin(&sender, seq_number);

        assert!(multisig_wallet::is_multisig_tx_approved_by<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number, signer::address_of(&sender)), 0);
        assert!(multisig_wallet::num_multisig_tx_approvals<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number) == 2, 0);
        assert!(!multisig_wallet::is_multisig_tx_executed<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number), 0);
    }

    #[test(
        sender = @sushi_masterchef_admin_owner3,
        approver = @sushi_masterchef_admin_owner2,
        initiator = @sushi_masterchef_admin_owner1,
        sushi_multisig_wallet_dev = @sushi_multisig_wallet_dev,
        sushi_multisig_wallet = @sushi_multisig_wallet,
        sushi_masterchef_admin_dev = @sushi_masterchef_admin_dev,
        sushi_masterchef_admin = @sushi_masterchef_admin,
        sushi_masterchef_dev = @masterchef_origin,
        sushi_masterchef = @sushi_masterchef
    )]
    fun execute_set_admin_successfully(
        sender: signer,
        approver: signer,
        initiator: signer,
        sushi_multisig_wallet_dev: signer,
        sushi_multisig_wallet: signer,
        sushi_masterchef_admin_dev: signer,
        sushi_masterchef_admin: signer,
        sushi_masterchef_dev: signer,
        sushi_masterchef: signer,
    )
    acquires Capabilities {
        before_each_test(
            &sender,
            &sushi_multisig_wallet_dev,
            &sushi_multisig_wallet,
            &sushi_masterchef_admin_dev,
            &sushi_masterchef_admin,
            &sushi_masterchef_dev,
            &sushi_masterchef
        );

        let eta = timestamp::now_seconds() + HOUR_IN_SECONDS;
        let new_admin_addr = @0x12345;

        let seq_number = multisig_wallet::next_seq_number(MULTISIG_WALLET_ADDRESS);
        init_set_admin(&initiator, eta, new_admin_addr);
        approve_set_admin(&approver, seq_number);
        timestamp::fast_forward_seconds(HOUR_IN_SECONDS);
        execute_set_admin(&sender, seq_number);

        assert!(multisig_wallet::is_multisig_tx_executed<SetAdminParams>(signer::address_of(&sushi_masterchef_admin), seq_number), 0);
        // {
        //     let seq_number = multisig_wallet::next_seq_number(MULTISIG_WALLET_ADDRESS);
        //     init_set_admin(&initiator, eta, new_admin_addr);
        //     approve_set_admin(&approver, seq_number);
        //     execute_set_admin(&sender, seq_number);
        // }
    }

    #[test_only]
    fun before_each_test(
        sender: &signer,
        sushi_multisig_wallet_dev: &signer,
        sushi_multisig_wallet: &signer,
        sushi_masterchef_admin_dev: &signer,
        sushi_masterchef_admin: &signer,
        sushi_masterchef_dev: &signer,
        sushi_masterchef: &signer
    ) {
        genesis::setup();

        account::create_account_for_test(signer::address_of(sender));
        account::create_account_for_test(signer::address_of(sushi_multisig_wallet_dev));
        account::create_account_for_test(signer::address_of(sushi_masterchef_admin_dev));
        account::create_account_for_test(signer::address_of(sushi_masterchef_dev));


        resource_account::create_resource_account(sushi_multisig_wallet_dev, b"sushi_multisig_wallet", x"");
        multisig_wallet::init_module_for_test(sushi_multisig_wallet);

        resource_account::create_resource_account(sushi_masterchef_admin_dev, b"pancake_masterchef_admin", x"");
        init_module(sushi_masterchef_admin);

        resource_account::create_resource_account(sushi_masterchef_dev, b"sushi-swap-masterchef", x"2c967359c97aafbfc2fbfb56829303ae20434cb014bc9d1531fb9aba9cf1dd69");
        // let ra = account::create_resource_address(&signer::address_of(sushi_masterchef_dev), b"sushi_masterchef");
        // std::debug::print(&ra);
        masterchef::initialize(sushi_masterchef);
    }
}
