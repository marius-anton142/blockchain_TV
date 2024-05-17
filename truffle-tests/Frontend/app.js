
let signer;
const contractAddress = '0xC83C634589c7cE8Ca839edE465C3417B26BB27F4';
const contractABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "IProposelContractAddress",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "InvalidInitialization",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "NotInitializing",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "OwnableInvalidOwner",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "OwnableUnauthorizedAccount",
		"type": "error"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint64",
				"name": "version",
				"type": "uint64"
			}
		],
		"name": "Initialized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "url",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "votes",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "ProposelAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "proposel_id",
				"type": "uint256"
			}
		],
		"name": "RemovedProposel",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "voter",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "proposel_id",
				"type": "uint256"
			}
		],
		"name": "VoteCasted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "voter",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "proposel_id",
				"type": "uint256"
			}
		],
		"name": "VoteUncasted",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "getFee",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getLastWinningProposal",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "url",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "votes",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "bytes32",
						"name": "uniqueHash",
						"type": "bytes32"
					}
				],
				"internalType": "struct Proposel",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPeriodInterval",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "periodStart",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "periodEnd",
						"type": "uint256"
					}
				],
				"internalType": "struct PeriodInterval",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getVotes",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getWinningPoposel",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "url",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "votes",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "bytes32",
						"name": "uniqueHash",
						"type": "bytes32"
					}
				],
				"internalType": "struct Proposel",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "lastWinningProposal",
		"outputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "url",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "votes",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			},
			{
				"internalType": "bytes32",
				"name": "uniqueHash",
				"type": "bytes32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "listProposels",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "url",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "votes",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "bytes32",
						"name": "uniqueHash",
						"type": "bytes32"
					}
				],
				"internalType": "struct Proposel[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			}
		],
		"name": "makeTransfer",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "resetPeriod",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newFee",
				"type": "uint256"
			}
		],
		"name": "setFee",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "url",
				"type": "string"
			}
		],
		"name": "setProposel",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "IProposelContractAddress",
				"type": "address"
			}
		],
		"name": "setProposelContractAddress",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "unvote",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "proposelId",
				"type": "uint256"
			}
		],
		"name": "vote",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

if (typeof Web3 !== 'undefined') {
	window.web3 = new Web3(Web3.givenProvider);
}
const contract = new web3.eth.Contract(contractABI, contractAddress);

class IContractEventObserver {
	update(eventResult){};
}
class ContractEventListener {
	constructor(contract) {
		this.contract = contract;
		this.observers = [];
	}

	subscribe(observer) {
		this.observers.push(observer);
	}

	notifyObservers(eventResult) {
		this.observers.forEach(observer => observer.update(eventResult));
	}

	listenToEvent(eventName) {
		this.contract.events[eventName]()
			.on('data', event => this.notifyObservers(event))
			.on('error', console.error);
	}
}

class AddProposelObserver extends  IContractEventObserver {
	update(eventResult){
		console.log('New proposal added:', eventResult);
		displayProposals();
	}
}

class VoteProposelObserver extends  IContractEventObserver {
	update(eventResult){
		console.log('New vote made:', eventResult);
		displayProposals();
	}
}

class UnvoteProposelObserver extends  IContractEventObserver {
	update(eventResult){
		console.log(' vote unmade:', eventResult);
		displayProposals();
	}
}

class RemovedProposelObservable extends  IContractEventObserver {
	update(eventResult){
		console.log('Renoved proposal:', eventResult);
		displayProposals();
	}
}
const unvoteProposelObserver = new UnvoteProposelObserver();
const voteProposelObserver = new VoteProposelObserver();
const addProposelObserver = new AddProposelObserver();
const removedProposelObservable = new RemovedProposelObservable();
const listenerAddProposelObserver = new ContractEventListener(contract);
const listenerVoteProposelObserver = new ContractEventListener(contract);
const listenerUnvoteProposelObserver = new ContractEventListener(contract);
const listenerRemovedProposelObservable = new ContractEventListener(contract);

listenerAddProposelObserver.subscribe(addProposelObserver);
listenerAddProposelObserver.listenToEvent('ProposelAdded');

listenerVoteProposelObserver.subscribe(voteProposelObserver);
listenerVoteProposelObserver.listenToEvent('VoteCasted');

listenerUnvoteProposelObserver.subscribe(unvoteProposelObserver);
listenerUnvoteProposelObserver.listenToEvent('VoteUncasted');

listenerRemovedProposelObservable.subscribe(removedProposelObservable);
listenerRemovedProposelObservable.listenToEvent('RemovedProposel');


