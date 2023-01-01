// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountcollected;
        string image;
        address[] donators;
        uint256[] donations;
        
    }

    // create a mapping for the above struct

    mapping (uint256 => Campaign ) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image ) public returns(uint256) {

        Campaign storage campaign = campaigns[numberOfCampaigns];

        // check if the function create campaign  is working

        require(campaign.deadline < block.timestamp, "The deadline should be the date in future");
        
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountcollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns -1;

    }

    function donateToCampaign(uint256 _id)  public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        // check if the transaction has been sent

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountcollected - campaign.amountcollected + amount;
        }

    }

    function  getDonators(uint256 _id) view  public returns (address[] memory, uint256[] memory) {
        return(campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {

        // get all campaigns
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns); 

        
        for (uint i = 0; i < numberOfCampaigns; i ++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
            

        }

        return allCampaigns;

    }

}