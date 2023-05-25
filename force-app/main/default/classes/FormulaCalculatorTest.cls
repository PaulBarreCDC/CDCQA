@isTest
private class FormulaCalculatorTest {
  @isTest
  private static void TestSimpleFormulaParsing() {
    FormulaCalculator formCalc = new FormulaCalculator();
    FormulaCalculator.FormulaResponse result = formCalc.calculateFormula('1+2',null);
    System.assert(formCalc.formulaTokens == new List<String>{'1','+','2'}, 'Tokenizer split function error.');
    System.assert(formCalc.operandsStacks.get('LVL0') == new List<String>{'1','2'}, 'Should contain only the numbers.');
    System.assert(formCalc.operatorsStacks.get('LVL0') == new List<String>{'+'}, 'Should contain only the operators');
    System.assert(result.value == 3.0, 'Simple 1+2=3, but it is ' + String.valueOf(result.value));
  }
  @isTest
  private static void TestSimpleFormulaSubstitution() {
    FormulaCalculator formCalc = new FormulaCalculator();
    Map<String, String> operandsMap = new Map<String, String>();
    operandsMap.put('{{a}}','1');
    operandsMap.put('{{b}}','2');
    FormulaCalculator.FormulaResponse result = formCalc.calculateFormula('{{a}}+{{b}}', operandsMap);
    System.assert(formCalc.formulaTokens == new List<String>{'{{a}}','+','{{b}}'}, 'Tokenizer split function error.');
    System.assert(formCalc.operandsStacks.get('LVL0') == new List<String>{'1','2'}, 'Should contain only the numbers.');
    System.assert(formCalc.operatorsStacks.get('LVL0') == new List<String>{'+'}, 'Should contain only the operators');
    System.assert(result.value == 3.0, 'Simple 1+2=3, but it is ' + String.valueOf(result.value));
  }
  @isTest
  private static void TestParenthesisParsing() {
    FormulaCalculator formCalc = new FormulaCalculator();
    FormulaCalculator.FormulaResponse result = formCalc.calculateFormula('1+(2-3)',null);
    System.assert(formCalc.formulaTokens == new List<String>{'1','+','(','2','-','3',')'}, 'Tokenizer split function error.');
    System.assert(formCalc.operandsStacks.get('LVL0') == new List<String>{'1','-1'}, 'The second number should be a decimal representation of what is in the parenthesis');
    System.assert(formCalc.operatorsStacks.get('LVL0') == new List<String>{'+'}, 'Should contain only the operators');
    System.assert(formCalc.operandsStacks.get('LVL1') == new List<String>{'2','3'}, 'Should contain only the numbers.');
    System.assert(formCalc.operatorsStacks.get('LVL1') == new List<String>{'-'}, 'Should contain only the operators');
  }
  @isTest
  private static void TestFullFormulaPriority() {
    FormulaCalculator formCalc = new FormulaCalculator();
    FormulaCalculator.FormulaResponse result = formCalc.calculateFormula('1+(2-3)*4+5^(2+0)',null);
    for(String formulaToken : formCalc.formulaTokens) {
      System.debug('Token: ' + formulaToken); 
    }
    System.assert(formCalc.formulaTokens == new List<String>{'1','+','(','2','-','3',')','*','4','+','5','^','(','2','+','0',')'}, 'Tokenizer split function error.');
    System.assert(formCalc.operandsStacks.containsKey('LVL0'), 'Base level must exist.');
    System.assert(formCalc.operatorsStacks.containsKey('LVL1'), 'Parenthesis should create a new level.');
    System.assert(result.value == 22.0, 'Should be 22.0, but calculated: ' + String.valueOf(result.value));
  }
}