const connectWallet = async () => {
	if (window.ethereum) {
		const provider = new ethers.providers.Web3Provider(window.ethereum);
		try {
			await provider.send("eth_requestAccounts", []);
			signer = provider.getSigner();
			document.getElementById('status').innerText = 'Wallet connected';
			document.getElementById('proposalsOperations').style.display = 'block';
			return signer;
		} catch (error) {
			console.error('Failed to connect wallet:', error);
			document.getElementById('status').innerText = 'Failed to connect wallet';
			document.getElementById('proposalsOperations').style.display = 'none';
		}
	} else {
		document.getElementById('status').innerText = 'Please install MetaMask';
	}
};

document.getElementById('connectWallet').addEventListener('click', connectWallet);

var player;

function onYouTubeIframeAPIReady() {
	player = new YT.Player('videoPlayer', {
		height: '405',
		width: '720',
		videoId: 'uRhmus2BdKc',
		playerVars: {
			autoplay: 1,
			controls: 1,
			showinfo: 0,
			modestbranding: 1,
			loop: 1,
			playlist: 'uRhmus2BdKc'
		},
		events: {
			'onReady': onPlayerReady,
			'onStateChange': onPlayerStateChange
		}
	});
}

function onPlayerReady(event) {
	event.target.playVideo();
}

function onPlayerStateChange(event) {
	updateVideoSrc(getHighestVotedVideoId());
}

function updateVideoSrc(videoUrl) {
	let videoId = videoUrl.split('/').pop();
	let currentVideoId = player.getVideoData().video_id;

	if (player && videoId) {
		console.log("Loading video ID:", videoId);
		if (currentVideoId === videoId) {
			console.log("The new video ID matches the current one. No action taken.");
			return;
		}
		player.loadVideoById(videoId);
	} else {
		console.error("YouTube player is not initialized or videoId is invalid.");
	}
}


async function getCurrentFee() {
	try {
		const contract = new ethers.Contract(contractAddress, contractABI, signer);
		const fee = await contract.getFee();

		return fee;
	} catch (error) {
		console.log(error);
		document.getElementById('errorMessages').innerText = "Failed to get fee: " + error.message;
	}
}

async function submitProposal() {
	const name = document.getElementById('proposalName').value;
	const url = document.getElementById('proposalUrl').value;
	if (!name || !url) {
		document.getElementById('errorMessages').innerText = "Both name and URL must be provided!";
		return;
	}

	let button = document.getElementById('submitProposal');

	try {
		const fee = await getCurrentFee();
		const feeInEther = ethers.utils.formatEther(fee.toString());
		const contract = new ethers.Contract(contractAddress, contractABI, signer);
		button.innerText = 'Submitting...';
		button.disabled = true;
		const transaction = await contract.setProposel(name, url, { value: ethers.utils.parseEther(feeInEther) });
		await transaction.wait();
		document.getElementById('errorMessages').innerText = "Proposal submitted successfully!";
	} catch (error) {
		document.getElementById('errorMessages').innerText = "Failed to submit proposal: " + error.message;
		console.error(error);
	} finally {
		button.innerText = 'Submit Proposal';
		button.disabled = false;
	}
}

document.getElementById('submitProposal').addEventListener('click', submitProposal);

async function vote(proposalId) {
	try {
		const contract = new ethers.Contract(contractAddress, contractABI, signer);
		const transaction = await contract.vote(proposalId);
		await transaction.wait();
		document.getElementById('voteStatus').innerText = "Vote cast successfully!";
	} catch (error) {
		console.error(error);
        if (error.code === 'INSUFFICIENT_FUNDS') {
            document.getElementById('voteStatus').innerText = "Failed to vote: Insufficient funds for gas.";
        } else if (error.code === 'ACTION_REJECTED') {
            document.getElementById('voteStatus').innerText = "Failed to vote: Transaction rejected by user.";
        } else if (error.code === 'UNPREDICTABLE_GAS_LIMIT') {
            document.getElementById('voteStatus').innerText = "Failed to vote: Voting period ended.";
        } else {
            document.getElementById('voteStatus').innerText = "Failed to vote: " + error.message;
        }
	}
}

async function unvote() {
	try {
		const contract = new ethers.Contract(contractAddress, contractABI, signer);
		const transaction = await contract.unvote();
		await transaction.wait();
		document.getElementById('voteStatus').innerText = "Vote retracted successfully!";
	} catch (error) {
		console.error(error);
		document.getElementById('voteStatus').innerText = "Failed to unvote: " + error.message;
	}
}

