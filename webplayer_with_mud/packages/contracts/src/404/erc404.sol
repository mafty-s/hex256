abstract contract ERC404 is Ownable {
    using ERC20Events for address;
    using ERC721Events for address;

    // Errors
    error NotFound();
    error AlreadyExists();
    error InvalidRecipient();
    error InvalidSender();
    error UnsafeRecipient();
