% Name: Elizabeth Brooks
% Modified: 07 March 2017
% File: postfixParser.pl

% Prolog Parser for PostFix:
% This parser takes as input a list of tokens by the provided scanner, determines whether that
% sequence of tokens follows the syntax of the PostFix language, and produces an Abstract
% Syntax Tree (AST) representation of the program scanned by the scanner.
% The AST is expressed as a Prolog list [Num, [Commands]], where Num represents the number of
% arguments to the program and [Commands] is a Prolog list of commands.

% The syntax of the PostFix language:
% program ::= (postfix number command_sequence)
% command_sequence ::= command command_sequence
% | L
% command ::= number
% | ( command_sequence )
% | 'add' | 'sub' | 'mul' | 'div' | 'rem'
% | 'lt' | 'eq' | 'gt'
% | 'pop'
% | 'swap'
% | 'sel'
% | 'nget'
% | 'exec'

% Postfix Parser:
% The non-terminal gramar symbol arguments for the predicates is the token list before and
% after recognizing a sentential form of the given non-terminal symbol.
% To complete parsing, the list of remaining elements must be empty.

% parse rule:
parse([[punctuation,'('],[identifier,postfix]|RestIn],BuildAST) :-
 exprCom(RestIn,Prog,AST),
 exprSeq(Prog,[[punctuation,')'],[punctuation,eof]],SeqAST),	
 append(AST,[SeqAST],BuildAST).
% exprSeq fact:
exprSeq(Seq,Seq,[]).
% exprSeq rules:
exprSeq(Seq,RemSeq,BuildAST) :-
 exprCom(Seq,Prog,AST),
 exprSeq(Prog,RemSeq,NextAST),
 append(AST,NextAST,BuildAST).
% exprCom facts:
exprCom([[number,Val]|RestIn],RestIn,[Val]).
exprCom([[operator,add]|RestIn],RestIn,[add]).
exprCom([[operator,sub]|RestIn],RestIn,[sub]).
exprCom([[operator,mul]|RestIn],RestIn,[mul]).
exprCom([[operator,div]|RestIn],RestIn,[div]).
exprCom([[operator,rem]|RestIn],RestIn,[rem]).
exprCom([[operator,lt]|RestIn],RestIn,[lt]).
exprCom([[operator,eq]|RestIn],RestIn,[eq]).
exprCom([[operator,gt]|RestIn],RestIn,[gt]).
% exprCom rule:
exprCom([[punctuation,'(']|RestIn],RemSeq,[BuildAST]) :-
 exprCom(RestIn,[[punctuation,')']|RemSeq],BuildAST).