// document.getElementById('voteProposal').addEventListener('click', vote);
// document.getElementById('unvoteProposal').addEventListener('click', unvote);

const provider = new ethers.providers.Web3Provider(window.ethereum);

async function displayProposals() {
	try {
		const contract = new ethers.Contract(contractAddress, contractABI, provider);
		const proposals = await contract.listProposels();
		console.log(proposals);
		const proposalsContainer = document.getElementById('proposalsList');
		proposalsContainer.innerHTML = '';

		proposals.forEach(proposal => {
			const proposalElem = document.createElement('div');
			proposalElem.innerHTML = `
			<div style="
			border: solid;
			border-color: #f2cdbf;
			padding: 5px;
			margin: 5px;
			background-color: #a189805e;
			">
                <p>Name: ${proposal.name}</p>
                <p>URL: <a href="${proposal.url}" target="_blank">${proposal.url}</a></p>
                <p>Votes: ${proposal.votes.toString()}</p>
				<button onclick="vote(${proposal.id})">Vote</button>
				<button onclick="unvote()">Unvote</button>
				</div>
            `;
			proposalsContainer.appendChild(proposalElem);
		});
	} catch (error) {
		console.error('Failed to load proposals:', error);
		document.getElementById('errorMessages').innerText = 'Failed to load proposals: ' + error.message;
	}
}

document.addEventListener('DOMContentLoaded', displayProposals);


async function setupEventListeners() {
	const contract = new ethers.Contract(contractAddress, contractABI, signer);

	contract.on('WinningProposal', (name, url, votes, id, event) => {
		console.log(`Winning proposal: ${name} with URL ${url}`);
		updateVideoSrc(url);
	});

	console.log("Event listeners set up.");
}

document.addEventListener('DOMContentLoaded', function () {
	setupEventListeners();
});

function setupWeb3() {
	if (!signer) {
		console.error("Signer is not set. Please connect the wallet first.");
		return null;
	}
	return new ethers.Contract(contractAddress, contractABI, signer);
}

async function updateVideoFromLastWinningProposal() {
	const contract = setupWeb3();
    if (!contract) {
        console.log("Contract is not set up. Signer might be missing.");
        return;
    }

    try {
        const lastWinningProposal = await contract.getLastWinningProposal();
        if (lastWinningProposal && lastWinningProposal.url !== "") {
            updateVideoSrc(lastWinningProposal.url);
        }
    } catch (error) {
        console.error('Error fetching the last winning proposal:', error);
    }
}


document.getElementById('estimateGasVote').addEventListener('click', async function() {
    const proposalId = document.getElementById('voteId').value;
    if (!proposalId) {
        console.error("Proposal ID is required to estimate gas!");
        return;
    }

    try {
        const contract = new ethers.Contract(contractAddress, contractABI, signer);
        const estimatedGas = await contract.estimateGas.vote(proposalId);
        const gasPrice = await signer.getGasPrice();
        console.log(`Estimated gas for voting: ${estimatedGas.toString()}`);
        console.log(`Current gas price: ${ethers.utils.formatUnits(gasPrice, 'gwei')} gwei`);
        const estimatedCostInEther = ethers.utils.formatEther(gasPrice.mul(estimatedGas));
        alert(`Estimated gas for voting: ${estimatedGas.toString()} units\n` +
              `Current gas price: ${ethers.utils.formatUnits(gasPrice, 'gwei')} gwei\n` +
              `Estimated cost: ${estimatedCostInEther} ETH`);
    } catch (error) {
        console.error("Failed to estimate gas:", error);
    }
});

async function fetchAndUpdateEthPrice() {
    if (!window.ethereum) {
        console.error("Ethereum object not found, please install MetaMask.");
        return;
    }

    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();

    try {
        const contract = new ethers.Contract(contractAddress, contractABI, signer);
        const priceInWei = await contract.getLatestPrice();
        const priceInUSD = ethers.utils.formatUnits(priceInWei, 'wei') / 1e3;
        document.getElementById('ethPriceDisplay').innerText = `ETH Price: ${priceInUSD} USD`;
    } catch (error) {
        console.error('Failed to fetch ETH price:', error);
        document.getElementById('ethPriceDisplay').innerText = 'Failed to load ETH price.';
    }
}

console.log("Starting to poll ETH price...");
function startPollingEthPrice() {
    console.log("Starting to poll ETH price...");
    setInterval(fetchAndUpdateEthPrice, 2000);
}

document.addEventListener('DOMContentLoaded', function() {
    startPollingEthPrice();
});










