module DAO::CommunityFunding {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a community project proposal.
    struct Proposal has store, key {
        funds_raised: u64,
        funding_goal: u64,
    }

    /// Function to submit a funding proposal.
    public fun create_proposal(proposer: &signer, goal: u64) {
        let proposal = Proposal {
            funds_raised: 0,
            funding_goal: goal,
        };
        move_to(proposer, proposal);
    }

    /// Function to contribute funds to a proposal.
    public fun fund_proposal(contributor: &signer, proposer: address, amount: u64) acquires Proposal {
        let proposal = borrow_global_mut<Proposal>(proposer);

        let contribution = coin::withdraw<AptosCoin>(contributor, amount);
        coin::deposit<AptosCoin>(proposer, contribution);

        proposal.funds_raised = proposal.funds_raised + amount;
    }
}
