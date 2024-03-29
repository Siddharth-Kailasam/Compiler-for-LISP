#Constant Folding and Propagation
import re
import operator
import sys

def get_operator_fn(op):
    return {
        '+' : operator.add,
        '-' : operator.sub,
        '*' : operator.mul,
        '/' : operator.floordiv,
        '%' : operator.mod,
        '^' : operator.xor,
        '>' : operator.gt,
        '<' : operator.lt,
        '>=' : operator.ge,
        '<=' : operator.le,
        '!' : operator.not_,
        '!=' : operator.ne
        }[op]

def eval_binary_expr(op1, oper, op2):
    op1,op2 = int(op1), int(op2)
    return get_operator_fn(oper)(op1, op2)
    
f = open(sys.argv[1],"r")
content = f.readlines()
constant_table=dict() #dictionary with key as variable and value as its constant
for i in range(len(content)):
	#content[i]=content[i].replace(" ","")
	if '=' in content[i] and not '==' in content[i] and not '<=' in content[i] and not '>=' in content[i] and not '!=' in content[i]: #Fix for case L1: t1=10
		Assignexpr = content[i].strip().split('=')
		variable=Assignexpr[0]
		if ':' in Assignexpr[0]:
			lhs=Assignexpr[0].replace(" ","").split(":")
			variable=lhs[1]
			#print constant_table
			constant_table={}

		var_list=re.split('\+|-|\*|/|%|(>=)|(<=)|(!=)|>|<', Assignexpr[1])
		var_list = [i for i in var_list if i != None]
		if len(var_list)==1: #pure assignment
			var_list[0]=var_list[0].replace(" ","")
			if var_list[0].isdigit():
				constant_table[variable]=var_list[0] #Case 2
			else:
				if var_list[0] in constant_table.keys():
					Assignexpr[1]=constant_table[var_list[0]] #Case 1
					Assignexpr[0]=Assignexpr[0].replace(" ","")
					constant_table[Assignexpr[0]]=constant_table[var_list[0]]
			print(str(Assignexpr[0])+'='+str(Assignexpr[1]))
		#RHS contains multiple operands - 4 types
		# Type 1 - op1 is digit op2 is digit
		# Type 2 - op1 is digit op2 is variable
		# Type 3 - op1 is variable op2 is digit
		# Type 4 - op1 is variable op2 is variable
		
		else: #Case 3
			constant_value="NOCHANGE"
			op1 = var_list[0]
			op2 = var_list[1]
			if '+' in content[i]:
				op='+'
			if '-' in content[i]:
				op='-'
			if '*' in content[i]:
				op='*'
			if '/' in content[i]:
				op='/'
			if '>' in content[i]:
				op='>'
			if '<' in content[i]:
				op='<'
			if '>=' in content[i]:
				op='>='
			if '<=' in content[i]:
				op='<='
			if '!' in content[i]:
				op='!'
			if '!=' in content[i]:
				op='!='
			op1=op1.replace(" ","")
			op2=op2.replace(" ","")
			if op1.isdigit() and op2.isdigit():
				constant_value=eval_binary_expr(op1, op, op2)
				Assignexpr[0]=Assignexpr[0].replace(" ","")
				constant_table[Assignexpr[0]]=constant_value
			if op1.isdigit() and op2.isdigit()!=1:
				if op2 in constant_table.keys():
					constant_value=eval_binary_expr(op1, op, constant_table[op2])
					Assignexpr[0]=Assignexpr[0].replace(" ","")
					constant_table[Assignexpr[0]]=constant_value
			if op1.isdigit()!=1 and op2.isdigit():
				if op1 in constant_table.keys():
					constant_value=eval_binary_expr(constant_table[op1], op, op2)
					Assignexpr[0]=Assignexpr[0].replace(" ","")
					constant_table[Assignexpr[0]]=constant_value
			if op1.isdigit()!=1 and op2.isdigit()!=1:
				if op1 in constant_table.keys():
					if op2 in constant_table.keys():
						constant_value=eval_binary_expr(constant_table[op1], op, constant_table[op2])
						Assignexpr[0]=Assignexpr[0].replace(" ","")
						constant_table[Assignexpr[0]]=constant_value
					else: #only op1 in constant table 
						Assignexpr[1]=str(constant_table[op1])+str(op)+str(op2)
				elif op2 in constant_table.keys():
					Assignexpr[1]=str(op1)+str(op)+str(constant_table[op2])
			if constant_value!="NOCHANGE":
				Assignexpr[1]=constant_value
			print(str(Assignexpr[0])+'='+str(Assignexpr[1]))
	elif ':' in content[i]:
		constant_table={}
		print(content[i])
	else:
		print(content[i])							
#print constant_table


#Algorithm approach
#1.For assigment operations, check if RHS is in constant table, if yes, then replace it's value with the constant.
#2.For arithmetic operations involving only constants on RHS, constant fold and store LHS as key, RHS as value.
#3.For arithmetic operations involving only variables on RHS, check if any of the operands already exists in the constant fold table, and replace it with its constant value.
#4.If the key is being redefined in following lines, then pop the key from the constant fold dictionary.

