% Name: Elizabeth Brooks
% Modified: 08 March 2017
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

% parse rules:
parse(ProgIn,ProgOut) :-
	parseCom(ProgIn,[],ProgOut).
% parse facts:
parseCom([],AST,AST).
% parseCom rule:
parseCom([[punctuation,'('],[identifier,postfix],[number,Val]|ProgSeq],AST,[Val|[ParseH|ParseT]]) :-
	parseAST(ProgSeq,RestProg,AST,NewAST),
	parseCom(RestProg,NewAST,[ParseH|ParseT]).
parseCom(ProgSeq,AST,OutAST) :-
	parseAST(ProgSeq,RestProg,AST,NewAST),
	parseCom(RestProg,NewAST,OutAST).
parseCom([[punctuation,')'],[punctuation,eof]],AST,OutAST) :-
	revAST(AST,[],FinalAST),
	parseCom([],FinalAST,OutAST).
% parseAST facts:
parseAST([[number,Val]|RestIn],RestIn,BuildAST,[Val|BuildAST]).
parseAST([[operator,add]|RestIn],RestIn,BuildAST,[add|BuildAST]).
parseAST([[operator,sub]|RestIn],RestIn,BuildAST,[sub|BuildAST]).
parseAST([[operator,mul]|RestIn],RestIn,BuildAST,[mul|BuildAST]).
parseAST([[operator,div]|RestIn],RestIn,BuildAST,[div|BuildAST]).
parseAST([[operator,rem]|RestIn],RestIn,BuildAST,[rem|BuildAST]).
parseAST([[operator,lt]|RestIn],RestIn,BuildAST,[lt|BuildAST]).
parseAST([[operator,eq]|RestIn],RestIn,BuildAST,[eq|BuildAST]).
parseAST([[operator,gt]|RestIn],RestIn,BuildAST,[gt|BuildAST]).
% parseAST rules:
parseAST([[punctuation,'(']|RestIn],RestIn,BuildAST,[[ComH|ComT]|BuildAST]) :-
	comSeq(RestIn,BuildAST,[ComH|ComT]).
% comSeq rules:
comSeq([[punctuation,')']|_],ComAST,ResAST) :-
	revAST(ComAST,[],ResAST).
comSeq(SeqIn,InAST,ResAST) :-
	exprCom(SeqIn,RestSeq,InAST,ComAST),
	comSeq(RestSeq,ComAST,[ComAST|ResAST]).
% revAST fact:
revAST([],TempAST,TempAST).
% revAST rule:
revAST([ASTHH|ASTT],TempAST,RevdAST) :-
	revAST(ASTT,[ASTHH|TempAST],RevdAST).