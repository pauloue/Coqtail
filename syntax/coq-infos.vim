" Author: Wolf Honore
" Original Maintainer: Laurent Georget <laurent@lgeorget.eu>
" Coq Info panel syntax definitions.

" Only load this syntax file when no other was loaded and user didn't opt out.
if exists('b:current_syntax') || get(g:, 'coqtail_nosyntax', 0)
  finish
endif
let b:current_syntax = 'coq-infos'

" Helpers
execute printf('source %s/_coq_common.vim', expand('<sfile>:p:h'))
let s:h = g:CoqtailSyntaxHelpers()

" Various
syn match   coqVernacPunctuation ":=\|\.\|:"
syn match   coqIdent             contained "[_[:alpha:]][_'[:alnum:]]*"
syn keyword coqTopLevel          Declare Type Canonical Structure Cd Coercion Derive Drop Existential

" Definitions
syn match coqDefName          "[_[:alpha:]][\._'[:alnum:]]*\_.\{-}\%(=\|:\)"me=e-1 contains=@coqTerm nextgroup=coqDefContents1,coqDefContents2
syn region coqDefName2       contained contains=coqDefBinder,coqDefType,coqDefContents1 matchgroup=coqIdent start="[_[:alpha:]][_'[:alnum:]]*" matchgroup=NONE end="\.\_s" end=":="
syn region coqDefContents1     contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" matchgroup=NONE end="^$" end="^\S"me=e-1
syn region coqDefContents2     contained contains=@coqTerm matchgroup=coqVernacPunctuation start="=" matchgroup=NONE end="^$"

syn region coqDefNameHidden     matchgroup=coqComment start="\*\*\* \[" matchgroup=coqComment end="\]" contains=@coqTerm,coqDefContents3
syn region coqDefContents3     contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end="]"me=e-1

syn region coqDef          contains=coqDefName2 matchgroup=coqVernacCmd start="\<\%(Program\_s\+\)\?\%(Definition\|Let\)\>" end="\.$"me=e-1 end="\.\s"me=e-2  keepend skipnl skipwhite skipempty

" Declarations
syn region coqDecl       contains=coqIdent,coqDeclTerm,coqDeclBinder matchgroup=coqVernacCmd start="\<\%(Axiom\|Conjecture\|Hypothes[ie]s\|Parameters\?\|Variables\?\)\>" matchgroup=coqVernacCmd end="\.\_s" keepend
syn region coqDeclBinder contained contains=coqIdent,coqDeclTerm matchgroup=coqVernacPunctuation start="(" end=")" keepend
syn region coqDeclTerm   contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end=")"
syn region coqDeclTerm   contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end="\.\_s"

" Theorems
syn region coqThm       contains=coqThmName matchgroup=coqVernacCmd start="\<\%(Program\_s\+\)\?\%(Theorem\|Lemma\|Example\|Corollary\|Remark\)\>" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\.\_s" keepend
syn region coqThmName   contained contains=coqThmTerm,coqThmBinder matchgroup=coqIdent start="[_[:alpha:]][_'[:alnum:]]*" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\.\_s"
syn region coqThmTerm   contained contains=@coqTerm,coqProofBody matchgroup=coqVernacCmd start=":" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\>"
syn region coqThmBinder contained matchgroup=coqVernacPunctuation start="(" end=")" keepend

" Modules
syn region  coqModule     contains=coqIdent,coqDef,coqThm,coqDecl,coqInd,coqModuleEnd,coqStructDef matchgroup=coqTopLevel start="\<Module\>" end="^$"
syn keyword coqModuleEnd  contained End
syn region  coqStructDef  contained contains=coqStruct matchgroup=coqVernacPunctuation start=":=" end="End"
syn region  coqStruct     contained contains=coqIdent,coqDef,coqThm,coqDec,coqInd matchgroup=coqTopLevel start="\<Struct\>" end="End"

" Terms
syn cluster coqTerm            contains=coqKwd,coqTermPunctuation,coqKwdMatch,coqKwdLet,coqKwdParen
syn region coqKwdMatch         contained contains=@coqTerm matchgroup=coqKwd start="\<match\>" end="\<with\>"
syn region coqKwdLet           contained contains=@coqTerm matchgroup=coqKwd start="\<let\>"   end=":="
syn region coqKwdParen         contained contains=@coqTerm matchgroup=coqTermPunctuation start="(" end=")" keepend extend
syn keyword coqKwd             contained else end exists2 fix forall fun if in struct then as return
syn match   coqKwd             contained "\<where\>"
syn match   coqKwd             contained "\<exists!\?"
syn match   coqKwd             contained "|\|/\\\|\\/\|<->\|\~\|->\|=>\|{\|}\|&\|+\|-\|*\|=\|>\|<\|<="
syn match coqTermPunctuation   contained ":=\|:>\|:\|;\|,\|||\|\[\|\]\|@\|?\|\<_\>"

