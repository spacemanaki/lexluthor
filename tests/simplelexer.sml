structure SimpleLexerTests =
struct

open BasicRegExpSyntax

(* simple spec with regexp ast only *)
structure SimpleLexerSpec =
   struct
      datatype token = Num | Id
      local
         (* binary numbers *)
         val num = Concat(Altern(Symbol #"0",Symbol #"1"),
                          Repeat(Altern(Symbol #"0",Symbol #"1")))
         (* identifiers consisting only of a,b,c *)
         val id = Repeat(Altern(Symbol #"a",Altern(Symbol #"b",Symbol #"c")))
      in
         val tokens = [(num,Num),(id,Id)]
      end
   end

structure SimpleLexLuthor = LexLuthorFn(SimpleLexerSpec)

fun showToken SimpleLexerSpec.Num = "Num"
  | showToken SimpleLexerSpec.Id = "Id"

local
   val lexer = SimpleLexLuthor.mkLexer ()
in
   fun lex s = SimpleLexLuthor.lex (lexer, s)
end

local
   open Show
   open Test
in
   val assert = Test.polyAssertEq {show=(list (pair (showToken, string)))}
   val lexerTests =
       group ("simple lexer", assert,
              [
                {actual=lex "0",       expected=[(SimpleLexerSpec.Num, "0")]},
                {actual=lex "1",       expected=[(SimpleLexerSpec.Num, "1")]},
               {actual=lex "1010",       expected=[(SimpleLexerSpec.Num, "1010")]},
               {actual=lex "ab",         expected=[(SimpleLexerSpec.Id, "ab")]},
               {actual=lex "100100abab", expected=[(SimpleLexerSpec.Num, "100100"),
                                                   (SimpleLexerSpec.Id, "abab")]}
             ])
end

fun doTestRun v = Test.runTestSuite (v, lexerTests)

end
