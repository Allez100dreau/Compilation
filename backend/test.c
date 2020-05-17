
goto LabelWhileCdt1;
LabelWhile0:
$3
LabelWhileCdt1:
if ($1) goto LabelWhile0;

$1
goto LabelForCdt3;
LabelFor2:
$5
$3
LabelForCdt3:
if ($2) goto LabelFor2;

goto LabelWhileCdt5;
LabelWhile4:
$3
LabelWhileCdt5:
if ($1) goto LabelWhile4;