" Sections
syn match coqSectionDelimiter  "^ >>>>>>>" nextgroup=coqSectionDecl skipwhite skipnl
syn match coqSectionDecl       contained "Section" nextgroup=coqSectionName skipwhite skipnl
syn match coqSectionName       contained "[_[:alpha:]][_'[:alnum:]]*"

" Obligations
syn region coqObligation contains=coqIdent   matchgroup=coqVernacCmd start="\<\%(\%(\%(Admit\_s\+\)\?Obligations\)\|\%(Obligation\_s\+\d\+\)\|\%(Next\_s\+Obligation\)\|Preterm\)\%(\_s\+of\)\?\>" end="\.\_s"
syn region coqObligation contains=coqOblOf   matchgroup=coqVernacCmd start="\<Solve\_s\+Obligations\>" end="\.\_s" keepend
syn region coqOblOf      contains=coqIdent,coqOblUsing matchgroup=coqVernacCmd start="\<of\>" end="\.\_s" keepend
syn region coqObligation contains=coqOblUsing   matchgroup=coqVernacCmd start="\<Solve\_s\+All\_s\+Obligations\>" end="\.\_s" keepend
syn region coqOblUsing   contains=coqLtac   matchgroup=coqVernacCmd start="\<using\>" end="\.\_s"
syn region coqObligation contains=coqOblExpr matchgroup=coqVernacCmd start="\<Obligations\_s\+Tactic\>" end="\.\_s" keepend
syn region coqOblExpr    contains=coqLtac   matchgroup=coqVernacPunctuation start=":=" end="\.\_s"

" Compute
syn region coqComputed  contains=@coqTerm matchgroup=coqVernacPunctuation start="^\s*=" matchgroup=NONE end="^$"

" Notations
syn region coqNotationDef       contains=coqNotationString,coqNotationTerm matchgroup=coqVernacCmd start="\<Notation\>\%(\s*\<Scope\>\)\?" end="^$"
syn region coqNotationTerm      contained matchgroup=coqVernacPunctuation start=":=" matchgroup=NONE end="\""me=e-1 end="^$"me=e-1 contains=coqNotationScope,coqNotationFormat
syn region coqNotationScope     contained contains=@coqTerm,coqNotationFormat matchgroup=coqVernacPunctuation start=":" end="\""me=e-1 end="^$"
syn region coqNotationFormat    contained contains=coqNotationKwd,coqString matchgroup=coqVernacPunctuation start="(" end=")"

syn match  coqNotationKwd    contained "default interpretation"

" Scopes
syn region coqScopeDef       contains=coqNotationString,coqScopeTerm,coqScopeSpecification matchgroup=coqVernacCmd start="\<Scope\>" end="^$"
syn region coqScopeTerm      contained matchgroup=coqVernacPunctuation start=":=" matchgroup=NONE end="\""me=e-1 end="^$"me=e-1 contains=@coqTerm
syn keyword coqScopeSpecification contained Delimiting key is Bound to class

syn region coqNotationString contained start=+"+ skip=+""+ end=+"+ extend

" Inductives and Constants
syn region coqInd            contains=coqIndBody start="\<\%(\%(Co\)\?Inductive\|Constant\)\>" end="^\S"me=e-1 end="^$" keepend
syn region coqIndBody        contained contains=coqIdent,coqIndTerm,coqIndBinder matchgroup=coqVernacCmd start="\%(Co\)\?Inductive\|Constant" start="\<with\>" matchgroup=NONE end="^\S"me=e-1
syn region coqIndBinder      contained contains=coqIndBinderTerm matchgroup=coqVernacPunctuation start="("  end=")" keepend
syn region coqIndBinderTerm  contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":" end=")"
syn region coqIndTerm        contained contains=@coqTerm,coqIndContent matchgroup=coqVernacPunctuation start=":" matchgroup=NONE end="^\S"me=e-1
syn region coqIndContent     contained contains=coqIndConstructor start=":=" end="^\S"me=e-1
syn region coqIndConstructor contained contains=coqConstructor,coqIndBinder,coqIndConsTerm,coqIndNot,coqIndBody matchgroup=coqVernacPunctuation start=":=\%(\_s*|\)\?" start="|" matchgroup=NONE end="^\S"me=e-1
syn region coqIndConsTerm    contained contains=coqIndBody,@coqTerm,coqIndConstructor,coqIndNot matchgroup=coqConstructor start=":" matchgroup=NONE end="^\S"me=e-1
syn region coqIndNot         contained contains=coqNotationString,coqIndNotTerm matchgroup=coqVernacCmd start="\<where\>" end="^\S"me=e-1
syn region coqIndNotTerm     contained contains=@coqTerm,coqIndNotScope,coqIndBody matchgroup=coqVernacPunctuation start=":=" end="^\S"me=e-1
syn region coqIndNotScope    contained contains=coqIndBody matchgroup=coqVernacPunctuation start=":" end="^\S"me=e-1
syn match  coqConstructor    contained "[_[:alpha:]][_'[:alnum:]]*"

