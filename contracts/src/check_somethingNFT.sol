// SPDX-License-Identifier: MIT
// By David Murray
// check_somethingNFT contract

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract check_somethingNFT is ERC721, Ownable {
    using Strings for uint256;

    uint256 public currentTokenId = 0;
    string public defaultURI;
    uint256 public maxMintPerAddress = 1; // Limit to one mint per address

    mapping(address => bool) public authorizedMinters;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => bool) public lockedTokenURIs;
    mapping(address => uint256) public mintCount;

    event DefaultTokenURISet(string tokenURI);
    event TokenURISet(uint256 indexed tokenId, string tokenURI);
    event TokenURILocked(uint256 indexed tokenId);
    event AuthorizedMinterSet(address indexed minter, bool authorized);

    modifier onlyAuthorizedMinter() {
        require(authorizedMinters[msg.sender], "FrameNFTs: Mint must be triggered by API");
        _;
    }

    modifier onlyUnlockedTokenURI(uint256 tokenId) {
        require(!lockedTokenURIs[tokenId], "FrameNFTs: Token URI is locked");
        _;
    }

    modifier onlyBelowMaxMint(address to) {
        require(mintCount[to] < maxMintPerAddress, "FrameNFTs: Max mint reached");
        _;
    }

    constructor() ERC721("check_somethingNFT", "CHKSMTH") {
        defaultURI = "ipfs://QmSFqezaUhBKr32Z2vgFrbDPGYdbcj8zQcQvsDqbU6b6UH";
        authorizedMinters[msg.sender] = true;
        emit AuthorizedMinterSet(msg.sender, true);
        authorizeBaseMainnetSyndicateAPI();
    }

    function mint(address to) public onlyAuthorizedMinter onlyBelowMaxMint(to) {
        ++currentTokenId;
        ++mintCount[to];
        _mint(to, currentTokenId);
    }

    function generateSVG(uint256 tokenId) internal view returns (string memory) {
        // SVG generation logic
        // ...
        // return the SVG string
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory svg = generateSVG(tokenId);
        string memory svgBase64Encoded = Base64.encode(bytes(svg));
        return string(abi.encodePacked("data:image/svg+xml;base64,", svgBase64Encoded));
    }

    function lockTokenURI(uint256 tokenId) public onlyOwner {
        require(!lockedTokenURIs[tokenId], "FrameNFTs: Token URI already locked");
        lockedTokenURIs[tokenId] = true;
        emit TokenURILocked(tokenId);
    }

    function setDefaultTokenURI(string memory _tokenURI) public onlyOwner {
        defaultURI = _tokenURI;
        emit DefaultTokenURISet(_tokenURI);
    }

    function setMaxMintPerAddress(uint256 _maxMintPerAddress) public onlyOwner {
        maxMintPerAddress = _maxMintPerAddress;
    }

    function setAuthorizedMinter(address minter, bool authorized) public onlyOwner {
        authorizedMinters[minter] = authorized;
        emit AuthorizedMinterSet(minter, authorized);
    }

    function authorizeBaseMainnetSyndicateAPI() internal {
        // Authorized minters addresses
        // ...
    }

    fallback() external payable {
        revert("check_somethingNFT: Does not accept ETH");
    }

    receive() external payable {
        revert("check_somethingNFT: Does not accept ETH");
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        // Convert uint to string
        // ...
        // return the string representation of the number
    }
}
