const hre = require("hardhat");

async function main() {
	// Setting Form Owner
	const [owner, address1, address2, address3] = await hre.ethers.getSigners();

	// Max value of uint256 (alternative to infinite in solidity)
	const INFINITE =
		115792089237316195423570985008687907853269984665640564039457584007913129639935n;

	// Getting timestamp of last block
	const blockBeforeNumber = await ethers.provider.getBlockNumber();
	const blockBefore = await ethers.provider.getBlock(blockBeforeNumber);
	const blockBeforeTimestamp = blockBefore.timestamp;

	// Deployment Parameters
	const _maxFills = INFINITE;
	const _startTime = blockBeforeTimestamp;
	const _endTime = blockBeforeTimestamp + 24 * 60 * 60; // Adding 24 hours
	const _allowedTotalFills = INFINITE;
	const _publicKey = "Some Public Key";
	const _formHead = "Some Form Head";
	const _fields = "Some Form Fields";

	// Deploying Formsify Contract
	const FormsifyContractFactory = await hre.ethers.getContractFactory(
		"Formsify"
	);
	const FormsifyContract = await FormsifyContractFactory.deploy(
		_maxFills,
		_startTime,
		_endTime,
		_allowedTotalFills,
		_publicKey,
		_formHead,
		_fields
	);
	await FormsifyContract.deployed();

	// Deployment Status
	console.log(`\nFormsify Contract has been deplyed.`);
	console.log(`\nDeployed By: ${owner.address}`);
	console.log(`\nDeployed to: ${FormsifyContract.address}`);

	// Adding Form Entries
	await FormsifyContract.connect(address1).addRecord("Address1 Form Data");
	await FormsifyContract.connect(address2).addRecord("Address2 Form Data");
	await FormsifyContract.connect(address3).addRecord("Address3 Form Data");

	// Getting Formsify Contract Parameters
	const formOwner = await FormsifyContract.owner();
	const formFills = await FormsifyContract.fills();
	const formMaxFills = await FormsifyContract.maxFills();
	const formStartTime = await FormsifyContract.startTime();
	const formEndTime = await FormsifyContract.endTime();
	const formAllowedTotalFills = await FormsifyContract.allowedTotalFills();
	const formPublicKey = await FormsifyContract.publicKey();
	const formHead = await FormsifyContract.formHead();
	const formFields = await FormsifyContract.fields();
	const formRecords = await FormsifyContract.getRecords();

	// Logging out fetched form information
	console.log(`\nForm Owner is ${formOwner}`);
	console.log(`Forms filled so far are ${formFills}`);
	console.log(`Maximum form entries that can be filled are ${formMaxFills}`);
	console.log(`Form start time is ${formStartTime}`);
	console.log(`Form end time is ${formEndTime}`);
	console.log(
		`Allowed total fills by an address are ${formAllowedTotalFills}`
	);
	console.log(`Public key of form is "${formPublicKey}"`);
	console.log(`Form Head is "${formHead}"`);
	console.log(`Form fields are "${formFields}"`);
	console.log(
		`Records of the form are \n${JSON.stringify(formRecords, null, 2)}`
	);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.log(error);
		process.exit(1);
	});
