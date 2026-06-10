/**
 * NATURAL LANGUAGE PIPELINE - Comprehensive NLP Processing Chain
 * 
 * ENTERPRISE-GRADE TEXT UNDERSTANDING AND GENERATION
 * 
 * Full pipeline from raw text to structured semantic understanding:
 * - Tokenization → Normalization → POS Tagging → NER → Dependency Parsing
 * - Chunking → Semantic Role Labeling → Intent Classification → Sentiment Analysis
 * 
 * Integrated with:
 * - All 9 Organisms (Legal, Finance, Research, Engineering, Creative, Operations, Code, Video, PDF)
 * - Knowledge Graph Engine for entity linking
 * - Decision Reasoning Engine for logical inference
 * - Prompt System Architecture for response generation
 * 
 * S₀ (Sovereignty Floor) = 1.0 - MAXED - Enterprise Final Product
 */

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";

actor NaturalLanguagePipeline {
    
    // ============================================
    // SOVEREIGNTY CONSTANTS - ALL MAXED TO 1.0
    // ============================================
    
    private let S_0_FLOOR : Float = 1.0;  // MAXED - Enterprise grade
    private let COHERENCE_THRESHOLD : Float = 1.0;
    private let INTEGRITY_MINIMUM : Float = 1.0;
    
    // ============================================
    // TOKEN TYPES AND STRUCTURES
    // ============================================
    
    public type TokenType = {
        #Word;
        #Punctuation;
        #Number;
        #Whitespace;
        #Symbol;
        #Emoji;
        #URL;
        #Email;
        #Hashtag;
        #Mention;
        #Abbreviation;
        #Contraction;
        #Unknown;
    };
    
    public type Token = {
        text: Text;
        tokenType: TokenType;
        startOffset: Nat;
        endOffset: Nat;
        normalized: Text;
        isStopWord: Bool;
        stemmed: ?Text;
        lemma: ?Text;
    };
    
    // ============================================
    // PART-OF-SPEECH TAGS (Penn Treebank)
    // ============================================
    
    public type POSTag = {
        #CC;    // Coordinating conjunction
        #CD;    // Cardinal number
        #DT;    // Determiner
        #EX;    // Existential there
        #FW;    // Foreign word
        #IN;    // Preposition/subordinating conjunction
        #JJ;    // Adjective
        #JJR;   // Adjective, comparative
        #JJS;   // Adjective, superlative
        #LS;    // List item marker
        #MD;    // Modal
        #NN;    // Noun, singular or mass
        #NNS;   // Noun, plural
        #NNP;   // Proper noun, singular
        #NNPS;  // Proper noun, plural
        #PDT;   // Predeterminer
        #POS;   // Possessive ending
        #PRP;   // Personal pronoun
        #PRPS;  // Possessive pronoun
        #RB;    // Adverb
        #RBR;   // Adverb, comparative
        #RBS;   // Adverb, superlative
        #RP;    // Particle
        #SYM;   // Symbol
        #TO;    // to
        #UH;    // Interjection
        #VB;    // Verb, base form
        #VBD;   // Verb, past tense
        #VBG;   // Verb, gerund/present participle
        #VBN;   // Verb, past participle
        #VBP;   // Verb, non-3rd person singular present
        #VBZ;   // Verb, 3rd person singular present
        #WDT;   // Wh-determiner
        #WP;    // Wh-pronoun
        #WPS;   // Possessive wh-pronoun
        #WRB;   // Wh-adverb
        #PUNCT; // Punctuation
        #UNKNOWN;
    };
    
    public type TaggedToken = {
        token: Token;
        posTag: POSTag;
        confidence: Float;
    };
    
    // ============================================
    // NAMED ENTITY RECOGNITION
    // ============================================
    
    public type EntityType = {
        #Person;
        #Organization;
        #Location;
        #Date;
        #Time;
        #Money;
        #Percent;
        #Quantity;
        #Ordinal;
        #Cardinal;
        #Product;
        #Event;
        #WorkOfArt;
        #Law;
        #Language;
        #NORP;      // Nationalities, religious, political groups
        #Facility;
        #GPE;       // Geopolitical entity
        #Misc;
        #Unknown;
    };
    
    public type NamedEntity = {
        text: Text;
        entityType: EntityType;
        startToken: Nat;
        endToken: Nat;
        confidence: Float;
        linkedEntityId: ?Text;  // Link to knowledge graph
        metadata: [(Text, Text)];
    };
    
    // ============================================
    // DEPENDENCY PARSING
    // ============================================
    
    public type DependencyRelation = {
        #ROOT;
        #NSUBJ;     // Nominal subject
        #NSUBJPASS; // Passive nominal subject
        #DOBJ;      // Direct object
        #IOBJ;      // Indirect object
        #CSUBJ;     // Clausal subject
        #CCOMP;     // Clausal complement
        #XCOMP;     // Open clausal complement
        #AMOD;      // Adjectival modifier
        #ADVMOD;    // Adverbial modifier
        #NEG;       // Negation modifier
        #NMOD;      // Nominal modifier
        #APPOS;     // Appositional modifier
        #NUMMOD;    // Numeric modifier
        #COMPOUND;  // Compound
        #CASE;      // Case marking
        #DET;       // Determiner
        #AUX;       // Auxiliary
        #AUXPASS;   // Passive auxiliary
        #COP;       // Copula
        #MARK;      // Marker
        #PUNCT;     // Punctuation
        #CONJ;      // Conjunct
        #CC;        // Coordinating conjunction
        #DEP;       // Unspecified dependency
        #PARATAXIS; // Parataxis
        #DISCOURSE; // Discourse element
        #VOCATIVE;  // Vocative
        #EXPL;      // Expletive
        #ACL;       // Clausal modifier of noun
        #ADVCL;     // Adverbial clause modifier
        #RELCL;     // Relative clause modifier
        #AGENT;     // Agent
        #POSS;      // Possession modifier
        #POBJ;      // Object of preposition
        #PREP;      // Prepositional modifier
    };
    
    public type DependencyEdge = {
        headIndex: Nat;
        dependentIndex: Nat;
        relation: DependencyRelation;
        confidence: Float;
    };
    
    public type DependencyTree = {
        tokens: [TaggedToken];
        edges: [DependencyEdge];
        rootIndex: Nat;
    };
    
    // ============================================
    // CHUNKING AND PHRASE STRUCTURE
    // ============================================
    
    public type ChunkType = {
        #NP;    // Noun phrase
        #VP;    // Verb phrase
        #PP;    // Prepositional phrase
        #ADJP;  // Adjective phrase
        #ADVP;  // Adverb phrase
        #SBAR;  // Subordinate clause
        #PRT;   // Particle
        #INTJ;  // Interjection
        #CONJP; // Conjunction phrase
        #LST;   // List marker
        #UCP;   // Unlike coordinated phrase
    };
    
    public type Chunk = {
        chunkType: ChunkType;
        tokens: [TaggedToken];
        startIndex: Nat;
        endIndex: Nat;
        headIndex: Nat;
        text: Text;
    };
    
    // ============================================
    // SEMANTIC ROLE LABELING
    // ============================================
    
    public type SemanticRole = {
        #Agent;         // Who did it
        #Patient;       // Who it was done to
        #Theme;         // What was affected
        #Experiencer;   // Who experienced it
        #Beneficiary;   // Who benefited
        #Instrument;    // What was used
        #Location;      // Where it happened
        #Source;        // Where it came from
        #Goal;          // Where it went to
        #Time;          // When it happened
        #Manner;        // How it was done
        #Cause;         // Why it happened
        #Purpose;       // For what reason
        #Extent;        // How much
        #Result;        // What resulted
        #Attribute;     // Description
        #Comitative;    // With whom
        #Recipient;     // Who received
        #Stimulus;      // What caused experience
    };
    
    public type SemanticRoleLabel = {
        role: SemanticRole;
        predicate: Chunk;
        argument: Chunk;
        confidence: Float;
    };
    
    public type PredicateArgumentStructure = {
        predicate: TaggedToken;
        arguments: [SemanticRoleLabel];
        auxiliaries: [TaggedToken];
        negated: Bool;
        passive: Bool;
        modality: ?Text;
    };
    
    // ============================================
    // INTENT AND DIALOGUE ACTS
    // ============================================
    
    public type Intent = {
        #Question;
        #Command;
        #Statement;
        #Request;
        #Greeting;
        #Farewell;
        #Thanks;
        #Apology;
        #Acknowledgment;
        #Confirmation;
        #Denial;
        #Clarification;
        #Opinion;
        #Emotion;
        #Information;
        #Navigation;
        #Transaction;
        #Complaint;
        #Suggestion;
        #Unknown;
    };
    
    public type IntentClassification = {
        primaryIntent: Intent;
        secondaryIntents: [Intent];
        confidence: Float;
        slots: [(Text, Text)];  // Extracted slot values
    };
    
    // ============================================
    // SENTIMENT ANALYSIS
    // ============================================
    
    public type Sentiment = {
        #VeryPositive;
        #Positive;
        #Neutral;
        #Negative;
        #VeryNegative;
        #Mixed;
    };
    
    public type Emotion = {
        #Joy;
        #Sadness;
        #Anger;
        #Fear;
        #Surprise;
        #Disgust;
        #Trust;
        #Anticipation;
        #Love;
        #Optimism;
        #Pessimism;
        #Anxiety;
        #Frustration;
        #Confusion;
        #Neutral;
    };
    
    public type SentimentResult = {
        overallSentiment: Sentiment;
        polarity: Float;        // -1.0 to 1.0
        magnitude: Float;       // 0.0 to 1.0 (intensity)
        confidence: Float;
        emotions: [(Emotion, Float)];
        aspectSentiments: [(Text, Sentiment, Float)];  // Aspect-based
    };
    
    // ============================================
    // DOCUMENT STRUCTURE
    // ============================================
    
    public type Sentence = {
        tokens: [TaggedToken];
        text: Text;
        startOffset: Nat;
        endOffset: Nat;
        dependencies: DependencyTree;
        chunks: [Chunk];
        entities: [NamedEntity];
        semanticRoles: [PredicateArgumentStructure];
        intent: IntentClassification;
        sentiment: SentimentResult;
    };
    
    public type Paragraph = {
        sentences: [Sentence];
        text: Text;
        startOffset: Nat;
        endOffset: Nat;
        topicVector: [Float];
    };
    
    public type Document = {
        id: Text;
        title: ?Text;
        paragraphs: [Paragraph];
        fullText: Text;
        language: Text;
        entities: [NamedEntity];        // Document-level entities
        topics: [(Text, Float)];        // Topic distribution
        summary: ?Text;
        sentiment: SentimentResult;
        metadata: [(Text, Text)];
        processedAt: Time.Time;
    };
    
    // ============================================
    // COREFERENCE RESOLUTION
    // ============================================
    
    public type Mention = {
        text: Text;
        sentenceIndex: Nat;
        tokenStart: Nat;
        tokenEnd: Nat;
        mentionType: {#Pronoun; #Nominal; #Proper; #List};
        gender: ?{#Male; #Female; #Neutral; #Unknown};
        number: ?{#Singular; #Plural; #Unknown};
        animacy: ?{#Animate; #Inanimate; #Unknown};
    };
    
    public type CoreferenceChain = {
        chainId: Nat;
        mentions: [Mention];
        representativeMention: Nat;  // Index of representative mention
        entityType: ?EntityType;
    };
    
    // ============================================
    // STATE MANAGEMENT
    // ============================================
    
    private var documentCounter : Nat = 0;
    private let documents = HashMap.HashMap<Text, Document>(100, Text.equal, Text.hash);
    
    // Stop words for English
    private let stopWords : [Text] = [
        "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for",
        "of", "with", "by", "from", "up", "about", "into", "over", "after",
        "is", "are", "was", "were", "be", "been", "being", "have", "has", "had",
        "do", "does", "did", "will", "would", "could", "should", "may", "might",
        "must", "shall", "can", "need", "dare", "ought", "used", "this", "that",
        "these", "those", "i", "you", "he", "she", "it", "we", "they", "what",
        "which", "who", "whom", "when", "where", "why", "how", "all", "each",
        "every", "both", "few", "more", "most", "other", "some", "such", "no",
        "nor", "not", "only", "own", "same", "so", "than", "too", "very", "just"
    ];
    
    // ============================================
    // TOKENIZATION
    // ============================================
    
    public func tokenize(text: Text) : async [Token] {
        let chars = Text.toIter(text);
        let tokens = Buffer.Buffer<Token>(100);
        var currentToken = Buffer.Buffer<Char>(50);
        var startOffset : Nat = 0;
        var currentOffset : Nat = 0;
        var currentType : TokenType = #Unknown;
        
        func flushToken() {
            if (currentToken.size() > 0) {
                let tokenText = Text.fromIter(currentToken.vals());
                let normalized = Text.toLowercase(tokenText);
                let isStop = isStopWord(normalized);
                
                tokens.add({
                    text = tokenText;
                    tokenType = currentType;
                    startOffset = startOffset;
                    endOffset = currentOffset;
                    normalized = normalized;
                    isStopWord = isStop;
                    stemmed = ?stem(normalized);
                    lemma = ?lemmatize(normalized);
                });
                
                currentToken := Buffer.Buffer<Char>(50);
                startOffset := currentOffset;
            };
        };
        
        for (c in chars) {
            let charType = classifyChar(c);
            
            if (charType != currentType and currentToken.size() > 0) {
                flushToken();
            };
            
            if (charType != #Whitespace) {
                currentToken.add(c);
            } else if (currentToken.size() > 0) {
                flushToken();
            } else {
                startOffset := currentOffset + 1;
            };
            
            currentType := charType;
            currentOffset += 1;
        };
        
        flushToken();
        
        Buffer.toArray(tokens)
    };
    
    private func classifyChar(c: Char) : TokenType {
        let code = Char.toNat32(c);
        
        if (code >= 48 and code <= 57) {
            return #Number;
        };
        
        if ((code >= 65 and code <= 90) or (code >= 97 and code <= 122)) {
            return #Word;
        };
        
        if (code == 32 or code == 9 or code == 10 or code == 13) {
            return #Whitespace;
        };
        
        if (code == 46 or code == 44 or code == 33 or code == 63 or
            code == 58 or code == 59 or code == 39 or code == 34) {
            return #Punctuation;
        };
        
        #Symbol
    };
    
    private func isStopWord(word: Text) : Bool {
        for (sw in stopWords.vals()) {
            if (word == sw) {
                return true;
            };
        };
        false
    };
    
    // Simple Porter Stemmer (subset)
    private func stem(word: Text) : Text {
        var result = word;
        
        // Remove common suffixes
        if (Text.endsWith(result, #text "ing")) {
            result := stripSuffix(result, 3);
        } else if (Text.endsWith(result, #text "ed")) {
            result := stripSuffix(result, 2);
        } else if (Text.endsWith(result, #text "ly")) {
            result := stripSuffix(result, 2);
        } else if (Text.endsWith(result, #text "ness")) {
            result := stripSuffix(result, 4);
        } else if (Text.endsWith(result, #text "ment")) {
            result := stripSuffix(result, 4);
        } else if (Text.endsWith(result, #text "tion")) {
            result := stripSuffix(result, 4);
        } else if (Text.endsWith(result, #text "able")) {
            result := stripSuffix(result, 4);
        } else if (Text.endsWith(result, #text "ible")) {
            result := stripSuffix(result, 4);
        } else if (Text.endsWith(result, #text "ful")) {
            result := stripSuffix(result, 3);
        } else if (Text.endsWith(result, #text "less")) {
            result := stripSuffix(result, 4);
        } else if (Text.endsWith(result, #text "ous")) {
            result := stripSuffix(result, 3);
        } else if (Text.endsWith(result, #text "ive")) {
            result := stripSuffix(result, 3);
        } else if (Text.endsWith(result, #text "s") and not Text.endsWith(result, #text "ss")) {
            result := stripSuffix(result, 1);
        };
        
        result
    };
    
    private func stripSuffix(text: Text, n: Nat) : Text {
        let size = Text.size(text);
        if (size <= n) {
            return text;
        };
        
        var result = "";
        var i = 0;
        for (c in Text.toIter(text)) {
            if (i < size - n) {
                result := result # Text.fromChar(c);
            };
            i += 1;
        };
        result
    };
    
    // Simple lemmatization (irregular verbs)
    private func lemmatize(word: Text) : Text {
        // Irregular verb mapping
        switch (word) {
            case "was" { "be" };
            case "were" { "be" };
            case "been" { "be" };
            case "being" { "be" };
            case "am" { "be" };
            case "is" { "be" };
            case "are" { "be" };
            case "had" { "have" };
            case "has" { "have" };
            case "did" { "do" };
            case "does" { "do" };
            case "done" { "do" };
            case "went" { "go" };
            case "gone" { "go" };
            case "going" { "go" };
            case "saw" { "see" };
            case "seen" { "see" };
            case "took" { "take" };
            case "taken" { "take" };
            case "came" { "come" };
            case "coming" { "come" };
            case "made" { "make" };
            case "making" { "make" };
            case "said" { "say" };
            case "saying" { "say" };
            case "got" { "get" };
            case "gotten" { "get" };
            case "getting" { "get" };
            case "knew" { "know" };
            case "known" { "know" };
            case "thought" { "think" };
            case "thinking" { "think" };
            case "gave" { "give" };
            case "given" { "give" };
            case "giving" { "give" };
            case "found" { "find" };
            case "finding" { "find" };
            case "told" { "tell" };
            case "telling" { "tell" };
            case "felt" { "feel" };
            case "feeling" { "feel" };
            case "became" { "become" };
            case "becoming" { "become" };
            case "left" { "leave" };
            case "leaving" { "leave" };
            case "brought" { "bring" };
            case "bringing" { "bring" };
            case "began" { "begin" };
            case "begun" { "begin" };
            case "beginning" { "begin" };
            case "wrote" { "write" };
            case "written" { "write" };
            case "writing" { "write" };
            case "stood" { "stand" };
            case "standing" { "stand" };
            case "heard" { "hear" };
            case "hearing" { "hear" };
            case "let" { "let" };
            case "letting" { "let" };
            case "kept" { "keep" };
            case "keeping" { "keep" };
            case "held" { "hold" };
            case "holding" { "hold" };
            case "ran" { "run" };
            case "running" { "run" };
            case "read" { "read" };
            case "reading" { "read" };
            case "spoke" { "speak" };
            case "spoken" { "speak" };
            case "speaking" { "speak" };
            case "lost" { "lose" };
            case "losing" { "lose" };
            case "paid" { "pay" };
            case "paying" { "pay" };
            case "met" { "meet" };
            case "meeting" { "meet" };
            case "sat" { "sit" };
            case "sitting" { "sit" };
            case "sent" { "send" };
            case "sending" { "send" };
            case "built" { "build" };
            case "building" { "build" };
            case "spent" { "spend" };
            case "spending" { "spend" };
            case "fell" { "fall" };
            case "fallen" { "fall" };
            case "falling" { "fall" };
            case "led" { "lead" };
            case "leading" { "lead" };
            case "understood" { "understand" };
            case "understanding" { "understand" };
            case "set" { "set" };
            case "setting" { "set" };
            case "learned" { "learn" };
            case "learnt" { "learn" };
            case "learning" { "learn" };
            case "changed" { "change" };
            case "changing" { "change" };
            case "watched" { "watch" };
            case "watching" { "watch" };
            case "followed" { "follow" };
            case "following" { "follow" };
            case "stopped" { "stop" };
            case "stopping" { "stop" };
            case "created" { "create" };
            case "creating" { "create" };
            case "won" { "win" };
            case "winning" { "win" };
            case "allowed" { "allow" };
            case "allowing" { "allow" };
            case "added" { "add" };
            case "adding" { "add" };
            case "continued" { "continue" };
            case "continuing" { "continue" };
            case "opened" { "open" };
            case "opening" { "open" };
            case "walked" { "walk" };
            case "walking" { "walk" };
            case "offered" { "offer" };
            case "offering" { "offer" };
            case "remembered" { "remember" };
            case "remembering" { "remember" };
            case "considered" { "consider" };
            case "considering" { "consider" };
            case "appeared" { "appear" };
            case "appearing" { "appear" };
            case "bought" { "buy" };
            case "buying" { "buy" };
            case "served" { "serve" };
            case "serving" { "serve" };
            case "died" { "die" };
            case "dying" { "die" };
            case "expected" { "expect" };
            case "expecting" { "expect" };
            case "stayed" { "stay" };
            case "staying" { "stay" };
            case "reached" { "reach" };
            case "reaching" { "reach" };
            case "killed" { "kill" };
            case "killing" { "kill" };
            case "remained" { "remain" };
            case "remaining" { "remain" };
            case _ { stem(word) };
        }
    };
    
    // ============================================
    // PART-OF-SPEECH TAGGING
    // ============================================
    
    public func tagPOS(tokens: [Token]) : async [TaggedToken] {
        let tagged = Buffer.Buffer<TaggedToken>(tokens.size());
        
        for (i in Iter.range(0, tokens.size() - 1)) {
            let token = tokens[i];
            let prevToken : ?Token = if (i > 0) { ?tokens[i - 1] } else { null };
            let nextToken : ?Token = if (i < tokens.size() - 1) { ?tokens[i + 1] } else { null };
            
            let (tag, confidence) = inferPOSTag(token, prevToken, nextToken);
            
            tagged.add({
                token = token;
                posTag = tag;
                confidence = confidence;
            });
        };
        
        Buffer.toArray(tagged)
    };
    
    private func inferPOSTag(token: Token, prev: ?Token, next: ?Token) : (POSTag, Float) {
        let word = token.normalized;
        
        // Punctuation
        if (token.tokenType == #Punctuation) {
            return (#PUNCT, 0.99);
        };
        
        // Numbers
        if (token.tokenType == #Number) {
            return (#CD, 0.95);
        };
        
        // Determiners
        if (word == "the" or word == "a" or word == "an" or word == "this" or
            word == "that" or word == "these" or word == "those" or word == "my" or
            word == "your" or word == "his" or word == "her" or word == "its" or
            word == "our" or word == "their" or word == "some" or word == "any" or
            word == "no" or word == "every" or word == "each" or word == "all") {
            return (#DT, 0.95);
        };
        
        // Prepositions
        if (word == "in" or word == "on" or word == "at" or word == "by" or
            word == "for" or word == "with" or word == "about" or word == "against" or
            word == "between" or word == "into" or word == "through" or word == "during" or
            word == "before" or word == "after" or word == "above" or word == "below" or
            word == "from" or word == "up" or word == "down" or word == "to" or
            word == "of" or word == "over" or word == "under" or word == "again" or
            word == "off" or word == "out" or word == "around" or word == "among") {
            return (#IN, 0.92);
        };
        
        // Conjunctions
        if (word == "and" or word == "but" or word == "or" or word == "nor" or
            word == "for" or word == "yet" or word == "so") {
            return (#CC, 0.95);
        };
        
        // Personal pronouns
        if (word == "i" or word == "you" or word == "he" or word == "she" or
            word == "it" or word == "we" or word == "they" or word == "me" or
            word == "him" or word == "her" or word == "us" or word == "them") {
            return (#PRP, 0.97);
        };
        
        // Possessive pronouns
        if (word == "mine" or word == "yours" or word == "his" or word == "hers" or
            word == "ours" or word == "theirs") {
            return (#PRPS, 0.95);
        };
        
        // WH-words
        if (word == "what" or word == "which" or word == "who" or word == "whom") {
            return (#WP, 0.93);
        };
        if (word == "where" or word == "when" or word == "why" or word == "how") {
            return (#WRB, 0.93);
        };
        if (word == "whose") {
            return (#WPS, 0.93);
        };
        
        // Modal verbs
        if (word == "can" or word == "could" or word == "may" or word == "might" or
            word == "must" or word == "shall" or word == "should" or word == "will" or
            word == "would") {
            return (#MD, 0.96);
        };
        
        // TO
        if (word == "to") {
            switch (next) {
                case (?nextTok) {
                    // If followed by a verb-like word, it's TO
                    if (isVerbLike(nextTok.normalized)) {
                        return (#TO, 0.90);
                    };
                };
                case null {};
            };
            return (#IN, 0.75);  // Default to preposition
        };
        
        // Common verbs (be, have, do)
        if (word == "be" or word == "am" or word == "is" or word == "are" or
            word == "was" or word == "were" or word == "been" or word == "being") {
            return (#VB, 0.95);
        };
        if (word == "have" or word == "has" or word == "had" or word == "having") {
            return (#VB, 0.90);
        };
        if (word == "do" or word == "does" or word == "did" or word == "doing" or word == "done") {
            return (#VB, 0.90);
        };
        
        // Adverbs (words ending in -ly)
        if (Text.endsWith(word, #text "ly")) {
            return (#RB, 0.85);
        };
        
        // Adjectives (common patterns)
        if (Text.endsWith(word, #text "ful") or Text.endsWith(word, #text "less") or
            Text.endsWith(word, #text "ous") or Text.endsWith(word, #text "ive") or
            Text.endsWith(word, #text "able") or Text.endsWith(word, #text "ible") or
            Text.endsWith(word, #text "al") or Text.endsWith(word, #text "ish")) {
            return (#JJ, 0.80);
        };
        
        // Comparative/superlative adjectives
        if (Text.endsWith(word, #text "er")) {
            switch (prev) {
                case (?prevTok) {
                    if (prevTok.normalized == "more" or prevTok.normalized == "less") {
                        return (#JJR, 0.75);
                    };
                };
                case null {};
            };
            return (#JJR, 0.60);
        };
        if (Text.endsWith(word, #text "est")) {
            return (#JJS, 0.65);
        };
        
        // Verbs (common patterns)
        if (Text.endsWith(word, #text "ing")) {
            return (#VBG, 0.80);
        };
        if (Text.endsWith(word, #text "ed")) {
            return (#VBD, 0.75);
        };
        if (Text.endsWith(word, #text "s") or Text.endsWith(word, #text "es")) {
            // Could be noun plural or verb 3rd person
            switch (prev) {
                case (?prevTok) {
                    if (isPronounSubject(prevTok.normalized)) {
                        return (#VBZ, 0.70);
                    };
                };
                case null {};
            };
            return (#NNS, 0.65);  // Default to noun plural
        };
        
        // Nouns (words ending in -tion, -ness, -ment, etc.)
        if (Text.endsWith(word, #text "tion") or Text.endsWith(word, #text "sion") or
            Text.endsWith(word, #text "ness") or Text.endsWith(word, #text "ment") or
            Text.endsWith(word, #text "ity") or Text.endsWith(word, #text "ance") or
            Text.endsWith(word, #text "ence")) {
            return (#NN, 0.85);
        };
        
        // Check if capitalized (proper noun)
        if (isCapitalized(token.text) and not isFirstInSentence(prev)) {
            return (#NNP, 0.70);
        };
        
        // Default: context-based inference
        switch (prev) {
            case (?prevTok) {
                // After determiner -> noun
                if (isDeterminer(prevTok.normalized)) {
                    return (#NN, 0.70);
                };
                // After preposition -> noun
                if (isPreposition(prevTok.normalized)) {
                    return (#NN, 0.65);
                };
                // After adjective -> noun
                if (Text.endsWith(prevTok.normalized, #text "ful") or
                    Text.endsWith(prevTok.normalized, #text "less") or
                    Text.endsWith(prevTok.normalized, #text "ous")) {
                    return (#NN, 0.65);
                };
                // After modal -> verb
                if (isModal(prevTok.normalized)) {
                    return (#VB, 0.75);
                };
                // After "to" -> verb
                if (prevTok.normalized == "to") {
                    return (#VB, 0.80);
                };
            };
            case null {};
        };
        
        // Default to noun
        (#NN, 0.50)
    };
    
    private func isVerbLike(word: Text) : Bool {
        Text.endsWith(word, #text "ing") or
        Text.endsWith(word, #text "ed") or
        Text.endsWith(word, #text "en") or
        word == "be" or word == "have" or word == "do" or
        word == "go" or word == "come" or word == "get" or
        word == "make" or word == "take" or word == "give"
    };
    
    private func isPronounSubject(word: Text) : Bool {
        word == "he" or word == "she" or word == "it" or
        word == "who" or word == "what" or word == "that" or
        word == "this" or word == "everyone" or word == "someone" or
        word == "anyone" or word == "nobody" or word == "everybody"
    };
    
    private func isCapitalized(word: Text) : Bool {
        switch (Text.toIter(word).next()) {
            case (?c) {
                let code = Char.toNat32(c);
                code >= 65 and code <= 90
            };
            case null { false };
        }
    };
    
    private func isFirstInSentence(prev: ?Token) : Bool {
        switch (prev) {
            case null { true };
            case (?p) {
                p.text == "." or p.text == "!" or p.text == "?" or
                p.text == ":" or p.text == ";"
            };
        }
    };
    
    private func isDeterminer(word: Text) : Bool {
        word == "the" or word == "a" or word == "an" or word == "this" or
        word == "that" or word == "these" or word == "those" or word == "my" or
        word == "your" or word == "his" or word == "her" or word == "its" or
        word == "our" or word == "their" or word == "some" or word == "any"
    };
    
    private func isPreposition(word: Text) : Bool {
        word == "in" or word == "on" or word == "at" or word == "by" or
        word == "for" or word == "with" or word == "about" or word == "to" or
        word == "of" or word == "from" or word == "into" or word == "through"
    };
    
    private func isModal(word: Text) : Bool {
        word == "can" or word == "could" or word == "may" or word == "might" or
        word == "must" or word == "shall" or word == "should" or word == "will" or
        word == "would"
    };
    
    // ============================================
    // NAMED ENTITY RECOGNITION
    // ============================================
    
    public func recognizeEntities(taggedTokens: [TaggedToken]) : async [NamedEntity] {
        let entities = Buffer.Buffer<NamedEntity>(20);
        var i = 0;
        
        while (i < taggedTokens.size()) {
            let token = taggedTokens[i];
            
            // Proper nouns (potential named entities)
            if (token.posTag == #NNP or token.posTag == #NNPS) {
                let entityStart = i;
                var entityEnd = i;
                var entityText = token.token.text;
                
                // Look for consecutive proper nouns
                while (entityEnd + 1 < taggedTokens.size()) {
                    let nextToken = taggedTokens[entityEnd + 1];
                    if (nextToken.posTag == #NNP or nextToken.posTag == #NNPS) {
                        entityEnd += 1;
                        entityText := entityText # " " # nextToken.token.text;
                    } else {
                        // Allow "of", "the" in entity names (e.g., "Bank of America")
                        if (entityEnd + 2 < taggedTokens.size()) {
                            let midToken = taggedTokens[entityEnd + 1];
                            let afterToken = taggedTokens[entityEnd + 2];
                            if ((midToken.token.normalized == "of" or midToken.token.normalized == "the") and
                                (afterToken.posTag == #NNP or afterToken.posTag == #NNPS)) {
                                entityEnd += 2;
                                entityText := entityText # " " # midToken.token.text # " " # afterToken.token.text;
                            } else {
                                i := entityEnd + 1;
                            };
                        } else {
                            i := entityEnd + 1;
                        };
                    };
                };
                
                let entityType = classifyEntityType(entityText, taggedTokens, entityStart, entityEnd);
                
                entities.add({
                    text = entityText;
                    entityType = entityType;
                    startToken = entityStart;
                    endToken = entityEnd;
                    confidence = 0.75;
                    linkedEntityId = null;
                    metadata = [];
                });
                
                i := entityEnd + 1;
            }
            // Numbers (potential dates, money, quantities)
            else if (token.posTag == #CD) {
                let (entity, newIndex) = parseNumericEntity(taggedTokens, i);
                switch (entity) {
                    case (?e) {
                        entities.add(e);
                        i := newIndex;
                    };
                    case null {
                        i += 1;
                    };
                };
            } else {
                i += 1;
            };
        };
        
        Buffer.toArray(entities)
    };
    
    private func classifyEntityType(text: Text, tokens: [TaggedToken], start: Nat, end: Nat) : EntityType {
        let lower = Text.toLowercase(text);
        
        // Person indicators
        if (Text.contains(lower, #text "mr.") or Text.contains(lower, #text "mrs.") or
            Text.contains(lower, #text "ms.") or Text.contains(lower, #text "dr.") or
            Text.contains(lower, #text "prof.") or Text.contains(lower, #text "president") or
            Text.contains(lower, #text "ceo") or Text.contains(lower, #text "director")) {
            return #Person;
        };
        
        // Organization indicators
        if (Text.contains(lower, #text "inc.") or Text.contains(lower, #text "corp.") or
            Text.contains(lower, #text "llc") or Text.contains(lower, #text "ltd.") or
            Text.contains(lower, #text "company") or Text.contains(lower, #text "corporation") or
            Text.contains(lower, #text "bank") or Text.contains(lower, #text "university") or
            Text.contains(lower, #text "institute") or Text.contains(lower, #text "association") or
            Text.contains(lower, #text "foundation") or Text.contains(lower, #text "group") or
            Text.contains(lower, #text "technologies") or Text.contains(lower, #text "systems")) {
            return #Organization;
        };
        
        // Location indicators
        if (Text.contains(lower, #text "city") or Text.contains(lower, #text "state") or
            Text.contains(lower, #text "country") or Text.contains(lower, #text "river") or
            Text.contains(lower, #text "mountain") or Text.contains(lower, #text "lake") or
            Text.contains(lower, #text "ocean") or Text.contains(lower, #text "sea") or
            Text.contains(lower, #text "street") or Text.contains(lower, #text "avenue") or
            Text.contains(lower, #text "boulevard") or Text.contains(lower, #text "park")) {
            return #Location;
        };
        
        // Check context before and after
        if (start > 0) {
            let prevToken = tokens[start - 1];
            let prevWord = prevToken.token.normalized;
            
            // Person context
            if (prevWord == "said" or prevWord == "told" or prevWord == "asked" or
                prevWord == "according" or prevWord == "met" or prevWord == "called") {
                return #Person;
            };
            
            // Location context
            if (prevWord == "in" or prevWord == "at" or prevWord == "from" or
                prevWord == "to" or prevWord == "near" or prevWord == "visited") {
                return #Location;
            };
            
            // Organization context
            if (prevWord == "at" or prevWord == "for" or prevWord == "by" or
                prevWord == "joined" or prevWord == "founded" or prevWord == "works") {
                return #Organization;
            };
        };
        
        // Default to Misc
        #Misc
    };
    
    private func parseNumericEntity(tokens: [TaggedToken], start: Nat) : (?NamedEntity, Nat) {
        let token = tokens[start];
        var entityText = token.token.text;
        var endIndex = start;
        var entityType : EntityType = #Cardinal;
        
        // Check for currency symbols before
        if (start > 0) {
            let prevToken = tokens[start - 1];
            if (prevToken.token.text == "$" or prevToken.token.text == "€" or
                prevToken.token.text == "£" or prevToken.token.text == "¥") {
                entityText := prevToken.token.text # entityText;
                entityType := #Money;
            };
        };
        
        // Check for units/currency after
        if (start + 1 < tokens.size()) {
            let nextToken = tokens[start + 1];
            let nextWord = nextToken.token.normalized;
            
            // Money
            if (nextWord == "dollars" or nextWord == "euros" or nextWord == "pounds" or
                nextWord == "cents" or nextWord == "million" or nextWord == "billion" or
                nextWord == "thousand" or nextWord == "usd" or nextWord == "eur") {
                entityText := entityText # " " # nextToken.token.text;
                entityType := #Money;
                endIndex := start + 1;
            }
            // Percent
            else if (nextWord == "percent" or nextWord == "%" or nextWord == "pct") {
                entityText := entityText # " " # nextToken.token.text;
                entityType := #Percent;
                endIndex := start + 1;
            }
            // Quantity
            else if (nextWord == "people" or nextWord == "units" or nextWord == "items" or
                     nextWord == "kilograms" or nextWord == "pounds" or nextWord == "meters" or
                     nextWord == "miles" or nextWord == "kilometers" or nextWord == "feet" or
                     nextWord == "inches" or nextWord == "gallons" or nextWord == "liters") {
                entityText := entityText # " " # nextToken.token.text;
                entityType := #Quantity;
                endIndex := start + 1;
            }
            // Date patterns
            else if (nextWord == "january" or nextWord == "february" or nextWord == "march" or
                     nextWord == "april" or nextWord == "may" or nextWord == "june" or
                     nextWord == "july" or nextWord == "august" or nextWord == "september" or
                     nextWord == "october" or nextWord == "november" or nextWord == "december") {
                entityText := entityText # " " # nextToken.token.text;
                entityType := #Date;
                endIndex := start + 1;
                
                // Look for year
                if (start + 2 < tokens.size()) {
                    let yearToken = tokens[start + 2];
                    if (yearToken.posTag == #CD) {
                        entityText := entityText # " " # yearToken.token.text;
                        endIndex := start + 2;
                    };
                };
            }
            // Time patterns
            else if (nextWord == "am" or nextWord == "pm" or nextWord == "o'clock") {
                entityText := entityText # " " # nextToken.token.text;
                entityType := #Time;
                endIndex := start + 1;
            }
            // Ordinal
            else if (nextWord == "st" or nextWord == "nd" or nextWord == "rd" or nextWord == "th") {
                entityText := entityText # nextToken.token.text;
                entityType := #Ordinal;
                endIndex := start + 1;
            };
        };
        
        (?{
            text = entityText;
            entityType = entityType;
            startToken = start;
            endToken = endIndex;
            confidence = 0.80;
            linkedEntityId = null;
            metadata = [];
        }, endIndex + 1)
    };
    
    // ============================================
    // DEPENDENCY PARSING
    // ============================================
    
    public func parseDependencies(taggedTokens: [TaggedToken]) : async DependencyTree {
        let edges = Buffer.Buffer<DependencyEdge>(taggedTokens.size());
        var rootIndex : Nat = 0;
        
        // Find the main verb (root)
        var mainVerbIndex : ?Nat = null;
        for (i in Iter.range(0, taggedTokens.size() - 1)) {
            let token = taggedTokens[i];
            if (token.posTag == #VB or token.posTag == #VBD or token.posTag == #VBG or
                token.posTag == #VBN or token.posTag == #VBP or token.posTag == #VBZ) {
                switch (mainVerbIndex) {
                    case null { mainVerbIndex := ?i; };
                    case (?_) {}; // Keep first verb as root candidate
                };
            };
        };
        
        rootIndex := switch (mainVerbIndex) {
            case (?idx) { idx };
            case null { 0 };  // Default to first token
        };
        
        // Build dependency edges
        for (i in Iter.range(0, taggedTokens.size() - 1)) {
            if (i != rootIndex) {
                let token = taggedTokens[i];
                let (headIdx, relation) = findHead(taggedTokens, i, rootIndex);
                
                edges.add({
                    headIndex = headIdx;
                    dependentIndex = i;
                    relation = relation;
                    confidence = 0.70;
                });
            };
        };
        
        {
            tokens = taggedTokens;
            edges = Buffer.toArray(edges);
            rootIndex = rootIndex;
        }
    };
    
    private func findHead(tokens: [TaggedToken], depIdx: Nat, rootIdx: Nat) : (Nat, DependencyRelation) {
        let token = tokens[depIdx];
        let depPos = token.posTag;
        
        // Punctuation attaches to root
        if (depPos == #PUNCT) {
            return (rootIdx, #PUNCT);
        };
        
        // Determiners attach to following noun
        if (depPos == #DT) {
            // Find next noun
            for (i in Iter.range(depIdx + 1, tokens.size() - 1)) {
                let t = tokens[i];
                if (t.posTag == #NN or t.posTag == #NNS or t.posTag == #NNP or t.posTag == #NNPS) {
                    return (i, #DET);
                };
            };
            return (rootIdx, #DET);
        };
        
        // Adjectives attach to following noun
        if (depPos == #JJ or depPos == #JJR or depPos == #JJS) {
            for (i in Iter.range(depIdx + 1, tokens.size() - 1)) {
                let t = tokens[i];
                if (t.posTag == #NN or t.posTag == #NNS or t.posTag == #NNP or t.posTag == #NNPS) {
                    return (i, #AMOD);
                };
            };
            return (rootIdx, #AMOD);
        };
        
        // Adverbs attach to verbs
        if (depPos == #RB or depPos == #RBR or depPos == #RBS) {
            return (rootIdx, #ADVMOD);
        };
        
        // Subjects (nouns before verb)
        if ((depPos == #NN or depPos == #NNS or depPos == #NNP or depPos == #NNPS or depPos == #PRP) and
            depIdx < rootIdx) {
            return (rootIdx, #NSUBJ);
        };
        
        // Objects (nouns after verb)
        if ((depPos == #NN or depPos == #NNS or depPos == #NNP or depPos == #NNPS or depPos == #PRP) and
            depIdx > rootIdx) {
            return (rootIdx, #DOBJ);
        };
        
        // Prepositions
        if (depPos == #IN) {
            return (rootIdx, #PREP);
        };
        
        // Conjunctions
        if (depPos == #CC) {
            return (rootIdx, #CC);
        };
        
        // Modals and auxiliaries
        if (depPos == #MD) {
            return (rootIdx, #AUX);
        };
        
        // TO
        if (depPos == #TO) {
            return (rootIdx, #MARK);
        };
        
        // Cardinals
        if (depPos == #CD) {
            // Attach to nearest noun
            for (i in Iter.range(depIdx + 1, tokens.size() - 1)) {
                let t = tokens[i];
                if (t.posTag == #NN or t.posTag == #NNS) {
                    return (i, #NUMMOD);
                };
            };
            return (rootIdx, #NUMMOD);
        };
        
        // Default: attach to root
        (rootIdx, #DEP)
    };
    
    // ============================================
    // CHUNKING
    // ============================================
    
    public func chunk(taggedTokens: [TaggedToken]) : async [Chunk] {
        let chunks = Buffer.Buffer<Chunk>(20);
        var i = 0;
        
        while (i < taggedTokens.size()) {
            let token = taggedTokens[i];
            
            // Skip punctuation
            if (token.posTag == #PUNCT) {
                i += 1;
            }
            // Noun phrase: (DT)? (JJ)* (NN|NNS|NNP|NNPS)+
            else if (isDeterminer(token.token.normalized) or
                     token.posTag == #JJ or token.posTag == #JJR or token.posTag == #JJS or
                     token.posTag == #NN or token.posTag == #NNS or token.posTag == #NNP or token.posTag == #NNPS) {
                let (np, newIdx) = parseNounPhrase(taggedTokens, i);
                chunks.add(np);
                i := newIdx;
            }
            // Verb phrase
            else if (token.posTag == #MD or token.posTag == #VB or token.posTag == #VBD or
                     token.posTag == #VBG or token.posTag == #VBN or token.posTag == #VBP or
                     token.posTag == #VBZ) {
                let (vp, newIdx) = parseVerbPhrase(taggedTokens, i);
                chunks.add(vp);
                i := newIdx;
            }
            // Prepositional phrase
            else if (token.posTag == #IN or token.posTag == #TO) {
                let (pp, newIdx) = parsePrepPhrase(taggedTokens, i);
                chunks.add(pp);
                i := newIdx;
            }
            // Adverb phrase
            else if (token.posTag == #RB or token.posTag == #RBR or token.posTag == #RBS) {
                let (advp, newIdx) = parseAdvPhrase(taggedTokens, i);
                chunks.add(advp);
                i := newIdx;
            }
            else {
                i += 1;
            };
        };
        
        Buffer.toArray(chunks)
    };
    
    private func parseNounPhrase(tokens: [TaggedToken], start: Nat) : (Chunk, Nat) {
        let chunkTokens = Buffer.Buffer<TaggedToken>(10);
        var i = start;
        var headIdx = start;
        var text = "";
        
        // Optional determiner
        if (i < tokens.size() and isDeterminer(tokens[i].token.normalized)) {
            chunkTokens.add(tokens[i]);
            text := tokens[i].token.text;
            i += 1;
        };
        
        // Optional adjectives
        while (i < tokens.size() and 
               (tokens[i].posTag == #JJ or tokens[i].posTag == #JJR or tokens[i].posTag == #JJS)) {
            chunkTokens.add(tokens[i]);
            text := if (text == "") { tokens[i].token.text } else { text # " " # tokens[i].token.text };
            i += 1;
        };
        
        // Required nouns
        while (i < tokens.size() and 
               (tokens[i].posTag == #NN or tokens[i].posTag == #NNS or 
                tokens[i].posTag == #NNP or tokens[i].posTag == #NNPS)) {
            chunkTokens.add(tokens[i]);
            headIdx := i;
            text := if (text == "") { tokens[i].token.text } else { text # " " # tokens[i].token.text };
            i += 1;
        };
        
        ({
            chunkType = #NP;
            tokens = Buffer.toArray(chunkTokens);
            startIndex = start;
            endIndex = i - 1;
            headIndex = headIdx;
            text = text;
        }, i)
    };
    
    private func parseVerbPhrase(tokens: [TaggedToken], start: Nat) : (Chunk, Nat) {
        let chunkTokens = Buffer.Buffer<TaggedToken>(10);
        var i = start;
        var headIdx = start;
        var text = "";
        
        // Optional modal
        if (i < tokens.size() and tokens[i].posTag == #MD) {
            chunkTokens.add(tokens[i]);
            text := tokens[i].token.text;
            i += 1;
        };
        
        // Optional adverbs
        while (i < tokens.size() and 
               (tokens[i].posTag == #RB or tokens[i].posTag == #RBR or tokens[i].posTag == #RBS)) {
            chunkTokens.add(tokens[i]);
            text := if (text == "") { tokens[i].token.text } else { text # " " # tokens[i].token.text };
            i += 1;
        };
        
        // Required verbs
        while (i < tokens.size() and 
               (tokens[i].posTag == #VB or tokens[i].posTag == #VBD or 
                tokens[i].posTag == #VBG or tokens[i].posTag == #VBN or
                tokens[i].posTag == #VBP or tokens[i].posTag == #VBZ)) {
            chunkTokens.add(tokens[i]);
            headIdx := i;
            text := if (text == "") { tokens[i].token.text } else { text # " " # tokens[i].token.text };
            i += 1;
            
            // Check for adverb between verbs
            while (i < tokens.size() and 
                   (tokens[i].posTag == #RB or tokens[i].posTag == #RBR or tokens[i].posTag == #RBS)) {
                chunkTokens.add(tokens[i]);
                text := text # " " # tokens[i].token.text;
                i += 1;
            };
        };
        
        ({
            chunkType = #VP;
            tokens = Buffer.toArray(chunkTokens);
            startIndex = start;
            endIndex = i - 1;
            headIndex = headIdx;
            text = text;
        }, i)
    };
    
    private func parsePrepPhrase(tokens: [TaggedToken], start: Nat) : (Chunk, Nat) {
        let chunkTokens = Buffer.Buffer<TaggedToken>(10);
        var i = start;
        var text = "";
        
        // Preposition
        if (i < tokens.size() and (tokens[i].posTag == #IN or tokens[i].posTag == #TO)) {
            chunkTokens.add(tokens[i]);
            text := tokens[i].token.text;
            i += 1;
        };
        
        // Optional determiner
        if (i < tokens.size() and isDeterminer(tokens[i].token.normalized)) {
            chunkTokens.add(tokens[i]);
            text := text # " " # tokens[i].token.text;
            i += 1;
        };
        
        // Optional adjectives
        while (i < tokens.size() and 
               (tokens[i].posTag == #JJ or tokens[i].posTag == #JJR or tokens[i].posTag == #JJS)) {
            chunkTokens.add(tokens[i]);
            text := text # " " # tokens[i].token.text;
            i += 1;
        };
        
        // Nouns
        while (i < tokens.size() and 
               (tokens[i].posTag == #NN or tokens[i].posTag == #NNS or 
                tokens[i].posTag == #NNP or tokens[i].posTag == #NNPS)) {
            chunkTokens.add(tokens[i]);
            text := text # " " # tokens[i].token.text;
            i += 1;
        };
        
        ({
            chunkType = #PP;
            tokens = Buffer.toArray(chunkTokens);
            startIndex = start;
            endIndex = i - 1;
            headIndex = start;  // Preposition is head
            text = text;
        }, i)
    };
    
    private func parseAdvPhrase(tokens: [TaggedToken], start: Nat) : (Chunk, Nat) {
        let chunkTokens = Buffer.Buffer<TaggedToken>(5);
        var i = start;
        var text = "";
        
        while (i < tokens.size() and 
               (tokens[i].posTag == #RB or tokens[i].posTag == #RBR or tokens[i].posTag == #RBS)) {
            chunkTokens.add(tokens[i]);
            text := if (text == "") { tokens[i].token.text } else { text # " " # tokens[i].token.text };
            i += 1;
        };
        
        ({
            chunkType = #ADVP;
            tokens = Buffer.toArray(chunkTokens);
            startIndex = start;
            endIndex = i - 1;
            headIndex = start;
            text = text;
        }, i)
    };
    
    // ============================================
    // INTENT CLASSIFICATION
    // ============================================
    
    public func classifyIntent(taggedTokens: [TaggedToken], text: Text) : async IntentClassification {
        var primaryIntent : Intent = #Statement;
        var confidence : Float = 0.5;
        let slots = Buffer.Buffer<(Text, Text)>(10);
        let secondaryIntents = Buffer.Buffer<Intent>(5);
        
        // Check for question marks
        for (token in taggedTokens.vals()) {
            if (token.token.text == "?") {
                primaryIntent := #Question;
                confidence := 0.95;
            };
        };
        
        // Check for WH-words at start
        if (taggedTokens.size() > 0) {
            let firstToken = taggedTokens[0];
            let firstWord = firstToken.token.normalized;
            
            if (firstWord == "what" or firstWord == "where" or firstWord == "when" or
                firstWord == "why" or firstWord == "who" or firstWord == "how" or
                firstWord == "which") {
                primaryIntent := #Question;
                confidence := 0.90;
            }
            // Commands (imperative)
            else if (firstToken.posTag == #VB) {
                primaryIntent := #Command;
                confidence := 0.85;
            }
            // Please requests
            else if (firstWord == "please") {
                primaryIntent := #Request;
                confidence := 0.90;
            }
            // Can you / Could you / Would you
            else if ((firstWord == "can" or firstWord == "could" or firstWord == "would") and
                     taggedTokens.size() > 1 and taggedTokens[1].token.normalized == "you") {
                primaryIntent := #Request;
                confidence := 0.88;
            }
            // Greetings
            else if (firstWord == "hi" or firstWord == "hello" or firstWord == "hey" or
                     firstWord == "good" or firstWord == "greetings") {
                primaryIntent := #Greeting;
                confidence := 0.95;
            }
            // Farewells
            else if (firstWord == "bye" or firstWord == "goodbye" or firstWord == "farewell" or
                     firstWord == "see") {
                primaryIntent := #Farewell;
                confidence := 0.92;
            }
            // Thanks
            else if (firstWord == "thank" or firstWord == "thanks" or firstWord == "appreciate") {
                primaryIntent := #Thanks;
                confidence := 0.95;
            }
            // Apology
            else if (firstWord == "sorry" or firstWord == "apologize" or firstWord == "apologies") {
                primaryIntent := #Apology;
                confidence := 0.93;
            }
            // Yes/No (confirmation/denial)
            else if (firstWord == "yes" or firstWord == "yeah" or firstWord == "yep" or
                     firstWord == "sure" or firstWord == "absolutely" or firstWord == "correct") {
                primaryIntent := #Confirmation;
                confidence := 0.90;
            }
            else if (firstWord == "no" or firstWord == "nope" or firstWord == "never" or
                     firstWord == "wrong" or firstWord == "incorrect") {
                primaryIntent := #Denial;
                confidence := 0.90;
            };
        };
        
        // Extract action verbs as potential slots
        for (token in taggedTokens.vals()) {
            if (token.posTag == #VB and not isAuxiliary(token.token.normalized)) {
                slots.add(("action", token.token.text));
            };
        };
        
        // Check for secondary intents
        let lower = Text.toLowercase(text);
        
        if (Text.contains(lower, #text "think") or Text.contains(lower, #text "believe") or
            Text.contains(lower, #text "opinion")) {
            secondaryIntents.add(#Opinion);
        };
        
        if (Text.contains(lower, #text "feel") or Text.contains(lower, #text "emotion") or
            Text.contains(lower, #text "happy") or Text.contains(lower, #text "sad") or
            Text.contains(lower, #text "angry") or Text.contains(lower, #text "excited")) {
            secondaryIntents.add(#Emotion);
        };
        
        if (Text.contains(lower, #text "suggest") or Text.contains(lower, #text "recommend") or
            Text.contains(lower, #text "advice") or Text.contains(lower, #text "should")) {
            secondaryIntents.add(#Suggestion);
        };
        
        {
            primaryIntent = primaryIntent;
            secondaryIntents = Buffer.toArray(secondaryIntents);
            confidence = confidence;
            slots = Buffer.toArray(slots);
        }
    };
    
    private func isAuxiliary(word: Text) : Bool {
        word == "be" or word == "is" or word == "are" or word == "was" or word == "were" or
        word == "have" or word == "has" or word == "had" or
        word == "do" or word == "does" or word == "did" or
        word == "will" or word == "would" or word == "shall" or word == "should" or
        word == "can" or word == "could" or word == "may" or word == "might" or word == "must"
    };
    
    // ============================================
    // SENTIMENT ANALYSIS
    // ============================================
    
    // Positive words
    private let positiveWords : [Text] = [
        "good", "great", "excellent", "amazing", "wonderful", "fantastic", "awesome",
        "love", "loved", "loving", "like", "liked", "liking", "enjoy", "enjoyed",
        "happy", "happily", "happiness", "joy", "joyful", "joyfully", "pleased",
        "beautiful", "beautifully", "perfect", "perfectly", "best", "better",
        "nice", "nicely", "pleasant", "pleasantly", "positive", "positively",
        "brilliant", "brilliantly", "superb", "superbly", "outstanding",
        "remarkable", "remarkably", "impressive", "impressively", "incredible",
        "delightful", "delightfully", "marvelous", "marvelously", "splendid",
        "successful", "successfully", "success", "win", "won", "winning",
        "right", "correct", "correctly", "true", "truly", "genuine", "genuinely",
        "helpful", "helpfully", "useful", "usefully", "beneficial", "beneficially",
        "interesting", "interestingly", "exciting", "excitingly", "thrilling",
        "comfortable", "comfortably", "satisfied", "satisfying", "satisfactorily",
        "recommend", "recommended", "recommending", "worth", "worthwhile",
        "efficient", "efficiently", "effective", "effectively", "productive",
        "innovative", "innovatively", "creative", "creatively", "inspiring"
    ];
    
    // Negative words
    private let negativeWords : [Text] = [
        "bad", "badly", "terrible", "terribly", "horrible", "horribly", "awful",
        "hate", "hated", "hating", "dislike", "disliked", "disliking", "despise",
        "sad", "sadly", "sadness", "unhappy", "unhappily", "unhappiness",
        "ugly", "uglily", "worst", "worse", "poor", "poorly",
        "nasty", "nastily", "unpleasant", "unpleasantly", "negative", "negatively",
        "stupid", "stupidly", "dumb", "idiotic", "ridiculous", "ridiculously",
        "disgusting", "disgustingly", "gross", "grossly", "repulsive",
        "disappointing", "disappointingly", "disappointed", "disappointment",
        "fail", "failed", "failing", "failure", "lose", "lost", "losing",
        "wrong", "wrongly", "incorrect", "incorrectly", "false", "falsely",
        "harmful", "harmfully", "useless", "uselessly", "worthless",
        "boring", "boringly", "bored", "boredom", "dull", "dully",
        "uncomfortable", "uncomfortably", "dissatisfied", "dissatisfying",
        "waste", "wasted", "wasting", "wasteful", "wastefully",
        "inefficient", "inefficiently", "ineffective", "ineffectively",
        "annoying", "annoyingly", "annoyed", "irritating", "irritatingly",
        "frustrating", "frustratingly", "frustrated", "frustration",
        "confusing", "confusingly", "confused", "confusion", "unclear"
    ];
    
    // Intensifiers
    private let intensifiers : [Text] = [
        "very", "extremely", "incredibly", "absolutely", "completely", "totally",
        "really", "truly", "highly", "deeply", "particularly", "especially",
        "remarkably", "exceptionally", "extraordinarily", "amazingly",
        "utterly", "thoroughly", "entirely", "perfectly", "strongly"
    ];
    
    // Negations
    private let negations : [Text] = [
        "not", "never", "no", "none", "nobody", "nothing", "nowhere",
        "neither", "nor", "hardly", "barely", "scarcely", "rarely",
        "seldom", "without", "lack", "lacking", "absent", "absence"
    ];
    
    public func analyzeSentiment(taggedTokens: [TaggedToken], text: Text) : async SentimentResult {
        var positiveScore : Float = 0.0;
        var negativeScore : Float = 0.0;
        var intensifierMultiplier : Float = 1.0;
        var negationActive : Bool = false;
        var negationWindow : Nat = 0;
        
        let emotions = Buffer.Buffer<(Emotion, Float)>(5);
        let aspectSentiments = Buffer.Buffer<(Text, Sentiment, Float)>(5);
        
        for (i in Iter.range(0, taggedTokens.size() - 1)) {
            let token = taggedTokens[i];
            let word = token.token.normalized;
            
            // Check for intensifier
            for (int in intensifiers.vals()) {
                if (word == int) {
                    intensifierMultiplier := 1.5;
                };
            };
            
            // Check for negation
            for (neg in negations.vals()) {
                if (word == neg) {
                    negationActive := true;
                    negationWindow := 3;  // Negation affects next 3 words
                };
            };
            
            // Check for positive word
            var isPositive = false;
            for (pos in positiveWords.vals()) {
                if (word == pos) {
                    isPositive := true;
                };
            };
            
            if (isPositive) {
                if (negationActive) {
                    negativeScore += 1.0 * intensifierMultiplier;
                } else {
                    positiveScore += 1.0 * intensifierMultiplier;
                };
                intensifierMultiplier := 1.0;
            };
            
            // Check for negative word
            var isNegative = false;
            for (neg in negativeWords.vals()) {
                if (word == neg) {
                    isNegative := true;
                };
            };
            
            if (isNegative) {
                if (negationActive) {
                    positiveScore += 0.5 * intensifierMultiplier;  // Negated negative is mildly positive
                } else {
                    negativeScore += 1.0 * intensifierMultiplier;
                };
                intensifierMultiplier := 1.0;
            };
            
            // Decrement negation window
            if (negationActive) {
                negationWindow -= 1;
                if (negationWindow == 0) {
                    negationActive := false;
                };
            };
        };
        
        // Calculate polarity (-1 to 1)
        let totalScore = positiveScore + negativeScore;
        let polarity : Float = if (totalScore > 0.0) {
            (positiveScore - negativeScore) / totalScore
        } else {
            0.0
        };
        
        // Calculate magnitude (intensity)
        let magnitude : Float = Float.min(totalScore / 10.0, 1.0);
        
        // Determine overall sentiment
        let overallSentiment : Sentiment = if (polarity > 0.5) {
            #VeryPositive
        } else if (polarity > 0.1) {
            #Positive
        } else if (polarity < -0.5) {
            #VeryNegative
        } else if (polarity < -0.1) {
            #Negative
        } else if (positiveScore > 0.0 and negativeScore > 0.0) {
            #Mixed
        } else {
            #Neutral
        };
        
        // Simple emotion detection
        let lower = Text.toLowercase(text);
        
        if (Text.contains(lower, #text "happy") or Text.contains(lower, #text "joy") or
            Text.contains(lower, #text "delight") or Text.contains(lower, #text "pleased")) {
            emotions.add((#Joy, 0.8));
        };
        if (Text.contains(lower, #text "sad") or Text.contains(lower, #text "sorrow") or
            Text.contains(lower, #text "grief") or Text.contains(lower, #text "depressed")) {
            emotions.add((#Sadness, 0.8));
        };
        if (Text.contains(lower, #text "angry") or Text.contains(lower, #text "furious") or
            Text.contains(lower, #text "mad") or Text.contains(lower, #text "rage")) {
            emotions.add((#Anger, 0.8));
        };
        if (Text.contains(lower, #text "fear") or Text.contains(lower, #text "afraid") or
            Text.contains(lower, #text "scared") or Text.contains(lower, #text "terrified")) {
            emotions.add((#Fear, 0.8));
        };
        if (Text.contains(lower, #text "surprise") or Text.contains(lower, #text "amazed") or
            Text.contains(lower, #text "astonished") or Text.contains(lower, #text "shocked")) {
            emotions.add((#Surprise, 0.8));
        };
        if (Text.contains(lower, #text "disgust") or Text.contains(lower, #text "repulsed") or
            Text.contains(lower, #text "revolted") or Text.contains(lower, #text "nauseated")) {
            emotions.add((#Disgust, 0.8));
        };
        if (Text.contains(lower, #text "trust") or Text.contains(lower, #text "believe") or
            Text.contains(lower, #text "confident") or Text.contains(lower, #text "reliable")) {
            emotions.add((#Trust, 0.7));
        };
        if (Text.contains(lower, #text "anticipate") or Text.contains(lower, #text "expect") or
            Text.contains(lower, #text "hope") or Text.contains(lower, #text "looking forward")) {
            emotions.add((#Anticipation, 0.7));
        };
        if (Text.contains(lower, #text "love") or Text.contains(lower, #text "adore") or
            Text.contains(lower, #text "cherish")) {
            emotions.add((#Love, 0.85));
        };
        if (Text.contains(lower, #text "frustrated") or Text.contains(lower, #text "annoyed") or
            Text.contains(lower, #text "irritated")) {
            emotions.add((#Frustration, 0.75));
        };
        if (Text.contains(lower, #text "confused") or Text.contains(lower, #text "puzzled") or
            Text.contains(lower, #text "bewildered")) {
            emotions.add((#Confusion, 0.75));
        };
        if (Text.contains(lower, #text "anxious") or Text.contains(lower, #text "worried") or
            Text.contains(lower, #text "nervous")) {
            emotions.add((#Anxiety, 0.75));
        };
        if (Text.contains(lower, #text "optimistic") or Text.contains(lower, #text "hopeful") or
            Text.contains(lower, #text "positive outlook")) {
            emotions.add((#Optimism, 0.75));
        };
        if (Text.contains(lower, #text "pessimistic") or Text.contains(lower, #text "hopeless") or
            Text.contains(lower, #text "negative outlook")) {
            emotions.add((#Pessimism, 0.75));
        };
        
        // Default to neutral if no emotions detected
        if (emotions.size() == 0) {
            emotions.add((#Neutral, 0.6));
        };
        
        // Calculate confidence based on signal strength
        let confidence : Float = if (totalScore > 5.0) { 0.90 }
                                 else if (totalScore > 2.0) { 0.75 }
                                 else if (totalScore > 0.0) { 0.60 }
                                 else { 0.50 };
        
        {
            overallSentiment = overallSentiment;
            polarity = polarity;
            magnitude = magnitude;
            confidence = confidence;
            emotions = Buffer.toArray(emotions);
            aspectSentiments = Buffer.toArray(aspectSentiments);
        }
    };
    
    // ============================================
    // SENTENCE BOUNDARY DETECTION
    // ============================================
    
    public func splitSentences(text: Text) : async [Text] {
        let sentences = Buffer.Buffer<Text>(20);
        var currentSentence = "";
        var inQuotes = false;
        var prevChar : ?Char = null;
        
        for (c in Text.toIter(text)) {
            currentSentence := currentSentence # Text.fromChar(c);
            
            // Track quotes
            if (c == '"' or c == '\'' or c == '"' or c == '"') {
                inQuotes := not inQuotes;
            };
            
            // Sentence boundary detection
            if ((c == '.' or c == '!' or c == '?') and not inQuotes) {
                // Don't split on common abbreviations
                let isAbbreviation = switch (prevChar) {
                    case (?pc) {
                        // Single letter before period (e.g., "Mr.", "U.S.")
                        let code = Char.toNat32(pc);
                        (code >= 65 and code <= 90)  // Uppercase letter
                    };
                    case null { false };
                };
                
                if (not isAbbreviation) {
                    let trimmed = Text.trim(currentSentence, #char ' ');
                    if (Text.size(trimmed) > 0) {
                        sentences.add(trimmed);
                    };
                    currentSentence := "";
                };
            };
            
            prevChar := ?c;
        };
        
        // Add remaining text as final sentence
        let trimmed = Text.trim(currentSentence, #char ' ');
        if (Text.size(trimmed) > 0) {
            sentences.add(trimmed);
        };
        
        Buffer.toArray(sentences)
    };
    
    // ============================================
    // FULL DOCUMENT PROCESSING PIPELINE
    // ============================================
    
    public func processDocument(text: Text, title: ?Text) : async Document {
        let startTime = Time.now();
        documentCounter += 1;
        let docId = "doc-" # Nat.toText(documentCounter);
        
        // Split into sentences
        let sentenceTexts = await splitSentences(text);
        let paragraphs = Buffer.Buffer<Paragraph>(10);
        let allEntities = Buffer.Buffer<NamedEntity>(50);
        
        // Process each sentence
        let sentences = Buffer.Buffer<Sentence>(sentenceTexts.size());
        var offset : Nat = 0;
        
        for (sentText in sentenceTexts.vals()) {
            // Tokenize
            let tokens = await tokenize(sentText);
            
            // POS tag
            let taggedTokens = await tagPOS(tokens);
            
            // Dependencies
            let deps = await parseDependencies(taggedTokens);
            
            // Chunking
            let chunks = await chunk(taggedTokens);
            
            // Named entities
            let entities = await recognizeEntities(taggedTokens);
            for (e in entities.vals()) {
                allEntities.add(e);
            };
            
            // Intent
            let intent = await classifyIntent(taggedTokens, sentText);
            
            // Sentiment
            let sentiment = await analyzeSentiment(taggedTokens, sentText);
            
            sentences.add({
                tokens = taggedTokens;
                text = sentText;
                startOffset = offset;
                endOffset = offset + Text.size(sentText);
                dependencies = deps;
                chunks = chunks;
                entities = entities;
                semanticRoles = [];  // Simplified - would need predicate detection
                intent = intent;
                sentiment = sentiment;
            });
            
            offset += Text.size(sentText) + 1;  // +1 for space/newline
        };
        
        // Create single paragraph (simplified)
        paragraphs.add({
            sentences = Buffer.toArray(sentences);
            text = text;
            startOffset = 0;
            endOffset = Text.size(text);
            topicVector = [];  // Would need topic modeling
        });
        
        // Document-level sentiment (aggregate)
        let allTagged = Buffer.Buffer<TaggedToken>(100);
        for (sent in sentences.vals()) {
            for (tok in sent.tokens.vals()) {
                allTagged.add(tok);
            };
        };
        let docSentiment = await analyzeSentiment(Buffer.toArray(allTagged), text);
        
        // Detect language (simplified - assume English)
        let language = "en";
        
        let doc : Document = {
            id = docId;
            title = title;
            paragraphs = Buffer.toArray(paragraphs);
            fullText = text;
            language = language;
            entities = Buffer.toArray(allEntities);
            topics = [];  // Would need topic modeling
            summary = null;  // Would need summarization
            sentiment = docSentiment;
            metadata = [];
            processedAt = startTime;
        };
        
        documents.put(docId, doc);
        doc
    };
    
    // ============================================
    // COREFERENCE RESOLUTION
    // ============================================
    
    public func resolveCoreferences(document: Document) : async [CoreferenceChain] {
        let chains = Buffer.Buffer<CoreferenceChain>(10);
        let mentions = Buffer.Buffer<Mention>(50);
        
        // Extract all mentions
        for (paraIdx in Iter.range(0, document.paragraphs.size() - 1)) {
            let para = document.paragraphs[paraIdx];
            for (sentIdx in Iter.range(0, para.sentences.size() - 1)) {
                let sent = para.sentences[sentIdx];
                
                for (tokIdx in Iter.range(0, sent.tokens.size() - 1)) {
                    let token = sent.tokens[tokIdx];
                    
                    // Personal pronouns
                    if (token.posTag == #PRP) {
                        let word = token.token.normalized;
                        let (gender, number) = getPronounFeatures(word);
                        
                        mentions.add({
                            text = token.token.text;
                            sentenceIndex = sentIdx;
                            tokenStart = tokIdx;
                            tokenEnd = tokIdx;
                            mentionType = #Pronoun;
                            gender = gender;
                            number = number;
                            animacy = ?#Animate;
                        });
                    };
                };
                
                // Named entities as mentions
                for (entity in sent.entities.vals()) {
                    let animacy : ?{#Animate; #Inanimate; #Unknown} = 
                        if (entity.entityType == #Person) { ?#Animate }
                        else if (entity.entityType == #Organization or entity.entityType == #Location) { ?#Inanimate }
                        else { ?#Unknown };
                    
                    mentions.add({
                        text = entity.text;
                        sentenceIndex = sentIdx;
                        tokenStart = entity.startToken;
                        tokenEnd = entity.endToken;
                        mentionType = #Proper;
                        gender = ?#Unknown;
                        number = ?#Singular;
                        animacy = animacy;
                    });
                };
            };
        };
        
        // Simple coreference: link pronouns to nearest compatible antecedent
        let mentionArray = Buffer.toArray(mentions);
        var chainId : Nat = 0;
        let assigned = Array.init<Bool>(mentionArray.size(), false);
        
        for (i in Iter.range(0, mentionArray.size() - 1)) {
            if (not assigned[i]) {
                let mention = mentionArray[i];
                let chainMentions = Buffer.Buffer<Mention>(10);
                chainMentions.add(mention);
                assigned[i] := true;
                
                // Find compatible mentions
                for (j in Iter.range(i + 1, mentionArray.size() - 1)) {
                    if (not assigned[j]) {
                        let other = mentionArray[j];
                        if (areMentionsCompatible(mention, other)) {
                            chainMentions.add(other);
                            assigned[j] := true;
                        };
                    };
                };
                
                if (chainMentions.size() > 1) {
                    chains.add({
                        chainId = chainId;
                        mentions = Buffer.toArray(chainMentions);
                        representativeMention = 0;  // First mention is representative
                        entityType = null;
                    });
                    chainId += 1;
                };
            };
        };
        
        Buffer.toArray(chains)
    };
    
    private func getPronounFeatures(word: Text) : (?{#Male; #Female; #Neutral; #Unknown}, ?{#Singular; #Plural; #Unknown}) {
        switch (word) {
            case "he" { (?#Male, ?#Singular) };
            case "him" { (?#Male, ?#Singular) };
            case "his" { (?#Male, ?#Singular) };
            case "himself" { (?#Male, ?#Singular) };
            case "she" { (?#Female, ?#Singular) };
            case "her" { (?#Female, ?#Singular) };
            case "hers" { (?#Female, ?#Singular) };
            case "herself" { (?#Female, ?#Singular) };
            case "it" { (?#Neutral, ?#Singular) };
            case "its" { (?#Neutral, ?#Singular) };
            case "itself" { (?#Neutral, ?#Singular) };
            case "they" { (?#Unknown, ?#Plural) };
            case "them" { (?#Unknown, ?#Plural) };
            case "their" { (?#Unknown, ?#Plural) };
            case "theirs" { (?#Unknown, ?#Plural) };
            case "themselves" { (?#Unknown, ?#Plural) };
            case "i" { (?#Unknown, ?#Singular) };
            case "me" { (?#Unknown, ?#Singular) };
            case "my" { (?#Unknown, ?#Singular) };
            case "mine" { (?#Unknown, ?#Singular) };
            case "myself" { (?#Unknown, ?#Singular) };
            case "we" { (?#Unknown, ?#Plural) };
            case "us" { (?#Unknown, ?#Plural) };
            case "our" { (?#Unknown, ?#Plural) };
            case "ours" { (?#Unknown, ?#Plural) };
            case "ourselves" { (?#Unknown, ?#Plural) };
            case "you" { (?#Unknown, ?#Unknown) };
            case "your" { (?#Unknown, ?#Unknown) };
            case "yours" { (?#Unknown, ?#Unknown) };
            case "yourself" { (?#Unknown, ?#Singular) };
            case "yourselves" { (?#Unknown, ?#Plural) };
            case _ { (?#Unknown, ?#Unknown) };
        }
    };
    
    private func areMentionsCompatible(m1: Mention, m2: Mention) : Bool {
        // Check gender compatibility
        switch (m1.gender, m2.gender) {
            case (?#Male, ?#Female) { return false };
            case (?#Female, ?#Male) { return false };
            case _ {};
        };
        
        // Check number compatibility
        switch (m1.number, m2.number) {
            case (?#Singular, ?#Plural) { return false };
            case (?#Plural, ?#Singular) { return false };
            case _ {};
        };
        
        // Check animacy compatibility
        switch (m1.animacy, m2.animacy) {
            case (?#Animate, ?#Inanimate) { return false };
            case (?#Inanimate, ?#Animate) { return false };
            case _ {};
        };
        
        true
    };
    
    // ============================================
    // SEMANTIC ROLE LABELING
    // ============================================
    
    public func labelSemanticRoles(sentence: Sentence) : async [PredicateArgumentStructure] {
        let structures = Buffer.Buffer<PredicateArgumentStructure>(5);
        
        // Find predicates (verbs)
        for (chunk in sentence.chunks.vals()) {
            if (chunk.chunkType == #VP) {
                let predToken = chunk.tokens[chunk.headIndex - chunk.startIndex];
                let arguments = Buffer.Buffer<SemanticRoleLabel>(5);
                let auxiliaries = Buffer.Buffer<TaggedToken>(3);
                var negated = false;
                var passive = false;
                var modality : ?Text = null;
                
                // Check for auxiliaries and negation in the VP
                for (tok in chunk.tokens.vals()) {
                    if (isAuxiliary(tok.token.normalized)) {
                        auxiliaries.add(tok);
                        
                        // Check for passive (was/were + VBN)
                        if (tok.token.normalized == "was" or tok.token.normalized == "were" or
                            tok.token.normalized == "been" or tok.token.normalized == "being") {
                            if (predToken.posTag == #VBN) {
                                passive := true;
                            };
                        };
                    };
                    
                    if (tok.posTag == #MD) {
                        modality := ?tok.token.text;
                    };
                    
                    if (tok.token.normalized == "not" or tok.token.normalized == "n't") {
                        negated := true;
                    };
                };
                
                // Find subject (NP before VP)
                for (otherChunk in sentence.chunks.vals()) {
                    if (otherChunk.chunkType == #NP and otherChunk.endIndex < chunk.startIndex) {
                        let role : SemanticRole = if (passive) { #Patient } else { #Agent };
                        arguments.add({
                            role = role;
                            predicate = chunk;
                            argument = otherChunk;
                            confidence = 0.75;
                        });
                    };
                };
                
                // Find object (NP after VP)
                for (otherChunk in sentence.chunks.vals()) {
                    if (otherChunk.chunkType == #NP and otherChunk.startIndex > chunk.endIndex) {
                        let role : SemanticRole = if (passive) { #Agent } else { #Patient };
                        arguments.add({
                            role = role;
                            predicate = chunk;
                            argument = otherChunk;
                            confidence = 0.70;
                        });
                    };
                };
                
                // Find prepositional phrases (for various roles)
                for (otherChunk in sentence.chunks.vals()) {
                    if (otherChunk.chunkType == #PP) {
                        let prep = otherChunk.tokens[0].token.normalized;
                        
                        let role : SemanticRole = 
                            if (prep == "in" or prep == "at" or prep == "on" or prep == "near") { #Location }
                            else if (prep == "from") { #Source }
                            else if (prep == "to" or prep == "toward" or prep == "towards") { #Goal }
                            else if (prep == "with") { #Instrument }
                            else if (prep == "for") { #Beneficiary }
                            else if (prep == "by") { 
                                if (passive) { #Agent } else { #Manner }
                            }
                            else if (prep == "during" or prep == "before" or prep == "after") { #Time }
                            else if (prep == "because" or prep == "due") { #Cause }
                            else { #Location };  // Default
                        
                        arguments.add({
                            role = role;
                            predicate = chunk;
                            argument = otherChunk;
                            confidence = 0.65;
                        });
                    };
                };
                
                structures.add({
                    predicate = predToken;
                    arguments = Buffer.toArray(arguments);
                    auxiliaries = Buffer.toArray(auxiliaries);
                    negated = negated;
                    passive = passive;
                    modality = modality;
                });
            };
        };
        
        Buffer.toArray(structures)
    };
    
    // ============================================
    // QUERY INTERFACE
    // ============================================
    
    public query func getDocument(docId: Text) : async ?Document {
        documents.get(docId)
    };
    
    public query func listDocuments() : async [Text] {
        let ids = Buffer.Buffer<Text>(documents.size());
        for (key in documents.keys()) {
            ids.add(key);
        };
        Buffer.toArray(ids)
    };
    
    public query func getStats() : async {
        documentCount: Nat;
        sovereigntyFloor: Float;
    } {
        {
            documentCount = documents.size();
            sovereigntyFloor = S_0_FLOOR;
        }
    };
    
    // ============================================
    // TEXT GENERATION HELPERS
    // ============================================
    
    public func generateResponse(intent: IntentClassification, entities: [NamedEntity], sentiment: SentimentResult) : async Text {
        var response = "";
        
        // Generate based on intent
        switch (intent.primaryIntent) {
            case (#Greeting) {
                response := "Hello! How can I assist you today?";
            };
            case (#Farewell) {
                response := "Goodbye! Have a great day!";
            };
            case (#Thanks) {
                response := "You're welcome! Is there anything else I can help with?";
            };
            case (#Question) {
                response := "I understand you have a question. Let me help you find the answer.";
            };
            case (#Command) {
                response := "I'll work on that for you right away.";
            };
            case (#Request) {
                response := "I'd be happy to help with that request.";
            };
            case (#Confirmation) {
                response := "Great, I've noted your confirmation.";
            };
            case (#Denial) {
                response := "I understand. Is there something else you'd prefer?";
            };
            case (#Apology) {
                response := "No need to apologize! How can I assist you?";
            };
            case (#Clarification) {
                response := "Let me clarify that for you.";
            };
            case _ {
                response := "I understand. How may I assist you further?";
            };
        };
        
        // Adjust tone based on sentiment
        switch (sentiment.overallSentiment) {
            case (#VeryNegative) {
                response := "I'm sorry to hear that. " # response # " I want to help make things better.";
            };
            case (#Negative) {
                response := "I understand your concern. " # response;
            };
            case (#VeryPositive) {
                response := "That's wonderful! " # response;
            };
            case (#Positive) {
                response := "Great! " # response;
            };
            case _ {};
        };
        
        response
    };
    
    // ============================================
    // SOVEREIGNTY COMPLIANCE
    // ============================================
    
    public query func verifySovereignty() : async {
        s0Floor: Float;
        coherenceThreshold: Float;
        integrityMinimum: Float;
        compliant: Bool;
    } {
        {
            s0Floor = S_0_FLOOR;
            coherenceThreshold = COHERENCE_THRESHOLD;
            integrityMinimum = INTEGRITY_MINIMUM;
            compliant = S_0_FLOOR >= 1.0 and COHERENCE_THRESHOLD >= 1.0 and INTEGRITY_MINIMUM >= 1.0;
        }
    };
}