" Records
syn region coqRec        contains=coqRecProfile start="\<Record\>" matchgroup=coqVernacPunctuation end="^\S"me=e-1 keepend
syn region coqRecProfile contained contains=coqIdent,coqRecTerm,coqRecBinder matchgroup=coqVernacCmd start="Record" matchgroup=NONE end="^\S"me=e-1
syn region coqRecBinder  contained contains=@coqTerm matchgroup=coqTermPunctuation start="("  end=")"
syn region coqRecTerm    contained contains=@coqTerm,coqRecContent matchgroup=coqVernacPunctuation start=":"  end="^\S"me=e-1
syn region coqRecContent contained contains=coqConstructor,coqRecStart matchgroup=coqVernacPunctuation start=":=" end="^\S"me=e-1
syn region coqRecStart   contained contains=coqRecField,@coqTerm start="{" matchgroup=coqVernacPunctuation end="}" keepend
syn region coqRecField   contained contains=coqField matchgroup=coqVernacPunctuation start="{" end=":"
syn region coqRecField   contained contains=coqField matchgroup=coqVernacPunctuation start=";" end=":"
syn match coqField       contained "[_[:alpha:]][_'[:alnum:]]*"

" Arguments specification
syn region  coqArgumentSpecification start="^\%(For \_.\{-}:\)\?\s*Argument" end="implicit" contains=@coqTerm,coqArgumentSpecificationKeywords
syn region  coqArgumentScopeSpecification start="^\%(For \_.\{-}:\)\?\s*Argument scopes\?" end="\]" contains=@coqTerm,coqArgumentSpecificationKeywords
syn keyword coqArgumentSpecificationKeywords contained Argument Arguments is are scope scopes implicit For and maximally inserted when applied to argument arguments

" Warning and errors
syn match   coqBad               contained ".*\%(w\|W\)arnings\?"
syn match   coqVeryBad           contained ".*\%(e\|E\)rrors\?"
syn region  coqWarningMsg        matchgroup=coqBad start="^.*\%(w\|W\)arnings\?:" end="$"
syn region  coqErrorMsg          matchgroup=coqVeryBad start="^.*\%(e\|E\)rrors\?:" end="$"

" Various (High priority)
syn region  coqComment           containedin=ALL contains=coqComment,coqTodo start="(\*" end="\*)" extend keepend
syn keyword coqTodo              contained TODO FIXME XXX NOTE
syn region  coqString            start=+"+ skip=+""+ end=+"+ extend

" TERMS AND TYPES
hi def link coqTerm              Type
hi def link coqKwd               coqTerm
hi def link coqTermPunctuation   coqTerm

" VERNACULAR COMMANDS
hi def link coqVernacCmd         coqVernacular
hi def link coqVernacPunctuation coqVernacular
hi def link coqTopLevel          coqVernacular
hi def link coqSectionDecl       coqTopLevel
hi def link coqModuleEnd         coqTopLevel

" DEFINED OBJECTS
hi def link coqIdent             Identifier
hi def link coqSectionName       Identifier
hi def link coqDefName           Identifier
hi def link coqDefNameHidden     Identifier
hi def link coqNotationString    coqIdent

" CONSTRUCTORS AND FIELDS
hi def link coqConstructor       Keyword
hi def link coqField             coqConstructor

" NOTATION SPECIFIC ("at level", "format", etc)
hi def link coqNotationKwd       Special

" SPECIFICATIONS
hi def link coqArgumentSpecificationKeywords Underlined
hi def link coqScopeSpecification            Underlined

" WARNINGS AND ERRORS
hi def link coqBad               WarningMsg
hi def link coqVeryBad           ErrorMsg
hi def link coqWarningMsg        WarningMsg
hi def link coqBad               WarningMsg

" USUAL VIM HIGHLIGHTINGS
" Comments
hi def link coqComment           Comment
hi def link coqSectionDelimiter  Comment
hi def link coqProofComment      coqComment

" Todo
hi def link coqTodo              Todo

" Errors
hi def link coqError             Error

" Strings
hi def link coqString            String
