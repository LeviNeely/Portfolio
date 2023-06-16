Welcome to the MathScript App!

Inside this folder, you will find all the source files that are used in the generating of this application.
This app is a simple math script interpreter that allows you to input various mathematical concepts, interpret them for their values, or print them
in a more visually pleasing way. 

Inside the documentation folder, you will find a pdf file titled "documentation.pdf" that documents the structure of the code as well as descriptions
for all the various methods for each class.

In order to run the program, simply download the MathScript.zip file and run the MathScript.app file found inside.

Below are the types of mathematical functions that MathScript is capable of handling:

Addition:

5 + 6

5 + -6

The above will result in interp values of 11 and -1 respectively.
Note: MathScript does not support subtraction, but handles negative values. In order to perform subtraction work, simply add a negative number. Thus:

2 - 1 : will not compute properly

2 + -1 : will result in the correct value of 1

Multiplication:

Utilizes the mathematical symbol "*" to denote multiplication.

5 * 5
5 * -5

The above will result in interp values of 25 and -25 respectively.
Note: MathScript does not support division, nor does it support fractions. Instances with the following syntax will not result in correct values:

5 / 5

5 * 0.2

5 * (1/5)

Variables:

Utilizes any alpha character as a variable. Without use of a let or func function, the variable will not interpret to any value.

5 + x
5 * x
x * y

All of the above examples will result in an error message.

Let:

MathScript utilizes underscores (_) in front of text-based functions to evaluation to meaning. The following are some examples that allow for intepretation:

_let x=5 _in x + 2

This would evaluate to 7.

_let x=5 _in (_let y = 2 _in x + y)

This would evaluate to 7 as well.

Booleans:

MathScript can evaluate boolean statements using the double equal signs.

3 == 3

3 == (1+1)

Will evaluate to _true and _false respectively.

Parenthesis:

MathScript supports the usage of parenthesis to indicate that what occurs inside parenthesis is evaluated before what happens outside of them

3 + 5 * 5

(3 + 5) * 5

Will result in 28 and 40 respectively.

If:

MathScript allows for if else statements using the following language:

_if 3==3 _then 55 _else _false

_if (3+3)==5 then 55 else _false

Will evaluate to 55 and _false respectively.

Func:

MathScripts allows for functions using the format:

_fun(variable) expression

The following are some examples:

_fun(x) x + 5

_let x = 5 _in _fun(x) x + 5

_let x = 5 _in _fun(x) _if x == 5 _then _true _else _false

Would evaluate to [function], 10, and _true respectively.

Please feel free to reach out to me at levijneely@gmail.com if you have further questions regarding this program.
