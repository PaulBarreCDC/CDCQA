public class FormulaCalculator {
  public String MSG_NO_FRM = 'No formula provided.';
  public String MSG_NO_VAR = 'No value provided for variable: ';
  public String STS_ERR = 'ERROR';
  public String MSG_FRM_CLC = 'Formula successfully processed.';
  public String STS_SCS = 'SUCCESS';
  public String LVL_PRFX = 'LVL';
  public List<String> formulaTokens;
  public Map<String,List<String>> operatorsStacks;
  public Map<String,List<String>> operandsStacks;
  private Map<String,Integer> operatorPriority = new Map<String,Integer> {
    '+' => 0,
    '-' => 0,
    '*' => 1,
    '/' => 1,
    '^' => 2,
    '(' => 3,
    ')' => 3
  };
  // Constructor : initiate lists and maps
  public FormulaCalculator() {
    formulaTokens = new List<String>();
    operatorsStacks = new Map<String,List<String>>();
    operandsStacks = new Map<String,List<String>>();
  }
  /** 
  * PURPOSE : Processes a string formula, and attempts to calculate it.  TODO: add variable replacement funcationality
  * ARGS :
  *   formualStr  String              String representation of a formula, i.e. 1-2(4-5)
  *   operandsMap Map<String, String> Map of variables in formulaStr
  **/
  public FormulaResponse calculateFormula(String formulaStr, Map<String, String> operandsMap) {
    // Instantiate container for calculation results (carries status, message, and value)
    FormulaResponse calcResult = new FormulaResponse();
    // IF the formula string provided is blank, return an error status and message
    //  ELSE begin processing the formula for calculation
    if(formulaStr == null || formulaStr == '') {
      calcResult.message = MSG_NO_FRM;
      calcResult.status = STS_ERR;
      return calcResult;
    }
    Integer lvlCounter = 0;                                 // Keeps track of what level(parenthesis content) the system is currently calculating
    String lvlKey = LVL_PRFX + String.valueOf(lvlCounter);  // Variable name for current level, this is used for substitution after each calculation
    // Add a base level (0) list for operators and operands into their respective maps
    operatorsStacks.put(lvlKey, new List<String>());
    operandsStacks.put(lvlKey, new List<String>());
    // Break up the formula at every supported mathematical operation, and loop over the results
    formulaTokens = formulaStr.split('(?<=[-+*/\\^\\(\\)])|(?=[-+*/\\^\\(\\)])');
    /** PURPOSE: This LOOP is parsing the formula string, and pre-calculating all content in parentheses **/
    for(String formulaToken : formulaTokens) {
      // IF the current token is a number, throw it in the current level's operands stack
      //  ELSE IF the current token is a left parenthesis, place the key into the operand stack as a variable, and create a new level in the operands and operators stacks
      //  ELSE IF the current token is a right parenthesis, calculate the contents of (), move the key down a level, and substitute the variable LVL# placeholder
      //  ELSE handle variables
      if(formulaToken.isNumeric()) {
        // Add the current number to the current operands stack
        operandsStacks.get(lvlKey).add(formulaToken);
      } else if(formulaToken == '(') {
        lvlCounter++;
        lvlKey = LVL_PRFX + String.valueOf(lvlCounter);
        // Add the LVL# to the current stack of operands
        operandsStacks.get(LVL_PRFX + String.valueOf(lvlCounter - 1)).add(lvlKey);
        // Add a new list for the next LVL# operands and operators
        operandsStacks.put(lvlKey, new List<String>());
        operatorsStacks.put(lvlKey, new List<String>());
      } else if(formulaToken == ')') {
        // Calculate the result of the current stacks of operands and operators
        Decimal calculatedValue = calculateStack(operandsStacks.get(lvlKey), operatorsStacks.get(lvlKey));
        // Move down a level, and set the key
        lvlCounter--;
        lvlKey = LVL_PRFX + String.valueOf(lvlCounter);
        // Find the variable in the list of operands, and replace it with the calculated value
        Integer indexToReplace = operandsStacks.get(lvlKey).indexOf(LVL_PRFX + String.valueOf(lvlCounter + 1));
        operandsStacks.get(lvlKey).set(indexToReplace, String.valueOf(calculatedValue));
      } else if(operatorPriority.containsKey(formulaToken)) {
        // Add the current operator to the current stack of operators
        operatorsStacks.get(lvlKey).add(formulaToken);
      } else {
        if(operandsMap != null && operandsMap.containsKey(formulaToken)) {
          operandsStacks.get(lvlKey).add(operandsMap.get(formulaToken));
        } else {
          calcResult.message = MSG_NO_VAR + formulaToken;
          calcResult.status = STS_ERR;
          break;
        }
      }
    }
    // Now that all parentheses are calculated, run the base calculation {
    if(calcResult.message == '') {
      lvlKey = LVL_PRFX + '0';
      calcResult.message = MSG_FRM_CLC;
      calcResult.status = STS_SCS;
      calcResult.value = calculateStack(operandsStacks.get(lvlKey), operatorsStacks.get(lvlKey));
    }
    // }
    return calcResult;
  }
  /** 
  * PURPOSE : Calculates a decimal value for a stack of operators and operands in prioritized order, i.e. PEMDAS
  * ARGS :
  *   operands  List<String>  List of numbers to be processed
  *   operators List<String>  List of operators to be processed [+ - * / ^]
  **/
  public Decimal calculateStack(List<String> operands, List<String> operators) {
    // Copy the lists to avoid mutating inputs
    List<String> operandStack = new List<String>(operands);
    List<String> operatorStack = new List<String>(operators);
    Integer priority = 2; //  Priority starts at 2, because parentheses [priority 3] have already been processed
    Integer index = 0;    //  Current index to check in the operator stack
    Decimal value = 0;    //  Holds the result of the currenct calculation
    Decimal result = 0;   //  Aggregate of all calculations
    while(operatorStack.size() > 0) {
      if(operatorPriority.get(operatorStack.get(index)) ==  priority) {
        value = performOperation(
          operatorStack.remove(index),
          Decimal.valueOf(operandStack.remove(index)),
          Decimal.valueOf(operandStack.remove(index))
        );
        // Aggregate the calculation results
        result += value;
        // IF all operands have been used, we are at the end of the loop, set the current value as the final result, and break
        //  ELSE IF the index is greater than the operand stack, insert the result into the stack
        //  ELSE add the value into the operand stack at the specified index
        if(operandStack.size() == 0) {
          result = value;
          break;
        } else if(index >= operandStack.size()) {
          operandStack.add(String.valueOf(value));
        } else {
          operandStack.add(index, String.valueOf(value));
        }
      }
      // IF the index is greater than the number of operators in the stack, check final operations
      //  ELSE IF the final operator has been checked; TODO: check if the operandStack check @ 116makes this redundant
      //  ELSE increment the index to check the next operator
      if(index >= operatorStack.size() - 1) {
        // IF the priority is 0, and the operator stack has a single element in it, the system has one final calculation to run
        //  ELSE if the priority is zero [implied that there are no operators left], set the final result to the current value
        //  ELSE the system has erroneously gotten a negative priority, and successfully looped; TODO: get rid of this
        //  ELSE reduce the priority, and set the priority one level down to start the next round of operator checks
        if(priority == 0 && operatorStack.size() == 1) {
          // Validate that the final operator is an operator (?)
          // TODO: validate all formula string members before this
          System.debug('final operator and operands');
        } else if(priority < 0) {
          result = value;
          break;
        } else {
          priority--;
        }
        index = 0;
      } else if(operatorStack.size() == 0) {
        result = value;
        break;
      } else {
        index++;
      }
    }

    return result;
  }
  /** 
  * PURPOSE : Calculates a decimal value for a stack of operators and operands
  * ARGS :
  *   operator  String  Operation to be processed
  *   operandA  Decimal First number in operation
  *   operandB  Decimal Second number in operation
  **/
  public Decimal performOperation(String operator, Decimal operandA, Decimal operandB) {
    Decimal result = 0.0;
    switch on operator {
      when '-' {
        result = operandA - operandB;
      }
      when '+' {
        result = operandA + operandB;
      }
      when '*' {
        result = operandA * operandB;
      }
      when '/' {
        result = operandA / operandB;
      }
      when '^' {
        result = operandA.pow(operandB.intValue());
      }
      when else {
        result = 0.0;
      }
    }
    return result;
  }

  public class FormulaResponse {
    public String message {get;set;}
    public String status {get;set;}
    public Decimal value {get;set;}

    public FormulaResponse() {
      message = '';
      status = '';
      value = 0.0;
    }
  }
}