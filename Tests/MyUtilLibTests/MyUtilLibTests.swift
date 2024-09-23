import Testing
@testable import MyUtilLib

@Test func tokenizerTest1 () async throws {
    let tokenizer = Tokenizer (input: "Agent | Sample")
    let tokens = tokenizer.tokenize (tokenDataList: getFilterTokenDataList ())
    #expect (tokens.count == 3)
    #expect (tokens[0] == Token.AtomicFilter("Agent"))
    #expect (tokens[1] == Token.Or)
    #expect (tokens[2] == Token.AtomicFilter("Sample"))
}

@Test func tokenizerTest2 () async throws {
    let tokenizer = Tokenizer (input: "Agent| Sample")
    let tokens = tokenizer.tokenize (tokenDataList: getFilterTokenDataList ())
    #expect (tokens.count == 3)
    #expect (tokens[0] == Token.AtomicFilter("Agent"))
    #expect (tokens[1] == Token.Or)
    #expect (tokens[2] == Token.AtomicFilter("Sample"))
}


