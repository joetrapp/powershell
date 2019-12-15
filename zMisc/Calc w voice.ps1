clear
while ($true) {

write-host ("Ctrl + C to quit, or close Powershell window")
add-type -assemblyname system.speech
$voice = new-object system.speech.synthesis.speechsynthesizer

$voice.speakasync("Enter your first number")
$num1=read-host “Enter the first number”
$oper=read-host “Do you want to divide, add, multiply or subtract?[D,A,M,S]" 
$voice.speakasync("Enter your second number")
$num2=read-host “Enter the second number” 
$answ="ERROR: Unusable operator"

switch ($oper) {
    d {$answ=($num1 -as [int])/($num2 -as [int])}
    a {$answ=($num1 -as [int])+($num2 -as [int])}
    m {$answ=($num1 -as [int])*($num2 -as [int])}
    s {$answ=($num1 -as [int])-($num2 -as [int])}
    }
    $voice.speakasync(“Your answer is: $answ”)
	write-host ("$answ")
pause
}